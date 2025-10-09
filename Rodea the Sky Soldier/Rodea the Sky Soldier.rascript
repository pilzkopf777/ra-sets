// Rodea the Sky Soldier
// #ID = 34706

// Helper function taken from Souzooka - thanks!
WII_GAME_MASK = 0x1fffffff

function ptr(base, offsets, accessor=dword_be)
{
    val = base
    // Cool masking action in a seperate line
    val = val & WII_GAME_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            // Result also needs to 
            val = val & WII_GAME_MASK
        }
    }
    
    return val
}

function get_active_save_slot() {
    return dword_be(0x003F210C)
}

function check_if_on_title_screen() {
    return byte(0x003f2108) == 1
}

function check_if_in_multiplayer() {
    return dword_be(0x003F210C) == 0x03
}

function check_if_in_chapter_select() {
    // If pointer points places we are in chapter select
    return byte(0x003f2120) == 1
}

function check_if_in_chapter_results() {
    return dword_be(0x3f1cfc) != 0x00 // See above
}

function results_rolled_in() {
    roll_state = ptr(dword_be(0x3f1cfc), [0x00], dword_be)
    return roll_state == 0x08 && prev(roll_state) != 0x08
}

function get_current_chapter() {
    return dword_be(0x3f0a28)
}

function check_if_save_file_loaded() {
    return dword_be(0x3f210c) <= 2
}

function in_graviton_door() {
    return dword_be(0x3f1448) == 0x01
}

function get_stage_time() {
    return dword_be(0x3f19e4)
}

function get_bomb_time_left() {
    return ptr(dword_be(0x3f19dc), [0xAF0], float_be)
}

function bomb_timer_stopped() {
    return ptr(dword_be(0x3f19dc), [0xAEC], dword_be)
}

function timer_frozen_due_to_cutscene() {
    return dword_be(0x3f19e0) == 0x01
}

function get_boss_hp() {
    return ptr(dword_be(0x3f1d00), [0x04], dword_be)
}

function get_ion_wave_hp() {
    return dword_be(0x3efa94)
}

function get_top_objective_id() {
    return ptr(dword_be(0x3f19dc), [0x410], dword_be)
}

function get_bottom_objective_id() {
    return ptr(dword_be(0x3f19dc), [0x414], dword_be)
}

function restarted_stage() {
    return get_stage_time() < prev(get_stage_time()) && get_stage_time() == 0
}

function get_kills_in_current_attempt_cp_21() {
    return ptr(dword_be(0x003f2018), [0xffc], dword_be)
}

// S_RANK_GOALS[0]["grav"] == ...
S_RANK_GOALS = {
    0:
        {
            "time": 0,
            "grav": 0
        },
    1:
        {
            "time": 0,
            "grav": 0
        }
}

PLAYER_DATA_POINTER = dword_be(0x3f1478)

START_OF_SAVE_SLOT_1 = 0x00EDF3D0

class ChapterSaveData
{
    save_slot = 0
    chapter = 0

    function _get_start_adr_raw() {
        SLOT_BASE = START_OF_SAVE_SLOT_1 + (this.save_slot * 0x1400)
        CHAPTER_RAW_ADR = SLOT_BASE + 0x100 + (this.chapter * 0x40)
        return CHAPTER_RAW_ADR
    }

    function is_unlocked() {
        return dword_be(this._get_start_adr_raw() + 0x00) >= 0x02
    }

    function is_beaten() {
        return dword_be(this._get_start_adr_raw() + 0x00) == 0x03
    }

    function get_best_time() {
        return dword_be(this._get_start_adr_raw() + 0x04)
    }

    function get_best_graviton_score() {
        return dword_be(this._get_start_adr_raw() + 0x08)
    }


    function is_time_s_rank() {
        return true
    }

    function is_graviton_s_rank() {
        return true    
    }

    function get_bronze_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x1b)
    }

    function get_silver_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x13)
    }

    function get_gold_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x17)
    }

    // function all_medals_collected() {
    //     if (this.chapter == 0 || this.chapter == 4 || this.chapter == 9 || this.chapter == 14 || this.chapter == 19 || this.chapter == 24 || this.chapter == 25) {
    //         return always_true()
    //     } else {
    //         return this.get_bronze_medal_count() == 5 && this.get_silver_medal_count() == 3 && this.get_gold_medal_count() == 1
    //     }
    // }

    function get_amount_of_medals_collected() {
        return this.get_bronze_medal_count() + this.get_silver_medal_count() + this.get_gold_medal_count()
    }

}

class SaveSlot
{
    save_slot = 0

    function get_chapter(chapter) {
        return ChapterSaveData(save_slot=this.save_slot, chapter=chapter)
    }

    function is_chapter_beaten_first_time(chapter) {
        return this.get_chapter(chapter).is_beaten()
    }

