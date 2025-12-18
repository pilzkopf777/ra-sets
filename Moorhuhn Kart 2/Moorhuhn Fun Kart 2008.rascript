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

class PlayerData {
    player = 0

    function get_item() {
        return ptr(dword(0x003d03d8), [0x18], word)
    }

    function get_pos() {
        return ptr(dword(0x003d03d8), [0x40], word)
    }

    function get_lap() {
        return ptr(dword(0x003d03d8), [0x38], word)
    }

    function get_char() {
        return ptr(dword(0x003d03d8), [0x10], word)
    }

    function get_total_time() {
        return ptr(dword(0x003d03d8), [0x20], word)
    }

    function finished_race() {
        this.get_lap() == 3 && prev(this.get_lap() == 2)
    }

    function get_x_coord() {
        return ptr(dword(0x003cf730), [0xe0, 0x1b8, 0x9c], float)
    }

    function get_y_coord() {
        return ptr(dword(0x003cf730), [0xe0, 0x1b8, 0xa0], float)
    }

    function get_z_coord() {
        return ptr(dword(0x003cf730), [0xe0, 0x1b8, 0xa4], float)
    }
}

player_1_data = PlayerData(player=1)

class CheckpointGate {
    x_1 = 0.0 // smaller than x2
    x_2 = 0.0 // larger than x1
    z_1 = 0.0 // smaller than z2
    z_2 = 0.0 // larger than z1

    function passed_through_checkpoint() {
        return player_1_data.get_x_coord() > this.x_1 && player_1_data.get_z_coord() > this.z_1 && 
               player_1_data.get_x_coord() < this.x_2 && player_1_data.get_z_coord() < this.z_2 && 
               (
                    prev(player_1_data.get_x_coord() <= this.x_1 && player_1_data.get_z_coord() <= this.z_1) ||
                    prev(player_1_data.get_x_coord() >= this.x_2 && player_1_data.get_z_coord() >= this.z_2)
               )
    }
}

shortcut_data = {
    0x11:
    [
        CheckpointGate(x_1=-251.0, x_2=-245.0, z_1=-43.0, z_2=-31.0), // inside barn
        CheckpointGate(x_1=-109.0, x_2=-95.0, z_1=-40.0, z_2=-25.0), // road
        CheckpointGate(x_1=-4.0, x_2=3.0, z_1=-41.0, z_2=-23.0) // exit
    ],
    0x0e:
    [
        CheckpointGate(x_1=-76.0, x_2=-61.0, z_1=109.0, z_2=130.0), // entrance cave before log
        CheckpointGate(x_1=-99.0, x_2=-80.0, z_1=90.0, z_2=100.0),
        CheckpointGate(x_1=-107.0, x_2=-97.0, z_1=72.0, z_2=76.0) // exit
    ],
    0x12:
    [
        CheckpointGate(x_1=253.0, x_2=258.0, z_1=-82.0, z_2=-98.0), // entrance
        CheckpointGate(x_1=287.0, x_2=288.0, z_1=-96.0, z_2=-85.0),
        CheckpointGate(x_1=319.0, x_2=324.0, z_1=-95.0, z_2=-82.0) // exit
    ],
    0x0b:
    [
        CheckpointGate(x_1=-171.0, x_2=-167.0, z_1=-163.0, z_2=-150.0), // entrance
        CheckpointGate(x_1=-254.0, x_2=-247.0, z_1=-164.0, z_2=-158.0),
        CheckpointGate(x_1=-256.0, x_2=-242.0, z_1=-109.0, z_2=-101.0) // exit
    ],
    0x15:
    [
        CheckpointGate(x_1=-146.0, x_2=-140.0, z_1=26.0, z_2=37.0),
        CheckpointGate(x_1=-154.0, x_2=-143.0, z_1=18.0, z_2=19.0),
        CheckpointGate(x_1=-165.0, x_2=-151.0, z_1=-9.0, z_2=-5.0)
    ],
    0x0d:
    [

    ],
    0x0c:
    [

    ],
    0xff:
    [

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