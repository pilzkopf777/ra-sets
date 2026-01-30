// Egg
// #ID = 25240

class PlayerObj {
    player_id = 0 // 1 for P1, 2 for P2...
    p_1_start = 0x157dcc // starts at status

    // Player Object size: 0x68
    // Status: +0x00 -> 0x14 for bit4 or 0x44 for bit6
    // Motion: +0x08
    // HP: +0x14
    // Tower: +0x16
    // Land %: +0x1C
    // Ability Energy: +0x1E

    function get_color() {
        start = 0x157dc4
        used_id = this.player_id - 1
        target_adr = (0x02 * used_id) + start
        return word(target_adr)
    }

    function get_hp() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x14
        return word(target_adr)
    }

    function get_tower_level() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x16
        return (word(target_adr) + 1) / 2
    }

    function is_moving() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x08
        return word(target_adr) == 0x01
    }

    function player_died() {
        // value rolls over on death
        return this.get_hp() > 5000 && prev(this.get_hp() < 1000) || this.get_hp() == 0 && prev(this.get_hp() < 1000) 
    }

    function get_claimed_land() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x1C
        return word(target_adr)
    }

    function get_energy() {
        used_id = this.player_id - 1
        target_adr = 0x157dcc + (used_id * 0x68) + 0x1E
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

/*
2 Players:
0x00 = 1, COM
0x10 = 1, 2
0x20 = COM, COM
3 Players:
0x30 = 1, COM, COM
0x40 = 1, 2, COM
0x50 = 1, 2, 3
0x60 = COM, COM, COM
4 Players:
0x70 = 1, COM, COM, COM
0x80 = 1, 2, COM, COM
0x90 = 1, 2, 3, COM
0xa0 = 1, 2, 3, 4
0xb0 = COM, COM, COM, COM
*/
player_count_map = {
    0x00: "2",
    0x10: "2",
    0x20: "2",
    0x30: "3",
    0x40: "3",
    0x50: "3",
    0x60: "3",
    0x70: "4",
    0x80: "4",
    0x90: "4",
    0xa0: "4",
    0xb0: "4"
}

function get_vs_player_combo() {
    return byte(0x157db9)
}

function get_player_count() {
    return player_count_map[get_vs_player_combo()]
}

function player_won_stage_pop_moment() {
    return word(0x157da8) == 0x00 && word(0x13fbf6) == 0x01 && prev(word(0x13fbf6) == 0x00)
}

function in_mission_mode() {
    return word(0x1cccf8) == 0x0100 && byte(0x157db9) == 0x00
}

// If this is true / value is above 1, the title screen was reached.
function screen_progression_started() {
    return word(0x0bbf62) > 0x00
}

/*
    Normally I would solve this like this but runtime logic won't do...

    if (player_2_obj.get_color() < player_1_obj.get_color()) {
        stage = player_2_obj.get_color() + 1
    } else {
        stage = player_2_obj.get_color()
    }

    Instead use a 2d matrix of sorts:
*/

// Keys 0-3 are the only PLAYABLE colors
mission_data = {
    0: [1, 2, 3, 4, 5, 6, 7], // Red:    B, Y, G, P
    1: [0, 2, 3, 4, 5, 6, 7], // Blue:   R, Y, G, P
    2: [0, 1, 3, 4, 5, 6, 7], // Yellow: R, B, G, P
    3: [0, 1, 2, 4, 5, 6, 7]  // Green:  R, B, Y, P
}

function is_on_mission(id) {
    conditions = []
    idx = id - 1
    
    for player_val in mission_data {
        opponent_val = mission_data[player_val][idx]
        array_push(conditions, player_1_obj.get_color() == player_val && player_2_obj.get_color() == opponent_val)
    }
    
    return any_of(conditions, c => c)
}

function get_mission_addendum() {
    return word(0x157dc0)
}

function is_secret_stage() {
    return word(0x157dc0) == 0x01
}

function is_b_stage() {
    return word(0x157dc0) == 0x02
}

function dev_logo_was_shown() {
    return word(0x0bbf58) > 0
}

function get_current_player_acting() {
    return word(0xc0684)
}

mission_addendum_map = {
    0x00: "",
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
            in_mission_mode() && get_mission_addendum() == 0x00 &&
            is_on_mission(current_mission) &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION {0} TURNS", current_mission),
        description = format("MISSION {0} TURNS", current_mission),
        start = 
        (
            in_mission_mode() && get_mission_addendum() == 0x00 &&
            is_on_mission(current_mission) &&
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
            in_mission_mode() && get_mission_addendum() == 0x01 &&
            is_on_mission(current_mission) &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION SECRET {0} TURNS", current_mission),
        description = format("MISSION SECRET {0} TURNS", current_mission),
        start = 
        (
            in_mission_mode() && get_mission_addendum() == 0x01 &&
            is_on_mission(current_mission) &&
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
            in_mission_mode() && get_mission_addendum() == 0x02 &&
            is_on_mission(current_mission) &&
            player_won_stage_pop_moment()
    )

    leaderboard(
        title = format("MISSION {0}-B TURNS", current_mission),
        description = format("MISSION {0}-B TURNS", current_mission),
        start = 
        (
            in_mission_mode() && get_mission_addendum() == 0x02 &&
            is_on_mission(current_mission) &&
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

function ach_logic_player_against_all_cpu() {
    return (
                // 2 Total Players, Mission Mode:
                in_mission_mode()
            ) ||
            (
                // 2 Total Players, VS mode: Combo is 0x00
                !in_mission_mode() && get_vs_player_combo() == 0x00
            ) ||
            (
                // 3 Total Players, VS mode: Combo is 0x30
                !in_mission_mode() && get_vs_player_combo() == 0x30
            ) ||
            (
                // 4 Total Players, VS mode: Combo is 0x70
                !in_mission_mode() && get_vs_player_combo() == 0x70
            )
}

// Variety achievements
achievement(
    title = format("CLAIM 15%"),
    points = 0,
    type = "",
    description = format("CLAIM 15% IN MATCH VS ALL CPU"),
    trigger = 
        (
            get_turn() > 0x01 &&
            player_1_obj.get_claimed_land() >= prev(player_1_obj.get_claimed_land()) + 15 &&
            get_current_player_acting() == 0x00
        ) && (
            ach_logic_player_against_all_cpu()
        )  
)

achievement(
    title = format("KILL AN EGG IN 15 TURNS"),
    points = 0,
    type = "",
    description = format("KILL AN EGG IN 15 TURNS"),
    trigger = 
        (
            // 2 Total Players, Mission Mode:
            in_mission_mode() &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_2_obj.player_died()
        ) ||
        (
            // 2 Total Players, VS mode: Combo is 0x00
            !in_mission_mode() && get_vs_player_combo() == 0x00 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_2_obj.player_died()
        ) ||
        (
            // 3 Total Players, VS mode: Combo is 0x30
            !in_mission_mode() && get_vs_player_combo() == 0x30 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_2_obj.player_died()
        ) ||
        (
            !in_mission_mode() && get_vs_player_combo() == 0x30 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_3_obj.player_died()
        ) ||
        (
            // 4 Total Players, VS mode: Combo is 0x70
            !in_mission_mode() && get_vs_player_combo() == 0x70 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_2_obj.player_died()
        ) ||
        (
            !in_mission_mode() && get_vs_player_combo() == 0x70 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_3_obj.player_died()
        ) ||
        (
            !in_mission_mode() && get_vs_player_combo() == 0x70 &&
            get_turn() <= 15 && get_turn() > 0x01 &&
            player_4_obj.player_died()
        )
)

achievement(
    title = format("OVERTAKE OPPONENT TOWER LEVEL SPEED"),
    points = 0,
    type = "",
    description = format("OVERTAKE OPPONENT TOWER LEVEL 3 SPEED IN MATCH VS ALL CPU"),
    trigger = 
        (
            // 2 Total Players, Mission Mode:
            in_mission_mode() && get_turn() > 0x01 && 
            player_1_obj.get_tower_level() >= player_2_obj.get_tower_level() + 3
        ) ||
        (
            // 2 Total Players, VS mode: Combo is 0x00
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x00 &&
            player_1_obj.get_tower_level() >= player_2_obj.get_tower_level() + 3
        ) ||
        (
            // 3 Total Players, VS mode: Combo is 0x30
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x30 &&
            player_1_obj.get_tower_level() >= player_2_obj.get_tower_level() + 3
        ) ||
        (
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x30 &&
            player_3_obj.get_tower_level() >= player_3_obj.get_tower_level() + 3
        ) ||
        (
            // 4 Total Players, VS mode: Combo is 0x70
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x70 &&
            player_2_obj.get_tower_level() >= player_2_obj.get_tower_level() + 3
        ) ||
        (
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x70 &&
            player_3_obj.get_tower_level() >= player_3_obj.get_tower_level() + 3
        ) ||
        (
            !in_mission_mode() && get_turn() > 0x01 && get_vs_player_combo() == 0x70 &&
            player_4_obj.get_tower_level() >= player_4_obj.get_tower_level() + 3
        )
)

achievement(
    title = format("DESTROY 5% OF OPPONENT WITH ABILITY"),
    points = 0,
    type = "",
    description = format("DESTROY 5% OF OPPONENT WITH ABILITY IN MATCH VS ALL CPU"),
    trigger = 
        (
            get_turn() > 0x01 &&
            get_current_player_acting() == 0x00
        ) && (
            (
                // 2 Total Players, Mission Mode:
                (   
                    in_mission_mode() &&
                    prev(player_2_obj.get_claimed_land()) >= 5 &&
                    // example: p2 now has 10, prev had 18 -> pop
                    // == 10                           == 18
                    player_2_obj.get_claimed_land() + 5 <= prev(player_2_obj.get_claimed_land())
                    
                )
            ) ||
            (
                // 2 Total Players, VS mode: Combo is 0x00
                (
                    !in_mission_mode() && 
                    prev(player_2_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x00 &&
                    player_2_obj.get_claimed_land() + 5 <= prev(player_2_obj.get_claimed_land())
                )
            ) ||
            (
                // 3 Total Players, VS mode: Combo is 0x30
                (
                    !in_mission_mode() && 
                    prev(player_2_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x30 &&
                    player_2_obj.get_claimed_land() + 5 <= prev(player_2_obj.get_claimed_land())
                ) ||
                (
                    !in_mission_mode() && 
                    prev(player_3_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x30 &&
                    player_3_obj.get_claimed_land() + 5 <= prev(player_3_obj.get_claimed_land())
                )
            ) ||
            (
                // 4 Total Players, VS mode: Combo is 0x70
                (
                    !in_mission_mode() && 
                    prev(player_2_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x70 &&
                    player_2_obj.get_claimed_land() + 5 <= prev(player_2_obj.get_claimed_land())
                ) ||
                (
                    !in_mission_mode() && 
                    prev(player_3_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x70 &&
                    player_3_obj.get_claimed_land() + 5 <= prev(player_3_obj.get_claimed_land())
                ) ||
                (
                    !in_mission_mode() && 
                    prev(player_4_obj.get_claimed_land()) >= 5 &&
                    get_vs_player_combo() == 0x70 &&
                    player_4_obj.get_claimed_land() + 5 <= prev(player_4_obj.get_claimed_land())
                )
            )
        )  
)

// I hate this so much but what will you do in a world without dynamic lookups?
lookup_mission_stage = {
    1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7", // Red
    10: "1", 12: "2", 13: "3", 14: "4", 15: "5", 16: "6", 17: "7", // Blue
    20: "1", 21: "2", 23: "3", 24: "4", 25: "5", 26: "6", 27: "7", // Yellow
    30: "1", 31: "2", 32: "3", 34: "4", 35: "5", 36: "6", 37: "7"  // Green
}

// RP
rich_presence_conditional_display(!screen_progression_started(), "Preparing to build a civilisation...")

rich_presence_conditional_display(get_turn() == 0x00, "In the Main Menu")

// Mission Mode Secret
rich_presence_conditional_display(in_mission_mode() && get_turn() != 0x00 && is_secret_stage(), "Mission Mode • {1}Stage {0}{1} • Turn {2}",
    // Multiply by 10 (decimal) to get individual matches in the lookup table
    rich_presence_lookup("Mission", (player_1_obj.get_color() * 10) + player_2_obj.get_color(), lookup_mission_stage),
    rich_presence_lookup("Mission Addendum", get_mission_addendum(), mission_addendum_map, fallback=""),
    rich_presence_value("Turn", get_turn())
)

// Mission Mode Normal
rich_presence_conditional_display(in_mission_mode() && get_turn() != 0x00, "Mission Mode • Stage {0} • Turn {1}",
    // Multiply by 10 (decimal) to get individual matches in the lookup table
    rich_presence_lookup("Mission", (player_1_obj.get_color() * 10) + player_2_obj.get_color(), lookup_mission_stage),
    rich_presence_value("Turn", get_turn())
)

// VS Mode
rich_presence_conditional_display(!in_mission_mode() && get_turn() != 0x00, "VS Mode • {0} Players • Turn {1}",
    rich_presence_lookup("Player Count", get_vs_player_combo(), player_count_map, fallback="?"),
    rich_presence_value("Turn", get_turn())
)

rich_presence_display("Preparing to build a civilisation...")