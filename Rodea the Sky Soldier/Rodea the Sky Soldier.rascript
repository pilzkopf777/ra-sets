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

function booting_up() {
    return dword_be(0x003f1790) == 0x00
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
    return byte(0x3f19e0) == 0x01
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
    return ptr(dword_be(0x003f2018), [0xfcc], dword_be)
}

function get_total_appeared_in_current_attempt_cp_21() {
    return ptr(dword_be(0x003f2018), [0xfc8], dword_be)
}

function get_amount_of_keycards_collected_cp_14() {
    return dword_be(0x004105B0)
}

function checkpoint_bell_hit() {
    return dword_be(0x003f19f4) > prev(dword_be(0x003f19f4))
}

// I hate this
S_RANK_TABLE = {
    1: {
        "time": 70000,
        "grav": 200
    },
    2: {
        "time": 200000,
        "grav": 520
    },
    3: {
        "time": 245000,
        "grav": 660
    },
    4: {
        "time": 235000,
        "grav": 480
    },
    5: {
        "time": 80000,
        "grav": 0 // Boss, no Grav
    },
    6: {
        "time": 255000,
        "grav": 680
    },
    7: {
        "time": 190000,
        "grav": 590
    },
    8: {
        "time": 300000,
        "grav": 460
    },
    9: {
        "time": 190000,
        "grav": 330
    },
    10: {
        "time": 125000,
        "grav": 0 // Boss
    },
    11: {
        "time": 180000,
        "grav": 530
    },
    12: {
        "time": 220000,
        "grav": 740
    },
    13: {
        "time": 145000,
        "grav": 280
    },
    14: {
        "time": 310000,
        "grav": 800
    },
    15: {
        "time": 135000,
        "grav": 0 // Boss
    },
    16: {
        "time": 200000,
        "grav": 570
    },
    17: {
        "time": 255000,
        "grav": 660
    },
    18: {
        "time": 220000,
        "grav": 510
    },
    19: {
        "time": 235000,
        "grav": 570
    },
    20: {
        "time": 155000,
        "grav": 0 // Boss
    },
    21: {
        "time": 320000,
        "grav": 840
    },
    22: {
        "time": 235000,
        "grav": 520
    },
    23: {
        "time": 300000,
        "grav": 600
    },
    24: {
        "time": 200000,
        "grav": 0 // Boss
    },
    25: {
        "time": 410000,
        "grav": 0 // Boss
    }
}


PLAYER_DATA_POINTER = dword_be(0x3f1478)

START_OF_SAVE_SLOT_1 = 0x00EDF3D0
ADR_S_RANK_TIME_1 = 0x3881dc
ADR_S_RANK_GRAV_1 = 0x00 // todo

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
        return this.get_best_time() <= S_RANK_TABLE[this.chapter]["time"]      
    }

    function is_graviton_s_rank() {
        // Not all chapters have graviton S ranks so for those the target is == 0 and should yield false
        if (S_RANK_TABLE[this.chapter]["grav"] == 0) {
            return false
        } else {
            return this.get_best_graviton_score() >= S_RANK_TABLE[this.chapter]["grav"]
        }
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

        for current_chapter in range(1, 25, 1) {
            sum = sum + this.get_chapter(current_chapter).get_amount_of_medals_collected()
        }

        return sum
    }

    function get_total_s_ranks_collected() {
        sum = 0
               

        for current_chapter_id in range(1, 25, 1) {
            current_chapter_obj = this.get_chapter(current_chapter_id)
                                                        
            if (current_chapter_obj.is_time_s_rank()) {
                sum = sum + 1
            }
            
            if (current_chapter_obj.is_graviton_s_rank()) {
                sum = sum + 1
            }
        }
        
        return sum        
    }
}

INTERACTIVE_ITEM_BASE = dword_be(0x003f1818) & 0x1fffffff

class ItemCapsule
{
    id = 0

    function _get_state_adr() {
        val = INTERACTIVE_ITEM_BASE + 0x10000
        offset = this.id * 0x0c // item id array
        val = val + offset
        val = val - 0x57fc // fixed calc in assembler
        val = val + 0x04 // offset for object
        return val
    }

    function capsule_opened() {
        return dword_be(this._get_state_adr()) == 0x01
    }

