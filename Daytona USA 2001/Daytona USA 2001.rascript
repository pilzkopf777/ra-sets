// Daytona USA 2001
// #ID = 8412

function build_date() => byte(0x1BEA0C)
function pause_menu_highlighted_option() => byte(0x265D0C)
function ghost_car_select_highlighted_option() => byte(0x265D68)
function name_entry_currently_highlighted_character() => byte(0x265E74)
function name_entry_current_full_name() => dword(0x265E78)
function collision_with_other_car() => byte(0x266778)
function car_color_settings_highlighted_setting() => byte(0x28F5AC)
function car_color_settings_selected_palette() => byte(0x28F5B0)
function car_color_settings_selected_car() => byte(0x28F5B4)
function car_color_settings_selected_color() => byte(0x28F5BC)
function car_color_settings_hue_value() => byte(0x28F656)
function car_color_settings_shade_value() => byte(0x28F658)
function car_color_settings_value_value() => byte(0x28F65A)

GAME_MODE = byte(0x265D24)

RACE_TRACK_AND_TYPE_RAW_ADR = 0x294a40

CURRENT_SCREEN = word(0x2B66DE)

// Functions for player screen states
function screen_check(value) {
    return CURRENT_SCREEN == value || prior(CURRENT_SCREEN == value)
}

function on_title_screen() {
    // Special check for 0x0025: Also matches rankings after a race so additionally check for the main menu or title screen
    return (screen_check(0x0025) && GAME_MODE == 0) || screen_check(0x00cf) || screen_check(0x00a6) || screen_check(0x0000) || screen_check(0x01cf)
}

function on_victory_1st_series() {
    return CURRENT_SCREEN == 0x00f7 && prev(CURRENT_SCREEN == 0xffff)
}

function on_victory_2nd_series() {
    return CURRENT_SCREEN == 0x00ff && prev(CURRENT_SCREEN == 0xffff)
}

function on_victory_3rd_series() {
    return CURRENT_SCREEN == 0x0107 && prev(CURRENT_SCREEN == 0xffff)
}

function in_race() {
    // Maybe exclude 0x01bc?
    // -> return screen_check(0x006c) || screen_check(0x00cf) || screen_check(0x0012)
    // return screen_check(0x006c) || screen_check(0x00cf) || screen_check(0x01bc) || screen_check(0x0012)
    return screen_check(0x006c) || screen_check(0x00cf) || screen_check(0x0012)
}

function reset_race() {
    return CURRENT_SCREEN == 0x006c && prev(CURRENT_SCREEN == 0xffff)
}

function on_car_unlock_screen() {
    return screen_check(0x0011)
}

function start_your_engines_screen_ended() {
    // Previously on the start your engines screen...
    return (prev(CURRENT_SCREEN == 0x01f5) || prev(CURRENT_SCREEN == 0x0205) || prev(CURRENT_SCREEN == 0x01fd) || prev(CURRENT_SCREEN == 0x020d) ||
           prev(CURRENT_SCREEN == 0x0215) || prev(CURRENT_SCREEN == 0x021d) || prev(CURRENT_SCREEN == 0x0225) || prev(CURRENT_SCREEN == 0x022d)) &&
           // ...and now on the loading screen
           prev(LOADING_SCREEN_STATE == 0xfffffffe) && LOADING_SCREEN_STATE == 0x00
}

function get_current_map_id() {
    // Map is bit0-2. Thus, mask with 7 (bin 111) using modolo
    return byte(RACE_TRACK_AND_TYPE_RAW_ADR) % 8
}

function get_map_mirror_state() {
    return bit4(RACE_TRACK_AND_TYPE_RAW_ADR)
}

function get_map_reverse_state() {
    return bit3(RACE_TRACK_AND_TYPE_RAW_ADR)
}

function get_map_type() {
    // (bit3(0x2A6350) + bit3(0x2A6350) + bit4(0x2A6350)) == 3
    return (get_map_reverse_state() + get_map_reverse_state() + get_map_mirror_state())
    // return (get_map_reverse_state() + get_map_reverse_state() + get_map_mirror_state())
}

function raw_time_to_centiseconds(raw_time) {
    return (raw_time * 100) / 64
}

function raw_time_to_formatted_timestamp(raw_time) {
    return raw_time
}

function check_if_race_finished() {
    return prev(RACE_DATA["player"][0]["progress"]["laps_completed"]) < RACE_DATA["track"]["target_laps"] &&
    RACE_DATA["player"][0]["progress"]["laps_completed"] == RACE_DATA["track"]["target_laps"]
}

function lap_completed() {
    return prev(RACE_DATA["player"][0]["progress"]["laps_completed"]) < RACE_DATA["player"][0]["progress"]["laps_completed"]
}

function check_if_in_first(player_id) {
    return RACE_DATA["player"][player_id]["position"] == 1
}

function reach_speed(player, target) {
    return RACE_DATA["player"][player]["speed"] == target && prev(RACE_DATA["player"][player]["speed"]) < target
}

