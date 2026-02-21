// Nights: Journey of Dreams
// #ID = 7870

function game_over_while_on_foot() {
    return byte(0x104496E6) == 0 && byte(0x104496EA) == 1 && prev(byte(0x104496EA)) == 0
}

function game_over_while_dualized() {
    return byte(0x104496E6) == 1 && byte(0x104496F0) == 1 && prev(byte(0x104496F0)) == 0
}

class WorldData {
    offset = 0xD8
    order = 0
    start_adr = 0x005bce48

    function get_level() {
        target_adr = this.start_adr + this.offset * this.order
        return dword_be(target_adr)
    }

    function is_in_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) <= 0x03
    }

    function in_victory_animation() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x02
    }

    function just_won_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x02 && prev(this.is_in_level())
    }

    function just_failed_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x03 && prev(this.is_in_level())
    }

    function just_quit_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x04 && prev(this.is_in_level())
    }

    function dream_gate_only_in_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x00
    }
}

dream_gate_obj = WorldData(order=0)

pure_valley_obj = WorldData(order=2)
pure_valley_boss_obj = WorldData(order=3)
lost_park_obj = WorldData(order=4)
lost_park_boss_obj = WorldData(order=5)
delight_city_obj = WorldData(order=6)
delight_city_boss_obj = WorldData(order=7)

aqua_garden_obj = WorldData(order=8)
aqua_garden_boss_obj = WorldData(order=9)
crystal_castle_obj = WorldData(order=10)
crystal_castle_boss_obj = WorldData(order=11)
memory_forest_obj = WorldData(order=12)
memory_forest_boss_obj = WorldData(order=13)

bellbridge_obj = WorldData(order=14)
bellbridge_boss_obj = WorldData(order=15)

mydream_obj = WorldData(order=28)

function is_not_in_any_level() {
    return !dream_gate_obj.is_in_level() &&
    !pure_valley_obj.is_in_level() && !pure_valley_boss_obj.is_in_level() &&
    !lost_park_obj.is_in_level() && !lost_park_boss_obj.is_in_level() &&
    !delight_city_obj.is_in_level() && !delight_city_boss_obj.is_in_level() &&
    !aqua_garden_obj.is_in_level() && !aqua_garden_boss_obj.is_in_level() &&
    !crystal_castle_obj.is_in_level() && !crystal_castle_boss_obj.is_in_level() &&
    !memory_forest_obj.is_in_level() && !memory_forest_boss_obj.is_in_level() &&
    !bellbridge_obj.is_in_level() && !bellbridge_boss_obj.is_in_level() &&
    !mydream_obj.is_in_level()
}

world_data_map = {
    "Pure Valley": 
    {
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Link Challenge",
            0x02: "Fluffy Catch",
            0x03: "River Rescue"
        },
        "id": "1000",
    },
    "Pure Valley Boss": {
        "levels":
        {
            0x01: "vs. Donbalon"
        },
        "id": "1010"
    },
    "Lost Park":
    {
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Bomb Panic",
            0x02: "Link Challenge",
            0x03: "Coaster Rescue"
        },
        "id": "1100",
    },
    "Lost Park Boss": {
        "levels":
        {
            0x01: "vs. Chamelan"
        },
        "id": "1110"
    },
    "Delight City":
    {
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Neon City Battle",
            0x02: "Link Challenge",
            0x03: "Broadway Guide"
        },
        "id": "1200",
    },
    "Delight City Boss":
    {
        "levels":
        {
            0x01: "vs. Cerberus"
        },
        "id": "1210",
    },
    "Aqua Garden":
    {
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Aqua Challenge",
            0x02: "Link Challenge",
            0x03: "Marine Escape"
        },
        "id": "2000",
    },
    "Aqua Garden Boss":
    {
        "levels":
        {
            0x01: "vs. Girania"
        },
        "id": "2012",
    },
    "Crystal Castle": 
    {
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Link Challenge",
            0x02: "Labyrinth Guide",
            0x03: "Jewel Fever"
        },
        "id": "2100",
    },
    "Crystal Castle Boss":
    {
        "levels":
        {
            0x01: "vs. Bomamba"
        },
        "id": "2110",
    },
    "Memory Forest":
    {
        "id": "2200",
        "levels":
        {
            0x00: "Chase Mission",
            0x01: "Forest Adventure",
            0x02: "Link Challenge",
            0x03: "Sky Concert"
        },
    },
    "Memory Forest Boss":
    {
        "levels":
        {
            0x01: "vs. Queen Bella"
        },
        "id": "2210",
    },
    "Bellbridge":
    {
        "levels":
        {
            0x00: "Chase Mission"
        },
        "id": "3000",
    },
    "Bellbridge Boss":
    {
        "levels":
        {
            0x00: "vs. Wizeman"
        },
        "id": "3010",
    },
    "My Dream": {
        "id": "am" // Cut off from MyDream
    }
}

