// Donkey Kong Barrel Blast
// #ID = 34755

// Helper function taken from Souzooka - thanks!
WII_GAME_MASK = 0x1fffffff

function ptr(base, offsets, accessor=dword_be)
{
    val = base
    // Cool masking action in a seperate line
    val = val & WII_GAME_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            // Result also needs to 
            val = val & WII_GAME_MASK
        }
    }
    
    return val
}

class PlayerData
{
    player_id = 0 // 1 through 4

    OFFSET_PLAYER_OBJ = 0x26E0

    function get_character() {
        target_adr = 0x352028 + this.player_id * 0x04 - 0x04
        return dword_be(target_adr)
    }

    function get_item() {
        target_offset = 0x2A44 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be)
    }

    function get_position() {
        target_offset = 0x29B4 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        return ptr(dword_be(0x3e7ba8), [target_offset], word_be)
    }

    function get_lap_time(lap) {
        target_offset_lap1 = 0x2994 + this.player_id * this.OFFSET_PLAYER_OBJ - this.OFFSET_PLAYER_OBJ
        target_offset = target_offset_lap1 + lap * 0x04 - 0x04
        return ptr(dword_be(0x3e7ba8), [target_offset], dword_be)
    }

    function get_total_time() {
        return this.get_lap_time(1) + this.get_lap_time(2) + this.get_lap_time(3)
    }
}

function get_mode() {
    return byte(0x351FA1)
}

mode_map = {
    0x00: "Jungle Grand Prix",
    0x01: "Single Race",
    0x02: "Time Trial",
    0x03: "Free Run",
    0x04: "Candy's Challlenges",
    0x05: "Records",
    0x06: "Options",
    0x07: "Cranky's Flight School"
}

character_map = {
    0x00: "Donkey Kong",
    0x01: "Diddy Kong",
    0x02: "Dixie Kong",
    0x03: "",
    0x04: "",
    0x05: "Kritter",
    0x06: "Kip",
    0x07: "Kass",
    0x08: "",
    0x09: ""
}

function get_candy_challenge_num() {
    return dword_be(0x352068)
}

function get_candy_challenge_page() {
    // todo
    return 0
}

function get_track() {
    return byte(0x535773)
}

track_map = {
    0x00: "DK Jungle",
    0x01: "DK Jungle Falls",
    0x02: "DK Jungle Sunset",
    0x03: "Salty Sea",
    0x04: "Shimmering Sea",
    0x05: "Open Ocean",
    0x06: "Mt. Dynamite",
    0x07: "Mt. Dynamite Remix",
    0x08: "Dynamite Run",
    0x09: "Cranky's Temple",
    0x0a: "Temple Heights",
    0x0b: "Cosmic Highway",
    0x0c: "Scorching Canyon",
    0x0d: "Parched Palace",
    0x0e: "Mammoth Glacier",
    0x0f: "Alpine Peak"
}

player_1_obj = PlayerData(1)

rich_presence_conditional_display(always_true(), "{0} is in {1} on {2}",
    rich_presence_lookup("Character", player_1_obj.get_character(), character_map, fallback="An unknown character"),
    rich_presence_lookup("Mode", get_mode(), mode_map, fallback="an unknown mode"),
    rich_presence_lookup("Track", get_track(), track_map, fallback="an unknown track")
)

rich_presence_display("Playing Donkey Kong Barrel Blast")