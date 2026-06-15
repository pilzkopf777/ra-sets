// Astérix at the Olympic Games
// #ID = 22598

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


current_location = ptr(dword(0x006cbd00), [0x160], dword)
current_sport = ptr(dword(0x006cbd00), [0x12FA], byte)

multiplier = ptr(dword(0x006cbd00), [0x518], byte)
combo = ptr(dword(0x006cbd00), [0x534], byte)
romans_in_sky = ptr(dword(0x006cbd00), [0x544], byte)

hp_remaining = ptr(dword(0x90fd60), [0x19], byte)
max_hp = ptr(dword(0x90fd60), [0x1A], byte)

helmets = ptr(dword(0x90fd60), [0x1C], dword)

glue = ptr(dword(0x90fd60), [0x2C], byte)
magnesia = ptr(dword(0x90fd60), [0x2D], byte)

total_pigeons_left = 0
for element in range(0x04, 0x1F4, 0x14) {
    current_pidgeon_adr = ptr(dword(0x92889c), [0x84, element], dword)
    total_pigeons_left = total_pigeons_left + current_pidgeon_adr
}
pigeons = 50 - total_pigeons_left

upgrades_unlocked = bitcount(ptr(dword(0x90fd60), [0x3A], byte) + ptr(dword(0x90fd60), [0x3B], byte)) // 9 in total

olympics_score = ptr(dword(0x6cbd00), [0x41C, 0x18C], dword)


target = 5000
achievement(
    title = "LONG_JUMP_SCORE",
    points = 0,
    description = format("Score {0} or more points in the Long Jump event", target),
    trigger = 
    (
        // in-game?
        current_sport == 0x01 &&
        olympics_score >= target && prev(olympics_score < target)
    )
)

achievement(
    title = "50_PIGEONS",
    points = 0,
    description = "...",
    trigger = 
    (
        // in-game?
        pigeons == 50 && prev(pigeons < 50)
    )
)

achievement(
    title = "50_COMBO",
    points = 0,
    description = "Reach a combo of 50 hits",
    trigger = 
    (
        // in-game?
        combo >= 50 && prev(combo < 50)
    )
)

achievement(
    title = "40_MULT",
    points = 0,
    description = "Earn a multiplier of 40 or higher",
    trigger = 
    (
        // in-game?
        multiplier >= 40 && prev(multiplier < 40)
    )
)

achievement(
    title = "ALL_MOVES",
    points = 0,
    description = "Unlock all moves",
    trigger = 
    (
        // game paused?
        // in-game?
        current_location == 0x02 &&
        upgrades_unlocked == 9 && prev(upgrades_unlocked == 8)
    )
)

achievement(
    title = "ALL_GLUE",
    points = 0,
    description = "Collect all glue",
    trigger = 
    (
        // game paused?
        // in-game?
        glue == 3 && prev(glue == 2)
    )
)

achievement(
    title = "ALL_MAGNESIA",
    points = 0,
    description = "Collect all magnesia",
    trigger = 
    (
        // game paused?
        // in-game?
        magnesia == 3 && prev(magnesia == 2)
    )
)


// Rich Presence
WorldLookup = {
    0x01: "in the Forest of Carnutes",
    0x08: "outside the Olympic Vilage",
    0x02: "inside the Olympic Vilage",
    0x0b: "partaking in the Olympic Games",
    0x03: "on their way to the red cypress trees",
    0x09: "inside Doctormabus' Lair",
    0x06: "chasing Doctormabus",
    0x04: "in the VIP Zone",
    0x05: "in the City",
    0x0a: "in the Catacombs"
}

SportLookup = {
    0x00: "the Long Jump",
    0x01: "the Foot Race",
    0x02: "the Tug of War",
    0x03: "Toadball",
    0x04: "King of the Arena",
    0x05: "Hammer Throwing",
    0x06: "Javelin",
    0x07: "the Romanophone",
    0x08: "the Chariot Race"
}


// rich_presence_conditional_display(SAVE_GAME_STATE == 0, "Asterix & Obelix are in the main menu")

rich_presence_conditional_display(always_true(), "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", current_location, WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_conditional_display(current_location == 0xffffffff, "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", prior(current_location), WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_conditional_display(always_true(), "{0} is partaking in {3} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", current_location, WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons),
    rich_presence_lookup("Sport", current_sport, SportLookup, fallback="an unknown dicipline")
)

rich_presence_display("Playing Asterix at the Olympic Games")
