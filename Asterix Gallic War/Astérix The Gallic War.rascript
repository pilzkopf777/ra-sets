// Astérix: The Gallic War
// #ID = 18222

function get_music() {
    return dword(0x083450)
}

function is_in_strategy_game() {
    // Music ID is a consistent source: Enemy turn themes or the strategy music
    return dword(0x083450) == 0x0b || dword(0x083450) == 0x0c || dword(0x083450) == 0x0d
}

function in_game() {
    // TODO
    // return ...
}

function in_throw_a_roman() {
    return dword(0x082ec8) != 0x00
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

    function get_gaul_regions() {
        return ptr(POINTER_STRATEGY_GAME, [0x334, 0x24, 0x0C], dword)
    }

    function get_rome_regions() {
        return 82 - ptr(POINTER_STRATEGY_GAME, [0x334, 0x24, 0x0C], dword)
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

INGR_NAME  = ["1", "2", "3", "4", "5", "6", "7"]
INGR_DESC  = ["1", "2", "3", "4", "5", "6", "7"]
// TODO which of these actually have ingredients...? two seem to be false..
INGR_LEVEL = [0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa]

for ingredient in range(0, 6, 1) {
    achievement(
    title = INGR_NAME[ingredient],
    points = 0,
    description = format("Collect {0}", INGR_DESC[ingredient]),
    trigger = 
        // Player must be in the correct level
        // Player must enter victory animation with DELTA
        // Cheat mode must be off!
        always_false()
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
    get_music() == 0x0f &&
    in_throw_a_roman() &&
    // 30000 dec * 120 = 0x36EE80 target distance
    trigger_when(roman_throw_distance > 0x36EE80 && roman_throw_state == 4 && prev(roman_throw_state != 4))
)


leaderboard(
    title = "Throw the Roman!",
    description = "Do it!!",
    start =
    (   
        !is_in_strategy_game() &&
        get_music() == 0x0f &&
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

minigame_area_names = {
    0x2: "the Forest",
    0x3: "the Roman Fort",
    0x4: "the French Alps",
    0x5: "Carnac",
    0x6: "on Pirate Ship",
    0x7: "in Aqua",
    0x8: "in Narboa",
    0x9: "in Rome",
    0x0a: "in Pirate City",
    0x0b: "Strategy",
    0x0c: "Strategy",
    0x0d: "Strategy",
    0x0f: "in a Minigame"
}

minigame_character_map = {
    0x02: "Asterix",
    0x03: "Asterix",
    0x04: "Obelix",
    0x05: "Obelix",
    0x06: "Asterix",
    0x07: "Asterix",
    0x08: "Asterix",
    0x09: "Asterix",
    0x0a: "Asterix",
    0x0f: "Minigame???"
}

rich_presence_conditional_display(
    // TODO: ???
    always_false(),
    "On the Title Screen"
)

rich_presence_conditional_display(
    // any strategy music
    get_music() == 0x0b || get_music() == 0x0c || get_music() == 0x0d,
    "Strategizing the next move"
)

rich_presence_conditional_display(
    // not strategy music
    get_music() != 0x0b || get_music() != 0x0c || get_music() != 0x0d,
    "{0} is in {1}",
    rich_presence_lookup("Character", get_music(), minigame_character_map, fallback="what?"),
    rich_presence_lookup("Minigame", get_music(), minigame_area_names, fallback="what?")
)

/*
rich_presence_conditional_display(
    is_in_strategy_game(),
    "Strategizing the next move • Gauls ({0}) vs. Romans ({1}) • {2} / 7 Ingredients",
    rich_presence_value("Gaul Regions", strategy_game_obj.get_gaul_regions()),
    rich_presence_value("Rome Regions", strategy_game_obj.get_rome_regions()),
    rich_presence_value("Ingredients", strategy_game_obj.get_amount_of_ingredients_gathered())
)

rich_presence_conditional_display(
    !is_in_strategy_game(),
    "{3} is in {4} • Gauls ({0}) vs. Romans ({1}) • {2} / 7 Ingredients",
    rich_presence_value("Gaul Regions", prior(strategy_game_obj.get_gaul_regions())),
    rich_presence_value("Rome Regions", prior(strategy_game_obj.get_rome_regions())),
    rich_presence_value("Ingredients", prior(strategy_game_obj.get_amount_of_ingredients_gathered())),
    // rich_presence_value("Character", get_minigame_character()),
    rich_presence_lookup("Character", get_scene(), minigame_character_map, fallback="what?"),
    rich_presence_lookup("Minigame", get_scene(), minigame_area_names, fallback="what?")
)
*/

rich_presence_display("Getting ready to bash Romans...")
