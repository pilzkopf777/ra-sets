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
    val_1 = dword_be(0x3f0a24)
    val_2 = dword_be(0x3f0a28)

    // Same ID = Regular stage
    if (val_1 == val_2) {
        return val_1
    }
    // Special rule for prologue in new save file
    else if (val_1 == 0x1a && val_2 == 0x00) {
        return 0x00
    }
    // Chapter select
    else {
        return 0xFF
    }
}

// TODO: check if stage restarted..?
function check_if_respawned_or_restarted() {
    return 0
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

    function capsule_opened {
        return ptr(dword_be(this._get_state_adr()), [0x04], dword_be) == 0x01
    }

    function capsule_unopened {
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

unused_hp_capsule = ItemCapsule(id=0x88)

rodea = RodeaObject()


function clear_chapter_logic(target_stage) {
    return !check_if_on_title_screen() && get_current_stage() == target_stage &&
    (
        save_slot_0.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_0.is_chapter_beaten_first_time(target_stage)) ||
        save_slot_1.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_1.is_chapter_beaten_first_time(target_stage)) ||
        save_slot_2.is_chapter_beaten_first_time(target_stage) && prev(!save_slot_2.is_chapter_beaten_first_time(target_stage))
    )
}

function clear_without_spiderweb_logic() {
    return !check_if_on_title_screen() && get_current_stage() == 2 &&
    // todo: also check if goal reached
    trigger_when(always_true()) &&
    never(rodea.stuck_in_spiderweb() && prev(!rodea.stuck_in_spiderweb()))
}

function clear_bomber_attack_without_dmg_logic() {
    // TODO: objective id as check
    return !check_if_on_title_screen() && get_current_stage() == 3 && get_top_objective_id() == 0 && get_bottom_objective_id() == 0
    // TODO: was it 5 hp?
    never(get_ion_wave_hp() < prev(get_ion_wave_hp())) &&
    // TODO: trigger when bomber defeated
    trigger_when(always_true())
}


achievement(
    title = "Debug Stuff in RA", points = 50,
    description = "Debug Away!",
    trigger =
        clear_chapter_logic(0)
)





rich_presence_conditional_display(check_if_on_title_screen(), "Rodea is on the Title Screen")



rich_presence_display("Preparing to take flight!")
