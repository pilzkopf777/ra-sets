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
combo_asterix = ptr(dword(0x006cbd00), [0x530], byte)
combo_obelix = ptr(dword(0x006cbd00), [0x534], byte)
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

olympics_score_p1 = ptr(dword(0x6cbd00), [0x41C, 0x18C], dword)
olympics_score_p2 = ptr(dword(0x6cbd00), [0x41C, 0x190], dword)

sport_time_left = ptr(dword(0x006cbd00), [0x4c8, 0x104], float)
sport_countdown_time_left = ptr(dword(0x006cbd00), [0x4c8, 0xec], float)
sport_countdown_step = ptr(dword(0x006cbd00), [0x4c8, 0xf0], byte)

what_player_score_shown = ptr(dword(0x006cbd00), [0x12fb], byte)

sport_p1_won = ptr(dword(0x006cbd00), [0x12fe], byte) == 0x00
sport_p2_won = ptr(dword(0x006cbd00), [0x12fe], byte) == 0x01

function coop_is_enabled() {
    return ptr(dword(0x006cbd00), [0x1222], byte) == 0x01
}

function coop_is_disabled() {
    return ptr(dword(0x006cbd00), [0x1222], byte) == 0x00
}


function sport_countdown_started() {
    return sport_countdown_step == 0x00 && sport_countdown_time_left < 0.9 && prev(sport_countdown_time_left >= 0.9) 
}

function sport_started() {
    return sport_countdown_step == 0x02 && prev(sport_countdown_step == 0x01)
}

function sport_ended() {
    return sport_countdown_step == 0x03 && prev(sport_countdown_step == 0x02)
}

event_flags = {
    "all_disciplines_cleared": ptr(dword(0x928628), [0x14], byte) == 0xCF,
    "exited_lair": ptr(dword(0x9286a4), [0x14], byte) == 0xCF,
    "brutus_door_opened": ptr(dword(0x928730), [0x14], byte) == 0xCF,
    "caught_doctor": ptr(dword(0x92874c), [0x14], byte) == 0xCF,
    "opened_doctor_lair_door": ptr(dword(0x928798), [0x14], byte) == 0xCF,
    "opened_vip_zone_door": ptr(dword(0x9287ac), [0x14], byte) == 0xCF,
    "back_to_village": ptr(dword(0x9287c8), [0x14], byte) == 0xCF,
    "opened_door_path_to_lair": ptr(dword(0x928824), [0x14], byte) == 0xCF,
    "first_dart_board_done": ptr(dword(0x92882c), [0x14], byte) == 0xCF,
    "escape_underground": ptr(dword(0x00928610), [0x14], byte) == 0xCF,
    "win_final_race": ptr(dword(0x00928624), [0x14], byte) == 0xCF,
    "win_final_laudi_battle": ptr(dword(0x009286fc), [0x14], byte) == 0xCF,
}

achievement(
    title = "CLEAR_CHAPTER_FOREST",
    points = 0,
    description = "Return to forest, go to Olympia",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x01 &&
        event_flags["back_to_village"] && prev(!event_flags["back_to_village"])
    )
)

achievement(
    title = "CLEAR_OLYMPIC_VILLAGE",
    points = 0,
    description = "Clear 1st ambush, open path to road to lair",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x02 &&
        event_flags["opened_door_path_to_lair"] && prev(!event_flags["opened_door_path_to_lair"])
    )
)

achievement(
    title = "CLEAR_PATH_TO_LAIR",
    points = 0,
    description = "Open door to lair",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x03 &&
        event_flags["opened_doctor_lair_door"] && prev(!event_flags["opened_doctor_lair_door"])
    )
)

achievement(
    title = "CLEAR_LAIR",
    points = 0,
    description = "Exit lair",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x09 &&
        event_flags["exited_lair"] && prev(!event_flags["exited_lair"])
    )
)

achievement(
    title = "CLEAR_CATCH_DOC",
    points = 0,
    description = "Caught doc",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x06 &&
        event_flags["caught_doctor"] && prev(!event_flags["caught_doctor"])
    )
)

achievement(
    title = "CLEAR_GET_TO_CITY",
    points = 0,
    description = "Gain access to city from VIP zone",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x04 &&
        event_flags["opened_vip_zone_door"] && prev(!event_flags["opened_vip_zone_door"])
    )
)

achievement(
    title = "CLEAR_GOTO_BRUTUS_DOOR",
    points = 0,
    description = "Open door to Brutus quarters",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x05 &&
        event_flags["brutus_door_opened"] && prev(!event_flags["brutus_door_opened"])
    )
)

achievement(
    title = "CLEAR_ESCAPE_UG",
    points = 0,
    description = "Exit UG area",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x0a &&
        event_flags["escape_underground"] && prev(!event_flags["escape_underground"])
    )
)

achievement(
    title = "CLEAR_WIN_VS_BRUTUS",
    points = 0,
    description = "Win Chariot Race vs Brutus",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x0b &&
        event_flags["win_final_race"] && prev(!event_flags["win_final_race"])
    )
)

achievement(
    title = "CLEAR_GAME",
    points = 0,
    description = "Complete final Laudi battle",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x07 &&
        event_flags["win_final_laudi_battle"] && prev(!event_flags["win_final_laudi_battle"])
    )
)

