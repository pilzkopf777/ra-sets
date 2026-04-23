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

class MedalData {
    dlc_offset = 0x00
    dlc_offset_2 = 0x00

    function medal_1_unlocked() {
        return ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2, 0x18, 0x04], dword_be) == 0x01
    }

    function medal_1_amount_owned() {
        return ptr(dword_be(0x00436e94), [this.dlc_offset, this.dlc_offset_2 - 0x08, 0x18, 0x04], dword_be)
    }

    function get_sum_of_base_medals_unlocked() {
        // TODO: not all entries have data sadly.. -> do not use range, instead pull from list?
        cool_list = []

        for medal_count in range(0x04, 0xB4, 8) {
            array_push(cool_list, ptr(dword_be(0x00436e94), [this.dlc_offset, dlc_offset_2, 0x18, medal_count], dword_be))
        }

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

// Seemingly 63 dungeons total with DLC, including Infinity Spire; each has offset of 0x14; entries from 0x68 through 0x540
for current_dungeon_offset in range(0x68, 0x541, 0x14) {
    current_dungeon = Dungeon(dungeon_offset=current_dungeon_offset)
    array_push(dungeon_refs, current_dungeon)
}

dungeon_val = sum_of(dungeon_refs, item => (item.get_amount_explored() / item.get_target_for_full_explore()) + item.get_boss_state() / 3)

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

    function get_job_id() {
        return ptr(dword_be(0x00436e94), [0x8B21C, 0x13c, 0x18, this.entry_offset, 0x4C], dword_be)
    }
}

adventurer_list = []

for adventurer_offset in range(0x04, 0x8D, 0x08) {
    current_adv = Adventurer(entry_offset=adventurer_offset)
    array_push(adventurer_list, current_adv)
}

any_whm = any_of(adventurer_list, item => item.get_job_id() == 0x03) && none_of(adventurer_list, item => item.get_job_id() == 0x03)

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
    "skysphere_unlocked": 0, // unclear value -> double check?
    // 1 == Unlocked BLM, cutscene done
    "cp2_done": ptr(dword_be(0x801304), [0x7CBC, 0x34], dword_be) / 0xff,
    // 1 == Cutscene done. Next cutscene contains the cp 3 completion check..
    "cp3_done": ptr(dword_be(0x801304), [0x7D6C, 0x34], dword_be) / 0xff,
    // 1 == Cutscene done, could also check day count instead though
    "day_1_done": ptr(dword_be(0x801304), [0x814C, 0x34], dword_be) / 0xff,
    // 1 == Crowned Archlord, cutscene done
    "archlord": ptr(dword_be(0x801304), [0x7E44, 0x34], dword_be) / 0xff,
    // 1 == credits start rolling
    "game_clear": ptr(dword_be(0x801304), [0x7E4C, 0x34], dword_be) / 0xff
}

memories_seen = 0

for memory in range(0x7DC4, 0x7E35, 0x08) {
    memories_seen = memories_seen + ptr(dword_be(0x801304), [memory, 0x34], dword_be) / 0xff
}


us_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00, difficulty_offset=0x00),
    "upgrades": UpgradeData(dlc_offset=0x8F394, dlc_offset_2=0x15c),
    "medals": MedalData(dlc_offset=0x8F394, dlc_offset_2=0x20C),
    "is_used_version": is_game_region_us() && !is_dlc_installed()
}

us_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08, difficulty_offset=0x08),
    "upgrades": UpgradeData(dlc_offset=0x8D648, dlc_offset_2=0x164),
    "medals": MedalData(dlc_offset=0x8D648, dlc_offset_2=0x214),
    "is_used_version": is_game_region_us() && is_dlc_installed()
}

eu_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00, difficulty_offset=0x00),
    "upgrades": UpgradeData(dlc_offset=0x8F394, dlc_offset_2=0x15c),
    "medals": MedalData(dlc_offset=0x8F394, dlc_offset_2=0x20C),
    "is_used_version": is_game_region_eu() && !is_dlc_installed()
}

eu_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08, difficulty_offset=0x08),
    "upgrades": UpgradeData(dlc_offset=0x8D648, dlc_offset_2=0x164),
    "medals": MedalData(dlc_offset=0x8D648, dlc_offset_2=0x214),
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

// Achievements

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
        // Pops on Credits roll
        !on_title() &&
        event_flags["game_clear"] == 1 && prev(event_flags["game_clear"] == 0)
)

achievement(
    title = "KINGDOM_SCORE",
    points = 0,
    type = "",
    description = "KINGDOM SCORES",
    trigger = 
        // Pops on Kingdom Scores screen
        !on_title() &&
        event_flags["game_clear"] == 1 &&
        time_data.time_paused() && prev(!time_data.time_paused())
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
        time_data.get_current_time() == 0 && time_data.get_current_time() == 1
)

