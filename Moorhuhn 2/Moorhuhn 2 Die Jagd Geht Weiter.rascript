// Moorhuhn 2: Die Jagd Geht Weiter
// #ID = 17158

function better_ammo_unlocked() {
    rock_1 = word(0x0EC1E4) == 4
    rock_2 = word(0x0EC278) == 4
    rock_3 = word(0x0EC3A0) == 4
    rock_4 = word(0x0EC434) == 4
    rock_5 = word(0x0EC4C8) == 4
    rock_6 = word(0x0EC55C) == 4

    return rock_1 && rock_2 && rock_3 && rock_4 && rock_5 && rock_6
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

// $0CEAC0: [32-bit] Time (in frames)
//          Counts down in these modes: Original, Spiders, Hit the Moorhuhn
//          0xffffffff = None
//          0x00 = Time's up, resets to 0xffffffff afterwards
//          
//          Counts UP in the other modes (Balloons, Memory, Weidmannshuhn).
function time_in_frames() => dword(0x0CEAC0)


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
    spider_check = word(0x0EBC1C) > 4
    grass_check = word(0x0EC150) == 0x04

    return final_cond && spider_check && grass_check
}

// $0EC0EC: [16-bit] Left house combo bonus
//          Starts at 0x00, counts up by 0x01 with every shot when the secret has been enabled
//          Caps out at 0x06
function left_house_combo_bonus() => word(0x0EC0EC)


function scarecrow_correctly_shot() {
    scarecrow_data = dword(0x10F9F4)

    return scarecrow_data == 0x123456 && prev(scarecrow_data != 0x123456)
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

// todo
mode_map_english = {
    0x00: "Original",
    0x01: "Spider",
    0x02: "Scarecrow",
    0x03: "Hit the Moorhuhn",
    0x04: "Balloons",
    0x05: "Memory",
    0x07: "That one mode with the time limit bar",
    0x10: "Highscores",
    0x0f: "Credits"
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

function entered_leaderboard() {
    return prev(dword(0xc5fdc) == 0xffffffff) && dword(0xc5fdc) == 0x00
}


rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

// Modes with no rounds
rich_presence_conditional_display(!in_main_menu() && !in_demo(), "Playing {0} ({1}) • Score {2}",
    rich_presence_lookup("Mode DE", get_mode(), mode_map_german, fallback="an unknown mode"),
    rich_presence_lookup("Mode EN", get_mode(), mode_map_english, fallback="an unknown mode"),
    rich_presence_value("Points", get_score(), "VALUE")
)

// Spider game
rich_presence_conditional_display(!in_main_menu() && !in_demo(), "Playing {0} ({1}) • Round {3} • Score {2}",
    rich_presence_lookup("Mode DE", get_mode(), mode_map_german, fallback="an unknown mode"),
    rich_presence_lookup("Mode EN", get_mode(), mode_map_english, fallback="an unknown mode"),
    rich_presence_value("Points", get_score(), "VALUE"),
    rich_presence_value("Round", get_spider_round(), "VALUE")
)

rich_presence_display("Getting ready to hunt Moorhuhn...")