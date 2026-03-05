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

    function get_time_spent() {
        target_adr = (this.start_adr + this.offset * this.order) - 0x88
        return float_be(target_adr)
    }

    function get_level() {
        target_adr = this.start_adr + this.offset * this.order
        return dword_be(target_adr)
    }

    function is_in_level() {
        target_adr = this.start_adr + 0x04 + this.offset * this.order
        return dword_be(target_adr) == 0x00
    }

    function is_playing_level() {
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
        "id": "2010",
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
            0x00: "Chase Mission (Will)",
            0x01: "Chase Mission (Helen)"
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

function get_mission_target_value() {
    return dword_be(0x1044b370)
}

/*
function alt_get_final_score_1000_no_target(target) {
    time = get_time_limit() // need to round down..
    bonus_prev = (time + target) * 100
    bonus = bonus_prev - (bonus_prev % 100)
    result = bonus + dword_be(0x10448334)
    
    return result
}
*/

function alt_get_final_score_1000_no_target() {
    time = get_time_limit()
    bonus_prev = (time) * 1000

    bonus = bonus_prev - (bonus_prev % 1000)
    result = bonus + dword_be(0x10448334)
    
    return result
}

function alt_get_final_score_100_target() {
    time = get_time_limit()
    target = dword_be(0x1044b370)
    bonus_prev = (time + target) * 100

    bonus = bonus_prev - (bonus_prev % 100)
    result = bonus + dword_be(0x10448334)

    return result
}

function alt_lives_penalty_final_score() {
    penalty = dword_be(0x1044b370)
    bonus = (5 - penalty) * 500

    result = bonus + dword_be(0x10448334)

    return result
}

function get_escort_final_score(base_bonus, obj) {
    time_spent = obj.get_time_spent()
    penalty_prev = (time_spent) * 50

    penalty = penalty_prev - (penalty_prev % 50)

    bonus = base_bonus - penalty

    result = bonus + dword_be(0x10448334)
  
    return result
}

function get_time_limit() {
    return float_be(0x10448390)
}

function new_record_txt_appeared() {
    return byte(0x104496f5) == 0x01 && prev(byte(0x104496f5) == 0x00)
}

function true_ending_access_unlocked() {
    return byte(0x1044813f) == 0x01
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
    },
    "Lost Park": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x10446414),
            "rank": dword_be(0x10446418),
            "is_a": dword_be(0x10446418) == 0x00,
        },
        0x01: {
            "score": dword_be(0x104464cc),
            "rank": dword_be(0x104464d0),
            "is_a": dword_be(0x104464d0) == 0x00,
        },
        0x02: {
            "score": dword_be(0x10446584),
            "rank": dword_be(0x10446588),
            "is_a": dword_be(0x10446588) == 0x00,
        },
        0x03: {
            "score": dword_be(0x1044663c),
            "rank": dword_be(0x10446640),
            "is_a": dword_be(0x10446640) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x104466f4),
            "rank": dword_be(0x104466f8),
            "is_a": dword_be(0x104466f8) == 0x00,
        }
    },
    "Delight City": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x1044683c),
            "rank": dword_be(0x10446840),
            "is_a": dword_be(0x10446840) == 0x00,
        },
        0x01: {
            "score": dword_be(0x104468f4),
            "rank": dword_be(0x104468f8),
            "is_a": dword_be(0x104468f8) == 0x00,
        },
        0x02: {
            "score": dword_be(0x104469ac),
            "rank": dword_be(0x104469b0),
            "is_a": dword_be(0x104469b0) == 0x00,
        },
        0x03: {
            "score": dword_be(0x10446a64),
            "rank": dword_be(0x10446a68),
            "is_a": dword_be(0x10446a68) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x10446b1c),
            "rank": dword_be(0x10446b20),
            "is_a": dword_be(0x10446b20) == 0x00,
        }
    },
    "Aqua Garden": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x10446c64),
            "rank": dword_be(0x10446c68),
            "is_a": dword_be(0x10446c68) == 0x00,
        },
        0x01: {
            "score": dword_be(0x10446d1c),
            "rank": dword_be(0x10446d20),
            "is_a": dword_be(0x10446d20) == 0x00,
        },
        0x02: {
            "score": dword_be(0x10446dd4),
            "rank": dword_be(0x10446dd8),
            "is_a": dword_be(0x10446dd8) == 0x00,
        },
        0x03: {
            "score": dword_be(0x10446e8c),
            "rank": dword_be(0x10446e90),
            "is_a": dword_be(0x10446e90) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x10446f44),
            "rank": dword_be(0x10446f48),
            "is_a": dword_be(0x10446f48) == 0x00,
        }
    },
    "Crystal Castle": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x1044708c),
            "rank": dword_be(0x10447090),
            "is_a": dword_be(0x10447090) == 0x00,
        },
        0x01: {
            "score": dword_be(0x10447144),
            "rank": dword_be(0x10447148),
            "is_a": dword_be(0x10447148) == 0x00,
        },
        0x02: {
            "score": dword_be(0x104471fc),
            "rank": dword_be(0x10447200),
            "is_a": dword_be(0x10447200) == 0x00,
        },
        0x03: {
            "score": dword_be(0x104472b4),
            "rank": dword_be(0x104472b8),
            "is_a": dword_be(0x104472b8) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x1044736c),
            "rank": dword_be(0x10447370),
            "is_a": dword_be(0x10447370) == 0x00,
        }
    },
    "Memory Forest": {
        // Regular Missions
        0x00: {
            "score": dword_be(0x104474b4),
            "rank": dword_be(0x104474b8),
            "is_a": dword_be(0x104474b8) == 0x00,
        },
        0x01: {
            "score": dword_be(0x1044756c),
            "rank": dword_be(0x10447570),
            "is_a": dword_be(0x10447570) == 0x00,
        },
        0x02: {
            "score": dword_be(0x10447624),
            "rank": dword_be(0x10447628),
            "is_a": dword_be(0x10447628) == 0x00,
        },
        0x03: {
            "score": dword_be(0x104476dc),
            "rank": dword_be(0x104476e0),
            "is_a": dword_be(0x104476e0) == 0x00,
        },
        // Boss
        0x10: {
            "score": dword_be(0x10447794),
            "rank": dword_be(0x10447798),
            "is_a": dword_be(0x10447798) == 0x00,
        }
    },
    "Bellbridge": {
        // Will
        0x00: {
            "score": dword_be(0x104478dc),
            "rank": dword_be(0x104478e0),
            "is_a": dword_be(0x104478e0) == 0x00,
        },
        // Helen
        0x01: {
            "score": dword_be(0x10447994),
            "rank": dword_be(0x10447998),
            "is_a": dword_be(0x10447998) == 0x00,
        }
    }
}

