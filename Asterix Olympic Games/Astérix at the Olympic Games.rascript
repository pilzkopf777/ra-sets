// Astérix at the Olympic Games
// #ID = 22598

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

olympic_games_main_adr = ptr(dword(0x6cbf78), [0x48], dword)
cutscene_main_adr = ptr(dword(0x6cbf78), [0x12A38], dword)
pause_main_adr = ptr(dword(0x6cbf78), [0x1321C], dword)


function game_has_booted_up() {
    return olympic_games_main_adr != 0x00
}

function is_playing_sports() {
    return current_location == 0x0b
}

function not_in_main_menu() {
    return current_location != 0x00
}



olympic_base_address = ptr(olympic_games_main_adr, [0x5BC], dword) // [32-bit pointer] Olympic Games data
statistics_base_address = ptr(olympic_games_main_adr, [0x40], dword) // used to be 0x0090fd60

current_location = ptr(olympic_games_main_adr, [0x160], dword)
current_sport = ptr(olympic_games_main_adr, [0x12FA], byte)

sports_char_p1 = ptr(olympic_games_main_adr, [0x1220], byte)

multiplier = ptr(olympic_games_main_adr, [0x518], byte)
combo_asterix = ptr(olympic_games_main_adr, [0x530], byte)
combo_obelix = ptr(olympic_games_main_adr, [0x534], byte)
romans_in_sky = ptr(olympic_games_main_adr, [0x544], byte)

hp_remaining = ptr(statistics_base_address, [0x19], byte)
max_hp = ptr(statistics_base_address, [0x1A], byte)

helmets = ptr(statistics_base_address, [0x1C], dword)

glue = ptr(statistics_base_address, [0x2C], byte)
magnesia = ptr(statistics_base_address, [0x2D], byte)

total_pigeons_left = 0
for element in range(0x04, 0x1F4, 0x14) {
    current_pidgeon_adr = ptr(dword(0x92889c), [0x84, element], dword)
    total_pigeons_left = total_pigeons_left + current_pidgeon_adr
}
pigeons = 50 - total_pigeons_left

upgrades_unlocked = ptr(statistics_base_address, [0x3A], bitcount) + ptr(statistics_base_address, [0x3B], bitcount) // 9 in total
movies_unlocked = ptr(statistics_base_address, [0x3C], bitcount) + ptr(statistics_base_address, [0x3D], bitcount) // 16 in total

olympics_score_p1 = ptr(dword(0x6cbd00), [0x41C, 0x18C], dword)
olympics_score_p2 = ptr(dword(0x6cbd00), [0x41C, 0x190], dword)

sport_time_left = ptr(olympic_games_main_adr, [0x4c8, 0x104], float)
sport_countdown_time_left = ptr(olympic_games_main_adr, [0x4c8, 0xec], float)
sport_countdown_step = ptr(olympic_games_main_adr, [0x4c8, 0xf0], byte)

what_player_score_shown = ptr(olympic_games_main_adr, [0x12fb], byte)

sport_p1_won = ptr(olympic_games_main_adr, [0x12fe], byte) == 0x00
sport_p2_won = ptr(olympic_games_main_adr, [0x12fe], byte) == 0x01

enemy_lock_count = ptr(olympic_games_main_adr, [0x550], dword)

game_paused = ptr(pause_main_adr, [0x30]) == 0x01

function coop_is_enabled() {
    return ptr(olympic_games_main_adr, [0x1222], byte) == 0x01
}

function coop_is_disabled() {
    return ptr(olympic_games_main_adr, [0x1222], byte) == 0x00
}

function sport_countdown_started() {
    return sport_countdown_step == 0x00 && sport_countdown_time_left < 0.9 && prev(sport_countdown_time_left >= 0.9) 
}

function sport_started() {
    return sport_countdown_step == 0x02 && prev(sport_countdown_step == 0x01)
}

function sport_ended() {
    return sport_countdown_step == 0x03 && prev(sport_countdown_step == 0x02)
}

