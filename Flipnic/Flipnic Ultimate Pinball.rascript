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


rich_presence_conditional_display(watching_tutorial(), "Learning how to enjoy Flipnic")

rich_presence_conditional_display(in_original_mode() && !in_main_menu(), "In the Original Mode • {0} • {1}",
    rich_presence_lookup("Table", get_original_mode_table(), table_map, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty")
)

rich_presence_conditional_display(in_free_play_mode() && !in_main_menu(), "In Free Play • {0} • {1}",
    rich_presence_lookup("Table", get_free_play_table(), table_map, fallback="Unknown table"),
    rich_presence_lookup("Difficulty", get_difficulty(), difficulty_map, fallback="Unknown difficulty")
)

rich_presence_conditional_display(in_main_menu(), "In the Main Menu")

rich_presence_display("Playing Flipnic")