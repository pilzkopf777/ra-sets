// Donkey Kong Barrel Blast
// #ID = 34755

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

class PlayerData
{
    player_id = 0 // 1 through 4

    OFFSET_PLAYER_OBJ = 0x26E0

    function get_character() {
        target_adr = 0x352028 + this.player_id * 0x04 - 0x04
        return dword_be(target_adr)
    }

    function get_item() {
        target_offset = 0x2A44 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be)
    }

    function get_position() {
        target_offset = 0x29B4 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], word_be)
    }

    function get_lap_time(lap) {
        target_offset_lap1 = 0x2994 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        target_offset = target_offset_lap1 + lap * 0x04 - 0x04
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be)
    }

    function get_total_time() {
        return this.get_lap_time(1) + this.get_lap_time(2) + this.get_lap_time(3)
    }
}

function in_a_race_state() {
    return dword_be(0x3e7ba8) != 0x00
}

function get_mode() {
    return byte(0x351FA1)
}

mode_map = {
    0x00: "Jungle Grand Prix",
    0x01: "Single Race",
    0x02: "Time Trial",
    0x03: "Free Run",
    0x04: "Candy's Challlenges",
    0x05: "Records",
    0x06: "Options",
    0x07: "Cranky's Flight School"
}

character_map = {
    0x00: "Donkey Kong",
    0x01: "Diddy Kong",
    0x02: "Dixie Kong",
    0x03: "Tiny Kong",
    0x04: "Funky Kong",
    0x05: "Kritter",
    0x06: "Kip",
    0x07: "Kass",
    0x08: "Kalypso",
    0x09: "Kludge",
    0x0a: "Wrinkly Kong",
    0x0b: "King K. Rool",
    0x0c: "Lanky Kong",
    0x0d: "Cranky Kong",
    0x0e: "Klump",
    0x0f: "Kopter",
    0x10: "Ultra Barrel DK"
}

function get_candy_challenge_num() {
    return dword_be(0x352068)
}

function get_candy_challenge_page() {
    // todo
    return 0
}

function get_track() {
    return byte(0x535773)
}

item_map = {
    0x00: "Pineapple Launcher",
    0x01: "Backward Barrel",
    0x02: "Banana Fairy",
    0x03: "Whirlwind",
    0x04: "Blazing Banana",
    0x05: "Squawks",
    0x06: "Quawks",
    0x07: "Wild Elixer",
    0x08: "Crystal Coconut",
    0x09: "Mini-Necky",
    0x0a: "Tasty Melon",
    0x0b: "Mega TNT Barrel",
    0x0c: "Banana Bunch",
    0x0d: "Prop Monkey",
    0x0e: "Mini-Zinger"
}

function get_candy_chal() {
    return dword_be(0x352068)
}

// Key = Internal Challenge ID 
// track_id = Racetrack
// number = Mission ID in-game
// flag = Unlock flag location
challenge_data = {
    0x00: {
        "track_id": 0x00,
        "number": 01,
        "flag": bit1(0x524ea9)
    },
    0x01: {
        "track_id": ,
        "number": 11,
        "flag": bit1(0x524ed1)
    },
    0x02: {
        "track_id": ,
        "number": 07,
        "flag": bit1(0x524ef9)
    },
    0x03: {
        "track_id": ,
        "number": 13,
        "flag": bit1(0x524f21)
    },
    0x04: {
        "track_id": ,
        "number": 04,
        "flag": bit1(0x524f49)
    },
    0x05: {
        "track_id": ,
        "number": 12,
        "flag": bit1(0x524f71)
    },
    0x06: {
        "track_id": ,
        "number": 20,
        "flag": bit1(0x524f99)
    },
    0x07: {
        "track_id": ,
        "number": 27,
        "flag": bit1(0x524fc1)
    },
    0x08: {
        "track_id": ,
        "number": 08,
        "flag": bit1(0x524fe9)
    },
    0x09: {
        "track_id": ,
        "number": 16,
        "flag": bit1(0x525011)
    },
    0x10: {
        "track_id": ,
        "number": 21,
        "flag": bit1(0x525129)
    },
    0x0a: {
        "track_id": ,
        "number": 24,
        "flag": bit1(0x525039)
    },
    0x0b: {
        "track_id": ,
        "number": 31,
        "flag": bit1(0x525061)
    },
    0x0c: {
        "track_id": ,
        "number": 06,
        "flag": bit1(0x525089)
    },
    0x0d: {
        "track_id": ,
        "number": 19,
        "flag": bit1(0x5250b1)
    },
    0x0e: {
        "track_id": ,
        "number": 30,
        "flag": bit1(0x5250d9)
    },
    0x0f: {
        "track_id": ,
        "number": 14,
        "flag": bit1(0x525101)
    },
    // There is no mission mapped to 0x10
    0x11: {
        "track_id": ,
        "number": 26,
        "flag": bit1(0x525151)
    },
    0x12: {
        "track_id": ,
        "number": 15,
        "flag": bit1(0x525179)
    },
    0x13: {
        "track_id": ,
        "number": 23,
        "flag": bit1(0x5251a1)
    },
    0x14: {
        "track_id": ,
        "number": 32,
        "flag": bit1(0x5251c9)
    },
    0x15: {
        "track_id": ,
        "number": 09,
        "flag": bit1(0x5251f1)
    },
    0x16: {
        "track_id": ,
        "number": 18,
        "flag": bit1(0x525219)
    },
    0x17: {
        "track_id": ,
        "number": 28,
        "flag": bit1(0x525241)
    },
    0x18: {
        "track_id": ,
        "number": 17,
        "flag": bit1(0x525269)
    },
    0x19: {
        "track_id": ,
        "number": 05,
        "flag": bit1(0x525291)
    },
    0x1a: {
        "track_id": ,
        "number": 22,
        "flag": bit1(0x5252b9)
    },
    0x1b: {
        "track_id": ,
        "number": 29,
        "flag": bit1(0x5252e1)
    },
    0x1c: {
        "track_id": ,
        "number": 02,
        "flag": bit1(0x525309)
    },
    0x1d: {
        "track_id": ,
        "number": 10,
        "flag": bit1(0x525331)
    },
    0x1e: {
        "track_id": ,
        "number": 25,
        "flag": bit1(0x525359)
    },
    0x1f: {
        "track_id": ,
        "number": 03,
        "flag": bit1(0x525381)
    }
}

track_map = {
    0x00: "DK Jungle",
    0x01: "DK Jungle Falls",
    0x02: "DK Jungle Sunset",
    0x03: "Salty Sea",
    0x04: "Shimmering Sea",
    0x05: "Open Ocean",
    0x06: "Mt. Dynamite",
    0x07: "Mt. Dynamite Remix",
    0x08: "Dynamite Run",
    0x09: "Cranky's Temple",
    0x0a: "Temple Heights",
    0x0b: "Cosmic Highway",
    0x0c: "Scorching Canyon",
    0x0d: "Parched Palace",
    0x0e: "Mammoth Glacier",
    0x0f: "Alpine Peak"
}

player_1_obj = PlayerData(1)

// In Challenge mode
rich_presence_conditional_display(get_mode() == 0x04 && in_a_race_state(), "Donkey Kong is tackling Candy's Challenge No. {1}",
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Challenge ID", get_candy_chal(), challenge_data["number"], fallback="??")
)


rich_presence_conditional_display(get_mode() != 0x04 && in_a_race_state(), "{0} is in {1} on {2}",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="A unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track")
)

rich_presence_display("Playing Donkey Kong Barrel Blast")