function has_collided_with_object(player_id) {
    return (RACE_DATA["player"][player_id]["contact"]["wall"] != prev(RACE_DATA["player"][player_id]["contact"]["wall"])) || (RACE_DATA["player"][player_id]["contact"]["car"] != prev(RACE_DATA["player"][player_id]["contact"]["car"]))
}

function get_angular_distance(a, b) {
    diff = a - b
    if (diff < 0) {
        diff = -diff
    }
    if (diff > 32768) {
        diff = 65536 - diff
    }
    return diff
}

//function is_drifting() {
//    val = get_angular_distance(RACE_DATA["player"][0]["rotation"]["front"], RACE_DATA["player"][0]["rotation"]["back"])
//    return val > 50 && val < 500
//}



LOADING_SCREEN_STATE = dword(0x1bfd94)

INTERACTIVE_OBJ_COUNT_RAW_ADR = 0x34d664
INTERACTIVE_OBJ_COUNT = byte(INTERACTIVE_OBJ_COUNT_RAW_ADR)
CAR_OBJECT_START_RAW_ADR = 0x345b6c

function get_interactive_obj_data(id) {
    obj_start = INTERACTIVE_OBJ_COUNT_RAW_ADR + id * 0x100

    obj = {
        "coord1": float(obj_start + 0x14),
        "coord2": float(obj_start + 0x18),
        "coord3": float(obj_start + 0x1c),
    }

    return obj
}

function check_if_interactive_obj_moved(id) {
    obj = get_interactive_obj_data(id)
    return obj["coord1"] != prev(obj["coord1"]) || obj["coord2"] != prev(obj["coord2"]) || obj["coord3"] != prev(obj["coord3"])
}

function get_car_crash_obj_data(id) {
    // objects are 0x30C away from each other
    // id = 0: 0 * 0x30c = 0x00 from start
    obj_start = CAR_OBJECT_START_RAW_ADR + id * 0x30C

    obj = {
        "x": float(obj_start + 0x0),
        "z": float(obj_start + 0x4),
        "y": float(obj_start + 0x8),
        "crash": float(obj_start + 0x40)
    }

    return obj
}

function check_if_crashed_nearby(id) {
    // RACE_DATA["player"][0]["coordinates"]["x"]
    player_x = RACE_DATA["player"][0]["coordinates"]["x"]
    player_y = RACE_DATA["player"][0]["coordinates"]["y"]
    player_z = RACE_DATA["player"][0]["coordinates"]["z"]

    obj = get_car_crash_obj_data(id)

    // obj is at 20, player at 23:
    // check if player is in 15-25 for validity
    // obj - 5: is player larger?
    // obj + 5: is player smaller?
    // if both: valid
    return obj["x"] - 5.0 < player_x && obj["x"] + 5.0 > player_x &&
           obj["y"] - 5.0 < player_y && obj["y"] + 5.0 > player_y &&
           obj["z"] - 5.0 < player_z && obj["z"] + 5.0 > player_z &&
           // also opponent must be crashing now
           obj["crash"] > 0.0 && prev(obj["crash"] == 0.0)
    // return obj["x"] != prev(obj["coord1"]) || obj["coord2"] != prev(obj["coord2"]) || obj["coord3"] != prev(obj["coord3"])
}

INPUT = {
    "a": bit2(0x2f0478),
    "b": bit1(0x2f0478),
    "x": bit2(0x2f0479),
    "y": bit1(0x2f0479),
    "l": bit1(0x2f047a),
    "r": bit0(0x2f047a),
    "start": bit3(0x2f0478),
    "d-down": bit5(0x2f0478),
    "d-left": bit6(0x2f0478),
    "d-right":bit7(0x2f0478),
    "d-up": bit4(0x2f0478)
}

SETTINGS = {
    "difficulty": byte(0x28F660),
    "lap_time_display_off_on": byte(0x28F661),
    "section_lap_time_display_off_on": byte(0x28F662),
    "default_view_type": byte(0x28F663),
    "bgm_volum": byte(0x28F665),
    "se_volume": byte(0x28F666),
    "bgm_test": byte(0x28F667),
    "se_test": byte(0x28F668),
    "vibration_off_on": byte(0x28F669)
}

GAME_PAUSED = bit1(0x265D08)

UNLOCKS = {
    "Unicorn": bit4(0x291F68),
    "Red Cat": bit5(0x291F68),
    "Pywackett Barchetta": bit6(0x291F68),
    "Rule of the 9th": bit7(0x291F68),
    "Javelin": bit0(0x291f69),
    "Pywackett Barchetta Super": bit1(0x291f69)
}

TOTAL_PLAY_TIME = raw_time_to_centiseconds(dword(0x291FDC))

