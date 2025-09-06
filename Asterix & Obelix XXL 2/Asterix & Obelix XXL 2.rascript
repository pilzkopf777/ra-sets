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

// Global access function
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

ASTERIX_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x08, 0x28, 0x04], dword)
OBELIX_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x08, 0x28, 0x96c], dword)

IN_ENGINE_CUTSCENE_STATE =  ptr(pointer_to_loads_of_data(), [0x74, 0x0c], byte)
PAUSE_MENU_STATE = ptr(pointer_to_loads_of_data(), [0x44, 0x04, 0x30], byte)
SAVE_GAME_STATE = ptr(pointer_to_loads_of_data(), [0x80, 0x5f4], byte)

COMBAT_LOCK_COUNT = ptr(pointer_to_loads_of_data(), [0x88, 0xc4, 0x20], byte) // enemies left on a combat lock
WCW_TARGET_COUNT = ptr(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x3c, 0x04], byte) // enemies left in the wcw target challenge

DYNAMIC_ITEM_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x0c, 0x2c], dword)
DYNAMIC_ITEM_COUNT = ptr(pointer_to_loads_of_data(), [0x80, 0x0c, 0x30], word) // amount of dynamic items in current subarea

INTERACTIVE_ITEM_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x90], dword)

PLAYER_DATA = {
    "world": ptr(pointer_to_loads_of_data(), [0x48, 0x1d], byte),
    "subarea": ptr(pointer_to_loads_of_data(), [0x48, 0x1e], byte),
    "helmets": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x40], dword),
    "hp": {
        "shields": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3c], byte), // 0x00 - 0x06
        "shield_parts": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3d], byte) // 0x00 (none) - 0x04 (full)
    },
    "character_in_control": ptr(ASTERIX_POINTER, [0x25], byte), // 0x00 = asterix, 0x01 = obelix
    "multiplier": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3e], word),
    "playtime": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x48], float),
    "enemies_defeated": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x44], dword),
    "magic_potion": {
        "active": ptr(pointer_to_loads_of_data(), [0x80, 0xa0, 0x3c], bit0),
        "timer": ptr(pointer_to_loads_of_data(), [0x80, 0xa0, 0x44], float)
    },
    "final_postcard": ptr(pointer_to_loads_of_data(), [0x80, 0x5c, 0x66], bit0), // postcard #24 is the last one you can buy
    "character": {
        "asterix":
        {
            "control_freeze": ptr(ASTERIX_POINTER, [0x0c], byte),
            "current_move": ptr(ASTERIX_POINTER, [0xf4], byte),
            "coordinates": {
                "x": ptr(ASTERIX_POINTER, [0x3d4], float),
                "y": ptr(ASTERIX_POINTER, [0x3d8], float),
                "z": ptr(ASTERIX_POINTER, [0x3dc], float)
            },
            "jump_state": ptr(ASTERIX_POINTER, [0x40c], byte),
            "flame_state": ptr(ASTERIX_POINTER, [0x575], byte)
        },   
        "obelix":
        {
            "control_freeze": ptr(OBELIX_POINTER, [0x0c], byte),
            "current_move": ptr(OBELIX_POINTER, [0xf4], byte),
            "coordinates": {
                "x": ptr(OBELIX_POINTER, [0x3d4], float),
                "y": ptr(OBELIX_POINTER, [0x3d8], float),
                "z": ptr(OBELIX_POINTER, [0x3dc], float)
            },
            "jump_state": ptr(OBELIX_POINTER, [0x40c], byte),
            "flame_state": ptr(OBELIX_POINTER, [0x575], byte)
        }
    }    
}

CHALLENGE_TIMERS = {
    "lava": ptr(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x00, 0x04], float),
    "target": ptr(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x04, 0x04], float)
}

