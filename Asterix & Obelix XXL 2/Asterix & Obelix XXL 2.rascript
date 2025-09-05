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
DIAMOND_HELMET_POINTER = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, 0x154], dword)

PLAYER_DATA = {
    "world": prt(pointer_to_loads_of_data(), [0x48, 0x1d], byte),
    "subarea": prt(pointer_to_loads_of_data(), [0x48, 0x1e], byte),
    "helmets": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x40], dword),
    "hp": {
        "shields": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3c], byte), // 0x00 - 0x06
        "shield_parts": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3d], byte) // 0x00 (none) - 0x04 (full)
    },
    "multiplier": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x3e], word),
    "playtime": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x48], float),
    "enemies_defeated": prt(pointer_to_loads_of_data(), [0x80, 0x5c, 0x44], dword),
    "magic_potion": {
        "active": prt(pointer_to_loads_of_data(), [0x80, 0xa0, 0x3c], bit0),
        "timer": prt(pointer_to_loads_of_data(), [0x80, 0xa0, 0x44], float)
    }
}

CHALLENGE_TIMERS = {
    "lava": prt(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x00, 0x04], float),
    "target": prt(pointer_to_loads_of_data(), [0x80, 0x524, 0x5ac, 0x04, 0x04], float)
}

WORLD_DATA = [{
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
        "Switch on top of Eiffel Tower opening boat ride path": 0x178,
        "Door to Arc de Triomphe opening": 0x18c,
        "Security System 4th torch lit": 0x190,
        "Security System 3rd torch lit": 0x194,
        "Security System 2nd torch lit": 0x198,
        "Security System 1st torch lit": 0x19c,
        "Mario reveal outside Las Vegum": 0x210,
        "Toll gate to Venetia": 0x25c,
        "Toll gate to LuckSore": 0x264
    }
},
{
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
        "Boss door opened": 0x12c,
        "Torch for filling targets on plaza": 0x18c,
        "Torch in Asterix route on plaza": 0x1b0,
        "Torch in Obelix route on plaza": 0x1b4,
        "Lever to open door in trench area with merchant": 0x1bc,
        "Obelix torch in front of boss gate": 0x1c0,
        "Asterix torch in front of boss gate": 0x1c4,
        "Panel stomped in 1st trench": 0x220
    }
},
{
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
        "Internetus switch turned on": 0xf8,
        "Door to village opened": 0xfc,
        "Challenge 4 completed": 0x108,
        "Challenge 3 completed": 0x10c,
        "Challenge 2 completed": 0x110,
        "Challenge 1 completed": 0x114,
        "Door to Pirate Island and Palace opened": 0x234
    }
},
{
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
    }
},
{
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
    }
},
{
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
    }
},
{
    "id": 0x8,
    "world_name": "Boss Area Venetia",
    "rp_name": "facing the boss of Venetia",
    "quip_name": "", // none
    "helmets": {} // none
},
{
    "id": 0x9,
    "world_name": "Boss Area LuckSore",
    "rp_name": "facing the boss of LuckSore",
    "quip_name": "", // none
    "helmets": {} // none
},
{
    "id": 0x0a,
    "world_name": "Boss Area Pirate Island",
    "rp_name": "facing the boss of Pirate Island",
    "quip_name": "", // none
    "helmets": {} // none
},
{
    "id": 0x0b,
    "world_name": "Boss Area SeizeUs Palace",
    "rp_name": "facing the boss of SeizeUs Palace",
    "quip_name": "", // none
    "helmets": {} // none
}
]

achievement(
        title = "TESTING",
        description = "A COOL TEST",
        points = 10,
        id = 0,
        trigger=WORLD_DATA[0]["helmets"]["Four Torches"] == 1

)

// Achievements
for world in WORLD_DATA {
    if (length(world["helmets"]) == 5) {
        achievement(
        title = format("debug The {0}'s Treasures", world["quip_name"]),
        description = format("Find every diamond helmet {0}", world["rp_name"]),
        points = 10,
        id = 0,
        trigger =
            measured(
                sum_of(
                    world["helmets"],
                    key => world["helmets"][key]
                ) == 5
            )
            &&
            sum_of(
                world["helmets"],
                key => prev(world["helmets"][key])
            ) == 4
    )
    }
}