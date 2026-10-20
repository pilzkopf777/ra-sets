// Chocobo Racing
// #ID = 11352

current_mode = byte(0x07ae38)
track = byte(0x07afa8)
story_score = byte(0x08d759)
p1_char = byte(0x08c02d)
p2_char = byte(0x08c05d)
p1_abl = byte(0x08c02c)
p2_abl = byte(0x08c05c)
gp_pts_p1 = byte(0x08c028)
gp_pts_p2 = 0
race_time = dword(0x07b044)
goal_lap_count = byte(0x07ae36)
team_comp_definition = byte(0x08d752)

function in_demo() {
    return byte(0x07afab) == 0x01
}

function on_title_screen() {
    // TODO: Not safe?
    return byte(0x08d761) == 0x01
}

function in_main_menu() {
    return byte(0x08d5b6) == 0x01
}

function in_race() {
    return byte(0x07afec) == 0x00
}

function story_mode_score_revealed() {
    return word(0x08d784) >= 0x150 && prev(word(0x08d784) < 0x150)
}

function finished_race() {
    return prev(byte(0x07afca) == 0x00) && byte(0x07afca) == 0x01
}

function handicap_p1_off() {
    return bit2(0x1e929a) == 0x01
}

function handicap_p2_off() {
    return bit3(0x1e929a) == 0x01
}

array_of_gp_config_maps = [byte(0x07ae3c), byte(0x07ae3d), byte(0x07ae3e), byte(0x07ae3f)]

