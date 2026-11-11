// TrickStyle
// #ID = 22056

// Helper function taken from Souzooka - thanks! 

function ptr(base, offsets, accessor=tbyte)
{
    val = base

    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = tbyte(addr)
        }
    }
    
    return val
}

map_id = ptr(tbyte(0x11b890), [0x00], dword)
checkpoint_count = ptr(tbyte(0x11b890), [0xBBC, 0x1A8], dword)

function credits_started() {
    return float(0x0ed4f4) > 0.1 && prev(float(0x0ed4f4) <= 0.1)
}

main_menu_state = dword(0x0ef4b0)
title_screen_anim_timer = float(0x0ef4b4)
player_count = dword(0x0efe5c)

pause_state = dword(0x57f95c)

function hud_pause_inactive() {
    return dword(0x580ef0) == 0x01
}

function hud_pause_active() {
    return dword(0x580ef0) == 0x00
}

function in_single_player() {
    return player_count == 0x01
}

function in_two_player() {
    return player_count == 0x02
}

function in_demo() {
    return player_count == 0x00 && main_menu_state == 0x00
}

function on_the_title_screen() {
    return main_menu_state == 0x02 || main_menu_state == 0x01
}

function in_main_menu() {
    return main_menu_state == 0x03
}

function in_gameplay() {
    return !on_the_title_screen() && !in_main_menu() // && !in_demo()
}

function completed_event(event_result_slot_adr) {
    return bit2(event_result_slot_adr) == 1
}

function tally_progression_data(lower_limit, upper_limit) {
    cond = []

    start_id_slot_adr = 0x143c7a
    start_result_slot_adr = 0x143cba

    for current_offset in range(0, 40, 1) {

        array_push(cond,
            (
                once(
                    // meets lower limit req
                    byte(start_id_slot_adr + current_offset) >= lower_limit && 
                    // and higher too
                    byte(start_id_slot_adr + current_offset) <= upper_limit &&
                    // and the mission was completed
                    completed_event(start_result_slot_adr + current_offset) &&
                    prev(!completed_event(start_result_slot_adr + current_offset))
                )
            )
        )
    }

    return cond
}

function check_if_player_completed_obj_logic(target_amount_of_maps, lower_limit, upper_limit) {
        if (lower_limit == upper_limit) {
            // No range - use simplified check instead
            return tally(target_amount_of_maps, tally_progression_data(lower_limit, upper_limit)) && never(in_main_menu() || on_the_title_screen())
        } else {
            return measured(
                tally(target_amount_of_maps, tally_progression_data(lower_limit, upper_limit))) && never(in_main_menu() || on_the_title_screen()
            )
        }
}

map_map = {
    0x01: "the Velodrome",
    0x02: "the Velodrome", // Tutorial
    0x03: "the Velodrome",
    0x04: "the Velodrome",
    0x05: "the Velodrome",
    0x06: "the Velodrome",
    0x15: "UK Race 1",
    0x16: "UK Race 2",
    0x17: "UK Race 3",
    0x18: "UK Race 4",
    0x19: "UK Race 5",
    0x1B: "Stuntbowl UK",
    0x1F: "USA Race 1",
    0x20: "USA Race 2",
    0x21: "USA Race 3",
    0x22: "USA Race 4",
    0x23: "USA Race 5",
    0x25: "Backstreets USA",
    0x29: "Japan Race 1",
    0x2A: "Japan Race 2",
    0x2B: "Japan Race 3",
    0x2C: "Japan Race 4",
    0x2D: "Japan Race 5",
    0x2F: "Skydome Japan",
    0x07: "Guide Race 1",
    0x08: "Globe Switch 1",
    0x09: "Magno Race 1",
    0x0a: "Globe Collect 1",
    0x0b: "Stunt Session 1",
    0x0c: "Guide Race 2",
    0x0d: "Stunt Session 2",
    0x0e: "Globe Collect 2",
    0x0f: "Hoop Race 1",
    0x10: "Globe Switch 2",
    0x11: "Guide Race 3",
    0x12: "Stunt Session 3",
    0x13: "Magno Race 3",
    0x14: "Hoop Race 2",
    0x30: "Globe Switch 3",
    0x31: "Final Challenge",
    // VS Maps start here
    0x34: "Stunt Session",
    0x35: "Globe Switch",
    0x36: "Hoop Race",
    0x37: "Base Collect",
    0x3c: "Stuntbowl UK",
    0x3d: "Backstreets USA",
    0x3e: "Skydome Japan",
}


