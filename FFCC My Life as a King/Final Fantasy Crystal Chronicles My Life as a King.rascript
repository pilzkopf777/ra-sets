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

// "Global" stuff
class GlobalData
{
    dlc = true
    dlc_ptr = 0x16318bc
    no_dlc_ptr = 0x16466cc

    function get_development_city_state() {
        if (this.dlc) {
            data = ptr(dword_be(this.dlc_ptr), [0x10c], dword_be)
        } else {
            data = ptr(dword_be(this.no_dlc_ptr), [0x10c], dword_be)
        }
        return data
    }

    function get_day() {
        if (this.dlc) {
            data = ptr(dword_be(this.dlc_ptr), [0x13c], dword_be)
        } else {
            data = ptr(dword_be(this.no_dlc_ptr), [0x13c], dword_be)
        }
        return data
    }

    function get_difficulty() {
        if (this.dlc) {
            data = ptr(dword_be(this.dlc_ptr), [0x3c], dword_be)
        } else {
            data = ptr(dword_be(this.no_dlc_ptr), [0x3c], dword_be)
        }
        return data
    }

    function get_pay_rank() {
        if (this.dlc) {
            data = ptr(dword_be(this.dlc_ptr), [0x64], dword_be)
        } else {
            data = ptr(dword_be(this.no_dlc_ptr), [0x64], dword_be)
        }
        return data
    }

    function get_max_adv_count() {
        if (this.dlc) {
            data = ptr(dword_be(this.dlc_ptr), [0x5c], dword_be)
        } else {
            data = ptr(dword_be(this.no_dlc_ptr), [0x5c], dword_be)
        }
        return data
    }
}

function dlc_installed() {
    return dword_be(0x000030f0) > 0x80000000 && dword_be(0x000030f0) < 0x90000000
}

global_data_dlc = GlobalData(dlc=true)
global_data_no_dlc = GlobalData(dlc=false)

function no_save_loaded() {
    return dword_be(0x2b2ad4) != 0xffffffff
}

function in_report() {
    return dword_be(0x101b20f4) == 0x1c
}

function in_city() {
    return dword_be(0x101b20f4) == 0x9c
}

function has_long_day() {
    return ptr(dword_be(0x15de7c0), [0x64], dword_be) == 0x4ec
}

// Dungeon stuff
class Dungeon
{
    base_adr = 0x00

    function get_progress() {
        return ptr(dword_be(this.base_adr), [0x7c], dword_be)
    }

    function get_target_progress() {
        return ptr(dword_be(this.base_adr), [0x84], dword_be)
    }

    function get_boss_status() {
        return ptr(dword_be(this.base_adr), [0xd4], dword_be)
    }

}

distance_offset = 0x14
current_offset = 0x04
count = 0
list_of_dungeons = ["Castle", "1?", "2?", "3?"]
dungeons = {}

for dungeon_name in list_of_dungeons {
    final_offset = current_offset + distance_offset * count

    dungeon_obj_ptr = ptr(dword_be(0x65e290), [0x228, 0x20, final_offset], dword_be)
    dungeon_obj = Dungeon(base_adr=dungeon_obj_ptr)

    dungeons[dungeon_name] = dungeon_obj

    count = count + 1
}


upgrades = {
    "war": {
        "sword": {
            "total_invested": ptr(dword_be(0x1779b4c), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779b4c), [0x54], dword_be) 
        },
        "dagger": {
            "total_invested": ptr(dword_be(0x1779b9c), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779b9c), [0x54], dword_be) 
        },
        "battle": {
            "total_invested": ptr(dword_be(0x1779bb0), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779bb0), [0x54], dword_be) 
        },
    },
    "whm": {
        "restoration": {
            "total_invested": ptr(dword_be(0x1779ac0), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779ac0), [0x54], dword_be) 
        },
        "protection": {
            "total_invested": ptr(dword_be(0x1779ae8), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779ae8), [0x54], dword_be) 
        },
        "holy": {
            "total_invested": ptr(dword_be(0x1779afc), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779afc), [0x54], dword_be) 
        }
    },
    "blm": {
        "fire": {
            "total_invested": ptr(dword_be(0x1779a70), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779a70), [0x54], dword_be) 
        },
        "lightning": {
            "total_invested": ptr(dword_be(0x1779a98), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779a98), [0x54], dword_be) 
        },
        "enfeebling": {
            "total_invested": ptr(dword_be(0x1779aac), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779aac), [0x54], dword_be) 
        }
    },
    "thf": {
        "adventuring": {
            "total_invested": ptr(dword_be(0x1779b10), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779b10), [0x54], dword_be) 
        },
        "exploration": {
            "total_invested": ptr(dword_be(0x1779b24), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779b24), [0x54], dword_be) 
        },
        "dirty": {
            "total_invested": ptr(dword_be(0x1779b38), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779b38), [0x54], dword_be) 
        }
    },
    "item": {
        "potions": {
            "total_invested": ptr(dword_be(0x1779a0c), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779a0c), [0x54], dword_be) 
        },
        "antidotes": {
            "total_invested": ptr(dword_be(0x1779a20), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779a20), [0x54], dword_be) 
        },
        "survival": {
            "total_invested": ptr(dword_be(0x1779a5c), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779a5c), [0x54], dword_be) 
        }
    },
    "armory": {
        "shields": {
            "total_invested": ptr(dword_be(0x17799bc), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x17799bc), [0x54], dword_be) 
        },
        "robes": {
            "total_invested": ptr(dword_be(0x17799f8), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x17799f8), [0x54], dword_be) 
        }
    },
    "weapon": {
        "swords": {
            "total_invested": ptr(dword_be(0x1779944), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779944), [0x54], dword_be) 
        },
        "hammers": {
            "total_invested": ptr(dword_be(0x1779958), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779958), [0x54], dword_be) 
        },
        "daggers": {
            "total_invested": ptr(dword_be(0x1779980), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779980), [0x54], dword_be) 
        },
        "rods": {
            "total_invested": ptr(dword_be(0x1779994), [0x4c], dword_be),
            "current_level": ptr(dword_be(0x1779994), [0x54], dword_be) 
        }
    }
}


city_dev_map = {
    0x00: "Settlement",
    0x01: "Town",
    0x02: "City",
    0x03: "Kingdom",
    0x04: "Empire",
    0x05: "Promised Land"
}

// RP for DLC installed
rich_presence_conditional_display(no_save_loaded(), "On the Title Screen")

rich_presence_conditional_display(dlc_installed() && in_report(), "Reviewing the morning reports of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_dlc.get_day(), "VALUE")
)

rich_presence_conditional_display(dlc_installed() && in_city(), "Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_dlc.get_day(), "VALUE")
)

rich_presence_conditional_display(!dlc_installed() && in_report(), "Reviewing the morning reports of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_no_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_no_dlc.get_day(), "VALUE")
)

rich_presence_conditional_display(!dlc_installed() && in_city(), "Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_no_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_no_dlc.get_day(), "VALUE")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
