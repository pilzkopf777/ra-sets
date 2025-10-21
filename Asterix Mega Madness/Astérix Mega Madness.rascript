// Astérix: Mega Madness
// #ID = 18223

// $057C6C: [32-bit] Global frame timer
//          Ticks up every frame
function global_frame_timer() => dword(0x057C6C)

// $06AA78: [32-bit] Map ID
//          This ID takes priority for state deduction. If there's multiple minigames, refine via the Game ID
//          
//          0x03 = Main Menu
//          0x02 = Food Feast
//          0x05 = Forest
//          0x06 = Crossbow
function map_id() => dword(0x06AA78)

// $071CA0: [32-bit] Mega Madness Score: Asterix Game 1
function mega_madness_score_asterix_game_1() => dword(0x071CA0)

// $071CA4: [32-bit] Mega Madness Score: Obelix Game 1
function mega_madness_score_obelix_game_1() => dword(0x071CA4)

// $071CA8: [32-bit] Mega Madness Score: Cacofonix Game 1
function mega_madness_score_cacofonix_game_1() => dword(0x071CA8)

// $071CAC: [32-bit] Mega Madness Score: Mrs Geriatrix Game 1
function mega_madness_score_mrs_geriatrix_game_1() => dword(0x071CAC)

// $071CB0: [32-bit] Mega Madness Score: Asterix Game 2
function mega_madness_score_asterix_game_2() => dword(0x071CB0)

// $071CB4: [32-bit] Mega Madness Score: Obelix Game 2
function mega_madness_score_obelix_game_2() => dword(0x071CB4)

// $071CB8: [32-bit] Mega Madness Score: Cacofonix Game 2
function mega_madness_score_cacofonix_game_2() => dword(0x071CB8)

// $071CBC: [32-bit] Mega Madness Score: Mrs Geriatrix Game 2
function mega_madness_score_mrs_geriatrix_game_2() => dword(0x071CBC)

// $071CC0: [32-bit] Mega Madness Score: Asterix Game 3
function mega_madness_score_asterix_game_3() => dword(0x071CC0)

// $071CC4: [32-bit] Mega Madness Score: Obelix Game 3
function mega_madness_score_obelix_game_3() => dword(0x071CC4)

// $071CC8: [32-bit] Mega Madness Score: Cacofonix Game 3
function mega_madness_score_cacofonix_game_3() => dword(0x071CC8)

// $071CCC: [32-bit] Mega Madness Score: Mrs Geriatrix Game 3
function mega_madness_score_mrs_geriatrix_game_3() => dword(0x071CCC)

// $075E4A: [16-bit] Button inputs
function button_inputs() => word(0x075E4A)

// $0760C0: [32-bit] Game ID
//          Together with the Map ID this can be used to identify minigames
//          
//          0x0f = Camp Crashing
//          0x07 = Shield Chase
//          0x0d = Food Feast
//          0x06 = Shoot and Score
//          0x0c = Recipe Run
function game_id() => dword(0x0760C0)

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

// $08EE60: [32-bit] Character
//          0x00 = Obelix
//          0x01 = Asterix
//          0x02 = Mrs Geriatrix
//          0x03 = Cacofonix
function character() => dword(0x08EE60)

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

// $1CADB8: [32-bit] Score in Rowing minigame
function score_in_rowing_minigame() => dword(0x1CADB8)

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
