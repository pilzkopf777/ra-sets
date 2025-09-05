// Astérix & Obélix XXL 2: Mission - Las Vegum
// #ID = 22599

// Helper function taken from Souzooka - thanks!
function ptr(base, offsets, accessor=dword)
{
    val = base
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword(addr)
        }
    }
    
    return val
}

// Global access functions
function pointer_to_loads_of_data() => dword(0x57E2A4)

// Global data
FLAG_OFFSET = 0x14

EVENT_OFFSET = 0x13c
DIAMOND_HELMET_OFFSET = 0x154
CUTSCENE_OFFSET = 0x16c
SOUVENIER_OFFSET = 0x184

EVENT_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, EVENT_OFFSET], dword)
DIAMOND_HELMET_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, DIAMOND_HELMET_OFFSET], dword)
CUTSCENE_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, CUTSCENE_OFFSET], dword)
SOUVENIER_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, SOUVENIER_OFFSET], dword)

ASTERIX_POINTER = prt(pointer_to_loads_of_data(), [0x80, 0x08, 0x28, 0x04], dword)
OBELIX_POINTER = prt(pointer_to_loads_of_data(), [0x80, 0x08, 0x28, 0x96c], dword)

IN_ENGINE_CUTSCENE_STATE =  ptr(pointer_to_loads_of_data(), [0x74, 0x0c], byte)
MAIN_MENU_STATE = ptr(pointer_to_loads_of_data(), [0x80, 0x5f4], byte)

COMBAT_LOCK_COUNT = ptr(pointer_to_loads_of_data(), [0x88, 0xc4, 0x20], byte) // enemies left on a combat lock
WCW_TARGET_COUNT = ptr(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x3c, 0x04], byte) // enemies left in the wcw target challenge

PLAYER_DATA = {
    "world": prt(pointer_to_loads_of_data(), [0x48, 0x1d], byte),
    "subarea": prt(pointer_to_loads_of_data(), [0x48, 0x1e], byte),
    "helmets": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x40], dword),
    "hp": {
        "shields": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3c], byte), // 0x00 - 0x06
        "shield_parts": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3d], byte) // 0x00 (none) - 0x04 (full)
    },
    "character_in_control": prt(ASTERIX_POINTER, [0x25], byte), // 0x00 = asterix, 0x01 = obelix
    "multiplier": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3e], word),
    "playtime": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x48], float),
    "enemies_defeated": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x44], dword),
    "magic_potion": {
        "active": prt(pointer_to_loads_of_data(), [0x80, 0xa0, 0x3c], bit0),
        "timer": prt(pointer_to_loads_of_data(), [0x80, 0xa0, 0x44], float)
    },
    "final_postcard": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x66], bit0) // postcard #24 is the last one you can buy
    "character": {
        "asterix":
        {
            "control_freeze": prt(ASTERIX_POINTER, [0x0c], byte)
            "current_move": prt(ASTERIX_POINTER, [0xf4], byte)
            "coordinates": {
                "x": prt(ASTERIX_POINTER, [0x3d4], float)
                "y": prt(ASTERIX_POINTER, [0x3d8], float)
                "z": prt(ASTERIX_POINTER, [0x3dc], float)
            },
            "jump_state": prt(ASTERIX_POINTER, [0x40c], byte)
            "flame_state": prt(ASTERIX_POINTER, [0x575], byte)
        },   
        "obelix":
        {
            "control_freeze": prt(OBELIX_POINTER, [0x0c], byte)
            "current_move": prt(OBELIX_POINTER, [0xf4], byte)
            "coordinates": {
                "x": prt(OBELIX_POINTER, [0x3d4], float)
                "y": prt(OBELIX_POINTER, [0x3d8], float)
                "z": prt(OBELIX_POINTER, [0x3dc], float)
            },
            "jump_state": prt(OBELIX_POINTER, [0x40c], byte)
            "flame_state": prt(OBELIX_POINTER, [0x575], byte)
        }
    }    
}

CHALLENGE_TIMERS = {
    "lava": prt(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x00, 0x04], float),
    "target": prt(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x04, 0x04], float)
}

