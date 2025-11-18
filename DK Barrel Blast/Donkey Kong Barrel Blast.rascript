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

    function is_human_player() {
        target_adr = 0x352028 + this.player_id * 0x04 - 0x04
        return dword_be(target_adr) != 0xffffffff
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
        target_offset = 0x298C + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], float_be)
    }

    function finished_race() {
        target_offset = 0x2984 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be) == 3 && prev(ptr(dword_be(0x3e7ba8), [target_offset], dword_be)) == 2
    }

    function get_speed() {
        target_offset = 0x2678 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], float_be)
    }

    function zero_to_full_speed() {
        return this.get_speed() == 1.0 && prev(this.get_speed() == 0.0)
    }

    function get_banana_combo() {
        offset_map = {
            0x01: 0x288,
            0x02: 0x534,
            0x03: 0x7E0,
            0x04: 0xA8C
        }

        return ptr(dword_be(0x488eb8), [0x358, 0x24C, 0x298, offset_map[this.player_id]], dword_be)  
    }

    function get_wild_move_combo() {
        offset_map = {
            0x01: 0x288,
            0x02: 0x520,
            0x03: 0x7B8,
            0x04: 0xA50
        }

        return ptr(dword_be(0x488eb8), [0x358, 0x24C, 0x2A8, offset_map[this.player_id]], dword_be)  
    }

    function get_style_barrel_progress() {
        target_offset = 0x2C5C + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset, 0xE0], dword_be)
    }

    function player_got_50_in_style_barrel() {
        return this.get_style_barrel_progress() == 4 &&
        // Banana combo value must have increased by 50 or more
        this.get_banana_combo() >= prev(this.get_banana_combo()) + 50 &&
        prev(this.get_style_barrel_progress() == 3)
    }

    function using_banana_fairy() {
        target_offset = 0x29E8 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], float_be) > 0.0
    }

    function using_tasty_melon() {
        target_offset = 0x29F4 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], float_be) > 0.0
    }

    function is_riding_buddy() {
        target_offset = 0x2BB4 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be) == 1
    }
}

function in_a_race_state() {
    return dword_be(0x3e7ba8) != 0x00
}

function get_mode() {
    return byte(0x351FA1)
}