    function get_total_medals_collected() {
        sum = 0
        for current_chapter in range(0, 25, 1) {
            sum = sum + this.get_chapter(current_chapter).get_amount_of_medals_collected()
        }
        return sum
    }

    function earned_all_s_rank_on_page(first_chapter) {
        if (first_chapter == 21) {
            target = 8
        } else {
            target = 9
        }

        //collected = this.get_chapter(first_chapter + 0).is_graviton_s_rank() + this.get_chapter(first_chapter + 0).is_time_s_rank() + 
        //            this.get_chapter(first_chapter + 1).is_graviton_s_rank() + this.get_chapter(first_chapter + 1).is_time_s_rank() + 
        //            this.get_chapter(first_chapter + 2).is_graviton_s_rank() + this.get_chapter(first_chapter + 2).is_time_s_rank() + 
        //            this.get_chapter(first_chapter + 3).is_graviton_s_rank() + this.get_chapter(first_chapter + 3).is_time_s_rank() + 
        //            this.get_chapter(first_chapter + 4).is_graviton_s_rank() + this.get_chapter(first_chapter + 4).is_time_s_rank()
        //            
        //return measured(collected == target)
        return true
    }

    function collected_all_medals_on_page(first_chapter) {
        //return this.get_chapter(first_chapter).all_medals_collected() && // eg 5
        //       this.get_chapter(first_chapter + 1).all_medals_collected() &&  // eg 6
        //       this.get_chapter(first_chapter + 2).all_medals_collected() &&  // eg 7
        //       this.get_chapter(first_chapter + 3).all_medals_collected() &&  // eg 8
        //       this.get_chapter(first_chapter + 4).all_medals_collected() // 9

        if (first_chapter == 21) {
            target = 27
        } else {
            target = 36
        }
        collected = this.get_chapter(first_chapter + 0).get_amount_of_medals_collected() + 
                    this.get_chapter(first_chapter + 1).get_amount_of_medals_collected() +
                    this.get_chapter(first_chapter + 2).get_amount_of_medals_collected() +
                    this.get_chapter(first_chapter + 3).get_amount_of_medals_collected() +
                    this.get_chapter(first_chapter + 4).get_amount_of_medals_collected()
                    
        return measured(collected == target)
    }
}

INTERACTIVE_ITEM_BASE = 0x3f1818

class ItemCapsule
{
    id = 0

    function _get_state_adr() {
        val = INTERACTIVE_ITEM_BASE + 0x10000
        offset = this.id * 0x0c
        val = val + offset
        val = val - 0x57fc
        return val
    }

    function capsule_opened() {
        return ptr(dword_be(this._get_state_adr()), [0x04], dword_be) == 0x01
    }

    function capsule_unopened() {
        return ptr(dword_be(this._get_state_adr()), [0x04], dword_be) == 0x00
    }
}

class RodeaObject
{
    current_gear = ptr(PLAYER_DATA_POINTER, [0x08, 0x50], dword_be)

    // HP, Lives
    function get_hp() {
        // 0 = no wing, 1 = with wing, 2 = powered up
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x64], dword_be)
    }

    function has_shield() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x68], dword_be) == 0x01
    }

    function get_lives() {
        return dword_be(0xf58010)
    }

    function died() {
        // Timer resets to last checkpoint split upon death
        return get_stage_time() < prev(get_stage_time())
    }

    // Gravitons and Chain
    function get_gravitons() {
        return ptr(dword_be(0x3f1638), [0xc6], word_be)
    }

    function get_chain() {
        return ptr(dword_be(0x3f1638), [0xd0], word_be)
    }

    // State
    function stuck_in_spiderweb() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x6c
    }

    function in_victory_pose() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x4b
    }

    function on_wire_cable() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x3d
    }

    // Gears
    function has_gear() {
        return this.current_gear != 0xffffffff
    }

    function has_machine_gun_gear() {
        return this.current_gear == 0x00
    }

    function has_slide_gear() {
        return this.current_gear == 0x01
    }

    function has_lock_on_gear() {
        return this.current_gear == 0x02
    }

    function get_gear_energy() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x54], float_be)
    }

    // Coordinates
    function get_pos_x() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x350], float_be)
    }

    function get_pos_y() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x350], float_be)
    }

    function get_pos_z() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x350], float_be)
    }

    // Flight
    function get_flight_target_x() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0xEF8], float_be)
    }

    function get_flight_target_y() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0xEFC], float_be)
    }

    function get_flight_target_z() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0xFD0], float_be)
    }

    function get_flight_speed() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0xFDC], float_be)
    }
}


save_slot_0 = SaveSlot(save_slot=0)
save_slot_1 = SaveSlot(save_slot=1)
save_slot_2 = SaveSlot(save_slot=2)

SAVE_SLOT_OBJ_LIST = [save_slot_0, save_slot_1, save_slot_2]