function cutscene_started() {
    return ptr(cutscene_main_adr, [0x0C], dword) == 0x01 && prev(ptr(cutscene_main_adr, [0x0C], dword) == 0x00)
}

// TODO: These values are not good at showing the actual prog, using the sliding val is not stable.
music_box_goal = ptr(olympic_games_main_adr, [0x4C0, 0x164], byte)
music_box_prog = ptr(olympic_games_main_adr, [0x4C0, 0x166], byte)

music_goal_sliding_prog = ptr(olympic_games_main_adr, [0x04, 0x1a0, 0x20, 0x38, 0x50, 0x50], float)

function get_value_below_end_of_song() {
    correction_buffer = 0.05
    return 1.0 - (1.0 / music_box_goal) - correction_buffer
}

function completed_music_box() {
    return music_goal_sliding_prog >= get_value_below_end_of_song() && music_box_prog == 0x00 && prev(music_box_prog == music_box_goal - 1)
}

function started_music_box() {
    return music_box_goal != prev(music_box_goal)
}

event_flag_base_address = ptr(olympic_games_main_adr, [0x1D8], dword)

event_flags = {
    "all_disciplines_cleared": ptr(event_flag_base_address, [0x3E8, 0x14], byte) == 0xCF,
    "exited_lair": ptr(event_flag_base_address, [0x464, 0x14], byte) == 0xCF,
    "brutus_door_opened": ptr(event_flag_base_address, [0x4F0, 0x14], byte) == 0xCF,
    "caught_doctor": ptr(event_flag_base_address, [0x50C, 0x14], byte) == 0xCF,
    "opened_doctor_lair_door": ptr(event_flag_base_address, [0x558, 0x14], byte) == 0xCF,
    "opened_vip_zone_door": ptr(event_flag_base_address, [0x56C, 0x14], byte) == 0xCF,
    "back_to_village": ptr(event_flag_base_address, [0x588, 0x14], byte) == 0xCF,
    "opened_door_path_to_lair": ptr(event_flag_base_address, [0x5E4, 0x14], byte) == 0xCF,
    "first_dart_board_done": ptr(event_flag_base_address, [0x5EC, 0x14], byte) == 0xCF,
    "escape_underground": ptr(event_flag_base_address, [0x3D0, 0x14], byte) == 0xCF,
    "win_final_race": ptr(event_flag_base_address, [0x3E4, 0x14], byte) == 0xCF,
    "win_final_laudi_battle": ptr(event_flag_base_address, [0x4BC, 0x14], byte) == 0xCF,
}

achievement(
    title = "CLEAR_CHAPTER_FOREST",
    points = 0,
    description = "Return to forest, go to Olympia",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x01 &&
        event_flags["back_to_village"] && prev(!event_flags["back_to_village"])
    )
)

achievement(
    title = "CLEAR_OLYMPIC_VILLAGE",
    points = 0,
    description = "Clear 1st ambush, open path to road to lair",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x02 &&
        event_flags["opened_door_path_to_lair"] && prev(!event_flags["opened_door_path_to_lair"])
    )
)

achievement(
    title = "CLEAR_PATH_TO_LAIR",
    points = 0,
    description = "Open door to lair",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x03 &&
        event_flags["opened_doctor_lair_door"] && prev(!event_flags["opened_doctor_lair_door"])
    )
)

achievement(
    title = "CLEAR_LAIR",
    points = 0,
    description = "Exit lair",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x09 &&
        event_flags["exited_lair"] && prev(!event_flags["exited_lair"])
    )
)

achievement(
    title = "CLEAR_CATCH_DOC",
    points = 0,
    description = "Caught doc",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x06 &&
        event_flags["caught_doctor"] && prev(!event_flags["caught_doctor"])
    )
)

achievement(
    title = "CLEAR_GET_TO_CITY",
    points = 0,
    description = "Gain access to city from VIP zone",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x04 &&
        event_flags["opened_vip_zone_door"] && prev(!event_flags["opened_vip_zone_door"])
    )
)