CUPOLA_DATA = {
    "height_right": ptr(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29e0, 0xf8], float),
    "height_middle": ptr(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29ec, 0xf8], float),
    "height_left": ptr(pointer_to_loads_of_data(), [0x8c, 0x0c, 0x29f8, 0xf8], float)
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
        "Torch 3 in bomb push area lit": ptr(EVENT_POINTER, [0x8c, FLAG_OFFSET], bit1),
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
    "quip_name": "",
    "helmets": {

    },
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x0c, FLAG_OFFSET], bit1)
    }
},
"Boss Area LuckSore":{
    "id": 0x9,
    "world_name": "Boss Area LuckSore",
    "rp_name": "facing the boss of LuckSore",
    "quip_name": "",
    "helmets": {

    },
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x08, FLAG_OFFSET], bit1)
    }
},
"Boss Area Pirate Island":{
    "id": 0x0a,
    "world_name": "Boss Area Pirate Island",
    "rp_name": "facing the boss of Pirate Island",
    "quip_name": "",
    "helmets": {

    },
    "events": {
        "Boss Clear": ptr(EVENT_POINTER, [0x00, FLAG_OFFSET], bit1)
    }
},
"Boss Area SeizeUs Palace":{
    "id": 0x0b,
    "world_name": "Boss Area SeizeUs Palace",
    "rp_name": "facing the boss of SeizeUs Palace",
    "quip_name": "",
    "helmets": {

    },
    "events": {
        // none
    }
}
}

// Helper functions for common use-cases

// True, when an in-game cutscene ends
// User can either do this by watching / skipping through it normally or alternatively by quitting to the main menu
function in_engine_cutscene_has_ended() {
    return PAUSE_MENU_STATE == 2 && prev(PAUSE_MENU_STATE == 1) || IN_ENGINE_CUTSCENE_STATE == 0 && prev(IN_ENGINE_CUTSCENE_STATE == 1)
}

// Get diamond helmet count in a world, max is 5
// world_name = String, name of world
function count_helmets_in_world(world_name) {
    return sum_of(
        WORLD_DATA[world_name]["helmets"],
        key => WORLD_DATA[world_name]["helmets"][key]
    )
}

// Get diamond helmet count in total (all worlds), max is 30
function count_all_helmets() {
    return sum_of(
        WORLD_DATA,
        world_name => count_helmets_in_world(world_name)
    )
}

// True, when sphinx with diamond helmet in LuckSore is broken
// Not related to collecting the diamond helmet
function sphinx_with_diamond_helmet_is_broken() {
    // 0x144 is always the sphinx with the diamond helmet
    return ptr(DYNAMIC_ITEM_POINTER, [0x144, 0x34, 0x10], byte) == 4
}

// In-game timer advanced
function in_game_timer_tick() {
    return PLAYER_DATA["playtime"] > prev(PLAYER_DATA["playtime"])
}

// True, when the combat lock ticked from 1 to 0
// A combat lock is the red lock on the right side of the screen
// This does NOT include the WCW target lock for the targets challenge
function combat_lock_cleared() {
    return COMBAT_LOCK_COUNT == 0 && prev(COMBAT_LOCK_COUNT > 0)
}

// True, when the player is dead as they have no shields / hp left
// Also counts when jumping in pits or deathplanes etc
function player_died() {
    return PLAYER_DATA["hp"]["shields"] == 0 && PLAYER_DATA["hp"]["shield_parts"] == 0
}

// Is the player in an automatically moving cablecart?
function player_is_in_automatic_cablecart() {
    return ptr(INTERACTIVE_ITEM_POINTER, [0x00], dword) == 0x005786a0
}

// Is the player doing a looping?
function player_is_performing_looping() {
    return player_is_in_automatic_cablecart() && ptr(INTERACTIVE_ITEM_POINTER, [0x1f4], float) != 1000.0 && ptr(INTERACTIVE_ITEM_POINTER, [0x1f4], float) != 0.0
}


// Achievements

