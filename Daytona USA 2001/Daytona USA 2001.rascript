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

// SCREEN_STATE = byte(0x265bfd)

CURRENT_SCREEN = word(0x2B66DE)
/*
Reworked values for only this address:
0x0020 = Car / Map select
0x0017 = Main Menu
0x0025 = Title and Demo, Rankings
0x00cf = Dev logos
0xffff = Loading
0x004d = Championship exclusive menus
0x0033 = Ghost Car select, Memory Card, Race End Menu, Replay
0x0038 = Options
0x0028 = Records
0x006c = Race
0x0036 = Name Entry
0x0011 = New Car unlock
0x00a6 = TV setting
0x0000 = Initial boot
0x01cf = Initial logos on boot

0x01bc = 1st place celebration on 777 Speedway
0x0012 = Game Over after celebration

Start Your Engines:
0x01f5 = 777 Speedway
0x0205 = Dino Canyon
0x01fd = Seaside
0x020d = Desert City
0x0215 = National Park
0x021d = Ct. Pixie
0x0225 = Rin Rin Rink
0x022d = Mermaid Lake
*/

// Functions for player screen states
function screen_check(value) {
    return CURRENT_SCREEN == value || prior(CURRENT_SCREEN == value)
}

function on_title_screen() {
    // Special check for 0x0025: Also matches rankings after a race so additionally check for the main menu or title screen
    return (screen_check(0x0025) && GAME_MODE == 0) || screen_check(0x00cf) || screen_check(0x00a6) || screen_check(0x0000) || screen_check(0x01cf)
}

function on_victory_1st_series() {
    return CURRENT_SCREEN == 0x00f7 || prev(CURRENT_SCREEN == 0xffff)
}

function on_victory_2nd_series() {
    return CURRENT_SCREEN == 0x00ff || prev(CURRENT_SCREEN == 0xffff)
}

function on_victory_3rd_series() {
    return CURRENT_SCREEN == 0x0107 || prev(CURRENT_SCREEN == 0xffff)
}

function in_race() {
    return screen_check(0x006c) || screen_check(0x00cf) || screen_check(0x01bc) || screen_check(0x0012)
}

function reset_race() {
    return CURRENT_SCREEN == 0x006c && prev(CURRENT_SCREEN == 0xffff)
}

function on_car_unlock_screen() {
    return screen_check(0x0011)
}

