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

class RacerData {
    id = 0

    league_score_start_adr = 0x10648b28

    function is_in_1st() {
        return dword_be(0x10648a38) == this.id
    }

    function get_league_score() {
        return dword_be(league_score_start_adr + 0x04 * this.id)
    }
}

function get_total_race_time_in_frames() {
    return float_be(0x1064904c)
}

function get_track_id() {
    return dword_be(0x106490fc)
}

function get_formatted_track() {
    return get_league_id() * 0x10 + get_track_id()
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

function get_league() {
    return dword_be(0x106490f8)
}

function in_challenge() {
    return dword_be(0x10642868) == 0x01
}

function get_challenge() {
    return dword_be(0x10642860) + 1
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

    for mission_id in range(0, 7, 1) {
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

function get_total_challenge_clear_count() {
    return get_challenge_clear_count(false, challenge_mission_a_start_adr) + get_challenge_clear_count(false, challenge_mission_b_start_adr) + get_challenge_clear_count(false, challenge_mission_c_start_adr)
}

function in_a_race() {
    return dword_be(0x002801cc) == 0x01
}

function on_title_screen() {
    return dword_be(0x002801cc) == 0x00
}

function game_paused() {
    return dword_be(0x00530e40)
}

function text_just_displayed() {
    return dword_be(0x002802cc) == 0x01 && prev(dword_be(0x002802cc) == 0x00)
}

function get_class() {
    // 0, 1, 2
    return bit0(0x10648d3b) + bit1(0x10648d3b)
}

function get_qualifiaction_round() {
    return dword_be(0x10642844)
}

function get_qualification_step() {
    return ptr(dword_be(0x003ad7f0), [0x0c], dword_be)
}

rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

// Qualifiers
rich_presence_conditional_display(in_a_race() && get_qualifiaction_round() >= 0x01, "Qualifiying for the FAST - Racing League • {0} / 21 Challenges cleared",
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