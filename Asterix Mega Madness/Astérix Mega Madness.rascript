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
    return byte(0x0907d9) + 1
}

function countdown_ended() {
    return dword(0x06b028) == 0 && prev(dword(0x06b028)) > 0
}

function countdown_starting_again() {
    return dword(0x06b028) == 0x7fffffff && prev(dword(0x06b028)) != 0x7fffffff
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
    return byte(0x0760C0) == 0x17 || byte(0x0760C0) == 0x00 || byte(0x0760C0) == 0xbe || dword(0x090a1c) == 0
}

function get_mode() {
    return byte(0x0907d8)
}

mode_lookup = {
    0x00: "Mega Madness",
    0x01: "Practice",
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

function results_just_popped_up() {
    return dword(0x06b060) == 0x50 && prev(dword(0x06b060)) < 0x50
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
    
    cond = (
        // Single player
        char_count == 1 &&
        // Player is using Asterix
        get_char_id(player=1) == 0 &&
        // Asterix has highest score
        // Possible scenarios with this logic:
        // -> If A won, then A=60 and B=50 -> A-B == 60-50=10 -> A_result > 0
        // -> If B won, then A=30 and B=60 -> A-B == 30-60=-30 -> A_result > 0?
        // B won should fail/be false -> Check if left-most bit is 0 == Is result negative? For that logic also check == 0 though 
        // TODO: What happens on a tie? Who wins? Both?
        // TODO: Edit logic for all 4 cases
        //OLD: asterix_total > obelix_total && asterix_total > cacofonix_total && asterix_total > ms_geriatrix_total &&
        asterix_total - obelix_total >= 0 && asterix_total - cacofonix_total >= 0 && asterix_total - ms_geriatrix_total >= 0 &&
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Single player
        char_count == 1 &&
        // Player is using Obelix
        get_char_id(player=1) == 1 &&
        // Obelix has highest score
        obelix_total > asterix_total && obelix_total > cacofonix_total && obelix_total > ms_geriatrix_total &&
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Single player
        char_count == 1 &&
        // Player is using Cacofonix
        get_char_id(player=1) == 2 &&
        // Cacofonix has highest score
        cacofonix_total > asterix_total && cacofonix_total > obelix_total && cacofonix_total > ms_geriatrix_total &&
        (
            // Final round was played, at least one player scored a point
            get_mega_madness_score(day, rounds_this_day, "Asterix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Obelix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Cacofonix") > 0 ||
            get_mega_madness_score(day, rounds_this_day, "Mrs Geriatrix") > 0
        )
    ) ||
    (
        // Single player
        char_count == 1 &&
        // Player is using Ms Geriatrix
        get_char_id(player=1) == 3 &&
        // Ms Geriatrix has highest score
        ms_geriatrix_total > asterix_total && ms_geriatrix_total > obelix_total && ms_geriatrix_total > cacofonix_total &&
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

// Camp Crashing: Reach 100%
achievement(
    title = "Camp Crashing 100%",
    points = 0,
    description = "Destroy the entire camp before time runs out",
    trigger = 
        get_minigame() == 0x08 &&
        word(0x097BE6) == 0x4f && prev(word(0x097BE6)) < 0x4f
)

// Shield Chase: Beat time


// Food Feast: No poison
achievement(
    title = "Food Feast Score W/O Poison",
    points = 0,
    description = "Get Food Feast Score W/O Poison",
    trigger = 
        get_minigame() == 0x07 &&
        (
            get_player_count() == 1 &&
            dword(0x081b7c) >= 200 && prev(dword(0x081b7c)) < 200 &&
            disable_when(dword(0x081b38) != 0 && prev(dword(0x081b38) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
        ) || 
        (
            get_player_count() == 2 &&
            (
                dword(0x081b7c) >= 200 && prev(dword(0x081b7c)) < 200 &&
                disable_when(dword(0x081b38) != 0 && prev(dword(0x081b38) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
            ) ||
            (
                dword(0x082a40) >= 200 && prev(dword(0x082a40)) < 200 &&
                disable_when(dword(0x0829fc) != 0 && prev(dword(0x0829fc) == 0), until=dword(0x080cbc) == 0x008ca000 && prev(dword(0x080cbc) != 0x008ca000))
            )
        )
        
)

achievement(
    title = "Shoot & Score 3000 pts",
    points = 0,
    description = "Shoot & Score 3000 pts",
    trigger = 
        get_minigame() == 0x0b &&
        (
        (
            get_player_count() == 1 &&
            dword(0x086658) >= prev(dword(0x086658))
        ) || 
        (
            get_player_count() == 2 &&
            dword(0x086658) >= prev(dword(0x086658))
        ) ||
        (
            get_player_count() == 2 &&
            dword(0x086bb0) >= prev(dword(0x086bb0))
        )
        )        
)

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

// Boar Bash: Kill 50 boars
achievement(
    title = "Boar Bash 50 kills",
    points = 0,
    description = "Boar Bash 50 kills",
    trigger = 
        get_minigame() == 0x02 &&
        (
        (
            get_player_count() == 1 &&
            word(0x896f2) >= 50 && prev(word(0x896f2)) < 50
        ) || 
        (
            get_player_count() == 2 &&
            word(0x896f2) >= 50 && prev(word(0x896f2)) < 50
        ) ||
        (
            get_player_count() == 2 &&
            word(0x89a3a) >= 50 && prev(word(0x89a3a)) < 50
        )
        )        
)

// Catapult Chase: Beat time

// Helmet Hoarding: Never drop helmets by attack

// Rowing Race: Beat time

// Shield Bash: Win with 50% HP

// Hide and Seek: Win without key?

// Galley Smash: ...?

// Obstacle Course: Beat time

leaderboard(
    title = "Shoot & Score",
    description = "Get the highest score in \"Shoot & Score\"",
    start =
    (   
        get_minigame() == 0x0b &&
        results_just_popped_up() &&
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
    title = "Shoot to Survive",
    description = "Get the highest score in \"Shoot to Survive\"",
    start =
    (   
        get_minigame() == 0x0c &&
        results_just_popped_up() &&
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
    title = "Camp Crashing",
    description = "Get the highest score in \"Camp Crashing\"",
    start =
    (   
        get_minigame() == 0x08 &&
        results_just_popped_up() &&
        dword(0x97bec) != 0 && dword(?) != 0
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
                measured(dword(0x97bec), when=get_player_count() == 2 && dword(0x97bec) >= dword(?)),
                // P1 vs 2, P2 won
                measured(dword(?), when=get_player_count() == 2 && dword(0x97bec) < dword(?))
            ),
    format = "VALUE", lower_is_better = false
)


leaderboard(
    title = "Boar Bash",
    description = "Get the highest score in \"Boar Bash\"",
    start =
    (   
        get_minigame() == 0x02 &&
        results_just_popped_up() &&
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
    title = "Recipe Run",
    description = "Get the highest score in \"Recipe Run\"",
    start =
    (   
        get_minigame() == 0x00 &&
        results_just_popped_up() &&
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
    title = "Food Feast",
    description = "Get the highest score in \"Food Feast\"",
    start =
    (   
        get_minigame() == 0x07 &&
        results_just_popped_up() &&
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
    title = "Shield Chase",
    description = "Reach the goal as quickly as possible in \"Shield Chase\"",
    start =
    (   
        get_minigame() == 0x03 &&
        results_just_popped_up() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x0868a4) == 0 && dword(0x086bf0) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        dword(0x085a68) == 0x01770000 && prev(dword(0x085a68)) < 0x01770000 
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
        unless(dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    title = "Catapult Chase",
    description = "Reach the goal as quickly as possible in \"Catapult Chase\"",
    start =
    (   
        get_minigame() == 0x06 &&
        results_just_popped_up() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x1a7330) == 0 && dword(?) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        dword(?) == ? && prev(dword(?)) < ? 
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            dword(0x1a7330) == 3 && prev(dword(0x1a7330)) == 2
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            dword(0x1a7330) == 3 && prev(dword(0x1a7330)) == 2
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            dword(?) == 3 && prev(dword(?)) == 2
        )
    ),
    value = 
        unless(dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    title = "Rowing Race",
    description = "Reach the goal as quickly as possible in \"Rowing Race\"",
    start =
    (   
        get_minigame() == 0x01 &&
        results_just_popped_up() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(0x1cac3c) == 0 && dword(?) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        dword(?) == ? && prev(dword(?)) < ? 
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            dword(0x1cac3c) == 3 && prev(dword(0x1cac3c)) == 2
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            dword(0x1cac3c) == 3 && prev(dword(0x1cac3c)) == 2
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            dword(?) == 3 && prev(dword(?)) == 2
        )
    ),
    value = 
        unless(dword(0x06b028) != 0) &&
        unless(is_paused()) &&
        measured(
            tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
    format = "MILLISECS", lower_is_better = true
)


leaderboard(
    title = "Obstacle Course",
    description = "Reach the goal as quickly as possible in \"Obstacle Course\"",
    start =
    (   
        get_minigame() == 0x0d &&
        results_just_popped_up() &&
        // Only start the LB if someone has not started the race yet; do not start it on the results
        dword(?) == 0 && dword(?) == 0
    ),
    cancel = 
    (
        // Race time was reset -> restart
        dword(?) == ? && prev(dword(?)) < ? 
    ),
    submit = 
    (
        (
            // p1 alone
            get_player_count() == 1 &&
            dword(?) == 3 && prev(dword(?)) == 2
        ) ||
        (
            // p1 first
            get_player_count() == 2 &&
            dword(?) == 3 && prev(dword(?)) == 2
        ) ||
        (
            // p2 first
            get_player_count() == 2 &&
            dword(?) == 3 && prev(dword(?)) == 2
        )
    ),
    value = 
        unless(dword(0x06b028) != 0) &&
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