achievement(
    title = "CLEAR_GOTO_BRUTUS_DOOR",
    points = 0,
    description = "Open door to Brutus quarters",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x05 &&
        event_flags["brutus_door_opened"] && prev(!event_flags["brutus_door_opened"])
    )
)

achievement(
    title = "CLEAR_ESCAPE_UG",
    points = 0,
    description = "Exit UG area",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x0a &&
        event_flags["escape_underground"] && prev(!event_flags["escape_underground"])
    )
)

achievement(
    title = "CLEAR_WIN_VS_BRUTUS",
    points = 0,
    description = "Win Chariot Race vs Brutus",
    type = "progression",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x0b &&
        event_flags["win_final_race"] && prev(!event_flags["win_final_race"])
    )
)

achievement(
    title = "CLEAR_GAME",
    points = 0,
    description = "Complete final Laudi battle",
    type = "win_condition",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x07 &&
        event_flags["win_final_laudi_battle"] && prev(!event_flags["win_final_laudi_battle"])
    )
)

// SCORE
top_score_targets = {
    0x00: 17200, // long jump
    0x01: 19200, // foot race
    0x02: 21920, // tug of war
    0x03: 21200, // toadball
    0x04: 19850, // kota
    0x05: 22190, // hammer throw
    0x06: 18500, // javelin
    0x07: 21620, // music
    0x08: 19080 // chariot
}

SportLookup = {
    0x00: "the Long Jump",
    0x01: "the Foot Race",
    0x02: "the Tug of War",
    0x03: "Toadball",
    0x04: "King of the Arena",
    0x05: "Hammer Throwing",
    0x06: "the Javelin",
    0x07: "the Romanophone",
    0x08: "the Chariot Race"
}

CleanSportLookup = {
    0x00: "Long Jump",
    0x01: "Foot Race",
    0x02: "Tug of War",
    0x03: "Toadball",
    0x04: "King of the Arena",
    0x05: "Hammer Throwing",
    0x06: "Javelin",
    0x07: "The Romanophone",
    0x08: "Chariot Race"
}

SportCheevoNames = {
    0x00: "Going the Distance",
    0x01: "The Long Road",
    0x02: "Line in the Sand",
    0x03: "Ribbiting Performance",
    0x04:  "",
    0x05: "One Mighty Swing",
    0x06: "",
    0x07: "Virtuoso",
    0x08: ""
}

SportSpecialCheevoNames = {
    0x00: "Boundless",
    0x01: "Walk it out",
    0x02: "For you Mashing Pleasure",
    0x03: "Anti-Amphibian Approach",
    0x04: "Target Hog",
    0x05: "Nailed it",
    0x06: "Pierce the skies",
    0x07: "Hitting all the right notes",
    0x08: ""
}

// Sports where single player at a time
sports_with_single_player_struct = [0x00, 0x05, 0x06]

for element in sports_with_single_player_struct {
    achievement(
        title = format("{0}", SportCheevoNames[element]),
        points = 0,
        description = format("Score {0} or more points in {1} event", top_score_targets[0x00], SportLookup[0x00]),
        trigger = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // if solo: only p1 counts
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                ) ||
                (
                    // if coop: both may score accordingly
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                ) ||
                (
                    // p2 in coop
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p2 != prev(olympics_score_p2) &&
                    // check p2 score
                    olympics_score_p2 >= top_score_targets[element]
                )
            )
        )
    )

    leaderboard(
        title = format("{0}", CleanSportLookup[element]),
        description = format("Score as many points as possible in {0} event", SportLookup[element]),
        start = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // if solo: only p1 counts
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                ) ||
                (
                    // if coop: both may score accordingly
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                ) ||
                (
                    // p2 in coop
                    coop_is_enabled() &&
                    // score updated
                    olympics_score_p2 != prev(olympics_score_p2)
                )
            )
        ),
        cancel = always_false(),
        submit = always_true(),
        value = max_of(
            // if solo: only p1 counts
            measured(olympics_score_p1, when=coop_is_disabled() && what_player_score_shown == 0x00),
            // if coop: both may score accordingly
            measured(olympics_score_p1, when=coop_is_enabled() && what_player_score_shown == 0x00),
            // p2 in coop
            measured(olympics_score_p2, when=coop_is_enabled() && what_player_score_shown == 0x01)
        ),
        format = "VALUE", lower_is_better = true
    )
}