function gp_contains_requested_maps(requested_maps_array) {
    final_cond = always_true()

    for req_map in requested_maps_array {
        final_cond = final_cond && array_contains(array_of_gp_config_maps, req_map)
    }

    return final_cond
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


// Story mode prog (except final)
for count in range(0, 7, 1) {
    chapter_metadata = story_prog_data[count]

    achievement(
        title = chapter_metadata["name"],
        points = chapter_metadata["pts"],
        description = format("Complete the {0} chapter of Story mode without using the handicap", chapter_metadata["chapter_string"]),
        trigger = (
            story_chapter_done(count + 1) &&
            current_mode == 0x01 &&
            handicap_p1_off()
        )
    )
}

// TODO: Final Chapter


achievement(
    title = "Racing Perfection",
    points = 25,
    description = "Obtain a perfect 100 points score on the Story Mode.",
    id = 83626,
    trigger = (
        current_mode == 0x09 &&
        story_mode_score_revealed() &&
        story_score == 100
    )
)


achievement(
    title = "Star Breed", // TODO
    points = 25,
    description = "Get a perfect 36 points in a Grand Prix with Vulcan-O Valley, Fantasia and F.F.VIII Circuit in the rotation.",
    id = 83554,
    trigger = (
        always_false()
    )
)


achievement(
    title = "Pro Racer", points = 10,
    description = "Get a perfect 36 points in Grand Prix.",
    id = 83553, badge = "90639", published = "16/09/2019 02:22:23", modified = "25/04/2022 01:59:26",
    trigger = once(byte(0x096868) == 3) && byte(0x07AE38) == 3 && byte(0x08C028) == 36
)

achievement(
    title = "Cid's Test Track Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Cid's Test Track.",
    id = 83566, badge = "90655", published = "16/09/2019 02:23:57", modified = "04/10/2019 16:17:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 0 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Moogle Forest Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Moogle Forest.",
    id = 83567, badge = "90656", published = "16/09/2019 02:24:00", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 1 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "The Ancient Gate Relay ", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on The Ancient Gate.",
    id = 83568, badge = "90657", published = "16/09/2019 02:24:02", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 2 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Mithril Mines Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Mithril Mines.",
    id = 83569, badge = "90658", published = "16/09/2019 02:24:05", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 3 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "The Black Manor Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on The Black Manor.",
    id = 83570, badge = "90661", published = "16/09/2019 02:24:08", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 4 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Floating Gardens Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Floating Gardens.",
    id = 83571, badge = "90660", published = "16/09/2019 02:24:11", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 5 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Gingerbread Land Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Gingerbread Land.",
    id = 83572, badge = "90662", published = "16/09/2019 02:24:13", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 6 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Vulcan-O Valley Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Vulcan-O Valley.",
    id = 83573, badge = "90663", published = "16/09/2019 02:24:16", modified = "12/06/2020 03:27:33",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 7 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Fantasia Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on Fantasia.",
    id = 83574, badge = "90664", published = "16/09/2019 02:24:19", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 8 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "FFVIII Circuit Relay", points = 5,
    description = "Beat the computer in Relay Race set at 3 laps each on FFVIII Circuit.",
    id = 83575, badge = "90665", published = "16/09/2019 02:24:23", modified = "22/10/2019 20:51:01",
    trigger = never(byte(0x07AE38) != 5) && byte(0x07AE36) == 9 && byte(0x096868) == 3 && never(byte(0x096868) == 26) &&
              byte(0x07AE3C) == 9 && once(byte(0x0084D2) == 6)
)

achievement(
    title = "Chocobo Grand Prix", points = 5,
    description = "Win the Grand Prix as Chocobo and unlock the GP Chocobo Movie.",
    id = 83605, badge = "90762", published = "16/09/2019 18:00:20", modified = "25/04/2022 01:59:22",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit3(0x1E9298) > prev(bit3(0x1E9298))
)

achievement(
    title = "Mog Grand Prix", points = 5,
    description = "Win the Grand Prix as Mog and unlock the GP Mog Movie.",
    id = 83606, badge = "90763", published = "16/09/2019 18:00:23", modified = "25/04/2022 01:59:25",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit4(0x1E9298) > prev(bit4(0x1E9298))
)

achievement(
    title = "Goblin Grand Prix", points = 5,
    description = "Win the Grand Prix as Goblin and unlock the GP Goblin Movie.",
    id = 83607, badge = "90764", published = "16/09/2019 18:00:26", modified = "25/04/2022 01:59:24",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit5(0x1E9298) > prev(bit5(0x1E9298))
)

achievement(
    title = "White Mage Grand Prix", points = 5,
    description = "Win the Grand Prix as White Mage and unlock the GP White Mage Movie.",
    id = 83608, badge = "90765", published = "16/09/2019 18:00:28", modified = "25/04/2022 01:59:28",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit6(0x1E9298) > prev(bit6(0x1E9298))
)

achievement(
    title = "Black Magician Grand Prix", points = 5,
    description = "Win the Grand Prix as Black Magician and unlock the GP Black Magician Movie.",
    id = 83609, badge = "90766", published = "16/09/2019 18:00:32", modified = "25/04/2022 01:59:21",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit7(0x1E9298) > prev(bit7(0x1E9298))
)

achievement(
    title = "Chubby Chocobo Grand Prix", points = 5,
    description = "Win the Grand Prix as Chubby Chocobo and unlock the GP Chubby Chocobo Movie.",
    id = 83610, badge = "90767", published = "16/09/2019 18:00:35", modified = "25/04/2022 01:59:22",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit0(0x1E9299) > prev(bit0(0x1E9299))
)

achievement(
    title = "Behemoth Grand Prix", points = 5,
    description = "Win the Grand Prix as Behemoth and unlock the GP Behemoth Movie.",
    id = 83611, badge = "90768", published = "16/09/2019 18:00:37", modified = "25/04/2022 01:59:21",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit1(0x1E9299) > prev(bit1(0x1E9299))
)

achievement(
    title = "Golem Grand Prix", points = 5,
    description = "Win the Grand Prix as Golem and unlock the GP Golem Movie.",
    id = 83612, badge = "90769", published = "16/09/2019 18:00:40", modified = "25/04/2022 01:59:24",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit2(0x1E9299) > prev(bit2(0x1E9299))
)

achievement(
    title = "Bahamut Grand Prix", points = 5,
    description = "Win the Grand Prix as Bahamut and unlock the GP Bahamut Movie.",
    id = 83613, badge = "90770", published = "16/09/2019 18:00:43", modified = "25/04/2022 01:59:20",
    trigger = unless(byte(0x08C028) == 0) && unless(byte(0x096868) == 0) && bit3(0x1E9299) > prev(bit3(0x1E9299))
)

achievement(
    title = "Gunblade Specialist", points = 5,
    description = "Win Squall's challenge and unlock him!",
    id = 83614, badge = "90752", published = "16/09/2019 18:00:46", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x096868) != 3) && bit1(0x1E929D) > prev(bit1(0x1E929D))
)

achievement(
    title = "Tanking as a Tank", points = 10,
    description = "Unlock Cid Tank as a playable character.",
    id = 83615, badge = "90753", published = "16/09/2019 18:00:56", modified = "25/04/2022 01:59:27",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 0 &&
              byte(0x1EA998) == 1
)

achievement(
    title = "Mumba to the Rescue", points = 10,
    description = "Unlock Mumba as a playable character.",
    id = 83616, badge = "90754", published = "16/09/2019 18:00:59", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 1 &&
              byte(0x1EA998) == 2
)

achievement(
    title = "Now Where's my Remake?", points = 10,
    description = "Unlock Cloud as a playable character.",
    id = 83617, badge = "90755", published = "16/09/2019 18:01:03", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 2 &&
              byte(0x1EA998) == 3
)

achievement(
    title = "1000 Needles", points = 10,
    description = "Unlock Cactuar as a playable character.",
    id = 83618, badge = "90756", published = "16/09/2019 18:01:05", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 3 &&
              byte(0x1EA998) == 4
)