unused_hp_capsule = ItemCapsule(id=0x88)

rodea = RodeaObject()


function clear_without_spiderweb_logic() {
    return get_current_chapter() == 2 &&
    trigger_when(rodea.in_victory_pose() && prev(!rodea.in_victory_pose())) &&
    disable_when(rodea.stuck_in_spiderweb() && prev(!rodea.stuck_in_spiderweb()), until=restarted_stage())
}

function clear_bomber_attack_without_dmg_logic() {
    // TODO: objective id as check
    return get_current_chapter() == 3 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0 &&
    // TODO: was it 5 hp?
    disable_when(get_ion_wave_hp() < prev(get_ion_wave_hp()), until=rodea.died()) &&
    trigger_when(rodea.in_victory_pose() && prev(!rodea.in_victory_pose()))
}

function escape_bomb_logic() {
    // check objective ids
    return get_current_chapter() == 3 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0 &&
    disable_when(get_bomb_time_left() < 30.0 && prev(get_bomb_time_left()) >= 30.0) &&
    // Timer pauses upon explosion and when stopped (todo: check if also during pause menu)
    // Bomb timer runs into negative
    trigger_when(bomb_timer_stopped() && get_bomb_time_left() > 0.0)
}

function clear_all_rolling_enemies_logic() {
    // TODO: was it 6?
    chain_target = 6
    // TODO check values
    return get_current_chapter() == 6 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0 &&
    disable_when(rodea.get_chain() < prev(rodea.get_chain())) &&
    trigger_when(rodea.get_chain() == chain_target && prev(rodea.get_chain()) == chain_target - 1)
}

function spiderweb_climb_cp_10() {
    // x -2699 y 390 z -355 to
    // x -2699 y 387 z -337 for start
    trigger_loc = rodea.get_pos_z() == -358.0 && prev(rodea.get_pos_z() != -358.0) && rodea.get_pos_y() > 570.0

    return get_current_chapter() == 9 &&
    once(rodea.get_pos_y() == 390.0 && prev(rodea.get_pos_y() != 390.0) && rodea.get_pos_z() == -355.0 && prev(rodea.get_pos_z() != -355.0) && rodea.on_wire_cable()) &&
    trigger_when(rodea.get_chain() == 9 && trigger_loc) &&
    disable_when(rodea.get_chain() < prev(rodea.get_chain()) || trigger_loc && rodea.get_chain() != 9, until=rodea.died())
}

achievement(
title = "Getting Around It with Yūji Naka",
points = 4,
description = "In Chapter 11, instead of the shortcut, take the long route around the spiderwebs and reach the top with a Chain of 9",
trigger = 
    spiderweb_climb_cp_10()
)

achievement(
title = "Stop, Do, and Rolls",
points = 4,
description = "In Chapter 9, defeat the enemies during the ambush in a single chain",
trigger = 
    clear_all_rolling_enemies_logic()
)

achievement(
title = "The One That Got Away",
points = 2,
description = "In Chapter 6, open the capsule with the Heart item",
trigger = 
    !check_if_on_title_screen() && get_current_chapter() == 6 && unused_hp_capsule.capsule_opened() && prev(unused_hp_capsule.capsule_unopened())
)

achievement(
title = "Chain Reaction",
points = 2,
description = "In Chapter 4, reach a Chain of 30",
trigger = 
    !check_if_on_title_screen() && get_current_chapter() == 6 && rodea.get_chain() == 30 && prev(rodea.get_chain() < 30)
)

achievement(
title = "Sentient Security System",
points = 3,
description = "In Chapter 3, destroy the Bomber without the Ion Wave taking any damage",
trigger = 
    clear_bomber_attack_without_dmg_logic()
)

CHAPTER_CLEAR_ACHIEVEMENT_NAMES = {
    5: "Proving Your Resolve",
    10: "Lingering Memories",
    15: "Burning Desire",
    20: "Leap of Faith",
    25: "May These Feelings Reach the Future"
}

CHAPTER_CLEAR_PTS_MAP = {
    0: 1,
    5: 5,
    10: 10,
    15: 10,
    20: 10,
    25: 25
}

function get_progression_type(current_chapter) {
    if (current_chapter == 25) {
        return "win_condition"
    } else {
        return "progression"
    }
}

MEDAL_COLLECTION_ACHIEVEMENT_NAMES = {
    5: "Grasslands",
    10: "Desert",
    15: "Volcano",
    20: "Snowbank",
    25: "Naga Empire"
}

MEDAL_COLLECTION_PTS_MAP = {
    5: 10,
    10: 10,
    15: 10,
    20: 25,
    25: 25
}

CHAPTERS_WITH_MEDALS = {
    5: 4,
    10: 4,
    15: 4,
    20: 4,
    25: 3
}

