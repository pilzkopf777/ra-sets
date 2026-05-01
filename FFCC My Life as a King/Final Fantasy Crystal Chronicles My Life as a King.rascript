// Final Fantasy Crystal Chronicles: My Life as a King
// #ID = 7741

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

game_region = dword_be(0x00003180)

function is_game_region_eu() {
    return game_region == 0x57464350
}

function is_game_region_us() {
    return game_region == 0x57464345
}

function is_dlc_installed() {
    return ptr(dword_be(0x00436e94), [0x8F34C, 0x04], dword_be) == 0x03
}

function is_dlc_not_installed() {
    return ptr(dword_be(0x00436e94), [0x8F34C, 0x04], dword_be) == 0x01
}

function dlc_not_init_yet() {
    return ptr(dword_be(0x00436e94), [0x8F34C, 0x04], dword_be) != 0x01 && ptr(dword_be(0x00436e94), [0x8F34C, 0x04], dword_be) != 0x03 
}

function time_data_init() {
    return ptr(dword_be(0x00436e94), [0x3A54C], dword_be) > 0x80000000
}

class KingdomData {
    start_addon_offset = 0
    post_addon_offset = 0
    difficulty_offset = 0

    difficulty = 0x3c
    amt_adv = 0x54
    pay_rank = 0x5c
    elementite = 0x6c
    gil = 0xa4
    morale_prog = 0xe4
    morale_spheres = 0xec
    city_lvl = 0x104
    day = 0x134
    behest_ptr = 0x154
    raise_morale_timer = 0x114

    function get_difficulty() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.difficulty + this.post_addon_offset - this.difficulty_offset], dword_be)
    }

    function get_development_city_state() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.city_lvl + this.post_addon_offset], dword_be)
    }

    function get_day() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.day + this.post_addon_offset], dword_be)
    }

    function get_pay_rank() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.pay_rank + this.post_addon_offset], dword_be)
    }

    function get_max_adv_count() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.amt_adv + this.post_addon_offset], dword_be)
    }

    function get_behests_posted_count() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.behest_ptr + this.post_addon_offset, 0x44, 0x28], dword_be)
    }

    function gained_morale() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.morale_prog + this.post_addon_offset], dword_be) != prev(ptr(dword_be(0x00436e94), [this.start_addon_offset, this.morale_prog + this.post_addon_offset], dword_be))
    }

    function is_in_raise_morale_mode() {
        return ptr(dword_be(0x00436e94), [this.start_addon_offset, this.raise_morale_timer + this.post_addon_offset + this.post_addon_offset], dword_be) > 0
    }
}

class TimeData {
    function get_current_time() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x4C], dword_be)
    }

    function goes_to_bed_late() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x64], dword_be) == 0x4ec
    }

    function in_daily_report() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x5c], dword_be) == 0xffffffff
    }

    function get_report_value() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x5c], dword_be)
    }

    function time_paused() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x74], dword_be) == 0x01
    }
}

time_data = TimeData()

class UpgradeData {
    dlc_offset = 0x00
    dlc_offset_2 = 0x00

    function get_sum_of_upgrade_gil_paid() {
        total_upgrade_amt_paid = 0

        for upgrade_offset in range(0x04, 0x311, 0x14) {
            upgrade_amt_paid = ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x0c, 0x20, upgrade_offset, 0x4C], dword_be)

            total_upgrade_amt_paid = total_upgrade_amt_paid + upgrade_amt_paid
        }

        return total_upgrade_amt_paid
    }

/*
    function get_single_cond_for_upgrades_for_sale() {
        total_single_cond = []

        for upgrade_offset in range(0x04, 0x311, 0x14) {
            target = ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x0c, 0x20, upgrade_offset, 0xF4], dword_be)
            upgrade_for_sale = once(target == 3 || target == 5)

            array_push(total_single_cond, upgrade_for_sale)
        }

        return total_single_cond
    }
*/

    function get_sum_of_upgrade_levels() {
        total_performed_upgrades = 0

        for upgrade_offset in range(0x04, 0x311, 0x14) {
            upgrade_level = ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x0c, 0x20, upgrade_offset, 0x54], dword_be)

            amount_performed = upgrade_level / 5
            total_performed_upgrades = total_performed_upgrades + amount_performed
        }

        return total_performed_upgrades
    }
}

// TODO: chain is broken for eu dlc/base
class MedalData {
    dlc_offset = 0x00
    dlc_offset_2 = 0x00
    dlc_offset_3 = 0x00