char_map = {
    0x01: "Angel",
    0x02: "Brad",
    0x03: "King",
    0x04: "Mia",
    0x05: "Rose",
    0x06: "Max",
    0x07: "Shin",
    0x08: "Uri",
    0x09: "Zak",
}

board_map = {
    0x00: "Rookie",
    0x01: "Turbo",
    0x02: "Stunt",
    0x03: "Combat"
}

function trick_is_special_orb(trick_num) {
    return trick_num >= 0x191 && trick_num <= 0x200
}

class PlayerObject {

    function get_char() {
        return byte(0x143c78)
    }

    function get_char_p2() {
        return byte(0x143f24)
    }

    function get_board() {
        return byte(0x143c79)
    }

    function get_board_p2() {
        return byte(0x143f25)
    }

    function on_floor() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x3E0, 0x70], dword) == 0x01
        // return ptr(tbyte(0x1c5f40), [0xF4], dword) == 0x01
    }

    function mid_air() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x3E0, 0x70], dword) == 0x00
        // return ptr(tbyte(0x1c5f40), [0xF4], dword) == 0x00
    }

    function get_x() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x2C, 0x04, 0x40], float)
    }

    function get_y() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x2C, 0x04, 0x44], float)
    }

    function get_z() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x2C, 0x04, 0x48], float)
    }

    function get_race_pos() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x238], dword)
    }

    function get_trick() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x2E8], dword)
    }

    function get_score() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x3A8], dword)
    }

    function get_time_spent() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x230], float) 
    }

    function reached_race_goal_checkpoint(amount_of_checkpoints) {
        return ptr(tbyte(0x11b890), [0xBBC, 0x1A8], dword) == amount_of_checkpoints + 1 && prev(ptr(tbyte(0x11b890), [0xBBC, 0x1A8], dword) == amount_of_checkpoints)
    }

    function in_crash_state() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x2C4, 0x08, 0x48], dword) == 0x01
    }

    function not_in_crash_state() {
        return ptr(tbyte(0x11b890), [0xBBC, 0x2C4, 0x08, 0x48], dword) == 0x00
    }

    function entered_area(x1, x2, y1, y2, z1, z2) {
        x_pos = this.get_x()
        y_pos = this.get_y()
        z_pos = this.get_z()

        // e.g. box at x1 10, x2 20, y1 0, y2 20, z1 50, z2 60
        // player at x 15, y 10, z 40: valid
        cond1 = x1 <= x_pos
        cond4 = x2 >= x_pos

        cond2 = y1 <= y_pos
        cond5 = y2 >= y_pos

        cond3 = z1 <= z_pos
        cond6 = z2 >= z_pos

        return cond1 && cond2 && cond3 && cond4 && cond5 && cond6
    }

}

player = PlayerObject()

achievement(
    title = format("Teacher's Pet"),
    points = 0,
    description = format("Complete all of the Guide's training lessons"),
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(5, 0x02, 0x06) &&
        in_gameplay()
    )
)

achievement(
    title = format("Mind the Gap"),
    points = 0,
    description = format("In Single Player mode, win every race in the UK"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(5, 0x15, 0x19) &&
        in_gameplay()
    )
)

achievement(
    title = format("Queen of the Hill"),
    points = 0,
    description = format("In Single Player mode, win the boss challenge in the UK"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(1, 0x1b, 0x1b) &&
        in_gameplay()
    )
)

achievement(
    title = format("Born to Board in the USA"),
    points = 0,
    description = format("In Single Player mode, win every race in the USA"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(5, 0x1f, 0x23) &&
        in_gameplay()
    )
)

achievement(
    title = format("The Big Cheese"),
    points = 0,
    description = format("In Single Player mode, win the boss challenge in the USA"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(1, 0x25, 0x25) &&
        in_gameplay()
    )
)

achievement(
    title = format("Way of the Winner"),
    points = 0,
    description = format("In Single Player mode, win the first four races in Japan"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(4, 0x29, 0x2c) &&
        in_gameplay()
    )
)

achievement(
    title = format("Way of the Board"),
    points = 0,
    description = format("In Single Player mode, win the boss challenge in Japan"),
    type = "progression",
    trigger = (
        in_single_player() &&
        check_if_player_completed_obj_logic(1, 0x2f, 0x2f) &&
        in_gameplay()
    )
)

achievement(
    title = format("Guide Dang It!"),
    points = 0,
    description = format("In Single Player mode, win the final race against the Guide"),
    type = "win_condition",
    trigger = (
        in_single_player() &&
        map_id == 0x2d &&
        credits_started() &&
        in_gameplay()
    )
)

