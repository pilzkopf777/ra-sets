// Egg
// #ID = 25240

class PlayerObj {
    player_id = 0 // 1 for P1, 2 for P2...
    p_1_start = 0x157dcc // starts at status

    // Player Object size: 0x68
    // Status: +0x00 -> 0x14 for bit4 or 0x44 for bit6
    // HP: +0x14
    // Land %: +0x1C
    // Ability Energy: +0x1E

    function get_hp() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x14
        return word(target_adr)
    }

    function player_died() {
        return this.get_hp() < 1000 && prev(this.get_hp() >= 1000)
    }

    function get_claimed_land() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x1C
        return word(target_adr)
    }

    function is_being_healed_by_own_nation() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x00
        return bit4(target_adr)
    }

    function is_being_attacked_by_own_nation() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x00
        return bit6(target_adr)
    }
}

player_1_obj = PlayerObj(player_id = 1)
player_2_obj = PlayerObj(player_id = 2)
player_3_obj = PlayerObj(player_id = 3)
player_4_obj = PlayerObj(player_id = 4)

function get_turn() {
    return word(0x157dbe)
}

function get_player_count() {
    return word(0x157dba)
}

function player_won_stage_pop_moment() {
    return word(0x157da8) == 0x00 && word(0x13fbf6) == 0x01 && prev(word(0x13fbf6) == 0x00)
}

function get_mode() {
    return word(0xbbf64)
}

function in_main_menu() {
    return word(0x0bbf5c) == 0x01
}

// If this is true / value is above 1, the title screen was reached.
function screen_progression_started() {
    return word(0x0bbf62) > 0x00
}

mode_map = {
    0x00: "Mission",
    0x01: "VS"
}

function get_mission() {
    return word(0x157dc6)
}

function get_mission_addendum() {
    return word(0x157dc0)
}

function dev_logo_was_shown() {
    return word(0x0bbf58) > 0
}

mission_addendum_map = {
    0x01: "Secret ",
    0x02: "-B"
}

goal_desc = {
    0x01: "by claiming at least 30% of the land",
    0x02: "by breaking the opponent's egg",
    0x03: "by destroying the opponent's tower",
    0x04: "by letting your tower reach level 9",
    0x05: "by defeating the opponent by any means",
    0x06: "by defeating the opponent by any means",
    0x07: "by defeating the opponent by any means",
}

normal_goal_titles = {
    0x01: "",
    0x02: "",
    0x03: "",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: ""
}

secret_goal_titles = {
    0x01: "",
    0x02: "",
    0x03: "",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: ""
}

b_goal_titles = {
    0x01: "",
    0x02: "",
    0x03: "",
    0x04: "",
    0x05: "",
    0x06: "",
    0x07: ""
}

// Achievements
for current_mission in range(1, 7, 1) {
    // Missions
    achievement(
        title = format("MISSION {0} CLEAR", current_mission),
        points = 0,
        type = "progression",
        description = format("Clear Mission {0} {1}", current_mission, goal_desc[current_mission]),
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
        description = format("Clear the Secret Mission {0} {1}", current_mission, goal_desc[current_mission]),
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
        description = format("Clear Mission {0}-B {1}", current_mission, goal_desc[current_mission]),
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


achievement(
    title = format("DEBUG"),
    points = 0,
    type = "",
    description = format("DEBUG"),
    trigger = 
        player_1_obj.get_hp() == 1 && player_2_obj.get_hp() == 1 && player_3_obj.get_hp() == 1 && player_4_obj.get_hp() == 1
)

// RP
rich_presence_conditional_display(!screen_progression_started(), "Preparing to build a civilisation...")

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

// Mission Mode - hidden turn count before actual match begins
rich_presence_conditional_display(get_mode() == 0x00 && !in_main_menu() && get_turn() == 0, "Mission Mode • Stage {1}{0}{1}",
    rich_presence_value("Mission", get_mission()),
    rich_presence_lookup("Mission Addendum", get_mission_addendum(), mission_addendum_map, fallback="")
)

// Mission Mode
rich_presence_conditional_display(get_mode() == 0x00 && !in_main_menu(), "Mission Mode • Stage {1}{0}{1} • Turn {2}",
    rich_presence_value("Mission", get_mission()),
    rich_presence_lookup("Mission Addendum", get_mission_addendum(), mission_addendum_map, fallback=""),
    rich_presence_value("Turn", get_turn())
)

// VS Mode - hidden turn count before actual match begins
rich_presence_conditional_display(get_mode() == 0x01 && !in_main_menu() && get_turn() == 0, "VS Mode • {0} Players",
    rich_presence_value("Player Count", get_player_count())
)

// VS Mode
rich_presence_conditional_display(get_mode() == 0x01 && !in_main_menu(), "VS Mode • {0} Players • Turn {1}",
    rich_presence_value("Player Count", get_player_count()),
    rich_presence_value("Turn", get_turn())
)

rich_presence_display("Preparing to build a civilisation...")