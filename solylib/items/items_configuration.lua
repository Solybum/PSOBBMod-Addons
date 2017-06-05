-- All colors are 0xAARRGGBB
local white = 0xFFFFFFFF
local grey = 0xFFA0A0A0

-- Item
local itemIndex = 0xFFFFFFFF
local itemEquipped = 0xFFFFFFFF

-- WEAPON
local weaponUntekked = 0xFFFF0000
local weaponName = 0xFFB060B0
local weaponGrind = 0xFF28CC66
local weaponSRankTitle = 0xFFFF0000
local weaponSRankName = 0xFF2D98B7
local weaponSRankCustomName = 0xFFB060B0
local weaponSRankSpecial = 0xFF2D98B7
local weaponKills = 0xFFFFFF00
local weaponSpecial =
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
local weaponAttributesEnabled = true
local weaponAttributes =
{
    100, 0xFFFFFFFF,
    90, 0xFFFFFFFF,
    80, 0xFFFFFFFF,
    70, 0xFFFFFFFF,
    60, 0xFFFFFFFF,
    50, 0xFFFFFFFF,
    40, 0xFFFFFFFF,
    30, 0xFFFFFFFF,
    20, 0xFFFFFFFF,
    10, 0xFFFFFFFF,
    0, 0xFFA0A0A0,
    -1, 0xFFA0A0A0,
}
local weaponHit =
{
    100, 0xFFFF0000,
    90, 0xFFFF3800,
    80, 0xFFFF7100,
    70, 0xFFFFAA00,
    60, 0xFFFFE200,
    50, 0xFFE2FF00,
    40, 0xFFAAFF00,
    30, 0xFF71FF00,
    20, 0xFF38FF00,
    10, 0xFF00FF00,
    0, 0xFFFFFFFF,
    -1, 0xFFA0A0A0,
}

-- ARMOR (Frame and Barrier)
local armorName = 0xFFB060B0
local armorStats = 0xFF28CC66
local armorStatsMax = 0xFF28CC66
local armorSlots = 0xFFFFFF00

-- ARMOR (Unit)
local unitName = 0xFFB060B0
local unitKills = 0xFFFFFF00

-- MAG
local magName = 0xFFB060B0
local magColor = 0xFF2D98B7
local magStats = 0xFF28CC66
local magPB = 0xFFFFFF00
local magFeedTimer =
{
    9001,   0xFFFF0000, -- over 9000, really just needs 211
    30,     0xFFFF8C00,
    16,     0xFFF1C40F,
    1,      0xFF28CC66,
}

-- TOOL
local toolName = 0xFFB060B0
local toolAmount = 0xFF28CC66

-- TECHNIQUE
local techName = 0xFFB060B0
local techLevel = 0xFF28CC66

-- MESETA
local mesetaName = 0xFFB060B0
local mesetaAmount = 0xFFFFFF00

return
{
    -- Colors
    white = white,
    grey = grey,
    itemIndex = itemIndex,
    itemEquipped = itemEquipped,
    weaponUntekked = weaponUntekked,
    weaponName = weaponName,
    weaponGrind = weaponGrind,
    weaponSRankTitle = weaponSRankTitle,
    weaponSRankName = weaponSRankName,
    weaponSRankCustomName = weaponSRankCustomName,
    weaponSRankSpecial = weaponSRankSpecial,
    weaponKills = weaponKills,
    weaponSpecial = weaponSpecial,
    weaponAttributesEnabled = weaponAttributesEnabled,
    weaponAttributes = weaponAttributes,
    weaponHit = weaponHit,
    armorName = armorName,
    armorStats = armorStats,
    armorSlots = armorSlots,
    unitName = unitName,
    unitKills = unitKills,
    magName = magName,
    magColor = magColor,
    magStats = magStats,
    magPB = magPB,
    magFeedTimer = magFeedTimer,
    toolName = toolName,
    toolAmount = toolAmount,
    techName = techName,
    techLevel = techLevel,
    mesetaName = mesetaName,
    mesetaAmount = mesetaAmount,
}