achievement(
    title = "Mitochondria Queen", points = 10,
    description = "Unlock Aya as a playable character.",
    id = 83619, badge = "90757", published = "16/09/2019 18:01:08", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 4 &&
              byte(0x1EA998) == 5
)

achievement(
    title = "8bit Racing", points = 10,
    description = "Unlock Classic Chocobo as a playable character.",
    id = 83620, badge = "90759", published = "16/09/2019 18:01:11", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 5 &&
              byte(0x1EA998) == 6
)

achievement(
    title = "Fly Away", points = 10,
    description = "Unlock S.S Invincible as a playable character.",
    id = 83621, badge = "90760", published = "16/09/2019 18:01:14", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 6 &&
              byte(0x1EA998) == 7
)

achievement(
    title = "Wait, who?", points = 10,
    description = "Unlock Jack as a playable character.",
    id = 83622, badge = "90761", published = "16/09/2019 18:01:17", modified = "22/10/2019 20:51:01",
    trigger = unless(byte(0x08D759) == 0) && unless(byte(0x08D759) == 255) && prev(byte(0x1EA998)) == 7 &&
              byte(0x1EA998) == 8
)

achievement(
    title = "Bronze Trophy", points = 10,
    description = "Win all Bronze Trophies on Grand Prix.",
    id = 83623, badge = "90749", published = "16/09/2019 18:01:20", modified = "25/04/2022 01:59:21",
    trigger = unless(prev(byte(0x1E9290)) == 0) && unless(prev(byte(0x1E9291)) == 0) && byte(0x1E9290) == 255 &&
              bit0(0x1E9291) == 1 && bit1(0x1E9291) == 1 &&
              ((prev(byte(0x1E9290)) != 255) ||
               (prev(bit0(0x1E9291)) != 1) ||
               (prev(bit1(0x1E9291)) != 1))
)

achievement(
    title = "Silver Trophy", points = 10,
    description = "Win all Silver Trophies on Grand Prix.",
    id = 83624, badge = "90750", published = "16/09/2019 18:01:22", modified = "25/04/2022 01:59:26",
    trigger = unless(prev(byte(0x1E9291)) == 0) && unless(prev(byte(0x1E9292)) == 0) && bit2(0x1E9291) == 1 &&
              bit3(0x1E9291) == 1 && bit4(0x1E9291) == 1 && bit5(0x1E9291) == 1 && bit6(0x1E9291) == 1 &&
              bit7(0x1E9291) == 1 && bit0(0x1E9292) == 1 && bit1(0x1E9292) == 1 && bit2(0x1E9292) == 1 &&
              bit3(0x1E9292) == 1 &&
              ((prev(byte(0x1E9291)) < 252) ||
               (prev(bit0(0x1E9292)) != 1) ||
               (prev(bit1(0x1E9292)) != 1) ||
               (prev(bit2(0x1E9292)) != 1) ||
               (prev(bit3(0x1E9292)) != 1))
)

achievement(
    title = "Gold Trophy", points = 10,
    description = "Win all Gold Trophies on Grand Prix and Unlock Mirror Mode.",
    id = 83625, badge = "90751", published = "16/09/2019 18:01:25", modified = "25/04/2022 01:59:24",
    trigger = unless(prev(byte(0x1E9292)) == 0) && unless(prev(byte(0x1E9293)) == 0) && bit4(0x1E9292) == 1 &&
              bit5(0x1E9292) == 1 && bit6(0x1E9292) == 1 && bit7(0x1E9292) == 1 && bit0(0x1E9293) == 1 &&
              bit1(0x1E9293) == 1 && bit2(0x1E9293) == 1 && bit3(0x1E9293) == 1 && bit4(0x1E9293) == 1 &&
              bit5(0x1E9293) == 1 &&
              ((prev(byte(0x1E9292)) < 240) ||
               (prev(bit0(0x1E9293)) != 1) ||
               (prev(bit1(0x1E9293)) != 1) ||
               (prev(bit2(0x1E9293)) != 1) ||
               (prev(bit3(0x1E9293)) != 1) ||
               (prev(bit4(0x1E9293)) != 1) ||
               (prev(bit5(0x1E9293)) != 1))
)



// RP

rich_presence_conditional_display(on_title_screen() || in_demo(), "On the Title Screen")
rich_presence_conditional_display(in_main_menu() || !in_race(), "In the Main Menu")

rp_adjusted_mode_map = {
    0x01: "in Story Mode",
    0x02: "in a Time Attack",
    0x03: "in a Grand Prix",
    0x04: "in a VS Race",
    0x05: "in a Relay Race",
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

rich_presence_conditional_display(in_race() && playing_solo(), "{0} is {1} {2}",
    rich_presence_lookup("Player", p1_char, character_map, fallback="An unknown character"),
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