RACE_DATA = {
    "player": {
        0: {
        "car": {
            "selection": byte(0x294a45),
            "transmission": byte(0x294a43),
            "tire": byte(0x294a47),
            "color": "n/a",
            "handicap": byte(0x294a49)
        },
        "coordinates": {
            "x": float(0x345B6C),
            "z": float(0x345b70),
            "y": float(0x345b74)
        },
        "rotation": {
            "front": word(0x345b98),
            "back": word(0x345ba8)
        },
        "pedal": {
            "accel": byte(0x265bce),
            "brake": byte(0x265bd0)
        },  
        "speed": word(0x345B64),
        "speed_raw": float(0x345B84),
        "position": byte(0x345BC0) + 1,
        "gear": byte(0x345CAC),
        "burnout": byte(0x345c06),
        "flip": float(0x345bac),
        "viewpoint": byte(0x265EFC),
        "progress": {
            "checkpoints_completed": byte(0x345BC2),
            "laps_completed": byte(0x345BC4)
        },
        "contact": {
            "wall": dword(0x345c4c),
            "car": byte(0x345de5)
        },
        "drive_state": word(0x345B58)
        },
        1: {
        "car": {
            "selection": byte(0x294a46),
            "transmission": byte(0x294a44),
            "tire": byte(0x294a48),
            "color": "n/a",
            "handicap": byte(0x294a4a)
        },
        "coordinates": {
            "x": float(0x345e78),
            "z": float(0x345e7c),
            "y": float(0x345e80)
        },
        "speed": word(0x345e70),
        //"speed_raw": float(0x345B84),
        "position": byte(0x345ecc) + 1,
        //"gear": byte(0x345CAC),
        //"viewpoint": byte(0x265EFC),
        "progress": {
            "checkpoints_completed": byte(0x345ece),
            "laps_completed": byte(0x345ed0)
        },
        "drive_state": word(0x345e64)
        },
    },
    "track": {
        "map": get_current_map_id(),
        "type": get_map_type(),
        "target_laps": byte(0x265c50),
        "driver_count": byte(0x294a42)
    },
    "timing": {
        "countdown": raw_time_to_centiseconds(dword(0x265C34)),
        "total_time": raw_time_to_centiseconds(dword(0x265C30)),
        "total_time_raw": dword(0x265C30),
        "last_lap_time": raw_time_to_centiseconds(dword(0x345bbc)),
        "last_lap_time_raw": dword(0x345bbc)
    },
    "championship": {
        "chain_lead": byte(0x2b63fd)
    }
}

FIXATION_LAP_RULES = {
    0x00: 8,
    0x01: 2,
    0x02: 4,
    0x03: 4,
    0x04: 6,
    0x05: 8,
    0x06: 6,
    0x07: 6
}

function get_points_score_for_compl_achievement(map_id) {
    // If the achievement asks the player to run x laps, award y points
    // e.g. 2 laps -> 4pts
    lap_check = {
        2: 5, // 2 laps
        4: 4, // 4 laps
        6: 3, // 6 laps
        8: 2  // 8 laps
    }
    return lap_check[FIXATION_LAP_RULES[map_id]]
}

function get_points_score_for_time_trial_circuit_achievement(map_id) {
    // If the achievement asks the player to run x laps, award y points
    // e.g. 2 laps -> 50pts
    lap_check = {
        2: 50, // 2 laps
        4: 25, // 4 laps
        6: 10, // 6 laps
        8: 10  // 8 laps
    }
    return lap_check[FIXATION_LAP_RULES[map_id]]
}

function get_points_score_for_time_trial_flap_achievement(map_id) {
    // If the achievement asks the player to run x laps, award y points
    // e.g. 2 laps -> 50pts
    lap_check = {
        2: 10, // 2 laps
        4: 5, // 4 laps
        6: 5, // 6 laps
        8: 3  // 8 laps
    }
    return lap_check[FIXATION_LAP_RULES[map_id]]
}


TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS = {
    //"normal": "[Normal]",
    //"mirror": "[Mirror]",
    //"reverse": "[Reverse]",
    //"mirror_reverse": "[Mirror-Reverse]"
    "normal": "Normal",
    "mirror": "Mirror",
    "reverse": "Reverse",
    "mirror_reverse": "Mirror Reverse"
}