    function medal_1_unlocked() {
        return ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x18, 0x04, this.dlc_offset_3], dword_be) == 0x01
    }

    function medal_1_amount_owned() {
        return ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2 + 0x08, 0x18, 0x04], dword_be)
    }

    function get_sum_of_dlc_medals_unlocked() {
        total = 0

        // Deduct 5 (6?) from final amount due to unused medals in the data (DLC? Test with Base?)

        for medal_count in range(0x04, 0x2BD, 8) {
            value = ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x18, medal_count, this.dlc_offset_3], dword_be)
            total = total + value
        }
        
        return total - 6
    }

    function get_sum_of_base_medals_unlocked() {
       total = 0

        // Deduct 5 (6?) from final amount due to unused medals in the data (DLC? Test with Base?)

        for medal_count in range(0x04, 0x155, 8) {
            value = ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x18, medal_count, this.dlc_offset_3], dword_be)
            total = total + value
        }
        
        return total - 6
    }
}

class Dungeon {
    dungeon_offset = 0x00

    function get_level() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xB4], dword_be)
    }

    function get_boss_state() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be)
    }

    function is_boss_defeated() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be) == 0x02
    }

    function get_amount_explored() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be)
    }

    function get_target_for_full_explore() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x84], dword_be)
    }

    function is_fully_explored() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be) == ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x84], dword_be)
    }

    function is_fully_cleared() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be) - ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x84], dword_be) +
               ptr(dword_be(0x00436e94), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be) == 0x02 / 1
    }
}

// Seemingly 63 dungeons total with DLC, including Infinity Spire; each has offset of 0x14; entries from 0x68 through 0x540
dungeon_refs = []
tally_cond = []

// Seemingly 63 dungeons total with DLC, including Infinity Spire; each has offset of 0x14; entries from 0x68 through 0x540
for current_dungeon_offset in range(0x68, 0x541, 0x14) {
    // Do NOT include Infinity Spire or Shrine of Awakening / Final Boss dungeon in list of dungeons
    if (current_dungeon_offset != 0x540 || current_dungeon_offset != 0x234) {
        current_dungeon = Dungeon(dungeon_offset=current_dungeon_offset)
        array_push(dungeon_refs, current_dungeon)

        array_push(tally_cond, once(current_dungeon.get_amount_explored() == current_dungeon.get_target_for_full_explore() && current_dungeon.is_boss_defeated()))
    }
}

infinity_spire = Dungeon(dungeon_offset=0x540)

/*
dungeons = {
    "Pallum Dei Caverns": Dungeon(dungeon_offset=0x68),
    "Kubito Grotto": Dungeon(dungeon_offset=0x7C),
    "Goblins' Den": Dungeon(dungeon_offset=0x90),
    "Terun Westway": Dungeon(dungeon_offset=0xA4),
    "Dolsam Gulch": Dungeon(dungeon_offset=0xB8),
    "Junun Dei Meadows": Dungeon(dungeon_offset=0xCC),
    "Polpus Mistmoor": Dungeon(dungeon_offset=0xE0),
}
*/

class KingdomBuilding {
    entry_offset = 0x00

    function get_building_type() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x4C4, 0x20, this.entry_offset, 0x3C], dword_be)
    }
}

building_refs = []

for current_building_offset in range(0x04, 0x1401, 0x14) {
    current_building = KingdomBuilding(entry_offset=current_building_offset)
    array_push(building_refs, current_building)
}

class Adventurer {
    entry_offset = 0x00
    dlc_offset = 0x00

    function get_job_id() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x13c, 0x18, this.entry_offset, this.dlc_offset, 0x4C], dword_be)
    }

    function get_level() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x13c, 0x18, this.entry_offset, this.dlc_offset, 0x3C], dword_be)
    }
}

function get_adv_hired() {
    return ptr(dword_be(0x00436e94), [0x8B21C, 0x13c, 0x1c], dword_be)
}


any_lvl_50_base = always_false()
any_lvl_50_dlc = always_false()

any_whm_base = always_false()
any_whm_dlc = always_false()

any_blm_base = always_false()
any_blm_dlc = always_false()

any_thf_base = always_false()
any_thf_dlc = always_false()

amt_adv_logic = 1

