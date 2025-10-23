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
    0x30: "throwing Romans"
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
        "name": "",
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
        "name": "",
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
        "potion": 5,
        "coin": 100
    },
    2: {
        "loc": minigame_area_names[0x06],
        "name": "Collectables 2",
        "id": 0x06,
        "potion": 6,
        "coin": 158
    },
    3: {
        "loc": minigame_area_names[0x02],
        "name": "Collectables 3",
        "id": 0x02,
        "potion": 6,
        "coin": 61
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
        "potion": 3,
        "coin": 50
    },
    6: {
        "loc": minigame_area_names[0x05],
        "name": "Collectables 6",
        "id": 0x05,
        "potion": 2,
        "coin": 101
    },
    7: { // pirate ship
        "loc": minigame_area_names[0x04],
        "name": "Collectables 7",
        "id": 0x04,
        "potion": 1,
        "coin": 53
    },
    8: { // rome
        "loc": minigame_area_names[0x07],
        "name": "Collectables 8",
        "id": 0x07,
        "potion": 10,
        "coin": 67
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
        byte(0x083286) == 0x12 && prev(byte(0x083286)) != 0x12
    )
}

for count in range(0, 6, 1) {
    achievement(
    title = COLLECTABLE_MAP[count]["name"],
    points = 10,
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

achievement(
    title = "The Pirate who cried Gaul",
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
        byte(0x083286) == 0x12 && prev(byte(0x083286)) != 0x12
)

achievement(
    title = "rome",
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
        byte(0x083286) == 0x12 && prev(byte(0x083286)) != 0x12
)


roman_throw_distance = ptr(tbyte(0x082ec8), [0x58], dword)
roman_speed_meter = ptr(tbyte(0x082ec8), [0x40], dword)
roman_throw_state = ptr(tbyte(0x082ec8), [0x4c], word)

achievement(
title = "Throw far",
points = 5,
description = "Throw Roman far",
trigger =
    !is_in_strategy_game() &&
    ( get_level() == 0x0a || get_level() == 0x30 ) &&
    in_throw_a_roman() &&
    // 40000 dec * 120 = 0x493E00 target distance
    roman_throw_distance > 0x493E00 && roman_throw_state == 4 && prev(roman_throw_state != 4)
)


leaderboard(
    title = "Throw the Roman!",
    description = "Do it!!",
    start =
    (   
        !is_in_strategy_game() &&
        ( get_level() == 0x0a || get_level() == 0x30 ) &&
        in_throw_a_roman() &&
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
    0x30: "Obelix"
}

// Title
rich_presence_conditional_display(
    on_title_screen() || byte(0x007504) == 0,
    "In the Main Menu"
)

// Fully in Strategy
rich_presence_conditional_display(
    is_in_strategy_game() && !is_in_level(), // && byte(0x083305) == 0x00,
    "Conquering Gaul • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_strategy()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_strategy())
)

// Between loading of strategy and level, data is being moved a lot and partially incorrect.
// Use a mix of the two RP states here to make sure no wrong data is displayed.
rich_presence_conditional_display(
    is_in_strategy_game_alt(), // && is_in_level(), // || byte(0x083305) == 0x10,
    "Conquering Gaul • Gauls ({0}) vs. Romans ({1})",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions_during_level()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions_during_level())
)

// Fully in level
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