// Sports always vs CPU
sports_with_multi_player_struct = [0x01, 0x02, 0x03, 0x04, 0x07, 0x08]

for element in sports_with_multi_player_struct {
    achievement(
        title = format("{0} Score Achievement", SportCheevoNames[element]),
        points = 0,
        description = format("Score {0} or more points in {1} event playing against as a computer-controlled opponent", top_score_targets[0x00], SportLookup[0x00]),
        trigger = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // only solo is allowed, human is always p1
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1) &&
                    // check p1 score
                    olympics_score_p1 >= top_score_targets[element]
                )
            )
        )
    )

    leaderboard(
        title = format("{0}", CleanSportLookup[element]),
        description = format("Score as many points as possible in {0} event", SportLookup[element]),
        start = 
        (
            game_has_booted_up() &&
            not_in_main_menu() &&
            is_playing_sports() &&
            current_sport == element &&
            sport_countdown_step == 0x02 &&
            (
                (
                    // only solo is allowed, human is always p1
                    coop_is_disabled() &&
                    // score updated
                    olympics_score_p1 != prev(olympics_score_p1)
                )
            )
        ),
        cancel = always_false(),
        submit = always_true(),
        value = (
            // score
            measured(olympics_score_p1)
        ),
        format = "VALUE", lower_is_better = true
    )
}


// SPECIAL SPORTS
long_jump_extensions = ptr(olympic_base_address, [0x26c], float)

achievement(
    title = format("{0}", SportSpecialCheevoNames[0x00]),
    points = 0,
    description = format("Extend your jump three times mid-air by completing the button inputs in the Long Jump event"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        current_sport == 0x00 &&
        // unlock on extension count
        long_jump_extensions == 3.0 && prev(long_jump_extensions == 2.0)
    )
)

foot_race_stretch = ptr(olympic_base_address, [0x3f0], dword)