for adventurer_offset in range(0x04, 0x7D, 0x08) {
    current_adv = Adventurer(entry_offset=adventurer_offset, dlc_offset=0x26C)
    current_adv_dlc = Adventurer(entry_offset=adventurer_offset, dlc_offset=0x274)

    lvl_50_cond_base = current_adv.get_level() >= 50 && prev(current_adv.get_level() < 50) && get_adv_hired() >= amt_adv_logic
    lvl_50_cond_dlc = current_adv_dlc.get_level() >= 50 && prev(current_adv_dlc.get_level() < 50) && get_adv_hired() >= amt_adv_logic

    whm_cond_base = current_adv.get_job_id() == 0x03 && prev(current_adv.get_job_id() != 0x03) && get_adv_hired() >= amt_adv_logic
    whm_cond_dlc = current_adv_dlc.get_job_id() == 0x03 && prev(current_adv_dlc.get_job_id() != 0x03) && get_adv_hired() >= amt_adv_logic

    blm_cond_base = current_adv.get_job_id() == 0x02 && prev(current_adv.get_job_id() != 0x02) && get_adv_hired() >= amt_adv_logic
    blm_cond_dlc = current_adv_dlc.get_job_id() == 0x02 && prev(current_adv_dlc.get_job_id() != 0x02) && get_adv_hired() >= amt_adv_logic

    thf_cond_base = current_adv.get_job_id() == 0x04 && prev(current_adv.get_job_id() != 0x04) && get_adv_hired() >= amt_adv_logic
    thf_cond_dlc = current_adv_dlc.get_job_id() == 0x04 && prev(current_adv_dlc.get_job_id() != 0x04) && get_adv_hired() >= amt_adv_logic

    any_lvl_50_base = any_lvl_50_base || lvl_50_cond_base
    any_lvl_50_dlc = any_lvl_50_dlc || lvl_50_cond_dlc

    any_whm_base = any_whm_base || whm_cond_base
    any_whm_dlc = any_whm_dlc || whm_cond_dlc

    any_blm_base = any_blm_base || blm_cond_base
    any_blm_dlc = any_blm_dlc || blm_cond_dlc

    any_thf_base = any_thf_base || thf_cond_base
    any_thf_dlc = any_thf_dlc || thf_cond_dlc

    amt_adv_logic = amt_adv_logic + 1
}

one_of_each_base = any_whm_base && any_blm_base && any_thf_base
one_of_each_dlc = any_whm_dlc && any_blm_dlc && any_thf_dlc

// any_lvl_50_base = any_of(adventurer_list_base, item => item.get_level() == 50) && prev(none_of(adventurer_list_base, item => item.get_level() == 50))
// any_lvl_50_dlc = any_of(adventurer_list_dlc, item => item.get_level() == 50) && prev(none_of(adventurer_list_dlc, item => item.get_level() == 50))


class WanderingMonster {
    monster_offset = 0x00

    function monster_just_died() {
        status_1 = ptr(dword_be(0x00436e94), [0x8B21C, 0x18c, 0x18, this.monster_offset, 0x04], dword_be)
        status_2 = ptr(dword_be(0x00436e94), [0x8B21C, 0x18c, 0x18, this.monster_offset, 0x74], dword_be)

        // Monster went from any status to dead (to dodge flicker)
        return status_2 == 1 && status_1 == 3 && prev(status_1 != 3)
    }
}

wandering_monsters = [
    {
        "name": "The Corruptor of Minds",
        "true_name": "Mind Flayer",
        "obj": WanderingMonster(monster_offset=0x04)
    },
    {
        "name": "The Unstoppable Fiend",
        "true_name": "Behemoth",
        "obj": WanderingMonster(monster_offset=0x0C)
    },
    {
        "name": "The Clockwork Executioner",
        "true_name": "Steel Golem",
        "obj": WanderingMonster(monster_offset=0x14)
    },
    {
        "name": "The Everliving Drake",
        "true_name": "Zombie Dragon",
        "obj": WanderingMonster(monster_offset=0x1C)
    },
    {
        "name": "The Ravenous Howler",
        "true_name": "Brutal Wolf",
        "obj": WanderingMonster(monster_offset=0x24)
    },
    {
        "name": "The Demonic Duo",
        "true_name": "Imp",
        "obj": WanderingMonster(monster_offset=0x2C)
    },
    {
        "name": "The Tiny Tomb Twins",
        "true_name": "Tonberry",
        "obj": WanderingMonster(monster_offset=0x34)
    },
    {
        "name": "The Silver-Shelled Beast",
        "true_name": "Gil Snapper",
        "obj": WanderingMonster(monster_offset=0x3C)
    }
]

