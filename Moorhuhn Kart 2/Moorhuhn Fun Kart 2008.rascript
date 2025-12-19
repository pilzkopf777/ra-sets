// Moorhuhn Fun Kart 2008
// #ID = 25108

// Helper function taken from Souzooka - thanks!
function ptr(base, offsets, accessor=dword)
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
            val = dword(addr)
        }
    }
    
    return val
}

function get_post_race_menu_status() {
    return dword(0x37a71c)
}

class PlayerData {
    player = 0

    base_adr = 0x003d03d8
    base_adr_coord = 0x003cf730

    // todo: check correct memory adr for p2 stuff

    function get_item() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x18], dword)
    }

    function get_pos() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x40], dword)
    }

    function get_lap() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x38], dword)
    }

    function get_char() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x10], dword)
    }

    function player_has_highest_gp_score() {
        cond = (
            this.get_char() == 0x00 &&                 // player char
            dword(0x0037a964) >= dword(0x0037a968) &&  // player is better than rival no 1...
            dword(0x0037a964) >= dword(0x0037a96c) &&
            dword(0x0037a964) >= dword(0x0037a970) &&
            dword(0x0037a964) >= dword(0x0037a974) &&
            dword(0x0037a964) >= dword(0x0037a978) &&
            dword(0x0037a964) >= dword(0x0037a97c)   
        ) || (
            this.get_char() == 0x01 &&                  
            dword(0x0037a968) >= dword(0x0037a964) &&
            dword(0x0037a968) >= dword(0x0037a96c) &&
            dword(0x0037a968) >= dword(0x0037a970) &&
            dword(0x0037a968) >= dword(0x0037a974) &&
            dword(0x0037a968) >= dword(0x0037a978) &&
            dword(0x0037a968) >= dword(0x0037a97c)      
        ) || (
            this.get_char() == 0x02 &&                  
            dword(0x0037a96c) >= dword(0x0037a964) &&
            dword(0x0037a96c) >= dword(0x0037a968) &&
            dword(0x0037a96c) >= dword(0x0037a970) &&
            dword(0x0037a96c) >= dword(0x0037a974) &&
            dword(0x0037a96c) >= dword(0x0037a978) &&
            dword(0x0037a96c) >= dword(0x0037a97c)      
        ) || (
            this.get_char() == 0x03 &&                  
            dword(0x0037a970) >= dword(0x0037a964) &&
            dword(0x0037a970) >= dword(0x0037a968) &&
            dword(0x0037a970) >= dword(0x0037a96c) &&
            dword(0x0037a970) >= dword(0x0037a974) &&
            dword(0x0037a970) >= dword(0x0037a978) &&
            dword(0x0037a970) >= dword(0x0037a97c)      
        ) || (
            this.get_char() == 0x04 &&                  
            dword(0x0037a974) >= dword(0x0037a964) &&
            dword(0x0037a974) >= dword(0x0037a968) &&
            dword(0x0037a974) >= dword(0x0037a96c) &&
            dword(0x0037a974) >= dword(0x0037a970) &&
            dword(0x0037a974) >= dword(0x0037a978) &&
            dword(0x0037a974) >= dword(0x0037a97c)      
        ) || (
            this.get_char() == 0x05 &&                  
            dword(0x0037a978) >= dword(0x0037a964) &&
            dword(0x0037a978) >= dword(0x0037a968) &&
            dword(0x0037a978) >= dword(0x0037a96c) &&
            dword(0x0037a978) >= dword(0x0037a970) &&
            dword(0x0037a978) >= dword(0x0037a974) &&
            dword(0x0037a978) >= dword(0x0037a97c)      
        ) || (
            this.get_char() == 0x06 &&                  
            dword(0x0037a97c) >= dword(0x0037a964) &&
            dword(0x0037a97c) >= dword(0x0037a968) &&
            dword(0x0037a97c) >= dword(0x0037a96c) &&
            dword(0x0037a97c) >= dword(0x0037a970) &&
            dword(0x0037a97c) >= dword(0x0037a974) &&
            dword(0x0037a97c) >= dword(0x0037a978)      
        )

        return cond
    }

    function get_total_time() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x20], dword) + ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x28], dword) + ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x30], dword)
    }

    function just_finished_race() {
        return ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x34], dword) == 1 && prev(ptr(dword(this.base_adr + 0x04 * this.player - 0x04), [0x34], dword) == 0)
    }

    function get_x_coord() {
        return ptr(dword(this.base_adr_coord + 0x04 * this.player - 0x04), [0xe0, 0x1b8, 0x9c], float)
    }

    function get_y_coord() {
        return ptr(dword(this.base_adr_coord + 0x04 * this.player - 0x04), [0xe0, 0x1b8, 0xa0], float)
    }

    function get_z_coord() {
        return ptr(dword(this.base_adr_coord + 0x04 * this.player - 0x04), [0xe0, 0x1b8, 0xa4], float)
    }
}

