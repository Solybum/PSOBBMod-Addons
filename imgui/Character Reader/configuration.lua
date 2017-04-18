-- Files to save to, when using the Save to file button
local invFileName = "imgui/inv.txt"
-- Includes the item index in the items window
local printItemIndex = true
-- Includes the item index when saving to a file
local printItemIndexToFile = true
-- Ignores meseta in the floor items
local ignoreMeseta = false
-- Shows PBs of mags
local magShowPBs = true
-- Shows the feed timer mags
local magShowFeedTimer = true
-- Shows an [E] besides equipped items in the inventory
local itemsShowEquipped = true
-- new floor items are added by default on the top of the list, use this setting to add new items at the bottom
local invertFloorItemsFlow = false
-- Shows the main window with inventory, bank and Floor combo box selection as well as save to file button
local mainWindow = true
-- Shows a dedicated floor items window, this one doesn't have a selection neither a save to file button
local floorItemsWindow = false
-- Shows a dedicated mag window, this one only shows mags in the character inventory
local dedicatedMagWindow = false
-- Shows a monsters window with some data about monsters (name, HP and position)
local monstersWindow = true
-- Font size for all windows
local fontSize = 1.0

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
    0xFFFFFFFF, -- None
    0xFFBFFDC4, -- Draw
    0xFF80FB8A, -- Drain
    0xFF40F94F, -- Fill
    0xFF00F714, -- Gush
    0xFFBFE1FC, -- Heart
    0xFF80C4FA, -- Mind
    0xFF40A6F7, -- Soul
    0xFF0088F4, -- Geist
    0xFFFFB8FF, -- Master's
    0xFFFF72FF, -- Lord's
    0xFFFF2BFF, -- King's
    0xFFEBEB00, -- Charge
    0xFFF7BB13, -- Spirit
    0xFFEAF718, -- Berserk
    0xFFCBF2FF, -- Ice
    0xFF98E5FF, -- Frost
    0xFF64D8FF, -- Freeze
    0xFF31CBFF, -- Blizzard
    0xFFF9D4C7, -- Bind
    0xFFF3AA90, -- Hold
    0xFFED8058, -- Seize
    0xFFE75521, -- Arrest
    0xFFFFDDCC, -- Heat
    0xFFFFBB9A, -- Fire
    0xFFFF9967, -- Flame
    0xFFFF7734, -- Burning
    0xFFFBFBBF, -- Shock
    0xFFF7F780, -- Thunder
    0xFFF3F240, -- Storm
    0xFFEFEE00, -- Tempest
    0xFFF2C4FF, -- Dim
    0xFFE588FF, -- Shadow
    0xFFD84DFF, -- Dark
    0xFFCB11FF, -- Hell
    0xFFFDC7E5, -- Panic
    0xFFFC8FCB, -- Riot
    0xFFFA57B2, -- Havoc
    0xFFF91F98, -- Chaos
    0xFFD3BFF0, -- Devil's
    0xFFA67FE0, -- Demon's
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
    invertFloorItemsFlow = invertFloorItemsFlow,
    mainWindow = mainWindow,
    floorItemsWindow = floorItemsWindow,
    dedicatedMagWindow = dedicatedMagWindow,
    monstersWindow = monstersWindow,
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