event_flags = {
    // 1 == Cutscene for first holiday started. Also check time for unlock moment.
    "first_holiday": ptr(dword_be(0x801304), [0x7A1C, 0x34], dword_be) / 0xff,
    // 1 == Cutscene done: Celebration of kill. At end of cutscene (== end of day) unlock achievement
    "cp1_done": ptr(dword_be(0x801304), [0x7BD4, 0x34], dword_be) / 0xff,
    // 1 == Unlocked park
    "park_unlocked": ptr(dword_be(0x801304), [0x7C0C, 0x34], dword_be) / 0xff,
    // 1 == Unlocked spacious houses
    "spacious_houses_unlocked": ptr(dword_be(0x801304), [0x7C24, 0x34], dword_be) / 0xff,
    // 1 == Unlocked Skysphere
    "skysphere_unlocked": ptr(dword_be(0x801304), [0x7C3C, 0x34], dword_be), //TODO: REVIEW THIS VAL
    // 1 == Unlocked BLM, cutscene done
    "cp2_done": ptr(dword_be(0x801304), [0x7CBC, 0x34], dword_be) / 0xff,
    // 1 == Cutscene done. Next cutscene contains the cp 3 completion check..
    "cp3_done": ptr(dword_be(0x801304), [0x7D6C, 0x34], dword_be) / 0xff,
    // 1 == Cutscene done, could also check day count instead though
    "day_1_done": ptr(dword_be(0x801304), [0x814C, 0x34], dword_be) / 0xff,
    // 1 == Crowned Archlord, cutscene done
    "archlord": ptr(dword_be(0x801304), [0x7E44, 0x34], dword_be) / 0xff,
    // 1 == credits start rolling
    "game_clear": ptr(dword_be(0x801304), [0x7E4C, 0x34], dword_be) / 0xff,
    // 1 == completed subquest
    "subquest": ptr(dword_be(0x801304), [0x784C, 0x3C], dword_be),
}

memories_seen = 0

for memory in range(0x7DC4, 0x7E35, 0x08) {
    memories_seen = memories_seen + ptr(dword_be(0x801304), [memory, 0x34], dword_be) / 0xff
}

us_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00, difficulty_offset=0x00),
    "upgrades": UpgradeData(dlc_offset=0x8F394, dlc_offset_2=0x15c),
    "medals": MedalData(dlc_offset=0x8F394, dlc_offset_2=0x20C, dlc_offset_3=0xA4),
    "is_used_version": is_game_region_us() && !is_dlc_installed()
}

us_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08, difficulty_offset=0x08),
    "upgrades": UpgradeData(dlc_offset=0x8D648, dlc_offset_2=0x164),
    "medals": MedalData(dlc_offset=0x8D648, dlc_offset_2=0x214, dlc_offset_3=0xAC),
    "is_used_version": is_game_region_us() && is_dlc_installed()
}

eu_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00, difficulty_offset=0x00),
    "upgrades": UpgradeData(dlc_offset=0x8F394, dlc_offset_2=0x15c),
    "medals": MedalData(dlc_offset=0x8F394, dlc_offset_2=0x20C, dlc_offset_3=0xA4),
    "is_used_version": is_game_region_eu() && !is_dlc_installed()
}

eu_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08, difficulty_offset=0x08),
    "upgrades": UpgradeData(dlc_offset=0x8D648, dlc_offset_2=0x164),
    "medals": MedalData(dlc_offset=0x8D648, dlc_offset_2=0x214, dlc_offset_3=0xAC),
    "is_used_version": is_game_region_eu() && is_dlc_installed()
}

city_dev_map = {
    0x00: "Settlement",
    0x01: "Town",
    0x02: "City",
    0x03: "Kingdom",
    0x04: "Empire",
    0x05: "Promised Land"
}

difficulty_map = {
    0x00: "Normal",
    0x01: "Hard",
    0x02: "Very Hard"
}

max_time_map = {
    0xffffffff: "Viewing the daily reports"
}

function on_title() {
    return dlc_not_init_yet() || !time_data_init()
}

function on_results() {
    return time_data.get_current_time() == 6300 && time_data.time_paused() && time_data.get_report_value() == 0 &&
    event_flags["game_clear"] == 1
}

// Progression
achievement(
    title = "COMPL_DAY_1",
    points = 0,
    type = "progression",
    description = "Complete the first day",
    trigger = 
        !on_title() &&
        event_flags["day_1_done"] == 1 && prev(event_flags["day_1_done"] == 0)
)

