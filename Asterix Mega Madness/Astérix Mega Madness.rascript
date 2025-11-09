// Astérix: Mega Madness
// #ID = 18223

// Helper function taken from Souzooka - thanks!
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

function is_paused() {
    return byte(0x06af60) == 0x02
}

function in_game_timer_tick() {
    return dword(0x057C6C) > prev(dword(0x057C6C))
}

function in_game_timer_tick_while_unpaused_only() {
    return dword(0x057C6C) > prev(dword(0x057C6C)) && !is_paused()
}

function get_minigame() {
    current_mg_index = dword(0x1fef70)
    offset = 0x04 * current_mg_index - 0x04
    target_adr = 0x1fef34 + offset

    return dword(target_adr)
}

function get_minigame_string() {
    get_minigame()
}

function get_mega_madness_day() {
    return byte(0x1fef74) + 1
}

function countdown_ended() {
    return dword(0x06b028) == 0 && prev(dword(0x06b028)) > 0
}

function countdown_starting_again() {
    return dword(0x06b028) == 0x7fffffff && prev(dword(0x06b028)) != 0x7fffffff
}

function tutorial_on_screen() {
    return dword(0x06b074) == 0x00
}

function tutorial_just_popped_up() {
    return dword(0x06b074) == 0x00 && prev(dword(0x06b074)) == 0x01
}

minigame_lookup = {
    0x0b: "Shoot & Score",
    0x00: "Recipe Run",
    0x07: "Food Feast",
    0x02: "Boar Bash",
    0x03: "Shield Chase",
    0x08: "Camp Crashing",
    0x06: "Catapult Chase",
    0x04: "Helmet Hoarding",
    0x01: "Rowing Race",
    0x05: "Shield Bash",
    0x0a: "Hide & Seek",
    0x09: "Galley Smash",
    0x0d: "Obstacle Course",
    0x0c: "Shoot to Survive",
}

function is_in_main_menu() {
    // Main Menu, Boot-up, Transition bewteen modes..
    return byte(0x0760C0) == 0x17 || byte(0x0760C0) == 0x00 || byte(0x0760C0) == 0xbe //|| dword(0x090a1c) == 0
}

function is_in_mega_madness() {
    return byte(0x1fef76) == 0x01
}

mode_lookup = {
    0x01: "Mega Madness",
    0x00: "Practice",
    0x02: "Team Play"
}

// Day = 1 - 4
// Round = 1 - 4
// Character = String
function get_mega_madness_score(day, round, character) {
    base = 0x071CA0

    if (character == "Asterix") {
        character_offset = 0x00
    } else if (character == "Obelix") {
        character_offset = 0x04
    } else if (character == "Cacofonix") {
        character_offset = 0x08
    } else if (character == "Mrs Geriatrix") {
        character_offset = 0x0c
    }

    t_day = day - 1
    day_offset = 0x40 * t_day
    t_round = round - 1
    round_offset = 0x10 * t_round

    final = base + day_offset + round_offset + character_offset

    return dword(final)
}

function get_mega_madness_score_of_day(day, character) {
    if (day == 1 || day == 2) {
        return get_mega_madness_score(day, 1, character) + get_mega_madness_score(day, 2, character) + get_mega_madness_score(day, 3, character)
    } else if (day == 3 || day == 4) {
        return get_mega_madness_score(day, 1, character) + get_mega_madness_score(day, 2, character) + get_mega_madness_score(day, 3, character) + get_mega_madness_score(day, 4, character)
    }
}

function get_char_id(player) {
    base = 0x1fef14
    offset = player * 0x04 - 0x04
    return dword(base + offset)
}

function get_player_count() {
    return dword(0x1fef24)
}

function entered_black_screen_for_loading() {
    return dword(0x06b4dc) == 0x00 && prev(dword(0x06b4dc)) != 0x00
}

function results_just_popped_up() {
    return dword(0x06b060) == 0x50 && prev(dword(0x06b060)) < 0x50
}

function minigame_not_finished() {
    return dword(0x06b060) == 0x00
}

function in_loading_screen() {
    return dword(0x06a92c) == 0x01
}

function minigame_fully_loaded() {
    return byte(0x06a94d) == 0x01
}

function player_quit_minigame() {
    return byte(0x06a94d) == 0x00 && prev(byte(0x06a94d) == 0x01)
}

function is_in_demo() {
    return dword(0x06a948) == 0x002ee000
}

function is_not_in_demo() {
    return dword(0x06a948) == 0x00
}

ACH_NAME = ["All Warmed Up", "Smashing Performance", "Hot Streak", "Village Champion"]
ACH_PTS  = [5, 5, 10, 10]
ACH_PRG  = ["progression", "progression", "progression", "win_condition"]

DAY_ROUNDS = [3, 3, 4, 4]

