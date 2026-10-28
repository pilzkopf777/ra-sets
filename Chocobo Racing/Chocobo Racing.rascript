// Chocobo Racing
// #ID = 11352

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

current_mode = byte(0x07ae38)
track = byte(0x07afa8)
story_score = byte(0x08d759)
p1_char = byte(0x08c02d)
p2_char = byte(0x08c05d)
p1_abl = byte(0x08c02c)
p2_abl = byte(0x08c05c)
first_place_gp_score = byte(0x08d2ac)
first_place_gp_char = byte(0x08d2b0)
race_time = dword(0x07b044)
goal_lap_count = byte(0x07ae36)
team_comp_definition = byte(0x08d752)

p1_race_pos = ptr(tbyte(0x08d32c), [0x27A], byte)

function in_demo() {
    return byte(0x07afab) == 0x01
}

function on_title_screen() {
    // TODO: Not safe?
    return byte(0x08d761) == 0x01
}

function in_mode_select() {
    return byte(0x08d5b6) == 0x01
}

function on_any_main_menu_screen() {
    return word(0x07afb2) == 0x00
}

function in_race() {
    // return byte(0x07afec) == 0x00
    return word(0x07afb2) == 0x8010
}

function story_mode_score_revealed() {
    return word(0x08d784) >= 0x150 && prev(word(0x08d784) < 0x150)
}

function finished_race() {
    return prev(byte(0x07b048) == 0x03) && byte(0x07b048) == 0x04
}

function custom_char_p1() {
    return p1_char != byte(0x08c033)
}

function base_char_p1() {
    return p1_char == byte(0x08c033)
}

function custom_char_p2() {
    return p2_char != byte(0x08c063)
}

function base_char_p2() {
    return p2_char == byte(0x08c063)
}

function handicap_p1_off() {
    return bit2(0x1e929a) == 0x00
}

function handicap_p2_off() {
    return bit3(0x1e929a) == 0x00
}

function game_init() {
    return byte(0x08d5b7) == 0x04
}

function ending_cutscene_ended() {
    return current_mode == 0x09 && prev(current_mode == 0x01) && track == 0x08 && byte(0x07ae18) == 0x01
}

// player map selection
array_of_gp_config_maps = [byte(0x07ae3c), byte(0x07ae3d), byte(0x07ae3e), byte(0x07ae3f)]

function gp_contains_requested_map(requested_map) {
    return once(
        in_race() &&
        (
            array_of_gp_config_maps[0] == requested_map ||
            array_of_gp_config_maps[1] == requested_map ||
            array_of_gp_config_maps[2] == requested_map ||
            array_of_gp_config_maps[3] == requested_map
        )
    ) 
}

story_mode_intermission_prog = byte(0x07b0a0)

function story_chapter_done(chapter_num) {
    return story_mode_intermission_prog == 0x01 && prev(story_mode_intermission_prog == 0x00)
        && track + 1 == chapter_num
}

function playing_solo() {
    return team_comp_definition == 0x01
}

function playing_vs() {
    return team_comp_definition == 0x00
}

function only_watching() {
    return team_comp_definition == 0x02
}

function gp_scores_revealed() {
    return byte(0x08d78c) == 0x82 && prev(byte(0x08d78c) < 0x82)
}

mode_map = {
    0x00: "Options",
    0x01: "Story Mode",
    0x02: "Time Attack",
    0x03: "Grand Prix",
    0x04: "VS Mode",
    0x05: "Relay Race",
    0x06: "Memory Card"
}

track_map = {
    0x00: "Cid's Test Track",
    0x01: "Moogle Forest",
    0x02: "Ancient Gate",
    0x03: "Mithril Mines",
    0x04: "Black Manor",
    0x05: "Floating Gardens",
    0x06: "Gingerbread Land",
    0x07: "Vulcan-o Valley",
    0x08: "Fantasia",
    0x09: "F.F.VIII Circuit"
}

ability_map = {
    0x00: "Dash",
    0x01: "Flap",
    0x02: "Grip Up",
    0x03: "Mug",
    0x04: "Magic Plus",
    0x05: "Barrier",
    0x06: "Charge",
    0x07: "Receive",
    0x08: "Megaflare",
    0x09: "Gunblade"
}