achievement(
    title = "COMPL_CP_1",
    points = 0,
    type = "progression",
    description = "Complete chapter 1",
    trigger = 
        !on_title() &&
        event_flags["cp1_done"] == 1 && prev(event_flags["cp1_done"] == 0)
)

achievement(
    title = "COMPL_CP_2",
    points = 0,
    type = "progression",
    description = "Complete chapter 2",
    trigger = 
        !on_title() &&
        event_flags["cp2_done"] == 1 && prev(event_flags["cp2_done"] == 0)
)

achievement(
    title = "COMPL_CP_3",
    points = 0,
    type = "progression",
    description = "Complete chapter 3",
    trigger = 
        !on_title() &&
        event_flags["cp3_done"] == 1 && prev(event_flags["cp3_done"] == 0)
)

achievement(
    title = "WIN",
    points = 0,
    type = "win_condition",
    description = "WIN",
    trigger = 
        // Pops on Kingdom Scores screen
        never(on_title()) &&
        event_flags["game_clear"] == 1 &&
        repeated(85, time_data.get_current_time() == 6300)
)

/*
RAScript hates multiple MeasuredIfs in LBs so we're doing it manually..

for diff in difficulty_map {
    leaderboard(
        title = format("Road to Archlord ({0}) ", difficulty_map[diff]),
        description = format("Be crowned the Archlord in as few days as possible on {0} difficulty!", difficulty_map[diff]),
        start = 
        (
            event_flags["game_clear"] == 1 &&
            repeated(85, time_data.get_current_time() == 6300)
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        (
            measured(us_dlc["kingdom"].get_day(), when=us_dlc["is_used_version"] && us_dlc["kingdom"].get_difficulty() == diff)
        ),
        format = "VALUE", lower_is_better = true
    )
}
*/


function final_rank_is_a() {
    return ascii_string_equals(0x00434911, "A") || ascii_string_equals(0x00434911, "S")
}

function final_rank_is_sss() {
    return ascii_string_equals(0x00434911, "S S S")
}

achievement(
    title = "WIN_A",
    points = 0,
    type = "",
    description = "Complete the game with an A rank or higher on any difficulty",
    trigger = 
        // Pops on Kingdom Scores screen
        never(on_title()) &&
        event_flags["game_clear"] == 1 &&
        final_rank_is_a() &&
        repeated(85, time_data.get_current_time() == 6300)
)

achievement(
    title = "WIN_SSS",
    points = 0,
    type = "",
    description = "Complete the game with a SSS rank on any difficulty",
    trigger = 
        // Pops on Kingdom Scores screen
        never(on_title()) &&
        event_flags["game_clear"] == 1 &&
        final_rank_is_sss() &&
        repeated(85, time_data.get_current_time() == 6300)
)

achievement(
    title = "WIN_HARDER",
    points = 0,
    type = "",
    description = "Complete the game with any rank on Hard or Very Hard difficulty",
    trigger = 
        // Pops on Credits roll
        never(on_title()) &&
        event_flags["game_clear"] == 1 &&
        repeated(85, time_data.get_current_time() == 6300) &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                us_dlc["kingdom"].get_difficulty() > 0
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                us_base["kingdom"].get_difficulty() > 0
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                eu_dlc["kingdom"].get_difficulty() > 0
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                eu_base["kingdom"].get_difficulty() > 0
            )
        )
)

// Day extension
achievement(
    title = "DAY_EXTENDED",
    points = 0,
    type = "",
    description = "Mingle with the inhabitants of the kingdom and earn the right to stay up past your bedtime",
    trigger = 
        !on_title() &&
        time_data.goes_to_bed_late() &&
        prev(time_data.get_current_time()) == 0 && time_data.get_current_time() == 1
)

achievement(
    title = "PAY_RATE",
    points = 0,
    type = "",
    description = "Increase the Pay Rank of the kingdom to the highest level and reward your adventurers starting the next day",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                measured(us_dlc["kingdom"].get_pay_rank() == 4, when=us_dlc["is_used_version"] && !on_title()) && prev(us_dlc["kingdom"].get_pay_rank() == 3)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                measured(us_base["kingdom"].get_pay_rank() == 4, when=us_base["is_used_version"] && !on_title()) && prev(us_base["kingdom"].get_pay_rank() == 3)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                measured(eu_dlc["kingdom"].get_pay_rank() == 4, when=eu_dlc["is_used_version"] && !on_title()) && prev(eu_dlc["kingdom"].get_pay_rank() == 3)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                measured(eu_base["kingdom"].get_pay_rank() == 4, when=eu_base["is_used_version"] && !on_title()) && prev(eu_base["kingdom"].get_pay_rank() == 3)
            )
        )
)

