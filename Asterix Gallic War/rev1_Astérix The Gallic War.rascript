// Astérix: The Gallic War
// #ID = 18222

POINTER_STRATEGY_GAME = tbyte(0x1ff5fc)

// This state uses the music (also set when muted)
function is_in_strategy_game() {
    return tbyte(0x07e9b4) != 0x00
}

// This state uses the strategy game ID
function is_in_strategy_game_alt() {
    return byte(0x083ad8) == 0xa0
}

function is_in_level() {
    return byte(0x083a3e) == 0x01
}

function get_level() {
    return byte(0x083ADE)
}

function on_title_screen() {
    return byte(0x087EB4) == 0xff && byte(0x089ABC) == 0x00
}

function in_free_play() {
    return byte(0x087EB4) == 0xff
}

function is_cheating() {
    return byte(0x0830E8) == 1
}

function get_difficulty() {
    return byte(0x083AA0)
}

function minigame_time_just_ended() {
    return byte(0x088a80) == 0 && word(0x087f02) == 0 && prev(word(0x087f02)) == 1
}

function boot_up_sony_screens() {
    return dword(0x05ae80) == 0x796e6f53
}


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

class Character {
    function get_hp() {
        return byte(0x89dac)
    }

    function get_action() {
        return byte(0x89d76)
    }

    function is_performing_victory_dance() {
        return this.get_action() == 0x12
    }

    function get_coins() {
        return byte(0x89f0e)
    }

    function get_cauldrons() {
        return byte(0x89f0a)
    }

    function collected_all_items_in_stage() {
        return this.get_coins() == 100 && this.get_cauldrons() == 5
    }

    function get_x() {
        return dword(0x89d58)
    }

    function get_y() {
        return dword(0x89d5c)
    }

    function get_z() {
        return dword(0x89d60)
    }
}


class StrategyGame {
    TOTAL_REGIONS = 53
    PC_PORT_OFFSET = 29

    ingredients_gathered = 0

    function get_gaul_regions_during_strategy() {
        return ptr(POINTER_STRATEGY_GAME, [0xE54, 0x0C], dword) - this.PC_PORT_OFFSET
        // return byte(0x11e7fc)
    }

    function get_rome_regions_during_strategy() {
        gaul_ct = ptr(POINTER_STRATEGY_GAME, [0xE54, 0x0C], dword) - this.PC_PORT_OFFSET
        return this.TOTAL_REGIONS - gaul_ct
        // return TOTAL_REGIONS - byte(0x11e7fc)
    }

    function get_gaul_regions_during_level() {
        return byte(0x0d946c) - this.PC_PORT_OFFSET
    }
    function get_rome_regions_during_level() {
        gaul_ct = byte(0x0d946c) - this.PC_PORT_OFFSET
        return this.TOTAL_REGIONS - gaul_ct
    }
}

strategy_game_obj = StrategyGame()
player = Character()


minigame_area_names = {
    0x00: "in the Forest",
    0x01: "in the Roman Fort",
    0x02: "in the French Alps",
    0x03: "in Carnac",
    0x04: "in on the Pirate Ship",
    0x05: "in Aquae Calidae",
    0x06: "in Narboa",
    0x07: "in Rome",
    0x08: "in Pirate City",
    0x0a: "throwing Romans",
    0x20: "breaking barrels",
    0x30: "throwing Romans",
    0x60: "whacking Romans",
    0x70: "bowling Romans"
}

INGR_ACHIEVEMENT_MAP = {
    0: {
        // forest
        "item": "a branch of mistletoe",
        "loc": minigame_area_names[0x00],
        "name": "Toe to Toe",
        "id": 0x00
    },
    1: {
        // roman camp
        "item": "a Roman standard",
        "loc": minigame_area_names[0x01],
        "name": "Sending a Message",
        "id": 0x01
    },
    2: {
        // narboa
        "item": "an amphora of wine",
        "loc": minigame_area_names[0x06],
        "name": "Bottoms up!",
        "id": 0x06
    },
    3: {
        // alps
        "item": "an edelweiss flower",
        "loc": minigame_area_names[0x02],
        "name": "Snow Joke for a Gaul",
        "id": 0x02
    },
    4: {
        // carnac
        "item": "a mini-menhir",
        "loc": minigame_area_names[0x03],
        "name": "Business Opportunity",
        "id": 0x03
    },
    5: {
        // pirate city
        "item": "the pirates' gold",
        "loc": minigame_area_names[0x08],
        "name": "No Rock Oil This Time",
        "id": 0x08
    },
    6: {
        // aquae
        "item": "bath salts",
        "loc": minigame_area_names[0x05],
        "name": "Still Don't Know Where Alesia Is",
        "id": 0x05
    }
}

