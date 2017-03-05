local invFileName = "imgui/inv.txt"
local printItemIndex = true
local printItemIndexToFile = true
local ignoreMeseta = false
local magShowPBs = true;
local magShowFeedTimer = true;
local startingInventory = 1;

-- All colors are 0xAARRGGBB

local white = 0xFFFFFFFF
local grey = 0xFFA0A0A0

-- Index (number before each item)
local idx = 0xFFFFFFFF

-- WEAPON
-- Untekked
local wuw = 0xFFFF0000
-- Name
local wna = 0xFFB060B0
-- S-Rank title: "S-RANK"
local wst = 0xFFFF0000
-- S-Rank weapon name: "SABER"
local wsn = 0xFF2D98B7
-- S-Rank custom name
local wsc = 0xFFB060B0
-- Grind
local wgn = 0xFF28CC66
-- Special
local wsp = 0xFF2D98B7
-- Kills
local wkl = 0xFFFFFF00
-- Color attributes when weapon is in inventory or bank
local wap = true
-- Attributes
-- Max attribute value to select the color
local wat =
{
     -1, 0xFFA0A0A0,
      0, 0xFFA0A0A0,
     10, 0xFFFFFFFF,
     20, 0xFFFFFFFF,
     30, 0xFFFFFFFF,
     40, 0xFFFFFFFF,
     50, 0xFFFFFFFF,
     60, 0xFFFFFFFF,
     70, 0xFFFFFFFF,
     80, 0xFFFFFFFF,
     90, 0xFFFFFFFF,
    100, 0xFFFFFFFF,
}
-- Hit
local wht =
{
     -1, 0xFFA0A0A0,
      0, 0xFFFFFFFF,
     10, 0xFF00FF00,
     20, 0xFF38FF00,
     30, 0xFF71FF00,
     40, 0xFFAAFF00,
     50, 0xFFE2FF00,
     60, 0xFFFFE200,
     70, 0xFFFFAA00,
     80, 0xFFFF7100,
     90, 0xFFFF3800,
    100, 0xFFFF0000,
}

-- ARMOR (Frame and Barrier)
-- Name
local ana = 0xFFB060B0
-- Stats
local ast = 0xFF28CC66
-- Slots (Frame only)
local asl = 0xFFFFFF00

-- ARMOR (Unit)
-- Name
local una = 0xFFB060B0
-- Mod (++/--)
local umo = 0xFFB060B0
-- Kills
local ukl = 0xFFFFFF00

-- MAG
-- Name
local mna = 0xFFB060B0
-- Color
local mcl = 0xFF2D98B7
-- Stats
local msc = 0xFF28CC66
-- Photon Blast
local mpb = 0xFFFFFF00
-- Feed timer
-- Below the seconds amount, will use the color
local mft = 
{
       1, 0xFF28CC66,
      16, 0xFFF1C40F,
      30, 0xFFFF8C00,
    9001, 0xFFFF0000, -- over 9000, really just needs 210 at most
}

-- TOOL
-- Name
local tna = 0xFFB060B0
-- Amount
local tcc = 0xFF28CC66

-- TECHNIQUE
-- Name
local tch = 0xFFB060B0
-- Amount
local tlv = 0xFF28CC66

-- MESETA
-- Name
local nna = 0xFFB060B0
-- Color
local nac = 0xFFFFFF00

return 
{
    -- Some options
    invFileName = invFileName,
    printItemIndex = printItemIndex,
    printItemIndexToFile = printItemIndexToFile,
    ignoreMeseta = ignoreMeseta,
    magShowPBs = magShowPBs,
    magShowFeedTimer = magShowFeedTimer,
    startingInventory = startingInventory,

    -- Colors
    white = white,
    grey = grey,
    idx = idx,
    wuw = wuw,
    wna = wna,
    wst = wst,
    wsn = wsn,
    wsc = wsc,
    wgn = wgn,
    wsp = wsp,
    wkl = wkl,
    wap = wap,
    wat = wat,
    wht = wht,
    ana = ana,
    ast = ast,
    asl = asl,
    una = una,
    umo = umo,
    ukl = ukl,
    mna = mna,
    mcl = mcl,
    msc = msc,
    mpb = mpb,
    mft = mft,
    tna = tna,
    tcc = tcc,
    tch = tch,
    tlv = tlv,
    nna = nna,
    nac = nac,
}