    function capsule_unopened() {
        return dword_be(this._get_state_adr()) == 0x00
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
        return ptr(dword_be(0x3f1638), [0xc6], dword_be)
    }

    function get_chain() {
        return ptr(dword_be(0x3f1638), [0xd0], dword_be)
    }

    // State
    function stuck_in_spiderweb() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x6c
    }

    // Be careful, not all stages end on the victory pose (e.g. chapter 8)
    function in_victory_pose() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x4a
    }

    function on_wire_cable() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x3d
    }

    function in_fps_mode() {
        return byte(0x00a193d0) == 0x01
    }

    // State via statistics
    function has_landed() {
        return dword_be(0xf58088) > prev(dword_be(0xf58088))
    }

    function started_flight() {
        return dword_be(0xf58084) > prev(dword_be(0xf58084))
    }

    function jumped_off_wall() {
        return dword_be(0xf5808c) > prev(dword_be(0xf5808c))
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
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x354], float_be)
    }

    function get_pos_z() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x358], float_be)
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
    return get_current_chapter() == 3 && get_top_objective_id() == 5 && get_bottom_objective_id() == 6 &&
    disable_when(get_ion_wave_hp() < prev(get_ion_wave_hp()), until=rodea.died()) &&
    trigger_when(rodea.in_victory_pose() && prev(!rodea.in_victory_pose()))
}

function escape_bomb_logic() {
    // check objective ids
    return get_current_chapter() == 3 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0 &&
    disable_when(get_bomb_time_left() < 30.0 && prev(get_bomb_time_left()) >= 30.0, until=rodea.died()) &&
    // Timer pauses upon explosion and when stopped (todo: check if also during pause menu)
    // Bomb timer runs into negative
    trigger_when(bomb_timer_stopped() && get_bomb_time_left() > 0.0)
}

function clear_all_rolling_enemies_logic() {
    chain_target = 6
    return get_current_chapter() == 9 && get_top_objective_id() == 2 &&
    disable_when(rodea.get_chain() < prev(rodea.get_chain()), until=rodea.died()) &&
    trigger_when(rodea.get_chain() == chain_target && prev(rodea.get_chain()) == chain_target - 1)
}

function spiderweb_climb_cp_11() {
    trigger_loc = rodea.get_pos_z() < -358.0 && prev(rodea.get_pos_z()) > -358.0 && rodea.get_pos_y() > 570.0

    return get_current_chapter() == 11 &&
    (never(rodea.died())) &&
    once(rodea.get_pos_z() > -363.0 && prev(rodea.get_pos_z()) < -363.0 && rodea.on_wire_cable()) &&
    trigger_when(rodea.get_chain() == 9 && trigger_loc) &&
    disable_when(rodea.get_chain() < prev(rodea.get_chain()) || trigger_loc && rodea.get_chain() != 9, until=rodea.died())
}

//function key_cards_without_floor_cp_14_logic() {
//    return get_current_chapter() == 14 && get_top_objective_id() == 1 && get_bottom_objective_id() == 2 &&
//    trigger_when(get_amount_of_keycards_collected_cp_14() == 3 && prev(get_amount_of_keycards_collected_cp_14()) == 2) &&
//    (
//        disable_when(rodea.has_landed(), until=rodea.died() || get_top_objective_id() != 1 && get_bottom_objective_id() != 2)
//    ) &&
//    (
//        disable_when(checkpoint_bell_hit(), until=restarted_stage())
//    )
//}

function topdown_gun_section_logic() {
    return get_current_chapter() == 21 && get_kills_in_current_attempt_cp_21() == 196 && timer_frozen_due_to_cutscene() && prev(!timer_frozen_due_to_cutscene()) 
}

achievement(
title = "Getting Around It with Yuji Naka",
points = 4,
description = "In Chapter 11, instead of the shortcut, take the long route around the spiderwebs and reach the top with a Chain of 9",
trigger = 
    spiderweb_climb_cp_11()
)

achievement(
title = "Stop, Do, and Rolls",
points = 5,
description = "In Chapter 9, defeat the enemies during the ambush in a single chain",
trigger = 
    clear_all_rolling_enemies_logic()
)

achievement(
title = "The One That Got Away",
points = 3,
description = "In Chapter 6, open the capsule with the Heart item",
trigger = 
    !check_if_on_title_screen() && get_current_chapter() == 6 && unused_hp_capsule.capsule_opened() && prev(unused_hp_capsule.capsule_unopened())
)