time_trial_map_dict = {
    0x15: "UK Race 1",
    0x16: "UK Race 2",
    0x17: "UK Race 3",
    0x18: "UK Race 4",
    0x19: "UK Race 5",
    0x1F: "USA Race 1",
    0x20: "USA Race 2",
    0x21: "USA Race 3",
    0x22: "USA Race 4",
    0x23: "USA Race 5",
    0x29: "Japan Race 1",
    0x2A: "Japan Race 2",
    0x2B: "Japan Race 3",
    0x2C: "Japan Race 4",
    0x2D: "Japan Race 5",
}

time_trial_ach_titles = {
    0x15: "",
    0x16: "",
    0x17: "",
    0x18: "",
    0x19: "",
    0x1F: "",
    0x20: "",
    0x21: "",
    0x22: "",
    0x23: "",
    0x29: "",
    0x2A: "",
    0x2B: "",
    0x2C: "",
    0x2D: ""
}

time_trial_map_checkpoint_count = {
    0x15: 3,
    0x16: 3,
    0x17: 3,
    0x18: 3,
    0x19: 3,
    0x1F: 3,
    0x20: 3,
    0x21: 3,
    0x22: 3,
    0x23: 4,
    0x29: 3,
    0x2A: 3,
    0x2B: 3,
    0x2C: 3,
    0x2D: 1,
}

time_trial_targets = {
    0x15: 74.0, // 01:14:00
    0x16: 80.0, // 01:20:00
    0x17: 95.0, // 01:35:00
    0x18: 79.0, // 01:19:00
    0x19: 100.0, // 01:40:00
    0x1F: 73.0, // 01:13:00
    0x20: 101.0, // 01:41:00
    0x21: 83.0, // 01:23:00
    0x22: 63.0, // 01:03:00
    0x23: 110.0, // 01:50:00
    0x29: 83.0, // 01:23:00
    0x2A: 93.0, // 01:33:00
    0x2B: 75.0, // 01:15:00
    0x2C: 96.0, // 01:36:00
    0x2D: 121.0, // 02:01:00
}

// This is horrible but I have no idea how to reasonably turn my float into an int without getting into black magic
function pad_to_twos(input) {
    // How many characters of the input should be visible?
    if input >= 10 {
        // two chars
        input = "" + input
        input = substring(input, 0, 2)
    } else {
        // one char
        input = "" + input
        input = substring(input, 0, 1)
    }

    // Depending on the amount, pad out to two chars
    if (length(input) == 1) {
        res = "0" + input
    } else {
        res = input
    }
    
    return res
}

function format_time(time_float) {
    min = time_float / 60
    sec = time_float % 60
    
    return format("{0}:{1}:00", pad_to_twos(min), pad_to_twos(sec))
}

for map in time_trial_map_dict {
    leaderboard(
        title = format("Time Attack: {0}", time_trial_map_dict[map]),
        description = format("In Single Player mode, reach the goal in {0} as quickly as possible", time_trial_map_dict[map]),
        start = 
        (
            in_single_player() &&
            map_id == map &&
            player.reached_race_goal_checkpoint(time_trial_map_checkpoint_count[map]) &&
            in_gameplay()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            player.get_time_spent() * 100
        ),
        format = "MILLISECS", lower_is_better = true
    )

    achievement(
        title = format("{0}", time_trial_ach_titles[map]),
        points = 0,
        description = format("In Single Player mode, reach the goal in {0} in {1} or less",
                        time_trial_map_dict[map],
                        format_time(time_trial_targets[map])
                    ),
        trigger = (
            in_single_player() &&
            map_id == map &&
            trigger_when(player.reached_race_goal_checkpoint(time_trial_map_checkpoint_count[map])) &&
            player.get_time_spent() <= time_trial_targets[map] &&
            in_gameplay()
        )
    )
}

// UK: 0x15, 0x19
// US: 0x1F, 0x23
// JPN: 0x29, 0x2D
three_cp_options = [0x15, 0x16, 0x17, 0x18, 0x19, 0x1f, 0x20, 0x21, 0x22, 0x24, 0x2a, 0x2b, 0x2c]
four_cp_options = [0x23]
one_cp_options = [0x2d]

