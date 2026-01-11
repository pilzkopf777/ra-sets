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

function get_league_id() {
    return dword_be(0x106490f8)
}

function get_class() {
    return 0 // todo
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

function get_challenge_a_clear_count() {
    challenge_a_missions = []
    challenge_a_mission_start_adr = 0x106494a8

    for mission_id in range(0, 7, 1) {
        array_push(challenge_a_missions, dword_be(challenge_a_mission_start_adr + 0x04 * mission_id))
    }

    // challenge_a_missions now contains all mission flags (0 = uncleared, 1 = cleared, 2 = star clear)

    clear_count = sum_of(challenge_a_missions, value => value)

    return clear_count
}

function get_total_challenge_clear_count() {
    return get_challenge_a_clear_count()
}

function in_a_race() {
    return always_true() // todo
}

function on_title_screen() {
    return always_false() // todo
}


rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

// League race
rich_presence_conditional_display(in_a_race(), "Competing in the {0} League in {2} Class on {1} • {3} / 21 Challenges cleared",
    rich_presence_lookup("League", get_league(), league_map, fallback="unknown"),
    rich_presence_lookup("Track", get_formatted_track(), formatted_track_map, fallback="an unknown track"),
    rich_presence_lookup("Class", get_class(), class_map, fallback="an unknown"),
    rich_presence_value("Challenges Cleared", get_total_challenge_clear_count())
)

rich_presence_display("Getting ready to race...")