function day_victory_logic(day) {
    // day = 1, 2, 3, 4
    cond = always_true()

    char_count = dword(0x1fef24)

    asterix_total = get_mega_madness_score_of_day(day, "Asterix")
    obelix_total = get_mega_madness_score_of_day(day, "Obelix")
    cacofonix_total = get_mega_madness_score_of_day(day, "Cacofonix")
    ms_geriatrix_total = get_mega_madness_score_of_day(day, "Mrs Geriatrix")

    rounds_this_day = DAY_ROUNDS[day - 1]
    
    cond = 
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Single player - check for P1
        get_player_count() <= 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Asterix
        get_char_id(player=1) == 0 &&
        // Asterix has highest score
        // Possible scenarios with this logic:
        // -> If A won, then A=60 and B=50 -> A-B == 60-50=10 -> A_result > 0
        // -> If B won, then A=30 and B=60 -> A-B == 30-60=-30 -> A_result > 0?
        // B won should fail/be false -> Check if left-most bit is 0 == Is result negative? For that logic also check == 0 though 
        asterix_total - obelix_total >= 0 && asterix_total - cacofonix_total >= 0 && asterix_total - ms_geriatrix_total >= 0 &&
        asterix_total - obelix_total < 0x80000000 && asterix_total - cacofonix_total < 0x80000000 && asterix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Single player - check for P1
        get_player_count() <= 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Obelix
        get_char_id(player=1) == 1 &&
        // Obelix has highest score
        obelix_total - asterix_total >= 0 && obelix_total - cacofonix_total >= 0 && obelix_total - ms_geriatrix_total >= 0 &&
        obelix_total - asterix_total < 0x80000000 && obelix_total - cacofonix_total < 0x80000000 && obelix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Single player - check for P1
        get_player_count() <= 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Cacofonix
        get_char_id(player=1) == 2 &&
        // Cacofonix has highest score
        cacofonix_total - asterix_total >= 0 && cacofonix_total - obelix_total >= 0 && cacofonix_total - ms_geriatrix_total >= 0 &&
        cacofonix_total - asterix_total < 0x80000000 && cacofonix_total - obelix_total < 0x80000000 && cacofonix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Single player - check for P1
        get_player_count() <= 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Ms Geriatrix
        get_char_id(player=1) == 3 &&
        // Ms Geriatrix has highest score
        ms_geriatrix_total - asterix_total >= 0 && ms_geriatrix_total - obelix_total >= 0 && ms_geriatrix_total - cacofonix_total >= 0 &&
        ms_geriatrix_total - asterix_total < 0x80000000 && ms_geriatrix_total - obelix_total < 0x80000000 && ms_geriatrix_total - cacofonix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    // But if it's Coop, Player 2 can also win!
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Coop - check for P2
        get_player_count() == 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Asterix
        get_char_id(player=2) == 0 &&
        // Asterix has highest score
        // Possible scenarios with this logic:
        // -> If A won, then A=60 and B=50 -> A-B == 60-50=10 -> A_result > 0
        // -> If B won, then A=30 and B=60 -> A-B == 30-60=-30 -> A_result > 0?
        // B won should fail/be false -> Check if left-most bit is 0 == Is result negative? For that logic also check == 0 though 
        asterix_total - obelix_total >= 0 && asterix_total - cacofonix_total >= 0 && asterix_total - ms_geriatrix_total >= 0 &&
        asterix_total - obelix_total < 0x80000000 && asterix_total - cacofonix_total < 0x80000000 && asterix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Coop - check for P2
        get_player_count() == 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Obelix
        get_char_id(player=2) == 1 &&
        // Obelix has highest score
        obelix_total - asterix_total >= 0 && obelix_total - cacofonix_total >= 0 && obelix_total - ms_geriatrix_total >= 0 &&
        obelix_total - asterix_total < 0x80000000 && obelix_total - cacofonix_total < 0x80000000 && obelix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Coop - check for P2
        get_player_count() == 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Cacofonix
        get_char_id(player=2) == 2 &&
        // Cacofonix has highest score
        cacofonix_total - asterix_total >= 0 && cacofonix_total - obelix_total >= 0 && cacofonix_total - ms_geriatrix_total >= 0 &&
        cacofonix_total - asterix_total < 0x80000000 && cacofonix_total - obelix_total < 0x80000000 && cacofonix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    ) ||
    (
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Coop - check for P2
        get_player_count() == 2 &&
        // Mode
        is_in_mega_madness() &&
        // Player is using Ms Geriatrix
        get_char_id(player=2) == 3 &&
        // Ms Geriatrix has highest score
        ms_geriatrix_total - asterix_total >= 0 && ms_geriatrix_total - obelix_total >= 0 && ms_geriatrix_total - cacofonix_total >= 0 &&
        ms_geriatrix_total - asterix_total < 0x80000000 && ms_geriatrix_total - obelix_total < 0x80000000 && ms_geriatrix_total - cacofonix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Asterix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Obelix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Cacofonix") == 0) ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0 && prev(get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") == 0)
        )
    )

    return cond
}

// Progression and Victory
for day in range(0, 3, 1) {
    achievement(
    title = ACH_NAME[day],
    points = ACH_PTS[day],
    type = ACH_PRG[day],
    description = format("Finish in first place on day {0} of Mega Madness mode", day + 1),
    trigger = 
        day_victory_logic(day + 1)
    )
}


// Variety Showcase - a bunch of achievements with special challenges tied to them:
// TODO: Let's roll
target_boar_kills = 45

achievement(
    title = "No Boars Were Harmed in the Making of This Achievement",
    points = 10,
    description = format("In \"Boar Bash\", defeat {0} boars in a single round", target_boar_kills),
    trigger = 
        get_minigame() == 0x02 &&
        minigame_not_finished() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        (
        (
            get_player_count() == 1 &&
            word(0x896f2) >= target_boar_kills && prev(word(0x896f2)) < target_boar_kills
        ) || 
        (
            get_player_count() == 2 &&
            word(0x896f2) >= target_boar_kills && prev(word(0x896f2)) < target_boar_kills
        ) ||
        (
            get_player_count() == 2 &&
            word(0x89a3a) >= target_boar_kills && prev(word(0x89a3a)) < target_boar_kills
        )
        )        
)