// TODO: test this
function demo_playing() {
    demo_ends_in = ptr(dword_be(0x0048c10c), [0x78], float_be)
    // cond_demo_time = demo_ends_in < 3000.0 && demo_ends_in >= 0.0 && demo_ends_in != 0.0
    // cond_race_state = in_a_race_state()
    // cond_ptr_valid = dword_be(0x00535790) != 0x00
    return dword_be(0x0048c10c) != 0xffffffff && dword_be(0x0048c10c) != 0x00 && demo_ends_in != 0.0
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

difficulty_map = {
    0x00: "Rookie",
    0x01: "Pro",
    0x02: "Expert"
}

function get_track() {
    return ptr(dword_be(0x53560c), [0x30], dword_be)
}

function get_gp() {
    return dword_be(0x352048)
}

function get_difficulty() {
    return dword_be(0x352024)
}

gp_map = {
    0x00: "Topaz",
    0x01: "Sapphire",
    0x02: "Diamond",
    0x03: "Platinum",
    0x04: "Selection",
    0x05: "Random"
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

function in_victory_ceremony() {
    return float_be(0x53f368) > 0.0 && float_be(0x53f368) < 1300.0
}

// Key = Internal Challenge ID 
// track_id = Racetrack
// number = Mission ID in-game
// flag = Unlock flag location
challenge_data = {
    0x00: {
        "track_id": 0xfe,
        "number": 01,
        "flag": bit1(0x524ea9)
    },
    0x01: {
        "track_id": 0xfe,
        "number": 11,
        "flag": bit1(0x524ed1)
    },
    0x02: {
        "track_id": 0xfe,
        "number": 07,
        "flag": bit1(0x524ef9)
    },
    0x03: {
        "track_id": 0xfe,
        "number": 13,
        "flag": bit1(0x524f21)
    },
    0x04: {
        "track_id": 0xfe,
        "number": 04,
        "flag": bit1(0x524f49)
    },
    0x05: {
        "track_id": 0x00,
        "number": 12,
        "flag": bit1(0x524f71)
    },
    0x06: {
        "track_id": 0xfe,
        "number": 20,
        "flag": bit1(0x524f99)
    },
    0x07: {
        "track_id": 0x00,
        "number": 27,
        "flag": bit1(0x524fc1)
    },
    0x08: {
        "track_id": 0x00,
        "number": 08,
        "flag": bit1(0x524fe9)
    },
    0x09: {
        "track_id": 0x0e,
        "number": 16,
        "flag": bit1(0x525011)
    },
    0x10: {
        "track_id": 0x00,
        "number": 21,
        "flag": bit1(0x525129)
    },
    0x0a: {
        "track_id": 0x09,
        "number": 24,
        "flag": bit1(0x525039)
    },
    0x0b: {
        "track_id": 0x0f,
        "number": 31,
        "flag": bit1(0x525061)
    },
    0x0c: {
        "track_id": 0x00,
        "number": 06,
        "flag": bit1(0x525089)
    },
    0x0d: {
        "track_id": 0x0d,
        "number": 19,
        "flag": bit1(0x5250b1)
    },
    0x0e: {
        "track_id": 0xfe,
        "number": 30,
        "flag": bit1(0x5250d9)
    },
    0x0f: {
        "track_id": 0x06,
        "number": 14,
        "flag": bit1(0x525101)
    },
    // There is no mission mapped to 0x10
    0x11: {
        "track_id": 0x03,
        "number": 26,
        "flag": bit1(0x525151)
    },
    0x12: {
        "track_id": 0x00,
        "number": 15,
        "flag": bit1(0x525179)
    },
    0x13: {
        "track_id": 0x0d,
        "number": 23,
        "flag": bit1(0x5251a1)
    },
    0x14: {
        "track_id": 0x00,
        "number": 32,
        "flag": bit1(0x5251c9)
    },
    0x15: {
        "track_id": 0x04,
        "number": 09,
        "flag": bit1(0x5251f1)
    },
    0x16: {
        "track_id": 0x0c,
        "number": 18,
        "flag": bit1(0x525219)
    },
    0x17: {
        "track_id": 0x0d,
        "number": 28,
        "flag": bit1(0x525241)
    },
    0x18: {
        "track_id": 0x00,
        "number": 17,
        "flag": bit1(0x525269)
    },
    0x19: {
        "track_id": 0x00,
        "number": 05,
        "flag": bit1(0x525291)
    },
    0x1a: {
        "track_id": 0x00,
        "number": 22,
        "flag": bit1(0x5252b9)
    },
    0x1b: {
        "track_id": 0x02,
        "number": 29,
        "flag": bit1(0x5252e1)
    },
    0x1c: {
        "track_id": 0x03,
        "number": 02,
        "flag": bit1(0x525309)
    },
    0x1d: {
        "track_id": 0x07,
        "number": 10,
        "flag": bit1(0x525331)
    },
    0x1e: {
        "track_id": 0x08,
        "number": 25,
        "flag": bit1(0x525359)
    },
    0x1f: {
        "track_id": 0x00,
        "number": 03,
        "flag": bit1(0x525381)
    }
}

challenge_data_true_id_map = {
    0x00: "01",
    0x01: "11",
    0x02: "07",
    0x03: "13",
    0x04: "04",
    0x05: "12",
    0x06: "20",
    0x07: "27",
    0x08: "08",
    0x09: "16",
    0x10: "21",
    0x0a: "24",
    0x0b: "31",
    0x0c: "06",
    0x0d: "19",
    0x0e: "30",
    0x0f: "14",
    // There is no mission mapped to 0x10
    0x11: "26",
    0x12: "15",
    0x13: "23",
    0x14: "32",
    0x15: "09",
    0x16: "18",
    0x17: "28",
    0x18: "17",
    0x19: "05",
    0x1a: "22",
    0x1b: "29",
    0x1c: "02",
    0x1d: "10",
    0x1e: "25",
    0x1f: "03"
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
    0x0f: "Alpine Peak",
    0xfe: "Practice Course" // not a regular track, should never show up here..; value for this is made up
}

time_trial_data = [
    {
        "track_id": 0x00, // DK Jungle
        "target_time": 5107,
        "valid_characters": [0x00, 0x05]
    },
    {
        "track_id": 0x01, // DK J Falls
        "target_time": 6883,
        "valid_characters": [0x01, 0x06]
    },
    {
        "track_id": 0x02, // DK J Sunset
        "target_time": 7308, // 02:01:80
        "valid_characters": [0x02, 0x07]
    },
    {
        "track_id": 0x03, // Salty Sea
        "target_time": 6781,
        "valid_characters": [0x0c, 0x0e]
    },
    {
        "track_id": 0x04, // Shimmering Sea
        "target_time": 7128,
        "valid_characters": [0x03, 0x08]
    },
    {
        "track_id": 0x05, // Open Ocean
        "target_time": 6943, // 1:55:70
        "valid_characters": [0x04, 0x09]
    },
    {
        "track_id": 0x06, // Mt. Dynamite
        "target_time": 8675,
        "valid_characters": [0x0a, 0x0f]
    },
    {
        "track_id": 0x07, // Mt. Dynamite Remix
        "target_time": 11744,
        "valid_characters": [0x0d, 0x0b]
    },
    {
        "track_id": 0x08, // Dynamite Run
        "target_time": 11489,
        "valid_characters": [0x00, 0x05]
    },
    {
        "track_id": 0x09, // Cranky Temple
        "target_time": 8618,
        "valid_characters": [0x01, 0x06]
    },
    {
        "track_id": 0x0a, // Temple Heights
        "target_time": 10277,
        "valid_characters": [0x02, 0x07]
    },
    {
        "track_id": 0x0b, // Cosmic Highway
        "target_time": 10796,
        "valid_characters": [0x0c, 0x0e]
    },
    {
        "track_id": 0x0c, // Scorching Canyon
        "target_time": 7356,
        "valid_characters": [0x03, 0x08]
    },
    {
        "track_id": 0x0d, // Parched Palace
        "target_time": 10825,
        "valid_characters": [0x04, 0x09]
    },
    {
        "track_id": 0x0e, // Mammoth Glacier
        "target_time": 7708,
        "valid_characters": [0x0a, 0x0f]
    },
    {
        "track_id": 0x0f, // Alpine Peak
        "target_time": 10321,
        "valid_characters": [0x0d, 0x0b]
    },
]

function pad_to_twos(input) {
    input = "" + input
    if (length(input) == 1) {
        res = "0" + input
    } else {
        res = input
    }
    
    return res
}

function frame_time_to_next_second(frames) {
    fps = 60

    // truncate any fractional frames
    frames = frames - (frames % 1)

    leftover = frames % fps
    if (leftover == 0) {
        return frames
    }
    return frames + (fps - leftover)
}


function frame_time_to_readable_string(frames) {
    fps = 60

    frames = frame_time_to_next_second(frames)

    total_seconds = frames / fps
    minutes = total_seconds / 60
    seconds = total_seconds % 60

    leftover_frames = frames % fps
    millis = leftover_frames / fps * 1000

    return format("{0}:{1}:{2}", pad_to_twos(minutes), pad_to_twos(seconds), pad_to_twos(millis))
}

player_1_obj = PlayerData(1)
player_2_obj = PlayerData(2)
player_3_obj = PlayerData(3)
player_4_obj = PlayerData(4)


for element in time_trial_data {
    achievement(
    title = format("Going Ape in {0}", track_map[element["track_id"]]),
    points = 25,
    description = format("As either {0} or {1}, reach the goal in {2} on {3} in a Time Trial on Expert difficulty",
        character_map[element["valid_characters"][0]], // char 1
        character_map[element["valid_characters"][1]], // char 2
        frame_time_to_readable_string(element["target_time"]), // time
        track_map[element["track_id"]] // track
    ),
    trigger = 
        !demo_playing() &&
        get_mode() == 02 &&
        get_track() == element["track_id"] &&
        (
            player_1_obj.get_character() == element["valid_characters"][0] || player_1_obj.get_character() == element["valid_characters"][1]
        ) &&
        player_1_obj.get_total_time() >= frame_time_to_next_second(element["target_time"]) &&
        trigger_when(player_1_obj.finished_race())
    )

    leaderboard(
        title = format("Time Trial: {0} (Expert)", track_map[element["track_id"]]),
        description = format("Reach the goal as quickly as possible on {0} in a Time Trial on Expert difficulty as any character except Ultra Barrel DK!",
        track_map[element["track_id"]] // track
    ),
        start = 
        (
            player_1_obj.get_character() != 0x10 && // no ultra barrel dk
            in_a_race_state() &&
            !demo_playing() &&
            get_mode() == 02 &&
            get_track() == element["track_id"] &&
            player_1_obj.finished_race()
        ),
        cancel = (
            !in_a_race_state() && prev(in_a_race_state())
        ),
        submit = always_true(),
        value =
            measured(
                player_1_obj.get_total_time()
        ),
        format = "FRAMES", lower_is_better = true
    )
}

function count_cleared_challenges() {
    return sum_of(
        challenge_data,
        item => challenge_data[item]["flag"]
    )
}

function count_cleared_challenges_per_level(level) {
    start_of_range = 1 + level * 8 - 8
    lower_range = start_of_range
    upper_range = lower_range + 7

    array_with_ids_of_relevant_chal = array_filter(challenge_data, item => challenge_data[item]["number"] >= lower_range && challenge_data[item]["number"] <= upper_range)
    
    return array_reduce(array_with_ids_of_relevant_chal, 0, (acc, item) => acc + challenge_data[item]["flag"])
}

achievement(
    title = "Tricked out",
    points = 1,
    description = "Land all four tricks in a Style Barrel",
    trigger = 
    !demo_playing() &&
    (
        (
            player_1_obj.is_human_player() && player_1_obj.player_got_50_in_style_barrel()
        )
        ||
        (
            player_2_obj.is_human_player() && player_2_obj.player_got_50_in_style_barrel()
        )
        ||
        (
            player_3_obj.is_human_player() && player_3_obj.player_got_50_in_style_barrel()
        )
        ||
        (
            player_4_obj.is_human_player() && player_4_obj.player_got_50_in_style_barrel()
        )
    )
)

target_wild = 15
achievement(
    title = "Finally, a racing game with a Wild Move meter!",
    points = 5,
    description = format("Reach a Wild Move combo of {0}", target_wild),
    trigger = 
    !demo_playing() &&
    (
        (
            player_1_obj.is_human_player() && player_1_obj.get_wild_move_combo() == target_wild && prev(player_1_obj.get_wild_move_combo() == target_wild - 1)
        )
        ||
        (
            player_2_obj.is_human_player() && player_2_obj.get_wild_move_combo() == target_wild && prev(player_2_obj.get_wild_move_combo() == target_wild - 1)
        )
        ||
        (
            player_3_obj.is_human_player() && player_3_obj.get_wild_move_combo() == target_wild && prev(player_3_obj.get_wild_move_combo() == target_wild - 1)
        )
        ||
        (
            player_4_obj.is_human_player() && player_4_obj.get_wild_move_combo() == target_wild && prev(player_4_obj.get_wild_move_combo() == target_wild - 1)
        )
    )
)

function banana_combo_went_up_by_x(player_id, amount) {
    player_obj = PlayerData(player_id)
    // eg. was 5, now 7, amount is 2:
    // 7 - 5 = 2 -> true
    return player_obj.get_banana_combo() - prev(player_obj.get_banana_combo()) >= amount
}

function banana_fairy_logic_for_player(player_id) {
    cond = []

    for count in range(1, 100, 1) {
        array_push(cond, banana_combo_went_up_by_x(player_id, count))
    }

    return cond
}


// This is just for generation of the logic, replace Resetif with Resetnextif if generating this or things will go horribly wrong
target_fairy = 150
achievement(
    title = "Blessed with Potassium",
    points = 3,
    description = format("Earn {0} bananas using the Banana Fairy before it runs out", target_fairy),
    trigger = 
    (
        (
            player_1_obj.is_human_player() &&
            // reset hits if player has no banana fairy
            (
                never(!player_1_obj.using_banana_fairy()) &&
                tally(
                   target_fairy, banana_fairy_logic_for_player(1)
                )
            )
        )
        ||
        (
            player_2_obj.is_human_player() &&
            // reset hits if player has no banana fairy
            (
                never(!player_2_obj.using_banana_fairy()) &&
                tally(
                    target_fairy, banana_fairy_logic_for_player(2)
                )
            )
        )
        ||
        (
            player_3_obj.is_human_player() &&
            // reset hits if player has no banana fairy
            (
                never(!player_3_obj.using_banana_fairy()) &&
                tally(
                    target_fairy, banana_fairy_logic_for_player(3)
                )
            )
        )
        ||
        (
            player_4_obj.is_human_player() &&
            // reset hits if player has no banana fairy
            (
                never(!player_4_obj.using_banana_fairy()) &&
                tally(
                    target_fairy, banana_fairy_logic_for_player(4)
                )
            )
        )
    )
)

achievement(
    title = "Peak Position",
    points = 1,
    description = "Perform a Boost Start",
    trigger = 
    (
        (
            player_1_obj.is_human_player() &&
            player_1_obj.zero_to_full_speed()
        )
        ||
        (
            player_2_obj.is_human_player() &&
            player_2_obj.zero_to_full_speed()
        )
        ||
        (
            player_3_obj.is_human_player() &&
            player_3_obj.zero_to_full_speed()
        )
        ||
        (
            player_4_obj.is_human_player() &&
            player_4_obj.zero_to_full_speed()
        )
    )
)

buddy_data = {
    0x00: {
        "map": 0x03,
        "title": "Coral Capers",
        "bud_name": "Enguarde",
        "target": 140
    },
    0x01: {
        "map": 0x05,
        "title": "Clam City",
        "bud_name": "Enguarde",
        "target": 85
    },
    0x02: {
        "map": 0x08,
        "title": "Jungle Hijinxs",
        "bud_name": "Rambi",
        "target": 105
    },
}

for element in buddy_data {
    achievement(
        title = buddy_data[element]["title"],
        points = 3,
        description = format("While riding {0} on {1}, collect {2} bananas", buddy_data[element]["bud_name"], track_map[buddy_data[element]["map"]], buddy_data[element]["target"]),
        trigger = 
        get_track() == buddy_data[element]["map"] &&
        (
            (
                player_1_obj.is_human_player() &&
                never(!player_1_obj.is_riding_buddy()) &&
                tally(
                   buddy_data[element]["target"], banana_fairy_logic_for_player(1)
                )
            )
            ||
            (
                player_2_obj.is_human_player() &&
                never(!player_2_obj.is_riding_buddy()) &&
                tally(
                   buddy_data[element]["target"], banana_fairy_logic_for_player(2)
                )
            )
            ||
            (
                player_3_obj.is_human_player() &&
                never(!player_3_obj.is_riding_buddy()) &&
                tally(
                   buddy_data[element]["target"], banana_fairy_logic_for_player(3)
                )
            )
            ||
            (
                player_4_obj.is_human_player() &&
                never(!player_4_obj.is_riding_buddy()) &&
                tally(
                   buddy_data[element]["target"], banana_fairy_logic_for_player(4)
                )
            )
        )
    )

}



chal_names = ["Lightly Sprinkled", "Double-Dipped", "Fully Frosted", "Candy-Crystalized"]
chal_score = [5, 10, 10, 25]
//chal_prog = ["progression", "progression", "progression", "win_condition"]

for element in range(0, 3, 1) {
    achievement(
        title = chal_names[element],
        points = chal_score[element],
        // type = chal_prog[element],
        description = format("Clear all of Candy's Challenges in Level {0}", element + 1),
        trigger = 
            !demo_playing() &&
            get_mode() == 04 &&
            measured(
                count_cleared_challenges_per_level(element + 1) == 8
            ) &&
            prev(count_cleared_challenges_per_level(element + 1) == 7)
    )
}

function human_player_is_1st_in_gp(character_id) {
    return dword_be(0x3511ac) == character_id
}

function trophy_revealed() {
    trophy_state = ptr(dword_be(0x0048319c), [0x01], byte)
    cup_prog = ptr(dword_be(0x53560c), [0x3c], dword_be)
    // trophy revealed and players was on final race of cup, timecode done
    return trophy_state == 0x05 && prev(trophy_state < 0x05) && cup_prog == dword_be(0x35204c) && float_be(0x0053f368) > 1200.0
}

escalation = ["Run", "Rush", "Rampage"]
esc_score = [3, 5, 10]

function check_if_cup_is_victory_cond(cup, difficulty) {
    if (cup == 0x03 && difficulty == 0x02) {
        return "win_condition"
    } else {
        return "progression"
    }
}

for difficulty in difficulty_map {
    current_difficulty = difficulty_map[difficulty]
    dif_text = escalation[difficulty]
    score = esc_score[difficulty]

    // Go over all four default cups, excluding Choice and Random
    for cup in range(0, 3, 1) {
        achievement(
            title = format("{0} {1}", gp_map[cup], dif_text),
            points = score,
            type = check_if_cup_is_victory_cond(cup, difficulty),
            description = format("Reach first place in the {0} Jungle Grand Prix on {1} difficulty", gp_map[cup], difficulty_map[difficulty]),
            trigger = 
            get_mode() == 0 &&
            get_gp() == cup && get_difficulty() == difficulty &&
            (
                (
                    player_1_obj.is_human_player() && human_player_is_1st_in_gp(player_1_obj.get_character()) && trophy_revealed()
                )
                ||
                (
                    player_2_obj.is_human_player() && human_player_is_1st_in_gp(player_2_obj.get_character()) && trophy_revealed()
                )
                ||
                (
                    player_3_obj.is_human_player() && human_player_is_1st_in_gp(player_3_obj.get_character()) && trophy_revealed()
                )
                ||
                (
                    player_4_obj.is_human_player() && human_player_is_1st_in_gp(player_4_obj.get_character()) && trophy_revealed()
                )
            )
        )
    }
}


achievement(
    title = "The Choice is Yours",
    points = 3,
    description = "Reach first place in the Choice Cup in Jungle Grand Prix on any difficulty",
    trigger = 
    get_mode() == 0 &&
    get_gp() == 0x04 &&
    (
        (
            player_1_obj.is_human_player() && human_player_is_1st_in_gp(player_1_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_2_obj.is_human_player() && human_player_is_1st_in_gp(player_2_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_3_obj.is_human_player() && human_player_is_1st_in_gp(player_3_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_4_obj.is_human_player() && human_player_is_1st_in_gp(player_4_obj.get_character()) && trophy_revealed()
        )
    )
)

achievement(
    title = "You Have No Choice",
    points = 3,
    description = "Reach first place in the Random Cup in Jungle Grand Prix on any difficulty",
    trigger = 
    get_mode() == 0 &&
    get_gp() == 0x05 &&
    (
        (
            player_1_obj.is_human_player() && human_player_is_1st_in_gp(player_1_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_2_obj.is_human_player() && human_player_is_1st_in_gp(player_2_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_3_obj.is_human_player() && human_player_is_1st_in_gp(player_3_obj.get_character()) && trophy_revealed()
        )
        ||
        (
            player_4_obj.is_human_player() && human_player_is_1st_in_gp(player_4_obj.get_character()) && trophy_revealed()
        )
    )
)


// Parched Palace get golden banana
// Shortcut barrel in Mt Dynamite




// In Challenge mode
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x04 && in_a_race_state(), "Donkey Kong is tackling Candy's Challenge No. {1} • {2} / 32 Challenges Cleared",
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Challenge ID", get_candy_chal(), challenge_data_true_id_map, fallback="??"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE")
)

// In Tutorial
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x07 && in_a_race_state(), "Donkey Kong is learning the ropes at Cranky's Flight School • {0} / 32 Challenges Cleared",
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE")
)

// In GP mode, alone
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x00 && in_a_race_state() && !player_2_obj.is_human_player(), "{0} is competing in the {1} Cup on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE")
)

// In GP mode, with 2 players
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x00 && in_a_race_state() && !player_3_obj.is_human_player(), "{0} and {4} are competing in the {1} Cup on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character")
)

