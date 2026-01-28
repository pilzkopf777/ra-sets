// Egg
// #ID = 25240

class PlayerObj {
    id = 0
    p_1_start = 

    function get_egg_color() {
        
    }

    function get_hp() {

    }

    function player_died() {
        return this.get_hp() < 1000 && prev(this.get_hp() >= 1000)
    }

    function get_claimed_land() {

    }

    function is_being_healed_by_own_nation() {
        return bit4()
    }

    function is_being_attacked_by_own_nation() {
        return bit6()
    }
}

function get_turn() {
    return word_be(0x157dbe)
}

function get_player_count() {
    return word_be(0x157dba)
}

function player_won_stage_pop_moment() {
    return word_be(0x157da8) == 0x00 && word_be(0x13fbf6) == 0x01 && prev(word_be(0x13fbf6) == 0x00)
}

function get_mode() {
    return word_be(0xbbf64)
}

mode_map = {
    0x00: "Mission",
    0x01: "VS"
}

function get_mission() {
    return word_be(0x157dc6)
}

function get_mission_addendum() {
    return word_be(0x157dc0)
}

mission_addendum_map = {
    0x01: "Secret",
    0x02: "-B"
}


// Achievements
for current_mission in range(0, 6, 1) {
    // Missions
    achievement(
        title = format("MISSION {0} CLEAR", current_mission),
        points = 0,
        type = "progression",
        description = format("MISSION {0} CLEAR", current_mission),
        trigger = 
            get_mode() == 0x00 && get_mission_addendum() == 0x00 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION {0} TURNS", current_mission),
        description = format("MISSION {0} TURNS", current_mission),
        start = 
        (
            get_mode() == 0x00 && get_mission_addendum() == 0x00 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_turn()
        ),
        format = "VALUE", lower_is_better = true
    )

    // Secret Missions
    achievement(
        title = format("MISSION SECRET {0} CLEAR", current_mission),
        points = 0,
        type = "",
        description = format("MISSION SECRET {0} CLEAR", current_mission),
        trigger = 
            get_mode() == 0x00 && get_mission_addendum() == 0x01 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION SECRET {0} TURNS", current_mission),
        description = format("MISSION SECRET {0} TURNS", current_mission),
        start = 
        (
            get_mode() == 0x00 && get_mission_addendum() == 0x01 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_turn()
        ),
        format = "VALUE", lower_is_better = true
    )

    // Missions X-B
    achievement(
        title = format("MISSION {0}-B CLEAR", current_mission),
        points = 0,
        type = "",
        description = format("MISSION {0}-B CLEAR", current_mission),
        trigger = 
            get_mode() == 0x00 && get_mission_addendum() == 0x02 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION {0}-B TURNS", current_mission),
        description = format("MISSION {0}-B TURNS", current_mission),
        start = 
        (
            get_mode() == 0x00 && get_mission_addendum() == 0x02 &&
            get_mission() == current_mission &&
            player_won_stage_pop_moment()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_turn()
        ),
        format = "VALUE", lower_is_better = true
    )
}


// RP
rich_presence_conditional_display(always_false(), "In the Main Menu")

// Mission Mode
rich_presence_conditional_display(get_mode() == 0x00 && always_true(), "Mission Mode • Stage {1} {0}{1} • Turn {2}",
    rich_presence_value("Mission", get_mission()),
    rich_presence_lookup("Mission Addendum", get_mission_addendum(), mission_addendum_map, fallback=""),
    rich_presence_value("Turn", get_turn()),
)

// VS Mode
rich_presence_conditional_display(get_mode() == 0x01 && always_true(), "VS Mode • {0} Players • Turn {1}",
    rich_presence_value("Player Count", get_player_count()),
    rich_presence_value("Turn", get_turn()),
)

rich_presence_display("Preparing to build a civilisation...")