achievement(
    title = "Gaulish Defence System",
    points = 5,
    description = "In \"Shoot & Score\", complete a round without getting hit",
    trigger = 
        get_minigame() == 0x0b &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        never(countdown_starting_again()) &&
        (
        (
            get_player_count() <= 2 &&
            // Game just ended
            // Time limit is not the most reliable, so...
            // Results must show, players must have scored any pts
            // The latter checks if the game was finished (you need to destroy stuff and score points to even meet the achievement requirement..)
            trigger_when(results_just_popped_up() && dword(0x086658) != 0) &&
            // Player hit? Disable
            disable_when(dword(0x08665c) != 0 && prev(dword(0x08665c) == 0))
        ) || 
        (
            get_player_count() == 2 &&
            // Game just ended
            trigger_when(results_just_popped_up() && dword(0x086bb0) != 0) &&
            // Player hit? Disable
            disable_when(dword(0x086bb4) != 0 && prev(dword(0x086bb4) == 0))
        )
        )        
)

food_target = 20

achievement(
    title = "I'll Eat Almost Anything",
    points = 10,
    description = format("In \"Food Feast\", eat {0} things in a single round", food_target),
    trigger = 
        get_minigame() == 0x07 &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        never(countdown_starting_again()) &&
        (
            // Solo or Team, P1
        (
            get_player_count() <= 2 &&
            // Game just ended
            // Time limit is not the most reliable, so...
            // Results must show, players must have scored any pts
            // The latter checks if the game was finished (you need to destroy stuff and score points to even meet the achievement requirement..)
            results_just_popped_up() && dword(0x081b7c) != 0 &&
            (
            // Eat x items
            repeated(food_target, dword(0x081b7c) > prev(dword(0x081b7c)))
            // Player poisoned? Disable
            //disable_when(dword(0x081b38) != 0 && prev(dword(0x081b38) == 0))
            )
        ) || 
            // Solo or Team, P2
        (
            get_player_count() == 2 &&
            // Game just ended
            results_just_popped_up() && dword(0x082a40) != 0 &&
            (
            // Eat x items
            repeated(food_target, dword(0x082a40) > prev(dword(0x082a40)))
            // Player poisoned? Disable
            //disable_when(dword(0x0829fc) != 0 && prev(dword(0x0829fc) == 0))
            )
        ) || 
            // Team mode, P1
        (
            get_player_count() == 3 &&
            results_just_popped_up() && dword(0x081b7c) != 0 &&
            (
            repeated(food_target, dword(0x081b7c) > prev(dword(0x081b7c)))
            )
        ) || 
            // Team mode, P2
        (
            get_player_count() == 3 &&
            results_just_popped_up() && dword(0x080cb8) != 0 &&
            (
            repeated(food_target, dword(0x080cb8) > prev(dword(0x080cb8)))
            )
        ) ||
            // 4 Player P1
        (
            get_player_count() == 4 &&
            results_just_popped_up() && dword(0x081b7c) != 0 &&
            (
            repeated(food_target, dword(0x081b7c) > prev(dword(0x081b7c)))
            )
        ) ||
            // 4 Player P2
        (
            get_player_count() == 4 &&
            results_just_popped_up() && dword(0x080cb8) != 0 &&
            (
            repeated(food_target, dword(0x080cb8) > prev(dword(0x080cb8)))
            )
        ) ||
            // 4 Player P3
        (
            get_player_count() == 4 &&
            results_just_popped_up() && dword(0x082a40) != 0 &&
            (
            repeated(food_target, dword(0x082a40) > prev(dword(0x082a40)))
            )
        ) ||
            // 4 Player P4
        (
            get_player_count() == 4 &&
            results_just_popped_up() && dword(0x083904) != 0 &&
            (
            repeated(food_target, dword(0x083904) > prev(dword(0x083904)))
            )
        )
        )        
)

time_limit = 11500

achievement(
    title = "You're Hired!",
    points = 5,
    description = "In \"Shield Chase\", reach the goal in 1:55.00 or less",
    trigger = 
        get_minigame() == 0x03 &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&

        // unless(is_paused()) &&
        disable_when(
            // player took too long
            tally(time_limit, in_game_timer_tick_while_unpaused_only(), in_game_timer_tick_while_unpaused_only()),
            // game restarted, reset hits from time limit
            until=countdown_starting_again() || dword(0x06b028) != 0
        ) &&
        (
        (
            // p1 alone
            get_player_count() == 1 &&
            trigger_when(dword(0x0868a4) == 3 && prev(dword(0x0868a4)) == 2)
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            trigger_when(dword(0x0868a4) == 3 && prev(dword(0x0868a4)) == 2)
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            trigger_when(dword(0x086bf0) == 3 && prev(dword(0x086bf0)) == 2)
        )
    )
)

time_limit = 9500

