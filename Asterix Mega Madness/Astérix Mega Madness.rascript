// Astérix: Mega Madness
// #ID = 18223

function in_game_timer_tick() {
    return dword(0x057C6C) > prev(dword(0x057C6C))
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

function is_paused() {
    return byte(0x06af60) == 0x02
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

function get_mode() {
    return byte(0x1fef76)
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

ACH_NAME = ["day 1", "day 2", "day 3", "day 4"]
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
        !is_in_main_menu() &&
        !in_loading_screen() &&
        // Single player
        get_player_count() == 1 &&
        // Mode
        get_mode() == 1 &&
        (
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
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Player is using Obelix
        get_char_id(player=1) == 1 &&
        // Obelix has highest score
        obelix_total - asterix_total >= 0 && obelix_total - cacofonix_total >= 0 && obelix_total - ms_geriatrix_total >= 0 &&
        obelix_total - asterix_total < 0x80000000 && obelix_total - cacofonix_total < 0x80000000 && obelix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Player is using Cacofonix
        get_char_id(player=1) == 2 &&
        // Cacofonix has highest score
        cacofonix_total - asterix_total >= 0 && cacofonix_total - obelix_total >= 0 && cacofonix_total - ms_geriatrix_total >= 0 &&
        cacofonix_total - asterix_total < 0x80000000 && cacofonix_total - obelix_total < 0x80000000 && cacofonix_total - ms_geriatrix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Player is using Ms Geriatrix
        get_char_id(player=1) == 3 &&
        // Ms Geriatrix has highest score
        ms_geriatrix_total - asterix_total >= 0 && ms_geriatrix_total - obelix_total >= 0 && ms_geriatrix_total - cacofonix_total >= 0 &&
        ms_geriatrix_total - asterix_total < 0x80000000 && ms_geriatrix_total - obelix_total < 0x80000000 && ms_geriatrix_total - cacofonix_total < 0x80000000 && 
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
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
    description = format("Reach first place in day {0} of Mega Madness mode", day + 1),
    trigger = 
        day_victory_logic(day + 1)
    )
}

// Shield Chase: Beat time


// Food Feast: No poison
achievement(
    title = "Food Feast Score W/O Poison",
    points = 0,
    description = "Get Food Feast Score W/O Poison",
    trigger = 
        get_minigame() == 0x07 &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        minigame_not_finished() &&
        (
            (
                get_player_count() == 1 &&
                dword(0x081b7c) >= 200 && prev(dword(0x081b7c)) < 200 &&
                disable_when(dword(0x081b38) != 0 && prev(dword(0x081b38) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
            ) ||
            (
                get_player_count() == 2 &&
                dword(0x081b7c) >= 200 && prev(dword(0x081b7c)) < 200 &&
                disable_when(dword(0x081b38) != 0 && prev(dword(0x081b38) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
            ) ||
            (
                get_player_count() == 2 &&
                dword(0x082a40) >= 200 && prev(dword(0x082a40)) < 200 &&
                disable_when(dword(0x0829fc) != 0 && prev(dword(0x0829fc) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
            )
        )
        
)

// Minigame get score iteration:
minigame_score_data = {
    0x0b: {
        "game_name": "Shoot & Score",
        "target": 3000,
        "title": "Shot and Scored",
        "p1_score_adr": 0x86658,
        "p2_score_adr": 0x86bb0
    },
    0x00: {
        "game_name": "Recipe Run",
        "target": 2000,
        "title": "Just use beetroot juice",
        "p1_score_adr": 0x8d438,
        "p2_score_adr": 0x8d790
    },
    0x07: {
        "game_name": "Food Feast",
        "target": 2500,
        "title": "The Final Page",
        "p1_score_adr": 0x81b7c,
        "p2_score_adr": 0x82a40
    },
    0x02: {
        "game_name": "Boar Bash",
        "target": 3500,
        "title": "Breakfast is served",
        "p1_score_adr": 0x896e4,
        "p2_score_adr": 0x89a2c
    },
    0x03: {
        "game_name": "Shield Chase",
        "target": 3000,
        "title": "Carry on",
        "p1_score_adr": 0x868d0,
        "p2_score_adr": 0x86c1c
    },
    0x08: {
        "game_name": "Camp Crashing",
        "target": 3000,
        "title": "Just Cleaning up here",
        "p1_score_adr": 0x97bec,
        "p2_score_adr": 0x97f6c
    },
    0x06: {
        "game_name": "Catapult Chase",
        "target": 3000,
        "title": "Do the Heavy Lifting",
        "p1_score_adr": 0x1a7540,
        "p2_score_adr": 0x1a754c
    },
    0x04: {
        "game_name": "Helmet Hoarding",
        "target": 3000,
        "title": "Stash Superstar",
        "p1_score_adr": 0x8d670,
        "p2_score_adr": 0x8d9ac
    },
    0x01: {
        "game_name": "Rowing Race",
        "target": 3000,
        "title": "Life is but a dream",
        "p1_score_adr": 0x1cabc4,
        "p2_score_adr": 0x1caf94
    },
    0x05: {
        "game_name": "Shield Bash",
        "target": 3000,
        "title": "Combo Fodder",
        "p1_score_adr": 0,
        "p2_score_adr": 0
    },
    0x0a: {
        "game_name": "Hide & Seek",
        "target": 3000,
        "title": "Lost and Found",
        "p1_score_adr": 0x8dce4,
        "p2_score_adr": 0x8dff8
    },
    0x09: {
        "game_name": "Galley Smash",
        "target": 3000,
        "title": "All at Sea",
        "p1_score_adr": 0x1c914c,
        "p2_score_adr": 0x1c94c4
    },
    0x0d: {
        "game_name": "Obstacle Course",
        "target": 3000,
        "title": "Who's on top?",
        "p1_score_adr": 0x83ed0,
        "p2_score_adr": 0x842b0
    },
    0x0c: {
        "game_name": "Shoot to Survive",
        "target": 3000,
        "title": "Last Line of Defense",
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

    achievement(
    title = ach_title,
    points = 5,
    description = format("Score {0} points in {1}", target, game_name),
    trigger = 
        get_minigame() == gameid_key &&
        minigame_not_finished() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        (
        (
            get_player_count() == 1 &&
            dword(p1_score_adr) >= prev(dword(p1_score_adr)) &&
            dword(p1_score_adr) >= target
        ) || 
        (
            get_player_count() == 2 &&
            dword(p1_score_adr) >= prev(dword(p1_score_adr)) &&
            dword(p1_score_adr) >= target
        ) ||
        (
            get_player_count() == 2 &&
            dword(p2_score_adr) >= prev(dword(p2_score_adr)) &&
            dword(p2_score_adr) >= target
        )
        )        
    )
}
/*
achievement(
    title = "Shoot & Score No Hit",
    points = 0,
    description = "Shoot & Score No Hit",
    trigger = 
        get_minigame() == 0x0b &&
        (
            (
                once(countdown_ended()) && never(dword(0x06b028) == 0x7fffffff && prev(dword(0x06b028)) != 0x7fffffff) &&
                get_player_count() == 1 &&
                trigger_when(dword(0x084ff0) == 0x00bd1000 && prev(dword(0x084ff0)) != 0x00bd1000) &&
                disable_when(dword(0x08665c) != 0 && prev(dword(0x08665c) == 0), until=countdown_starting_again())
            ) ||
            (
                once(countdown_ended()) && never(dword(0x06b028) == 0x7fffffff && prev(dword(0x06b028)) != 0x7fffffff) &&
                get_player_count() == 2 &&
                trigger_when(dword(0x084ff0) == 0x00bd1000 && prev(dword(0x084ff0)) != 0x00bd1000) &&
                disable_when(dword(0x08665c) != 0 && prev(dword(0x08665c) == 0), until=countdown_starting_again())
            ) ||
            (
                once(countdown_ended()) && never(dword(0x06b028) == 0x7fffffff && prev(dword(0x06b028)) != 0x7fffffff) &&
                get_player_count() == 2 &&
                trigger_when(dword(0x084ff0) == 0x00bd1000 && prev(dword(0x084ff0)) != 0x00bd1000) &&
                disable_when(dword(0x086bb4) != 0 && prev(dword(0x086bb4) == 0), until=countdown_starting_again())
            )
        )
)


// Shoot to Survive: x seconds

// Recipe Run: Score all items


target_boar_kills = 45

achievement(
    title = "Boar Bash 45 kills",
    points = 0,
    description = format("Boar Bash {0} kills", target_boar_kills),
    trigger = 
        get_minigame() == 0x02 &&
        minigame_not_finished() &&
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
    title = "Shield Chase Both potions",
    points = 0,
    description = "Shield Chase Both potions",
    trigger = 
        get_minigame() == 0x03 &&
        minigame_not_finished() &&
        (
        (
            get_player_count() == 1 &&
            always_true()
            // p1 potion 1 and 2 active
        ) || 
        (
            get_player_count() == 2 &&
            always_true()
            // p1 potion 1 and 2 active
        ) ||
        (
            get_player_count() == 2 &&
            always_true()
            // p2 potion 1 and 2 active
        )
        )        
)

achievement(
    title = "Shield Bash win with 50%",
    points = 0,
    description = "Shield Bash win with 50% against CPU opponent",
    trigger = 
        get_minigame() == 0x05 &&
        minigame_not_finished() &&
        (
        (
            get_player_count() == 1 &&
            // P1 HP must be over 50%
            // P2 HP must be 0
            always_true()
        ) || 
        (
            get_player_count() == 2 &&
            // One player must be CPU -> P1 human
            // P1 HP must be over 50%
            // P2 HP must be 0
            always_true()
        ) ||
        (
            get_player_count() == 2 &&
            // One player must be CPU -> P2 human
            // P2 HP must be over 50%
            // P1 HP must be 0
            always_true()
        )
        )        
)

achievement(
    title = "Catapult Chase Win in x sec",
    points = 0,
    description = "Catapult Chase Win in x sec",
    trigger = 
        get_minigame() == 0x06 &&
        // TODO: Does this make sense? Is it needed?
        never(entered_black_screen_for_loading()) &&
        // Show Trigger badge when tutorial pops up at start
        once(results_just_popped_up()) &&
        dword(0x1a7330) == 0 && dword(0x1a754c) == 0 &&
        // Trigger/Disable when time is up -> minigame time limit hit certain time
        // Here: Disable achievement if certain time spent
        dword(0x86d00) > 0x100 &&
        (
        (
            // p1 alone
            get_player_count() == 1 &&
            trigger_when(dword(0x1a7330) == 3 && prev(dword(0x1a7330)) == 2)
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            trigger_when(dword(0x1a7330) == 3 && prev(dword(0x1a7330)) == 2)
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            trigger_when(dword(0x1a7528) == 3 && prev(dword(0x1a7528)) == 2)
        )
        )        
)
*/

// Do the same for other race minigames..

leaderboard(
    title = "High Score: Helmet Hoarding",
    description = "Get the highest score in \"Helmet Hoarding\"",
    start =
    (   
        get_minigame() == 0x04 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x8d670) != 0 && dword(0x8d9ac) != 0
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
                measured(dword(0x8d670), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x8d670), when=get_player_count() == 2 && dword(0x8d670) >= dword(0x8d9ac)),
                // P1 vs 2, P2 won
                measured(dword(0x8d9ac), when=get_player_count() == 2 && dword(0x8d670) < dword(0x8d9ac))
            ),
    format = "VALUE", lower_is_better = false
)


leaderboard(
    title = "High Score: Galley Smash",
    description = "Get the highest score in \"Galley Smash\"",
    start =
    (   
        get_minigame() == 0x09 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x1c914c) != 0 && dword(0x1c94c4) != 0
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
                measured(dword(0x1c914c), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x1c914c), when=get_player_count() == 2 && dword(0x1c914c) >= dword(0x1c94c4)),
                // P1 vs 2, P2 won
                measured(dword(0x1c94c4), when=get_player_count() == 2 && dword(0x1c914c) < dword(0x1c94c4))
            ),
    format = "VALUE", lower_is_better = false
)


// Rowing Race: Beat time

// Shield Bash: Win with 50% HP
// TODO: Shield Bash cannot really use a LB...?

// Obstacle Course: Beat time

leaderboard(
    title = "High Score: Hide & Seek",
    description = "Get the highest score in \"Hide & Seek\"",
    start =
    (   
        get_minigame() == 0x0a &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        word(0x8dce4) != 0 && word(0x8dff8) != 0
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
                measured(word(0x8dce4), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(word(0x8dce4), when=get_player_count() == 2 && word(0x8dce4) >= word(0x8dff8)),
                // P1 vs 2, P2 won
                measured(word(0x8dff8), when=get_player_count() == 2 && word(0x8dce4) < word(0x8dff8))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "High Score: Shoot & Score",
    description = "Get the highest score in \"Shoot & Score\"",
    start =
    (   
        get_minigame() == 0x0b &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x86658) != 0 && dword(0x86bb0) != 0
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
                measured(dword(0x86658), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x86658), when=get_player_count() == 2 && dword(0x86658) >= dword(0x86bb0)),
                // P1 vs 2, P2 won
                measured(dword(0x86bb0), when=get_player_count() == 2 && dword(0x86658) < dword(0x86bb0))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "High Score: Shoot to Survive",
    description = "Get the highest score in \"Shoot to Survive\"",
    start =
    (   
        get_minigame() == 0x0c &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x86658) != 0 && dword(0x86bb0) != 0
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
                measured(dword(0x86658), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x86658), when=get_player_count() == 2 && dword(0x86658) >= dword(0x86bb0)),
                // P1 vs 2, P2 won
                measured(dword(0x86bb0), when=get_player_count() == 2 && dword(0x86658) < dword(0x86bb0))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "High Score: Camp Crashing",
    description = "Get the highest score in \"Camp Crashing\"",
    start =
    (   
        get_minigame() == 0x08 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x97bec) != 0 && dword(0x97f6c) != 0
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
                measured(dword(0x97bec), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x97bec), when=get_player_count() == 2 && dword(0x97bec) >= dword(0x97f6c)),
                // P1 vs 2, P2 won
                measured(dword(0x97f6c), when=get_player_count() == 2 && dword(0x97bec) < dword(0x97f6c))
            ),
    format = "VALUE", lower_is_better = false
)


leaderboard(
    title = "High Score: Boar Bash",
    description = "Get the highest score in \"Boar Bash\"",
    start =
    (   
        get_minigame() == 0x02 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x896e4) != 0 && dword(0x89a2c) != 0
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
                measured(dword(0x896e4), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x896e4), when=get_player_count() == 2 && dword(0x896e4) >= dword(0x89a2c)),
                // P1 vs 2, P2 won
                measured(dword(0x89a2c), when=get_player_count() == 2 && dword(0x896e4) < dword(0x89a2c))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "High Score: Recipe Run",
    description = "Get the highest score in \"Recipe Run\"",
    start =
    (   
        get_minigame() == 0x00 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x8d438) != 0 && dword(0x8d790) != 0
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
                measured(dword(0x8d438), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x8d438), when=get_player_count() == 2 && dword(0x8d438) >= dword(0x8d790)),
                // P1 vs 2, P2 won
                measured(dword(0x8d790), when=get_player_count() == 2 && dword(0x8d438) < dword(0x8d790))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "High Score: Food Feast",
    description = "Get the highest score in \"Food Feast\"",
    start =
    (   
        get_minigame() == 0x07 &&
        results_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        dword(0x081B7C) != 0 && dword(0x82a40) != 0
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
                measured(dword(0x081B7C), when=get_player_count() == 1),
                // P1 vs 2, P1 won
                measured(dword(0x081B7C), when=get_player_count() == 2 && dword(0x081B7C) >= dword(0x082A40)),
                // P1 vs 2, P2 won
                measured(dword(0x082A40), when=get_player_count() == 2 && dword(0x081B7C) < dword(0x082A40))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "Fastest Time: Shield Chase",
    description = "Reach the goal as quickly as possible in \"Shield Chase\"",
    start =
    (   
        get_minigame() == 0x03 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x0868a4) == 0 && dword(0x086bf0) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        //dword(0x085a68) == 0x01770000 && prev(dword(0x085a68)) < 0x01770000 
        entered_black_screen_for_loading()
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
    description = "Reach the goal as quickly as possible in \"Catapult Chase\"",
    start =
    (   
        get_minigame() == 0x06 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        word(0x1a7330) == 0 && word(0x1a7528) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        //dword(0x97bd0) == 0x01964000 && prev(dword(0x97bd0)) < 0x01964000
        entered_black_screen_for_loading()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            word(0x1a7330) == 5 && prev(word(0x1a7330)) == 4
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            word(0x1a7330) == 5 && prev(word(0x1a7330)) == 4
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            word(0x1a7528) == 5 && prev(word(0x1a7528)) == 4
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

// TODO: Restart after winning bugged?
leaderboard(
    title = "Fastest Time: Rowing Race",
    description = "Reach the goal as quickly as possible in \"Rowing Race\"",
    start =
    (   
        get_minigame() == 0x01 &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x1cabc4) == 0 && dword(0x1caf94) == 0
    ),
    cancel = 
    (
        // TODO: need a good cancel condition
        entered_black_screen_for_loading()
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            dword(0x1cac40) != 0 && prev(dword(0x1cac40)) == 0
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            dword(0x1cac40) != 0 && prev(dword(0x1cac40)) == 0
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            dword(0x1cb010) != 0 && prev(dword(0x1cb010)) == 0
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


// TODO: restart does not work
leaderboard(
    title = "Fastest Time: Obstacle Course",
    description = "Reach the goal as quickly as possible in \"Obstacle Course\"",
    start =
    (   
        get_minigame() == 0x0d &&
        tutorial_just_popped_up() &&
        !is_in_main_menu() &&
        !in_loading_screen() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        byte(0x083ec8) == 0 && byte(0x0842a8) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        //dword(0x084ef0) == 0x01770000 && prev(dword(0x084ef0)) < 0x01770000 
        // TODO: for all race leaderboards make sure cancel is executed when restarting but not on the same frame as the new start?
        // OR: since i am using measured -> reset on start condition?
        entered_black_screen_for_loading()
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


// rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

// Generic competing in x in x mode
rich_presence_conditional_display(!is_in_main_menu(), "Competing in {0} in {1} mode",
    rich_presence_lookup("Game", get_minigame(), minigame_lookup, fallback="Unknown Minigame?"),
    rich_presence_lookup("Mode", get_mode(), mode_lookup, fallback="Unknown mode?")
)

rich_presence_display("In the Main Menu")
