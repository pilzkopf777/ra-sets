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

SCREEN_STATE = byte(0x265bfd)

CURRENT_SCREEN_REF_1 = byte(0x2B66DE)
CURRENT_SCREEN_REF_2 = byte(0x2B66EA)


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
    return (raw_time / 64) * 100
}

function raw_time_to_formatted_timestamp(raw_time) {
    return raw_time
}

function check_if_race_finished() {
    return prev(RACE_DATA["player"][0]["progress"]["laps_completed"]) < RACE_DATA["track"]["target_laps"] &&
    RACE_DATA["player"][0]["progress"]["laps_completed"] == RACE_DATA["track"]["target_laps"]
}

function check_if_in_first(player_id) {
    return RACE_DATA["player"][player_id]["position"] == 1
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

UNLOCKS_W_O_RED_CAT = {
    "Pywackett Barchetta": bit6(0x291F68),
    "Rule of 9th": bit7(0x291F68),
    "Javelin": bit0(0x291f69),
    "P. B. Super": bit1(0x291f69)
}

RED_CAT_UNLOCK = bit5(0x291F68)

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
            "y": float(0x345B70),
            "z": float(0x345B74)
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
        "drive_state": word(0x345B58)
        },
        1: {
        "car": {
            "selection": byte(0x294a46),
            "transmission": byte(0x294a44),
            "tire": byte(0x294a48),
            "color": "n/a",
            "handicap": byte(0x294a49)
        },
        //"coordinates": {
        //    "x": float(0x345B6C),
        //    "y": float(0x345B70),
        //    "z": float(0x345B74)
        //},
        //"speed": word(0x345B64), // todo: translate
        //"speed_raw": float(0x345B84),
        //"position": byte(0x345BC0) + 1,
        //"gear": byte(0x345CAC),
        //"viewpoint": byte(0x265EFC),
        //"progress": {
        //    "checkpoints_completed": byte(0x345BC2),
        //    "laps_completed": byte(0x345BC4)
        //},
        //"drive_state": word(0x345B58)
        },
    },
    "track": {
        "map": get_current_map_id(),
        "type": get_map_type(),
        "target_laps": byte(0x294a41),
        "driver_count": byte(0x294a42)
    },
    "timing": {
        "countdown": raw_time_to_centiseconds(dword(0x265C34)),
        "total_time": raw_time_to_centiseconds(dword(0x265C30)),
        "best_time": raw_time_to_centiseconds(dword(0x29059C)),
        "best_lap_time": raw_time_to_centiseconds(dword(0x29189C)),
        "last_split_time": raw_time_to_centiseconds(dword(0x345bbc))
    }
}


FIXATION_LAP_RULES = {
    0x00: 3,
    0x01: 1,
    0x02: 0,
    0x03: 1,
    0x04: 2,
    0x05: 3,
    0x06: 2,
    0x07: 2
}

function get_points_score_for_1st_place_normal_achievement(map_id) {
    // If the achievement asks the player to run x laps, award y points
    // e.g. 2 laps -> 4pts
    lap_check = {
        0: 5, // 2 laps
        1: 4, // 4 laps
        2: 3, // 6 laps
        3: 2  // 8 laps
    }
    return lap_check[FIXATION_LAP_RULES[map_id]]
}

function get_points_score_for_tournament_achievement(tournament_id) {
    // TODO: Change
    tourney_check = {
        0x00: 5,
        0x01: 5,
        0x02: 10,
        0x03: 10 // ?
    }
    
    return tourney_check[tournament_id]
}

function get_progression_or_victory_for_tournament(tournament_id) {
    if (tournament_id == 0x03) {
        return "win_condition"
    } else {
        return "progression"
    }
}

TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS = {
    "normal": "[Normal]",
    "mirror": "[Mirror]",
    "reverse": "[Reverse]",
    "mirror_reverse": "[Mirror-Reverse]"
}

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
            "course_raw": 0,
            "course_string": "2'21\"734",
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
            "course_raw": 0,
            "course_string": "3'29\"531",
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
            "course_raw": 0,
            "course_string": "3'13\"968",
            "lap_raw": 0,
            "lap_string": ""
        },
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
            "course_raw": 0,
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
            "course_raw": 0,
            "course_string": "3'42\"859",
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
            "course_raw": 0,
            "course_string": "2'30\"312",
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
            "course_raw": 0,
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

OptionalRedCatUnlockLookup = {
    0x00: "",
    0x01: "",
    0x02: "",
    0x03: " and unlock the Red Cat"
}

function in_title_menu() {
    return SCREEN_STATE == 0x09 || SCREEN_STATE == 0x09 || SCREEN_STATE <= 0x03 || SCREEN_STATE >= 0x32
}

function in_race() {
    return (SCREEN_STATE == 0x14 || SCREEN_STATE == 0x16) || (SCREEN_STATE == 0x28 && GAME_MODE == 0x04)
}