achievement(
title = "Chain Reaction",
points = 3,
description = "Reach a Chain of 20",
trigger = 
    !check_if_on_title_screen() && rodea.get_chain() == 20 && prev(rodea.get_chain() < 20)
)

achievement(
title = "Sentient Security System",
points = 4,
description = "In Chapter 3, destroy the Bomber without the Ion Wave taking any damage",
trigger = 
    clear_bomber_attack_without_dmg_logic()
)

//achievement(
//title = "Hit the Ground Running",
//points = 4,
//description = "In Chapter 14, collect the key cards without landing on the floor or ringing any checkpoint bells",
//trigger = 
//    key_cards_without_floor_cp_14_logic()
//)

//achievement(
//title = "The Last Bomb",
//points = 4,
//description = "In Chapter 19, complete the chapter before the bomb timer reaches 1:40:00",
//trigger = 
//    key_cards_without_floor_cp_14_logic()
//)

achievement(
title = "Top Machine Gun",
points = 10,
description = "In Chapter 21, defeat all enemies and reach a 100% KO rate",
trigger = 
    topdown_gun_section_logic()
)

achievement(
title = "Immersive Experience",
points = 1,
description = "Complete Chapter 1 while staying in FPS mode, entered by pressing the 2 button after beating the game",
trigger = 
    trigger_when(rodea.in_victory_pose() && prev(!rodea.in_victory_pose())) &&
    // 73.0 is just a location at the start of the map; if the player moves too far without FPS mode the achievement will be disabled
    disable_when(!rodea.in_fps_mode() && rodea.get_pos_z() < 73.0, until=restarted_stage() || rodea.get_pos_z() >= 73.0) &&
    !check_if_on_title_screen() && rodea.in_fps_mode() && get_current_chapter() == 1
)

achievement(
title = "Spare Parts",
points = 2,
description = "Earn an extra life",
trigger = 
    !check_if_on_title_screen() && rodea.get_lives() > prev(rodea.get_lives())
)

CHAPTER_CLEAR_ACHIEVEMENT_NAMES = {
    5: "Proving Your Resolve",
    10: "Lingering Memories",
    15: "Burning Desire",
    20: "Leap of Faith",
    25: "May These Feelings Reach the Future"
}

CHAPTER_CLEAR_ACHIEVEMENT_DESC = {
    5: "Defeat Deogordam and destroy the Wind Chronos Tower",
    10: "Defeat Belhemous and destroy the Sand Chronos Tower",
    15: "Defeat Zolendark and destroy the Fire Chronos Tower",
    20: "Defeat Odeon and destroy the Ice Chronos Tower",
    25: "Save Garuda"
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

function medal_collection_logic(target) {
    collected_slot_0 = save_slot_0.get_total_medals_collected()
    collected_slot_1 = save_slot_1.get_total_medals_collected()
    collected_slot_2 = save_slot_2.get_total_medals_collected()

    return !check_if_on_title_screen() && check_if_in_chapter_results() &&
    (
        get_active_save_slot() == 0 && measured(collected_slot_0 == target) && prev(collected_slot_0 != target) ||
        get_active_save_slot() == 1 && measured(collected_slot_1 == target) && prev(collected_slot_1 != target) ||
        get_active_save_slot() == 2 && measured(collected_slot_2 == target) && prev(collected_slot_2 != target)
    )
}

function s_rank_collection_logic(target) {
    collected_slot_0 = save_slot_0.get_total_s_ranks_collected()
    collected_slot_1 = save_slot_1.get_total_s_ranks_collected()
    collected_slot_2 = save_slot_2.get_total_s_ranks_collected()

    return !check_if_on_title_screen() && check_if_in_chapter_results() &&
    (
        get_active_save_slot() == 0 && measured(collected_slot_0 == target) && prev(collected_slot_0 != target) ||
        get_active_save_slot() == 1 && measured(collected_slot_1 == target) && prev(collected_slot_1 != target) ||
        get_active_save_slot() == 2 && measured(collected_slot_2 == target) && prev(collected_slot_2 != target)  
    )
}

achievement(
title = "More than Just an Order",
points = 1,
type = "progression",
description = "Make a Promise",
trigger = 
    !check_if_on_title_screen() && prev(get_current_chapter()) == 0 &&
    (
    once(get_active_save_slot() == 0 && save_slot_0.is_chapter_beaten_first_time(0) && prev(!save_slot_0.is_chapter_beaten_first_time(0)))
    ) ||
    (
    once(get_active_save_slot() == 1 && save_slot_1.is_chapter_beaten_first_time(0) && prev(!save_slot_1.is_chapter_beaten_first_time(0)))
    ) ||
    (
    once(get_active_save_slot() == 2 && save_slot_2.is_chapter_beaten_first_time(0) && prev(!save_slot_2.is_chapter_beaten_first_time(0)))
    ) &&
    never(check_if_in_chapter_select() && prev(!check_if_in_chapter_select()))
)

for current_chapter in range(5, 25, 5) {
    achievement(
    title = CHAPTER_CLEAR_ACHIEVEMENT_NAMES[current_chapter],
    points = CHAPTER_CLEAR_PTS_MAP[current_chapter],
    type = get_progression_type(current_chapter),
    description = CHAPTER_CLEAR_ACHIEVEMENT_DESC[current_chapter],
    trigger = 
        !check_if_on_title_screen() && prev(get_current_chapter()) == current_chapter && check_if_in_chapter_results() &&
        (
        once(get_active_save_slot() == 0 && save_slot_0.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_0.is_chapter_beaten_first_time(current_chapter)))
        ) ||
        (
        once(get_active_save_slot() == 1 && save_slot_1.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_1.is_chapter_beaten_first_time(current_chapter)))
        ) ||
        (
        once(get_active_save_slot() == 2 && save_slot_2.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_2.is_chapter_beaten_first_time(current_chapter)))
        ) &&
        never(check_if_in_chapter_select() && prev(!check_if_in_chapter_select()))
    )
}