character_map = {
    0x00: "Chocobo",
    0x01: "Mog",
    0x02: "Goblin",
    0x03: "White Mage",
    0x04: "Black Magican",
    0x05: "Chubby Chocobo",
    0x06: "Behemoth",
    0x07: "Golem",
    0x08: "Bahamut",
    0x09: "Squall",
    0x0a: "Cid's Tank",
    0x0b: "Mumba",
    0x0c: "Cloud",
    0x0d: "Cactuar",
    0x0e: "Aya",
    0x0f: "Classic Chocobo",
    0x10: "SS Invincible",
    0x11: "Jack"
}

story_prog_data = {
    0: {
        "name": "The Fastest Chocobo Alive",
        "pts": 2,
        "chapter_string": "first"
    },
    1: {
        "name": "It's How You Use the Tool That Counts",
        "pts": 2,
        "chapter_string": "second"
    },
    2: {
        "name": "A Staunch, Stalwart Ally",
        "pts": 2,
        "chapter_string": "third"
    },
    3: {
        "name": "Charitable Criminal",
        "pts": 3,
        "chapter_string": "fourth"
    },
    4: {
        "name": "A Terrifyingly Fun Time!",
        "pts": 4,
        "chapter_string": "fifth"
    },
    5: {
        "name": "Touring Tranquil Turf",
        "pts": 4,
        "chapter_string": "sixth"
    },
    6: {
        "name": "Acid Reflux",
        "pts": 5,
        "chapter_string": "seventh"
    },
    7: {
        "name": "High Risk, Reward and Heat",
        "pts": 5,
        "chapter_string": "eighth"
    },
}

old_relay_cheevo_id_map = {
    0x00: 83566,
    0x01: 83567,
    0x02: 83568,
    0x03: 83569,
    0x04: 83570,
    0x05: 83571,
    0x06: 83572,
    0x07: 83573,
    0x08: 83574,
    0x09: 83575
}

time_trial_target = {
    0x00: 2012,
    0x01: 2312,
    0x02: 2462,
    0x03: 2582,
    0x04: 3482,
    0x05: 3512,
    0x06: 4442,
    0x07: 4772,
    0x08: 5072,
    0x09: 4802
}

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

function get_time_as_string(input) {
    offset_time = input // + 4
    total_sec = offset_time / 30

    min = total_sec / 60
    sec = total_sec % 60

    return format("{0}:{1}:00", pad_to_twos(min), pad_to_twos(sec))
}

track_cheevo_names = {
    0x00: {
        "timetrial": "Experimenting with Efficiency",
        "relay": "Test Track Tag Team",
    },
    0x01: {
        "timetrial": "Kupo de Grace",
        "relay": "Pass the Branch",
    },
    0x02: {
        "timetrial": "The Tides of Time",
        "relay": "The Flow of Time",
    },
    0x03: {
        "timetrial": "Mettle of Mythril",
        "relay": "All Terrain Triumph",
    },
    0x04: {
        "timetrial": "Haunting Hour",
        "relay": "The Three Haunted Racers",
    },
    0x05: {
        "timetrial": "Terrace of Eternity",
        "relay": "The Scenic Route",
    },
    0x06: {
        "timetrial": "Intermittent Fasting",
        "relay": "Sweet, Sweet Victory",
    },
    0x07: {
        "timetrial": "High Temperatures, Tight Timing",
        "relay": "Air Conditioning Required",
    },
    0x08: {
        "timetrial": "Inching Towards Infinity",
        "relay": "A Victory One Dreams About",
    },
    0x09: {
        "timetrial": "Triple Triad? No, We're Tearing Tracks!",
        "relay": "Twists, Turns and Around and Round And...",
    },
}