// TODO: I hate the address for screen types. It works, but this needs a better "strategy":
// Title Screen, Menus, Race / Gameplay should be fine categories
// Rich Presence
rich_presence_conditional_display(in_title_menu(), "On the Title Screen")
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
    title = "In Single Race or Championship mode, complete a race on Normal difficulty or higher",
    points = 1,
    description = "In Single Race or Championship mode, complete a race on Normal difficulty or higher",
    trigger = 
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // Must be in a race
        in_race() &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
)


// 1st place on normal & fixation rules
for current_map_id in range(0, 7, 1) {
    achievement(
    title = format("In Single Race or Championship mode, finish in 1st place on {0} on Normal difficulty or higher", MapLookup[current_map_id]),
    points = get_points_score_for_1st_place_normal_achievement(current_map_id),
    description = format("In Single Race or Championship mode, finish in 1st place on {0} on Normal difficulty or higher", MapLookup[current_map_id]),
    trigger = 
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
for current_map_id in range(0, 7, 1) {
    achievement(
    title = format("In Single Race or Championship mode, reach the goal on {0} on Hard difficulty", MapLookup[current_map_id]),
    points = get_points_score_for_1st_place_normal_achievement(current_map_id),
    description = format("In Single Race or Championship mode, reach the goal on {0} on Hard difficulty", MapLookup[current_map_id]),
    trigger = 
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 2 &&
        // On right correct map / track?
        current_map_id == RACE_DATA["track"]["map"] &&
        // Must be correct lap count
        FIXATION_LAP_RULES[current_map_id] == RACE_DATA["track"]["target_laps"] &&
        // Cannot be reverse type
        get_map_reverse_state() == 0 &&
        // Must be in a race
        in_race() &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
    )
}

// Tournaments
for current_tournament in range(0, 3, 1) {
    achievement(
    title = format("Complete the {0} championship series", TournamentLookup[current_tournament]),
    points = get_points_score_for_tournament_achievement(current_tournament),
    type = get_progression_or_victory_for_tournament(current_tournament),
    description = format("Complete the {0} championship series{1}", TournamentLookup[current_tournament], OptionalRedCatUnlockLookup[current_tournament]),
    trigger = 
        GAME_MODE == 0x04 &&
        // TODO: logic here
        always_true()
    )
}

// Finish reverse race
achievement(
    title = "In Single Race mode, complete a reverse-type race with the fixation rulset of laps and drivers on Normal difficulty or higher",
    points = 1,
    description = "In Single Race mode, complete a reverse-type race with the fixation rulset of laps and drivers on Normal difficulty or higher",
    trigger = 
        // Medium difficulty or higher
        SETTINGS["difficulty"] >= 1 &&
        // Must be in a race
        in_race() &&
        // Must be reverse
        get_map_reverse_state() == 1 &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
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

MODE_TO_VAL_MAP = {
    "normal": 0x00,
    "mirror": 0x01,
    "reverse": 0x02,
    "mirror_reverse": 0x03
}

// Fastest course time (8 versions)
for current_map_id in TIME_ATTACK_COURSE_TIME_MISSION_TYPE {
    achievement(
    title = format("In Time attack mode, on {0} {1} beat the target time of {2} using the Fixation ruleset", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]], TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_string"]),
    points = 10,
    description = format("In Time attack mode, on {0} {1} beat the target time of {2} using the Fixation ruleset", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES_GENERIC_STRINGS[TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]], TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_string"]),
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
        RACE_DATA["timing"]["best_time"] < TIME_TRIAL_TARGET_TIMES[current_map_id][TIME_ATTACK_COURSE_TIME_MISSION_TYPE[current_map_id]]["course_raw"] &&
        // Pass the finish line with the correct lap count to get the achievement
        check_if_race_finished()
    )
}


// Fastest lap time (8 versions)
// TODO
/*
achievement(
title = format("In Time attack mode, on {0} beat the lap target time of {1}", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES[current_map_id]["lap_string"]),
points = 5,
description = format("In Time attack mode, on {0} beat the lap target time of {1}", MapLookup[current_map_id], TIME_TRIAL_TARGET_TIMES[current_map_id]["lap_string"]),
trigger = 
    // On right correct map / track?
    current_map_id == RACE_DATA["track"]["map"] &&
    // Must be basic type
    get_map_reverse_state() == 0 &&
    get_map_mirror_state() == 0 &&
    // Must be in a race
    in_race() &&
    // Must be meeting time criteria
    RACE_DATA["timing"]["last_split_time"] < TIME_TRIAL_TARGET_TIMES[current_map_id]["lap_raw"] &&
    // Pass the finish line with the correct lap count to get the achievement
    check_if_race_finished()
)
*/

// Unlock cars (no Red Cat since that one matches tournament unlock)
for current_car in UNLOCKS_W_O_RED_CAT {
    achievement(
    title = format("Unlock the {0}", current_car),
    points = 5,
    description = format("Unlock the {0}", current_car),
    trigger = 
        // On the unlock screen?
        SCREEN_STATE == 0x2e &&
        // Check moment of unlock
        prev(UNLOCKS_W_O_RED_CAT[current_car]) == 0 && UNLOCKS_W_O_RED_CAT[current_car] == 1
    )
}