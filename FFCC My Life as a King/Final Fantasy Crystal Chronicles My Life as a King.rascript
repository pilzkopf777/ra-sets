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
    // assuming eu data...:
    start_addon_offset = 0 // 0x8D648 for base, 0x8D648 for dlc
    post_addon_offset = 0 // 0 for base, 8 for dlc

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
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x64], dword_be) == 0x00
    }

    function get_max_time_ref() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x64], dword_be)
    }

    function time_paused() {
        return ptr(dword_be(0x00436e94), [0x03A54C, 0x74], dword_be) == 0x01
    }
}

time_data = TimeData()

ptr_to_upgrades_base_list_start = ptr(dword_be(0x00436e94), [0x8F394, 0x15c, 0x0c, 0x20], dword_be)
ptr_to_upgrades_dlc_list_start  = ptr(dword_be(0x00436e94), [0x8D648, 0x164, 0x0c, 0x20], dword_be)

upgrades_base = {
    "war": {
        "sword": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x22C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x22C, 0x54], dword_be)
        },
        "dagger": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x28C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x28C, 0x54], dword_be) 
        },
        "battle": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x2A4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x2A4, 0x54], dword_be) 
        }
    },
    "whm": {
        "restoration": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x184, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x184, 0x54], dword_be)
        },
        "protection": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1B4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1B4, 0x54], dword_be)
        },
        "holy": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1CC, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1CC, 0x54], dword_be)
        }
    },
    "blm": {
        "fire": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x124, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x124, 0x54], dword_be)
        },
        "lightning": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x154, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x154, 0x54], dword_be)
        },
        "enfeebling": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x16C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x16C, 0x54], dword_be)
        }
    },
    "thf": {
        "adventuring": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1E4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1E4, 0x54], dword_be)
        },
        "exploration": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1FC, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x1FC, 0x54], dword_be)
        },
        "dirty": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x214, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x214, 0x54], dword_be)
        }
    },
    "weapon": {
        "swords": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x04, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x04, 0x54], dword_be)
        },
        "hammers": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x18, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x18, 0x54], dword_be)
        },
        "daggers": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x4C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x4C, 0x54], dword_be)
        },
        "rods": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x64, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_base_list_start), [0x64, 0x54], dword_be) 
        }
    }
}

upgrades_dlc = {
    "war": {
        "sword": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x22C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x22C, 0x54], dword_be)
        },
        "dagger": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x28C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x28C, 0x54], dword_be) 
        },
        "battle": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x2A4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x2A4, 0x54], dword_be) 
        }
    },
    "whm": {
        "restoration": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x184, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x184, 0x54], dword_be)
        },
        "protection": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1B4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1B4, 0x54], dword_be)
        },
        "holy": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1CC, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1CC, 0x54], dword_be)
        }
    },
    "blm": {
        "fire": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x124, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x124, 0x54], dword_be)
        },
        "lightning": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x154, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x154, 0x54], dword_be)
        },
        "enfeebling": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x16C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x16C, 0x54], dword_be)
        }
    },
    "thf": {
        "adventuring": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1E4, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1E4, 0x54], dword_be)
        },
        "exploration": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1FC, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x1FC, 0x54], dword_be)
        },
        "dirty": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x214, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x214, 0x54], dword_be)
        }
    },
    "weapon": {
        "swords": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x04, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x04, 0x54], dword_be)
        },
        "hammers": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x18, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x18, 0x54], dword_be)
        },
        "daggers": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x4C, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x4C, 0x54], dword_be)
        },
        "rods": {
            "total_invested": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x64, 0x4C], dword_be),
            "level": ptr(dword_be(ptr_to_upgrades_dlc_list_start), [0x64, 0x54], dword_be) 
        }
    }
}

us_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00),
    "upgrades": upgrades_base
}
us_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08),
    "upgrades": upgrades_dlc
}
eu_base = {
    "kingdom": KingdomData(start_addon_offset=0x8F394, post_addon_offset=0x00),
    "upgrades": upgrades_base
}
eu_dlc = {
    "kingdom": KingdomData(start_addon_offset=0x8D648, post_addon_offset=0x08),
    "upgrades": upgrades_dlc
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
    0x00: "Viewing the daily reports",
    0x9d8: "Traveling the streets",
    0x4ec: "Traveling the streets"
}

rich_presence_conditional_display(dlc_not_init_yet(), "On the Title Screen")

rich_presence_conditional_display(is_game_region_us() && is_dlc_installed(), "US DLC • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_max_time_ref(), max_time_map, fallback="?"),
    rich_presence_lookup("Development State", us_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_dlc["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_us() && !is_dlc_installed(), "US Base • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_max_time_ref(), max_time_map, fallback="?"),
    rich_presence_lookup("Development State", us_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", us_base["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && is_dlc_installed(), "EU DLC • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_max_time_ref(), max_time_map, fallback="?"),
    rich_presence_lookup("Development State", eu_dlc["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_dlc["kingdom"].get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && !is_dlc_installed(), "EU Base • {0} of the {1} • Day {2}",
    rich_presence_lookup("Screen", time_data.get_max_time_ref(), max_time_map, fallback="?"),
    rich_presence_lookup("Development State", eu_base["kingdom"].get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", eu_base["kingdom"].get_day(), "VALUE")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
