-- Enable addon
local enable = true
-- Default font color
local fontColor = 0xFFFFFFFF
-- Default font size
local fontSize = 1.0
-- Color for the mag feed timer
local magFeedTimerColors =
{
    1, 0xFF28CC66,
    16, 0xFFF1C40F,
    30, 0xFFFF8C00,
    9001, 0xFFFF0000, -- over 9000, really just needs 210 at most
}
-- Mag ready to be fed string
local readyToBeFedString = "Feed Me!!!"

return
{
    enable = enable,
    fontColor = fontColor,
    fontSize = fontSize,
    magFeedTimerColors = magFeedTimerColors,
    readyToBeFedString = readyToBeFedString,
}