achievement(
    title = format("Point Break"),
    points = 0,
    description = format("In Single Player mode, win any race while scoring at least 15,000 points"),
    trigger = (
        (
            (
                map_id >= 0x15 && map_id <= 0x19 &&
                trigger_when(player.reached_race_goal_checkpoint(3))
            ) ||
            (
                map_id >= 0x1f && map_id <= 0x22 &&
                trigger_when(player.reached_race_goal_checkpoint(3))
            ) ||
            (
                map_id == 0x24 &&
                trigger_when(player.reached_race_goal_checkpoint(3))
            ) ||
            (
                map_id >= 0x2a && map_id <= 0x2c&&
                trigger_when(player.reached_race_goal_checkpoint(3))
            ) ||
            (
                map_id == 0x23 &&
                trigger_when(player.reached_race_goal_checkpoint(4))
            ) ||
            (
                map_id == 0x2d &&
                trigger_when(player.reached_race_goal_checkpoint(1))
            )
        ) &&
        in_single_player() &&
        player.get_score() >= 15000 &&
        player.get_race_pos() == 0x01 &&
        in_gameplay()
    )
)


achievement(
    title = format("Time's Up!"),
    points = 0,
    description = format("In Single Player mode, crash through Big Ben"),
    trigger = (
        in_single_player() &&
        never(checkpoint_count == 0xffffffff) &&
        in_gameplay() &&
        (
            (
                // bottom left: 1597.0, 220.0, 1277.0
                // top right: 1597.0, 480.0, 1307.0

                // bottom left: 1618.0, 220.0, 1265.0
                // top right: 1615.0, 480.0, 1297.0

                // bottom left: 1628.0, 220.0, 1263.0
                // top right: 1634.0, 480.0, 1291.0
                map_id == 0x15 &&

                once(player.entered_area(1597.0, 1598.0, 220.0, 480.0, 1277.0, 1307.0)) &&
                once(player.entered_area(1615.0, 1618.0, 220.0, 480.0, 1265.0, 1297.0)) &&
                once(player.entered_area(1628.0, 1634.0, 220.0, 480.0, 1263.0, 1291.0))
            )
            ||
            (
                // bottom left: 847.0, 220.0, 1565.0
                // top right: 856.0, 480.0, 1597.0

                // bottom left: 824.0, 220.0, 1573.0
                // top right: 840.0, 480.0, 1599.0

                // bottom left: 806.0, 220.0, 1579.0
                // top right: 816.0, 480.0, 1608.0
                map_id == 0x16 &&

                once(player.entered_area(847.0, 856.0, 220.0, 480.0, 1565.0, 1597.0)) &&
                once(player.entered_area(824.0, 840.0, 220.0, 480.0, 1573.0, 1599.0)) &&
                once(player.entered_area(806.0, 816.0, 220.0, 480.0, 1579.0, 1608.0))
            )            
        )
    )
)

achievement(
    title = format("Catch a Ride"),
    points = 0,
    description = format("In Single Player mode, land on a flying car"),
    trigger = (
        in_single_player() &&
        never(checkpoint_count == 0xffffffff) &&
        in_gameplay() &&
        (
            (
                // corner 1
                // 395 116 1348
                // corner 2
                // 528 133 1276
                // highest for ramp: 120
                map_id == 0x21 &&
                player.entered_area(400.0, 570.0,
                                    122.5, 300.0,
                                    1250.0, 1390.0) &&
                player.on_floor() && prev(player.mid_air())
            )
            ||
            (
                // corner 1
                // 411, 298, 209
                // corner 2
                // 546, 299, 147
                // highest for ramp: 304
                map_id == 0x22 &&
                player.entered_area(400.0, 570.0,
                                    306.5, 600.0,
                                    120.0, 250.0) &&
                player.on_floor() && prev(player.mid_air())
            ) ||
            (
                // corner 1
                // 421, 300, 745
                // corner 2
                // 534, 298, 677
                // highest for ramp: 304
                map_id == 0x23 &&
                player.entered_area(400.0, 570.0,
                                    306.5, 600.0,
                                    640.0, 790.0) &&
                player.on_floor() && prev(player.mid_air())
            )
        )
    )
)