achievement(
    title = "Doing the Heavy Lifting",
    points = 10,
    description = "In \"Catapult Chase\", reach the goal in 1:35.00 or less",
    trigger = 
        get_minigame() == 0x06 &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&

        // unless(is_paused()) &&
        disable_when(
            // player took too long
            tally(time_limit, in_game_timer_tick_while_unpaused_only(), in_game_timer_tick_while_unpaused_only()),
            // game restarted, reset hits from time limit
            until=countdown_starting_again() || dword(0x06b028) != 0
        ) &&
        (
        (
            // p1 alone
            get_player_count() == 1 &&
            trigger_when(ptr(tbyte(0x06a868), [0x19c], word) == 5 && prev(ptr(tbyte(0x06a868), [0x19c], word)) == 4)
            // trigger_when(word(0x1a7330) == 5 && prev(word(0x1a7330)) == 4)
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            trigger_when(ptr(tbyte(0x06a868), [0x19c], word) == 5 && prev(ptr(tbyte(0x06a868), [0x19c], word)) == 4)
            // trigger_when(word(0x1a7330) == 5 && prev(word(0x1a7330)) == 4)
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            trigger_when(ptr(tbyte(0x06a868), [0x394], word) == 5 && prev(ptr(tbyte(0x06a868), [0x394], word)) == 4)
            // trigger_when(word(0x1a7528) == 5 && prev(word(0x1a7528)) == 4)
        )
    )
)


time_limit = 8500

achievement(
    title = "Life Is but a Dream",
    points = 10,
    description = "In \"Rowing Race\", reach the goal in 1:25.00 or less",
    trigger = 
        get_minigame() == 0x01 &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&

        // unless(is_paused()) &&
        disable_when(
            // player took too long
            tally(time_limit, in_game_timer_tick_while_unpaused_only(), in_game_timer_tick_while_unpaused_only()),
            // game restarted, reset hits from time limit
            until=countdown_starting_again() || dword(0x06b028) != 0
        ) &&
        (
        (
            // p1 alone
            get_player_count() == 1 &&
            trigger_when(ptr(tbyte(0x06b0e0), [0xC76C], dword) != 0 && prev(ptr(tbyte(0x06a868), [0xC76C], word)) == 0)
            // trigger_when(dword(0x1cac40) != 0 && prev(dword(0x1cac40)) == 0)
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            trigger_when(ptr(tbyte(0x06b0e0), [0xC76C], dword) != 0 && prev(ptr(tbyte(0x06a868), [0xC76C], word)) == 0)
            // trigger_when(dword(0x1cac40) != 0 && prev(dword(0x1cac40)) == 0)
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            trigger_when(ptr(tbyte(0x06b0e0), [0xCB3C], dword) != 0 && prev(ptr(tbyte(0x06a868), [0xCB3C], word)) == 0)
            // trigger_when(dword(0x1cb010) != 0 && prev(dword(0x1cb010)) == 0)
        )
    )
)

function shield_bash_player_took_half_dmg(side) {
    if (side == "left") {
        target_adr = 0x08cdbc
    } else if (side == "right") {
        target_adr = 0x08d42c
    }

    // now has 50 or less; had more than 50 prev -> triggers when too much hp lost
    return dword(target_adr) <= 50 && prev(dword(target_adr)) > 50
}

function shield_bash_player_died(side) {
    if (side == "left") {
        target_adr = 0x08cdbc
    } else if (side == "right") {
        target_adr = 0x08d42c
    }

    // now has 0; had more than 0 prev -> triggers when dead
    return dword(target_adr) == 0 && prev(dword(target_adr)) > 0
}

achievement(
    title = "Tis but a Scratch",
    points = 5,
    description = "In \"Shield Bash\", win against a computer-controlled opponent with at least half your health remaining",
    trigger = 
        get_minigame() == 0x05 &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        (
            (
                // Single player left
                get_player_count() == 1 &&
                // P1 character must be on the left side - in that case...
                get_char_id(player=1) == dword(0x08cd64) &&
                // ...it's all about the left-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("left"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the right-side player HP being 0
                trigger_when(shield_bash_player_died("right"))
            ) || (
                // Single player right
                get_player_count() == 1 &&
                // P1 character must be on the right side - in that case...
                get_char_id(player=1) == dword(0x08d3d4) &&
                // ...it's all about the right-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("right"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the light-side player HP being 0
                trigger_when(shield_bash_player_died("left"))
            ) || (
                // Two players - P1 checks left
                get_player_count() == 2 &&
                // P1 character must be on the left side
                get_char_id(player=1) == dword(0x08cd64) &&
                // Opponent cannot be P2
                get_char_id(player=2) != dword(0x08d3d4) &&
                // ...it's all about the left-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("left"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the right-side player HP being 0
                trigger_when(shield_bash_player_died("right"))
            ) || (
                // Two players - P1 checks right
                get_player_count() == 2 &&
                // P1 character must be on the right side
                get_char_id(player=1) == dword(0x08d3d4) &&
                // Opponent cannot be P2
                get_char_id(player=2) != dword(0x08cd64) &&
                // ...it's all about the right-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("right"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the left-side player HP being 0
                trigger_when(shield_bash_player_died("left"))
            ) || (
                // Two players - P2 checks left
                get_player_count() == 2 &&
                // P2 character must be on the left side
                get_char_id(player=2) == dword(0x08cd64) &&
                // Opponent cannot be P1
                get_char_id(player=1) != dword(0x08d3d4) &&
                // ...it's all about the left-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("left"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the right-side player HP being 0
                trigger_when(shield_bash_player_died("right"))
            ) || (
                // Two players - P2 checks right
                get_player_count() == 2 &&
                // P2 character must be on the right side
                get_char_id(player=2) == dword(0x08d3d4) &&
                // Opponent cannot be P1
                get_char_id(player=1) != dword(0x08cd64) &&
                // ...it's all about the right-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("right"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the light-side player HP being 0
                trigger_when(shield_bash_player_died("left"))
            ) ||
            (
                // One team in Coop
                get_player_count() == 3 &&
                // Team is always on left side, no check needed
                // So left-side player HP being high...
                disable_when(shield_bash_player_took_half_dmg("left"), until=countdown_starting_again() || dword(0x06b028) != 0) &&
                // ...and the right-side player HP being 0
                trigger_when(shield_bash_player_died("right"))
            )
            // Two coop teams - not valid since human vs human
        )
)

