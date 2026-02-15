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
        return dword_be(target_adr) != 0x04
    }
}

pure_valley_obj = WorldData(order=2)
pure_valley_boss_obj = WorldData(order=3)
lost_park_obj = WorldData(order=4)
lost_park_boss_obj = WorldData(order=5)

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
        "id": "1200",
    },
    "Aqua Garden":
    {
        "id": "2000",
    },
    "Crystal Castle": 
    {
        "id": "2100",
    },
    "Memory Forest":
    {
        "id": "2200",
    },
   // "Bellbridge":
   // {
   //     "id": "3000",
   //     "order": 0,
   //     "world_data": WorldData(order=99) // ? Also, Dream Gate missing
   // }
}

function is_in_world(world_name) {
    world_adr = 0x11b68136
    world_id = world_data_map[world_name]["id"]

    return ascii_string_equals(world_adr, world_id)
}

function in_my_dream() {
    return ascii_string_equals(0x11b68131, "MyDream")
}

function on_title() {
    return ascii_string_equals(0x11b68131, "Title")
}



hub_map = {
    "Title": "Title Screen",
    "MyDream": "My Dream",
}

// RP

// On Title Screen
rich_presence_conditional_display(on_title(), "In the Main Menu • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In hub
// rich_presence_conditional_display(in_hub(), "In the Dream Gate • {2} / 60 Dreamdrops",
//     rich_presence_value("Dreamdrops", dword_be(0x10448448))
// )

// In a level

// In Pure Valley
rich_presence_conditional_display(!on_title() && is_in_world("Pure Valley") && pure_valley_obj.is_in_level(), "In Pure Valley • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Pure Valley", pure_valley_obj.get_level(), world_data_map["Pure Valley"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In Pure Valley Boss
rich_presence_conditional_display(!on_title() && is_in_world("Pure Valley Boss") && pure_valley_boss_obj.is_in_level(), "In Pure Valley • vs. Donbalon • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In Lost Park
rich_presence_conditional_display(!on_title() && is_in_world("Lost Park") && lost_park_obj.is_in_level(), "In Lost Park • {0} • {1} / 60 Dreamdrops",
    rich_presence_lookup("Level: Lost Park", lost_park_obj.get_level(), world_data_map["Lost Park"]["levels"], fallback="Unknown Level"),
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In Lost Park Boss
rich_presence_conditional_display(!on_title() && is_in_world("Lost Park Boss") && lost_park_boss_obj.is_in_level(), "In Lost Park • vs. Chamelan • {0} / 60 Dreamdrops",
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)


rich_presence_display("Playing NiGHTS")