// These are the targets for the Time Attack achievements
// There's normal, reverse, mirror and mirror_reverse
// Missing objects do exist but are left out of this object due to laziness and due to not being used in the set design
TIME_TRIAL_TARGET_TIMES = {
    // Three Seven Speedway
    0x00: { //
        //"normal": {
        //    "course_raw": 9031,
        //    "course_string": "2'21\"078",
        //    "lap_raw": 0,
        //    "lap_string": ""
        //},
        "reverse": { // Course
            "course_raw": 0x236F,
            "course_string": "2'21\"734",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0540,
            "lap_string": "0'21\"000",
        },
    },
    // Sea-Side Street Galaxy
    0x01: {
        //"normal": {        
        //    "course_raw": 11819,
        //    "course_string": "3'04\"671",
        //    "lap_raw": 0,
        //    "lap_string": ""
        //},
        "mirror": { // Course
            "course_raw": 0x3462,
            "course_string": "3'29\"531",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x1E80,
            "lap_string": "2'02\"000"
        },
    },
    // Dinosaur Canyon
    0x02: {
        "normal": { // Course
            "course_raw": 0x2337,
            "course_string": "2'21\"078",
            "lap_raw": 0,
            "lap_string": ""
        },
        //"reverse": {
        //    "course_raw": 12414,
        //    "course_string": "3'13\"968",
        //    "lap_raw": 0,
        //    "lap_string": ""
        //},
        "mirror_reverse": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0DC0,
            "lap_string": "0'55\"000"
        }
    },
    // Desert City
    0x03: {
        "normal": { // FLAP
            "course_raw": 0x2EC7,
            "course_string": "3'07\"109",
            "lap_raw": 0x0DC0,
            "lap_string": "0'55\"000"
        },
        "mirror_reverse": { // Course
            "course_raw": 0x2E98,
            "course_string": "3'06\"375",
            "lap_raw": 0,
            "lap_string": ""
        }
    },
    // National Park Speedway
    0x04: {
        //"normal": {        
        //    "course_raw": 14336,
        //    "course_string": "3'44\"000",
        //    "lap_raw": 0,
        //    "lap_string": ""
        //},
        "mirror": { // Course
            "course_raw": 0x37B7,
            "course_string": "3'42\"859",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0C40,
            "lap_string": "0'49\"000"
        },
    },
    // Circuit Pixie
    0x05: {
        //"normal": {        
        //    "course_raw": 9579,
        //    "course_string": "2'29\"671",
        //    "lap_raw": 0,
        //    "lap_string": ""
        //},
        "reverse": { // Course
            "course_raw": 0x2594,
            "course_string": "2'30\"312",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0540,
            "lap_string": "0'21\"000"
        },
    },
    // Rin Rin Rink
    0x06: {
        "normal": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0B40,
            "lap_string": "0'45\"000"
        },
        "mirror_reverse": { // Course
            "course_raw": 0x3744,
            "course_string": "3'41\"312",
            "lap_raw": 0,
            "lap_string": ""
        }
    },
    // Mermaid Lake
    0x07: {
        "normal": { // Course
            "course_raw": 0x4319,
            "course_string": "4'28\"390",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror_reverse": { // FLAP
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0x0D00,
            "lap_string": "0'52\"000"
        }
    }
}

// Rich Presence
MapLookup = {
    0x00: "Three Seven Speedway",
    0x01: "Sea-Side Street Galaxy",
    0x02: "Dinosaur Canyon",
    0x03: "Desert City",
    0x04: "National Park Speedway",
    0x05: "Circuit Pixie",
    0x06: "Rin Rin Rink",
    0x07: "Mermaid Lake"
}

MapPrefixLookup = {
    0x04: "in",
}

LapLookup = {
    0x00: 2,
    0x01: 4,
    0x02: 6,
    0x03: 8,
    0x04: 16,
    0x05: 40
}

TournamentLookup = {
    0x00: "Challengers Cup",
    0x01: "Strong Runners",
    0x02: "Riot Party Cup",
    0x03: "King of Daytona"
}

CarLookup = {
    0x00: "Hornet",
    0x01: "Grasshopper",
    0x02: "Falcon",
    0x03: "Lightning",
    0x04: "Unicorn",
    0x05: "Red Cat",
    0x06: "Pywackett Barchetta",
    0x07: "Rule of 9th",
    0x08: "Javelin",
    0x09: "P. B. Super"
}

GameModeLookup = {
    0x00: "Main Menu",
    0x01: "Single Race",
    0x02: "Time Attack",
    0x03: "VS Battle",
    0x04: "Championship",
    0x05: "Replay",
    0x06: "Records",
    0x07: "Options",
    0x08: "Homepage"
}

TransmissionLookup = {
    0x00: "[AT]",
    0x01: "[MT]"
}

MapTypeLookup = {
    0x00: "",
    0x01: "[M]",
    0x02: "[R]",
    0x03: "[MR]"
}


// Title Screen, Menus, Race / Gameplay should be fine categories
// Rich Presence
rich_presence_conditional_display(on_title_screen(), "On the Title Screen")
// VS Race needs extra data for P2
rich_presence_conditional_display(in_race() && GAME_MODE == 0x03, "In a {0} with the {1} {2} vs. the {3} {4} {5} {6} {7}",
    rich_presence_lookup("Game Mode", GAME_MODE, GameModeLookup, fallback="questionable situation"),
    rich_presence_lookup("Car Selection", RACE_DATA["player"][0]["car"]["selection"], CarLookup, fallback="unknown vehicle"),
    rich_presence_lookup("Transmission", RACE_DATA["player"][0]["car"]["transmission"], TransmissionLookup, fallback="[?]"),
    rich_presence_lookup("Car Selection P2", RACE_DATA["player"][1]["car"]["selection"], CarLookup, fallback="unknown vehicle"),
    rich_presence_lookup("Transmission P2", RACE_DATA["player"][1]["car"]["transmission"], TransmissionLookup, fallback="[?]"),
    rich_presence_lookup("Map Prefix", RACE_DATA["track"]["map"], MapPrefixLookup, fallback="on"),
    rich_presence_lookup("Map", RACE_DATA["track"]["map"], MapLookup, fallback="an unknown place"),
    rich_presence_lookup("Map Type", RACE_DATA["track"]["type"], MapTypeLookup, fallback="[?]")
)
// Regular Race
rich_presence_conditional_display(in_race(), "In a {0} with the {1} {2} {3} {4} {5}",
    rich_presence_lookup("Game Mode", GAME_MODE, GameModeLookup, fallback="questionable situation"),
    rich_presence_lookup("Car Selection", RACE_DATA["player"][0]["car"]["selection"], CarLookup, fallback="unknown vehicle"),
    rich_presence_lookup("Transmission", RACE_DATA["player"][0]["car"]["transmission"], TransmissionLookup, fallback="[?]"),
    rich_presence_lookup("Map Prefix", RACE_DATA["track"]["map"], MapPrefixLookup, fallback="on"),
    rich_presence_lookup("Map", RACE_DATA["track"]["map"], MapLookup, fallback="an unknown place"),
    rich_presence_lookup("Map Type", RACE_DATA["track"]["type"], MapTypeLookup, fallback="[?]")
)