// SCORE
top_score_targets = {
    0x00: 17200, // long jump
    0x01: 19200, // foot race
    0x02: 21920, // tug of war
    0x03: 21200, // toadball
    0x04: 19850, // kota
    0x05: 22190, // hammer throw
    0x06: 18500, // javelin
    0x07: 21620, // music
    0x08: 19080 // chariot
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

// Sports where single player at a time
sports_with_single_player_struct = [0x00, 0x05, 0x06]

for element in sports_with_single_player_struct {
    achievement(
        title = format("{0} Score Achievement", SportLookup[element]),
        points = 0,
        description = format("Score {0} or more points in {1} event", top_score_targets[0x00], SportLookup[0x00]),
        trigger = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // if solo: only p1 counts
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                ) ||
                (
                    // if coop: both may score accordingly
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                ) ||
                (
                    // p2 in coop
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p2 != prev(olympics_score_p2) &&
                    // check p2 score
                    olympics_score_p2 >= top_score_targets[element]
                )
            )
        )
    )

    leaderboard(
        title = format("{0} LB", SportLookup[element]),
        description = format("Score high in {0} event", SportLookup[element]),
        start = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // if solo: only p1 counts
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                ) ||
                (
                    // if coop: both may score accordingly
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                ) ||
                (
                    // p2 in coop
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p2 != prev(olympics_score_p2)
                )
            )
        ),
        cancel = always_false(),
        submit = always_true(),
        value = max_of(
            // if solo: only p1 counts
            measured(olympics_score_p1, when=coop_is_disabled() && what_player_score_shown == 0x00),
            // if coop: both may score accordingly
            measured(olympics_score_p1, when=coop_is_enabled() && what_player_score_shown == 0x00),
            // p2 in coop
            measured(olympics_score_p2, when=coop_is_enabled() && what_player_score_shown == 0x01)
        ),
        format = "VALUE", lower_is_better = true
    )
}

// Sports always vs CPU
sports_with_multi_player_struct = [0x01, 0x02, 0x03, 0x04, 0x07, 0x08]

for element in sports_with_multi_player_struct {
    achievement(
        title = format("{0} Score Achievement", SportLookup[element]),
        points = 0,
        description = format("Score {0} or more points in {1} event playing against as a computer-controlled opponent", top_score_targets[0x00], SportLookup[0x00]),
        trigger = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // only solo is allowed, human is always p1
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                )
            )
        )
    )

    leaderboard(
        title = format("{0} LB", SportLookup[element]),
        description = format("Score high in {0} event", SportLookup[element]),
        start = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // only solo is allowed, human is always p1
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                )
            )
        ),
        cancel = always_false(),
        submit = always_true(),
        value = (
            // score
            measured(olympics_score_p1)
        ),
        format = "VALUE", lower_is_better = true
    )
}


// SPECIAL SPORTS
long_jump_extensions = ptr(dword(0x009102dc), [0x26c], float)

achievement(
    title = "LONG_JUMP_AIR_COMBO",
    points = 0,
    description = format("Extend your jump three times mid-air by completing the button inputs in the Long Jump event"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        coop_is_disabled() &&
        current_sport == 0x00 &&
        // unlock on extension count
        long_jump_extensions == 3.0 && prev(long_jump_extensions == 2.0)
    )
)

foot_race_stretch = ptr(dword(0x009102dc), [0x3f0], dword)

achievement(
    title = "FOOT_RACE_NO_STRETCH",
    points = 0,
    description = format("Win against a computer-controlled opponent in the Foot Race event without completing the photo finish button inputs"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        coop_is_disabled() &&
        current_sport == 0x01 &&
        // reset when playing performs action
        never(foot_race_stretch == 0x01 && prev(foot_race_stretch == 0x00)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

rope_button = ptr(dword(0x009102dc), [0x00], byte) // TODO

achievement(
    title = "TUG_OF_WAR_ONE_BTN",
    points = 0,
    description = format("Win against a computer-controlled opponent in the Tug of War event without the required button input switching to a different one"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        coop_is_disabled() &&
        current_sport == 0x02 &&
        // reset when btn input changes
        never(rope_button != prev(rope_button)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

toadball_score_p1 = ptr(dword(0x009102dc), [0x1ed], byte)
toadball_score_p2 = ptr(dword(0x009102dc), [0x1ec], byte)

target = 4
achievement(
    title = "TOADBALL_NO_LESS_PTS",
    points = 0,
    description = format("Win against a computer-controlled opponent in the Toadball event without ever dropping below {0} points", target),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        coop_is_disabled() &&
        current_sport == 0x03 &&
        // reset when score falls too low
        never(toadball_score_p1 < target && prev(toadball_score_p1 >= target)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

// KOTA: score mult?

// HAMMER: ?

// JAVELIN: x clouds?

// MUSIC: no wrong note?

// CHARIOT: HP?

// OTHER STUFF

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
        (
            combo_obelix >= 50 && prev(combo_obelix < 50) ||
            combo_obelix >= 50 && prev(combo_obelix < 50)
        )
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
    0x0b: "in the main menu",
    0x03: "on their way to the red cypress trees",
    0x09: "inside Doctormabus' Lair",
    0x06: "chasing Doctormabus",
    0x04: "in the VIP Zone",
    0x05: "in the City",
    0x0a: "in the Catacombs",
    0x07: "facing a horde of Romans"
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

rich_presence_conditional_display(game_has_booted_up() && current_location == 0x0b, "{0} is competing in {3} • Helmets: {1} • Pigeons: {2} / 50 ",
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