achievement(
    title = "Ship It",
    points = 0,
    type = "",
    description = "Unlock the Skysphere",
    trigger = 
        !on_title() &&
        event_flags["skysphere_unlocked"] == 1 && prev(event_flags["skysphere_unlocked"] == 0)
)

achievement(
    title = "HIRED_COUNT",
    points = 0,
    type = "",
    description = "Have 20 or more adventurers fight for your kingdom at the same time",
    trigger = 
        !on_title() &&
        get_adv_hired() == 20 &&
        time_data.get_current_time() == 1 && prev(time_data.get_current_time() == 0)
)

// Holiday
achievement(
    title = "Take a Break",
    points = 0,
    type = "",
    description = "Celebrate the kingdom's very first holiday",
    trigger = 
        never(on_title() || time_data.in_daily_report()) &&
        once(event_flags["first_holiday"] == 1 && prev(event_flags["first_holiday"] == 0)) &&
        time_data.get_current_time() == 1 && prev(time_data.get_current_time() == 0)
)

// Behest count
achievement(
    title = "Public Service Announcement",
    points = 0,
    type = "",
    description = "Post four different behests at the same time",
    trigger = 
        !on_title() &&
        !time_data.in_daily_report() &&
        time_data.get_current_time() == 1 && prev(time_data.get_current_time() == 0) &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                us_dlc["kingdom"].get_behests_posted_count() == 4
            ) ||
            (
                // US BASE
                us_base["is_used_version"] &&
                us_base["kingdom"].get_behests_posted_count() == 4
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                eu_dlc["kingdom"].get_behests_posted_count() == 4
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                eu_base["kingdom"].get_behests_posted_count() == 4
            )
        )
)

// Sidequest
achievement(
    title = "A Little Helping Hand",
    points = 0,
    type = "",
    description = "Help a citizen of your kingdom with their everyday troubles",
    trigger = 
        !on_title() &&
        event_flags["subquest"] == 1 && prev(event_flags["subquest"] == 0)
)
// Rank up kingdom
achievement(
    title = "Development Plans",
    points = 0,
    type = "",
    description = "Develop your kingdom to the rank of \"Town\"",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                us_dlc["kingdom"].get_development_city_state() == 1 && prev(us_dlc["kingdom"].get_development_city_state() == 0)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                us_base["kingdom"].get_development_city_state() == 1 && prev(us_base["kingdom"].get_development_city_state() == 0)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                eu_dlc["kingdom"].get_development_city_state() == 1 && prev(eu_dlc["kingdom"].get_development_city_state() == 0)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                eu_base["kingdom"].get_development_city_state() == 1 && prev(eu_base["kingdom"].get_development_city_state() == 0)
            )
        )
)

achievement(
    title = "PROMISED_LAND",
    points = 0,
    type = "",
    description = "Develop your kingdom to the rank of \"Promised Land\"",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                measured(us_dlc["kingdom"].get_development_city_state() == 5, when=us_dlc["is_used_version"] && !on_title()) && prev(us_dlc["kingdom"].get_development_city_state() == 4)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                measured(us_base["kingdom"].get_development_city_state() == 5, when=us_base["is_used_version"] && !on_title()) && prev(us_base["kingdom"].get_development_city_state() == 4)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                measured(eu_dlc["kingdom"].get_development_city_state() == 5, when=eu_dlc["is_used_version"] && !on_title()) && prev(eu_dlc["kingdom"].get_development_city_state() == 4)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                measured(eu_base["kingdom"].get_development_city_state() == 5, when=eu_base["is_used_version"] && !on_title()) && prev(eu_base["kingdom"].get_development_city_state() == 4)
            )
        )
)

infinity_spire_floor = infinity_spire.get_level() - 9

// Infinity Spire
achievement(
    title = "INFINITY_1",
    points = 0,
    type = "",
    description = "Clear level 10 of the Infinity Spire",
    trigger = 
        !on_title() &&
        infinity_spire.get_level() >= 11 && prev(infinity_spire.get_level() <= 10)
)

achievement(
    title = "INFINITY_2",
    points = 0,
    type = "",
    description = "Clear level 25 of the Infinity Spire",
    trigger = 
        !on_title() &&
        infinity_spire.get_level() >= 26 && prev(infinity_spire.get_level() <= 25)
)