rich_presence_display("In the Main Menu")


// Achievements
// Finish your first race
achievement(
    title = "Welcome to Daytona",
    points = 1,
    description = "In Single Race or Championship mode, complete a race on Normal difficulty or higher",
    trigger = 
        (GAME_MODE == 0x01 || GAME_MODE == 0x04) &&
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // Must be in a race
        in_race() &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
)

achievement(
    title = "Some Serious Shift",
    points = 5,
    description = "Complete a race using Manual transmission in any mode except VS Battle",
    trigger = 
        GAME_MODE != 0x03 &&
        // Must be in a race
        in_race() &&
        // Must be MT
        RACE_DATA["player"][0]["car"]["transmission"] == 0x01 &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
)

FIRST_PLACE_ACHIEVEMENT_NAME = {
    0x00: "It's an Addiction",
    0x01: "Out of This World",
    0x02: "Canyon Fever",
    0x03: "Hot and Exciting",
    0x04: "The Wicked Wild",
    0x05: "Driving Circles",
    0x06: "Freeze Frame Finish",
    0x07: "A Wave of Applause"
}

// 1st place on normal & fixation rules
for current_map_id in range(0, 7, 1) {
    achievement(
    title = FIRST_PLACE_ACHIEVEMENT_NAME[current_map_id],
    points = get_points_score_for_compl_achievement(current_map_id),
    description = format("In Single Race or Championship mode, win a {1} lap race on the Normal or Mirrored {0} on Normal difficulty or higher", MapLookup[current_map_id], FIXATION_LAP_RULES[current_map_id]),
    trigger = 
        (GAME_MODE == 0x01 || GAME_MODE == 0x04) &&
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // On right correct map / track?
        current_map_id == RACE_DATA["track"]["map"] &&
        // Must be correct lap count
        FIXATION_LAP_RULES[current_map_id] == RACE_DATA["track"]["target_laps"] &&
        // Cannot be reverse type
        get_map_reverse_state() == 0 &&
        // Must be in a race
        in_race() &&
        // Must be in 1st
        check_if_in_first(0) &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
    )
}

// Finish race on hard & fixation rules
achievement(
    title = "Driving a Hard Bargain",
    points = 3,
    description = "In Single Race mode, complete a race on any track with the Fixation ruleset of laps on Hard difficulty",
    trigger = 
        GAME_MODE == 0x01 &&
        // Hard difficulty
        SETTINGS["difficulty"] == 2 &&
        // Must be correct lap count; I got very lazy here.
        (
        ( RACE_DATA["track"]["map"] == 0 && FIXATION_LAP_RULES[0] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 1 && FIXATION_LAP_RULES[1] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 2 && FIXATION_LAP_RULES[2] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 3 && FIXATION_LAP_RULES[3] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 4 && FIXATION_LAP_RULES[4] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 5 && FIXATION_LAP_RULES[5] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 6 && FIXATION_LAP_RULES[6] == RACE_DATA["track"]["target_laps"]) ||
        ( RACE_DATA["track"]["map"] == 7 && FIXATION_LAP_RULES[7] == RACE_DATA["track"]["target_laps"])
        ) &&
        // Must be in a race
        in_race() &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
)

// Tournaments
achievement(
    title = "Rise to the Challenge",
    points = 5,
    type = "progression",
    description = "Complete the \"Challengers Cup\" championship series",
    trigger = 
        GAME_MODE == 0x04 &&
        on_victory_1st_series()
)

achievement(
    title = "On the Run",
    points = 10,
    type = "progression",
    description = "Complete the \"Strong Runners\" championship series",
    trigger = 
        GAME_MODE == 0x04 &&
        on_victory_2nd_series()
)

achievement(
    title = "Party's Just Getting Started",
    points = 10,
    type = "progression",
    description = "Complete the \"Riot Party Cup\" championship series",
    trigger = 
        GAME_MODE == 0x04 &&
        on_victory_3rd_series()
)