CUPOLA_DATA = {
    "height_right": prt(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29e0, 0xf8], float)
    "height_middle": prt(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29ec, 0xf8], float)
    "height_left": prt(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29f8, 0xf8], float)
}

CUTSCENE_DATA = {
    "Entering Venetia": ptr(CUTSCENE_POINTER, [0x00, FLAG_OFFSET], bit1),
    "Boats / Intro Cutscene": ptr(CUTSCENE_POINTER, [0x04, FLAG_OFFSET], bit1),
    "Gaulish village / Follow-up to Intro": ptr(CUTSCENE_POINTER, [0x08, FLAG_OFFSET], bit1),
    "Entering Las Vegum": ptr(CUTSCENE_POINTER, [0x0c, FLAG_OFFSET], bit1),
    "After saving 1st prisoner": ptr(CUTSCENE_POINTER, [0x10, FLAG_OFFSET], bit1),
    "Internetus": ptr(CUTSCENE_POINTER, [0x14, FLAG_OFFSET], bit1),
    "Fake village in WCW": ptr(CUTSCENE_POINTER, [0x18, FLAG_OFFSET], bit1),
    "Larry Craft reveal in WCW": ptr(CUTSCENE_POINTER, [0x1c, FLAG_OFFSET], bit1),
    "LuckSore entrance": ptr(CUTSCENE_POINTER, [0x20, FLAG_OFFSET], bit1),
    "Pirate Island entrance": ptr(CUTSCENE_POINTER, [0x24, FLAG_OFFSET], bit1),
    "Palace entrance": ptr(CUTSCENE_POINTER, [0x28, FLAG_OFFSET], bit1),
    "Confronting Ceasar / That one weird Matrix reference": ptr(CUTSCENE_POINTER, [0x2c, FLAG_OFFSET], bit1),
    "Saving 1st prisoner": ptr(CUTSCENE_POINTER, [0x30, FLAG_OFFSET], bit1),
    "Saving 2nd prisoner": ptr(CUTSCENE_POINTER, [0x34, FLAG_OFFSET], bit1),
    "Saving 3rd prisoner": ptr(CUTSCENE_POINTER, [0x38, FLAG_OFFSET], bit1),
    "Caesar defeated": ptr(CUTSCENE_POINTER, [0x3c, FLAG_OFFSET], bit1),
    "Ending": ptr(CUTSCENE_POINTER, [0x40, FLAG_OFFSET], bit1)
}

SOUVENIER_DATA = {
    "Character models / Lutetia": ptr(SOUVENIER_POINTER, [0x00, FLAG_OFFSET], bit1),
    "Postcards / Venetia": ptr(SOUVENIER_POINTER, [0x04, FLAG_OFFSET], bit1),
    "Cutscenes / LuckSore": ptr(SOUVENIER_POINTER, [0x08, FLAG_OFFSET], bit1)
}