achievement(
    title = format("Pagoda Pop"),
    points = 0,
    description = format("In Single Player mode, land a Kickflip while jumping over the pagoda in UK Race 3 or 5"),
    trigger =
    (

        in_single_player() &&
        never(checkpoint_count == 0xffffffff) &&
        in_gameplay() &&
        /*
        usa 3 (0x17):
        bottom right
        573, 130, 319
        top left
        596, 130, 301
        height min: 140
        */

        /*
        usa 5 (0x19):
        bottom right
        1158, 134, 410
        top left
        1130, 134, 435
        height min: 148
        */
        (
            (
                once(
                    map_id == 0x17 &&
                    once(player.get_trick() == 0x43 && prev(player.get_trick() != 0x43)) &&
                    player.entered_area(1158.0, 1130.0,
                                        134.0, 1340.0,
                                        410.0, 435.0) &&
                    prev(player.get_score() + 600) <= player.get_score()
                )
            ) ||
            (
                once(
                    map_id == 0x19 &&
                    once(player.get_trick() == 0x43 && prev(player.get_trick() != 0x43)) &&
                    player.entered_area(573.0, 596.0,
                                        140.0, 1400.0,
                                        300.0, 319.0) &&
                    prev(player.get_score() + 600) <= player.get_score()
                )  
            )                  
        ) &&
        player.on_floor() && prev(player.mid_air())
    )
)

achievement(
    title = format("Two for One"),
    points = 0,
    description = format("In Single Player mode, jump over both fences in a single jump in USA Race 1"),
    trigger = (
        in_single_player() &&
        never(checkpoint_count == 0xffffffff) &&
        map_id == 0x1f &&
        in_gameplay() &&
        /*
        ramp
        1970 795 1524
        1948 791 1541
        min height 805

        air
        1950 770 1640
        1984 870 1630

        dont be here
        1909 764 1665
        1985 600 1620

        end
        1953 743 1671
        2007 600 1792
        */
        once(
            player.entered_area(1948.0, 1970.0,
                                803.0, 900.0,
                                1524.0, 1541.0)
        ) &&
        once(
            player.entered_area(1950.0, 1984.0,
                                770.0, 870.0,
                                1630.0, 1640.0)
        ) &&
        once(
            player.entered_area(1953.0, 2007.0,
                                600.0, 743.0,
                                1671.0, 1792.0)
        ) &&
        never(
            player.entered_area(1909.0, 1985.0,
                                200.0, 764.0,
                                1620.0, 1665.0)
        ) &&
        player.on_floor() && prev(player.mid_air())
    )
)


achievement(
    title = format("Triple Threat"),
    points = 0,
    description = format("In Single Player mode, land a 1080 Air"),
    trigger = (
        in_single_player() &&
        in_gameplay() &&
        never(checkpoint_count == 0xffffffff) &&
        once(player.get_trick() == 0x44e) &&
        // 500, 750, 1000 -> adds a minimum of 2250 pts
        prev(player.get_score() + 2250) <= player.get_score() &&
        never(player.on_floor())
    )
)

achievement(
    title = format("Frequent Flyer"),
    points = 0,
    description = format("In Single Player mode, stay airborne for at least 4 seconds and land safely"),
    trigger = (
        in_single_player() &&
        in_gameplay() &&
        never(checkpoint_count == 0xffffffff) &&
        repeated(120, player.mid_air() && hud_pause_inactive()) &&
        player.on_floor() && hud_pause_inactive() &&
        never(player.in_crash_state()) && never(repeated(3, player.on_floor()))
    )
)

achievement(
    title = format("Special Delivery"),
    points = 0,
    description = format("In Single Player mode, land any special trick"),
    trigger = (
        in_single_player() &&
        in_gameplay() &&
        checkpoint_count != 0xffffffff&&
        prev(player.get_score() + 1500) <= player.get_score() &&
        prev(trick_is_special_orb(player.get_trick())) && player.get_trick() == 0x00
    )
)


// RP

rich_presence_conditional_display(on_the_title_screen() || in_demo(), "On the Title Screen")

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

rich_presence_conditional_display(in_gameplay() && in_single_player(), "{0} is competing in {1} on the {2} board", // Challenges completed: {3}
    rich_presence_lookup("Player", player.get_char(), char_map, fallback="Unknown character"),
    rich_presence_lookup("Map", map_id, map_map, fallback="an unknown map"),
    rich_presence_lookup("Board", player.get_board(), board_map, fallback="unknown")
    //rich_presence_value("ChallengeCount", ...(), "VALUE")
)

rich_presence_conditional_display(in_gameplay() && in_two_player(), "{0} and {2} are competing in {1}", // Challenges completed: {3}
    rich_presence_lookup("Player", player.get_char(), char_map, fallback="Unknown character"),
    rich_presence_lookup("Map", map_id, map_map, fallback="an unknown map"),
    rich_presence_lookup("Player2", player.get_char_p2(), char_map, fallback="a unknown character")
    //rich_presence_value("ChallengeCount", ...(), "VALUE")
)

rich_presence_display("Playing TrickStyle")