// In GP mode, with 3 players
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x00 && in_a_race_state() && !player_4_obj.is_human_player(), "{0}, {4} and {5} are competing in the {1} Cup on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character")
)

// In GP mode, with 4 players
rich_presence_conditional_display(!demo_playing() && get_mode() == 0x00 && in_a_race_state() && player_4_obj.is_human_player(), "{0}, {4}, {5} and {6} are competing in the {1} Cup on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 4", player_4_obj.get_character(), character_map, fallback="an unknown character")
)


// Single Race, Time Trial, Free Run
rich_presence_conditional_display(!demo_playing() && get_mode() <= 0x03 && in_a_race_state() && !player_2_obj.is_human_player(), "{0} is in a {1} on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE")
)

// Single Race, Time Trial, Free Run 2 players
rich_presence_conditional_display(!demo_playing() && get_mode() <= 0x03 && in_a_race_state() && !player_3_obj.is_human_player(), "{0} and {4} are in a {1} on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character")
)

// Single Race, Time Trial, Free Run 3 players 
rich_presence_conditional_display(!demo_playing() && get_mode() <= 0x03 && in_a_race_state() && !player_4_obj.is_human_player(), "{0}, {4} and {5} are a {1} on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character")
)

// Single Race, Time Trial, Free Run 4 players
rich_presence_conditional_display(!demo_playing() && get_mode() <= 0x03 && in_a_race_state() && player_4_obj.is_human_player(), "{0}, {4}, {5} and {6} are in a {1} on {2} • {3} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 4", player_4_obj.get_character(), character_map, fallback="an unknown character")
)

