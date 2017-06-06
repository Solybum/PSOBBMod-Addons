-- Enable addon
local enable = true
-- Default font color
local fontColor = 0xFFFFFFFF
-- Default font size
local fontSize = 1.0
-- Invert the order of the monster list
local invertMonsterList = false
-- Hide HP bars for monsters that are
-- not in the room that the player is in
local showOnlyPlayerRoom = false

return
{
    enable = enable,
    fontColor = fontColor,
    fontSize = fontSize,
    invertMonsterList = invertMonsterList,
    showOnlyPlayerRoom = showOnlyPlayerRoom,
}