for current_track in track_map {
    // Leaderboards
    leaderboard(
        title = format("Time Attack: {0} (Standard Character)", track_map[current_track]),
        description = format("Reach the goal as quickly as possible in a Time Attack on {0} with any regular character", track_map[current_track]),
        start = 
        (
            in_race() && finished_race() && base_char_p1() && track == current_track && current_mode == 0x02
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            race_time * 2
        ),
        format = "FRAMES", lower_is_better = true
    )

    leaderboard(
        title = format("Time Attack: {0} (Custom Character)", track_map[current_track]),
        description = format("Reach the goal as quickly as possible in a Time Attack on {0} with any custom character", track_map[current_track]),
        start = 
        (
            in_race() && finished_race() && custom_char_p1() && track == current_track && current_mode == 0x02
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            race_time * 2
        ),
        format = "FRAMES", lower_is_better = true
    )

    // Time Trial
    achievement(
        title = track_cheevo_names[current_track]["timetrial"],
        points = 5,
        description = format("Beat the time of {0} on {1} in Time Attack (handicap may be activated)", get_time_as_string(time_trial_target[current_track]), track_map[current_track]),
        id = old_relay_cheevo_id_map[current_track],
        trigger = (
            in_race() &&
            trigger_when(finished_race()) &&
            track == current_track &&
            current_mode == 0x02 &&
            race_time <= time_trial_target[current_track]
        )
    )

    // Relay Races
    achievement(
        title = track_cheevo_names[current_track]["relay"],
        points = 5,
        description = format("Beat the computer in a Relay Race set at 3 laps each on {0}.", track_map[current_track]),
        id = old_relay_cheevo_id_map[current_track],
        trigger = (
            current_mode == 0x05 &&
            // vs cpu
            team_comp_definition == 0x01 &&
            // 3 laps * 3
            goal_lap_count == 0x09 &&
            // correct map
            track == current_track &&
            finished_race() &&
            p1_race_pos == 0x00
        )
    )
}


// Story mode prog (except final)
for count in range(0, 7, 1) {
    chapter_metadata = story_prog_data[count]

    achievement(
        title = chapter_metadata["name"],
        points = chapter_metadata["pts"],
        description = format("Complete the {0} chapter of Story Mode without using the handicap", chapter_metadata["chapter_string"]),
        trigger = (
            story_chapter_done(count + 1) &&
            current_mode == 0x01 &&
            handicap_p1_off()
        )
    )
}

achievement(
    title = "The Domain of the Gods",
    points = 25,
    description = "Complete the final chapter of Story Mode without using the handicap and watch the end credits",
    trigger = (
        ending_cutscene_ended()
    )
)

achievement(
    title = "Racing Perfection",
    points = 25,
    description = "Obtain a perfect score of 100 points score in Story Mode",
    id = 83626,
    trigger = (
        current_mode == 0x09 &&
        story_mode_score_revealed() &&
        story_score == 100
    )
)

achievement(
    title = "Star Breed",
    points = 25,
    description = "Score a perfect 36 points in a Grand Prix with Vulcan-O Valley, Fantasia and F.F.VIII Circuit in rotation",
    id = 83554,
    trigger = (
        gp_contains_requested_map(0x07) &&
        gp_contains_requested_map(0x08) &&
        gp_contains_requested_map(0x09) &&
        // prev(in_race()) && in_race() &&
        // never(on_any_main_menu_screen()
        byte(0x07afec) != 0x0b &&
        gp_scores_revealed() &&
        current_mode == 0x03 &&
        // ID matches last track
        byte(0x07ae3f) == track &&
        (
            (
                // p1 is valid
                p1_char == first_place_gp_char &&
                first_place_gp_score == 36
            )
            ||
            (
                // p2 is valid
                p2_char == first_place_gp_char &&
                first_place_gp_score == 36
            )
        ) 
    )
)

achievement(
    title = "Pro Racer",
    points = 10,
    description = "Score a perfect 36 points in a Grand Prix",
    id = 83553,
    trigger = (
        on_any_main_menu_screen() && byte(0x07afec) == 0x0b &&
        gp_scores_revealed() &&
        current_mode == 0x03 &&
        // ID matches last track
        byte(0x07ae3f) == track && 
        (
            (
                // p1 is valid
                p1_char == first_place_gp_char &&
                first_place_gp_score == 36
            )
            ||
            (
                // p2 is valid
                p2_char == first_place_gp_char &&
                first_place_gp_score == 36
            )
        ) 
    )
)

achievement(
    title = "Gunblade Specialist",
    points = 5,
    description = "Win Squall's challenge and unlock him as a playable character",
    id = 83614,
    trigger = (
        bit1(0x1e929d) == 0x01 && prev(bit1(0x1e929d) == 0x00) && current_mode == 0x01 && in_race()
    )
)

char_gp_name_map = {
    0x00: "Little Chocobo in a Big, Wide World",
    0x01: "Mysterious Creature, Legendary Racer",
    0x02: "Great Going for a Little Goblin",
    0x03: "A Monumental, Magical Moment",
    0x04: "Proficient in Spells and Speed",
    0x05: "Earning a Cheat Day",
    0x06: "Monstrous Effort",
    0x07: "A New Experience for Old Rocks",
    0x08: "Living Legend"
}

