local invFileName = "imgui/inv.txt"
local printItemIndex = true
local printItemIndexToFile = true
local ignoreMeseta = false
local startingInventory = 1;

-- All colors are r, g, b, a
-- Values are floats [0, 1]

-- Index (number before each item)
local idx = { 1, 1, 1, 1 }
-- Weapon Colors
-- Wrapped and Untekked
local wuw = { 1, 1, 1, 1 }
-- Name
local wna = { 1, 1, 1, 1 }
-- S-Rank title: "S-RANK"
local wst = { 1, 1, 1, 1 }
-- S-Rank weapon name: "SABER"
local wsn = { 1, 1, 1, 1 }
-- S-Rank custom name
local wsc = { 1, 1, 1, 1 }
-- Grind
local wgn = { 1, 1, 1, 1 }
-- Special
local wsp = { 1, 1, 1, 1 }
-- Kills
local wkl = { 1, 1, 1, 1 }
-- Attributes
local wat = 
{
    { 1, 1, 1, 1 }, -- Below 0
    { 1, 1, 1, 1 }, -- 0
    { 1, 1, 1, 1 }, -- Up to 20
    { 1, 1, 1, 1 }, -- Up to 40
    { 1, 1, 1, 1 }, -- Up to 60
    { 1, 1, 1, 1 }, -- Up to 80
    { 1, 1, 1, 1 }, -- Above 80
}
-- Hit
local wht = 
{
    { 1, 1, 1, 1 }, -- Below 0
    { 1, 1, 1, 1 }, -- 0
    { 1, 1, 1, 1 }, -- Up to 20
    { 1, 1, 1, 1 }, -- Up to 40
    { 1, 1, 1, 1 }, -- Up to 60
    { 1, 1, 1, 1 }, -- Up to 80
    { 1, 1, 1, 1 }, -- Above 80
}


return 
{
    -- Some options
    invFileName = invFileName,
    printItemIndex = printItemIndex,
    printItemIndexToFile = printItemIndexToFile,
    ignoreMeseta = ignoreMeseta,
    startingInventory = startingInventory,

    -- Colors
    idx = idx,
    wuw = wuw,
    wna = wna,
    wst = wst,
    wsn = wsn,
    wsc = wsc,
    wgn = wgn,
    wsp = wsp,
    wkl = wkl,
    wat = wat,
    wht = wht,
}
