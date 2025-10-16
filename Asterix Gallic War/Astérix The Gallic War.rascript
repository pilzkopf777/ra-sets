// Astérix: The Gallic War
// #ID = 18222

function get_minigame() {
    return byte(0x78834)
}

function is_in_strategy_game() {
    // TODO: This is terrible as a reference..
    return get_minigame() == 0x11 || get_minigame() == 0x12 || get_minigame() == 0x13
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

function ingr_logic(count) {
    offset = count * 0x04
    return ptr(tbyte(0x0D22BC), [0xCAB90 + offset, 0x2C], byte) == 2 && prev(ptr(tbyte(0x0D22BC), [0xCAB90 + offset, 0x2C], byte)) == 1
}

INGR_NAME = ["1", "2", "3", "4", "5", "6", "7"]
INGR_DESC = ["1", "2", "3", "4", "5", "6", "7"]

for ingredient in range(0, 6, 1) {
    achievement(
    title = INGR_NAME[ingredient],
    points = 0,
    description = format("Collect {0}", INGR_DESC[ingredient]),
    trigger = 
        ingr_logic(ingredient)
    )
}

achievement(
title = "Throw far",
points = 0,
description = "Throw Roman far",
trigger =
    !is_in_strategy_game() &&
    dword(0x1bcd1c) > 0x00464584 && dword(0x1bcd1c) > prev(dword(0x1bcd1c))
)

leaderboard(
    title = "Throw the Roman!",
    description = "Do it!!",
    start = 
    cancel = 
    submit = always_true(),
    value =
        measured(
    ),
    format = "FRAMES", lower_is_better = false
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
    0x2: "Forest",
    0x3: "Roman Fort",
    0x4: "French Alps",
    0x5: "Carnac",
    0x6: "Pirate Ship",
    0x7: "Aqua",
    0x8: "Narboa",
    0x9: "Rome",
    0x10: "Pirate City",
    0x15: "Minigame???"
}

minigame_character_map = {
    0x2: "Asterix",
    0x3: "Asterix",
    0x4: "Obelix",
    0x5: "Obelix",
    0x6: "Asterix",
    0x7: "Asterix",
    0x8: "Asterix",
    0x9: "Asterix",
    0x10: "Asterix",
    0x15: "Minigame???"
}


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
    rich_presence_lookup("Character", get_minigame(), minigame_character_map, fallback="what?"),
    rich_presence_lookup("Minigame", get_minigame(), minigame_area_names, fallback="what?")
)

rich_presence_display("Wow! Placeholder!")
