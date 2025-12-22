// Flipnic: Ultimate Pinball
// #ID = 24189

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

function in_main_menu() {
    return dword(0x002b2e54) == 0x00
}

function check_if_no_cutscene_playing() {
    return dword(0x22cac0) == 0x00
}

function check_if_matching_cutscene_is_playing(cutscene_ident) {
    to_check = cutscene_map[cutscene_ident]

    current_offset = 0x00
    cond = always_true()

    for element in to_check {
        return ptr(dword(0x22cac0), [0x00], dword) == element
        current_offset = current_offset + 0x04
    }

    return cond
}

cutscene_map = {
    "TUTORIAL": [0x50414843],
    "NEXT_STAGE": [0x5458454e],
    "CREDITS": [0x46415453, 0x4f525f46],
    "GAME_OVER": [0x454d4147],
    "BIOLOGY_OPENING": [0x564c4953]
}

function watching_tutorial() {
    return check_if_matching_cutscene_is_playing("TUTORIAL")
}

function game_is_now_over() {
    return check_if_matching_cutscene_is_playing("GAME_OVER") && prev(check_if_no_cutscene_playing())
}

function stage_unlock_cutscene_done() {
    return cond_in_unlock_cutscene && prev(!cond_in_unlock_cutscene)
}

function in_original_mode() {
    return dword(0x0036f568) == 0x00
}

function in_free_play_mode() {
    return dword(0x0036f568) == 0x01
}

function get_free_play_table() {
    return dword(0x0036f930) * 10 + dword(0x0036f938)
}

function get_original_mode_table() {
    return dword(0x0036f570) * 10 + dword(0x0036f578)
}

function get_difficulty() {
    return dword(0x00449280)
}

function get_score() {
    return dword(0x00449268)
}

function get_balls() {
    return dword(0x00449334)
}

function get_combo() {
    return dword(0x449284)
}

function get_exp() {
    return dword(0x449288)
}

function get_total_lanes() {
    return dword(0x449290)
}

function get_total_bumpers() {
    return dword(0x44928c)
}

function get_time_remaining_time_attack() {
    return ptr(dword(0x0022cb58), [0x69c], dword)
}

function check_if_time_set_time_attack() {
    return ptr(dword(0x0022cb58), [0x69c], dword) != 0x00
}

// function in_time_attack() {
//     return dword(0x0040775c) == 0x01
// }

difficulty_map = {
    0x00: "Easy",
    0x01: "Normal",
    0x02: "Hard"
}

table_map_og = {
    00: "Biology A",
    01: "Evolution A",
    02: "Biology B",
    10: "Metallurgy A",
    11: "Evolution B",
    12: "Metallurgy B",
    20: "Optics A",
    21: "Evolution C",
    22: "Optics B",
    30: "Geometry A",
    31: "Evolution D"
}

table_map_free = {
    00: "Biology A",
    01: "Biology B",
    02: "Biology 2P",
    10: "Metallurgy A",
    11: "Metallurgy B",
    12: "Metallurgy 2P",
    20: "Optics A",
    21: "Optics B",
    22: "Optics 2P",
    30: "Geometry A",
    32: "Geometry 2P"
}

