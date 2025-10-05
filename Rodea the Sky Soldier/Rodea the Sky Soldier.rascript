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

function get_current_stage() {
    return dword_be(0x3f0a24)
}


FLIGHT_POINTER = dword_be(0xa186e8)
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

    function is_chapter_beaten(chapter) {
        return this.get_chapter(chapter).is_beaten()
    }
}

/*
[32-bit BE] Player data
+0x08

++0x50 = [32-bit BE] Current tool
..0xfffffff = None
..0x00000000 = Machine Gun Gear
..0x00000001 = Slide Gear
..0x00000002 = Lock-on Gear

++0x54 = [32-bit BE float] Energy in current tool (100.0 through 0.0)
++0x64 = [32-bit BE] Power Wing state (0x01 if none, 0x02 if collected)

++0x128 = [32-bit BE] Current state
..0x01 = Standing still
..0x02 = Idle animation
..0x03 = Crouching before flight
..0x05 = Walking
..0x07 through 0x09 = Dodge roll
..0x10 through 0x1a = Any form of flight
..0x23 = Charge Attack
..0x24 = Falling
..0x27 = Landing
..0x53 = Collected Power Wing
..0x72 = Hurt / Knockback

++0x350 = [32-bit BE float] Coordinate X
++0x354 = [32-bit BE float] Coordinate Y (height)
++0x358 = [32-bit BE float] Coordinate Z

++0x35c = [32-bit BE float] Model rotation X
++0x360 = [32-bit BE float] Model rotation Y
++0x364 = [32-bit BE float] Model rotation Z

++0x368 = [32-bit BE float] Movement input X
++0x36c = [32-bit BE float] Movement input Y
++0x370 = [32-bit BE float] Movement input Z
*/
class RodeaObject
{
    // function has_power_wing_plus() {
    //     PLAYER_DATA_POINTER
    // }

    current_gear = ptr(PLAYER_DATA_POINTER, [0x08, 0x50], dword_be)

    // Power Wing
    function has_power_wing_plus() {
        return ptr(PLAYER_DATA_POINTER, [0x08, 0x128], dword_be) == 0x00
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
        return ptr(FLIGHT_POINTER, [0xEF8], float_be)
    }

    function get_flight_target_y() {
        return ptr(FLIGHT_POINTER, [0xEFC], float_be)
    }

    function get_flight_target_z() {
        return ptr(FLIGHT_POINTER, [0xFD0], float_be)
    }

    function get_flight_speed() {
        return ptr(FLIGHT_POINTER, [0xFDC], float_be)
    }
}


save_slot_0 = SaveSlot(save_slot=0)
save_slot_1 = SaveSlot(save_slot=1)
save_slot_2 = SaveSlot(save_slot=2)



function clear_prologue_logic() {
    return !check_if_on_title_screen() &&
        get_current_stage() == 26 &&
        (
            save_slot_0.is_chapter_beaten(0) && prev(!save_slot_0.is_chapter_beaten(0)) ||
            save_slot_1.is_chapter_beaten(0) && prev(!save_slot_1.is_chapter_beaten(0)) ||
            save_slot_2.is_chapter_beaten(0) && prev(!save_slot_2.is_chapter_beaten(0))
        )
}


achievement(
    title = "Debug Stuff in RA", points = 50,
    description = "Debug Away!",
    trigger =
        clear_prologue_logic()
)





rich_presence_conditional_display(check_if_on_title_screen(), "Rodea is on the Title Screen")



rich_presence_display("Preparing to take flight!")