achievement(
    title = "Roadside Royalty",
    points = 25,
    type = "win_condition",
    description = "Complete the \"King of Daytona\" championship series and unlock the Unicorn",
    trigger = 
        // But why, game????
        GAME_MODE == 0x00 &&
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Unicorn"]) == 0 && UNLOCKS["Unicorn"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

achievement(
    title = "Done with Road Safety",
    points = 5,
    description = "Unlock the Red Cat",
    trigger = 
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Red Cat"]) == 0 && UNLOCKS["Red Cat"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

achievement(
    title = "Maserati's Law",
    points = 5,
    description = "Unlock the Rule of the 9th",
    trigger = 
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Rule of the 9th"]) == 0 && UNLOCKS["Rule of the 9th"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

achievement(
    title = "And Who Are These Guys?",
    points = 5,
    description = "Unlock the Pywackett Barchetta",
    trigger = 
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Pywackett Barchetta"]) == 0 && UNLOCKS["Pywackett Barchetta"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

achievement(
    title = "On Knife's Edge",
    points = 5,
    description = "Unlock the Pywackett Barchetta Super",
    trigger = 
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Pywackett Barchetta Super"]) == 0 && UNLOCKS["Pywackett Barchetta Super"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

achievement(
    title = "To Be This Good Really Does Take Ages",
    points = 10,
    description = "Unlock the Javelin",
    trigger = 
        on_car_unlock_screen() &&
        once(prev(UNLOCKS["Javelin"]) == 0 && UNLOCKS["Javelin"] == 1) &&
        never(CURRENT_SCREEN == 0x33 && prev(CURRENT_SCREEN != 0x33))
        
)

TIME_ATTACK_COURSE_TIME_MISSION_TYPE = {
    0x00: "reverse",
    0x01: "mirror",
    0x02: "normal",
    0x03: "mirror_reverse",
    0x04: "mirror",
    0x05: "reverse",
    0x06: "mirror_reverse",
    0x07: "normal"
}

TIME_ATTACK_FLAP_MISSION_TYPE = {
    0x00: "mirror",
    0x01: "reverse",
    0x02: "mirror_reverse",
    0x03: "normal",
    0x04: "reverse",
    0x05: "mirror",
    0x06: "normal",
    0x07: "mirror_reverse"
}

MODE_TO_VAL_MAP = {
    "normal": 0x00,
    "mirror": 0x01,
    "reverse": 0x02,
    "mirror_reverse": 0x03
}

// Fastest course time (8 versions)
for current_map_id in TIME_ATTACK_COURSE_TIME_MISSION_TYPE {
    achievement(
    title = format("Peak Pace: {0}", MapLookup[current_map_id]),
    points = get_points_score_for_time_trial_circuit_achievement(current_map_id),
    description = format("In Time Attack mode, beat the course time of {2} in a {3} lap race on {1} {0}",
        MapLookup[current_map_id],
        TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]],
        TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_string"],
        FIXATION_LAP_RULES[current_map_id]
    ),
    trigger = 
        // Time Attack mode?
        GAME_MODE == 0x02 &&
        // On right correct map / track?
        current_map_id == RACE_DATA["track"]["map"] &&
        // Cannot be free run..
        RACE_DATA["track"]["target_laps"] != 0xff &&
        // Must be correct type
        get_map_type() == MODE_TO_VAL_MAP[TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]] &&
        // Must be in a race
        in_race() &&
        // Must be meeting time criteria
        // RACE_DATA["timing"]["total_time"] <= 0 &&
        RACE_DATA["timing"]["total_time_raw"] < TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_raw"] &&
        trigger_when(
            // Pass the finish line with the correct lap count to get the achievement
            check_if_race_finished()
        )
    )
}

// FLAP (8 versions)
for current_map_id in TIME_ATTACK_FLAP_MISSION_TYPE {
    achievement(
    title = format("Dream Lap: {0}", MapLookup[current_map_id]),
    points = get_points_score_for_time_trial_flap_achievement(current_map_id),
    description = format("In Time Attack mode, beat the fastest lap time of {2} on {1} {0}", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]], TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]]["lap_string"]),
    trigger = 
        // Time Attack mode?
        GAME_MODE == 0x02 &&
        // On right correct map / track?
        current_map_id == RACE_DATA["track"]["map"] &&
        // Must be correct type
        get_map_type() == MODE_TO_VAL_MAP[TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]] &&
        // Must be in a race
        in_race() &&
        // Must be meeting time criteria
        // RACE_DATA["timing"]["total_time"] <= 0 &&
        trigger_when(RACE_DATA["timing"]["last_lap_time_raw"] < TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]]["lap_raw"] && lap_completed())
        // Complete a lap to get the achievement
    )
}

achievement(
    title = "[VOID] And They're Underway",
    points = 2,
    description = "Perform a Boost Start in any mode except VS Battle",
    trigger = 
        // No VS mode
        GAME_MODE != 0x03 &&
        RACE_DATA["player"][0]["speed_raw"] > 0.2 &&
        prev(RACE_DATA["player"][0]["speed_raw"]) == 0.2 &&
        in_race() &&
        RACE_DATA["timing"]["total_time_raw"] >= 0x30 && // 0x40 is 1 sec 
        RACE_DATA["player"][0]["burnout"] == 0x00
)

achievement(
    title = "Golden Hour",
    points = 1,
    description = "Change the time of day before the race",
    trigger = 
        // Once the Ladies and Gentleman screen changes into a loading screen hold L and R to switch the skybox - though not always to Sunset as it depends on the track..
        start_your_engines_screen_ended() &&
        INPUT["l"] == 1 && INPUT["r"] == 1
)