COLLECTABLE_MAP = {
    0: { // forest
        "loc": minigame_area_names[0x00],
        "name": "Conquering the Forest",
        "id": 0x00
    },
    1: { // roman camp
        "loc": minigame_area_names[0x01],
        "name": "Conquering the Roman Fort",
        "id": 0x01
    },
    2: { // narboa
        "loc": minigame_area_names[0x06],
        "name": "Conquering Narboa",
        "id": 0x06
    },
    3: { // alps
        "loc": minigame_area_names[0x02],
        "name": "Conquering the French Alps",
        "id": 0x02
    },
    4: { // carnac
        "loc": minigame_area_names[0x03],
        "name": "Conquering Carnac",
        "id": 0x03
    },
    5: { // pirate city
        "loc": minigame_area_names[0x08],
        "name": "Conquering Pirate City",
        "id": 0x08
    },
    6: { // aquae
        "loc": minigame_area_names[0x05],
        "name": "Conquering Aquae Calidae",
        "id": 0x05
    },
    7: { // pirate ship
        "loc": minigame_area_names[0x04],
        "name": "Conquering the Pirate Ship",
        "id": 0x04
    },
    8: { // rome
        "loc": minigame_area_names[0x07],
        "name": "Conquering Rome",
        "id": 0x07
    },
}


for count in range(0, 6, 1) {
    achievement(
    title = INGR_ACHIEVEMENT_MAP[count]["name"],
    points = 5,
    type = "progression",
    description = format("Collect {0} {1}", INGR_ACHIEVEMENT_MAP[count]["item"], INGR_ACHIEVEMENT_MAP[count]["loc"]),
    trigger = 
        !is_in_strategy_game() &&
        // Correct map
        get_level() == INGR_ACHIEVEMENT_MAP[count]["id"] &&
        // No cheating!
        !is_cheating() &&
        // Victory animation
        player.is_performing_victory_dance() && prev(!player.is_performing_victory_dance())
    )
}

for count in range(0, 8, 1) {
    achievement(
    title = COLLECTABLE_MAP[count]["name"],
    points = 10,
    description = format("Collect all gold coins and potions in {0}", COLLECTABLE_MAP[count]["loc"]),
    trigger = 
        // Correct map
        get_level() == COLLECTABLE_MAP[count]["id"] &&
        // No cheating!
        !is_cheating() &&
        // Got all potions and coins?
        player.collected_all_items_in_stage() &&
        prev(!player.collected_all_items_in_stage())
    )
}

achievement(
    title = "The Pirate Who Cried Gaul",
    points = 10,
    type = "progression",
    description = "Take over the Pirate Ship",
    trigger = 
        !is_in_strategy_game() &&
        // Correct map
        get_level() == 0x04 &&
        // No cheating!
        !is_cheating() &&
        // Victory animation
        player.is_performing_victory_dance() && prev(!player.is_performing_victory_dance())
)

achievement(
    title = "Go Home, Caesar",
    points = 25,
    type = "win_condition",
    description = "Collect the laurels in Rome and complete the recipe",
    trigger = 
        !is_in_strategy_game() &&
        // Correct map
        get_level() == 0x07 &&
        // No cheating!
        !is_cheating() &&
        // Victory animation
        player.is_performing_victory_dance() && prev(!player.is_performing_victory_dance())
)

roman_throw_distance = ptr(tbyte(0x089a0c), [0x58], dword)
roman_speed_meter = ptr(tbyte(0x089a0c), [0x40], dword)
roman_throw_state = ptr(tbyte(0x089a0c), [0x4c], word)


achievement(
title = "Aerodynamic Armor",
points = 5,
description = "In \"Throw the Roman\" throw the Roman 40,000 or more units away",
trigger =
    !is_in_strategy_game() && is_in_level() &&
    ( get_level() == 0x0a || get_level() == 0x30 ) &&
    // 40000 dec * 120 = 0x493E00 target distance
    roman_throw_distance > 0x493E00 && roman_throw_state == 4 && prev(roman_throw_state != 4)
)