function medal_collection_logic(first_chapter) {
    return !check_if_on_title_screen() && check_if_in_chapter_results() &&
    (
        // TODO: this is a measured, is this fine without delta?
        get_active_save_slot() == 0 && save_slot_0.collected_all_medals_on_page(first_chapter) ||
        get_active_save_slot() == 1 && save_slot_1.collected_all_medals_on_page(first_chapter) ||
        get_active_save_slot() == 2 && save_slot_2.collected_all_medals_on_page(first_chapter)     
    )
}

function s_rank_collection_logic(first_chapter) {
    return !check_if_on_title_screen() && check_if_in_chapter_results() &&
    (
        // TODO: this is a measured, is this fine without delta?
        get_active_save_slot() == 0 && save_slot_0.earned_all_s_rank_on_page(first_chapter) ||
        get_active_save_slot() == 1 && save_slot_1.earned_all_s_rank_on_page(first_chapter) ||
        get_active_save_slot() == 2 && save_slot_2.earned_all_s_rank_on_page(first_chapter)     
    )
}

achievement(
title = "More than Just an Order",
points = 1,
type = "progression",
description = "Complete the Prologue",
trigger = 
    !check_if_on_title_screen() && prev(get_current_chapter()) == 0 &&
    (
        get_active_save_slot() == 0 && save_slot_0.is_chapter_beaten_first_time(0) && prev(!save_slot_0.is_chapter_beaten_first_time(0)) ||
        get_active_save_slot() == 1 && save_slot_1.is_chapter_beaten_first_time(0) && prev(!save_slot_1.is_chapter_beaten_first_time(0)) ||
        get_active_save_slot() == 2 && save_slot_2.is_chapter_beaten_first_time(0) && prev(!save_slot_2.is_chapter_beaten_first_time(0))
    )
)

for current_chapter in range(5, 25, 5) {
    achievement(
    title = CHAPTER_CLEAR_ACHIEVEMENT_NAMES[current_chapter],
    points = CHAPTER_CLEAR_PTS_MAP[current_chapter],
    type = get_progression_type(current_chapter),
    description = format("Complete Chapter {0}", current_chapter),
    trigger = 
    // TODO: All of these need to earn a hit once the chapter clear is recorded and reset the hit once you enter the chapter select
    // Then, trigger the achievement the moment you enter the results screen
        !check_if_on_title_screen() && prev(get_current_chapter()) == current_chapter && check_if_in_chapter_results() &&
        (
            get_active_save_slot() == 0 && save_slot_0.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_0.is_chapter_beaten_first_time(current_chapter)) ||
            get_active_save_slot() == 1 && save_slot_1.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_1.is_chapter_beaten_first_time(current_chapter)) ||
            get_active_save_slot() == 2 && save_slot_2.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_2.is_chapter_beaten_first_time(current_chapter))
        )
    )

    achievement(
    title = format("The Legacy of the {0}", MEDAL_COLLECTION_ACHIEVEMENT_NAMES[current_chapter]),
    points = MEDAL_COLLECTION_PTS_MAP[current_chapter],
    description = format("Collect all Legacy Medals in Chapters {0} through {1}", current_chapter - 4, current_chapter - 5 + CHAPTERS_WITH_MEDALS[current_chapter]),
    trigger = 
        medal_collection_logic(first_chapter=current_chapter - 4)
    )

    achievement(
    title = format("Touring the {0}", MEDAL_COLLECTION_ACHIEVEMENT_NAMES[current_chapter]),
    points = MEDAL_COLLECTION_PTS_MAP[current_chapter],
    description = format("Earn all S Ranks in Chapters {0} through {1}", current_chapter - 4, current_chapter - 5 + CHAPTERS_WITH_MEDALS[current_chapter]),
    trigger = 
        s_rank_collection_logic(first_chapter=current_chapter - 4)
    )
}

rich_presence_conditional_display(check_if_on_title_screen(), "On the Title Screen")

rich_presence_conditional_display(check_if_in_multiplayer(), "Taking to the skies in Multiplayer mode")

for current_save_slot in range(0, 2, 1) {

    rich_presence_conditional_display((check_if_in_chapter_select() && get_active_save_slot() == current_save_slot) || (get_current_chapter() == 0xffffffff && get_active_save_slot() == current_save_slot), "Choosing the next destination • {0} / 108 Legacy Medals",
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )

    rich_presence_conditional_display(get_active_save_slot() == current_save_slot && get_current_chapter() == 0,
        "In the Prologue • {1} / 180 Legacy Medals",
        rich_presence_value("Chapter", get_current_chapter()),
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )

    rich_presence_conditional_display(get_active_save_slot() == current_save_slot,
        "In Chapter {0} • {1} / 180 Legacy Medals",
        rich_presence_value("Chapter", get_current_chapter()),
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )
}


rich_presence_display("Preparing to take flight!")