function is_in_world(world_name) {
    world_adr = 0x11b68136
    world_id = world_data_map[world_name]["id"]

    return ascii_string_equals(world_adr, world_id)
}

function on_title() {
    // return ascii_string_equals(0x11b68131, "Title")
    return dword_be(0x11b6861c) == 0x01
}

function on_staff_roll() {
    return ascii_string_equals(0x11b68131, "StaffRoll") 
}

function get_current_character() {
    return bit0(0x005bce4b)
}

function is_will() {
    return get_current_character() == 0x00
}

function is_helen() {
    return get_current_character() == 0x01
}

char_map = {
    0x00: "Will",
    0x01: "Helen"
}

function in_vs_race_mode() {
    return dword_be(0x005bdba4) != 0x00 || dword_be(0x005bdd54) != 0x00 || dword_be(0x005be414) != 0x00
}

function in_vs_battle_mode() {
    return dword_be(0x005bdf04) != 0x00 || dword_be(0x005be0b4) != 0x00 || dword_be(0x005be264) != 0x00
}

function in_multiplayer_mode() {
    return in_vs_battle_mode() || in_vs_battle_mode()
}

function on_initial_boot_no_string() {
    return dword_be(0x11b68131) == 0x00
}

function chase_final_score_is_set() {
    return dword_be(0x12d6d6a8) > 0
}

function chase_get_final_score() {
    return dword_be(0x12d6d6a8)
}

function alt_get_final_score() {
    return dword_be(0x10448334)
}

function get_time_limit() {
    return float_be(0x10448390)
}

function new_record_txt_appeared() {
    return byte(0x104496f5) == 0x01 && prev(byte(0x104496f5) == 0x00)
}

event_flags = {
    "Will": {
        "unlocked_1st_door": byte(0x1044866b)
    },
    "Helen": {
        "unlocked_1st_door": byte(0x10448616)
    }
}

high_score_data = {
    "Pure Valley": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x10445fec),
            "rank": dword_be(0x10445ff0),
            "is_a": dword_be(0x10445ff0) == 0x00,
        },
        0x01: {
            "score": dword_be(0x104460a4),
            "rank": dword_be(0x104460a8),
            "is_a": dword_be(0x104460a8) == 0x00,
        },
        0x02: {
            "score": dword_be(0x1044615c),
            "rank": dword_be(0x10446160),
            "is_a": dword_be(0x10446160) == 0x00,
        },
        0x03: {
            "score": dword_be(0x10446214),
            "rank": dword_be(0x10446218),
            "is_a": dword_be(0x10446218) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x104462cc),
            "rank": dword_be(0x104462d0),
            "is_a": dword_be(0x104462d0) == 0x00,
        }
    }
}

// Achievements
achievement(
    title = "TestFlightCheevo",
    points = 1,
    type = "progression",
    description = format("Dualize with NiGHTS and complete your first test flight"),
    trigger = 
        !in_multiplayer_mode() &&
        never(!dream_gate_obj.dream_gate_only_in_level()) &&
        // Player must have been in the level for a bit, prevent false trigger via loading state
        repeated(500, dream_gate_obj.dream_gate_only_in_level()) &&
        (
            (
                is_will() &&
                event_flags["Will"]["unlocked_1st_door"] == 0x01 && prev(event_flags["Will"]["unlocked_1st_door"] == 0x00)
            ) || (
                is_helen() &&
                event_flags["Helen"]["unlocked_1st_door"] == 0x01 && prev(event_flags["Helen"]["unlocked_1st_door"] == 0x00)
            )
        )
)

chain_target = 300

achievement(
    title = "HighLink",
    points = 5,
    type = "",
    description = format("Reach a Link chain of {0}", chain_target),
    trigger = 
        !in_multiplayer_mode() && !on_title() &&
        dword_be(0x10448330) >= chain_target && prev(dword_be(0x10448330)) < chain_target
)

function chase_level_clear_generator(world, mission, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = format("{0} - {1} - Clear", world, mission),
        points = 3,
        type = "progression",
        description = format("Complete {0} in {1}", mission, world),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            chase_final_score_is_set() &&
            target_obj.just_won_level()
    )

    leaderboard(
        title = format("{0} - {1} - Clear", world, mission),
        description = format("Complete {0} in {1}", mission, world),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            chase_final_score_is_set() &&
            target_obj.just_won_level()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            chase_get_final_score()
        ),
        format = "VALUE", lower_is_better = false
    )
}

