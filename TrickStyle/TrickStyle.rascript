// TrickStyle
// #ID = 22056

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

map_id = dword(0x6c4f80)

class PlayerObject {

    function get_x() {
        return ptr(tbyte(0x6c5b3c), [0xAC, 0x2C, 0x04, 0x40], float)
    }

    function get_y() {
        return ptr(tbyte(0x6c5b3c), [0xAC, 0x2C, 0x04, 0x44], float)
    }

    function get_z() {
        return ptr(tbyte(0x6c5b3c), [0xAC, 0x2C, 0x04, 0x48], float)
    }

    function entered_area(x1, x2, y1, y2, z1, z2) {
        x_pos = this.get_x()
        y_pos = this.get_y()
        z_pos = this.get_z()

        // e.g. box at x1 10, x2 20, y1 0, y2 20, z1 50, z2 60
        // player at x 15, y 10, z 40: valid
        cond1 = x1 <= x_pos
        cond4 = x2 >= x_pos

        cond2 = y1 <= y_pos
        cond5 = y2 >= y_pos

        cond3 = z1 <= z_pos
        cond6 = z2 >= z_pos

        return cond1 && cond2 && cond3 && cond4 && cond5 && cond6
    }

}

player = PlayerObject()

achievement(
    title = format("TEST BIG BEN"),
    points = 0,
    description = format("TEST BIG BEN"),
    trigger = (
        // bottom left: 1597.0, 220.0, 1277.0
        // top right: 1597.0, 480.0, 1307.0

        // bottom left: 1618.0, 220.0, 1265.0
        // top right: 1615.0, 480.0, 1297.0

        // bottom left: 1628.0, 220.0, 1263.0
        // top right: 1634.0, 480.0, 1291.0

        map_id == 0x15 &&

        once(player.entered_area(1597.0, 1598.0, 220.0, 480.0, 1277.0, 1307.0)) &&
        once(player.entered_area(1615.0, 1618.0, 220.0, 480.0, 1265.0, 1297.0)) &&
        once(player.entered_area(1628.0, 1634.0, 220.0, 480.0, 1263.0, 1291.0))
    )

)