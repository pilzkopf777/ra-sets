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

RACE_TRACK_AND_TYPE = byte(0x2a6350)

CURRENT_SCREEN_REF_1 = byte(0x2B66DE)
CURRENT_SCREEN_REF_2 = byte(0x2B66EA)

function get_current_race_mode() {
    bit0(RACE_TRACK_AND_TYPE)
}

function get_current_map_id() {
    // Map is bit0-2. Thus, mask with 7 (bin 111) using modolo
    return RACE_TRACK_AND_TYPE % 8
}

function get_map_mirror_state() {
    return bit4(RACE_TRACK_AND_TYPE)
}

function get_map_reverse_state() {
    return bit3(RACE_TRACK_AND_TYPE)
}

function get_map_type() {
    // (bit3(0x2A6350) + bit3(0x2A6350) + bit4(0x2A6350)) == 3
    return (bit3(0x2A6350) + bit3(0x2A6350) + bit4(0x2A6350))
    // return (get_map_reverse_state() + get_map_reverse_state() + get_map_mirror_state())
}

function raw_time_to_centiseconds(raw_time) {
    return (raw_time / 64) * 100
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

GAME_PAUSED = bit1(byte(0x265D08))

UNLOCKS = {
    "Red Cat": bit5(0x291F68),
    "Pywackett Barchetta": bit6(0x291F68),
    "Rule of 9th": bit7(0x291F68),
    "Javelin": bit0(0x291f69),
    "P. B. Super": bit1(0x291f69)
}

PLAYER_CAR = {
    "selection": byte(0x1BE9AD),
    "transmission": byte(0x265EE8),
    "tire": "n/a",
    "color": "n/a"
}

PLAYER_DATA = {
    "unlockables": UNLOCKS,
    "total_play_time": raw_time_to_centiseconds(dword(0x291FDC))
}

RACE_DATA = {
    "player": {
        "car": PLAYER_CAR,
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
            "current_checkpoint": byte(0x345BC2) + 1,
            "current_lap": byte(0x345BC4) + 1
        },
        "drive_state": word(0x345B58)
    },
    "track": {
        "map": get_current_map_id(),
        "type": get_map_type()
    },
    "timing": {
        "countdown": raw_time_to_centiseconds(dword(0x265C34)),
        "total_time": raw_time_to_centiseconds(dword(0x265C30)),
        "best_time": raw_time_to_centiseconds(dword(0x29059C)),
        "best_lap_time": raw_time_to_centiseconds(dword(0x29189C))
    }
}

// Rich Presence
MapLookup = {
    0x00: "on Three Seven Speedway",
    0x01: "on Sea-Side Street Galaxy",
    0x02: "on Dinosaur Canyon",
    0x03: "in Desert City",
    0x04: "on National Park Speedway",
    0x05: "on Circuit Pixie",
    0x06: "on Rin Rin Rink",
    0x07: "on Mermaid Lake"
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
    0x00: "AT",
    0x01: "MT"
}

MapTypeLookup = {
    0x00: "",
    0x01: "(M)",
    0x02: "(R)",
    0x03: "(MR)"
}



// In (MODE)
// e.g. "In a Single Race with the Hornet AT"
rich_presence_conditional_display(CURRENT_SCREEN_REF_1 == 0x6c && CURRENT_SCREEN_REF_2 == 0x6f, "In a {0} with the {1} {2} {3}",
    rich_presence_lookup("Game Mode", GAME_MODE, GameModeLookup, fallback="questionable situation"),
    rich_presence_lookup("Car", RACE_DATA["player"]["car"]["selection"], CarLookup, fallback="unknown vehicle"),
    rich_presence_lookup("Map", RACE_DATA["track"]["map"], MapLookup, fallback="an unknown place"),
    rich_presence_lookup("Map Type", RACE_DATA["track"]["type"], MapTypeLookup, fallback="(?)")
)
rich_presence_display("test")