old_gp_movie_cheevo_ids = {
    0x00: 83605,
    0x01: 83606,
    0x02: 83607,
    0x03: 83608,
    0x04: 83609,
    0x05: 83610,
    0x06: 83611,
    0x07: 83612,
    0x08: 83613
}

for char_id in range(0x00, 0x08, 0x01) {
    current_car_name = character_map[char_id]

    achievement(
        title = char_gp_name_map[char_id],
        points = 5,
        description = format("Win a Grand Prix as {0}", current_car_name),
        id = old_gp_movie_cheevo_ids[char_id],
        trigger = 
        (
            on_any_main_menu_screen() && byte(0x07afec) == 0x0b &&
            gp_scores_revealed() &&
            current_mode == 0x03 &&
            // ID matches last track
            byte(0x07ae3f) == track && 
            (
                (
                    // p1 is valid
                    p1_char == first_place_gp_char &&
                    p1_char == char_id
                )
                ||
                (
                    // p2 is valid
                    p2_char == first_place_gp_char &&
                    p2_char == char_id
                )
            ) 
        )
    )
}

char_unlock_name_map = {
    0x0a: "Tanking as a Tank",
    0x0b: "Mumba to the Rescue",
    0x0c: "Now Where's my Remake?",
    0x0d: "1000 Needles",
    0x0e: "Mitochondria Queen",
    0x0f: "8bit Racing",
    0x10: "Fly Away",
    0x11: "Wait, Who?"
}

old_char_unlock_id = {
    0x0a: 83615,
    0x0b: 83616,
    0x0c: 83617,
    0x0d: 83618,
    0x0e: 83619,
    0x0f: 83620,
    0x10: 83621,
    0x11: 83622
}

for char_id in range(0x0a, 0x11, 0x01) {
    current_car_name = character_map[char_id]

    achievement(
        title = char_unlock_name_map[char_id],
        points = 10,
        description = format("Unlock {0} as a playable character", current_car_name),
        id = old_char_unlock_id[char_id],
        trigger = 
        (
            byte(0x1ea998) == char_id - 9 && prev(byte(0x1ea998) == char_id - 10)
        )
    )
}



achievement(
    title = "Bronze Trophy",
    points = 10,
    description = "Win all Bronze Trophies on Grand Prix.",
    id = 83623,
    trigger = (
        in_race() &&
        // There are 10 tracks total
        measured(bitcount(0x1e9290) + bit0(0x1e9291) + bit1(0x1e9291) == 10) &&
        prev(bitcount(0x1e9290) + bit0(0x1e9291) + bit1(0x1e9291) == 9)
    )
)

achievement(
    title = "Silver Trophy",
    points = 10,
    description = "Win all Silver Trophies on Grand Prix.",
    id = 83624,
    trigger = (
        in_race() &&
        // There are 10 tracks total
        measured(bit2(0x1e9291) + bit3(0x1e9291) + bit4(0x1e9291) + bit5(0x1e9291) + bit6(0x1e9291) + bit7(0x1e9291) + bit0(0x1e9292) + bit1(0x1e9292) + bit2(0x1e9292) + bit3(0x1e9292) == 10) &&
        prev(bit2(0x1e9291) + bit3(0x1e9291) + bit4(0x1e9291) + bit5(0x1e9291) + bit6(0x1e9291) + bit7(0x1e9291) + bit0(0x1e9292) + bit1(0x1e9292) + bit2(0x1e9292) + bit3(0x1e9292) == 9)
    )
)

achievement(
    title = "Gold Trophy",
    points = 10,
    description = "Win all Gold Trophies on Grand Prix.",
    id = 83625,
    trigger = (
        in_race() &&
        // There are 10 tracks total
        measured(bit4(0x1e9292) + bit5(0x1e9292) + bit6(0x1e9292) + bit7(0x1e9292) + bit0(0x1e9293) + bit1(0x1e9293) + bit2(0x1e9293) + bit3(0x1e9293) + bit4(0x1e9293) + bit5(0x1e9293) == 10) &&
        prev(bit4(0x1e9292) + bit5(0x1e9292) + bit6(0x1e9292) + bit7(0x1e9292) + bit0(0x1e9293) + bit1(0x1e9293) + bit2(0x1e9293) + bit3(0x1e9293) + bit4(0x1e9293) + bit5(0x1e9293) == 9)
    )
)




