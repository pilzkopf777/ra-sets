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
    "CREDITS": [0x00] // todo
}

function watching_tutorial() {
    return check_if_matching_cutscene_is_playing("TUTORIAL")
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
    00: "test"
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
                "score": 3,
            },
            {
                "type": "",
                "ident": "Zero Gravity",
                "title": "Knockout!",
                "desc_post": "knocking over the figure in space",
                "score": 3,
            },
            {
                "type": "",
                "ident": "Circle of Life",
                "title": "It Gets Around",
                "desc_post": "hitting the XXXX in the Multiball area",
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
                "title": "Actually, Mostly just Downs",
                "desc_post": "hitting all bumpers with yellow arrow plates in the river area",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Lucky Flamingos",
                "title": "It's called a Flamboyance",
                "desc_post": "matching the slots and collecting all stars during the flamingo minigame",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Hungry Monkey",
                "title": "Dinner is Served",
                "desc_post": "matching the slots and collecting bananas using the monkey during the monkey minigame",
                "score": 10,
            },
            {
                "type": "",
                "ident": "Color Puzzle",
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Money Money Money",
                "title": "Payday",
                "desc_post": "matching the slots to summon coins",
                "score": 3,
            },
            {
                "type": "",
                "ident": "UFO Quiz Show",
                "title": "Trivia from Outher Space",
                "desc_post": "matching the slots and correctly counting the amount of UFOs during the quiz show minigame",
                "score": 3,
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
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 2",
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Lane Count Mission 3",
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Total Lane Counts",
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Total Bumper Counts",
                "title": "???",
                "desc_post": "???",
                "score": 0,
            },
            {
                "type": "",
                "ident": "Extra Ball",
                "title": "Safeguarding",
                "desc_post": "hitting the blue UFO",
                "score": 3,
            },
            {
                "type": "",
                "ident": "Extra Credit",
                "title": "Security Deposit",
                "desc_post": "hitting the golden UFO",
                "score": 3,
            }
        ],
        "total": 20,
        "table_ids": [00, 02],
        "start_1": 0x448f9c,
        "start_2": 0x44905c
    },
   // "Metallurgy": {
   //     "red": 6,
   //     "yellow": 11,
   //     "start_1": 0x448fdc,
   //     "start_2": 0x44907c
   // },
   // "Optics": {
   //     "red": 7,
   //     "yellow": 9,
   //     "start_1": 0x44901c,
   //     "start_2": 0x44909c
   // }
}

// obj_solo_data = {
//     "Geometry": {
//         "red": 4,
//         "yellow": 5,
//         "start": 0x4490bc // no second version exists
//     }
// }

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
                    get_original_mode_table() == obj_data[table]["table_ids"][0] &&
                    (
                        bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0) || bit1(target_adr_2) == 1 && prev(bit1(target_adr_2) == 0)
                    )
                ) ||
                // free play
                (
                    in_free_play_mode() &&
                    get_free_play_table() == obj_data[table]["table_ids"][1] &&
                    (
                        bit1(target_adr_1) == 1 && prev(bit1(target_adr_1) == 0) || bit1(target_adr_2) == 1 && prev(bit1(target_adr_2) == 0)
                    )
                )
                
        )
    }
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
)

achievement(
    title = "Is that a Skull?",
    points = 5,
    type = "progression",
    description = format("In Original Mode on {0}, defeat the being in space and unlock the next table", "Evolution A"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 01 &&
        // trigger as cutscene ends
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
)

achievement(
    title = "I think I've been here before",
    points = 5,
    type = "progression",
    description = format("In Original Mode on {0}, defeat the being in space and unlock the next table", "Evolution B"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 11 &&
        // trigger as cutscene ends
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
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
        check_if_matching_cutscene_is_playing("NEXT_STAGE") && prev(check_if_no_cutscene_playing())
)

// Table clear final boss (on credits)
achievement(
    title = "An Enjoyable Simple-Action Amazing Boss Fight for You",
    points = 25,
    type = "win_condition",
    description = format("In Original Mode on {0}, defeat the final boss", "Evolution D"),
    trigger = 
        in_original_mode() &&
        get_original_mode_table() == 31 &&
        // trigger as cutscene ends
        check_if_matching_cutscene_is_playing("CREDITS") && prev(check_if_no_cutscene_playing())
)

// Standalone achievements
achievement(
    title = "Multiplication Station",
    points = 10,
    type = "",
    description = "In Original Mode or Free Play, collect 1000 EXP to increase the base point multiplier",
    trigger = 
        (
            in_original_mode() || in_free_play_mode()
        ) &&
        get_exp() == 1000 && prev(get_exp() < 1000)
)

achievement(
    title = "Bump and Grind",
    points = 10,
    type = "",
    description = "In Original Mode or Free Play, hit bumpers 100 times to earn a score bonus",
    trigger = 
        (
            in_original_mode() || in_free_play_mode()
        ) &&
        get_total_bumpers() == 100 && prev(get_total_bumpers() < 100)
)

achievement(
    title = "The Long Road",
    points = 10,
    type = "",
    description = "In Original Mode or Free Play, travel through area lanes 25 times to earn a score bonus",
    trigger = 
        (
            in_original_mode() || in_free_play_mode()
        ) &&
        get_total_lanes() == 25 && prev(get_total_lanes() < 25)
)


// optics multiball has no super jackpot
// optics multiball with match three colors always wins after time


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