achievement(
    title = format("{0}", SportSpecialCheevoNames[0x01]),
    points = 0,
    description = format("Win against a computer-controlled opponent without completing the photo finish button inputs in the Foot Race event"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        never(!is_playing_sports()) &&
        coop_is_disabled() &&
        never(current_sport != 0x01) &&
        // reset when playing performs action
        never(foot_race_stretch == 0x01 && prev(foot_race_stretch == 0x00)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

rope_button = ptr(olympic_base_address, [0x16c], byte)

achievement(
    title = format("{0}", SportSpecialCheevoNames[0x02]),
    points = 0,
    description = format("Win against a computer-controlled opponent without the required button input switching to a different one in the Tug of War event"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        never(!is_playing_sports()) &&
        coop_is_disabled() &&
        never(current_sport != 0x02) &&
        // reset when btn input changes
        never(rope_button != prev(rope_button) && sport_time_left < 43.0) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

toadball_score_p1 = ptr(olympic_base_address, [0x1ed], byte)
toadball_score_p2 = ptr(olympic_base_address, [0x1ec], byte)

target = 4
achievement(
    title = format("{0}", SportSpecialCheevoNames[0x03]),
    points = 0,
    description = format("Win against a computer-controlled opponent without ever dropping below {0} points in the Toadball event", target),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        never(!is_playing_sports()) &&
        coop_is_disabled() &&
        never(current_sport != 0x03) &&
        // reset when score falls too low
        never(toadball_score_p1 < target && prev(toadball_score_p1 >= target)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

// KOTA: score mult?
p1_mult = ptr(olympic_base_address, [0x1D4], byte)
p2_mult = ptr(olympic_base_address, [0x1D5], byte)
dart_height = ptr(olympic_base_address, [0x1E8], float)

achievement(
    title = format("{0}", SportSpecialCheevoNames[0x04]),
    points = 0,
    description = format("Win against a computer-controlled opponent while claiming every bonus dart board in the King of the Arena event"),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        never(!is_playing_sports()) &&
        coop_is_disabled() &&
        never(current_sport != 0x04) &&
        // reset when opp steals board
        never(p2_mult == 0x03 && prev(p2_mult == 0x01)) &&
        // reset when board unclaimed
        never(
            dart_height < 12.0 && prev(dart_height >= 12.0) && p1_mult == 0x01 && p2_mult == 0x01
        ) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

// HAMMER: precision
target = 3.90

hammer_nail_precision = ptr(olympic_base_address, [0x284], float)
hammer_throw_status = ptr(olympic_base_address, [0x296], byte)

achievement(
    title = format("{0}", SportSpecialCheevoNames[0x05]),
    points = 0,
    description = format("Score a Nail-on-the-Head bonus multipler of {0} or more in the Hammer Throwing event", target),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        current_sport == 0x05 &&
        hammer_throw_status == 0x06 &&
        hammer_nail_precision >= target && prev(hammer_nail_precision < target)
    )
)

// JAVELIN: x clouds
javelin_clouds_p1 = ptr(olympic_base_address, [0x65C], float)
javelin_clouds_p2 = ptr(olympic_base_address, [0x674], float)

target = 9
target_float = 9.0
achievement(
    title = format("{0}", SportSpecialCheevoNames[0x06]),
    points = 0,
    description = format("Pass the javelin through {0} clouds in one throw in the Javelin throw event", target),
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        is_playing_sports() &&
        current_sport == 0x06 &&
        (
            (
                javelin_clouds_p1 == target_float && prev(javelin_clouds_p1 == target_float - 1.0)
            )
            ||
            (
                coop_is_enabled() &&
                javelin_clouds_p2 == target_float && prev(javelin_clouds_p2 == target_float - 1.0)
            )
        )
    )
)

// MUSIC: no wrong note? -> TODO

p2_hp = ptr(olympic_base_address, [0x24, 0x4B4], float)
p1_hp = ptr(olympic_base_address, [0x24, 0xA0C], float)
half_hp_val = 70.0

// CHARIOT: HP?
achievement(
    title = format("{0}", SportSpecialCheevoNames[0x08]),
    points = 0,
    description = format("Win against a computer-controlled opponent without dropping 70% of your health in the Chariot Race event"),
    trigger = 
    (
        (
            current_sport == 0x08 || current_location == 0x06
        ) &&
        game_has_booted_up() &&
        never(!not_in_main_menu()) &&
        never(current_location == 0xffffffff) &&
        coop_is_disabled() &&
        // reset when low hp
        never(p1_hp < half_hp_val && prev(p1_hp >= half_hp_val)) &&
        // checkpoint on start
        once(sport_countdown_started()) &&
        // unlock on win
        trigger_when(sport_ended() && sport_p1_won) &&
        // reset on lose
        never(sport_ended() && sport_p2_won)
    )
)

// SPECIAL ADV CHALLENGES
/*
achievement(
    title = "CART_DEFENSE",
    points = 0,
    description = "...",
    type = "missable",
    trigger = 
    (
        game_has_booted_up() &&
        never(!not_in_main_menu()) &&
        // switched to area
        once(current_location == 0x08 && prev(current_location == 0xffffffff)) &&
        // correct prev quest..
        event_flags["exited_lair"] &&
        // and no further
        !event_flags["caught_doctor"] &&
        // trigger when cart defended / enemy lock downed
        trigger_when(enemy_lock_count == 0 && prev(enemy_lock_count > 0)) &&
        // deny when cart broken
        never(cutscene_started()) &&
        // death
        never(hp_remaining == 0x00 && prev(hp_remaining > 0x00))
    )
)
*/


// FAST MUSIC BOX
target = 5000
achievement(
    title = "FAST_MUSIC",
    points = 0,
    description = "...",
    type = "missable",
    trigger = 
    (
        game_has_booted_up() &&
        never(!not_in_main_menu()) &&
        once(started_music_box()) &&
        trigger_when(completed_music_box()) &&
        // deny when taken too long
        never(repeated(target, !game_paused)) &&
        // death
        never(hp_remaining == 0x00 && prev(hp_remaining > 0x00))
    )
)



// OTHER STUFF
achievement(
    title = "MOVIES",
    points = 0,
    description = "Purchase every movie in the gallery",
    trigger = 
    (
        game_has_booted_up() &&
        !not_in_main_menu() &&
        measured(movies_unlocked == 16) && prev(movies_unlocked < 16)
    )
)

achievement(
    title = "20_PIGEONS",
    points = 0,
    description = "Rescue 20 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons >= 20) && prev(pigeons < 20)
    )
)

achievement(
    title = "40_PIGEONS",
    points = 0,
    description = "Rescue 40 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons >= 40) && prev(pigeons < 40)
    )
)

achievement(
    title = "50_PIGEONS",
    points = 0,
    description = "Rescue all 50 pigeons",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(pigeons == 50) && prev(pigeons < 50)
    )
)

achievement(
    title = "50_COMBO",
    points = 0,
    description = "Reach a combo of 50 hits",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        (
            combo_obelix >= 50 && prev(combo_obelix < 50) ||
            combo_obelix >= 50 && prev(combo_obelix < 50)
        )
    )
)

achievement(
    title = "40_MULT",
    points = 0,
    description = "Earn a multiplier of 40 or higher",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        multiplier >= 40 && prev(multiplier < 40)
    )
)

achievement(
    title = "ALL_MOVES",
    points = 0,
    description = "Purchase all moves",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        current_location == 0x02 &&
        measured(upgrades_unlocked == 9) && prev(upgrades_unlocked == 8)
    )
)