achievement(
    title = "INFINITY_3",
    points = 0,
    type = "",
    description = "Clear level 50 of the Infinity Spire",
    trigger = 
        !on_title() &&
        infinity_spire.get_level() >= 51 && prev(infinity_spire.get_level() <= 50)
)

achievement(
    title = "INFINITY_4",
    points = 0,
    type = "",
    description = "Clear level 99 of the Infinity Spire",
    trigger = 
        !on_title() &&
        infinity_spire.get_level() >= 100 && prev(infinity_spire.get_level() <= 99)
)

// Dungeon rate
achievement(
    title = "Dungeon Tour",
    points = 0,
    type = "",
    description = "Defeat the boss and fully explore 10 different dungeons excluding the Infinity Spire",
    trigger = 
        !on_title() &&
        measured(tally(10, tally_cond))
)

achievement(
    title = "Dungeon World Tour",
    points = 0,
    type = "",
    description = "Defeat the boss and fully explore 55 different dungeons excluding the Infinity Spire",
    trigger = 
        !on_title() &&
        measured(tally(55, tally_cond))
)

achievement(
    title = "Even Grander Dungeon World Tour",
    points = 0,
    type = "",
    description = "Defeat the boss and fully explore all dungeons excluding the Infinity Spire",
    trigger = 
        !on_title() &&
        measured(tally(62, tally_cond))
)

// Memories
achievement(
    title = "Memories",
    points = 0,
    type = "",
    description = "Read five entries of Chime's personal report during the attack on the Dark Lord",
    trigger = 
        never(on_title()) &&
        measured(memories_seen == 5, when=!on_title()) && prev(memories_seen) == 4
)

// Gain happiness on day
target = 50
achievement(
    title = "HAPPY_MORALE",
    points = 0,
    type = "",
    description = "HAPPY_MORALE",
    trigger = 
        never(on_title()) &&
        (
            (
                // For all of these:
                // Clear progress on new day
                // Count up once per morale change -> even when overflowing to 0 this represents a gain
                // US DLC
                us_dlc["is_used_version"] &&
                never(us_dlc["kingdom"].get_day() != prev(us_dlc["kingdom"].get_day())) &&
                never(!us_dlc["kingdom"].is_in_raise_morale_mode()) &&

                trigger_when(
                    repeated(target, us_dlc["kingdom"].gained_morale())
                )
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                never(us_base["kingdom"].get_day() != prev(us_base["kingdom"].get_day())) &&
                never(!us_base["kingdom"].is_in_raise_morale_mode()) &&

                trigger_when(
                    repeated(target, us_base["kingdom"].gained_morale())
                )
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                never(eu_dlc["kingdom"].get_day() != prev(eu_dlc["kingdom"].get_day())) &&
                never(!eu_dlc["kingdom"].is_in_raise_morale_mode()) &&

                trigger_when(
                    repeated(target, eu_dlc["kingdom"].gained_morale())
                )
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                never(eu_base["kingdom"].get_day() != prev(eu_base["kingdom"].get_day())) &&
                never(!eu_base["kingdom"].is_in_raise_morale_mode()) &&

                trigger_when(
                    repeated(target, eu_base["kingdom"].gained_morale())
                )   
            )
        )

)

