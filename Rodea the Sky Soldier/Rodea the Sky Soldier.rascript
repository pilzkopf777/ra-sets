// Rodea the Sky Soldier
// #ID = 34706

// Helper function taken from Souzooka - thanks!
WII_GAME_MASK = 0x1fffffff

function ptr(base, offsets, accessor=dword_be)
{
    val = base
    // Cool masking action in a seperate line
    val = val & WII_GAME_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            // Result also needs to 
            val = val & WII_GAME_MASK
        }
    }
    
    return val
}


START_OF_SAVE_SLOT_1 = 0x00EDF3D0

class ChapterSaveData
{
    save_slot = 0
    chapter = 0

    function _get_start_adr_raw() {
        SLOT_BASE = START_OF_SAVE_SLOT_1 + (this.save_slot * 0x1400)
        CHAPTER_RAW_ADR = SLOT_BASE + 0x100 + (this.chapter * 0x40)
        return CHAPTER_RAW_ADR
    }

    function is_unlocked() {
        return dword_be(this._get_start_adr_raw() + 0x00) >= 0x02
    }

    function is_beaten() {
        return dword_be(this._get_start_adr_raw() + 0x00) == 0x03
    }

//    function get_best_time() {
//
//    }
//
//    function get_best_graviton_score() {
//
//    }
//
//    function is_time_s_rank() {
//
//    }
//
//    function is_graviton_s_rank() {
//
//    }
//
//    function get_bronze_medal_count() {
//
//    }
//
//    function get_silver_medal_count() {
//
//    }
//
//    function get_gold_medal_count() {
//
//    }
//
//    function all_medals_collected() {
//
//    }


}

function clear_prologue_logic() {
  cp= ChapterSaveData(save_slot=0, chapter=0)
  return cp.is_beaten() && prev(!cp.is_beaten())
}

achievement(
    title = "Debug Stuff in RA", points = 50,
    description = "Debug Away!",
    trigger =
        clear_prologue_logic()
)