function opponent_crash_logic() {
    cond = always_false()
    // Up to 39 opponents, including the Player 2 object which will be a CPU if in Single Player mode
    for id in range(1, 39, 1)
    {
      cond = cond || (check_if_crashed_nearby(id))
    }
    return cond
}

achievement(
    title = "Safety Redefined",
    points = 2,
    description = "With the Red Cat cause an opponent to crash in any mode except VS Battle",
    trigger = 
        // No VS mode
        GAME_MODE != 0x03 &&
        // Car?
        RACE_DATA["player"][0]["car"]["selection"] == 0x05 &&
        trigger_when(opponent_crash_logic()) &&
        in_race()
)

achievement(
    title = "Grab and Hold",
    points = 3,
    description = "In Single Race or Championship mode, with the Pywackett Barchetta Super win a race while performing a Pit Stop at least twice",
    trigger = 
        (GAME_MODE == 0x01 || GAME_MODE == 0x04) &&
        never(reset_race() || !in_race()) &&
        RACE_DATA["player"][0]["car"]["selection"] == 0x09 &&
        // Race over? Did they win?
        trigger_when(check_if_race_finished() && check_if_in_first(0) && repeated(2, prev(RACE_DATA["player"][0]["drive_state"]) == 0xbf94 && RACE_DATA["player"][0]["drive_state"] == 0xbb9c))
)

achievement(
    title = "Chasing the Prey",
    points = 4,
    description = "With the Falcon in Single Race mode, win a Normal or Mirrored 4 lap race with 20 opponents present in Desert City without ever dropping down a position",
    trigger = 
        // Single Race
        GAME_MODE == 0x01 &&
        // Car?
        RACE_DATA["player"][0]["car"]["selection"] == 0x02 &&
        // Desert City?
        RACE_DATA["track"]["map"] == 0x03 &&
        // Cannot be reverse type
        get_map_reverse_state() == 0 &&
        // Laps?
        RACE_DATA["track"]["target_laps"] == 4 &&
        // Opponents?
        RACE_DATA["track"]["driver_count"] == 20 &&
        // In race?
        in_race() &&
        // Race over? Did they win?
        trigger_when(check_if_race_finished() && check_if_in_first(0)) &&
        // Disable if the player drops in position; reset if they reset the race
        disable_when(prev(RACE_DATA["player"][0]["position"]) < RACE_DATA["player"][0]["position"], until=reset_race())
)

achievement(
    title = "No Time for Brakes",
    points = 3,
    description = "With the Rule of the 9th in Single Race mode, finish a race on Dinosaur Canyon using Automatic transmission but without using the brakes on Normal difficulty or higher",
    trigger = 
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // Car?
        RACE_DATA["player"][0]["car"]["selection"] == 0x07 &&
        // AT?
        RACE_DATA["player"][0]["car"]["transmission"] == 0x00 &&
        // Single Race
        GAME_MODE == 0x01 &&
        // Dino Canyon?
        RACE_DATA["track"]["map"] == 0x02 &&
        // get break power input, retry when race starts again
        disable_when(RACE_DATA["player"][0]["pedal"]["brake"] != 0x00, until=reset_race()) &&
        // Unlock when..
        trigger_when(check_if_race_finished())
)

achievement(
    title = "The Classic",
    points = 3,
    description = "With the Hornet in Single Race mode, finish a 40 lap race on Three Seven Speedway on Normal difficulty or higher",
    trigger = 
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // Single Race
        GAME_MODE == 0x01 &&
        // Hornet only
        RACE_DATA["player"][0]["car"]["selection"] == 0x00 &&
        // Correct map?
        RACE_DATA["track"]["map"] == 0x00 &&
        // Laps?
        RACE_DATA["track"]["target_laps"] == 40 &&
        // Unlock when..
        trigger_when(check_if_race_finished())
)

function bump_into_obj_logic() {
  cond = always_true()
  // Player has to bump into all 35 items on Seaside Street Galaxy. Keep in mind that the first element is actually ID 1, not 0!
  for element in range(1, 0x23, 1)
  {
    cond = cond && (once(check_if_interactive_obj_moved(element)))
  }
  return cond
}

achievement(
    title = "A General Distaste for Signs",
    points = 2,
    description = "With the Pywackett Barchetta run into all signs and traffic cones on Sea-Side Street Galaxy in any mode except VS Battle",
    trigger = 
        // No VS mode
        GAME_MODE != 0x03 &&
        // Pywackett Barchetta only
        RACE_DATA["player"][0]["car"]["selection"] == 0x06 &&
        // Reset progress when not in a race or restarting race
        never(reset_race()) &&
        never(!in_race()) &&
        // For good measure - also reset when on wrong map
        never(0x01 != RACE_DATA["track"]["map"]) &&
        // Actual logic here
        trigger_when(bump_into_obj_logic())
)

achievement(
    title = "Rolling Thunder",
    points = 3,
    description = "With the Lightning, in Single Race mode win a 2 lap race with 40 opponents present on National Park Speedway",
    trigger = 
        // Single Race mode
        GAME_MODE == 0x01 &&
        // Pywackett Barchetta only
        RACE_DATA["player"][0]["car"]["selection"] == 0x03 &&
        in_race() &&
        RACE_DATA["track"]["target_laps"] == 2 &&
        RACE_DATA["track"]["map"] == 0x04 &&
        RACE_DATA["track"]["driver_count"] == 40 &&
        trigger_when(check_if_race_finished() && check_if_in_first(0))
)