obj_data = {
    "Biology": {
        "objectives": [
            {
                "type": "progression",
                "ident": "Freeze Over",
                "title": "Butterfly Effect",
                "desc_post": "hitting all bumpers in the butterfly area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Hidden Path Discovery",
                "title": "Quite the Breakthrough",
                "desc_post": "smashing into the frozen waterfall",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Zero Gravity",
                "title": "Knockout!",
                "desc_post": "knocking over the figure in space",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Circle of Life",
                "title": "It Gets Around",
                "desc_post": "hitting the tower bumpers in the Multiball area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Bumper Village",
                "title": "Ups and Downs",
                "desc_post": "hitting all bumpers with arrows in the river area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Perfect Bumper Village",
                "title": "Actually, Mostly Just Downs",
                "desc_post": "hitting all bumpers with yellow arrow plates in the river area",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Lucky Flamingos",
                "title": "It's Called a Flamboyance",
                "desc_post": "matching the slots and collecting all stars during the Flamingo minigame",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Hungry Monkey",
                "title": "Dinner Is Served",
                "desc_post": "matching the slots and collecting bananas using the monkey during the Monkey minigame",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Color Puzzle",
                "title": "Bingo!",
                "desc_post": "matching the slots and scoring Bingos during the Color Puzzle minigame",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Money Money Money",
                "title": "Payday",
                "desc_post": "matching the slots to summon coins",
                "score": 5,
            },
            {
                "type": "",
                "ident": "UFO Quiz Show",
                "title": "Trivia from Outher Space",
                "desc_post": "matching the slots and correctly counting the amount of UFOs thrice during the Quiz Show minigame",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Multiball 1",
                "title": "Jacks Open",
                "desc_post": "scoring a Super Jackpot during the initial Multiball event",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Multiball 2",
                "title": "Pistol Poker",
                "desc_post": "scoring a Super Jackpot during a manually triggered Multiball event",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 1",
                "title": "Waterfall Showcase",
                "desc_post": "landing the ball multiple times in the secret lane in the waterfall area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 2",
                "title": "To Better Places",
                "desc_post": "landing the ball multiple times on the silver ramp lane in the Multiball area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 3",
                "title": "To Other, Equally Good Places",
                "desc_post": "landing the ball multiple times on the golden ramp lane in the Multiball area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Total Lane Counts",
                "title": "Jungle Lane Champion",
                "desc_post": "traveling through lanes multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Total Bumper Counts",
                "title": "Jungle Bumper Champion",
                "desc_post": "hitting bumpers multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Ball",
                "title": "Safeguarding",
                "desc_post": "hitting the blue UFO",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Credit",
                "title": "Security Deposit",
                "desc_post": "hitting the golden UFO",
                "score": 5,
            }
        ],
        "total": 20,
        "table_ids_og": [00, 02],
        "table_ids_fp": [00, 01],
        "start_1": 0x448f9c,
        "start_2": 0x44905c
    },
    "Metallurgy": {
        "objectives": [
            {
                "type": "progression",
                "ident": "Move On 1",
                "title": "On the Run",
                "desc_post": "hitting the first blocked door multiple times in the UFO area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Move On 2",
                "title": "On the Run Again",
                "desc_post": "hitting the second blocked door multiple times in the UFO area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Spider Crab Shoot-Down",
                "title": "Tank Stance",
                "desc_post": "destroying the giant Spider Crab",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Stop the Four Shafts 1",
                "title": "Power Drain",
                "desc_post": "deactivating the first set of shafts in the space area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Stop the Four Shafts 2",
                "title": "Batteries Empty",
                "desc_post": "deactivating the second set of shafts in the space area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Zero Gravity",
                "title": "Have We Met Before?",
                "desc_post": "knocking over the figure in space",
                "score": 5,
            },
            {
                "type": "",
                "ident": "UFO Shoot-Down",
                "title": "A Moment of Revenge",
                "desc_post": "shooting down 10 UFOs in the UFO area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Crab Baby Shoot-Down",
                "title": "Crab and Go",
                "desc_post": "shooting down 10 Crab Baby formations in the Spider Crab area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Multiball 1",
                "title": "Big Money",
                "desc_post": "scoring a Super Jackpot during the Multiball event in the first UFO area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Multiball 2",
                "title": "Bigger Money",
                "desc_post": "scoring a Super Jackpot during the Multiball event in the second UFO area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Multiball 2",
                "title": "Too Rich to Fail",
                "desc_post": "engaging in the Multiball event in the Spider Crab area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 1",
                "title": "You Can Count on Me!",
                "desc_post": "landing the ball multiple times on the silver ramp lane in the first UFO area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 2",
                "title": "Actually, I Lost Count",
                "desc_post": "landing the ball multiple times in the lane between the bumpers in the second UFO area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Total Lane Counts",
                "title": "Construction Lane Champion",
                "desc_post": "traveling through lanes multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Total Bumper Counts",
                "title": "Construction Bumper Champion",
                "desc_post": "hitting bumpers multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Ball",
                "title": "Protection Barrier",
                "desc_post": "hitting the blue UFO",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Credit",
                "title": "Insurance",
                "desc_post": "hitting the golden UFO",
                "score": 5,
            }
        ],
        "total": 17,
        "table_ids_og": [10, 12],
        "table_ids_fp": [10, 11],
        "start_1": 0x448fdc,
        "start_2": 0x44907c
    },
    "Optics": {
        "objectives": [
            {
                "type": "progression",
                "ident": "Point of No Return 1",
                "title": "Quite the Switchup",
                "desc_post": "passing through the colored rings to collect the five colors",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Point of No Return 2",
                "title": "The Matching Game",
                "desc_post": "passing through the colored rings to collect the five colors",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Point of No Return 3",
                "title": "Same Ain't Lame",
                "desc_post": "passing through red rings multiple times",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Multiball 1",
                "title": "Bumpin'",
                "desc_post": "hitting the bumpers in the upper area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Multiball 2",
                "title": "A Perfect Match",
                "desc_post": "matching the colors of the the bumpers in the upper area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Multiball 3",
                "title": "Seeing Red",
                "desc_post": "hitting the red bumpers in the upper area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Zero Gravity",
                "title": "Okay, I'm Pretty Sure I Know You",
                "desc_post": "knocking over the figure in space",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Loop The Loop 1",
                "title": "A Neverending Back and Fourth",
                "desc_post": "hitting the bumper at the end of the loop",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Loop The Loop 2",
                "title": "A Return to Form",
                "desc_post": "hitting the bumper at the end of the loop again",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Loop The Loop 3",
                "title": "It's Not Actually Endless, Is It?",
                "desc_post": "hitting the bumper at the end of the loop yet again",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Bumper Village",
                "title": "Could Call It a Civilisation",
                "desc_post": "hitting all bumpers with arrows in the bumper area",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Perfect Bumper Village",
                "title": "Explored It All",
                "desc_post": "hitting all bumpers with yellow arrow plates in the river area",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Total Lane Counts",
                "title": "Hue Lane Champion",
                "desc_post": "traveling through lanes multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Total Bumper Counts",
                "title": "Hue Bumper Champion",
                "desc_post": "hitting bumpers multiple times",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Ball",
                "title": "Iron Shield",
                "desc_post": "hitting the blue UFO",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Credit",
                "title": "Warranty Provided",
                "desc_post": "hitting the golden UFO",
                "score": 5,
            }
        ],
        "total": 16,
        "table_ids_og": [20, 22],
        "table_ids_fp": [20, 21],
        "start_1": 0x44901c,
        "start_2": 0x44909c
    }
}

