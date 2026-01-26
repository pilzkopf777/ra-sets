// FAST: Racing League
// #ID = 35968

// Helper function taken from Souzooka - thanks!
WII_GAME_MASK = 0x1fffffff

function ptr(base, offsets, accessor=dword_be)
{
    val = base
    // Cool masking action in a seperate line
    val = val & WII_GAME_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            // Result also needs to 
            val = val & WII_GAME_MASK
        }
    }
    
    return val
}

function player_1_shifted() {
    return ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be) != prev(ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be))
}

function player_1_crashed() {
    return ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be) < 0x02 && // Value jumped too high: OOB
      prev(ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be)) >= 0x02 ||
           ptr(dword_be(0x531954), [0x20, 0x6c, 0x49C], float_be) == 1.0 && // Value moves from ~0.9 to 1.0: Explosion or Water
      prev(ptr(dword_be(0x531954), [0x20, 0x6c, 0x49C], float_be) < 1.0)
}

function player_1_in_1st() {
    return dword_be(0x10648a38) == 0x00
}

function get_total_race_time_in_frames() {
    return float_be(0x1064904c)
}

function get_track_id() {
    return dword_be(0x106490fc)
}

function get_league() {
    return dword_be(0x106490f8)
}

function get_formatted_track() {
    return get_league() * 0x10 + get_track_id()
}

// for use with get_formatted_track()
formatted_track_map = {
    0x00: "Cove Harbour",
    0x01: "Flood Area",
    0x02: "Turbine Canyon",
    0x03: "The Rig",
    0x10: "Rookie Beach",
    0x11: "Breeze City",
    0x12: "Scorpio Circuit",
    0x13: "Ice Park",
    0x20: "Dry Hill",
    0x21: "The Chillout",
    0x22: "Pyramid Valley",
    0x23: "Storm Creek"
}

// frames % 60 == 0 -> millis are 0
time_trial_targets = {
    0x00: 5100, //01'24"08
    0x01: 7800, //02'09"30
    0x02: 6300, //01'44"60
    0x03: 4800,
    0x10: 5820,
    0x11: 6720,
    0x12: 7380,
    0x13: 3840,
    0x20: 6000,
    0x21: 4860,
    0x22: 7380,
    0x23: 4620,
}


function in_challenge() {
    return dword_be(0x10642868) == 0x01
}

function in_multiplayer() {
    return dword_be(0x10648b0c) == 0x01
}

function get_challenge() {
    return dword_be(0x10642860) + 1
}

function flyover_started() {
    return dword_be(0x10648b00) == 0x01 && prev(dword_be(0x10648b00)) == 0x00
}

function in_flyover() {
    return dword_be(0x10648b00) == 0x00
}

class_map = {
    0x00: "Neutron",
    0x01: "Proton",
    0x02: "Ion"
}

league_map = {
    0x00: "Shima",
    0x01: "Siberia",
    0x02: "Sunahara"
}

function get_challenge_clear_count(star_only, start_adr) {
    challenge_missions = []

    for mission_id in range(0, 6, 1) {
        // Add the 0th and 1st bit to the array.
        // If a mission was cleared the 0th bit will be 1, if star-cleared the 1st bit will be 1.
        // Both cannot be 1 at the same time.
        // Thus, every entry which was cleared adds the value 1 to the array. Others add 0.

        // Stars always count
        array_push(challenge_missions, bit(1, start_adr + 0x03 + 0x04 * mission_id))
        if (star_only == false) {
            // Normal clears only if stars are optional
            array_push(challenge_missions, bit(0, start_adr + 0x03 + 0x04 * mission_id))
        }
    }

    // Returns 0 through 7, amount of cleared missions
    return sum_of(challenge_missions, value => value)

}

challenge_mission_a_start_adr = 0x106494a8
challenge_mission_b_start_adr = 0x106494c4
challenge_mission_c_start_adr = 0x106494e0

cleared_a_missions = get_challenge_clear_count(false, challenge_mission_a_start_adr)
cleared_b_missions = get_challenge_clear_count(false, challenge_mission_b_start_adr)
cleared_c_missions = get_challenge_clear_count(false, challenge_mission_c_start_adr)

star_cleared_a_missions = get_challenge_clear_count(true, challenge_mission_a_start_adr)
star_cleared_b_missions = get_challenge_clear_count(true, challenge_mission_b_start_adr)
star_cleared_c_missions = get_challenge_clear_count(true, challenge_mission_c_start_adr)

function get_total_challenge_clear_count() {
    return cleared_a_missions + cleared_b_missions + cleared_c_missions
}

function in_a_race() {
    return dword_be(0x002801cc) == 0x01
}

function in_main_menu() {
    return dword_be(0x1067bba8) == 0x01 || dword_be(0x002801cc) == 0x00
}

function game_paused() {
    return dword_be(0x00530e40) == 0x01
}