achievement(
    title = "Just Like the Real Thing",
    points = 3,
    description = "With the Unicorn reach the goal on Rin Rin Rink while staying in the cockpit view mode at all times in any mode except VS Battle",
    trigger = 
        // No VS mode
        GAME_MODE != 0x03 &&
        // Unicorn only
        RACE_DATA["player"][0]["car"]["selection"] == 0x04 &&
        RACE_DATA["player"][0]["viewpoint"] == 0x01 &&
        disable_when(RACE_DATA["player"][0]["viewpoint"] != 0x01, until=(RACE_DATA["timing"]["total_time_raw"] == 0 && prev(RACE_DATA["timing"]["total_time_raw"] == 0))) &&
        // Correct map?
        RACE_DATA["track"]["map"] == 0x06 &&
        // Unlock when..
        trigger_when(check_if_race_finished())
)

achievement(
    title = "The Perfect Run",
    points = 3,
    description = "With the Grasshopper in Single Race mode, complete a lap with 40 opponents present in Desert City without crashing into a wall or an opponent",
    trigger = 
        // Single Race mode
        GAME_MODE == 0x01 &&
        // Grasshopper only
        RACE_DATA["player"][0]["car"]["selection"] == 0x01 &&
        // 40 opponents
        RACE_DATA["track"]["driver_count"] == 40 &&
        // Fail achievement upon collision
        disable_when(has_collided_with_object(0), until=(reset_race())) &&
        // Correct map?
        RACE_DATA["track"]["map"] == 0x03 &&
        // Unlock when..
        trigger_when(lap_completed())
)

TARGET_SPEED = 400

achievement(
    title = "Two Speeds",
    points = 10,
    description = format("With the Javelin reach a top speed of {0} km/h in any mode except VS Battle", TARGET_SPEED),
    trigger = 
        // No VS mode!
        GAME_MODE != 0x03 &&
        in_race() &&
        RACE_DATA["player"][0]["car"]["selection"] == 0x08 &&
        trigger_when(reach_speed(0, TARGET_SPEED))
)

achievement(
    title = "Pole Possession",
    points = 5,
    description = "In Championship mode, cross the finish line first for 5 laps in a row",
    trigger = 
        GAME_MODE == 0x04 &&
        repeated(5, lap_completed() && check_if_in_first(0)) &&
        never(lap_completed() && !check_if_in_first(0)) &&
        never(!in_race())
        // RACE_DATA["championship"]["chain_lead"] == 4 &&
        // prev(RACE_DATA["championship"]["chain_lead"]) == 3       
)

// LB for Normal type
for current_map_id in range(0, 7, 1) {
    leaderboard(
        title = format("{0} Normal & Mirror: Best Course Time", MapLookup[current_map_id]),
        // Get the fastest Course Time in a 8 lap race on the Normal or Mirrored version of Three Seven Speedway in any mode except VS Battle
        description = format("Get the fastest Course Time in a {1} lap race on the Normal or Mirrored version of {0} in any mode except VS Battle",
            MapLookup[current_map_id],
            FIXATION_LAP_RULES[current_map_id]
        ),
        start = 
            // No VS mode!
            GAME_MODE != 0x03 &&
            // On right correct map / track?
            current_map_id == RACE_DATA["track"]["map"] &&
            // Must be correct lap count
            FIXATION_LAP_RULES[current_map_id] == RACE_DATA["track"]["target_laps"] &&
            // Must be correct type
            get_map_type() <= 0x01 &&
            // Must be in a race
            in_race() && 
            check_if_race_finished(),
        cancel = (
            !in_race()
        ),
        submit = always_true(),
        value =
            measured(
                RACE_DATA["timing"]["total_time"]
        ),
        format = "MILLISECS", lower_is_better = true
    )
}

// LB for Reverse type
for current_map_id in range(0, 7, 1) {
    leaderboard(
        title = format("{0} Reverse & Reverse Mirror: Best Course Time", MapLookup[current_map_id]),
        description = format("Get the fastest Course Time in a {1} lap race on the Reverse or Reverse Mirrored version of {0} in any mode except VS Battle",
            MapLookup[current_map_id],
            FIXATION_LAP_RULES[current_map_id]
        ),
        start = 
            // No VS mode!
            GAME_MODE != 0x03 &&
            // On right correct map / track?
            current_map_id == RACE_DATA["track"]["map"] &&
            // Must be correct lap count
            FIXATION_LAP_RULES[current_map_id] == RACE_DATA["track"]["target_laps"] &&
            // Must be correct type
            get_map_type() >= 0x02 &&
            // Must be in a race
            in_race() && 
            check_if_race_finished(),
        cancel = (
            !in_race()
        ),
        submit = always_true(),
        value =
            measured(
                RACE_DATA["timing"]["total_time"]
        ),
        format = "MILLISECS", lower_is_better = true
    )
}