player_1_data = PlayerData(player=1)
player_2_data = PlayerData(player=2)

class CheckpointGate {
    x_1 = 0.0 // smaller than x2
    x_2 = 0.0 // larger than x1
    z_1 = 0.0 // smaller than z2
    z_2 = 0.0 // larger than z1

    function passed_through_checkpoint(player_id) {
        obj = PlayerData(player=player_id)

        return obj.get_x_coord() > this.x_1 && obj.get_z_coord() > this.z_1 && 
               obj.get_x_coord() < this.x_2 && obj.get_z_coord() < this.z_2
    }
}

shortcut_data = {
    0x31:
    // Moorhuhn X
    [
        CheckpointGate(x_1=-251.0, x_2=-245.0, z_1=-43.0, z_2=-31.0), // inside barn
        CheckpointGate(x_1=-109.0, x_2=-95.0, z_1=-40.0, z_2=-25.0), // road
        CheckpointGate(x_1=-4.0, x_2=3.0, z_1=-41.0, z_2=-23.0) // exit
    ],
    0x32:
    // Winter
    [
        CheckpointGate(x_1=-76.0, x_2=-61.0, z_1=109.0, z_2=130.0), // entrance cave before log
        CheckpointGate(x_1=-99.0, x_2=-80.0, z_1=90.0, z_2=100.0),
        CheckpointGate(x_1=-107.0, x_2=-97.0, z_1=72.0, z_2=76.0) // exit
    ],
    0x33:
    // Island
    [
        CheckpointGate(x_1=253.0, x_2=258.0, z_1=-98.0, z_2=-82.0), // entrance
        CheckpointGate(x_1=287.0, x_2=288.0, z_1=-96.0, z_2=-85.0),
        CheckpointGate(x_1=319.0, x_2=324.0, z_1=-95.0, z_2=-82.0) // exit
    ],
    0x34:
    // Egypt
    [
        CheckpointGate(x_1=-171.0, x_2=-167.0, z_1=-163.0, z_2=-150.0), // entrance
        CheckpointGate(x_1=-254.0, x_2=-247.0, z_1=-164.0, z_2=-158.0),
        CheckpointGate(x_1=-256.0, x_2=-242.0, z_1=-109.0, z_2=-101.0) // exit
    ],
    0x35:
    // Factory
    [
        CheckpointGate(x_1=-146.0, x_2=-140.0, z_1=26.0, z_2=37.0),
        CheckpointGate(x_1=-154.0, x_2=-143.0, z_1=18.0, z_2=19.0),
        CheckpointGate(x_1=-165.0, x_2=-151.0, z_1=-9.0, z_2=-5.0)
    ],
    0x36:
    // Mine
    [
        CheckpointGate(x_1=-222.0, x_2=-216.0, z_1=-125.0, z_2=-110.0), // entrance
        CheckpointGate(x_1=-103.0, x_2=-96.0, z_1=-194.0, z_2=-171.0), // wavy part
        CheckpointGate(x_1=39.0, x_2=45.0, z_1=-184.0, z_2=-177.0), // start of bridge
    ],
    0x37:
    // Castle
    [
        CheckpointGate(x_1=149.0, x_2=155.0, z_1=203.0, z_2=204.0),
        CheckpointGate(x_1=135.0, x_2=151.0, z_1=239.0, z_2=240.0),
        CheckpointGate(x_1=135.0, x_2=149.0, z_1=253.0, z_2=262.0)
    ],
    0x38:
    // Swamp
    [
        CheckpointGate(x_1=-236.0, x_2=-232.0, z_1=173.0, z_2=201.0), // hill before ramp
        CheckpointGate(x_1=-200.0, x_2=-196.0, z_1=194.0, z_2=211.0), // in castle
        CheckpointGate(x_1=-139.0, x_2=-134.0, z_1=190.0, z_2=207.0) // after jump
    ]
}