function alt_level_clear_generator(world, mission, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = format("{0} - {1} - Clear", world, mission),
        points = 3,
        type = "progression",
        description = format("Complete {0} in {1}", mission, world),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            target_obj.just_won_level()
    )

    leaderboard(
        title = format("{0} - {1} - Clear", world, mission),
        description = format("Complete {0} in {1}", mission, world),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            target_obj.just_won_level()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            alt_get_final_score()
        ),
        format = "VALUE", lower_is_better = false
    )
}

function link_alt_level_clear_generator(world, mission, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = format("{0} - {1} - Clear", world, mission),
        points = 3,
        type = "progression",
        description = format("Complete {0} in {1}", mission, world),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            target_obj.just_won_level()
    )
    
    // In a horrible, cruel twist RATools is NOT able to generate the logic for this LB correctly. Oh well.    
}


function boss_level_clear_generator(world, boss_name, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = format("{0} - {1} - Clear", world, boss_name),
        points = 3,
        type = "progression",
        description = format("Defeat {0} once and for all in {1}", boss_name, world),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            target_obj.just_won_level()
    )

    leaderboard(
        title = format("{0} - {1} - Clear", world, boss_name),
        description = format("Defeat {0} once and for all in {1}", boss_name, world),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            is_in_world(world_is_in_world_string) && target_obj.is_in_level() && target_obj.get_level() == level_id &&
            target_obj.just_won_level()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            get_time_limit()
        ),
        format = "VALUE", lower_is_better = false
    )
}

world = "Pure Valley"

chase_level_clear_generator(world, "the Chase Mission", "Pure Valley Boss", pure_valley_boss_obj, 0x00)
link_alt_level_clear_generator(world, "the Link Challenge", world, pure_valley_obj, 0x01)
alt_level_clear_generator(world, "Fluffy Catch", world, pure_valley_obj, 0x02)
alt_level_clear_generator(world, "River Rescue", world, pure_valley_obj, 0x03)
boss_level_clear_generator(world, "Donbalon", "Pure Valley Boss", pure_valley_boss_obj, 0x01)

world = "Lost Park"

chase_level_clear_generator(world, "the Chase Mission", "Lost Park Boss", lost_park_boss_obj, 0x00)
alt_level_clear_generator(world, "Bomb Panic", world, lost_park_obj, 0x01)
link_alt_level_clear_generator(world, "the Link Challenge", world, lost_park_obj, 0x02)
alt_level_clear_generator(world, "Coaster Rescue", world, lost_park_obj, 0x03)
boss_level_clear_generator(world, "Chamelan", "Lost Park Boss", lost_park_boss_obj, 0x01)

world = "Delight City"

chase_level_clear_generator(world, "the Chase Mission", "Delight City Boss", delight_city_boss_obj, 0x00)
alt_level_clear_generator(world, "Neon City Battle", world, delight_city_obj, 0x01)
link_alt_level_clear_generator(world, "the Link Challenge", world, delight_city_obj, 0x02)
alt_level_clear_generator(world, "Broadway Guide", world, delight_city_obj, 0x03)
boss_level_clear_generator(world, "Cerberus", "Delight City Boss", delight_city_boss_obj, 0x01)

world = "Aqua Garden"

chase_level_clear_generator(world, "the Chase Mission", "Aqua Garden Boss", aqua_garden_boss_obj, 0x00)
alt_level_clear_generator(world, "Aqua Challenge", world, aqua_garden_obj, 0x01)
link_alt_level_clear_generator(world, "the Link Challenge", world, aqua_garden_obj, 0x02)
alt_level_clear_generator(world, "Marine Escape", world, aqua_garden_obj, 0x03)
boss_level_clear_generator(world, "Girania", "Aqua Garden Boss", aqua_garden_boss_obj, 0x01)

world = "Crystal Castle"

chase_level_clear_generator(world, "the Chase Mission", "Crystal Castle Boss", crystal_castle_boss_obj, 0x00)
link_alt_level_clear_generator(world, "the Link Challenge", world, crystal_castle_obj, 0x01)
alt_level_clear_generator(world, "Labyrinth Guide", world, crystal_castle_obj, 0x02)
alt_level_clear_generator(world, "Jewel Fever", world, crystal_castle_obj, 0x03)
boss_level_clear_generator(world, "Bomamba", "Crystal Castle Boss", crystal_castle_boss_obj, 0x01)

world = "Memory Forest"

chase_level_clear_generator(world, "the Chase Mission", "Memory Forest Boss", memory_forest_boss_obj, 0x00)
alt_level_clear_generator(world, "Forest Adventure", world, memory_forest_obj, 0x01)
link_alt_level_clear_generator(world, "the Link Challenge", world, memory_forest_obj, 0x02)
alt_level_clear_generator(world, "Sky Concert", world, memory_forest_obj, 0x03)
boss_level_clear_generator(world, "Queen Bella", "Memory Forest Boss", memory_forest_boss_obj, 0x01)


