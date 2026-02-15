// Nights: Journey of Dreams
// #ID = 7870

function game_over_while_on_foot() {
    return byte(0x104496E6) == 0 && byte(0x104496EA) == 1 && prev(byte(0x104496EA)) == 0
}

function game_over_while_dualized() {
    return byte(0x104496E6) == 1 && byte(0x104496F0) == 1 && prev(byte(0x104496F0)) == 0
}

function get_world() {
    world_adr = 0x11b68131

    return ascii_string_equals(world_adr, "Stage3000")
}

function in_hub() {
    return dword_be(0x1044b3f4) == 0x01
}

function in_my_dream() {
    return ascii_string_equals(0x11b68131, "MyDream")
}

function on_title() {
    return ascii_string_equals(0x11b68131, "Title")
}

world_map = {
    "1000": "Pure Valley",
    "1100": "Lost Park",
    "1200": "Delight City",
    "2000": "Aqua Garden",
    "2100": "Crystal Castle",
    "2200": "Memory Forest",
    "3000": "Bellbridge"
}

hub_map = {
    "Title": "Title Screen",
    "MyDream": "My Dream",
}

level_map = {
    // Set 1 for Will
    // W1
    "hugeData/adx/sng_stg1000.adx": "Chase Mission",
    "hugeData/adx/sng_stg1002.adx": "Fluffy Catch",
    "hugeData/adx/sng_stg1003.adx": "River Rescue",
    // W2
    "hugeData/adx/sng_stg1100.adx": "Chase Mission",
    "hugeData/adx/sng_stg1102.adx": "Bomb Panic",
    "hugeData/adx/sng_stg1103.adx": "Coaster Rescue",
    // W3
    "hugeData/adx/sng_stg1200.adx": "Chase Mission",
    "hugeData/adx/sng_stg1202.adx": "Neon City Battle",
    "hugeData/adx/sng_stg1203.adx": "Broadway Guide",
    // Set 2 for Helen
    // W1
    "hugeData/adx/sng_stg2000.adx": "Chase Mission",
    "hugeData/adx/sng_stg2002.adx": "Aqua Challenge",
    "hugeData/adx/sng_stg2003.adx": "Marine Escape",
    // W2
    "hugeData/adx/sng_stg2100.adx": "Chase Mission",
    "hugeData/adx/sng_stg2103.adx": "Labyrinth Guide",
    "hugeData/adx/sng_stg2102.adx": "Jewel Fever",
    // W3
    "hugeData/adx/sng_stg2200.adx": "Chase Mission",        // DUPLICATE!
    "hugeData/adx/sng_stg2203.adx": "Forest Adventure",
    // "hugeData/adx/sng_stg2200.adx": "Sky Concert",          // DUPLICATE!
    // Shared
    "hugeData/adx/sng_stg1001.adx": "Link Challenge",
    "hugeData/adx/snb_misc_entrance": "Chase Mission" // Bellbridge
}

// RP

// In MyDream: NO GOOD ACCESSOR YET...
// rich_presence_conditional_display(in_hub() && in_my_dream(), "In My Dream • {2} / 60 Dreamdrops",
//     rich_presence_ascii_string_lookup("Hub", 0x11b68136, hub_map),
//     rich_presence_ascii_string_lookup("Level", 0x1047b880, level_map),
//     rich_presence_value("Dreamdrops", dword_be(0x10448448))
// )

// On Title Screen
rich_presence_conditional_display(on_title() && !in_hub(), "In the Main Menu • {2} / 60 Dreamdrops",
    rich_presence_ascii_string_lookup("Hub", 0x11b68136, hub_map),
    rich_presence_ascii_string_lookup("Level", 0x1047b880, level_map),
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In hub
rich_presence_conditional_display(in_hub(), "In the Dream Gate • {2} / 60 Dreamdrops",
    rich_presence_ascii_string_lookup("Hub", 0x11b68136, hub_map),
    rich_presence_ascii_string_lookup("Level", 0x1047b880, level_map),
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)

// In a level
rich_presence_conditional_display(!in_hub(), "In {0} • {1} • {2} / 60 Dreamdrops",
    rich_presence_ascii_string_lookup("World", 0x11b68136, world_map),
    rich_presence_ascii_string_lookup("Level", 0x1047b880, level_map),
    rich_presence_value("Dreamdrops", dword_be(0x10448448))
)


rich_presence_display("Playing NiGHTS")