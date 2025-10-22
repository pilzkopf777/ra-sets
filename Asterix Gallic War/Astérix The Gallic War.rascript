// Astérix: The Gallic War
// #ID = 18222


// The next two functions are both used for the RP.
// This is needed since values update at different times when entering vs exiting the strategy game map.
// With this solution, incorrect data is not displayed. 

// This state uses the music (also set when muted)
function is_in_strategy_game() {
    return byte(0x083450) == 0x0b || byte(0x083450) == 0x0c || byte(0x083450) == 0x0d
}

// This state uses the strategy game ID
function is_in_strategy_game_alt() {
    return byte(0x07e3d4) == 0xa0
}

function is_in_level() {
    return byte(0x07e350) != 1
}

function get_level() {
    return byte(0x07e3da)
}

function current_demo() {
    return byte(0x07e353)
}

function on_title_screen() {
    return byte(0x082b1c) == 0xff || byte(0x082e94) == 0x00
}

function in_throw_a_roman() {
    return dword(0x082ec8) != 0x00
}

function is_cheating() {
    return byte(0x07eaa8) == 1
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

POINTER_STRATEGY_GAME = tbyte(0x07e2e0)


class Region {
    team = 0
    units = 0

    function get_team() {
        return this.team
    }

    function get_units() {
        return this.units
    }
}

class StrategyGame {
    TOTAL_REGIONS = 82

    ingredients_gathered = 0

    function get_gaul_regions_during_strategy() {
        return ptr(POINTER_STRATEGY_GAME, [0x334, 0x24, 0x0C], dword)
    }

    function get_rome_regions_during_strategy() {
        return 82 - ptr(POINTER_STRATEGY_GAME, [0x334, 0x24, 0x0C], dword)
    }

    function get_gaul_regions_during_level() {
        return byte(0x0d330c)
    }

    function get_rome_regions_during_level() {
        return 82 - byte(0x0d330c)
    }

    function get_amount_of_ingredients_gathered() {
        obj_regions_array = []
        for element in range(0, 6, 1) {
            offset = 0xCAB90 + element * 0x04
            region_base = ptr(POINTER_STRATEGY_GAME, [0x334, offset], tbyte)
            array_push(obj_regions_array, region_base)
        }

        return sum_of(obj_regions_array, base_adr => ptr(base_adr, [0x2C], byte) - 1)
        // return ptr(obj_regions_array[0], [0x2C], byte)
    }
}

strategy_game_obj = StrategyGame()

minigame_area_names = {
    0x00: "the Forest",
    0x01: "the Roman Fort",
    0x02: "the French Alps",
    0x03: "Carnac",
    0x04: "on Pirate Ship",
    0x05: "Aquae Calidae",
    0x06: "Narboa",
    0x07: "Rome",
    0x08: "Pirate City",
    0x0a: "Throw a Roman"
}

INGR_ACHIEVEMENT_MAP = {
    0: {
        // forest
        "item": "a branch of mistletoe",
        "loc": minigame_area_names[0x00],
        "name": "0",
        "id": 0x00
    },
    1: {
        // roman camp
        "item": "a Roman standard",
        "loc": minigame_area_names[0x01],
        "name": "1",
        "id": 0x01
    },
    2: {
        // narboa
        "item": "an amphora of wine",
        "loc": minigame_area_names[0x06],
        "name": "2",
        "id": 0x06
    },
    3: {
        // alps
        "item": "an edelweiss flower",
        "loc": minigame_area_names[0x02],
        "name": "3",
        "id": 0x02
    },
    4: {
        // carnac
        "item": "a mini-menhir",
        "loc": minigame_area_names[0x03],
        "name": "4",
        "id": 0x03
    },
    5: {
        // pirate city
        "item": "the pirates' gold",
        "loc": minigame_area_names[0x08],
        "name": "5",
        "id": 0x08
    },
    6: {
        // aquae
        "item": "bath salts",
        "loc": minigame_area_names[0x05],
        "name": "6",
        "id": 0x05
    }
}

COLLECTABLE_MAP = {
    0: {
        "loc": minigame_area_names[0x00],
        "name": "Collectables 0",
        "id": 0x00,
        "potion": 8,
        "coin": 181
    },
    1: {
        "loc": minigame_area_names[0x01],
        "name": "Collectables 1",
        "id": 0x01,
        "potion": 99,
        "coin": 99
    },
    2: {
        "loc": minigame_area_names[0x06],
        "name": "Collectables 2",
        "id": 0x06,
        "potion": 99,
        "coin": 99
    },
    3: {
        "loc": minigame_area_names[0x02],
        "name": "Collectables 3",
        "id": 0x02,
        "potion": 99,
        "coin": 99
    },
    4: {
        "loc": minigame_area_names[0x03],
        "name": "Collectables 4",
        "id": 0x03,
        "potion": 4,
        "coin": 42
    },
    5: {
        "loc": minigame_area_names[0x08],
        "name": "Collectables 5",
        "id": 0x08,
        "potion": 99,
        "coin": 99
    },
    6: {
        "loc": minigame_area_names[0x05],
        "name": "Collectables 6",
        "id": 0x05,
        "potion": 99,
        "coin": 99
    }
}

for count in range(0, 6, 1) {
    achievement(
    title = INGR_ACHIEVEMENT_MAP[count]["name"],
    points = 0,
    description = format("Collect {0} in {1}", INGR_ACHIEVEMENT_MAP[count]["item"], INGR_ACHIEVEMENT_MAP[count]["loc"]),
    trigger = 
        // Correct map
        get_level() == INGR_ACHIEVEMENT_MAP[count]["id"] &&
        // No cheating!
        !is_cheating() &&
        // Victory animation
        byte(0x083286) == 0x12 && prev(byte(0x083286)) != 0x12
    )
}

for count in range(0, 6, 1) {
    achievement(
    title = COLLECTABLE_MAP[count]["name"],
    points = 0,
    description = format("Collect all gold coins and potions in {0}", COLLECTABLE_MAP[count]["loc"]),
    trigger = 
        // Correct map
        get_level() == INGR_ACHIEVEMENT_MAP[count]["id"] &&
        // No cheating!
        !is_cheating() &&
        // Got all potions and coins?
        byte(0x08341a) == COLLECTABLE_MAP[count]["potion"] && byte(0x08341e) == COLLECTABLE_MAP[count]["coin"] &&
        (
            prev(byte(0x08341a)) == COLLECTABLE_MAP[count]["potion"] - 1 || prev(byte(0x08341e)) == COLLECTABLE_MAP[count]["coin"] - 1
        )
    )
}

roman_throw_distance = ptr(tbyte(0x082ec8), [0x58], dword)
roman_speed_meter = ptr(tbyte(0x082ec8), [0x40], dword)
roman_throw_state = ptr(tbyte(0x082ec8), [0x4c], word)

achievement(
title = "Throw far",
points = 0,
description = "Throw Roman far",
trigger =
    !is_in_strategy_game() &&
    get_level() == 0x0a &&
    in_throw_a_roman() &&
    // 30000 dec * 120 = 0x36EE80 target distance
    roman_throw_distance > 0x36EE80 && roman_throw_state == 4 && prev(roman_throw_state != 4)
)


leaderboard(
    title = "Throw the Roman!",
    description = "Do it!!",
    start =
    (   
        !is_in_strategy_game() &&
        get_level() == 0x0a &&
        in_throw_a_roman() &&
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
title = "debug",
points = 0,
description = "debug",
trigger =
    always_false()
    // strategy_game_obj.get_amount_of_ingredients_gathered()
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
    0x09: "Minigame???"
}

// Title
rich_presence_conditional_display(
    on_title_screen() || byte(0x007504) == 0,
    "In the Main Menu"
)

// Fully in Strategy
rich_presence_conditional_display(
    is_in_strategy_game() && !is_in_level(), // && byte(0x083305) == 0x00,
    "Strategizing the next move • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_strategy()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_strategy())
)

// Between loading of strategy and level, data is being moved a lot and partially incorrect.
// Use a mix of the two RP states here to make sure no wrong data is displayed.
rich_presence_conditional_display(
    is_in_strategy_game_alt(), // && is_in_level(), // || byte(0x083305) == 0x10,
    "Strategizing the next move • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level())
)

// Fully in level
rich_presence_conditional_display(
    !is_in_strategy_game() && is_in_level(),
    "{2} is in {3} • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level()),
    // rich_presence_value("Character", get_minigame_character()),
    rich_presence_lookup("Character", get_level(), minigame_character_map, fallback="A stranger"),
    rich_presence_lookup("Minigame", get_level(), minigame_area_names, fallback="an unknown place")
)


rich_presence_display("Getting ready to bash Romans...")