time_limit = 8000

achievement(
    title = "Jump, Man",
    points = 10,
    description = "In \"Obstacle Course\", reach the goal in 1:20.00 or less",
    trigger = 
        get_minigame() == 0x0d &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&

        // unless(is_paused()) &&
        disable_when(
            // player took too long
            tally(time_limit, in_game_timer_tick_while_unpaused_only(), in_game_timer_tick_while_unpaused_only()),
            // game restarted, reset hits from time limit
            until=countdown_starting_again() || dword(0x06b028) != 0
        ) &&
        (
        (
            // p1 alone
            get_player_count() == 1 &&
            trigger_when(byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0)
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            trigger_when(byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0)
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            trigger_when(byte(0x0842a8) == 1 && prev(byte(0x0842a8)) == 0)
        ) ||
        (
            // team alone
            get_player_count() == 3 &&
            trigger_when(byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0)
        ) ||
        (
            // team vs team, p1 first
            get_player_count() == 4 &&
            trigger_when(byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0)
        ) ||
        (
            // team vs team, p2 first
            get_player_count() == 4 &&
            trigger_when(byte(0x0842a8) == 1 && prev(byte(0x0842a8)) == 0)
        )
    )
)



// Minigame get score iteration:
minigame_score_data = {
    0x0b: {
        "game_name": "Shoot & Score",
        "target": 3000,
        "title": "Shot and Scored",
        "score_size": 64,
        "p1_score_adr": 0x86658,
        "p2_score_adr": 0x86bb0
    },
    0x00: {
        "game_name": "Recipe Run",
        "target": 2000,
        "title": "Just Use Beetroot Juice",
        "score_size": 64,
        "p1_score_adr": 0x8d438,
        "p2_score_adr": 0x8d790
    },
    0x07: {
        "game_name": "Food Feast",
        "target": 2500,
        "title": "The Final Page",
        "score_size": 64,
        "p1_score_adr": 0x81b7c,
        "p2_score_adr": 0x82a40
    },
    0x02: {
        "game_name": "Boar Bash",
        "target": 3500,
        "title": "Breakfast Is Served",
        "score_size": 64,
        "p1_score_adr": 0x896e4,
        "p2_score_adr": 0x89a2c
    },
    //0x03: {
    //    "game_name": "Shield Chase",
    //    "target": 2000,
    //    "title": "Holding on to What I Am",
    //    "score_size": 64,
    //    "p1_score_adr": 0x868d0,
    //    "p2_score_adr": 0x86c1c
    //},
    0x08: {
        "game_name": "Camp Crashing",
        "target": 3000,
        "title": "Cleanup Crew",
        "score_size": 64,
        "p1_score_adr": 0x97bec,
        "p2_score_adr": 0x97f6c
    },
    //0x06: {
    //    "game_name": "Catapult Chase",
    //    "target": 2000,
    //    "title": "Doing the Heavy Lifting",
    //    "score_size": 64,
    //    "p1_score_adr": 0x1a7354,
    //    "p2_score_adr": 0x1a754c
    //},
    0x04: {
        "game_name": "Helmet Hoarding",
        "target": 2000,
        "title": "Stash Superstar",
        "score_size": 64,
        "p1_score_adr": 0x8d670,
        "p2_score_adr": 0x8d9ac
    },
    //0x01: {
    //    "game_name": "Rowing Race",
    //    "target": 2000,
    //    "title": "Life Is but a Dream",
    //    "score_size": 64,
    //    "p1_score_adr": 0x1cabc4,
    //    "p2_score_adr": 0x1caf94
    //},
    0x0a: {
        "game_name": "Hide & Seek",
        "target": 2000,
        "title": "Lost and Found",
        "score_size": 32,
        "p1_score_adr": 0x8dce4,
        "p2_score_adr": 0x8dff8
    },
  //  0x09: {
  //      "game_name": "Galley Smash",
  //      "target": 2000,
  //      "title": "All at Sea",
  //      "score_size": 64,
  //      "p1_score_adr": ptr(tbyte(0x06b0e0), [0x1958], dword), // prev 0x1c914c
  //      "p2_score_adr": ptr(tbyte(0x06b0e0), [0x1CD0], dword)  // prev 0x1c94c4
  //  },
    //0x0d: {
    //    "game_name": "Obstacle Course",
    //    "target": 2000,
    //    "title": "Who's on Top?",
    //    "score_size": 64,
    //    "p1_score_adr": 0x83ed0,
    //    "p2_score_adr": 0x842b0
    //},
    0x0c: {
        "game_name": "Shoot to Survive",
        "target": 2500,
        "title": "Last Line of Defense",
        "score_size": 64,
        "p1_score_adr": 0x86658,
        "p2_score_adr": 0x86bb0
    }
}


