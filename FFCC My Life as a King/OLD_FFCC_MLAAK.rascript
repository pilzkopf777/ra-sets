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
    region = "US"

    function get_starting_adr_for_block() {
        if (this.dlc) {
            if (this.region == "US") {
                // DLC in US
                return 0xc10d58
            } else {
                // DLC in EU
                return 0xc10e98
            }
        } else {
            if (this.region == "US") {
                // Base in US
                return 0xcf8000
            } else {
                // Base in EU
                return 0xcf7e64
            }
        }
    }

    function get_development_city_state() {
        target = this.get_starting_adr_for_block() + 0xB0
        return dword_be(target)
    }

    function get_day() {
        target = this.get_starting_adr_for_block() + 0xE0
        return dword_be(target)
    }

   // function get_difficulty() {
   //     target = this.get_starting_adr_for_block() + 0x
   //     return dword_be(target)
   // }

    function get_pay_rank() {
        target = this.get_starting_adr_for_block() + 0x08
        return dword_be(target)
    }

    function get_max_adv_count() {
        target = this.get_starting_adr_for_block() + 0x00
        return dword_be(target)
    }
}

game_region = dword_be(0x00003180)

region_map = {
    0x57464345: "US",
    0x57464350: "EU"
}

function is_ptr_us_base_valid() {
    return dword_be(0x598094) > 0x80000000 && dword_be(0x598094) < 0xa0000000 &&
           // Spire Passage is set...
           ptr(dword_be(0x598094), [0x52c], dword_be) > 0x80000000 && ptr(dword_be(0x598094), [0x52c], dword_be) < 0xa0000000 &&
           // ...but not Infinite Spire itself
           ptr(dword_be(0x598094), [0x540], dword_be) == 0x00
}

function is_ptr_eu_base_valid() {
    return dword_be(0x0063ed94) > 0x80000000 && dword_be(0x0063ed94) < 0xa0000000 &&
           ptr(dword_be(0x0063ed94), [0x52c], dword_be) > 0x80000000 && ptr(dword_be(0x0063ed94), [0x52c], dword_be) < 0xa0000000 &&
           ptr(dword_be(0x598094), [0x540], dword_be) == 0x00
}

function is_game_region_eu() {
    return dword_be(0x00003180) == 0x57464350
}

function is_game_region_us() {
    return dword_be(0x00003180) == 0x57464345
}

global_data_eu_dlc = GlobalData(region="EU", dlc=true)
global_data_eu_base = GlobalData(region="EU", dlc=false)
global_data_us_dlc = GlobalData(region="US", dlc=true)
global_data_us_base = GlobalData(region="US", dlc=false)

function no_save_loaded() {
    return dword_be(0x2b2ad4) != 0xffffffff
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
rich_presence_conditional_display(is_game_region_eu() && !is_ptr_eu_base_valid() && no_save_loaded(), "EU DLC • On the Title Screen")
rich_presence_conditional_display(is_game_region_eu() && is_ptr_eu_base_valid() && no_save_loaded(), "EU Base • On the Title Screen")

rich_presence_conditional_display(is_game_region_us() && !is_ptr_us_base_valid() && no_save_loaded(), "US DLC • On the Title Screen")
rich_presence_conditional_display(is_game_region_us() && is_ptr_us_base_valid() && no_save_loaded(), "US Base • On the Title Screen")



rich_presence_conditional_display(is_game_region_us() && !is_ptr_us_base_valid() && !no_save_loaded(), "US DLC • Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_us_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_us_dlc.get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_us() && is_ptr_us_base_valid() && !no_save_loaded(), "US Base • Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_us_base.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_us_base.get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && !is_ptr_eu_base_valid() && !no_save_loaded(), "EU DLC • Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_eu_dlc.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_eu_dlc.get_day(), "VALUE")
)

rich_presence_conditional_display(is_game_region_eu() && is_ptr_eu_base_valid() && !no_save_loaded(), "EU Base • Traveling the streets of the {0} • Day {1}",
    rich_presence_lookup("Development State", global_data_eu_base.get_development_city_state(), city_dev_map, fallback="?"),
    rich_presence_value("Day", global_data_eu_base.get_day(), "VALUE")
)

rich_presence_display("Playing Final Fantasy Crystal Chronicles: My Life as a King")
