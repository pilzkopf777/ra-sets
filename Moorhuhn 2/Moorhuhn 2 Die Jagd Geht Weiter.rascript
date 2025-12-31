// Moorhuhn 2: Die Jagd Geht Weiter
// #ID = 17158

function better_ammo_unlocked() {
    rock_1 = word(0x0EC1E4) == 4
    rock_2 = word(0x0EC278) == 4
    rock_3 = word(0x0EC3A0) == 4
    rock_4 = word(0x0EC434) == 4
    rock_5 = word(0x0EC4C8) == 4
    rock_6 = word(0x0EC55C) == 4

    rock_cond = rock_1 && rock_2 && rock_3 && rock_4 && rock_5 && rock_6

    return rock_cond && prev(!rock_cond)
}

function get_spider_round() {
    return word(0x043D3C)
}

function get_score() {
    return dword(0x0CAA48)
}

// $043AEC: [16-bit] Memory minigame: Lives remaining
//          0x00 = Game over
function memory_minigame_lives_remaining() => word(0x043AEC)

function max_bullets_upgraded() {
    return prev(dword(0x0CAA54) == 8) && dword(0x0CAA54) == 10
}

function get_time() {
    return dword(0x0CEAC0)
}

function get_player_count() {
    // 1 or 2
    return dword(0x0CEADC)
}

function unlocked_secret_game() {
    return prev(word(0x0DEC9C) == 0x00) && word(0x0DEC9C) == 0x03
}

function boat_shot() {
    return prev(word(0x0EB248) == 0x00) && word(0x0EB248) == 0x04
}

function high_perch_broken_broken() {
    return word(0x0EB30C) == 0x03 && prev(word(0x0EB30C) != 0x03) && word(0x0EB30E) == 0x012
}

function shot_memmenshuhn() {
    final_cond = word(0x0EB70C) == 0x06 && prev(word(0x0EB70C) != 0x06)
    spider_check = word(0x0ebc4c) > 4
    grass_check = word(0x0EC150) == 0x04

    return final_cond && spider_check && grass_check
}

// $0EC0EC: [16-bit] Left house combo bonus
//          Starts at 0x00, counts up by 0x01 with every shot when the secret has been enabled
//          Caps out at 0x06
function left_house_combo_bonus() => word(0x0EC0EC)


function scarecrow_correctly_shot() {
    scarecrow_data = dword(0x10F9F4)

    return scarecrow_data == 0x1234567 && prev(scarecrow_data != 0x1234567)
}

// $10FA08: [32-bit] Scarecrow minigame: Parts remaining
//          With every shot that hits the scarecrow body parts are removed. Counts down by 0x01 per part removed (or 0x02 if head and hat at the same time).
//          
//          0x47 = Starting amount
//          0x01 = No parts remain, game ends
function scarecrow_minigame_parts_remaining() => dword(0x10FA08)

function in_demo() {
    return dword(0xdeb00) == 0x01
}

function get_mode() => dword(0x11063C)

mode_map_german = {
    0x00: "Moorhuhn 2 Original",
    0x01: "Die spinnen, die Spinnen",
    0x02: "Scheuchen scheuchen",
    0x03: "Hau das Moorhuhn Classic",
    0x04: "98 Moorballloons",
    0x05: "Memoory Huhn",
    0x07: "Weidmannshuhn!",
    0x10: "Highscores",
    0x0f: "Credits"
}

mode_map_english = {
    0x00: "Chicken 2 Classic",
    0x01: "Spider Madness",
    0x02: "Scarecrow",
    0x03: "Chicken Bop",
    0x04: "98 Chikalloons",
    0x05: "Chik N Brain",
    0x07: "Chicken Hunt!",
    0x10: "Highscores",
    0x0f: "Credits"
}

mode_map_blunt = {
    0x00: "Classic",
    0x01: "Spider",
    0x02: "Scarecrow",
    0x03: "Chicken Bop",
    0x04: "Balloon",
    0x05: "Memory",
    0x07: "Endurance Hunt"
}

// $1107E8: [16-bit] Spiders minigame: Lives remaining
//          0x00 = Game over
function spiders_minigame_lives_remaining() => word(0x1107E8)

// $110894: [16-bit] Balloon mode: Time limit
//          0x00 = Time's up
function balloon_mode_time_limit() => word(0x110894)

// $110BCC: [16-bit] Weidmannshuhn minigame: Time limit
//          0x00 = Time's up
function weidmannshuhn_minigame_time_limit() => word(0x110BCC)

function in_main_menu() {
    return dword(0xc5fdc) == 0x00
}

function on_title_screen() {
    return dword(0x0c5fe4) == 0x00
}

function entered_score_screen() {
    return dword(0x0c5fe8) == 0x03 && prev(dword(0x0c5fe8) == 0x02)
}