// Achievements
achievement(
    title = "Soaring Start",
    points = 1,
    type = "progression",
    description = format("Dualize with NiGHTS and complete your first test flight"),
    trigger = 
        !in_multiplayer_mode() &&
        !on_title() &&
        // Player must have been in the level for a bit, prevent false trigger via loading state
        dream_gate_obj.dream_gate_only_in_level() && byte(0x104496c0) == 0x00 &&
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

achievement(
    title = "Split Personality",
    points = 1,
    type = "",
    description = format("Meet familiar faces from Twin Seeds in the Dream Gate"),
    trigger = 
        !in_multiplayer_mode() &&
        !on_title() &&
        dream_gate_obj.dream_gate_only_in_level() && byte(0x104496c0) == 0x00 &&
        (
            (
                is_will() &&
                prev(dword_be(0x1044b188)) == 0x01 && dword_be(0x1044b188) == 0x03
            ) || (
                is_helen() &&
                prev(dword_be(0x1044b188)) == 0x00 && dword_be(0x1044b188) == 0x02
            )
        )
)

chain_target = 300

achievement(
    title = "An Unbroken Chain",
    points = 5,
    type = "",
    description = format("Reach a Link chain of {0}", chain_target),
    trigger = 
        !in_multiplayer_mode() && !on_title() &&
        dword_be(0x10448330) >= chain_target && prev(dword_be(0x10448330)) < chain_target
)

function final_result_just_shown(target_obj) {
    // To be used in multi-stage result screens (Chase Boss)
    return target_obj.in_victory_animation() && byte(0x104496f7) == 0x00 && prev(byte(0x104496f7) == 0x01)
}

function chase_level_clear_generator(cheevo_title, world, mission, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = cheevo_title,
        points = 5,
        type = "progression",
        description = format("Complete {0} - {1}", world, mission),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            final_result_just_shown(target_obj) && chase_final_score_is_set()
            // chase_final_score_is_set() && prev(!chase_final_score_is_set()) && target_obj.in_victory_animation()
            //target_obj.just_won_level()
    )

    leaderboard(
        title = format("{0} - {1}", world, mission),
        description = format("Score as high as possible in {0} - {1}", world, mission),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            final_result_just_shown(target_obj) && chase_final_score_is_set()
            // chase_final_score_is_set() && prev(!chase_final_score_is_set()) && target_obj.in_victory_animation()
            //target_obj.just_won_level()
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

function alt_level_clear_generator(cheevo_title, world, mission, world_is_in_world_string, target_obj, level_id, lb_value_data) {
    achievement(
        title = cheevo_title,
        points = 3,
        type = "progression",
        description = format("Complete {0} - {1}", world, mission),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
    )

    leaderboard(
        title = format("{0} - {1}", world, mission),
        description = format("Score as high as possible in {0} - {1}", world, mission),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            // lb_value_data
            // alt_get_final_score(get_mission_target_value())
            lb_value_data
        ),
        format = "VALUE", lower_is_better = false
    )
}



function link_alt_level_clear_generator(cheevo_title, world, mission, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = cheevo_title,
        points = 3,
        type = "progression",
        description = format("Complete {0} - {1}", world, mission),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            ///final_result_just_shown(target_obj) && target_obj.in_victory_animation()
    )
    
    // In a horrible, cruel twist RATools is NOT able to generate the logic for this LB correctly. Oh well.

    leaderboard(
        title = format("{0} - {1}", world, mission),
        description = format("Score as high as possible in {0} - {1}", world, mission),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
        ),
        cancel = always_false(),
        submit = always_true(),
        value =
        measured(
            0
        ),
        format = "VALUE", lower_is_better = false
    )


}


