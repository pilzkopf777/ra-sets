// Donkey Kong Barrel Blast
// #ID = 34755

// $351FA1: [8-bit] Main menu mode selection
//          0x00 = Jungle Grand Prix
//          0x01 = Single Race
//          0x02 = Time Trial
//          0x03 = Free Run
//          0x04 = Candy's Challlenges
//          0x05 = Records
//          0x06 = Options
//          0x07 = Cranky's Flight School
function main_menu_mode_selection() => byte(0x351FA1)

// $352028: [32-bit BE] Character P1
//          0x00 = Donkey Kong
//          0x01 = Diddy Kong
//          0x02 = Dixie Kong
//          0x03 =
//          0x04 =
//          0x05 = Kritter
//          0x06 = Kip
//          0x07 = Kass
//          0x08 =
function character_p1() => dword_be(0x352028)

// $35202C: [32-bit BE] Character P2
//          See 0x00352028 for IDs
function character_p2() => dword_be(0x35202C)

// $352030: [32-bit BE] Character P3
//          See 0x00352028 for IDs
function character_p3() => dword_be(0x352030)

// $352034: [32-bit BE] Character P4
//          See 0x00352028 for IDs
function character_p4() => dword_be(0x352034)

// $352068: [32-bit BE] Candy's Challenges: Selected challenge
//          0xff = None
function candy_s_challenges_selected_challenge() => dword_be(0x352068)

// $3E7BA8: [32-bit BE] Pointer to Gameplay data
//          
//          +0x890 = [8-bit] Pos?
//          +0x8C0 = [8-bit] Pos?
//          +0x2984 = [32-bit BE] Lap
//          +0x2990 = [Float BE] Race time in frames
//          +0x29B4 = [16-bit BE] Position
//          +0x2A40 = [16-bit BE] Bananas collected
//          +0x2A42 = [16-bit BE] Wild Moves available
//          +0x2A44 = [32-bit BE] Current item
//          .0xFFFFFFFF = No item
//          .0x00 = Pineapple Launcher
//          .0x01 = Backward Barrel
//          .0x02 = Banana Fairy
//          .0x03 = Whirlwind
//          .0x04 = Blazing Banana
//          .0x05 = Squawks
//          .0x06 = Quawks
//          .0x07 = Wild Elixer
//          .0x08 = Crystal Coconut
//          .0x09 = Mini-Necky
//          .0x0a = Tasty Melon
//          .0x0b = Mega TNT Barrel
//          .0x0c = Banana Bunch
//          .0x0d = Prop Monkey
//          .0x0e = Mini-Zinger
//          +0x5064 = [32-bit BE] Lap P2
//          +0x5094 = [16-bit BE] Position P2
//          +0x5120 = [16-bit BE] Bananas collected P2
//          +0x5122 = [16-bit BE] Wild Moves available P2
//          +0x5124 = [32-bit BE] Current item P2
//          +0x7744 = [32-bit BE] Lap P3
//          +0x7774 = [16-bit BE] Position P3
//          +0x7800 = [16-bit BE] Bananas collected P3
//          +0x7802 = [16-bit BE] Wild Moves available P3
//          +0x7804 = [32-bit BE] Current item P3
//          +0x9E24 = [32-bit BE] Lap P4
//          +0x9E54 = [16-bit BE] Position P4
//          +0x9EE0 = [16-bit BE] Bananas collected P4
//          +0x9EE2 = [16-bit BE] Wild Moves available P4
//          +0x9EE4 = [32-bit BE] Current item P4
function pointer_to_gameplay_data() => dword_be(0x3E7BA8)

// $4892C8: [32-bit BE] Pointer to current banana combo P1
//          +0x288 = [32-bit BE] Combo value
function pointer_to_current_banana_combo_p1() => dword_be(0x4892C8)

// $48934C: [32-bit BE] Pointer to Combo P1
//          +0x288 = [32-bit BE] Combo value
function pointer_to_combo_p1() => dword_be(0x48934C)

// $535773: [8-bit] Current race track
//          Cannot use this in Mission mode. To get the map consider a map of missions and match the map with that.
//          
//          0x00 = DK Jungle
//          0x01 = DK Jungle Falls
//          0x02 = DK Jungle Sunset
//          0x03 = Salty Sea
//          0x04 = Shimmering Sea
//          0x05 = Open Ocean
//          0x06 = Mt. Dynamite
//          0x07 = Mt. Dynamite Remix
//          0x08 = Dynamite Run
//          0x09 = Cranky's Temple
//          0x0a = Temple Heights
//          0x0b = Cosmic Highway
//          0x0c = Scorching Canyon
//          0x0d = Parched Palace
//          0x0e = Mammoth Glacier
//          0x0f = Alpine Peak
function current_race_track() => byte(0x535773)

// $53861C: [32-bit BE] Pointer to trick count P1
//          +0xE0 = [32-bit BE] Current trick val
function pointer_to_trick_count_p1() => dword_be(0x53861C)