for gameid_key in minigame_score_data {
    game_name = minigame_score_data[gameid_key]["game_name"]
    target = minigame_score_data[gameid_key]["target"]
    ach_title = minigame_score_data[gameid_key]["title"]
    p1_score_adr = minigame_score_data[gameid_key]["p1_score_adr"]
    p2_score_adr = minigame_score_data[gameid_key]["p2_score_adr"]
    score_size = minigame_score_data[gameid_key]["score_size"]

    if (score_size == 32) {
        cond = get_minigame() == gameid_key &&
        minigame_not_finished() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        (
        (
            get_player_count() == 1 &&
            word(p1_score_adr) > prev(word(p1_score_adr)) &&
            word(p1_score_adr) >= target
        ) || 
        (
            get_player_count() == 2 &&
            word(p1_score_adr) > prev(word(p1_score_adr)) &&
            word(p1_score_adr) >= target
        ) ||
        (
            get_player_count() == 2 &&
            word(p2_score_adr) > prev(word(p2_score_adr)) &&
            word(p2_score_adr) >= target
        )
        )

    } else if (score_size == 64) {
        cond = get_minigame() == gameid_key &&
        minigame_not_finished() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        (
        (
            get_player_count() == 1 &&
            dword(p1_score_adr) > prev(dword(p1_score_adr)) &&
            dword(p1_score_adr) >= target
        ) || 
        (
            get_player_count() == 2 &&
            dword(p1_score_adr) > prev(dword(p1_score_adr)) &&
            dword(p1_score_adr) >= target
        ) ||
        (
            get_player_count() == 2 &&
            dword(p2_score_adr) > prev(dword(p2_score_adr)) &&
            dword(p2_score_adr) >= target
        )
        )
    }

    achievement(
    title = ach_title,
    points = 5,
    description = format("In \"{1}\", score {0} points in Mega Madness or Practice mode", target, game_name),
    trigger = 
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        cond
    )
}


// Raw call due to pointer; dirty fix for the time being
achievement(
    title = "All at Sea",
    points = 5,
    description = format("In \"{1}\", score {0} points in Mega Madness or Practice mode", 2000, "Galley Smash"),
    trigger = 
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x09 &&
        minigame_not_finished() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        (
        (
            get_player_count() == 1 &&
            ptr(tbyte(0x06b0e0), [0x1958], dword) > prev(ptr(tbyte(0x06b0e0), [0x1958], dword)) &&
            ptr(tbyte(0x06b0e0), [0x1958], dword) >= 2000
        ) || 
        (
            get_player_count() == 2 &&
            ptr(tbyte(0x06b0e0), [0x1958], dword) > prev(ptr(tbyte(0x06b0e0), [0x1958], dword)) &&
            ptr(tbyte(0x06b0e0), [0x1958], dword) >= 2000
        ) ||
        (
            get_player_count() == 2 &&
            ptr(tbyte(0x06b0e0), [0x1CD0], dword) > prev(ptr(tbyte(0x06b0e0), [0x1CD0], dword)) &&
            ptr(tbyte(0x06b0e0), [0x1CD0], dword) >= 2000
        )
        )
    )




// Leaderboard iteration: Score target
lb_score_obj = {
    0x0b: {
        "game_name": "Shoot & Score",
        "score_size": 64,
        "p1_score_adr": 0x86658,
        "p2_score_adr": 0x86bb0
    },
    0x00: {
        "game_name": "Recipe Run",
        "score_size": 64,
        "p1_score_adr": 0x8d438,
        "p2_score_adr": 0x8d790
    },
    0x07: {
        "game_name": "Food Feast",
        "score_size": 64,
        "p1_score_adr": 0x81b7c,
        "p2_score_adr": 0x82a40
    },
    0x02: {
        "game_name": "Boar Bash",
        "score_size": 64,
        "p1_score_adr": 0x896e4,
        "p2_score_adr": 0x89a2c
    },
    0x08: {
        "game_name": "Camp Crashing",
        "score_size": 64,
        "p1_score_adr": 0x97bec,
        "p2_score_adr": 0x97f6c
    },
    0x04: {
        "game_name": "Helmet Hoarding",
        "score_size": 64,
        "p1_score_adr": 0x8d670,
        "p2_score_adr": 0x8d9ac
    },
    0x0a: {
        "game_name": "Hide & Seek",
        "score_size": 32,
        "p1_score_adr": 0x8dce4,
        "p2_score_adr": 0x8dff8
    },
  //  0x09: {
  //      "game_name": "Galley Smash",
  //      "score_size": 64,
  //      "p1_score_adr": ptr(tbyte(0x06b0e0), [0x1958], dword), // prev 0x1c914c
  //      "p2_score_adr": ptr(tbyte(0x06b0e0), [0x1CD0], dword)  // prev 0x1c94c4
  //  },
    0x0c: {
        "game_name": "Shoot to Survive",
        "score_size": 64,
        "p1_score_adr": 0x86658,
        "p2_score_adr": 0x86bb0
    }
}

// Leaderboard iteration: Score target
// These 3 plus Obstacle course as solo
lb_team_score_obj = {
    0x07: {
        "game_name": "Food Feast",
        "score_size": 64,
        "t1_p1": 0x081b7c,
        "t1_p2": 0x080cb8,
        "t2_p1": 0x082a40,
        "t2_p2": 0x083904
    },
    0x08: {
        "game_name": "Camp Crashing",
        "score_size": 64,
        "t1_p1": 0x097bec,
        "t1_p2": 0x097f6c,
        "t2_p1": 0x0982ec,
        "t2_p2": 0x09866c
    }
}


