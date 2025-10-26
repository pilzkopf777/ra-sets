// Astérix: Mega Madness
// #ID = 18223

// $057C6C: [32-bit] Global frame timer
//          Ticks up every frame
function global_frame_timer() => dword(0x057C6C)

// $075E4A: [16-bit] Button inputs
function button_inputs() => word(0x075E4A)

// $081B38: [32-bit] Eating minigame: Poison timer
//          0x00 = Not poisoned
function eating_minigame_poison_timer() => dword(0x081B38)

// $081B7C: [32-bit] Eating minigame: Score
function eating_minigame_score() => dword(0x081B7C)

// $083ED0: [32-bit] Score in Obstacle Course minigame
function score_in_obstacle_course_minigame() => dword(0x083ED0)

// $084FF0: [32-bit] Crossbow minigame: Time Limit
//          Ends on 0x00bd1000
function crossbow_minigame_time_limit() => dword(0x084FF0)

// $086658: [32-bit] Crossbow minigame: Score
function crossbow_minigame_score() => dword(0x086658)

// $08665C: [32-bit] Crossbow minigame: Stun timer when hit
//          0x00 = Not hit
function crossbow_minigame_stun_timer_when_hit() => dword(0x08665C)

// $086670: [32-bit] Crossbow minigame: Next projectile
//          
//          0x00 = Cow
//          0x01 = Roman in Gold Armor
//          0x02 = Roman with Gold Helmet
//          0x03 = Roman
//          0x04 = Chicken
//          0x05 = Barrel
//          0x06 = Pirate
//          0x07 = Captain
//          0x08 = Boar
//          0x09 = Menhir
//          0x0a = Hay
//          0x0b = Weird cat thing?
//          0x0c = Frog?
function crossbow_minigame_next_projectile() => dword(0x086670)

// $086690: [32-bit] Crossbow minigame: Shots until reload
//          0xffffffff = Need to reload
function crossbow_minigame_shots_until_reload() => dword(0x086690)

// $086770: [32-bit] Carrier Race minigame: Balance
//          0xe9ea0000 = Fell off the right
//          0x155c0000 = Fell off the left
function carrier_race_minigame_balance() => dword(0x086770)

// $086868: [32-bit] Carrier Race minigame: Carry state
//          0x00 = Can move
//          0x01 = Tripped, movement lock
function carrier_race_minigame_carry_state() => dword(0x086868)

// $0868A4: [32-bit] Carrier Race minigame: Lap
//          0x03 = Race ended
function carrier_race_minigame_lap() => dword(0x0868A4)

// $0868D0: [32-bit] Carrier Race minigame: Score
function carrier_race_minigame_score() => dword(0x0868D0)

// $086BB0: [32-bit] Crossbow minigame: Score P2
function crossbow_minigame_score_p2() => dword(0x086BB0)

// $086BB4: [32-bit] Crossbow minigame: Stun timer when hit P2
function crossbow_minigame_stun_timer_when_hit_p2() => dword(0x086BB4)

// $086BC8: [32-bit] Crossbow minigame: Next projectile P2
function crossbow_minigame_next_projectile_p2() => dword(0x086BC8)

// $086BE8: [32-bit] Crossbow minigame: Shots until reload
//          0xffffffff = Need to reload
function crossbow_minigame_shots_until_reload() => dword(0x086BE8)

// $0896BC: [32-bit] Boar Hunt minigame: Blue Potion timer
//          0x00 = Ran out
function boar_hunt_minigame_blue_potion_timer() => dword(0x0896BC)

// $0896C4: [32-bit] Boar Hunt minigame: Red Potion timer
//          0x00 = Ran out
function boar_hunt_minigame_red_potion_timer() => dword(0x0896C4)

// $0896E4: [32-bit] Boar Hunt minigame: Score
function boar_hunt_minigame_score() => dword(0x0896E4)

// $0896F2: [16-bit] Boar Hunt minigame: Boars defeated
function boar_hunt_minigame_boars_defeated() => word(0x0896F2)

