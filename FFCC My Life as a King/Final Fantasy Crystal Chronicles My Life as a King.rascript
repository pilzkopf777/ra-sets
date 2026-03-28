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

class KingdomData {
    start_addon_offset = 0
    post_addon_offset = 0

    amt_adv = 0x54
    pay_rank = 0x5c
    elementite = 0x6c
    gil = 0xa4
    morale_prog = 0xe4
    morale_spheres = 0xec
    city_lvl = 0x104
    day = 0x134

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

// TODO: make upgrades a class

ptr_to_upgrades_base_list_start = ptr(dword_be(0x00436e94), [0x8F394, 0x15c, 0x0c, 0x20], dword_be)
ptr_to_upgrades_dlc_list_start  = ptr(dword_be(0x00436e94), [0x8D648, 0x164, 0x0c, 0x20], dword_be)

upgrades_base = {
    "war": {
        "sword": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x22C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x22C, 0x54], dword_be)
        }
    }
}

upgrades_dlc = {
    "war": {
        "sword": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x22C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x22C, 0x54], dword_be)
        }
    }
}

class Dungeon {
    dungeon_offset = 0x00

    function get_level() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xB4], dword_be)
    }

    function get_boss_state() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be)
    }

    function is_boss_defeated() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be) == 0x02
    }

    function get_amount_explored() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be)
    }

    function is_fully_explored() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be) == ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x84], dword_be)
    }

    function is_fully_cleared() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x7C], dword_be) == ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0x84], dword_be) &&
               ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x20, this.dungeon_offset, 0xD4], dword_be) == 0x02
    }
}

dungeons = {
    "Pallum Dei Caverns": Dungeon(dungeon_offset=0x68),
    "Kubito Grotto": Dungeon(dungeon_offset=0x7C),
    "Goblins' Den": Dungeon(dungeon_offset=0x90),
    "Terun Westway": Dungeon(dungeon_offset=0xA4),
    "Dolsam Gulch": Dungeon(dungeon_offset=0xB8),
    "Junun Dei Meadows": Dungeon(dungeon_offset=0xCC),
    "Polpus Mistmoor": Dungeon(dungeon_offset=0xE0),
    "...": Dungeon(0xF4),
}

WanderingMonster {
    monster_offset = 0x00

    function get_residing_dungeon_ptr_adr() {
        return ptr(dword_be(dungeon_list), [0x8B21C, 0x184, 0x18, this.monster_offset, 0x6C], dword_be)
    } 
}

wandering_monsters = {
    "The Corruptor of Minds": WanderingMonster(monster_offset=0x04)
}

us_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00),
    "upgrades": upgrades_base,
    "dungeons": dungeons,
    "wandering_monsters": wandering_monsters
}

us_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08),
    "upgrades": upgrades_dlc,
    "dungeons": dungeons,
    "wandering_monsters": wandering_monsters
}

eu_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00),
    "upgrades": upgrades_base,
    "dungeons": dungeons,
    "wandering_monsters": wandering_monsters
}

eu_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08),
    "upgrades": upgrades_dlc,
    "dungeons": dungeons,
    "wandering_monsters": wandering_monsters
}

city_dev_map = {
    0x00: "Settlement",
    0x01: "Town",
    0x02: "City",
    0x03: "Kingdom",
    0x04: "Empire",
    0x05: "Promised Land"
}

max_time_map = {
    0xffffffff: "Viewing the daily reports"
}

rich_presence_conditional_display(dlc_not_init_yet(), "On the Title Screen")

rich_presence_conditional_display(is_game_region_us() && is_dlc_installed(), "US DLC • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed(), "US Base • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed(), "EU DLC • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed(), "EU Base • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_report_value(), max_time_map, fallback="Traveling the streets"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