// Not in race: Ceremony?
/*
rich_presence_conditional_display(!!demo_playing() && get_mode() == 0x00 && in_victory_ceremony() && !player_2_obj.is_human_player(), "{0} is in the victory ceremony of the {1} Cup • {2} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE")
)

rich_presence_conditional_display(!!demo_playing() && get_mode() == 0x00 && in_victory_ceremony() && !player_3_obj.is_human_player(), "{0} and {3} are in the victory ceremony of the {1} Cup • {2} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character")
)

rich_presence_conditional_display(!!demo_playing() && get_mode() == 0x00 && in_victory_ceremony() && !player_4_obj.is_human_player(), "{0}, {3} and {4} are in the victory ceremony of the {1} Cup • {2} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character")
)

rich_presence_conditional_display(!!demo_playing() && get_mode() == 0x00 && in_victory_ceremony() && player_4_obj.is_human_player(), "{0}, {3}, {4} and {5} are in the victory ceremony of the {1} Cup • {2} / 32 Challenges Cleared",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("GP", get_gp(), gp_map, fallback="an unknown GP"),
    rich_presence_value("Challenge Clear Count", count_cleared_challenges(), "VALUE"),
    rich_presence_lookup("Character 2", player_2_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 3", player_3_obj.get_character(), character_map, fallback="an unknown character"),
    rich_presence_lookup("Character 4", player_4_obj.get_character(), character_map, fallback="an unknown character")
)
*/

rich_presence_display("In the Main Menu")