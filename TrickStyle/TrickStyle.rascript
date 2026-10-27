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
    return !on_the_title_screen() && !in_demo() && !in_main_menu()
}

function completed_event(event_result_slot_adr) {
    return bit2(event_result_slot_adr) == 1
}

function tally_progression_data(lower_limit, upper_limit) {
    cond = []

    start_id_slot_adr = 0x143c7a
    start_result_slot_adr = 0x143cba

    for current_offset in range(0, 35, 1) {

        array_push(cond,
            (
                once(
                    // meets lower limit req
                    byte(start_id_slot_adr + current_offset) >= lower_limit && 
                    // and higher too
                    byte(start_id_slot_adr + current_offset) <= upper_limit &&
                    // and the mission was completed
                    completed_event(start_result_slot_adr + current_offset)
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
    0x31: "Final Challenge"

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

class PlayerObject {

    function get_char() {
        return byte(0x143c78)
    }

    function get_board() {
        return byte(0x143c79)
    }

    function on_floor() {
        return ptr(tbyte(0x1c5f40), [0xF4], dword) == 0x01
    }

    function mid_air() {
        return ptr(tbyte(0x1c5f40), [0xF4], dword) == 0x00
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

    function has_invuln_frames() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x50], dword) == 0x00
    }

    function has_no_invuln_frames() {
        return ptr(tbyte(0x11b890), [0xBBC, 0xAC, 0x50], dword) == 0x01
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
    title = format("UK RACES"),
    points = 0,
    description = format("UK RACES"),
    trigger = (
        check_if_player_completed_obj_logic(5, 0x15, 0x19)
    )
)

achievement(
    title = format("UK BOSS"),
    points = 0,
    description = format("UK BOSS"),
    trigger = (
        check_if_player_completed_obj_logic(1, 0x1b, 0x1b)
    )
)

achievement(
    title = format("US RACES"),
    points = 0,
    description = format("US RACES"),
    trigger = (
        check_if_player_completed_obj_logic(5, 0x1f, 0x23)
    )
)

achievement(
    title = format("US BOSS"),
    points = 0,
    description = format("US BOSS"),
    trigger = (
        check_if_player_completed_obj_logic(1, 0x25, 0x25)
    )
)

achievement(
    title = format("JPN RACES"),
    points = 0,
    description = format("JPN RACES"),
    trigger = (
        check_if_player_completed_obj_logic(4, 0x29, 0x2c)
    )
)

achievement(
    title = format("JPN BOSS"),
    points = 0,
    description = format("JPN BOSS"),
    trigger = (
        check_if_player_completed_obj_logic(1, 0x2f, 0x2f)
    )
)

achievement(
    title = format("JPN FINAL RACE"),
    points = 0,
    description = format("JPN FINAL RACE"),
    trigger = (
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
    0x23: 111.0, // 01:51:00
    0x29: 85.0, // 01:25:00
    0x2A: 0,
    0x2B: 0,
    0x2C: 0,
    0x2D: 122.0, // 02:02:00
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
        description = format("Reach the goal in {0} as quickly as possible", time_trial_map_dict[map]),
        start = 
        (
            map_id == map &&
            player.reached_race_goal_checkpoint(time_trial_map_checkpoint_count[map])
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
        title = format("TIME TRIAL {0}", time_trial_map_dict[map]),
        points = 0,
        description = format("Reach the goal in {0} in {1} or less",
                        time_trial_map_dict[map],
                        format_time(time_trial_targets[map])
                    ),
        trigger = (
            map_id == map &&
            trigger_when(player.reached_race_goal_checkpoint(time_trial_map_checkpoint_count[map])) &&
            player.get_time_spent() <= time_trial_targets[map]
        )
    )
}

achievement(
    title = format("BREAK BIG BEN"),
    points = 0,
    description = format("BREAK BIG BEN"),
    trigger = (
        never(checkpoint_count == 0xffffffff) &&
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

achievement(
    title = format("LAND ON CAR"),
    points = 0,
    description = format("LAND ON CAR"),
    trigger = (
        never(checkpoint_count == 0xffffffff) &&
        (
            // corner 1
            // 546, 113, 1334
            // corner 2
            // 420, 133, 1286
            // highest for ramp: 120
            map_id == 0x21 &&
            player.entered_area(400.0, 570.0, 122.5, 300.0, 1250.0, 1390.0) &&
            never(player.on_floor())
        )
        ||
        (
            // corner 1
            // 411, 298, 209
            // corner 2
            // 546, 299, 147
            // highest for ramp: 304
            map_id == 0x22 &&
            player.entered_area(400.0, 570.0, 306.5, 600.0, 120.0, 250.0) &&
            player.on_floor() && prev(player.mid_air())
        ) ||
        (
            // corner 1
            // 421, 300, 745
            // corner 2
            // 534, 298, 677
            // highest for ramp: 304
            map_id == 0x23 &&
            player.entered_area(400.0, 570.0, 306.5, 600.0, 640.0, 790.0) &&
            player.on_floor() && prev(player.mid_air())
        )
    )
)



achievement(
    title = format("LAND 1080 AIR"),
    points = 0,
    description = format("LAND 1080 AIR"),
    trigger = (
        never(checkpoint_count == 0xffffffff) &&
        once(player.get_trick() == 0x44e) &&
        // 500, 750, 1000 -> adds a minimum of 2250 pts
        prev(player.get_score() + 2250) <= player.get_score() &&
        never(player.on_floor())
    )
)


// RP

rich_presence_conditional_display(on_the_title_screen() || in_demo(), "On the Title Screen")

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

rich_presence_conditional_display(in_gameplay(), "{0} is competing in {1} on the {2} board", // Challenges completed: {3}
    rich_presence_lookup("Player", player.get_char(), char_map, fallback="Unknown character"),
    rich_presence_lookup("Map", map_id, map_map, fallback="Unknown map"),
    rich_presence_lookup("Board", player.get_board(), board_map, fallback="Unknown board")
    //rich_presence_value("ChallengeCount", ...(), "VALUE")
)

rich_presence_display("Playing TrickStyle")