for gameid_key in lb_score_obj {
    game_name = lb_score_obj[gameid_key]["game_name"]
    p1_score_adr = lb_score_obj[gameid_key]["p1_score_adr"]
    p2_score_adr = lb_score_obj[gameid_key]["p2_score_adr"]
    score_size = lb_score_obj[gameid_key]["score_size"]

    if (score_size == 32) {
        start_add_cond = word(p1_score_adr) != 0 && word(p2_score_adr) != 0
        value_add_cond = max_of(
                             measured(tally(0, always_true())),
                             // P1 alone
                             measured(word(p1_score_adr), when=get_player_count() == 1),
                             // P1 vs 2, P1 won
                             measured(word(p1_score_adr), when=get_player_count() == 2 && word(p1_score_adr) >= word(p2_score_adr)),
                             // P1 vs 2, P2 won
                             measured(word(p2_score_adr), when=get_player_count() == 2 && word(p1_score_adr) < word(p2_score_adr))
                         )
    }
    else if (score_size == 64) {
        start_add_cond = dword(p1_score_adr) != 0 && dword(p2_score_adr) != 0
        value_add_cond = max_of(
                             measured(tally(0, always_true())),
                             // P1 alone
                             measured(dword(p1_score_adr), when=get_player_count() == 1),
                             // P1 vs 2, P1 won
                             measured(dword(p1_score_adr), when=get_player_count() == 2 && dword(p1_score_adr) >= dword(p2_score_adr)),
                             // P1 vs 2, P2 won
                             measured(dword(p2_score_adr), when=get_player_count() == 2 && dword(p1_score_adr) < dword(p2_score_adr))
                         )
    }

    leaderboard(
        title = format("High Score: {0}", game_name),
        description = format("Get the highest score in \"{0}\" in Mega Madness or Practice mode", game_name),
        start =
        (   
            (
            get_player_count() == 1 || get_player_count() == 2
            ) &&
            get_minigame() == gameid_key &&
            results_just_popped_up() &&
            !is_in_main_menu() &&
            !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
            start_add_cond
        ),
        cancel = 
        (
            always_false()
        ),
        submit = 
        (
            always_true()
        ),
        value = value_add_cond,
        format = "VALUE", lower_is_better = false
    )
}

// Exception for Galley Smash due to pointer...
leaderboard(
    title = format("High Score: {0}", "Galley Smash"),
    description = format("Get the highest score in \"{0}\" in Mega Madness or Practice mode", "Galley Smash"),
    start =
    (   
        (
        get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x09 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        ptr(tbyte(0x06b0e0), [0x1958], dword) != 0 && ptr(tbyte(0x06b0e0), [0x1CD0], dword) != 0
    ),
    cancel = 
    (
        always_false()
    ),
    submit = 
    (
        always_true()
    ),
    value = max_of(
                    measured(tally(0, always_true())),
                    // P1 alone
                    measured(ptr(tbyte(0x06b0e0), [0x1958], dword), when=get_player_count() == 1),
                    // P1 vs 2, P1 won
                    measured(ptr(tbyte(0x06b0e0), [0x1958], dword), when=get_player_count() == 2 && ptr(tbyte(0x06b0e0), [0x1958], dword) >= ptr(tbyte(0x06b0e0), [0x1CD0], dword)),
                    // P1 vs 2, P2 won
                    measured(ptr(tbyte(0x06b0e0), [0x1CD0], dword), when=get_player_count() == 2 && ptr(tbyte(0x06b0e0), [0x1958], dword) < ptr(tbyte(0x06b0e0), [0x1CD0], dword))
                ),
    format = "VALUE", lower_is_better = false
)

for gameid_key in lb_team_score_obj {
    game_name = lb_team_score_obj[gameid_key]["game_name"]
    p1_1_score_adr = lb_team_score_obj[gameid_key]["t1_p1"]
    p1_2_score_adr = lb_team_score_obj[gameid_key]["t1_p2"]
    p2_1_score_adr = lb_team_score_obj[gameid_key]["t2_p1"]
    p2_2_score_adr = lb_team_score_obj[gameid_key]["t2_p2"]

    team_1_score = dword(p1_1_score_adr) + dword(p1_2_score_adr)
    team_2_score = dword(p2_1_score_adr) + dword(p2_2_score_adr)


    start_add_cond = team_1_score != 0 && team_2_score != 0
    value_add_cond = max_of(
        // TODO: check logic
                            measured(tally(0, always_true())),
                            // P1 alone
                            measured(team_1_score, when=get_player_count() == 3),
                            // P1 vs 2, P1 won
                            measured(team_1_score, when=get_player_count() == 4 && team_1_score >= team_2_score),
                            // P1 vs 2, P2 won
                            measured(team_2_score, when=get_player_count() == 4 && team_1_score < team_2_score)
                        )

    leaderboard(
        title = format("High Score: {0} (Team)", game_name),
        description = format("Get the highest score in \"{0}\" in Team Play mode", game_name),
        start =
        (   
            (
                get_player_count() == 3 || get_player_count() == 4
            ) &&
            get_minigame() == gameid_key &&
            results_just_popped_up() &&
            !is_in_main_menu() &&
            !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
            start_add_cond
        ),
        cancel = 
        (
            always_false()
        ),
        submit = 
        (
            always_true()
        ),
        value = value_add_cond,
        format = "VALUE", lower_is_better = false
    )
}



// Time Trials Solo or Duo
leaderboard(
    title = "Fastest Time: Shield Chase",
    description = "Reach the goal as quickly as possible in \"Shield Chase\" in Mega Madness or Practice mode",
    start =
    (   
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x03 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x0868a4) == 0 && dword(0x086bf0) == 0
    ),
    cancel = 
    (
        player_quit_minigame()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            dword(0x0868a4) == 3 && prev(dword(0x0868a4)) == 2
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            dword(0x0868a4) == 3 && prev(dword(0x0868a4)) == 2
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            dword(0x086bf0) == 3 && prev(dword(0x086bf0)) == 2
        )
    ),
    value = 
        never(countdown_starting_again() || dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    title = "Fastest Time: Catapult Chase",
    description = "Reach the goal as quickly as possible in \"Catapult Chase\" in Mega Madness or Practice mode",
    start =
    (   
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x06 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        ptr(tbyte(0x06a868), [0x19c], word)  == 0 && ptr(tbyte(0x06a868), [0x394], word) == 0
    ),
    cancel = 
    (
        player_quit_minigame()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            ptr(tbyte(0x06a868), [0x19c], word) == 5 && prev(ptr(tbyte(0x06a868), [0x19c], word)) == 4
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            ptr(tbyte(0x06a868), [0x19c], word) == 5 && prev(ptr(tbyte(0x06a868), [0x19c], word)) == 4
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            ptr(tbyte(0x06a868), [0x394], word) == 5 && prev(ptr(tbyte(0x06a868), [0x394], word)) == 4
        )
    ),
    value = 
        never(countdown_starting_again() || dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    title = "Fastest Time: Rowing Race",
    description = "Reach the goal as quickly as possible in \"Rowing Race\" in Mega Madness or Practice mode",
    start =
    (   
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x01 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        ptr(tbyte(0x06b0e0), [0xC76C], dword) == 0 && ptr(tbyte(0x06b0e0), [0xC76C], dword) == 0
    ),
    cancel = 
    (
        player_quit_minigame()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            ptr(tbyte(0x06b0e0), [0xC76C], dword) != 0 && prev(ptr(tbyte(0x06b0e0), [0xC76C], dword)) == 0
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            ptr(tbyte(0x06b0e0), [0xC76C], dword) != 0 && prev(ptr(tbyte(0x06b0e0), [0xC76C], dword)) == 0
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            ptr(tbyte(0x06b0e0), [0xCB3C], dword) != 0 && prev(ptr(tbyte(0x06b0e0), [0xCB3C], dword)) == 0
        )
    ),
    value = 
        never(countdown_starting_again() || dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)


