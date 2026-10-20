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
checkpoint_count = ptr(tbyte(0x6c5b3c), [0x01a8], dword)
victory_state = ptr(tbyte(0x6c5b3c), [0x2e0], dword)
time_left = ptr(tbyte(0x6c5b3c), [0x22c], float)
countdown_state = dword(0x135804)

function race_ended() {
    return countdown_state == 0x21 && prev(countdown_state == 0x11)
}

function credits_started() {
    return float(0x0ed4f4) > 0.1 && prev(float(0x0ed4f4) <= 0.1)
}

main_menu_state = dword(0x0ef4b0)
title_screen_anim_timer = float(0x0ef4b4)
player_count = dword(0x0efe5c)

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
}

time_trial_targets = {
    0x15: 0, // 01:14:00
    0x16: 0, // 01:20:00
    0x17: 0, // 01:35:00
    0x18: 0, // 01:19:00
    0x19: 100.0 // 01:40:00
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

    function get_x() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0xAC, 0x2C, 0x04, 0x40], float)
    }

    function get_y() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0xAC, 0x2C, 0x04, 0x44], float)
    }

    function get_z() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0xAC, 0x2C, 0x04, 0x48], float)
    }

    function get_race_pos() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0x238], dword)
    }

    function get_trick() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0x2E8], dword)
    }

    function get_score() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0x3A8], dword)
    }

    function get_time_spent() {
        return ptr(tbyte(0x11b8b4), [0x00, 0x1C, 0x3A8], float) 
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

// for this, get a list of unlocked races and actions in memory..
//achievement(
//    title = format("UK ALL RACES"),
//    points = 0,
//    description = format("UK ALL RACES"),
//    trigger = (
//        map_id == 0x1b &&
//        race_ended() && player.get_race_pos() == 0x01
//    )
//)

achievement(
    title = format("UK BOSS"),
    points = 0,
    description = format("UK BOSS"),
    trigger = (
        map_id == 0x1b &&
        race_ended() && player.get_race_pos() == 0x01
    )
)

achievement(
    title = format("BREAK BIG BEN"),
    points = 0,
    description = format("BREAK BIG BEN UK RACE 1 OR 2"),
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