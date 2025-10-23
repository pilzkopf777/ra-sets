// Astérix: The Gallic War
// #ID = 18222

// This state uses the music (also set when muted)
//function is_in_strategy_game() {
//    return byte(0x083450) == 0x0b || byte(0x083450) == 0x0c || byte(0x083450) == 0x0d
//}

// This state uses the strategy game ID
//function is_in_strategy_game_alt() {
//    return byte(0x07e3d4) == 0xa0
//}

//function is_in_level() {
//    return byte(0x07e350) != 1
//}

function get_level() {
    return byte(0x083ADE)
}

function on_title_screen() {
    return byte(0x087EB4) == 0xff || byte(0x089ABC) == 0x00
}

function is_cheating() {
    return byte(0x0830E8) == 1
}

function get_difficulty() {
    return byte(0x083AA0)
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

POINTER_STRATEGY_GAME = tbyte(0x1ff5fc)


class Character {
    function get_hp() {
        return byte(0x89dac)
    }

    function get_action() {
        return byte(0x89d76)
    }

    function is_performing_victory_dance() {
        this.get_action() == 0x12
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
    // TODO: How many?
    TOTAL_REGIONS = 82

    ingredients_gathered = 0

    function get_gaul_regions_during_strategy() {
        // return ptr(POINTER_STRATEGY_GAME, [0xE54, 0x0C], dword)
        return byte(0x11e7fc)
    }

    function get_rome_regions_during_strategy() {
        // return TOTAL_REGIONS - ptr(POINTER_STRATEGY_GAME, [0xE54, 0x0C], dword)
        return TOTAL_REGIONS - byte(0x11e7fc)
    }

 //   function get_gaul_regions_during_level() {
 //       // TODO: Where?
 //       return byte(0x0d330c)
 //   }

 //   function get_rome_regions_during_level() {
 //       // TODO: Where?
 //       return TOTAL_REGIONS - byte(0x0d330c)
 //   }
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
    0: { // forest
        "loc": minigame_area_names[0x00],
        "name": "Collectables 0",
        "id": 0x00,
        "potion": 8,
        "coin": 181
    },
    1: { // roman camp
        "loc": minigame_area_names[0x01],
        "name": "Collectables 1",
        "id": 0x01,
        "potion": 5,
        "coin": 100
    },
    2: { // narboa
        "loc": minigame_area_names[0x06],
        "name": "Collectables 2",
        "id": 0x06,
        "potion": 6,
        "coin": 158
    },
    3: { // alps
        "loc": minigame_area_names[0x02],
        "name": "Collectables 3",
        "id": 0x02,
        "potion": 6,
        "coin": 61
    },
    4: { // carnac
        "loc": minigame_area_names[0x03],
        "name": "Collectables 4",
        "id": 0x03,
        "potion": 4,
        "coin": 42
    },
    5: { // pirate city
        "loc": minigame_area_names[0x08],
        "name": "Collectables 5",
        "id": 0x08,
        "potion": 3,
        "coin": 50
    },
    6: { // aquae
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