leaderboard(
    title = "Fastest Time: Obstacle Course",
    description = "Reach the goal as quickly as possible in \"Obstacle Course\" in Mega Madness or Practice mode",
    start =
    (   
        (
            get_player_count() == 1 || get_player_count() == 2
        ) &&
        get_minigame() == 0x0d &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        byte(0x083ec8) == 0 && byte(0x0842a8) == 0
    ),
    cancel = 
    (
        player_quit_minigame()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            byte(0x0842a8) == 1 && prev(byte(0x0842a8)) == 0
        )
    ),
    value = 
        never(countdown_starting_again() || dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    title = "Fastest Time: Obstacle Course (Team)",
    description = "Reach the goal as quickly as possible in \"Obstacle Course\" in Team Play mode",
    start =
    (   
        (
            get_player_count() == 3 || get_player_count() == 4
        ) &&
        get_minigame() == 0x0d &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() && minigame_fully_loaded() && is_not_in_demo() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        byte(0x083ec8) == 0 && byte(0x0842a8) == 0
    ),
    cancel = 
    (
        player_quit_minigame()
    ),
    submit = 
    (
        (
            // team alone
            get_player_count() == 3 &&
            byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0
        ) ||
        (
            // team vs team, p1 first
            get_player_count() == 4 &&
            byte(0x083ec8) == 1 && prev(byte(0x083ec8)) == 0
        ) ||
        (
            // team vs team, p2 first
            get_player_count() == 4 &&
            byte(0x0842a8) == 1 && prev(byte(0x0842a8)) == 0
        )
    ),
    value = 
        never(countdown_starting_again() || dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

// rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

// Generic competing in x in Mega Madness mode
rich_presence_conditional_display(!is_in_main_menu() && is_not_in_demo() && is_in_mega_madness(), "Competing in {0} in Mega Madness mode",
    rich_presence_lookup("Game", get_minigame(), minigame_lookup, fallback="Unknown Minigame?")
)

// Not Mega Madness? What if in a team?
rich_presence_conditional_display(!is_in_main_menu() && is_not_in_demo() && get_player_count() > 2, "Competing in {0} in Team Play mode",
    rich_presence_lookup("Game", get_minigame(), minigame_lookup, fallback="Unknown Minigame?")
)

// Neither? Practice Mode
rich_presence_conditional_display(!is_in_main_menu() && is_not_in_demo(), "Competing in {0} in Practice mode",
    rich_presence_lookup("Game", get_minigame(), minigame_lookup, fallback="Unknown Minigame?")
)

rich_presence_display("In the Main Menu")