function get_map() {
    // map this digit to a race track:
    // 0x31 = 1
    // 0x32 = 2
    // (...) 
    // 0x38 = 8
    music_track_digit = byte(0x0030f016)
    return music_track_digit
}

function get_mode() {
    return dword(0x37a820)
}

function get_gp() {
    return dword(0x37a824)
}

function get_gp_race() {
    return dword(0x37a9d4)
}

function get_power_class() {
    return dword(0x379f6c)
}

function in_a_race() {
    return player_1_data.get_pos() > 0
}

racetrack_map = {
    0x31: "on Moorhuhn X",
    0x32: "in Winter",
    0x33: "on the Island",
    0x34: "in Egypt",
    0x35: "in the Factory",
    0x36: "in the Mine",
    0x37: "in the Castle",
    0x38: "in the Swamp"
}

plain_racetrack_map = {
    0x31: "Moorhuhn X",
    0x32: "Winter",
    0x33: "Island",
    0x34: "Egypt",
    0x35: "Factory",
    0x36: "Mine",
    0x37: "Castle",
    0x38: "Swamp"
}

// divide the value in here by 10 to get the actual time
// for the achievement logic: add laps 1, 2 and 3 together, divide by 10, check if greater/not than this
time_trial_target = {
    0x31: 20058,
    0x32: 19374,
    0x33: 26332,
    0x34: 33300,
    0x35: 13397,
    0x36: 24957,
    0x37: 27280,
    0x38: 22406
}

mode_map = {
    0x00: "Time Trial",
    0x01: "Championship",
    0x02: "Versus race",
    0x03: "Championship"
}

char_map = {
    0x00: "Moorhuhn",
    0x01: "Lesshuhn",
    0x02: "Moorfrosch",
    0x03: "Pumpkin",
    0x04: "Snowman",
    0x05: "Kröt",
    0x06: "Hank"
}