function boss_level_clear_generator(cheevo_title, world, boss_name, world_is_in_world_string, target_obj, level_id) {
    achievement(
        title = cheevo_title,
        points = 10,
        type = "progression",
        description = format("Defeat {0} in a rematch in {1}", boss_name, world),
        trigger = 
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
    )

    leaderboard(
        title = format("{0} - {1}", world, boss_name),
        description = format("Defeat {0} in a rematch in {1} as quickly as possible", boss_name, world),
        start = 
        (
            // This pops when the boss dies and the score updates
            !in_multiplayer_mode() && !on_title() &&
            // Must be playing the level (in-game) for at least a frame
            once(target_obj.is_playing_level()) &&
            // Reset that CP when not in correct world or level
            never(!is_in_world(world_is_in_world_string)) &&
            never(target_obj.get_level() != level_id) &&
            // Additional sanity check
            prev(is_in_world(world_is_in_world_string)) &&
            !dream_gate_obj.dream_gate_only_in_level() &&
            // Unlock when
            target_obj.just_won_level()
            //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
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

chase_level_clear_generator("A Breath of Fresh Air", world, "Chase Mission", "Pure Valley Boss", pure_valley_boss_obj, 0x00)
link_alt_level_clear_generator("Like a Certain Superhero", world, "Link Challenge", world, pure_valley_obj, 0x01)
alt_level_clear_generator("What Goes Up...", world, "Fluffy Catch", world, pure_valley_obj, 0x02, alt_lives_penalty_final_score())
alt_level_clear_generator("Go with the Flow", world, "River Rescue", world, pure_valley_obj, 0x03, alt_get_final_score_100_target())
boss_level_clear_generator("Bouncy House", world, "Donbalon", "Pure Valley Boss", pure_valley_boss_obj, 0x01)

world = "Lost Park"

chase_level_clear_generator("Ticket to Ride", world, "Chase Mission", "Lost Park Boss", lost_park_boss_obj, 0x00)
alt_level_clear_generator("Short Fuse", world, "Bomb Panic", world, lost_park_obj, 0x01, alt_get_final_score_1000_no_target())
link_alt_level_clear_generator("Linking Park", world, "Link Challenge", world, lost_park_obj, 0x02)
alt_level_clear_generator("Off the Rails", world, "Coaster Rescue", world, lost_park_obj, 0x03, alt_get_final_score_1000_no_target())
boss_level_clear_generator("Card Sharked", world, "Chamelan", "Lost Park Boss", lost_park_boss_obj, 0x01)

world = "Delight City"

achievement(
    title = "Amazing Technicolor Battlefield",
    points = 3,
    type = "progression",
    description = format("Defeat Reala in {0}", world),
    trigger = 
        !in_multiplayer_mode() && !on_title() &&
        // Mare 1 only
        dword_be(0x10448324) == 0x00 &&
        // Must be playing the level (in-game) for at least a frame
        once(delight_city_obj.is_playing_level()) &&
        // Reset that CP when not in correct world or level
        never(!is_in_world(world)) &&
        never(delight_city_obj.get_level() != 0x00) &&
        // Unlock when
        delight_city_obj.just_won_level()
        //final_result_just_shown(target_obj) && target_obj.in_victory_animation()
)

chase_level_clear_generator("Bright Lights, Big City", world, "Chase Mission", "Delight City Boss", delight_city_boss_obj, 0x00)
alt_level_clear_generator("Concrete Jungle" ,world, "Neon City Battle", world, delight_city_obj, 0x01, alt_get_final_score_1000_no_target())
link_alt_level_clear_generator("Making the Connection" ,world, "Link Challenge", world, delight_city_obj, 0x02)
alt_level_clear_generator("Stage Presence", world, "Broadway Guide", world, delight_city_obj, 0x03, get_escort_final_score(30000, delight_city_obj))
// Start at 30000, losing 50 pts per sec
boss_level_clear_generator("Triple Threat", world, "Cerberus", "Delight City Boss", delight_city_boss_obj, 0x01)

world = "Aqua Garden"

chase_level_clear_generator("Making Waves", world, "Chase Mission", "Aqua Garden Boss", aqua_garden_boss_obj, 0x00)
alt_level_clear_generator("Don't Burst the Bubble", world, "Aqua Challenge", world, aqua_garden_obj, 0x01, alt_get_final_score_100_target())
link_alt_level_clear_generator("Squid-in-a-Box", world, "Link Challenge", world, aqua_garden_obj, 0x02)
alt_level_clear_generator("Out of the Blue", world, "Marine Escape", world, aqua_garden_obj, 0x03, get_escort_final_score(30000, aqua_garden_obj))
boss_level_clear_generator("Hook, Line, and Sinker", world, "Girania", "Aqua Garden Boss", aqua_garden_boss_obj, 0x01)

world = "Crystal Castle"

chase_level_clear_generator("Refraction Action", world, "Chase Mission", "Crystal Castle Boss", crystal_castle_boss_obj, 0x00)
link_alt_level_clear_generator("Queen of the Castle", world, "Link Challenge", world, crystal_castle_obj, 0x01)
alt_level_clear_generator("Exit Strategy", world, "Labyrinth Guide", world, crystal_castle_obj, 0x02, get_escort_final_score(30000, crystal_castle_obj))
alt_level_clear_generator("That's Rich", world, "Jewel Fever", world, crystal_castle_obj, 0x03, alt_get_final_score_100_target())
boss_level_clear_generator("The Cat's out of the Bag", world, "Bomamba", "Crystal Castle Boss", crystal_castle_boss_obj, 0x01)

world = "Memory Forest"

chase_level_clear_generator("Deep Roots", world, "Chase Mission", "Memory Forest Boss", memory_forest_boss_obj, 0x00)
alt_level_clear_generator("Branching Out", world, "Forest Adventure", world, memory_forest_obj, 0x01, get_escort_final_score(30000, memory_forest_obj))
link_alt_level_clear_generator("Chain of Memories", world, "Link Challenge", world, memory_forest_obj, 0x02)
alt_level_clear_generator("Ending on a High Note", world, "Sky Concert", world, memory_forest_obj, 0x03, alt_lives_penalty_final_score())
boss_level_clear_generator("Queen's Gambit", world, "Queen Bella", "Memory Forest Boss", memory_forest_boss_obj, 0x01)

world = "Bellbridge"

achievement(
    title = "Nightmare's End",
    points = 10,
    type = "progression",
    description = format("Defeat Wizeman in Bellbridge"),
    trigger = 
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Must be playing the level (in-game) for at least a frame
        once(bellbridge_boss_obj.is_playing_level()) &&
        // Reset that CP when not in correct world or level
        never(!is_in_world("Bellbridge Boss")) &&
        !true_ending_access_unlocked() &&
        // Additional sanity check
        prev(is_in_world("Bellbridge Boss")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        // Unlock when
        final_result_just_shown(bellbridge_boss_obj) && chase_final_score_is_set()
)

achievement(
    title = "Come on, NiGHTS!",
    points = 5,
    type = "progression",
    description = format("Defeat Reala in {0} after collecting the Ideya of Hope", world),
    trigger = 
        !in_multiplayer_mode() && !on_title() &&
        // Must be in Mare 4 (i.e. after regular three)
        dword_be(0x10448324) == 0x03 &&
        // vs Reala starts at 300.0 and cutscenes set to 30.0 -> hits once as battle starts
        once(get_time_limit() == 300.0 && prev(get_time_limit() == 30.0)) &&
        // Reset hit when in Mare 1 (restart) or not in Bellbridge
        never(!is_in_world(world) || dword_be(0x10448324) == 0x00) &&
        // Unlock when
        bellbridge_obj.just_won_level()
)

achievement(
    title = "Journey of Dreams",
    points = 25,
    type = "win_condition",
    description = format("Defeat Wizeman in Bellbridge after collecting the Ideya of Hope"),
    trigger = 
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Must be playing the level (in-game) for at least a frame
        once(bellbridge_boss_obj.is_playing_level()) &&
        // Reset that CP when not in correct world or level
        never(!is_in_world("Bellbridge Boss")) &&
        true_ending_access_unlocked() &&
        // Additional sanity check
        prev(is_in_world("Bellbridge Boss")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        // Unlock when
        final_result_just_shown(bellbridge_boss_obj) && chase_final_score_is_set()
)

leaderboard(
    title = "Bellbridge - Chase Mission",
    description = "Score as high as possible in Bellbridge",
    start = 
    (
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Must be playing the level (in-game) for at least a frame
        once(bellbridge_boss_obj.is_playing_level()) &&
        // Reset that CP when not in correct world or level
        never(!is_in_world("Bellbridge Boss")) &&
        // never(bellbridge_boss_obj.get_level() != level_id) &&
        // Additional sanity check
        prev(is_in_world("Bellbridge Boss")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        // Unlock when
        final_result_just_shown(bellbridge_boss_obj) && chase_final_score_is_set()
    ),
    cancel = always_false(),
    submit = always_true(),
    value =
    measured(
        chase_get_final_score()
    ),
    format = "VALUE", lower_is_better = false
)

// Special Challenges

// possibly one per world?
// Pure Valley: Fluffy Catch catch x at same time
achievement(
    title = "Caught onto It",
    points = 3,
    type = "",
    description = format("In Pure Valley - Fluffy Catch paraloop five Nightopians at the same time"), // todo names?
    trigger = 
    (
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Correct level? Broadway Guide
        pure_valley_obj.get_level() == 0x02 &&
        // Additional sanity check
        prev(is_in_world("Pure Valley")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        is_in_world("Pure Valley") && pure_valley_obj.is_playing_level() &&
        pure_valley_obj.get_time_spent() >= 0.1 &&
        // Unlock when inc by 5 in single frame
        trigger_when(
            dword_be(0x10448330) >= prev(dword_be(0x10448330) + 5)
        )
    )
)

// Lost Park
// Delight City: Complete Escort without collecting clock?
achievement(
    title = "No Time for Sightseeing",
    points = 5,
    type = "",
    description = format("In Delight City - Broadway Guide reach the goal without picking up any Time Chips"),
    trigger = 
    (
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Correct level? Broadway Guide
        delight_city_obj.get_level() == 0x03 &&
        // Additional sanity check
        prev(is_in_world("Delight City")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        is_in_world("Delight City") && delight_city_obj.is_playing_level() &&
        delight_city_obj.get_time_spent() >= 0.1 &&
        // byte(0x104496ee) goes from 1 to 0 on new lap; there may never be a switch
        disable_when(
            // earned too much time: more than 11sec
            get_time_limit() >= prev(get_time_limit() + 11.0),
        until=
            delight_city_obj.get_time_spent() < 0.2 && prev(delight_city_obj.get_time_spent() <= 0.2)
        ) &&
        // Unlock when stage done
        trigger_when(
            delight_city_obj.just_won_level()
        )
    )
)


// Aqua Garden: No multilaps
achievement(
    title = "Frontrunning",
    points = 5,
    type = "",
    description = format("In Aqua Garden - Chase Mission complete the first three Mares without ever taking a second lap"),
    trigger = 
    (
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Correct level? Broadway Guide
        aqua_garden_obj.get_level() == 0x00 &&
        // Additional sanity check
        prev(is_in_world("Aqua Garden")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        is_in_world("Aqua Garden") && aqua_garden_obj.is_playing_level() &&
        aqua_garden_obj.get_time_spent() >= 0.1 &&
        once(byte(0x104496e6) == 0x00) &&
        // byte(0x104496ee) goes from 1 to 0 on new lap; there may never be a switch
        disable_when(
            // Lap completed
            once(byte(0x104496ee) == 0x00 && prev(byte(0x104496ee) == 0x01)) && 
            // Mare did not update for x frames -> the player did not advance the mare...
            (
                repeated(5, dword_be(0x10448324) == prev(dword_be(0x10448324))) &&
                // Reset above counter is Mare completed
                never(dword_be(0x10448324) > prev(dword_be(0x10448324)))
            )
        ) &&
        // Unlock when Mare 3 completed
        trigger_when(
            dword_be(0x10448324) == 0x03 && prev(dword_be(0x10448324) == 0x02)
        ) &&
        // I hate this but it seems to be a good solution since I have a reset inside the PauseIf: Reset the achievement if the player restarts the stage
        (
            always_false() || never(aqua_garden_obj.get_time_spent() < 0.2 && prev(aqua_garden_obj.get_time_spent() <= 0.2))
        )
    )
)

achievement(
    title = "Dash Meter Allergy",
    points = 5,
    type = "",
    description = format("In Memory Forest - Chase Mission, complete the first Mare without flying through any rings"),
    trigger = 
    (
        // This pops when the boss dies and the score updates
        !in_multiplayer_mode() && !on_title() &&
        // Correct level? Any Chase Mission
        memory_forest_obj.get_level() == 0x00 &&
        // Additional sanity check
        prev(is_in_world("Memory Forest")) &&
        !dream_gate_obj.dream_gate_only_in_level() &&
        is_in_world("Memory Forest") && memory_forest_obj.is_playing_level() &&
        memory_forest_obj.get_time_spent() >= 0.1 &&
        // Mare 1
        prev(dword_be(0x10448324) == 0x00) &&
        // Deny the achievement when the player gained link while not gaining blue chips -> ring
        disable_when(
            // Link increased
            dword_be(0x10448330) > prev(dword_be(0x10448330)) &&
            // Blue Chips also increased on same frame
            dword_be(0x10445f3c) == prev(dword_be(0x10445f3c)),
            until=memory_forest_obj.get_time_spent() < 0.1
        ) &&
        // Unlock when inc by 5 in single frame
        trigger_when(
            dword_be(0x10448324) > prev(dword_be(0x10448324))
        )
    )
)


// Crystal Castle
// Memory Forest

list_data = {
    0x00: {
        "obj": pure_valley_obj,
        "boss_obj": pure_valley_boss_obj,
        "names": "Pure Valley",
        "boss_names": "Pure Valley Boss",
        "title": "Eloquent Echo"
    },
    0x01: {
        "obj": lost_park_obj,
        "boss_obj": lost_park_boss_obj,
        "names": "Lost Park",
        "boss_names": "Lost Park Boss",
        "title": "Wandering Wildness"
    },
    0x02: {
        "obj": delight_city_obj,
        "boss_obj": delight_city_boss_obj,
        "names": "Delight City",
        "boss_names": "Delight City Boss",
        "title": "Electric Entertainment"
    },
    0x03: {
        "obj": aqua_garden_obj,
        "boss_obj": aqua_garden_boss_obj,
        "names": "Aqua Garden",
        "boss_names": "Aqua Garden Boss",
        "title": "Sweeping Seashore"
    },
    0x04: {
        "obj": crystal_castle_obj,
        "boss_obj": crystal_castle_boss_obj,
        "names": "Crystal Castle",
        "boss_names": "Crystal Castle Boss",
        "title": "Crystal Choir"
    },
    0x05: {
        "obj": memory_forest_obj,
        "boss_obj": memory_forest_boss_obj,
        "names": "Memory Forest",
        "boss_names": "Memory Forest Boss",
        "title": "Merry Memory Go Round"
    }
}

// A Rank Regular worlds
for element in list_data {
    item_obj = list_data[element]

    achievement(
        title = item_obj["title"],
        points = 10,
        type = "",
        description = format("Earn an A Rank in every mission in {0}", item_obj["names"]),
        trigger = 
            // This pops when the boss dies and the score updates
            // TODO: dynamic ref obj
            (
                (
                    is_in_world(item_obj["names"]) && item_obj["obj"].in_victory_animation()
                ) ||
                (
                    is_in_world(item_obj["boss_names"]) && item_obj["boss_obj"].in_victory_animation()   
                )
            ) &&
            !in_multiplayer_mode() && !on_title() && 
            never(on_title()) &&
            measured(tally_of(high_score_data[item_obj["names"]], 5, input => once(high_score_data[item_obj["names"]][input]["rank"] == 0x00 && high_score_data[item_obj["names"]][input]["score"] > 0))) &&
            tally_of(high_score_data[item_obj["names"]], 4, input => once(prev(high_score_data[item_obj["names"]][input]["rank"] == 0x00 && high_score_data[item_obj["names"]][input]["score"] > 0)))
            // tally_of(high_score_data["Pure Valley"], 5, input => once(high_score_data["Pure Valley"][input]["rank"] == 0x00 && high_score_data["Pure Valley"][input]["score"] > 0))
            // measured(get_a_ranks_in_world("Pure Valley") == 0x05) && prev(get_a_ranks_in_world("Pure Valley") < 0x05)
    )
}
// A Rank Bellbridge both versions
achievement(
    title = "Growing Wings",
    points = 10,
    type = "",
    description = format("Earn an A Rank in both versions of {0}", "Bellbridge"),
    trigger = 
        // This pops when the boss dies and the score updates
        is_in_world("Bellbridge Boss") && bellbridge_boss_obj.is_in_level() &&
        !in_multiplayer_mode() && !on_title() && 
        bellbridge_obj.just_won_level() &&
        never(on_title()) &&
        measured(tally_of(high_score_data["Bellbridge"], 2, input => once(high_score_data["Bellbridge"][input]["rank"] == 0x00 && high_score_data["Bellbridge"][input]["score"] > 0)))
        // tally_of(high_score_data["Pure Valley"], 5, input => once(high_score_data["Pure Valley"][input]["rank"] == 0x00 && high_score_data["Pure Valley"][input]["score"] > 0))
        // measured(get_a_ranks_in_world("Pure Valley") == 0x05) && prev(get_a_ranks_in_world("Pure Valley") < 0x05)
)

// Dreamdrops

dreamdrop_data = {
    0x00: {
        "start_adr": 0x10448400,
        "amount": 4,
        "world": "Dream Gate",
        "title": "",
        "pts": 10
    },
    0x01: {
        "start_adr": 0x1044841c,
        "amount": 8,
        "world": "Pure Valley",
        "title": "",
        "pts": 10
    },
    0x02: {
        "start_adr": 0x10448424,
        "amount": 8,
        "world": "Lost Park",
        "title": "",
        "pts": 10
    },
    0x03: {
        "start_adr": 0x1044842c,
        "amount": 8,
        "world": "Delight City",
        "title": "",
        "pts": 10
    },
    0x04: {
        "start_adr": 0x10448404,
        "amount": 8,
        "world": "Aqua Garden",
        "title": "",
        "pts": 10
    },
    0x05: {
        "start_adr": 0x1044840c,
        "amount": 8,
        "world": "Crystal Castle",
        "title": "",
        "pts": 10
    },
    0x06: {
        "start_adr": 0x10448414,
        "amount": 8,
        "world": "Memory Forest",
        "title": "",
        "pts": 10
    },
    0x07: {
        "start_adr": 0x10448434,
        "amount": 6,
        "world": "Bellbridge", // both versions
        "title": "",
        "pts": 10
    },
    0x08: {
        "start_adr": 0x1044843a,
        "amount": 2,
        "world": "My Dream",
        "title": "",
        "pts": 10
    }
}

// Dreamdrops
function sum_world_dreamseeds(start_adr, amount) {
    return sum_of(range(0, amount - 1, 1), i => 
        byte(start_adr + i)
    )
}

for area in dreamdrop_data {
    amount_collected = sum_world_dreamseeds(dreamdrop_data[area]["start_adr"], dreamdrop_data[area]["amount"])

    achievement(
    title = format("Dream Explorer: {0}", dreamdrop_data[area]["world"]),
    points = dreamdrop_data[area]["pts"],
    type = "",
    description = format("Collect all Dreamdrops in {0}", dreamdrop_data[area]["world"]),
    trigger = 
        !in_multiplayer_mode() && !on_title() && 
        measured(amount_collected == dreamdrop_data[area]["amount"]) && prev(amount_collected == dreamdrop_data[area]["amount"] - 1)
    )
}


// RP

// Title Screen
rich_presence_conditional_display(on_title() || on_initial_boot_no_string(), "In the Main Menu")

// In Dream Gate
rich_presence_conditional_display(!in_multiplayer_mode() && dream_gate_obj.dream_gate_only_in_level(), "{1} is in the Dream Gate • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Pure Valley
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Pure Valley") && pure_valley_obj.is_playing_level(), "{2} is in Pure Valley • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Pure Valley", pure_valley_obj.get_level(), world_data_map["Pure Valley"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Pure Valley Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Pure Valley Boss") && pure_valley_boss_obj.is_playing_level(), "{1} is in Pure Valley • vs. Donbalon • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Lost Park
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Lost Park") && lost_park_obj.is_playing_level(), "{2} is in Lost Park • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Lost Park", lost_park_obj.get_level(), world_data_map["Lost Park"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Lost Park Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Lost Park Boss") && lost_park_boss_obj.is_playing_level(), "{1} is in Lost Park • vs. Chamelan • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Delight City
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Delight City") && delight_city_obj.is_playing_level(), "{2} is in Delight City • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Delight City", delight_city_obj.get_level(), world_data_map["Delight City"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Delight City Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Delight City Boss") && delight_city_boss_obj.is_playing_level(), "{1} is in Delight City • vs. Cerberus • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Aqua Garden
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Aqua Garden") && aqua_garden_obj.is_playing_level(), "{2} is in Aqua Garden • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Aqua Garden", aqua_garden_obj.get_level(), world_data_map["Aqua Garden"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Aqua Garden Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Aqua Garden Boss") && aqua_garden_boss_obj.is_playing_level(), "{1} is in Aqua Garden • vs. Girania • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Crystal Castle
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Crystal Castle") && crystal_castle_obj.is_playing_level(), "{2} is in Crystal Castle • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Crystal Castle", crystal_castle_obj.get_level(), world_data_map["Crystal Castle"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Crystal Castle Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Crystal Castle Boss") && crystal_castle_boss_obj.is_playing_level(), "{1} is in Crystal Castle • vs. Bomamba • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Memory Forest
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Memory Forest") && memory_forest_obj.is_playing_level(), "{2} is in Memory Forest • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Memory Forest", memory_forest_obj.get_level(), world_data_map["Memory Forest"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Memory Forest Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Memory Forest Boss") && memory_forest_boss_obj.is_playing_level(), "{1} is in Memory Forest • vs. Queen Bella • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// Bellbridge vs Reala
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Bellbridge") && bellbridge_obj.is_playing_level() &&
                                  dword_be(0x10448324) == 0x03 && once(get_time_limit() == 300.0 && prev(get_time_limit() == 30.0)) && never(!is_in_world("Bellbridge") || dword_be(0x10448324) == 0x00),
                                  "{2} is in Bellbridge • vs. Reala • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Bellbridge", bellbridge_obj.get_level(), world_data_map["Bellbridge"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Bellbridge
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Bellbridge") && bellbridge_obj.is_playing_level(), "{2} is in Bellbridge • Chase Mission • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Bellbridge", bellbridge_obj.get_level(), world_data_map["Bellbridge"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In Bellbridge Boss
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("Bellbridge Boss") && bellbridge_boss_obj.is_playing_level(), "{1} is in Bellbridge • vs. Wizeman • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// In My Dream
rich_presence_conditional_display(!in_multiplayer_mode() && !on_title() && is_in_world("My Dream") && mydream_obj.is_playing_level(), "{1} is in My Dream • {0} / 60 Dreamdrops",
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
rich_presence_conditional_display(on_staff_roll(), "Watching the Credits • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// FALLBACK
// In Dream Gate
rich_presence_display("{1} is in the Dream Gate • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448)),
    rich_presence_lookup("Character", get_current_character(), char_map, fallback="The Visitor")
)

// rich_presence_display("Playing Nights: Journey of Dreams")