function league_text_just_displayed() {
    return dword_be(0x002802cc) == 0x01 && prev(dword_be(0x002802cc) == 0x00)
}

function challenge_or_qualification_text_just_displayed() {
    return dword_be(0x10642880) == 0x01 && prev(dword_be(0x10642880) == 0x00)
}

function get_class() {
    // 0, 1, 2
    return bit0(0x10648d3b) + bit1(0x10648d3b)
}

function get_qualification_round() {
    return dword_be(0x10642844)
}

function get_qualification_step() {
    return ptr(dword_be(0x003ad7f0), [0x0c], dword_be)
}

function is_boosting() {
    return ptr(dword_be(0x003ab39c), [0x0c], dword_be) == 0x01
}

function get_laps_completed() {
    return ptr(dword_be(0x00531954), [0x20, 0x6c, 0x124], dword_be)
}

function pad_to_twos(input) {
    input = "" + input
    if (length(input) == 1) {
        res = "0" + input
    } else {
        res = input
    }
    
    return res
}

function frame_time_to_next_second(frames) {
    fps = 60

    // truncate any fractional frames
    frames = frames - (frames % 1)

    leftover = frames % fps
    if (leftover == 0) {
        return frames
    }
    return frames + (fps - leftover)
}

function frame_time_to_readable_string(frames) {
    fps = 60

    // frames = frame_time_to_next_second(frames)

    total_seconds = frames / fps
    minutes = total_seconds / 60
    seconds = total_seconds % 60

    leftover_frames = frames % fps
    millis = (leftover_frames * 100) / fps

    return format("{0}:{1}:{2}", pad_to_twos(minutes), pad_to_twos(seconds), pad_to_twos(millis))
}

// Achievements

// Keep Boosting
achievement(
    title = format("LONG BOOST"),
    points = 0,
    description = format("LONG BOOST"),
    trigger = 
        in_a_race() && !in_multiplayer() && !in_challenge() &&
        never(!is_boosting()) &&
        repeated(200, is_boosting() && !game_paused())
)

// No shift
achievement(
    title = format("Shift Happens"),
    points = 2,
    description = format("Win a race in League or FAST Records mode without shifting"),
    trigger = 
        in_a_race() && !in_multiplayer() && !in_challenge() &&
        disable_when(player_1_shifted(), until=in_flyover()) &&
        trigger_when(
            get_laps_completed() == 3 && prev(get_laps_completed()) == 2 && player_1_in_1st()
        )
)

// No Crash
// achievement(
//     title = format("Insurance"),
//     points = 0,
//     description = format("Win a race in League or FAST Records mode without crashing"),
//     trigger = 
//         in_a_race() && !in_multiplayer() && !in_challenge() &&
//         disable_when(player_1_crashed(), until=in_flyover()) &&
//         trigger_when(
//             get_laps_completed() == 3 && prev(get_laps_completed()) == 2 && player_1_in_1st()
//         )
// )
achievement(
    title = format("Insurance"),
    points = 2,
    description = format("Win a race in League or FAST Records mode without crashing"),
    trigger = 
        in_a_race() && !in_multiplayer() && !in_challenge() &&
        disable_when(ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be) < 0x02 && // Value jumped too high: OOB
                prev(ptr(dword_be(0x531954), [0x20, 0x6c, 0x310], dword_be)) >= 0x02,
            until=in_flyover()) &&
        disable_when(ptr(dword_be(0x531954), [0x20, 0x6c, 0x49C], float_be) == 1.0 && // Value moves from ~0.9 to 1.0: Explosion or Water
                prev(ptr(dword_be(0x531954), [0x20, 0x6c, 0x49C], float_be) < 1.0),
            until=in_flyover()) &&
        trigger_when(
            get_laps_completed() == 3 && prev(get_laps_completed()) == 2 && player_1_in_1st()
        )
)


// Qualification
achievement(
    title = format("Cleared for Takeoff"),
    points = 1,
    description = format("Qualify for the FAST Racing League"),
    trigger = 
        in_a_race() && !in_multiplayer() && !in_challenge() &&
        get_qualification_round() == 4 &&
        get_qualification_step() == 4 &&
        challenge_or_qualification_text_just_displayed()
)

// Clear Cup
class_qips = ["Pulsar", "Magnetar", "Quasar"]
class_pts = [5, 10, 25]
for current_class in range(0, 2, 1) {
    current_class_name = class_map[current_class]

    for current_league in range(0, 2, 1) {
        current_league_name = league_map[current_league]

        achievement(
            title = format("The {0} Champion in {1}", class_qips[current_class], current_league_name),
            points = class_pts[current_class],
            description = format("Win in the {1} League in the {0} Class", current_class_name, current_league_name),
            trigger = 
                in_a_race() && !in_multiplayer() &&
                get_class() == current_class &&
                get_league() == current_league &&
                get_track_id() == 0x04 &&
                league_text_just_displayed() &&
                // better than player 2, 3, ..., 8
                dword_be(0x10648b28) >= dword_be(0x10648b2c) &&
                dword_be(0x10648b28) >= dword_be(0x10648b30) &&
                dword_be(0x10648b28) >= dword_be(0x10648b34) &&
                dword_be(0x10648b28) >= dword_be(0x10648b38) &&
                dword_be(0x10648b28) >= dword_be(0x10648b3c) &&
                dword_be(0x10648b28) >= dword_be(0x10648b40) &&
                dword_be(0x10648b28) >= dword_be(0x10648b44)
        )
    }
}