obj_solo_data = {
    "Geometry": {
        "objectives": [
            {
                "type": "progression",
                "ident": "Space Warp",
                "title": "Tunnel Vision",
                "desc_post": "collecting all red keys",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Alien Hill",
                "title": "A Steady Ascent",
                "desc_post": "collecting the blue flag, then reaching the top of the area",
                "score": 5,
            },
            {
                "type": "progression",
                "ident": "Area 74",
                "title": "Unidentified Flying Obliteration",
                "desc_post": "destroying all UFOs",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Galaxy Tennis",
                "title": "In Space No One Can Hear You Play Tennis",
                "desc_post": "winning at Space Tennis",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Chu Chu Multiball",
                "title": "Mouse Mania",
                "desc_post": "earning a Super Jackpot during the Multiball event",
                "score": 5,
            },
            {
                "type": "",
                "ident": "100 Blocks",
                "title": "Blocklist",
                "desc_post": "clearing all 100 blocks",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Warm-colored Blocks",
                "title": "Now in Color!",
                "desc_post": "clearing all warm-colored blocks",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Ball",
                "title": "Heart Container",
                "desc_post": "hitting the blue UFO",
                "score": 5,
            },
            {
                "type": "",
                "ident": "Extra Credit",
                "title": "Collateral Collection",
                "desc_post": "hitting the golden UFO",
                "score": 5,
            }
        ],
        "total": 9,
        "table_ids_og": [30],
        "table_ids_fp": [30],
        "start_1": 0x4490bc,
        "start_2": 0x00 // todo
    }
}