// $08CDBC: [32-bit] Shield Bash minigame: HP
function shield_bash_minigame_hp() => dword(0x08CDBC)

// $08D314: [32-bit] Recipe minigame: Jump state
//          0x00 = None
//          0x14 = Falling
//          0x0e = Short jump
//          0x0f = High jump
function recipe_minigame_jump_state() => dword(0x08D314)

// $08D318: [32-bit] Recipe minigame: Attack
//          0x0a through 0x0c = Attacking
//          0x00 = None
function recipe_minigame_attack() => dword(0x08D318)

// $08D330: [32-bit] Recipe minigame: Coordinate 1
function recipe_minigame_coordinate_1() => dword(0x08D330)

// $08D338: [32-bit] Recipe minigame: Coordinate 2
function recipe_minigame_coordinate_2() => dword(0x08D338)

// $08D40C: [32-bit] Recipe minigame: Blue Potion timer
//          0x00 = Ran out
function recipe_minigame_blue_potion_timer() => dword(0x08D40C)

// $08D414: [32-bit] Recipe minigame: Red Potion timer
//          0x00 = Ran out
function recipe_minigame_red_potion_timer() => dword(0x08D414)

// $08D438: [32-bit] Recipe minigame: Score
function recipe_minigame_score() => dword(0x08D438)

// $08D5FC: [16-bit] Helmet Hoarding minigame: Helmets held
function helmet_hoarding_minigame_helmets_held() => word(0x08D5FC)

// $08D670: [32-bit] Helmet Hoarding minigame: Score
function helmet_hoarding_minigame_score() => dword(0x08D670)

// $08E94D: [8-bit] Main menu: Highlighted option
//          Works in all menus!
function main_menu_highlighted_option() => byte(0x08E94D)

// $091530: [8-bit] Language Selection
//          0x00 = English
//          0x01 = French
//          0x02 = Italian
//          0x03 = Spanish
//          0x04 = German
//          0x05 = Dutch
function language_selection() => byte(0x091530)

// $097BE6: [16-bit] Camp Crashing minigame: Progress %
//          Ticks up every time the % meter goes up. Thus, does not match the actual percentage.
//          0x4f = Max
function camp_crashing_minigame_progress() => word(0x097BE6)

// $097BEC: [32-bit] Camp Crashing minigame: Score
function camp_crashing_minigame_score() => dword(0x097BEC)

// $1A7330: [16-bit] Catapult Chase minigame: Lap
//          0x05 = End
function catapult_chase_minigame_lap() => word(0x1A7330)

// $1A7540: [32-bit] Catapult Chase minigame: Score
function catapult_chase_minigame_score() => dword(0x1A7540)

// $1C95F0: [32-bit] Galley Crash minigame: Score
function galley_crash_minigame_score() => dword(0x1C95F0)

// $1CAC3C: [32-bit] Rowing Race minigame: Lap
//          0x02 = End
function rowing_race_minigame_lap() => dword(0x1CAC3C)

// $1CADB8: [32-bit] Rowing Race minigame: Score
function rowing_race_minigame_score() => dword(0x1CADB8)

// $1FE899: [8-bit] Sound volume
//          0x00 through 0xff
function sound_volume() => byte(0x1FE899)

// $1FE89C: [8-bit] Music volume
//          0x00 through 0x7f
function music_volume() => byte(0x1FE89C)

// $1FE8A0: [8-bit] Days unlocked in tournament mode
//          0x01 through 0x04
function days_unlocked_in_tournament_mode() => byte(0x1FE8A0)

// $1FEEBC: [8-bit] Vibration setting
//          0x00 = Off
//          0x01 = On
function vibration_setting() => byte(0x1FEEBC)




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
        asterix_total > obelix_total && asterix_total > cacofonix_total && asterix_total > ms_geriatrix_total &&
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
        // Asterix has highest score
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
        // Asterix has highest score
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
        // Player is using Mrs Geriatrix
        get_char_id(player=1) == 3 &&
        // Asterix has highest score
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