target = 5000
target_string = "5,000"
// Upgrades
achievement(
    title = "INVEST",
    points = 0,
    type = "",
    description = format("Invest a total of {0} gil into research", target_string),
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                measured(us_dlc["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=us_dlc["is_used_version"] && !on_title()) && prev(us_dlc["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                measured(us_base["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=us_base["is_used_version"] && !on_title()) && prev(us_base["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                measured(eu_dlc["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=eu_dlc["is_used_version"] && !on_title()) && prev(eu_dlc["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                measured(eu_base["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=eu_base["is_used_version"] && !on_title()) && prev(eu_base["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            )
        )
)

target = 100000
target_string = "100,000"
achievement(
    title = "INVEST_HIGH",
    points = 0,
    type = "",
    description = format("Invest a total of {0} gil into research", target_string),
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                measured(us_dlc["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=us_dlc["is_used_version"] && !on_title()) && prev(us_dlc["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                measured(us_base["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=us_base["is_used_version"] && !on_title()) && prev(us_base["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                measured(eu_dlc["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=eu_dlc["is_used_version"] && !on_title()) && prev(eu_dlc["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                measured(eu_base["upgrades"].get_sum_of_upgrade_gil_paid() >= target, when=eu_base["is_used_version"] && !on_title()) && prev(eu_base["upgrades"].get_sum_of_upgrade_gil_paid() < target)
            )
        )
)

/*
Setup

The generated logic is too long. Using Remember/Recall cuts down the size a lot so for these achievements a custom Python script is used to manually generated these cheevos.
Concepts for those:
- Enable three shrine buffs on the same day / same time
- Have one 

achievement(
    title = "...",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        !on_title() &&
        // Too long... barely
        measured(tally_of(building_refs, 50, item => once(item.get_building_type() == 0x191))) && tally_of(building_refs, 49, item => once(item.get_building_type() == 0x191))
)
*/


// Other stuff missing: specific upgrade schools, anything related to library, build x buldings? (maybe only houses or utility etc)
// Spire floor 1, 50, etc

achievement(
    title = "WHM",
    points = 0,
    type = "",
    description = "Have any adventurer change their job to a White Mage",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                any_whm_dlc
            ) ||
            (
                // US BASE
                is_dlc_not_installed() &&
                any_whm_base
            )
        )
)

achievement(
    title = "BLM",
    points = 0,
    type = "",
    description = "Have any adventurer change their job to a Black Mage",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                any_blm_dlc
            ) ||
            (
                // US BASE
                is_dlc_not_installed() &&
                any_blm_base
            )
        )
)

achievement(
    title = "THF",
    points = 0,
    type = "",
    description = "Have any adventurer change their job to a Thief",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                any_thf_dlc
            ) ||
            (
                // US BASE
                is_dlc_not_installed() &&
                any_thf_base
            )
        )
)

achievement(
    title = "LVL_50",
    points = 0,
    type = "",
    description = "Have any adventurer reach level 50",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                any_lvl_50_dlc
            ) ||
            (
                // US BASE
                is_dlc_not_installed() &&
                any_lvl_50_base
            )
        )
)

// Medals
achievement(
    title = "GET_MEDAL",
    points = 0,
    type = "",
    description = "Earn your first medal",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                measured(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 1, when=is_dlc_installed() && !on_title()) && prev(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 0)
            ) ||
            (
               // US BASE
               is_dlc_not_installed() &&
                measured(us_base["medals"].get_sum_of_base_medals_unlocked() == 1, when=is_dlc_not_installed() && !on_title()) && prev(us_base["medals"].get_sum_of_base_medals_unlocked() == 0)
            )
        )
)

achievement(
    title = "GET_40_MEDALS",
    points = 0,
    type = "",
    description = "Earn a total of 40 different medals",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                measured(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 40, when=is_dlc_installed() && !on_title()) && prev(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 39)
            ) ||
            (
               // US BASE
               is_dlc_not_installed() &&
                measured(us_base["medals"].get_sum_of_base_medals_unlocked() == 40, when=is_dlc_not_installed() && !on_title()) && prev(us_base["medals"].get_sum_of_base_medals_unlocked() == 39)
            )
        )
)

achievement(
    title = "GET_82_MEDALS",
    points = 0,
    type = "",
    description = "Earn a total of 82 different medals",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                is_dlc_installed() &&
                measured(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 82, when=is_dlc_installed() && !on_title()) && prev(us_dlc["medals"].get_sum_of_dlc_medals_unlocked() == 81)
            ) ||
            (
                // US BASE
                is_dlc_not_installed() &&
                measured(us_base["medals"].get_sum_of_base_medals_unlocked() == 82, when=is_dlc_not_installed() && !on_title()) && prev(us_base["medals"].get_sum_of_base_medals_unlocked() == 81)
            )
        )
)

// Kill legendary monsters
for monster in wandering_monsters {
    achievement(
        title = format("{0}", monster["name"]),
        points = 0,
        type = "",
        description = format("Defeat the wandering {0}", monster["true_name"]),
        trigger = 
            !on_title() &&
            monster["obj"].monster_just_died()
    )
}


rich_presence_conditional_display(on_title(), "On the Title Screen")

// US DLC
rich_presence_conditional_display(is_game_region_us() && is_dlc_installed(), "{3} difficulty • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_us() && is_dlc_installed() && on_results(), "{3} difficulty • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// US BASE
rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed(), "{3} difficulty • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed() && on_results(), "{3} difficulty • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// EU DLC
rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed(), "{3} difficulty • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed() && on_results(), "{3} difficulty • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// EU BASE
rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed(), "{3} difficulty • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed() && on_results(), "{3} difficulty • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