// main mode puzzle achievements
achievement(
    title = "Coward of the County",
    points = 10,
    description = format("Shoot the Memmenhuhn in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        shot_memmenshuhn()
)

achievement(
    title = "All's in Order",
    points = 3,
    description = format("Shoot the scarecrow in the correct order in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        scarecrow_correctly_shot()
)

achievement(
    title = "Irony",
    points = 2,
    description = format("Destroy the perch in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        high_perch_broken_broken()
)

achievement(
    title = "Capsizing",
    points = 2,
    description = format("Destroy the boat in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        boat_shot()
)

achievement(
    title = "Getting an Upgrade",
    points = 3,
    description = format("Earn the special ammunition in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        better_ammo_unlocked()
)

achievement(
    title = "More Huhn",
    points = 3,
    description = format("Earn additional ammunition in the \"{0}\" mode", mode_map_blunt[0]),
    trigger = 
        get_mode() == 0 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        max_bullets_upgraded()
)

// score targets in all modes
// classic
target = 700
mode = 0
achievement(
    title = "A Good Shot",
    points = 10,
    type = "progression",
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score()) < target
)

target = 1300
mode = 0
achievement(
    title = "A Great Shot",
    points = 10,
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score() < target)
)

// spider
target = 4
mode = 1
achievement(
    title = "Hanging onto a Thread",
    points = 5,
    type = "progression",
    description = format("Clear round {1} in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_spider_round() == target + 1 && prev(get_spider_round() == target)
)

// scarecrow
target = 1750
mode = 2
achievement(
    title = "Not Scared Anymore",
    points = 5,
    type = "progression",
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score() < target)
)

// bop
target = 1500
mode = 3
achievement(
    title = "Smack at First Sight",
    points = 5,
    type = "progression",
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score() < target)
)

// balloon
target = 12000
mode = 4
achievement(
    title = "Long-lasting Effort",
    points = 5,
    type = "progression",
    description = format("Survive for {1} or more minutes in the \"{0}\" mode as a single player", mode_map_blunt[mode], target / 50 / 60),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_time() >= target && prev(get_time() < target)
)

// memory
target = 2500
mode = 5
achievement(
    title = "Memory Mastermind",
    points = 5,
    type = "progression",
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score() < target)
)

// the weird meter mode thing
target = 2500
mode = 7
achievement(
    title = "A Sight for Sore Eyes",
    points = 5,
    type = "progression",
    description = format("Score {1} or more points in the \"{0}\" mode as a single player", mode_map_blunt[mode], target),
    trigger = 
        get_mode() == mode &&
        get_player_count() == 1 &&
        !in_main_menu() && !on_title_screen() && !in_demo() &&
        get_score() >= target && prev(get_score() < target)
)

// unlock scarecrow mode
achievement(
    title = "The Metagame",
    points = 1,
    type = "progression",
    description = format("Unlock the secret game mode"),
    trigger = 
        in_main_menu() && !in_demo() &&
        unlocked_secret_game()
)

for mode_count in range(0, 5, 1) {
    leaderboard(
        title = format("\"{0}\" Score Attack", mode_map_english[mode_count]),
        description = format("Score as many points as possible in the \"{0}\" mode as a single player!", mode_map_blunt[mode_count]),
        start = 
        (
            get_mode() == mode_count &&
            get_player_count() == 1 &&
            // main menu flag updates just before the enter score screen -> no not include it
            !on_title_screen() && !in_demo() &&
            entered_score_screen()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_score()
        ),
        format = "VALUE", lower_is_better = false
    )
}

// no mode for 6 so here's a seperate entry..
leaderboard(
    title = format("\"{0}\" Score Attack", mode_map_english[7]),
    description = format("Score as many points as possible in the \"{0}\" mode as a single player!", mode_map_blunt[7]),
    start = 
    (
        get_mode() == 7 &&
        get_player_count() == 1 &&
        // main menu flag updates just before the enter score screen -> no not include it
        !on_title_screen() && !in_demo() &&
        entered_score_screen()
    ),
    cancel = always_false(),
    submit = always_true(),
    value =
    measured(
        get_score()
    ),
    format = "VALUE", lower_is_better = false
)



rich_presence_conditional_display(on_title_screen(), "On the Title Screen")

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

// Spider game
rich_presence_conditional_display(!in_main_menu() && !on_title_screen() && !in_demo() && get_mode() == 0x01, "Playing \"{0}\" mode • Score {2} • Round {3}",
    rich_presence_lookup("Mode BLUNT", get_mode(), mode_map_blunt, fallback="an unknown mode"),
    rich_presence_lookup("Mode EN", get_mode(), mode_map_english, fallback="an unknown mode"),
    rich_presence_value("Points", get_score(), "VALUE"),
    rich_presence_value("Round", get_spider_round(), "VALUE")
)

// Modes with no rounds
rich_presence_conditional_display(!in_main_menu() && !on_title_screen() && !in_demo(), "Playing \"{0}\" mode • Score {2}",
    rich_presence_lookup("Mode BLUNT", get_mode(), mode_map_blunt, fallback="an unknown mode"),
    rich_presence_lookup("Mode EN", get_mode(), mode_map_english, fallback="an unknown mode"),
    rich_presence_value("Points", get_score(), "VALUE")
)

rich_presence_display("Getting ready to hunt Moorhuhn...")