MEDAL_TARGET_AMOUNTS = [10, 50, 100, 171]
MEDAL_TARGET_PTS = [5, 10, 25, 50]
MEDAL_TARGET_PREFIXES = ["Apprentice", "Dedicated", "Veteran", "Eternal"]

for current in range(0, 3, 1) {
    achievement(
    title = format("{0} Archivist", MEDAL_TARGET_PREFIXES[current]),
    points = MEDAL_TARGET_PTS[current],
    description = format("Collect {0} Legacy Medals", MEDAL_TARGET_AMOUNTS[current]),
    trigger = 
        medal_collection_logic(MEDAL_TARGET_AMOUNTS[current])
    )
}

S_RANK_TARGET_AMOUNTS = [5, 15, 30, 44]
S_RANK_TARGET_PTS = [5, 10, 25, 50]
S_RANK_TARGET_PREFIXES = ["Apprentice", "Dedicated", "Veteran", "Eternal"]

for current in range(0, 3, 1) {
    achievement(
    title = format("{0} Soldier", MEDAL_TARGET_PREFIXES[current]),
    points = MEDAL_TARGET_PTS[current],
    description = format("Earn {0} S Ranks", S_RANK_TARGET_AMOUNTS[current]),
    trigger = 
        s_rank_collection_logic(S_RANK_TARGET_AMOUNTS[current])
    )
}

rich_presence_conditional_display(booting_up() || check_if_on_title_screen(), "On the Title Screen")

rich_presence_conditional_display(check_if_in_multiplayer(), "Taking to the skies in Multiplayer mode")

for current_save_slot in range(0, 2, 1) {

    rich_presence_conditional_display((check_if_in_chapter_select() && get_active_save_slot() == current_save_slot) || (get_current_chapter() == 0xffffffff && get_active_save_slot() == current_save_slot),
        "Choosing the next destination • {0} / 171 Legacy Medals",
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )

    rich_presence_conditional_display(get_active_save_slot() == current_save_slot && get_current_chapter() == 0,
        "In the Prologue • {1} / 171 Legacy Medals",
        rich_presence_value("Chapter", get_current_chapter()),
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )

    rich_presence_conditional_display(get_active_save_slot() == current_save_slot,
        "In Chapter {0} • {1} / 171 Legacy Medals",
        rich_presence_value("Chapter", get_current_chapter()),
        rich_presence_value("Medals", SAVE_SLOT_OBJ_LIST[current_save_slot].get_total_medals_collected())
    )
}


rich_presence_display("Preparing to take flight!")

