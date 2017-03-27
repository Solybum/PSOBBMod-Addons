local invFileName = "imgui/inv.txt"
local printItemIndex = true
local printItemIndexToFile = true
local ignoreMeseta = false
local magShowPBs = true;
local magShowFeedTimer = true;
local itemsShowEquipped = true;
local mainWindow = true;
local floorItemsWindow = false;
local dedicatedMagWindow = false;
local monstersWindow = false;
local fontSize = 1.0;

-- All colors are 0xAARRGGBB

local white = 0xFFFFFFFF
local grey = 0xFFA0A0A0

-- Index (number before each item)
local idx = 0xFFFFFFFF

-- Equipped
local ieq = 0xFFFFFFFF

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
local wsp =
{
    0xFF2D98B7, -- None
    0xFF2D98B7, -- Draw
    0xFF2D98B7, -- Drain
    0xFF2D98B7, -- Fill
    0xFF2D98B7, -- Gush
    0xFF2D98B7, -- Heart
    0xFF2D98B7, -- Mind
    0xFF2D98B7, -- Soul
    0xFF2D98B7, -- Geist
    0xFF2D98B7, -- Master's
    0xFF2D98B7, -- Lord's
    0xFF2D98B7, -- King's
    0xFF2D98B7, -- Charge
    0xFF2D98B7, -- Spirit
    0xFF2D98B7, -- Berserk
    0xFF2D98B7, -- Ice
    0xFF2D98B7, -- Frost
    0xFF2D98B7, -- Freeze
    0xFF2D98B7, -- Blizzard
    0xFF2D98B7, -- Bind
    0xFF2D98B7, -- Hold
    0xFF2D98B7, -- Seize
    0xFF2D98B7, -- Arrest
    0xFF2D98B7, -- Heat
    0xFF2D98B7, -- Fire
    0xFF2D98B7, -- Flame
    0xFF2D98B7, -- Burning
    0xFF2D98B7, -- Shock
    0xFF2D98B7, -- Thunder
    0xFF2D98B7, -- Storm
    0xFF2D98B7, -- Tempest
    0xFF2D98B7, -- Dim
    0xFF2D98B7, -- Shadow
    0xFF2D98B7, -- Dark
    0xFF2D98B7, -- Hell
    0xFF2D98B7, -- Panic
    0xFF2D98B7, -- Riot
    0xFF2D98B7, -- Havoc
    0xFF2D98B7, -- Chaos
    0xFF2D98B7, -- Devil's
    0xFF2D98B7, -- Demon's
}
-- S-Rank Special
local wss = 0xFF2D98B7
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
    itemsShowEquipped = itemsShowEquipped,
    mainWindow = mainWindow,
    floorItemsWindow = floorItemsWindow,
    dedicatedMagWindow = dedicatedMagWindow,
    fontSize = fontSize,

    -- Colors
    white = white,
    grey = grey,
    idx = idx,
    ieq = ieq,
    wuw = wuw,
    wna = wna,
    wst = wst,
    wsn = wsn,
    wsc = wsc,
    wgn = wgn,
    wsp = wsp,
    wss = wss,
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
