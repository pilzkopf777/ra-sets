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

function game_has_booted_up() {
    return dword(0x006cbd00) != 0x00
}

function is_playing_sports() {
    return current_location == 0x0b
}

function not_in_main_menu() {
    return current_location != 0x00
}

current_location = ptr(dword(0x006cbd00), [0x160], dword)
current_sport = ptr(dword(0x006cbd00), [0x12FA], byte)

sports_char_p1 = ptr(dword(0x006cbd00), [0x1220], byte)

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
movies_unlocked = bitcount(ptr(dword(0x90fd60), [0x3C], byte)) +
                  bitcount(ptr(dword(0x90fd60), [0x3D], byte)) // 16 in total

olympics_score = ptr(dword(0x6cbd00), [0x41C, 0x18C], dword)

event_flags = {
    "all_disciplines_cleared": ptr(dword(0x928628), [0x14], byte) == 0xCF,
    "exited_lair": ptr(dword(0x9286a4), [0x14], byte) == 0xCF,
    "brutus_door_opened": ptr(dword(0x928730), [0x14], byte) == 0xCF,
    "caught_doctor": ptr(dword(0x92874c), [0x14], byte) == 0xCF,
    "opened_doctor_lair_door": ptr(dword(0x928798), [0x14], byte) == 0xCF,
    "opened_vip_zone_door": ptr(dword(0x9287ac), [0x14], byte) == 0xCF,
    "back_to_village": ptr(dword(0x9287c8), [0x14], byte) == 0xCF,
    "opened_door_path_to_lair": ptr(dword(0x928824), [0x14], byte) == 0xCF,
    "first_dart_board_done": ptr(dword(0x92882c), [0x14], byte) == 0xCF
}

achievement(
    title = "CLEAR_CHAPTER_FOREST",
    points = 0,
    description = "...",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x01 &&
        event_flags["back_to_village"] && prev(!event_flags["back_to_village"])
    )
)

target = 5000
achievement(
    title = "LONG_JUMP_SCORE",
    points = 0,
    description = format("Score {0} or more points in the Long Jump event", target),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        current_sport == 0x01 &&
        olympics_score >= target && prev(olympics_score < target)
    )
)

achievement(
    title = "MOVIES",
    points = 0,
    description = "Purchase every movie in the gallery",
    trigger = 
    (
        game_has_booted_up() &&
        !not_in_main_menu() &&
        measured(movies_unlocked == 16) && prev(movies_unlocked < 16)
    )
)

achievement(
    title = "20_PIGEONS",
    points = 0,
    description = "Rescue 20 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons >= 20) && prev(pigeons < 20)
    )
)

achievement(
    title = "40_PIGEONS",
    points = 0,
    description = "Rescue 40 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons >= 40) && prev(pigeons < 40)
    )
)

achievement(
    title = "50_PIGEONS",
    points = 0,
    description = "Rescue all 50 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons == 50) && prev(pigeons < 50)
    )
)

achievement(
    title = "50_COMBO",
    points = 0,
    description = "Reach a combo of 50 hits",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        combo >= 50 && prev(combo < 50)
    )
)

achievement(
    title = "40_MULT",
    points = 0,
    description = "Earn a multiplier of 40 or higher",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        multiplier >= 40 && prev(multiplier < 40)
    )
)

achievement(
    title = "ALL_MOVES",
    points = 0,
    description = "Unlock all moves",
    trigger = 
    (
        game_has_booted_up() &&
        // game paused?
        not_in_main_menu() &&
        current_location == 0x02 &&
        measured(upgrades_unlocked == 9) && prev(upgrades_unlocked == 8)
    )
)

achievement(
    title = "ALL_GLUE",
    points = 0,
    description = "Collect all glue",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(glue == 3) && prev(glue == 2)
    )
)

achievement(
    title = "ALL_MAGNESIA",
    points = 0,
    description = "Collect all magnesia",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(magnesia == 3) && prev(magnesia == 2)
    )
)


// Rich Presence
WorldLookup = {
    0x00: "in the main menu",
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

CharLookup = {
    0x00: "Asterix",
    0x01: "Doctormabus",
    0x02: "The Hispanic",
    0x03: "Sam Schieffer",
    0x04: "Obelix",
    0x05: "Gluteus Maximus",
    0x06: "The Egyptian",
    0x07: "The Goth",
    0x08: "Brutus",
    0x09: "The Grecian",
    0x0a: "Getafix",
    0x0b: "Lovestorix"
}


// rich_presence_conditional_display(SAVE_GAME_STATE == 0, "Asterix & Obelix are in the main menu")

rich_presence_conditional_display(game_has_booted_up() && current_location == 0x0b, "{0} is partaking in {3} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("Character", sports_char_p1, CharLookup, fallback="An unknown character"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons),
    rich_presence_lookup("Sport", current_sport, SportLookup, fallback="an unknown dicipline")
)

rich_presence_conditional_display(game_has_booted_up() && current_location != 0xffffffff, "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", current_location, WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_conditional_display(game_has_booted_up() && current_location == 0xffffffff, "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", prior(current_location), WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_display("Playing Asterix at the Olympic Games")
