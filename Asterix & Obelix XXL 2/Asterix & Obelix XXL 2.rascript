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
diamond_helmet_state = ptr(pointer_to_loads_of_data(), [0x80, 0x38, 0x0c, 0x154], dword)

WORLD_DATA = [{
    "id": 0x1,
    "world_name": "Lutetia",
    "rp_name": "in Lutetia",
    "quip_name": "City",
    "helmets": {
        "Four Torches": 0x74, // Player is not forced to collect it but loading a chapter will mark this as collected
        "Cruising": 0x70,
        "Triumphal Arch": 0x6c,
        "Eiffel Tower": 0x68,
        "Obelisk": 0x64
    }
},
{
    "id": 0x2,
    "world_name": "Venetia",
    "rp_name": "in Venetia",
    "quip_name": "Canal",
    "helmets": {
        "Saint Mark's Cage": 0x60,
        "Canal Bumper Jumper": 0x5c,
        "Rooftop Slides": 0x58,
        "Going Underground": 0x54,
        "Little Stone Bridge": 0x50
    }
},
{
    "id": 0x3,
    "world_name": "WCW",
    "rp_name": "in the WCW",
    "quip_name": "Arena",
    "helmets": {
        "Challenge 1": 0x4c, // Player is forced to collect Challenge 1-4.
        "Challenge 3": 0x48, // That is the actual order!
        "Challenge 2": 0x44,
        "Challenge 4": 0x40,
        "Fake Gaulish Village": 0x3c
    }
},
{
    "id": 0x4,
    "world_name": "LuckSore",
    "rp_name": "in LuckSore",
    "quip_name": "Pyramid",   
    "helmets": {
        "Secret of the Secret Passage": 0x28,
        "Beneath the Sphinx": 0x2c,
        "One flew over the Tortoise": 0x30,
        "Crown of Palms": 0x34,
        "Refreshing Shower": 0x38
    }
},
{
    "id": 0x6,
    "world_name": "Pirate Island",
    "rp_name": "in Pirate Island",
    "quip_name": "Island",   
    "helmets": {
        "Bellyflop by the Lighthouse": 0x14,
        "Record Ascent": 0x18,
        "Out of the Right Eye": 0x1c,
        "Out of the Left Eye": 0x20,
        "Booty in the Sand": 0x24
    }
},
{
    "id": 0x7,
    "world_name": "SeizeUs Palace",
    "rp_name": "in SeizeUs Palace",
    "quip_name": "Palace",   
    "helmets": {
        "Crazy Elevator": 0x00,
        "Skyscraper": 0x04,
        "Garden Level Zero": 0x08,
        "Leap of Faith": 0x0c,
        "Emperor's Laurels": 0x10 // Before final boss in the pillar
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
                    key => bit1(dword(diamond_helmet_state + world["helmets"][key]) + 0x14)
                ) == 5
            )
            &&
            sum_of(
                world["helmets"],
                key => prev(bit1(dword(diamond_helmet_state + world["helmets"][key]) + 0x14))
            ) == 4
    )
    }
    
}