// RP
rp_adjusted_mode_map = {
    0x01: "in Story Mode",
    0x02: "in a Time Attack",
    0x03: "in a Grand Prix",
    0x04: "in a VS Race",
    0x05: "in a Relay Race",
    0x09: "in a Test Run"
}

rp_adjusted_track_map = {
    0x00: "on Cid's Test Track",
    0x01: "in Moogle Forest",
    0x02: "in Ancient Gate",
    0x03: "in Mithril Mines",
    0x04: "in Black Manor",
    0x05: "in Floating Gardens",
    0x06: "in Gingerbread Land",
    0x07: "in Vulcan-o Valley",
    0x08: "in Fantasia",
    0x09: "on F.F.VIII Circuit"
}

rich_presence_conditional_display(on_title_screen() || in_demo() || !game_init(), "On the Title Screen")

// Normally display race data but for Story Mode there's an exception:
rich_presence_conditional_display(current_mode == 0x01 && !in_race(), "Watching a cutscene in Story Mode")

rich_presence_conditional_display(on_any_main_menu_screen(), "In the Main Menu")

rich_presence_conditional_display(in_race() && playing_solo(), "{0} is {1} {2}",
    rich_presence_lookup("Player1", p1_char, character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", current_mode, rp_adjusted_mode_map, fallback="in an unknown mode"),
    rich_presence_lookup("Track", track, rp_adjusted_track_map, fallback="on an unknown race track")
)

rich_presence_conditional_display(in_race() && playing_vs(), "{0} and {1} are {2} {3}",
    rich_presence_lookup("Player1", p1_char, character_map, fallback="An unknown character"),
    rich_presence_lookup("Player2", p2_char, character_map, fallback="an unknown character"),
    rich_presence_lookup("Mode", current_mode, rp_adjusted_mode_map, fallback="in an unknown mode"),
    rich_presence_lookup("Track", track, rp_adjusted_track_map, fallback="on an unknown race track")
)

rich_presence_display("Playing Chocobo Racing")





// VOID and Demoted stuff

achievement(
    title = "[VOID] Musical Melodies", points = 10,
    description = "Unlock all the music and listen to them (all 28) in the music player.",
    id = 83555, badge = "90292", published = "16/09/2019 02:22:31", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 0) && once(byte(0x0AF176) == 0) && once(byte(0x0AF176) == 1) &&
              once(byte(0x0AF176) == 2) && once(byte(0x0AF176) == 3) && once(byte(0x0AF176) == 4) &&
              once(byte(0x0AF176) == 5) && once(byte(0x0AF176) == 6) && once(byte(0x0AF176) == 7) &&
              once(byte(0x0AF176) == 8) && once(byte(0x0AF176) == 10) && once(byte(0x0AF176) == 11) &&
              once(byte(0x0AF176) == 12) && once(byte(0x0AF176) == 13) && once(byte(0x0AF176) == 14) &&
              once(byte(0x0AF176) == 15) && once(byte(0x0AF176) == 16) && once(byte(0x0AF176) == 17) &&
              once(byte(0x0AF176) == 18) && once(byte(0x0AF176) == 19) && once(byte(0x0AF176) == 20) &&
              once(byte(0x0AF176) == 21) && once(byte(0x0AF176) == 22) && once(byte(0x0AF176) == 23) &&
              once(byte(0x0AF176) == 24) && once(byte(0x0AF176) == 25) && once(byte(0x0AF176) == 26) &&
              once(byte(0x0AF176) == 27) && once(byte(0x0AF176) == 9) && once(byte(0x096868) == 1) &&
              once(byte(0x096868) == 7) && once(byte(0x096868) == 8) && once(byte(0x096868) == 9) &&
              once(byte(0x096868) == 10) && once(byte(0x096868) == 11) && once(byte(0x096868) == 12) &&
              once(byte(0x096868) == 6) && once(byte(0x096868) == 29) && once(byte(0x096868) == 2) &&
              once(byte(0x096868) == 3) && once(byte(0x096868) == 13) && once(byte(0x096868) == 14) &&
              once(byte(0x096868) == 15) && once(byte(0x096868) == 16) && once(byte(0x096868) == 17) &&
              once(byte(0x096868) == 18) && once(byte(0x096868) == 19) && once(byte(0x096868) == 20) &&
              once(byte(0x096868) == 21) && once(byte(0x096868) == 22) && once(byte(0x096868) == 23) &&
              once(byte(0x096868) == 24) && once(byte(0x096868) == 25) && once(byte(0x096868) == 26) &&
              once(byte(0x096868) == 27) && once(byte(0x096868) == 28) && once(byte(0x096868) == 30)
)