function race_leaderboard_logic(title, desc, mode, target_time) {
    leaderboard(
        title = title,
        description = desc,
        start = 
            always_false(),
        cancel = (
            always_false()
        ),
        submit = always_false(),
        value =
            measured(
                tally(0, in_game_timer_tick(), in_game_timer_tick())
        ),
        format = "FRAMES", lower_is_better = true
    )
}

// For all: Get high score and leaderboard of score (also time?)

// Camp Crashing: Reach 100%
//achievement(
//    title = "Camp Crashing 100%",
//    points = 0,
//    description = "Destroy the entire camp before time runs out",
//    trigger = 
//        get_minigame() == 0x08 &&
//        word(0x097BE6) == 0x4f && prev(word(0x097BE6)) < 0x4f
//)

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
            get_player_count() == 1 &&
            dword(0x086658) >= prev(dword(0x086658))
        ) || 
        (
            get_player_count() == 2 &&
            dword(0x086658) >= prev(dword(0x086658)) ||
            dword(0x086bb0) >= prev(dword(0x086bb0))
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
        results_just_popped_up()
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
                measured(dword(0x86658), when=dword(0x1FEF24) == 1),
                // P1 vs 2, P1 won
                measured(dword(0x86658), when=dword(0x1FEF24) == 2 && dword(0x86658) >= dword(0x86bb0)),
                // P1 vs 2, P2 won
                measured(dword(0x86bb0), when=dword(0x1FEF24) == 2 && dword(0x86658) < dword(0x86bb0))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "Shoot to Survive",
    description = "Get the highest score in \"Shoot to Survive\"",
    start =
    (   
        get_minigame() == 0x0c &&
        results_just_popped_up()
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
                measured(dword(0x86658), when=dword(0x1FEF24) == 1),
                // P1 vs 2, P1 won
                measured(dword(0x86658), when=dword(0x1FEF24) == 2 && dword(0x86658) >= dword(0x86bb0)),
                // P1 vs 2, P2 won
                measured(dword(0x86bb0), when=dword(0x1FEF24) == 2 && dword(0x86658) < dword(0x86bb0))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "Boar Bash",
    description = "Get the highest score in \"Boar Bash\"",
    start =
    (   
        get_minigame() == 0x02 &&
        results_just_popped_up()
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
                measured(dword(0x896e4), when=dword(0x1FEF24) == 1),
                // P1 vs 2, P1 won
                measured(dword(0x896e4), when=dword(0x1FEF24) == 2 && dword(0x896e4) >= dword(0x89a2c)),
                // P1 vs 2, P2 won
                measured(dword(0x89a2c), when=dword(0x1FEF24) == 2 && dword(0x896e4) < dword(0x89a2c))
            ),
    format = "VALUE", lower_is_better = false
)

leaderboard(
    title = "Food Feast",
    description = "Get the highest score in \"Food Feast\"",
    start =
    (   
        get_minigame() == 0x07 &&
        results_just_popped_up()
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
                measured(dword(0x081B7C), when=dword(0x1FEF24) == 1),
                // P1 vs 2, P1 won
                measured(dword(0x081B7C), when=dword(0x1FEF24) == 2 && dword(0x081B7C) >= dword(0x082A40)),
                // P1 vs 2, P2 won
                measured(dword(0x082A40), when=dword(0x1FEF24) == 2 && dword(0x081B7C) < dword(0x082A40))
            ),
    format = "VALUE", lower_is_better = false
)

// rich_presence_conditional_display(on_title_screen(), "In the Main Menu")

// Generic competing in x in x mode
rich_presence_conditional_display(!is_in_main_menu(), "Competing in {0} in {1} mode",
    rich_presence_lookup("Game", get_minigame(), minigame_lookup, fallback="Unknown Minigame?"),
    rich_presence_lookup("Mode", get_mode(), mode_lookup, fallback="Unknown mode?")
)

rich_presence_display("In the Main Menu")