function on_start_your_engines_screen() {
    return screen_check(0x01f5) || screen_check(0x0205) || screen_check(0x01fd) || screen_check(0x020d) ||
           screen_check(0x0215) || screen_check(0x021d) || screen_check(0x0225) || screen_check(0x022d)
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

INTERACTIVE_OBJ_COUNT_RAW_ADR = 0x34d664
INTERACTIVE_OBJ_COUNT = byte(INTERACTIVE_OBJ_COUNT_RAW_ADR)

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
        "speed": word(0x345B64), // todo: translate
        "speed_raw": float(0x345B84),
        "position": byte(0x345BC0) + 1,
        "gear": byte(0x345CAC),
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
        "speed": word(0x345e70), // todo: translate
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
        "last_split_time": raw_time_to_centiseconds(dword(0x345bbc))
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

TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS = {
    "normal": "[Normal]",
    "mirror": "[Mirror]",
    "reverse": "[Reverse]",
    "mirror_reverse": "[Mirror-Reverse]"
}

// These are the targets for the Time Attack achievements
// There's normal, reverse, mirror and mirror_reverse
// Missing objects do exist but are left out of this object due to laziness and due to not being used in the set design
TIME_TRIAL_TARGET_TIMES = {
    // Three Seven Speedway
    0x00: { //
        "normal": {
            "course_raw": 9031,
            "course_string": "2'21\"078",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": {
            "course_raw": 9071,
            "course_string": "2'21\"734",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
        },
    },
    // Sea-Side Street Galaxy
    0x01: {
        "normal": {        
            "course_raw": 11819,
            "course_string": "3'04\"671",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": {
            "course_raw": 13410,
            "course_string": "3'29\"531",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
        },
    },
    // Dinosaur Canyon
    0x02: {
        "normal": {        
            "course_raw": 13162,
            "course_string": "2'21\"078",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": {
            "course_raw": 12414,
            "course_string": "3'13\"968",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror_reverse": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
        }
    },
    // Desert City
    0x03: {
        "normal": {        
            "course_raw": 11975,
            "course_string": "3'07\"109",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror_reverse": {
            "course_raw": 11928,
            "course_string": "3'06\"375",
            "lap_raw": 0,
            "lap_string": ""
        }
    },
    // National Park Speedway
    0x04: {
        "normal": {        
            "course_raw": 14336,
            "course_string": "3'44\"000",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": {
            "course_raw": 14263,
            "course_string": "3'42\"859",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
        },
    },
    // Circuit Pixie
    0x05: {
        "normal": {        
            "course_raw": 9579,
            "course_string": "2'29\"671",
            "lap_raw": 0,
            "lap_string": ""
        },
        "reverse": {
            "course_raw": 9620,
            "course_string": "2'30\"312",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
        },
    },
    // Rin Rin Rink
    0x06: {
        "normal": {        
            "course_raw": 14188,
            "course_string": "3'41\"687",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror_reverse": {
            "course_raw": 14164,
            "course_string": "3'41\"312",
            "lap_raw": 0,
            "lap_string": ""
        }
    },
    // Mermaid Lake
    0x07: {
        "normal": {        
            "course_raw": 17177,
            "course_string": "4'28\"390",
            "lap_raw": 0,
            "lap_string": ""
        },
        "mirror_reverse": {
            "course_raw": 0,
            "course_string": "",
            "lap_raw": 0,
            "lap_string": ""
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
    points = 1,
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
    0x01: "Out of this World",
    0x02: "Canyon Fever",
    0x03: "Hot and Exciting",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: ""
}

// 1st place on normal & fixation rules
for current_map_id in range(0, 7, 1) {
    achievement(
    title = FIRST_PLACE_ACHIEVEMENT_NAME[current_map_id],
    points = get_points_score_for_compl_achievement(current_map_id),
    description = format("In Single Race or Championship mode, finish in 1st place on {0} [Normal / Mirror] on Normal difficulty or higher", MapLookup[current_map_id]),
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
    description = "In Single mode, reach the goal on any track with the fixation rulset of laps and drivers on Hard difficulty",
    trigger = 
        GAME_MODE == 0x01 &&
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 2 &&
        // Must be correct lap count
        // TODO: logic for this..
        FIXATION_LAP_RULES[0] == RACE_DATA["track"]["target_laps"] &&
        // TODO: Fixation driver count?
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
        GAME_MODE == 0x04 &&
        on_car_unlock_screen() &&
        prev(UNLOCKS["Unicorn"]) == 0 && UNLOCKS["Unicorn"] == 1
)

achievement(
    title = "Done with Road Safety",
    points = 5,
    description = "Unlock the Red Cat",
    trigger = 
        on_car_unlock_screen() &&
        prev(UNLOCKS["Red Cat"]) == 0 && UNLOCKS["Red Cat"] == 1
)

achievement(
    title = "Maserati's Law",
    points = 5,
    description = "Unlock the Rule of the 9th",
    trigger = 
        on_car_unlock_screen() &&
        prev(UNLOCKS["Rule of the 9th"]) == 0 && UNLOCKS["Rule of the 9th"] == 1
)

achievement(
    title = "And Who Are These Guys?",
    points = 5,
    description = "Unlock the Pywackett Barchetta",
    trigger = 
        on_car_unlock_screen() &&
        prev(UNLOCKS["Pywackett Barchetta"]) == 0 && UNLOCKS["Pywackett Barchetta"] == 1
)

achievement(
    title = "On Knife's Edge",
    points = 5,
    description = "Unlock the Pywackett Barchetta Super",
    trigger = 
        on_car_unlock_screen() &&
        prev(UNLOCKS["Pywackett Barchetta Super"]) == 0 && UNLOCKS["Pywackett Barchetta Super"] == 1
)

achievement(
    title = "To Be This Good Really Does Take Ages",
    points = 10,
    description = "Unlock the Javelin",
    trigger = 
        on_car_unlock_screen() &&
        prev(UNLOCKS["Javelin"]) == 0 && UNLOCKS["Javelin"] == 1
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

TIME_ATTACK_COURSE_TIME_ACHIEVEMENT_NAME = {
    0x00: "Reverse the Curse",
    0x01: "Starboard Speed",
    0x02: "Prehistoric Pace",
    0x03: "Mirage Run",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: ""
}

// Fastest course time (8 versions)
for current_map_id in TIME_ATTACK_COURSE_TIME_MISSION_TYPE {
    achievement(
    title = TIME_ATTACK_COURSE_TIME_ACHIEVEMENT_NAME[current_map_id],
    points = get_points_score_for_compl_achievement(current_map_id),
    description = format("In Time Attack mode, on {0} {1} beat the target time of {2} using the Fixation ruleset", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]], TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_string"]),
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

TIME_ATTACK_FLAP_TIME_ACHIEVEMENT_NAME = {
    0x00: "Taking it for a Spin",
    0x01: "",
    0x02: "",
    0x03: "",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: "Let's Go A-Wave"
}

// FLAP (8 versions)
for current_map_id in TIME_ATTACK_FLAP_MISSION_TYPE {
    achievement(
    title = TIME_ATTACK_FLAP_TIME_ACHIEVEMENT_NAME[current_map_id],
    points = get_points_score_for_compl_achievement(current_map_id),
    description = format("In Time Attack mode, on {0} {1} beat the fastest lap time of {2}", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]], TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_FLAP_MISSION_TYPE[current_map_id]]["lap_string"]),
    trigger = 
        always_false()
    )
}

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
    title = "The Classic",
    points = 3,
    description = "In Single Race mode, with the Hornet finish a race on Three Seven Speedway set to 40 laps",
    trigger = 
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

achievement(
    title = "Bumpscosity",
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
        bump_into_obj_logic()
)

achievement(
    title = "Rolling Thunder",
    points = 3,
    description = "In Single Race mode, with the Lightning win a race on National Park Speedway with the settings of 2 laps and 40 opponents present",
    trigger = 
        // Single Race mode
        GAME_MODE == 0x00 &&
        // Pywackett Barchetta only
        RACE_DATA["player"][0]["car"]["selection"] == 0x03 &&
        in_race() &&
        RACE_DATA["track"]["target_laps"] == 2 &&
        RACE_DATA["track"]["map"] == 0x04 &&
        RACE_DATA["track"]["driver_count"] == 40 &&
        check_if_in_first(0) && 
        check_if_race_finished()
)

achievement(
    title = "Just Like the Real Thing",
    points = 3,
    description = "With the Unicorn while staying in the cockpit view mode at all times reach the goal on Rin Rin Rink in any mode except VS Battle",
    trigger = 
        // No VS mode
        GAME_MODE != 0x03 &&
        // Unicorn only
        RACE_DATA["player"][0]["car"]["selection"] == 0x04 &&
        RACE_DATA["player"][0]["viewpoint"] == 0x01 &&
        // todo: add mercy time during countdown
        disable_when(RACE_DATA["player"][0]["viewpoint"] != 0x01, until=(RACE_DATA["timing"]["total_time_raw"] == 0)) &&
        // Correct map?
        RACE_DATA["track"]["map"] == 0x06 &&
        // Unlock when..
        trigger_when(check_if_race_finished())
)

achievement(
    title = "The Perfect Run",
    points = 3,
    description = "In Single Race mode, with the Grasshopper complete a lap in Desert City without crashing into a wall or an opponent with 40 opponents present",
    trigger = 
        // Single Race mode
        GAME_MODE == 0x00 &&
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
    points = 5,
    description = format("With the Javelin reach a top speed of {0} km/h", TARGET_SPEED),
    trigger = 
        in_race() &&
        // In all cases P1 can complete this mission 
        (RACE_DATA["player"][0]["car"]["selection"] == 0x08 && trigger_when(reach_speed(0, TARGET_SPEED))) ||
        // In VS mode, P2 could also do it
        (GAME_MODE == 0x03 && RACE_DATA["player"][1]["car"]["selection"] == 0x08 && trigger_when(reach_speed(1, TARGET_SPEED)))
)

achievement(
    title = "Pole Possession",
    points = 5,
    description = "In Championship mode, earn a Chain Lead bonus of 4 points",
    trigger = 
        in_race() &&
        RACE_DATA["championship"]["chain_lead"] == 4 &&
        prev(RACE_DATA["championship"]["chain_lead"]) == 3       
)

achievement(
    title = "drifting debug",
    points = 0,
    description = "drift please",
    trigger = 
        in_race()
)

// LB for Normal type
for current_map_id in range(0, 7, 1) {
    leaderboard(
        title = format("{0} [Normal / Mirror]: Best Course Time", MapLookup[current_map_id]),
        description = format("Get the fastest Course Time on {0} [Normal / Mirror] using the Fixation ruleset of {1} laps in any mode except VS Battle", MapLookup[current_map_id], FIXATION_LAP_RULES[current_map_id]),
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
        title = format("{0} [Reverse / Reverse-Mirror]: Best Course Time", MapLookup[current_map_id]),
        description = format("Get the fastest Course Time on {0} [Reverse / Mirror-Reverse] using the Fixation ruleset of {1} laps in any mode except VS Battle", MapLookup[current_map_id], FIXATION_LAP_RULES[current_map_id]),
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