function on_title_screen() {
    return dword(0x0037b37c) == 0x00
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

function format_time(time) {
    min = time / 6000
    centiseconds_left = time % 6000
    sec = centiseconds_left / 100
    milli = centiseconds_left % 100
    return format("{0}:{1}:{2}", pad_to_twos(min), pad_to_twos(sec), pad_to_twos(milli))
}

shortcut_names = ["Barnstorming", "Slipping and Sliding", "Palmtree Panic", "Touring Inshalalala", "Push and Pull", "All Mine", "King of the Castle", "This Is Supposed to Be Scotland?"]

for track in plain_racetrack_map {
    achievement(
        title = format("{0}", shortcut_names[track - 0x31]),
        points = 3,
        description = format("Find and take the shortcut {0}", racetrack_map[track]),
        trigger = 
        (
            // Solo
            get_mode() <= 1 &&
            in_a_race() && get_map() == track &&
            // Must pass through all checkpoints, reset on new lap just in case
            once(shortcut_data[track][0].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][1].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][2].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap()))
        ) ||
        (
            // Multiplayer, P1
            get_mode() >= 2 &&
            in_a_race() && get_map() == track &&
            // Must pass through all checkpoints, reset on new lap just in case
            once(shortcut_data[track][0].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][1].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][2].passed_through_checkpoint(1) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap()))
        ) ||
        (
            // Multiplayer, P2
            get_mode() >= 2 &&
            in_a_race() && get_map() == track &&
            // Must pass through all checkpoints, reset on new lap just in case
            once(shortcut_data[track][0].passed_through_checkpoint(2) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][1].passed_through_checkpoint(2) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap())) && once(shortcut_data[track][2].passed_through_checkpoint(2) && never(prev(player_1_data.get_lap()) != player_1_data.get_lap()))
        )
    )

    leaderboard(
        title = format("{0} 150cc Time Attack", plain_racetrack_map[track]),
        description = format("Complete a Time Trial {0} on 150cc as quickly as possible!", racetrack_map[track]),
        start = 
        (
            in_a_race() &&
            get_map() == track &&
            get_power_class() == 150 &&
            get_mode() == 0x00 &&
            player_1_data.just_finished_race()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            player_1_data.get_total_time() / 10
        ),
        format = "MILLISECS", lower_is_better = true
    )

    achievement(
        title = format("The Fastest Chicken {0}", racetrack_map[track]),
        points = 10,
        description = format("Complete a Time Trial {0} on 150cc in {1} or less", racetrack_map[track], format_time(time_trial_target[track])),
        trigger = 
            in_a_race() &&
            get_map() == track &&
            get_power_class() == 150 &&
            get_mode() == 0x00 &&
            player_1_data.just_finished_race() &&
            player_1_data.get_total_time() <= time_trial_target[track]
    )
}

cc_list = [50, 100, 150]
pts = [3, 5, 10]
gp_loc_titles = ["Local", "Extracurricular"]
gp_diff_titles = ["Rookie", "Pro", "Master"]

for cc in cc_list {
    for gp in range(1, 2, 1) {
        achievement(
        title = format("{0} {1}", gp_loc_titles[gp - 1], gp_diff_titles[(cc / 50) - 1]),
        points = pts[(cc / 50) - 1],
        description = format("Win Championship {0} on {1}cc", gp, cc),
        trigger = 
            (
                get_mode() == 1 &&
                get_gp() == gp - 1 &&
                get_power_class() == cc &&
                get_gp_race() == 4 &&
                get_post_race_menu_status() == 0x03 && prev(get_post_race_menu_status() == 0x02) &&
                player_1_data.player_has_highest_gp_score()
            ) ||
            (
                get_mode() == 3 &&
                get_gp() == gp - 1 &&
                get_power_class() == cc &&
                get_gp_race() == 4 &&
                get_post_race_menu_status() == 0x03 && prev(get_post_race_menu_status() == 0x02) &&
                player_1_data.player_has_highest_gp_score()
            ) ||
            (
                get_mode() == 3 &&
                get_gp() == gp - 1 &&
                get_power_class() == cc &&
                get_gp_race() == 4 &&
                get_post_race_menu_status() == 0x03 && prev(get_post_race_menu_status() == 0x02) &&
                player_2_data.player_has_highest_gp_score()
            )
        )
    }
}



rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

rich_presence_conditional_display(in_a_race(), "{1} is in a {0} ({2} cc) {3}",
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="n unknown mode"),
    rich_presence_lookup("Character", player_1_data.get_char(), char_map, fallback="A unknown character"),
    rich_presence_value("Power Class", get_power_class(), "VALUE"),
    rich_presence_lookup("Track", get_map(), racetrack_map, fallback="on an unknown racetrack")
)

// During loading between GP races
rich_presence_conditional_display(!in_a_race() && !on_title_screen(), "{1} is getting ready for a {0} ({2} cc)",
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="n unknown mode"),
    rich_presence_lookup("Character", player_1_data.get_char(), char_map, fallback="A unknown character"),
    rich_presence_value("Power Class", get_power_class(), "VALUE")
)

rich_presence_display("Getting ready to race...")