leaderboard(
    title = "Throw the Roman!",
    description = "Throw the Roman as far as you can in \"Throw the Roman\"",
    start =
    (   
        !is_in_strategy_game() && is_in_level() &&
        ( get_level() == 0x0a || get_level() == 0x30 ) &&
        // Do not submit scores that failed -> you need 2 units at least..
        roman_throw_distance / 120 > 1 && 
        roman_throw_state == 4 && prev(roman_throw_state != 4)
    ),
    cancel = 
    (
        always_false()
    ),
    submit = 
    (
        always_true()
    ),
    value =
    (
        // Divide by value so the units look a tad better...
        measured(roman_throw_distance / 120)
    ),
    format = "VALUE", lower_is_better = false
)

achievement(
title = "Rolling Thunder",
points = 5,
description = "In \"Bowl a Roman\" hit three Romans with a single ball",
trigger =
    !is_in_strategy_game() && is_in_level() &&
    get_level() == 0x70 &&
    byte(0x17be76) == 3 && prev(byte(0x17be76)) == 2
)

achievement(
title = "Strike!",
points = 5,
description = "In \"Bowl a Roman\" score 50 or more points",
trigger =
    !is_in_strategy_game() && is_in_level() &&
    get_level() == 0x70 &&
    byte(0x17bd62) >= 50 && prev(byte(0x17bd62)) < 50
)

leaderboard(
    title = "Bowl a Roman!",
    description = "Score as high as you can in \"Bowl a Roman\"",
    start =
    (   
        !is_in_strategy_game() && is_in_level() &&
        ( get_level() == 0x70 || get_level() == 0x70 ) &&
        minigame_time_just_ended()
    ),
    cancel = 
    (
        always_false()
    ),
    submit = 
    (
        always_true()
    ),
    value =
    (
        measured(byte(0x17bd62))
    ),
    format = "VALUE", lower_is_better = false
)

achievement(
title = "Menhir Menace",
points = 5,
description = "In \"Whack a Roman\" score 60 or more points",
trigger =
    !is_in_strategy_game() && is_in_level() &&
    get_level() == 0x60 &&
    byte(0x1d156a) >= 60 && prev(byte(0x1d156a)) < 60
)

leaderboard(
    title = "Whack a Roman!",
    description = "Score as high as you can in \"Whack a Roman\"",
    start =
    (   
        !is_in_strategy_game() &&
        get_level() == 0x60 &&
        minigame_time_just_ended()
    ),
    cancel = 
    (
        always_false()
    ),
    submit = 
    (
        always_true()
    ),
    value =
    (
        measured(byte(0x1d156a))
    ),
    format = "VALUE", lower_is_better = false
)


minigame_character_map = {
    0x00: "Asterix",
    0x01: "Asterix",
    0x02: "Obelix",
    0x03: "Obelix",
    0x04: "Asterix",
    0x05: "Asterix",
    0x06: "Asterix",
    0x07: "Asterix",
    0x08: "Asterix",
    0x09: "Obelix",
    0x20: "Asterix",
    0x30: "Obelix",
    0x60: "Obelix",
    0x70: "Obelix"
}

// Title
rich_presence_conditional_display(
    on_title_screen() || boot_up_sony_screens(),
    "In the Main Menu"
)

// Free Play
rich_presence_conditional_display(
    in_free_play() && is_in_level(),
    "{0} is {1} • Free Play",
    rich_presence_lookup("Character", get_level(), minigame_character_map, fallback="A stranger"),
    rich_presence_lookup("Minigame", get_level(), minigame_area_names, fallback="an unknown place")
)

// From Strategy to Level, showing HP bonus
rich_presence_conditional_display(
    is_in_strategy_game() && strategy_game_obj.get_gaul_regions_during_level() == -29,
    "Conquering Gaul • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level())
)

// Strategy
rich_presence_conditional_display(
    is_in_strategy_game(),
    "ALT Conquering Gaul • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level())
)

// From Strategy to Level, Loading
rich_presence_conditional_display(
    is_in_strategy_game() && strategy_game_obj.get_gaul_regions_during_level() == -29,
    "ALT {2} is {3} • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_strategy()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_strategy()),
    // rich_presence_value("Character", get_minigame_character()),
    rich_presence_lookup("Character", get_level(), minigame_character_map, fallback="A stranger"),
    rich_presence_lookup("Minigame", get_level(), minigame_area_names, fallback="an unknown place")
)

// In Level
rich_presence_conditional_display(
    !is_in_strategy_game() && is_in_level(),
    "{2} is {3} • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level()),
    // rich_presence_value("Character", get_minigame_character()),
    rich_presence_lookup("Character", get_level(), minigame_character_map, fallback="A stranger"),
    rich_presence_lookup("Minigame", get_level(), minigame_area_names, fallback="an unknown place")
)


rich_presence_display("Getting ready to bash Romans...")