// Progression
achievement(
    title = "debug What Happens in Las Vegum...", points = 2, type="progression",
    description = "Outsmart the security system of Las Vegum",
    trigger=
        // Player is in world 1...
        PLAYER_DATA["world"] == 1 &&
        // ...and in subarea 1
        PLAYER_DATA["subarea"] == 1 &&
        // This is the condition when the achievement will activate (after the related cutscene plays)
        WORLD_DATA["Lutetia"]["events"]["Security System 4th torch lit"] == 1 &&
        // This should be false. If it's not, the player used the chapter menu to skip ahead and shouldn't get the unlock
        WORLD_DATA["Lutetia"]["events"]["Toll gate to Venetia"] == 0 &&
        // Actual mem/delta check happens here: Unlock the achievement once the cutscene ends
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Veni, Vidi, Venetia", points = 3, type="progression",
    description = "Pay the toll and gain access to Venetia",
    trigger = 
        PLAYER_DATA["world"] == 1 &&
        PLAYER_DATA["subarea"] == 2 &&
        // There's no cutscene for the toll gate flag so do a basic mem/delta here
        WORLD_DATA["Lutetia"]["events"]["Toll gate to Venetia"] == 1 &&
        prev(WORLD_DATA["Lutetia"]["events"]["Toll gate to Venetia"] == 0)
)

achievement(
    title = "debug Open Says Me", points = 3, type="progression",
    description = "Open the door at the end of Venetia",
    trigger = 
        PLAYER_DATA["world"] == 2 &&
        PLAYER_DATA["subarea"] == 5 &&
        WORLD_DATA["Venetia"]["events"]["Boss door opened"] == 1 &&
        WORLD_DATA["Boss Area Venetia"]["events"]["Boss Clear"] == 0 &&
        (
           in_engine_cutscene_has_ended() 
        )
)

