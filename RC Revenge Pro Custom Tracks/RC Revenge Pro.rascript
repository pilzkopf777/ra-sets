// RC Revenge Pro
// #ID = 32849

function ptr(base, offsets, accessor=dword)
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
            val = dword(addr)
        }
    }
    
    return val
}


achievementsetradevtracks = achievement_set("RA Dev Tracks", type="BONUS", id=38653)

race_type = dword(0x1edc4c)
level_id = byte(0x1edc4a)

p1_laps_completed = ptr(dword(0x1ee7e8), [0x104], word)
p1_lap_time = ptr(dword(0x1ee7e8), [0x140], dword)
p1_three_to_four = ptr(dword(0x1ee7e8), [0x150], dword)
p1_pos = ptr(dword(0x1ee7e8), [0x13C], word)
p1_car = byte(0x001edcdf)

track_data = (       
    ptr(dword(0x1F093C), [0x00], dword) == 1985229328 &&
    ptr(dword(0x1F093C), [0x04], dword) == 0x00 &&
    ptr(dword(0x1F093C), [0x08], dword) == 0x03 &&
    ptr(dword(0x1F093C), [0x0C], dword) == 0x04 &&
    ptr(dword(0x1F093C), [0x14], word)  == 0x00 &&
    ptr(dword(0x1F093C), [0x18], dword) == 0x00 &&
    ptr(dword(0x1F093C), [0x1C], dword) == 0x26 &&
    ptr(dword(0x1F093C), [0x20], dword) == 0x19 &&
    ptr(dword(0x1F093C), [0x24], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0x28], dword) == 0x29 &&
    ptr(dword(0x1F093C), [0x2C], dword) == 0x19 &&
    ptr(dword(0x1F093C), [0x30], dword) == 0x26 &&
    ptr(dword(0x1F093C), [0x34], dword) == 0x29 &&
    ptr(dword(0x1F093C), [0x38], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0x3C], dword) == 0x11 &&
    ptr(dword(0x1F093C), [0x40], dword) == 0x11 &&
    ptr(dword(0x1F093C), [0x44], dword) == 0x26 &&
    ptr(dword(0x1F093C), [0x48], dword) == 0x2a &&
    ptr(dword(0x1F093C), [0x4C], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0x50], dword) == 0x2c &&
    ptr(dword(0x1F093C), [0x54], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0x58], dword) == 0x29 &&
    ptr(dword(0x1F093C), [0x5C], dword) == 0x1d &&
    ptr(dword(0x1F093C), [0x60], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0x64], dword) == 0x2a &&
    ptr(dword(0x1F093C), [0x68], dword) == 0x17 &&
    ptr(dword(0x1F093C), [0x6C], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0x70], dword) == 0x19 &&
    ptr(dword(0x1F093C), [0x74], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0x78], dword) == 0x30 &&
    ptr(dword(0x1F093C), [0x7C], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0x80], dword) == 0x2c &&
    ptr(dword(0x1F093C), [0x84], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0x88], dword) == 0x1f &&
    ptr(dword(0x1F093C), [0x8C], dword) == 0x26 &&
    ptr(dword(0x1F093C), [0x90], dword) == 0x17 &&
    ptr(dword(0x1F093C), [0x94], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0x98], dword) == 0x17 &&
    ptr(dword(0x1F093C), [0x9C], dword) == 0x29 &&
    ptr(dword(0x1F093C), [0xA0], dword) == 0x2d &&
    ptr(dword(0x1F093C), [0xA4], dword) == 0x2a &&
    ptr(dword(0x1F093C), [0xA8], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0xAC], dword) == 0x2c &&
    ptr(dword(0x1F093C), [0xB0], dword) == 0x18 &&
    ptr(dword(0x1F093C), [0xB4], dword) == 0x17 &&
    ptr(dword(0x1F093C), [0xB8], dword) == 0x18 &&
    ptr(dword(0x1F093C), [0xBC], dword) == 0x17 &&
    ptr(dword(0x1F093C), [0xC0], dword) == 0x2e &&
    ptr(dword(0x1F093C), [0xC4], dword) == 0x19 &&
    ptr(dword(0x1F093C), [0xC8], dword) == 0x26 &&
    ptr(dword(0x1F093C), [0xCC], dword) == 0x18 &&
    ptr(dword(0x1F093C), [0xD0], dword) == 0xffffffff
    )

time_limit = 48000

// HAYWIRE

achievement(
    title = "Need for Seed",
    points = 10,
    description = "In a Time Trial, complete a lap in less than 0:48.0 using the RC Action on Pilzkopf's track, \"Haywire\"",
    set = achievementsetradevtracks,
    trigger =
    (
        never(race_type != 0x100001FE) &&
        never(level_id != 0x61) &&
        // quit game
        never(dword(0x001ed900) == 0x04) &&
        once(p1_laps_completed == 0xffff) &&
        p1_car == 0x04 &&
        p1_lap_time < time_limit &&
        trigger_when(p1_laps_completed == prev(p1_laps_completed + 1)) &&
        track_data
    )
)

leaderboard(
    title = "Haywire - Time Trial - Single Lap",
    description = "In a Time Trial, complete a lap as quickly as possible on Pilzkopf's track, \"Haywire\"",
    set = achievementsetradevtracks,
    start = 
    (
        race_type == 0x100001FE &&
        level_id == 0x61 &&
        p1_laps_completed == prev(p1_laps_completed + 1) &&
        track_data
    ),
    cancel = always_false(),
    submit = always_true(),
    value = measured(prev(p1_lap_time) / 10),
    format = "MILLISECS", lower_is_better = true
)

achievement(
    title = "By a Country Mile",
    points = 5,
    description = "In a Single Race, finish in first place on Pilzkopf's track, \"Haywire\"",
    set = achievementsetradevtracks,
    trigger =
    (
        race_type == 0x100001FC &&
        level_id == 0x61 &&
        p1_pos == 0x00 &&
        // race done
        dword(0x1ed900) == 0x20 && prev(dword(0x1ed900) != 0x20) &&
        track_data
    )
)

leaderboard(
    title = "Haywire - Single Race",
    description = "In a Single Race, complete three laps as quickly as possible on Pilzkopf's track, \"Haywire\"",
    set = achievementsetradevtracks,
    start = 
    (
        race_type == 0x100001FC &&
        level_id == 0x61 &&
        p1_pos == 0x00 &&
        // race done
        dword(0x1ed900) == 0x20 && prev(dword(0x1ed900) != 0x20) &&
        track_data
    ),
    cancel = always_false(),
    submit = always_true(),
    value = measured(p1_three_to_four / 10),
    format = "MILLISECS", lower_is_better = true
)