achievement(
    title = "PureValleyMissionAllARank",
    points = 10,
    type = "",
    description = format("Earn an A Rank in every mission in Pure Valley"),
    trigger = 
        // This pops when the boss dies and the score updates
        (
            (
                is_in_world("Pure Valley") && pure_valley_obj.is_in_level()
            ) ||
            (
                is_in_world("Pure Valley Boss") && pure_valley_boss_obj.is_in_level()   
            )            
        ) &&
        !in_multiplayer_mode() && !on_title() && 
        pure_valley_obj.just_won_level() &&
        never(on_title()) &&
        measured(tally_of(high_score_data["Pure Valley"], 5, input => once(high_score_data["Pure Valley"][input]["rank"] == 0x00 && high_score_data["Pure Valley"][input]["score"] > 0)))
        // tally_of(high_score_data["Pure Valley"], 5, input => once(high_score_data["Pure Valley"][input]["rank"] == 0x00 && high_score_data["Pure Valley"][input]["score"] > 0))
        
        // measured(get_a_ranks_in_world("Pure Valley") == 0x05) && prev(get_a_ranks_in_world("Pure Valley") < 0x05)
)


// RP

// Title Screen
rich_presence_conditional_display(on_title() || on_initial_boot_no_string(), "In the Main Menu")

// In Dream Gate
rich_presence_conditional_display(!in_multiplayer_mode() && dream_gate_obj.dream_gate_only_in_level(), "{1} is in the Dream Gate • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Pure Valley
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Pure Valley") && pure_valley_obj.is_in_level(), "{2} is in Pure Valley • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Pure Valley", pure_valley_obj.get_level(), world_data_map["Pure Valley"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Pure Valley Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Pure Valley Boss") && pure_valley_boss_obj.is_in_level(), "{1} is in Pure Valley • vs. Donbalon • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Lost Park
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Lost Park") && lost_park_obj.is_in_level(), "{2} is in Lost Park • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Lost Park", lost_park_obj.get_level(), world_data_map["Lost Park"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Lost Park Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Lost Park Boss") && lost_park_boss_obj.is_in_level(), "{1} is in Lost Park • vs. Chamelan • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Delight City
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Delight City") && delight_city_obj.is_in_level(), "{2} is in Delight City • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Delight City", delight_city_obj.get_level(), world_data_map["Delight City"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Delight City Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Delight City Boss") && delight_city_boss_obj.is_in_level(), "{1} is in Delight City • vs. Cerberus • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Aqua Garden
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Aqua Garden") && aqua_garden_obj.is_in_level(), "{2} is in Aqua Garden • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Aqua Garden", aqua_garden_obj.get_level(), world_data_map["Aqua Garden"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Aqua Garden Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Aqua Garden Boss") && aqua_garden_boss_obj.is_in_level(), "{1} is in Aqua Garden • vs. Girania • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Crystal Castle
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Crystal Castle") && crystal_castle_obj.is_in_level(), "{2} is in Crystal Castle • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Crystal Castle", crystal_castle_obj.get_level(), world_data_map["Crystal Castle"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Crystal Castle Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Crystal Castle Boss") && crystal_castle_boss_obj.is_in_level(), "{1} is in Crystal Castle • vs. Bomamba • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Memory Forest
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Memory Forest") && memory_forest_obj.is_in_level(), "{2} is in Memory Forest • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Memory Forest", memory_forest_obj.get_level(), world_data_map["Memory Forest"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Memory Forest Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Memory Forest Boss") && memory_forest_boss_obj.is_in_level(), "{1} is in Memory Forest • vs. Queen Bella • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Bellbridge
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Bellbridge") && bellbridge_obj.is_in_level(), "{2} is in Bellbridge • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Bellbridge", bellbridge_obj.get_level(), world_data_map["Bellbridge"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Bellbridge Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Bellbridge Boss") && bellbridge_boss_obj.is_in_level(), "{1} is in Bellbridge • vs. Wizeman • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In My Dream
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("My Dream") && mydream_obj.is_in_level(), "{1} is in My Dream • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In VS Race
rich_presence_conditional_display(!on_title() && in_vs_race_mode(), "In a VS Race • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In VS Battle
rich_presence_conditional_display(!on_title() && in_vs_battle_mode(), "In a VS Battle • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// Credits
rich_presence_conditional_display(on_staff_roll(), "In the Credits • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// FALLBACK
// In Dream Gate
rich_presence_display("{1} is in the Dream Gate • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// rich_presence_display("Playing Nights: Journey of Dreams")