// Objective achievements
for table in obj_data {
    for objective_count in range(0, obj_data[table]["total"] - 1, 1) {
        objective = obj_data[table]["objectives"][objective_count]

        target_adr_1 = obj_data[table]["start_1"] + objective_count
        target_adr_2 = obj_data[table]["start_2"] + objective_count

        achievement(
            title = objective["title"],
            points = objective["score"],
            type = objective["type"],
            description = format("On {0}, complete \"{1}\" by {2}", table, objective["ident"], objective["desc_post"]),
            trigger = 
                // original mode
                (
                    in_original_mode() &&
                    (
                        get_original_mode_table() == obj_data[table]["table_ids_og"][0] &&
                        bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0)
                        ||
                        get_original_mode_table() == obj_data[table]["table_ids_og"][1] &&
                        bit1(target_adr_2) == 1 && prev(bit1(target_adr_2) == 0)
                    )
                ) ||
                // free play
                (
                    in_free_play_mode() &&
                    (
                        get_free_play_table() == obj_data[table]["table_ids_fp"][0] &&
                        bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0)
                        ||
                        get_free_play_table() == obj_data[table]["table_ids_fp"][1] &&
                        bit1(target_adr_2) == 1 && prev(bit1(target_adr_2) == 0)
                    )
                )
                
        )
    }
}

// Geometry has its own object:
for objective_count in range(0, obj_solo_data["Geometry"]["total"] - 1, 1) {
    objective = obj_solo_data["Geometry"]["objectives"][objective_count]

    target_adr_1 = obj_solo_data["Geometry"]["start_1"] + objective_count
    target_adr_2 = obj_solo_data["Geometry"]["start_2"] + objective_count

    achievement(
        title = objective["title"],
        points = objective["score"],
        type = objective["type"],
        description = format("On {0}, complete \"{1}\" by {2}", "Geometry", objective["ident"], objective["desc_post"]),
        trigger = 
            // original mode
            (
                in_original_mode() &&
                (
                    get_original_mode_table() == obj_solo_data["Geometry"]["table_ids_og"][0] &&
                    bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0)
                )
            ) ||
            // free play
            (
                in_free_play_mode() &&
                (
                    get_free_play_table() == obj_solo_data["Geometry"]["table_ids_fp"][0] &&
                    bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0)
                )
            )
            
    )
}