WORLD_DATA = {
"Lutetia":{
    "id": 0x1,
    "world_name": "Lutetia",
    "rp_name": "in Lutetia",
    "quip_name": "City",
    "helmets": {
        "Four Torches": ptr(DIAMOND_HELMET_POINTER, [0x74, FLAG_OFFSET], bit1), // Player is not forced to collect it but loading a chapter will mark this as collected
        "Cruising": ptr(DIAMOND_HELMET_POINTER, [0x70, FLAG_OFFSET], bit1),
        "Triumphal Arch": ptr(DIAMOND_HELMET_POINTER, [0x6c, FLAG_OFFSET], bit1),
        "Eiffel Tower": ptr(DIAMOND_HELMET_POINTER, [0x68, FLAG_OFFSET], bit1),
        "Obelisk": ptr(DIAMOND_HELMET_POINTER, [0x64, FLAG_OFFSET], bit1)
    },
    "events": {
        "Switch on top of Eiffel Tower opening boat ride path": ptr(EVENT_POINTER, [0x178, FLAG_OFFSET], bit1),
        "Door to Arc de Triomphe opening": ptr(EVENT_POINTER, [0x18c, FLAG_OFFSET], bit1),
        "Security System 4th torch lit": ptr(EVENT_POINTER, [0x190, FLAG_OFFSET], bit1),
        "Security System 3rd torch lit": ptr(EVENT_POINTER, [0x194, FLAG_OFFSET], bit1),
        "Security System 2nd torch lit": ptr(EVENT_POINTER, [0x198, FLAG_OFFSET], bit1),
        "Security System 1st torch lit": ptr(EVENT_POINTER, [0x19c, FLAG_OFFSET], bit1),
        "Mario reveal outside Las Vegum": ptr(EVENT_POINTER, [0x210, FLAG_OFFSET], bit1),
        "Toll gate to Venetia": ptr(EVENT_POINTER, [0x25c, FLAG_OFFSET], bit1),
        "Toll gate to LuckSore": ptr(EVENT_POINTER, [0x264, FLAG_OFFSET], bit1)
    }
},
"Venetia":{
    "id": 0x2,
    "world_name": "Venetia",
    "rp_name": "in Venetia",
    "quip_name": "Canal",
    "helmets": {
        "Saint Mark's Cage": ptr(DIAMOND_HELMET_POINTER, [0x60, FLAG_OFFSET], bit1),
        "Canal Bumper Jumper": ptr(DIAMOND_HELMET_POINTER, [0x5c, FLAG_OFFSET], bit1),
        "Rooftop Slides": ptr(DIAMOND_HELMET_POINTER, [0x58, FLAG_OFFSET], bit1),
        "Going Underground": ptr(DIAMOND_HELMET_POINTER, [0x54, FLAG_OFFSET], bit1),
        "Little Stone Bridge": ptr(DIAMOND_HELMET_POINTER, [0x50, FLAG_OFFSET], bit1)
    },
    "events": {
        "Boss door opened": ptr(EVENT_POINTER, [0x12c, FLAG_OFFSET], bit1),
        "Torch for filling targets on plaza": ptr(EVENT_POINTER, [0x18c, FLAG_OFFSET], bit1),
        "Torch in Asterix route on plaza": ptr(EVENT_POINTER, [0x1b0, FLAG_OFFSET], bit1),
        "Torch in Obelix route on plaza": ptr(EVENT_POINTER, [0x1b4, FLAG_OFFSET], bit1),
        "Lever to open door in trench area with merchant": ptr(EVENT_POINTER, [0x1bc, FLAG_OFFSET], bit1),        
        "Obelix torch in front of boss gate": ptr(EVENT_POINTER, [0x1c0, FLAG_OFFSET], bit1),
        "Asterix torch in front of boss gate": ptr(EVENT_POINTER, [0x1c4, FLAG_OFFSET], bit1),
        "Panel stomped in 1st trench": ptr(EVENT_POINTER, [0x220, FLAG_OFFSET], bit1)
    }
},
"WCW":{
    "id": 0x3,
    "world_name": "WCW",
    "rp_name": "in the WCW",
    "quip_name": "Arena",
    "helmets": {
        "Challenge 1": ptr(DIAMOND_HELMET_POINTER, [0x4c, FLAG_OFFSET], bit1), // Player is forced to collect Challenge 1-4.
        "Challenge 3": ptr(DIAMOND_HELMET_POINTER, [0x48, FLAG_OFFSET], bit1), // That is the actual order!
        "Challenge 2": ptr(DIAMOND_HELMET_POINTER, [0x44, FLAG_OFFSET], bit1),
        "Challenge 4": ptr(DIAMOND_HELMET_POINTER, [0x40, FLAG_OFFSET], bit1),
        "Fake Gaulish Village": ptr(DIAMOND_HELMET_POINTER, [0x3c, FLAG_OFFSET], bit1)
    },
    "events": {
        "Internetus switch turned on": ptr(EVENT_POINTER, [0xf8, FLAG_OFFSET], bit1),
        "Door to village opened": ptr(EVENT_POINTER, [0xfc, FLAG_OFFSET], bit1),
        "Challenge 4 completed": ptr(EVENT_POINTER, [0x108, FLAG_OFFSET], bit1),
        "Challenge 3 completed": ptr(EVENT_POINTER, [0x10c, FLAG_OFFSET], bit1),
        "Challenge 2 completed": ptr(EVENT_POINTER, [0x110, FLAG_OFFSET], bit1),
        "Challenge 1 completed": ptr(EVENT_POINTER, [0x114, FLAG_OFFSET], bit1),
        "Door to Pirate Island and Palace opened": ptr(EVENT_POINTER, [0x234, FLAG_OFFSET], bit1)
    }
},
"LuckSore":{
    "id": 0x4,
    "world_name": "LuckSore",
    "rp_name": "in LuckSore",
    "quip_name": "Pyramid",   
    "helmets": {
        "Secret of the Secret Passage": ptr(DIAMOND_HELMET_POINTER, [0x28, FLAG_OFFSET], bit1),
        "Beneath the Sphinx": ptr(DIAMOND_HELMET_POINTER, [0x2c, FLAG_OFFSET], bit1),
        "One flew over the Tortoise": ptr(DIAMOND_HELMET_POINTER, [0x30, FLAG_OFFSET], bit1),
        "Crown of Palms": ptr(DIAMOND_HELMET_POINTER, [0x34, FLAG_OFFSET], bit1),
        "Refreshing Shower": ptr(DIAMOND_HELMET_POINTER, [0x38, FLAG_OFFSET], bit1)
    },
    "events": {
        "Right torch in Pikmin room": ptr(EVENT_POINTER, [0x80, FLAG_OFFSET], bit1),
        "Left torch in Pikmin room": ptr(EVENT_POINTER, [0x84, FLAG_OFFSET], bit1),
        "Main door in bomb push area open": ptr(EVENT_POINTER, [0x88, FLAG_OFFSET], bit1),
        "Torch 3 in bomb push area lit": ptr(EVENT_POINTER, [0X8c, FLAG_OFFSET], bit1),
        "Torch 2 in bomb push area lit": ptr(EVENT_POINTER, [0x90, FLAG_OFFSET], bit1),
        "Torch 1 in bomb push area lit": ptr(EVENT_POINTER, [0x94, FLAG_OFFSET], bit1),
        "Torch 2 in toilet room": ptr(EVENT_POINTER, [0x9c, FLAG_OFFSET], bit1),
        "Torch 3 in toilet room": ptr(EVENT_POINTER, [0xa0, FLAG_OFFSET], bit1),
        "Boss door opened": ptr(EVENT_POINTER, [0xc0, FLAG_OFFSET], bit1),
        "Red laser activated": ptr(EVENT_POINTER, [0xc4, FLAG_OFFSET], bit1),
        "Green laser activated": ptr(EVENT_POINTER, [0xc8, FLAG_OFFSET], bit1),
        "Yellow laser activated": ptr(EVENT_POINTER, [0xcc, FLAG_OFFSET], bit1),
        "Torch 1 in toilet room": ptr(EVENT_POINTER, [0xdc, FLAG_OFFSET], bit1)
    }
},
"Pirate Island":{
    "id": 0x6,
    "world_name": "Pirate Island",
    "rp_name": "in Pirate Island",
    "quip_name": "Island",   
    "helmets": {
        "Bellyflop by the Lighthouse": ptr(DIAMOND_HELMET_POINTER, [0x14, FLAG_OFFSET], bit1),
        "Record Ascent": ptr(DIAMOND_HELMET_POINTER, [0x18, FLAG_OFFSET], bit1),
        "Out of the Right Eye": ptr(DIAMOND_HELMET_POINTER, [0x1c, FLAG_OFFSET], bit1),
        "Out of the Left Eye": ptr(DIAMOND_HELMET_POINTER, [0x20, FLAG_OFFSET], bit1),
        "Booty in the Sand": ptr(DIAMOND_HELMET_POINTER, [0x24, FLAG_OFFSET], bit1)
    },
    "events": {
        "Boss door opened": ptr(EVENT_POINTER, [0x5c, FLAG_OFFSET], bit1),
        "Toll gate": ptr(EVENT_POINTER, [0x6c, FLAG_OFFSET], bit1),
        "Left skull flame lit": ptr(EVENT_POINTER, [0x1a0, FLAG_OFFSET], bit1),
        "Right skull flame lit ": ptr(EVENT_POINTER, [0x1a4, FLAG_OFFSET], bit1),
        "Door with three buttons in front opened": ptr(EVENT_POINTER, [0x1c8, FLAG_OFFSET], bit1)
    }
},
"SeizeUs Palace":{
    "id": 0x7,
    "world_name": "SeizeUs Palace",
    "rp_name": "in SeizeUs Palace",
    "quip_name": "Palace",   
    "helmets": {
        "Crazy Elevator": ptr(DIAMOND_HELMET_POINTER, [0x00, FLAG_OFFSET], bit1),
        "Skyscraper": ptr(DIAMOND_HELMET_POINTER, [0x04, FLAG_OFFSET], bit1),
        "Garden Level Zero": ptr(DIAMOND_HELMET_POINTER, [0x08, FLAG_OFFSET], bit1),
        "Leap of Faith": ptr(DIAMOND_HELMET_POINTER, [0x0c, FLAG_OFFSET], bit1),
        "Emperor's Laurels": ptr(DIAMOND_HELMET_POINTER, [0x10, FLAG_OFFSET], bit1) // Before final boss in the pillar
    },
    "events": {
        "Ambush fight completed": ptr(EVENT_POINTER, [0x1c, FLAG_OFFSET], bit1),
        "Roulette door opened": ptr(EVENT_POINTER, [0x28, FLAG_OFFSET], bit1),
        "Blue roulette panel broken": ptr(EVENT_POINTER, [0x1ec, FLAG_OFFSET], bit1),
        "Yellow roulette panel  ": ptr(EVENT_POINTER, [0x1f0, FLAG_OFFSET], bit1),
        "Red roulette panel broken": ptr(EVENT_POINTER, [0x1f4, FLAG_OFFSET], bit1),
        "Green roulette panel broken": ptr(EVENT_POINTER, [0x1f8, FLAG_OFFSET], bit1)
    }
},
"Boss Area Venetia":{
    "id": 0x8,
    "world_name": "Boss Area Venetia",
    "rp_name": "facing the boss of Venetia",
    "quip_name": "", // none
    "helmets": {}, // none
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x0c, FLAG_OFFSET], bit1)
    }
},
"Boss Area LuckSore":{
    "id": 0x9,
    "world_name": "Boss Area LuckSore",
    "rp_name": "facing the boss of LuckSore",
    "quip_name": "", // none
    "helmets": {}, // none
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x08, FLAG_OFFSET], bit1)
    }
},
"Boss Area Pirate Island":{
    "id": 0x0a,
    "world_name": "Boss Area Pirate Island",
    "rp_name": "facing the boss of Pirate Island",
    "quip_name": "", // none
    "helmets": {}, // none
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x00, FLAG_OFFSET], bit1)
    }
},
"Boss Area SeizeUs Palace":{
    "id": 0x0b,
    "world_name": "Boss Area SeizeUs Palace",
    "rp_name": "facing the boss of SeizeUs Palace",
    "quip_name": "", // none
    "helmets": {}, // none
    "events": {
        // none
    }
}
}


// Achievements
achievement(
        title = "TESTING",
        description = "A COOL TEST",
        points = 10,
        id = 0,
        trigger=WORLD_DATA[0]["helmets"]["Four Torches"] == 1

)

for world_name in WORLD_DATA {
    current_world_data = WORLD_DATA[world_name]
    if (length(current_world_data["helmets"]) == 5) {
        achievement(
        title = format("debug The {0}'s Treasures", current_world_data["quip_name"]),
        description = format("Find every diamond helmet {0}", current_world_data["rp_name"]),
        points = 10,
        id = 0,
        trigger =
            measured(
                sum_of(
                    current_world_data["helmets"],
                    key => current_world_data["helmets"][key]
                ) == 5
            )
            &&
            sum_of(
                current_world_data["helmets"],
                key => prev(current_world_data["helmets"][key])
            ) == 4
    )
    }
}