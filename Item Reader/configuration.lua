-- Enable addon
local enable = true
-- Default font color
local fontColor = 0xFFFFFFFF
-- Default font size
local fontSize = 1.0
-- Enable AIO window
local enableAIOWindow = true
-- Enable inventory window
local enableInventoryWindow = true
-- Enable bank window
local enableBankWindow = true
-- Enable floor window
local enableFloorWindow = true
-- Enable mags window
local enableMagsWindow = true

-- Enable save to file button
local showButtonSaveToFile = true
-- File to dump inventory to
local saveFileName = "addons/saved_inventory.txt"

-- Includes the item index in the items window
local printItemIndex = true
-- Shows an [E] besides equipped items in the inventory
local showEquippedItems = true
-- Use short PB names
local shortPBNames = true
-- Ignores meseta items
local ignoreMeseta = false
-- Invert the order of the item list
-- This option only affects the floor items
local invertItemList = false

return
{
    enable = enable,
    fontColor = fontColor,
    fontSize = fontSize,

    enableAIOWindow = enableAIOWindow,
    enableInventoryWindow = enableInventoryWindow,
    enableBankWindow = enableBankWindow,
    enableFloorWindow = enableFloorWindow,
    enableMagsWindow = enableMagsWindow,

    showButtonSaveToFile = showButtonSaveToFile,
    saveFileName = saveFileName,

    printItemIndex = printItemIndex,
    showEquippedItems = showEquippedItems,
    shortPBNames = shortPBNames,
    ignoreMeseta = ignoreMeseta,
    invertItemList = invertItemList,
}