achievement(
    title = "ALL_GLUE",
    points = 0,
    description = "Collect all glue",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(glue == 3) && prev(glue == 2)
    )
)

achievement(
    title = "ALL_MAGNESIA",
    points = 0,
    description = "Collect all magnesia",
    trigger = 
    (
        game_has_booted_up() &&
        not_in_main_menu() &&
        measured(magnesia == 3) && prev(magnesia == 2)
    )
)


// Rich Presence
WorldLookup = {
    0x00: "in the main menu",
    0x01: "in the Forest of Carnutes",
    0x08: "outside the Olympic Vilage",
    0x02: "inside the Olympic Vilage",
    0x0b: "in the main menu",
    0x03: "on their way to the red cypress trees",
    0x09: "inside Doctormabus' Lair",
    0x06: "chasing Doctormabus",
    0x04: "in the VIP Zone",
    0x05: "in the City",
    0x0a: "in the Catacombs",
    0x07: "facing a horde of Romans"
}

CharLookup = {
    0x00: "Asterix",
    0x01: "Doctormabus",
    0x02: "The Hispanic",
    0x03: "Sam Schieffer",
    0x04: "Obelix",
    0x05: "Gluteus Maximus",
    0x06: "The Egyptian",
    0x07: "The Goth",
    0x08: "Brutus",
    0x09: "The Grecian",
    0x0a: "Getafix",
    0x0b: "Lovestorix"
}


// rich_presence_conditional_display(SAVE_GAME_STATE == 0, "Asterix & Obelix are in the main menu")

rich_presence_conditional_display(game_has_booted_up() && current_location == 0x0b, "{0} is competing in {3} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("Character", sports_char_p1, CharLookup, fallback="An unknown character"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons),
    rich_presence_lookup("Sport", current_sport, SportLookup, fallback="an unknown dicipline")
)

rich_presence_conditional_display(game_has_booted_up() && current_location != 0xffffffff, "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", current_location, WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_conditional_display(game_has_booted_up() && current_location == 0xffffffff, "Asterix & Obelix are {0} • Helmets: {1} • Pigeons: {2} / 50 ",
    rich_presence_lookup("World", prior(current_location), WorldLookup, fallback="in an unknown area"),
    rich_presence_value("Helmets", helmets),
    rich_presence_value("Pigeons", pigeons)
)

rich_presence_display("Playing Asterix at the Olympic Games")