achievement(
    title = "debug Enter the Dethmach", points = 5, type="progression",
    description = "Defeat Dethmach",
    trigger = 
        PLAYER_DATA["world"] == 8 &&
        PLAYER_DATA["subarea"] == 255 &&
        WORLD_DATA["Boss Area Venetia"]["events"]["Boss Clear"] == 0 &&
        WORLD_DATA["Lutetia"]["events"]["Toll gate to LuckSore"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Welcome to Casino Night", points = 3, type="progression",
    description = "Pay the toll and gain access to LuckSore",
    trigger = 
        PLAYER_DATA["world"] == 1 &&
        PLAYER_DATA["subarea"] == 6 &&
        WORLD_DATA["Lutetia"]["events"]["Toll gate to LuckSore"] == 1 &&
        prev(WORLD_DATA["Lutetia"]["events"]["Toll gate to LuckSore"] == 0)
)

achievement(
    title = "debug Laser Focused", points = 3, type="progression",
    description = "Use the lights to open the giant door in LuckSore",
    id = 532225, badge = "608397", published = "14/07/2025 22:10:48", modified = "23/07/2025 18:38:02",
    trigger = 
        PLAYER_DATA["world"] == 4 &&
        PLAYER_DATA["subarea"] == 2 &&
        WORLD_DATA["LuckSore"]["events"]["Boss door opened"] == 1 &&
        WORLD_DATA["Boss Area LuckSore"]["events"]["Boss Clear"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Dethmach Reloaded", points = 5, type="progression",
    description = "Defeat Dethmach again",
    trigger = 
        PLAYER_DATA["world"] == 9 &&
        PLAYER_DATA["subarea"] == 255 &&
        WORLD_DATA["Boss Area LuckSore"]["events"]["Boss Clear"] == 0 &&
        CUTSCENE_DATA["Saving 2nd prisoner"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Galactic Gladiator", points = 3, type="progression",
    description = "Become the champion of the WCW",
    trigger =
        PLAYER_DATA["world"] == 3 &&
        PLAYER_DATA["subarea"] == 6 &&
        WORLD_DATA["WCW"]["events"]["Door to village opened"] == 1 &&
        CUTSCENE_DATA["Fake village in WCW"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Tomb Raided", points = 10, type="progression",
    description = "Survive the ambush and defeat Caesar's henchman",
    trigger =
        PLAYER_DATA["world"] == 3 &&
        PLAYER_DATA["subarea"] == 8 &&
        WORLD_DATA["WCW"]["events"]["Door to Pirate Island and Palace opened"] == 1 &&
        prev(WORLD_DATA["WCW"]["events"]["Door to Pirate Island and Palace opened"] == 0)
)

achievement(
    title = "debug Eyes on Me", points = 3, type="progression",
    description = "Light up the eyes of the skull",
    trigger = 
        PLAYER_DATA["world"] == 6 &&
        PLAYER_DATA["subarea"] == 1 &&
        WORLD_DATA["Pirate Island"]["events"]["Boss door opened"] == 1 &&
        WORLD_DATA["Boss Area Pirate Island"]["events"]["Boss Clear"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)    
    
achievement(
    title = "debug Dethmach with a Vengeance", points = 5, type="progression",
    description = "Defeat Dethmach yet again",
    trigger =
        PLAYER_DATA["world"] == 10 &&
        PLAYER_DATA["subarea"] == 255 &&
        WORLD_DATA["Boss Area Pirate Island"]["events"]["Boss Clear"] == 0 &&
        CUTSCENE_DATA["Saving 3rd prisoner"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug The House Always Loses", points = 3, type="progression",
    description = "Destroy the roulette wheel and open the door",
    trigger =
        PLAYER_DATA["world"] == 7 &&
        PLAYER_DATA["subarea"] == 1 &&
        WORLD_DATA["SeizeUs Palace"]["events"]["Roulette door opened"] == 1 &&
        WORLD_DATA["SeizeUs Palace"]["events"]["Ambush fight completed"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Do Movie References Count?", points = 10, type="progression",
    description = "Defeat the foes at the top of SeizeUs Palace",
    trigger = 
        PLAYER_DATA["world"] == 7 &&
        PLAYER_DATA["subarea"] == 7 &&
        WORLD_DATA["SeizeUs Palace"]["events"]["Ambush fight completed"] == 1 &&
        CUTSCENE_DATA["Ending"] == 0 &&
        (
            in_engine_cutscene_has_ended()
        )
)

achievement(
    title = "debug Park's Closed Forever", points = 25, type="win_condition",
    description = "Defeat Dethmach one last time",
    trigger = 
        PLAYER_DATA["world"] == 11 &&
        PLAYER_DATA["subarea"] == 255 &&
        CUTSCENE_DATA["Caesar defeated"] == 1 &&
        // Only the in-engine cutscene state flag should be used for tracking since this is the end of the game
        // The player should not be able to access the pause menu to go back to the main menu in a cutscene
        IN_ENGINE_CUTSCENE_STATE == 0 && prev(IN_ENGINE_CUTSCENE_STATE == 1)
)

// Souvenier shops
achievement(
    title = "debug What're Ya Buyin'?", points = 5,
    description = "Find the merchant area in Venetia",
    trigger =
        PLAYER_DATA["world"] == 2 &&
        PLAYER_DATA["subarea"] == 4 &&
        SOUVENIER_DATA["Postcards / Venetia"] == 1 &&
        prev(SOUVENIER_DATA["Postcards / Venetia"]) == 0
)

achievement(
    title = "debug Shop and Awe", points = 5,
    description = "Find the merchant area in Lutetia",
    trigger =
        PLAYER_DATA["world"] == 1 &&
        PLAYER_DATA["subarea"] == 4 &&
        SOUVENIER_DATA["Character models / Lutetia"] == 1 &&
        prev(SOUVENIER_DATA["Character models / Lutetia"]) == 0
)

achievement(
    title = "debug Buy Julius!", points = 5,
    description = "Find the merchant area in LuckSore",
    trigger =
        PLAYER_DATA["world"] == 4 &&
        PLAYER_DATA["subarea"] == 1 &&
        SOUVENIER_DATA["Cutscenes / LuckSore"] == 1 &&
        prev(SOUVENIER_DATA["Cutscenes / LuckSore"]) == 0
)

// Buy all postcards
achievement(
    title = "debug Picture City", points = 10,
    description = "Purchase every image from the postcard souvenir shop",
    trigger = 
        // World 0 is the main menu
        PLAYER_DATA["world"] == 0 &&
        PLAYER_DATA["final_postcard"] == 1 &&
        prev(PLAYER_DATA["final_postcard"]) == 0
)

// Diamond helmet achievements
for world_name in WORLD_DATA {
    if (length(WORLD_DATA[world_name]["helmets"]) == 5) {
        achievement(
        title = format("debug The {0}'s Treasures", WORLD_DATA[world_name]["quip_name"]),
        description = format("Find every diamond helmet {0}", WORLD_DATA[world_name]["rp_name"]),
        points = 10,
        id = 0,
        trigger =
            measured(
                count_helmets_in_world(world_name) == 5
            )
            &&
            prev(count_helmets_in_world(world_name)) == 4
    )
    }
}

// Kill 1000 enemies
achievement(
    title = "debug Back to Rome", points = 4,
    description = "Defeat 1,000 Romans in total",
    trigger = 
        // Player is in any world, not the main menu
        PLAYER_DATA["world"] != 0 &&
        PLAYER_DATA["enemies_defeated"] >= 1000 &&
        prev(PLAYER_DATA["enemies_defeated"] < 1000)
)

// x50 mult
achievement(
    title = "debug Market Manipulation", points = 2,
    description = "Reach a x50 multiplier",
    trigger = 
        PLAYER_DATA["world"] != 0 &&
        PLAYER_DATA["multiplier"] >= 50 &&
        prev(PLAYER_DATA["multiplier"] < 50)
)

// 6 shields
achievement(
    title = "debug Impeccable Defense", points = 2,
    description = "Have six shields at the same time",
    trigger = 
        PLAYER_DATA["world"] != 0 &&
        // ["hp"]["shields"] tracks the amount of full shields remaining
        PLAYER_DATA["hp"]["shields"] == 6 &&
        // You can only reach 6 shields if you had at least 5 before since grabbing the item will increase the amount of full ones by 1
        prev(PLAYER_DATA["hp"]["shields"] == 5)
)

// Get diamond helmet without bomb
achievement(
    title = "debug No Bomb, No Problem", points = 4,
    description = "Earn the diamond helmet \"Beneath the Sphinx\" without using the bomb",
    trigger = 
        // Player must be in LuckSore
        never(PLAYER_DATA["world"] != 4) &&
        // Player collected the diamond helmet
        WORLD_DATA["LuckSore"]["helmets"]["Beneath the Sphinx"] == 1 &&
        prev(WORLD_DATA["LuckSore"]["helmets"]["Beneath the Sphinx"] == 0) &&
        // Check if the sphinx was broken using the magic potion
        // The potion will only be able to do this in the first 2.5 sec due to the explosion effects
        // You cannot prime the bomb and use the potion at the same time properly since the explosion would still cause the sphinx to break first
        once(
            PLAYER_DATA["magic_potion"]["timer"] < 2.5 &&
            sphinx_with_diamond_helmet_is_broken() && prev(!sphinx_with_diamond_helmet_is_broken())
        )
)

// Looping for 24sec
achievement(
    title = "debug Downhill Jam", points = 10,
    description = "Hold a looping in a cable cart for 24 seconds",
    trigger = 
        // Not in main menu
        never(PLAYER_DATA["world"] == 0) &&
        // Player is in automatic cablecart, performing a looping
        never(!player_is_performing_looping()) &&
        // 24 secs
        repeated(1200, in_game_timer_tick())
)

// Internetus dispenser
achievement(
    title = "debug Cheat Code", points = 2,
    description = "Enable the secret magic potion dispenser in the WCW",
    trigger =
        PLAYER_DATA["world"] == 3 &&
        PLAYER_DATA["subarea"] == 10 &&
        WORLD_DATA["WCW"]["events"]["Internetus switch turned on"] == 1 &&
        // Special type of cutscene for this - unlock the achievement after it ends (which is when the player can move again)
        PLAYER_DATA["character"]["asterix"]["control_freeze"] == 0 &&
        prev(PLAYER_DATA["character"]["asterix"]["control_freeze"] == 2)
)


// Challenge 1 extra
achievement(
    title = "debug Hot-Head Bop", points = 25,
    description = "Complete Challenge 1: Lava Pit in the WCW in 40 seconds or less",
    trigger =
        // Player must be in Challenge 1 arena, reset when leaving
        never(PLAYER_DATA["world"] != 3) &&
        never(PLAYER_DATA["subarea"] != 2) &&
        disable_when(
            // 2000 hits, gain a hit when the in-game timer ticks up
            // At 50Hz this equals 40 seconds
            // Thus, deny achievement after 40 seconds after the tutorial cutscene ends
            repeated(2000, in_game_timer_tick()),
        until=(COMBAT_LOCK_COUNT != 0) &&
            IN_ENGINE_CUTSCENE_STATE >= 1
        ) &&
        trigger_when(
            // Award achievement when all enemies are defeated
            combat_lock_cleared()
        ) &&
        never(
            // If player dies, instantly deny achievement
            // As a safeguard, also deny once the player respawns outside the arena (see never() subarea)
            player_died()
        )           
)

// Challenge 2 extra
achievement(
    title = "debug Potion Sickness", points = 10,
    description = "Complete Challenge 2: Mass Attack in the WCW without using a magic potion",
    trigger =
        // Player must be in Challenge 2 arena, reset when leaving
        never(PLAYER_DATA["world"] != 3) &&
        never(PLAYER_DATA["subarea"] != 3) &&
        disable_when(
            // Deny when the player gains a magic potion, be it from a Tip Bonus or the dispenser
            PLAYER_DATA["magic_potion"]["active"] == 1,
        until = IN_ENGINE_CUTSCENE_STATE >= 1
        ) &&
        trigger_when(
            combat_lock_cleared()
        ) &&
        never(
            player_died()
        )
)


// Challenge 3 extra
achievement(
    title = "debug High Ton", points = 25,
    description = "Complete Challenge 3: Targets in the WCW in 3 minutes or less",
    trigger = 
        // Player must be in Challenge 3 arena, reset when leaving
        never(PLAYER_DATA["world"] != 3) &&
        never(PLAYER_DATA["subarea"] != 4) &&
        disable_when(
            // 9000 hits, gain a hit when the in-game timer ticks up
            // At 50Hz this equals 3 minutes
            // Thus, deny achievement after 3 minutes after the tutorial cutscene ends
            repeated(9000, in_game_timer_tick()),
        until=(COMBAT_LOCK_COUNT != 0) &&
            IN_ENGINE_CUTSCENE_STATE >= 1
        ) &&
        trigger_when(
            // This challenge does not use a combat lock but a fancy floating counter in the arena
            WCW_TARGET_COUNT == 0 && prev(WCW_TARGET_COUNT > 0)
        ) &&
        never(
            player_died()
        )
)



// Challenge 4 extra
achievement(
    title = "debug Torchus Interruptus", points = 10,
    description = "Complete Challenge 4: Cupolas in the WCW without letting any cupolas be completed",
    trigger =
        // If any of the cupolas reach a height of 6.5, deny the achievement
        // The cupolas will rise to 6.5 during the tutorial cutscene so 1 hit is "free" and the 2nd hit denies the achievement
        disable_when(
            repeated(
                2, CUPOLA_DATA["height_right"] == 6.5 && prev(CUPOLA_DATA["height_right"] < 6.5)
            )
        ) && 
        disable_when(
            repeated(
                2, CUPOLA_DATA["height_middle"] == 6.5 && prev(CUPOLA_DATA["height_middle"] < 6.5)
            )
        ) && 
        disable_when(
            repeated(
                2, CUPOLA_DATA["height_left"] == 6.5 && prev(CUPOLA_DATA["height_left"] < 6.5)
            )
        ) && 
        trigger_when(
            combat_lock_cleared()
        ) &&
        // When the player dies or leaves, reset all hits
        // Done in an alt group since the disable_when() prevents a well timed reset
        (always_false() ||
            never(PLAYER_DATA["world"] != 3) &&
            never(PLAYER_DATA["subarea"] != 5) &&
            never(player_died())    
        )
)



// Smash attack
achievement(
    title = "debug Stylish!", points = 2,
    description = "Perform a Smash attack and earn a 3x multiplier",
    trigger =
        PLAYER_DATA["world"] != 0 &&
        // Pause menu not open / gameplay
        PAUSE_MENU_STATE == 0 &&
        (
            // Either Asterix or Obelix have to perform the move
            // ID 11 is the wind-up before the punch and 12 is the punch during the Smash combo itself
            PLAYER_DATA["character"]["asterix"]["current_move"] == 12 && prev(PLAYER_DATA["character"]["asterix"]["current_move"] == 11) ||
            PLAYER_DATA["character"]["obelix"]["current_move"] == 12 && prev(PLAYER_DATA["character"]["obelix"]["current_move"] == 11)
        )
)

// Play slots with enemy
// TODO: This seems to not play nice with RATools. Research that later..
/*
achievement(
    title = "Welcome to the Machine", points = 3,
    description = "Play a slot machine by throwing a Roman into it",
    trigger =
        for element in range(0, DYNAMIC_ITEM_COUNT, 1) {
            ptr(DYNAMIC_ITEM_POINTER, [element * 0x04], dword) == 0x57a6f0 && 
            once(
                ptr(DYNAMIC_ITEM_POINTER, [element * 0x04, 0xa1], byte) == 1 &&
                never(ptr(DYNAMIC_ITEM_POINTER, [element * 0x04, 0x34], byte) == 0)
            ) &&
            prev(ptr(DYNAMIC_ITEM_POINTER, [element * 0x04, 0x34], byte) == 2)
        }
)
*/

// Fury mode for 30sec
achievement(
    title = "debug Burning Knuckle", points = 3,
    description = "Stay in Fury mode for 30 seconds at once",
    trigger = 
        never(PLAYER_DATA["world"] != 0) &&
        // Being in the pause menu does not count, do not collect hits
        unless(PAUSE_MENU_STATE != 0) &&
        // 30sec target
        repeated(1500,
            // Earn hits while Asterix or Obelic have flames / are in Fury mode
            (PLAYER_DATA["character"]["asterix"]["flame_state"] == 3) || PLAYER_DATA["character"]["obelix"]["flame_state"] == 3
        ) &&
        never(
            // The moment they lose them reset the hit count
            (PLAYER_DATA["character"]["asterix"]["flame_state"] == 0) && PLAYER_DATA["character"]["obelix"]["flame_state"] == 0
        )
)

// Climb Internetus in 35sec
achievement(
    title = "debug To the Top of the Fortress", points = 10,
    description = "Starting from the platform next to the pipe, reach the top of the tower in the Internetus area in 35 seconds or less",
    trigger =
        // Player must be in Internetus area
        never(PLAYER_DATA["world"] != 3) &&
        never(PLAYER_DATA["subarea"] != 10) &&
        // Logic is seperated into two alt groups since mixing the two can cause issues - the NPC companion likes to sometimes jump around aimlessly at the pipe base.
        // If this were to happen during the final checks for this achievement the player might lose eligibility which would be very confusing.
        // Player coordinates may not properly update for the character not in control so this is safer. 
        (
            // Alt group 1: Logic for Asterix
            (
                PLAYER_DATA["character_in_control"] == 0 &&
                disable_when(
                    // Player fell or tried to cheat by taking a shortcut that enables after clearing the area - disable until...
                    PLAYER_DATA["character"]["asterix"]["coordinates"]["x"] < -158.0 &&
                    PLAYER_DATA["character"]["asterix"]["coordinates"]["y"] < -1.0,
                until=
                    // ... the player is at starting platform with the pipe - enable the achievement / Trigger again
                    PLAYER_DATA["character"]["asterix"]["coordinates"]["x"] > 158.0
                ) &&
                disable_when(
                    // Also disable the achievement if the player took too long.
                    repeated(1750, in_game_timer_tick()),
                until=
                    // Does not collect hits when the player is at the starting platform due to ResetIf. As a result, you may stand at the start as much as you like - the timer starts once you start moving
                    PLAYER_DATA["character"]["asterix"]["coordinates"]["x"] > -158.0
                ) &&
                trigger_when(
                    // Trigger the achievement if the player did not reset is previously (i.e. fell down or took too long) and additionally...
                    once(
                        once((
                            // ...they reached the top of the tower...
                            once(PLAYER_DATA["character"]["asterix"]["coordinates"]["y"] > 15.9)
                            ) &&
                            prev(PLAYER_DATA["character"]["asterix"]["coordinates"]["y"]) <= 15.9
                        ) &&
                        // ...and they stood on it (i.e. are not jumping, must be grounded for it to count)
                        PLAYER_DATA["character"]["asterix"]["jump_state"] == 0xff
                    )
                )
            ) ||
            // Alt group 2: Logic for Obelix
            // Comments from above apply here as well
            (
                PLAYER_DATA["character_in_control"] == 1 &&
                disable_when(
                    PLAYER_DATA["character"]["obelix"]["coordinates"]["x"] < -158.0 &&
                    PLAYER_DATA["character"]["obelix"]["coordinates"]["y"] < -1.0,
                until=
                    PLAYER_DATA["character"]["obelix"]["coordinates"]["x"] > 158.0
                ) &&
                disable_when(
                    repeated(1750, in_game_timer_tick()),
                until=
                    PLAYER_DATA["character"]["obelix"]["coordinates"]["x"] > -158.0
                ) &&
                trigger_when(
                    once(
                        once((
                            once(PLAYER_DATA["character"]["obelix"]["coordinates"]["y"] > 15.9)
                            ) &&
                            prev(PLAYER_DATA["character"]["obelix"]["coordinates"]["y"]) <= 15.9
                        ) &&
                        PLAYER_DATA["character"]["obelix"]["jump_state"] == 0xff
                    )
                )
            )
        )

)

// Rich Presence
// todo: This is also present in WORLD_DATA so it would probably be better to pull the data from there instead..
WorldLookup = {
    0: "in the Main Menu",
    1: "in Lutetia",
    2: "in Venetia",
    3: "in the WCW",
    4: "in LuckSore",
    6: "in Pirate Island",
    7: "in SeizeUs Palace",
    8: "facing the boss of Venetia",
    9: "facing the boss of LuckSore",
    10: "facing the boss of Pirate Island",
    11: "facing the boss of SeizeUs Palace",
}


rich_presence_conditional_display(SAVE_GAME_STATE == 0, "Asterix & Obelix are preparing to set out to Las Vegum")
rich_presence_conditional_display(SAVE_GAME_STATE == 1, "Asterix & Obelix are {0} • Helmets: {1} • Diamond Helmets: {2} / 30",
    rich_presence_lookup("World", PLAYER_DATA["world"], WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", PLAYER_DATA["helmets"]),
    rich_presence_value("Diamond Helmets", count_all_helmets())
)

rich_presence_display("Playing Asterix & Obelix XXL 2: Mission - Las Vegum")