achievement(
    title = "[VOID] Cid's Test Track Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Cid's Test Track.",
    id = 83556, badge = "90645", published = "16/09/2019 02:22:35", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && once(byte(0x0084D2) == 6) && byte(0x096868) == 3 &&
              never(byte(0x096868) == 26) && byte(0x07AE3C) == 0
)

achievement(
    title = "[VOID] Moogle Forest Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Moogle Forest.",
    id = 83557, badge = "90646", published = "16/09/2019 02:22:38", modified = "25/04/2022 01:59:25",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 1 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] The Ancient Gate Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on The Ancient Gate.",
    id = 83558, badge = "90648", published = "16/09/2019 02:22:41", modified = "25/04/2022 01:59:27",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 2 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Mithril Mines Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Mithril Mines.",
    id = 83559, badge = "90647", published = "16/09/2019 02:22:43", modified = "25/04/2022 01:59:25",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 3 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] The Black Manor Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on The Black Manor.",
    id = 83560, badge = "90649", published = "16/09/2019 02:22:46", modified = "25/04/2022 01:59:27",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 4 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Floating Gardens Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Floating Gardens.",
    id = 83561, badge = "90650", published = "16/09/2019 02:22:49", modified = "25/04/2022 01:59:23",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 5 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Gingerbread Land Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Gingerbread Land.",
    id = 83562, badge = "90651", published = "16/09/2019 02:22:52", modified = "25/04/2022 01:59:23",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 6 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Vulcan-O Valley Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Vulcan-O Valley.",
    id = 83563, badge = "90652", published = "16/09/2019 02:23:49", modified = "25/04/2022 01:59:28",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 7 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Fantasia Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on Fantasia.",
    id = 83564, badge = "90653", published = "16/09/2019 02:23:51", modified = "25/04/2022 01:59:23",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 8 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] FFVIII Circuit Marathon", points = 5,
    description = "Beat the computer in Vs Mode set at 10 laps on FFVIII Circuit.",
    id = 83565, badge = "90654", published = "16/09/2019 02:23:54", modified = "24/07/2024 20:50:38",
    trigger = never(byte(0x07AE38) != 4) && byte(0x07AE36) == 10 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 9 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "[VOID] Relaxing Story Time", points = 5, type="progression",
    description = "Complete Story mode, chapters 1-3. (No Handicap)",
    id = 83549, badge = "90235", published = "16/09/2019 02:22:10", modified = "15/11/2025 17:26:48",
    trigger = byte(0x07AFA8) == 2 && byte(0x07AE38) == 1 && byte(0x07B0A0) == 2 && prev(byte(0x07B0A0)) == 1
)

achievement(
    title = "[VOID] The Dusty Magical Chapter", points = 10, type="progression",
    description = "Complete Story mode, chapters 4-6. (No Handicap)",
    id = 83550, badge = "90236", published = "16/09/2019 02:22:13", modified = "15/11/2025 22:41:25",
    trigger = byte(0x07AFA8) == 5 && byte(0x07AE38) == 1 && byte(0x07B0A0) == 2 && prev(byte(0x07B0A0)) == 1
)

achievement(
    title = "[VOID] A Chocobo's Story", points = 25, type="win_condition",
    description = "Complete Story Mode and watch the credits (No Handicap).",
    id = 83551, badge = "90237", published = "16/09/2019 02:22:16", modified = "15/11/2025 22:34:24",
    trigger = byte(0x07AE3C) == 8 && byte(0x07AFA8) == 8 && byte(0x07AE38) == 1 && byte(0x07AE18) == 1 &&
              word(0x08DBBC) == 5616 && prev(word(0x08DBBC)) == 5615
)

achievement(
    title = "DEMOTED AS UNWELCOME CONCEPT - Chocobo Preview", points = 1,
    description = "Watch the Chocobo's Dungeon 2 trailer.",
    id = 83552, badge = "90238", published = "16/09/2019 02:22:20", modified = "18/12/2025 04:53:23",
    trigger = byte(0x07AE18) == 12 && word(0x08DBBC) == 1792 && prev(word(0x08DBBC)) < 1792
)