// Clear Missions
achievement(
    title = format("Holding the Line"),
    points = 5,
    description = format("Complete all Level A missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_a_missions == 7) && prev(cleared_a_missions == 6)
)

achievement(
    title = format("Edge of Control"),
    points = 5,
    description = format("Complete all Level B missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_b_missions == 7) && prev(cleared_b_missions == 6)
)

achievement(
    title = format("Limit Break"),
    points = 10,
    description = format("Complete all Level C missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_c_missions == 7) && prev(cleared_c_missions == 6)
)

// Star Clear
achievement(
    title = format("Protostar"),
    points = 10,
    description = format("Earn a star rating in all level A missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_a_missions == 7) && prev(cleared_a_missions == 6)
)

achievement(
    title = format("Main Sequence"),
    points = 10,
    description = format("Earn a star rating in all level B missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_b_missions == 7) && prev(cleared_b_missions == 6)
)

achievement(
    title = format("Supernova"),
    points = 25,
    description = format("Earn a star rating in all level C missions"),
    trigger = 
        in_challenge() &&
        measured(cleared_c_missions == 7) && prev(cleared_c_missions == 6)
)

// Leaderboards, Target Times
for element in formatted_track_map {
    track_name = formatted_track_map[element]
    track_id = element

    leaderboard(
        title = format("Time Attack: {0} (Ion Class)", track_name),
        description = format("Reach the goal as quickly as possible on {0} in Ion Class in either a League or FAST Record race", track_name),
        start = 
        (
            in_a_race() && !in_multiplayer() &&
            get_formatted_track() == element &&
            get_class() == 2 &&
            // must be time trial or gp -> anything that is not challenge or qualification
            get_qualification_round() == 0x00 &&
            !in_challenge() &&
            get_laps_completed() == 3 && prev(get_laps_completed()) == 2
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_total_race_time_in_frames()
        ),
        format = "FRAMES", lower_is_better = true
    )

    achievement(
        title = format("Full Throttle: {1}", frame_time_to_readable_string(time_trial_targets[track_id]), track_name),
        points = 10,
        description = format("Reach the goal in {0} or less on {1} in Ion Class in either a League or FAST Record race", frame_time_to_readable_string(time_trial_targets[track_id]), track_name),
        trigger = 
            in_a_race() && !in_multiplayer() &&
            get_formatted_track() == element &&
            get_class() == 2 &&
            get_qualification_round() == 0x00 &&
            !in_challenge() &&
            get_laps_completed() == 3 && prev(get_laps_completed()) == 2 &&
            get_total_race_time_in_frames() > time_trial_targets[track_id]
    )

}


rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

// Qualifiers
rich_presence_conditional_display(in_a_race() && get_qualification_round() >= 0x01, "Qualifiying for the FAST - Racing League • {0} / 21 Challenges cleared",
    rich_presence_value("Challenges Cleared", get_total_challenge_clear_count())
)

// Ceremony
rich_presence_conditional_display(in_a_race() && !in_challenge() && get_track_id() == 0x04, "In the Victory Ceremony ({2} Class) • {3} / 21 Challenges cleared",
    rich_presence_lookup("League", get_league(), league_map, fallback="unknown"),
    rich_presence_lookup("Track", get_formatted_track(), formatted_track_map, fallback="an unknown track"),
    rich_presence_lookup("Class", get_class(), class_map, fallback="an unknown"),
    rich_presence_value("Challenges Cleared", get_total_challenge_clear_count())
)

// League race
rich_presence_conditional_display(in_a_race() && !in_challenge(), "Competing on {1} ({2} Class) • {3} / 21 Challenges cleared",
    rich_presence_lookup("League", get_league(), league_map, fallback="unknown"),
    rich_presence_lookup("Track", get_formatted_track(), formatted_track_map, fallback="an unknown track"),
    rich_presence_lookup("Class", get_class(), class_map, fallback="an unknown"),
    rich_presence_value("Challenges Cleared", get_total_challenge_clear_count())
)

// Single Race / FAST Records
// todo

// Challenge race
rich_presence_conditional_display(in_a_race() && in_challenge(), "Tackling Challenge #{0} • {1} / 21 Challenges cleared",
    rich_presence_value("Challenge", get_challenge()),
    rich_presence_value("Challenges Cleared", get_total_challenge_clear_count())
)

rich_presence_display("Getting ready to race...")