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

function check_if_matching_cutscene_is_played(cutscene_ident) {
    to_check = cutscene_map[cutscene_ident]

    current_offset = 0x00
    cond = always_true()

    for element in to_check {
        cond = cond && ptr(dword(0x22cac0), [0x00 + current_offset], dword) == element
        current_offset = current_offset + 0x04
    }

    return cond
}

cutscene_map = {
    "TUTORIAL": [0x50414843],
    "NEXT_STAGE": [0x5458454e]
}

cond_in_unlock_cutscene = check_if_matching_cutscene_is_played("NEXT_STAGE")

function watching_tutorial() {
    return check_if_matching_cutscene_is_played("TUTORIAL")
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

difficulty_map = {
    0x00: "Easy",
    0x01: "Normal",
    0x02: "Hard"
}

table_map = {
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

obj_data = {
    "Biology": {
        "objectives": [
            {
                "type": "red",
                "ident": "Freeze Over",
                "title": "Butterfly Effect",
                "desc_post": "hitting all bumpers in the butterfly area thrice",
                "score": 0,
            }
        ],
        "total": 1, // 20
        // "red": 3,
        // "yellow": 17,
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

function obj_type_to_ach_type(obj_type) {
    if (obj_type == "red") {
        return "progression"
    } else {
        return ""
    }
}

for table in obj_data {
    for objective_count in range(0, obj_data[table]["total"] - 1, 1) {
        objective = obj_data[table]["objectives"][0]

        target_adr_1 = obj_data[table]["start_1"] + objective_count
        target_adr_2 = obj_data[table]["start_2"] + objective_count



        achievement(
            title = objective["title"],
            points = objective["score"],
            type = obj_type_to_ach_type(objective["type"]),
            description = format("On {0}, complete \"{1}\" by {2}", table, objective["ident"], objective["desc_post"]),
            trigger = 
                bit0(target_adr_1) == 1 && prev(bit0(target_adr_1) == 0) || bit0(target_adr_2) == 1 && prev(bit0(target_adr_2) == 0)
        )
    }
}


// Trigger rules:
// For the Zero Gravity goal, trigger on unlock cutscene (since its the last one)
// Also have achievement for defeating boss (tie to the mission flag)

// Bonus for hitting 100 bumpers in a life
// 25 lane counts

// optics multiball has no super jackpot
// optics multiball with match three colors always wins after time


rich_presence_conditional_display(watching_tutorial(), "Learning how to enjoy Flipnic")

rich_presence_conditional_display(in_original_mode() && !in_main_menu(), "In Original Mode • {0} • Score: {2} • Balls: {3}",
    rich_presence_lookup("Table", get_original_mode_table(), table_map, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty"),
    rich_presence_value("Score", get_score(), "POINTS"),
    rich_presence_value("Balls", get_balls(), "VALUE")
)

rich_presence_conditional_display(in_free_play_mode() && !in_main_menu(), "In Free Play • {0} • Score: {2} • Balls: {3}",
    rich_presence_lookup("Table", get_free_play_table(), table_map, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty"),
    rich_presence_value("Score", get_score(), "POINTS"),
    rich_presence_value("Balls", get_balls(), "VALUE")
)

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

rich_presence_display("Playing Flipnic")