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
    return dword_be(0x003F210C) == 0x04
}

function check_if_in_multiplayer() {
    return dword_be(0x003F210C) == 0x03
}

function check_if_in_chapter_select() {
    return dword_be(0x3f211c) != 0x00 // If pointer points places we are in chapter select
}

function check_if_in_chapter_results() {
    return dword_be(0x3f1cfc) != 0x00 // See above
}

function results_rolled_in() {
    roll_state = ptr(dword_be(0x3f1cfc), [0x00], dword_be)
    return roll_state == 0x08 && prev(roll_state) != 0x08
}

function in_active_gameplay() {
    return dword_be(0x3f1478) != 0x00
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

//
//    function is_time_s_rank() {
//
//    }
//
//    function is_graviton_s_rank() {
//
//    }
//
    function get_bronze_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x1b)
    }

    function get_silver_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x13)
    }

    function get_gold_medal_count() {
        return bitcount(this._get_start_adr_raw() + 0x17)
    }

    function all_medals_collected() {
        this.get_bronze_medal_count() == 5 && this.get_silver_medal_count() == 3 && this.get_gold_medal_count() == 1
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

    function restarted_stage() {
        return get_stage_time() < prev(get_stage_time()) && get_stage_time() == 0
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

unused_hp_capsule = ItemCapsule(id=0x88)

rodea = RodeaObject()


function clear_chapter_logic(target_stage) {
    return !check_if_on_title_screen() && get_current_chapter() == target_stage &&
    (
        save_slot_0.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_0.is_chapter_beaten_first_time(target_stage)) ||
        save_slot_1.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_1.is_chapter_beaten_first_time(target_stage)) ||
        save_slot_2.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_2.is_chapter_beaten_first_time(target_stage))
    )
}

function clear_without_spiderweb_logic() {
    return !check_if_on_title_screen() && get_current_chapter() == 2 &&
    trigger_when(rodea.in_victory_pose() && prev(!rodea.in_victory_pose())) &&
    disable_when(rodea.stuck_in_spiderweb() && prev(!rodea.stuck_in_spiderweb()), until=rodea.restarted_stage())
}

function clear_bomber_attack_without_dmg_logic() {
    // TODO: objective id as check
    return !check_if_on_title_screen() && get_current_chapter() == 3 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0 &&
    // TODO: was it 5 hp?
    disable_when(get_ion_wave_hp() < prev(get_ion_wave_hp()), until=rodea.died()) &&
    // TODO: trigger when bomber defeated
    trigger_when(always_true())
}


achievement(
    title = "Debug Stuff in RA", points = 50,
    description = "Debug Away!",
    trigger =
        clear_chapter_logic(0)
)

CHAPTER_CLEAR_ACHIEVEMENT_NAMES = {
    5: "Proving Your Resolve",
    10: "10",
    15: "15",
    20: "20",
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

for current_chapter in range(5, 25, 5) {
    achievement(
    title = CHAPTER_CLEAR_ACHIEVEMENT_NAMES[current_chapter],
    points = CHAPTER_CLEAR_PTS_MAP[current_chapter],
    description = format("Complete Chapter {0}", current_chapter),
    trigger = 
        !check_if_on_title_screen() && get_current_chapter() == current_chapter &&
        (
            save_slot_0.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_0.is_chapter_beaten_first_time(current_chapter)) ||
            save_slot_1.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_1.is_chapter_beaten_first_time(current_chapter)) ||
            save_slot_2.is_chapter_beaten_first_time(current_chapter) && prev(!save_slot_2.is_chapter_beaten_first_time(current_chapter))
        )
    )
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

for current_chapter in range(5, 25, 5) {
    achievement(
    title = format("The Legacy of the {0}", MEDAL_COLLECTION_ACHIEVEMENT_NAMES[current_chapter]),
    points = MEDAL_COLLECTION_PTS_MAP[current_chapter],
    description = format("Collect all Legacy Medals in Chapters {0} through {1}", current_chapter - 4, current_chapter),
    trigger = 
        // TODO: Logic for medal collection check
        check_if_in_chapter_results() && always_false()
    )
}



rich_presence_conditional_display(check_if_on_title_screen(), "Rodea is on the Title Screen")

rich_presence_conditional_display(check_if_in_chapter_select(), "Rodea is on the way to the next destination")

// TODO: Prologue fallback
rich_presence_conditional_display(in_active_gameplay(), "Rodea is in Chapter {0} - {1} / 9999 Medals",
    rich_presence_value("Chapter", get_current_chapter()),
    rich_presence_value("Medals", 0)
)

rich_presence_display("Preparing to take flight!")