achievement(
    title = "Jungle Tour",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Biology A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 00 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "Is That a Skull?",
    points = 5,
    type = "progression",
    description = format("In Original Mode on {0}, defeat the being in space and unlock the next table", "Evolution A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 01 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "Star Wars",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Metallurgy A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 10 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "I Think I've Been Here Before",
    points = 5,
    type = "progression",
    description = format("In Original Mode on {0}, defeat the being in space and unlock the next table", "Evolution B"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 11 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "Lights Out",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Optics A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 20 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "Program Rerun",
    points = 5,
    type = "progression",
    description = format("In Original Mode on {0}, defeat the being in space and unlock the next table", "Evolution C"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 21 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

// stage reruns
achievement(
    title = "The Wicked Wild",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Biology B"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 02 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "The Long-Awaited Sequel",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Metallurgy B"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 12 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "Color Shift",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Optics B"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 22 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

achievement(
    title = "The Ultimate Game",
    points = 10,
    type = "progression",
    description = format("In Original Mode on {0}, complete the main objectives and unlock the next table", "Geometry A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 30 &&
        // trigger as cutscene ends
        prev(check_if_matching_cutscene_is_playing("NEXT_STAGE")) && check_if_no_cutscene_playing()
)

// Table clear final boss (on credits)
achievement(
    title = "An Enjoyable Simple-Action Amazing Boss Fight for You",
    points = 25,
    type = "win_condition",
    description = format("In Original Mode on {0}, defeat the final boss", "Evolution D"),
    trigger = 
        in_main_menu() &&
        get_original_mode_table() == 31 &&
        // trigger as cutscene BEGINS
        check_if_matching_cutscene_is_playing("CREDITS") && prev(check_if_no_cutscene_playing())
)

// Standalone achievements
//achievement(
//    title = "Multiplication Station",
//    points = 10,
//    type = "",
//    description = "In Original Mode or Free Play, collect 1000 EXP to increase the base point multiplier",
//    trigger = 
//        (
//            in_original_mode() || in_free_play_mode()
//        ) &&
//        get_exp() == 1000 && prev(get_exp() < 1000)
//)

// Leaderboards

// Base tables
table_names = ["Biology", "Metallurgy", "Optics"]
table_ids = {
    "Biology": [00, 01],
    "Metallurgy": [10, 11],
    "Optics": [20, 21]
}
leeway_in_frames = 500

for table in table_names {
    leaderboard(
        title = format("{0} Score Attack", table),
        description = format("Score as many points as possible on {0} A or B on Normal difficulty or higher!", table),
        start = 
        (
            (
                get_free_play_table() == table_ids[table][0] || get_free_play_table() == table_ids[table][1]
            ) &&
            in_free_play_mode() &&
            game_is_now_over() &&
            // normal or hard
            get_difficulty() > 0 &&
            // Score Attack - so the timer may never go above 0
            disable_when(repeated(leeway_in_frames, check_if_time_set_time_attack()), until=in_main_menu())
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_score()
        ),
        format = "SCORE", lower_is_better = false
    )

    leaderboard(
        title = format("{0} Time Attack", table),
        description = format("Score as many points as possible on {0} A or B on Normal difficulty or higher before time runs out!", table),
        start = 
        (
            (
                get_free_play_table() == table_ids[table][0] || get_free_play_table() == table_ids[table][1]
            ) &&
            in_free_play_mode() &&
            game_is_now_over() &&
            // normal or hard
            get_difficulty() > 0 &&
            // Time attack - cheeky solution: If there has been a time limit it must be a Time Attack - so collect a hit until a reset
            disable_when(repeated(leeway_in_frames, !check_if_time_set_time_attack()), until=in_main_menu())
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_time_remaining_time_attack()
        ),
        format = "SCORE", lower_is_better = false
    )
}

// Geometry
leaderboard(
    title = format("{0} Score Attack", "Geometry"),
    description = format("Score as many points as possible on {0} A on Normal difficulty or higher!", "Geometry"),
    start = 
    (
        (
            get_free_play_table() == 30
        ) &&
        in_free_play_mode() &&
        game_is_now_over() &&
        // normal or hard
        get_difficulty() > 0 &&
        // Score Attack - so the timer may never go above 0
        disable_when(repeated(leeway_in_frames, check_if_time_set_time_attack()), until=in_main_menu())
    ),
    cancel = always_false(),
    submit = always_true(),
    value =
    measured(
        get_score()
    ),
    format = "SCORE", lower_is_better = false
)

leaderboard(
        title = format("{0} Time Attack", "Geometry"),
        description = format("Score as many points as possible on {0} A or B on Normal difficulty or higher before time runs out!", "Geometry"),
        start = 
        (
            (
                get_free_play_table() == 30
            ) &&
            in_free_play_mode() &&
            game_is_now_over() &&
            // normal or hard
            get_difficulty() > 0 &&
            // Time attack - cheeky solution: If there has been a time limit it must be a Time Attack - so collect a hit until a reset
            disable_when(repeated(leeway_in_frames, !check_if_time_set_time_attack()), until=in_main_menu())
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_time_remaining_time_attack()
        ),
        format = "SCORE", lower_is_better = false
    )

// RP

rich_presence_conditional_display(watching_tutorial(), "Learning how to enjoy Flipnic")

rich_presence_conditional_display(in_original_mode() && !in_main_menu(), "In Original Mode • {0} • Score: {2} • Balls: {3}",
    rich_presence_lookup("Table OG", get_original_mode_table(), table_map_og, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty"),
    rich_presence_value("Score", get_score(), "POINTS"),
    rich_presence_value("Balls", get_balls(), "VALUE")
)

rich_presence_conditional_display(in_free_play_mode() && !in_main_menu(), "In Free Play • {0} • Score: {2} • Balls: {3}",
    rich_presence_lookup("Table FP", get_free_play_table(), table_map_free, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty"),
    rich_presence_value("Score", get_score(), "POINTS"),
    rich_presence_value("Balls", get_balls(), "VALUE")
)

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

rich_presence_display("Playing Flipnic")