// Rank up kingdom
achievement(
    title = "UPGR_TO_TOWN",
    points = 0,
    type = "",
    description = "Develop the kingdom to the rank of \"Town\"",
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

// Dungeon rate
achievement(
    title = "DUNGEON_SWEEP",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        !on_title() &&
        measured(dungeon_val == 63) && prev(dungeon_val) == 62
)

// Memories
achievement(
    title = "MEMORIES",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        !on_title() &&
        measured(memories_seen == 5) && prev(memories_seen) == 4
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

// Medals
achievement(
    title = "MEDAL_ONE",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                us_dlc["medals"].medal_1_unlocked() && us_dlc["medals"].medal_1_amount_owned() == 10
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                us_base["medals"].medal_1_unlocked() && us_base["medals"].medal_1_amount_owned() == 10
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                eu_dlc["medals"].medal_1_unlocked() && eu_dlc["medals"].medal_1_amount_owned() == 10
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                eu_base["medals"].medal_1_unlocked() && eu_base["medals"].medal_1_amount_owned() == 10
            )
        )
)

// Adventurers
achievement(
    title = "HIRE_WHM",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        !on_title() &&
        any_of(adventurer_list, item => item.get_job_id() == 0x03) && none_of(adventurer_list, item => item.get_job_id() == 0x03)
)

achievement(
    title = "HIRE_ALL",
    points = 0,
    type = "",
    description = "...",
    trigger = 
        never(on_title()) &&
        // WAR
        once(any_of(adventurer_list, item => item.get_job_id() == 0x01) && none_of(adventurer_list, item => item.get_job_id() == 0x01)) &&
        // BLM
        once(any_of(adventurer_list, item => item.get_job_id() == 0x02) && none_of(adventurer_list, item => item.get_job_id() == 0x02)) && 
        // WHM
        once(any_of(adventurer_list, item => item.get_job_id() == 0x03) && none_of(adventurer_list, item => item.get_job_id() == 0x03)) && 
        // THF
        once(any_of(adventurer_list, item => item.get_job_id() == 0x04) && none_of(adventurer_list, item => item.get_job_id() == 0x04))
)

// Kill legendary monsters
for monster in wandering_monsters {
    achievement(
        title = format("{0}", monster["name"]),
        points = 0,
        type = "",
        description = format("Defeat the {0}", monster["true_name"]),
        trigger = 
            !on_title() &&
            monster["obj"].monster_just_died()
    )
}


achievement(
    title = "UPGR_TO_PROMISED_LAND",
    points = 0,
    type = "",
    description = "Develop the kingdom to the rank of \"Promised Land\"",
    trigger = 
        !on_title() &&
        (
            (
                // US DLC
                us_dlc["is_used_version"] &&
                measured(us_dlc["kingdom"].get_development_city_state() == 5, us_dlc["is_used_version"]) && prev(us_dlc["kingdom"].get_development_city_state() == 4)
            ) ||
            (
               // US BASE
                us_base["is_used_version"] &&
                measured(us_base["kingdom"].get_development_city_state() == 5, us_base["is_used_version"]) && prev(us_base["kingdom"].get_development_city_state() == 4)
            ) ||
            (
                // EU DLC
                eu_dlc["is_used_version"] &&
                measured(eu_dlc["kingdom"].get_development_city_state() == 5, eu_dlc["is_used_version"]) && prev(eu_dlc["kingdom"].get_development_city_state() == 4)
            ) ||
            (
                // EU BASE
                eu_base["is_used_version"] &&
                measured(eu_base["kingdom"].get_development_city_state() == 5, eu_base["is_used_version"]) && prev(eu_base["kingdom"].get_development_city_state() == 4)
            )
        )
)



rich_presence_conditional_display(on_title(), "On the Title Screen")

// US DLC
rich_presence_conditional_display(is_game_region_us() && is_dlc_installed(), "US DLC • {3} • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_us() && is_dlc_installed() && on_results(), "US DLC • {3} • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// US BASE
rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed(), "US Base • {3} • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed() && on_results(), "US Base • {3} • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", us_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// EU DLC
rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed(), "EU DLC • {3} • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed() && on_results(), "EU DLC • {3} • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_dlc["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

// EU BASE
rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed(), "EU Base • {3} • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed() && on_results(), "EU Base • {3} • On the Results screen",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE"),
    rich_presence_lookup("Difficulty", eu_base["kingdom"].get_difficulty(), difficulty_map, fallback="?")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
