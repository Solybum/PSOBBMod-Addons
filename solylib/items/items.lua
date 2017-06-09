local pmt = require("solylib.pmt")
local unitxt = require("solylib.unitxt")

local _ItemArray = 0x00A8D81C
local _ItemArrayCount = 0x00A8D820

local _ItemOwner = 0xE4
local _ItemCode = 0xF2
local _ItemEquipped = 0x190
local _ItemKills = 0xE8
local _ItemWrapped = 0xDC -- value & 0x00000400
local _ItemWepGrind = 0x1F5
local _ItemWepSpecial = 0x1F6
local _ItemWepStats = 0x1C8
local _ItemArmSlots = 0x1B8
local _ItemFrameDfp = 0x1B9
local _ItemFrameEvp = 0x1BA
local _ItemFrameDfpMax = 0x1BB
local _ItemFrameEvpMax = 0x1BC
local _ItemBarrierDfp = 0x1E4
local _ItemBarrierEvp = 0x1E5
local _ItemBarrierDfpMax = 0x1E6
local _ItemBarrierEvpMax = 0x1E7
local _ItemUnitMod = 0x1DC
local _ItemMagStats = 0x1C0
local _ItemMagPBHas = 0x1C8
local _ItemMagPB = 0x1C9
local _ItemMagColor = 0x1CA
local _ItemMagSync = 0x1BE
local _ItemMagIQ = 0x1BC
local _ItemMagTimer = 0x1B4
local _ItemToolCount = 0x104
local _ItemTechType = 0x108
local _ItemMesetaAmount = 0x100

local _PlayerArray = 0x00A94254
local _PlayerIndex =  0x00A9C4F4

local NoOwner = -1
local Me = -2

local function _GetLeftPBValue(pb)
    local pbs = { 0,0,0,0,0,0,0,0, }

    pbs[bit.band(pb, 7) + 1] = 1
    pbs[bit.rshift(bit.band(pb, 56), 3) + 1] = 1

    pb = bit.band(pb, 0xC0)
    pb = bit.rshift(pb, 6)

    for i=1,6,1 do
        if pbs[i] == 1 then
            -- continue
        else
            if pb == 0 then
                return (i - 1)
            else
                pb = pb - 1
            end
        end
    end
    return -1;
end

local function _ParseItemWeapon(item)
    item.weapon = {}

    item.weapon.wrapped = false
    item.weapon.untekked = false
    if item.data[5] > 0xBF then
        item.weapon.wrapped = true
        item.weapon.untekked = true
    elseif item.data[5] > 0x7F then
        item.weapon.untekked = true
    elseif item.data[5] > 0x3F then
        item.weapon.wrapped = true
    end

    item.weapon.grind = item.data[4]
    item.weapon.special = item.data[5] % 64

    item.weapon.isSRank = (item.data[2] >= 0x70 and item.data[2] < 0x89) or (item.data[2] >= 0xA5 and item.data[2] < 0xAA)
    -- SRANK
    if item.weapon.isSRank then
        item.weapon.nameSrank = unitxt.GetSRankName(item.data)
        item.weapon.specialSRank = item.data[3]
    -- NON SRANK
    else
        item.weapon.stats = {0,0,0,0,0,0}
        if item.data[7] < 6 then
            item.weapon.stats[item.data[7] + 1] = item.data[8]
            if item.weapon.stats[item.data[7] + 1] > 127 then
                item.weapon.stats[item.data[7] + 1] = item.weapon.stats[item.data[7] + 1] - 256
            end
        end
        if item.data[9] < 6 then
            item.weapon.stats[item.data[9] + 1] = item.data[10]
            if item.weapon.stats[item.data[9] + 1] > 127 then
                item.weapon.stats[item.data[9] + 1] = item.weapon.stats[item.data[9] + 1] - 256
            end
        end
        if item.data[11] < 6 then
            item.weapon.stats[item.data[11] + 1] = item.data[12]
            if item.weapon.stats[item.data[11] + 1] > 127 then
                item.weapon.stats[item.data[11] + 1] = item.weapon.stats[item.data[11] + 1] - 256
            end
        end
    end
    return item
end

local function _ParseItemFrame(item)
    item.armor.slots = item.data[6]
    item.armor.dfp = item.data[7]
    item.armor.evp = item.data[9]
    -- This is not how it actually works in game, the item doesn't know
    -- about it's max data but since the data is empty, we'll roll with it
    item.armor.dfpMax = item.data[8]
    item.armor.evpMax = item.data[10]
    return item
end

local function _ParseItemBarrier(item)
    item.armor.dfp = item.data[7]
    item.armor.evp = item.data[9]
    -- This is not how it actually works in game, the item doesn't know
    -- about it's max data but since the data is empty, we'll roll with it
    item.armor.dfpMax = item.data[8]
    item.armor.evpMax = item.data[10]
    return item
end

local function _ParseItemUnit(item)
    local mod = item.data[7]
    if mod > 127 then
        mod = mod - 256
    end

    item.unit.mod = 0
    if mod == 0 then
        item.unit.mod = 0
    elseif mod == 1 then
        item.unit.mod = 1
    elseif mod > 1 then
        item.unit.mod = 2
    elseif mod == -1 then
        item.unit.mod = -1
    elseif mod < -1 then
        item.unit.mod = -2
    end

    return item
end

local function _ParseItemMag(item)
    item.mag.color = item.data[16]

    item.mag.def = (bit.lshift(item.data[6],  8) + item.data[5] ) / 100.0
    item.mag.pow = (bit.lshift(item.data[8],  8) + item.data[7] ) / 100.0
    item.mag.dex = (bit.lshift(item.data[10], 8) + item.data[9] ) / 100.0
    item.mag.mind = (bit.lshift(item.data[12], 8) + item.data[11]) / 100.0

    if bit.band(item.data[15], 1) ~= 0 then
        item.mag.pbC = bit.band(item.data[4], 7)
    else
        item.mag.pbC = -1
    end
    if bit.band(item.data[15], 2) ~= 0 then
        item.mag.pbR = bit.rshift(bit.band(item.data[4], 56), 3)
    else
        item.mag.pbR = -1
    end
    if bit.band(item.data[15], 4) ~= 0 then
        item.mag.pbL = _GetLeftPBValue(item.data[4])
    else
        item.mag.pbL = -1
    end

    return item
end

local function _ParseItemTool(item)
    item.tool.count = item.data[6]
    return item
end

local function _ParseItemTechnique(item)
    item.hex = bit.lshift(5, 16) + bit.lshift(item.data[5],  8) + item.data[3]
    item.name = unitxt.GetTechniqueName(item.data[5])
    item.tool.level = item.data[3] + 1
    return item
end

local function _ParseItemMeseta(item)
    item.name = "Meseta"
    item.meseta = 
        bit.lshift(item.data[13],  0) +
        bit.lshift(item.data[14],  8) +
        bit.lshift(item.data[15], 16) +
        bit.lshift(item.data[16], 24)
    return item
end

local function ReadItemFromItemPool(itemAddr)
    local item = {}
    item.address = itemAddr

    item.data = {0,0,0,0,0,0,0,0,0,0,0,0}

    item.data[1] = pso.read_u8(itemAddr + _ItemCode + 0)
    item.data[2] = pso.read_u8(itemAddr + _ItemCode + 1)
    item.data[3] = pso.read_u8(itemAddr + _ItemCode + 2)
    item.hex = bit.lshift(item.data[1], 16) + bit.lshift(item.data[2],  8) + item.data[3]
    item.kills = 0

    item.equipped = bit.band(pso.read_u8(itemAddr +  _ItemEquipped), 1) == 1

    item.name = unitxt.GetItemName(pmt.GetItemUnitxtID(item.data))

    -- WEAPON
    if item.data[1] == 0 then
        item.weapon = {}

        item.data[4] = pso.read_u8(itemAddr + _ItemWepGrind)
        item.data[5] = pso.read_u8(itemAddr + _ItemWepSpecial)
        item.data[7] = pso.read_u8(itemAddr + _ItemWepStats + 0)
        item.data[8] = pso.read_u8(itemAddr + _ItemWepStats + 1)
        item.data[9] = pso.read_u8(itemAddr + _ItemWepStats + 2)
        item.data[10] = pso.read_u8(itemAddr + _ItemWepStats + 3)
        item.data[11] = pso.read_u8(itemAddr + _ItemWepStats + 4)
        item.data[12] = pso.read_u8(itemAddr + _ItemWepStats + 5)

        if item.data[2] == 0x33 or item.data[2] == 0xAB then
            item.kills = pso.read_u16(itemAddr + _ItemKills)
        end

        item = _ParseItemWeapon(item)
    -- ARMOR
    elseif item.data[1] == 1 then
        -- FRAME
        if item.data[2] == 1 then
            item.armor = {}

            item.data[6] = pso.read_u8(itemAddr + _ItemArmSlots)
            item.data[7] = pso.read_u8(itemAddr + _ItemFrameDfp)
            item.data[9] = pso.read_u8(itemAddr + _ItemFrameEvp)
            -- This is not how it actually works in game, the item doesn't know
            -- about it's max data but since the data is empty, we'll roll with it
            item.data[8] = pso.read_u8(itemAddr + _ItemFrameDfpMax)
            item.data[10] = pso.read_u8(itemAddr + _ItemFrameEvpMax)

            item = _ParseItemFrame(item)
        -- BARRIER
        elseif item.data[2] == 2 then
            item.armor = {}

            item.data[7] = pso.read_u8(itemAddr + _ItemBarrierDfp)
            item.data[9] = pso.read_u8(itemAddr + _ItemBarrierEvp)
            -- This is not how it actually works in game, the item doesn't know
            -- about it's max data but since the data is empty, we'll roll with it
            item.data[8] = pso.read_u8(itemAddr + _ItemBarrierDfpMax)
            item.data[10] = pso.read_u8(itemAddr + _ItemBarrierEvpMax)

            item = _ParseItemBarrier(item)
        -- UNIT
        elseif item.data[2] == 3 then
            item.unit = {}

            item.data[7] = pso.read_u8(itemAddr + _ItemUnitMod + 0)
            item.data[8] = pso.read_u8(itemAddr + _ItemUnitMod + 1)

            if item.data[3] == 0x4D or item.data[3] == 0x4F then
                item.kills = pso.read_u16(itemAddr + _ItemKills)
            end

            item = _ParseItemUnit(item)
        end
    -- MAG
    elseif item.data[1] == 2 then
        item.mag = {}

        item.data[4] = pso.read_u8(itemAddr + _ItemMagPB)
        item.data[5] = pso.read_u8(itemAddr + _ItemMagStats + 0)
        item.data[6] = pso.read_u8(itemAddr + _ItemMagStats + 1)
        item.data[7] = pso.read_u8(itemAddr + _ItemMagStats + 2)
        item.data[8] = pso.read_u8(itemAddr + _ItemMagStats + 3)
        item.data[9] = pso.read_u8(itemAddr + _ItemMagStats + 4)
        item.data[10] = pso.read_u8(itemAddr + _ItemMagStats + 5)
        item.data[11] = pso.read_u8(itemAddr + _ItemMagStats + 6)
        item.data[12] = pso.read_u8(itemAddr + _ItemMagStats + 7)
        item.data[13] = pso.read_u8(itemAddr + _ItemMagSync)
        item.data[14] = pso.read_u8(itemAddr + _ItemMagIQ)
        item.data[15] = pso.read_u8(itemAddr + _ItemMagPBHas)
        item.data[16] = pso.read_u8(itemAddr + _ItemMagColor)

        item.mag.timer = pso.read_f32(itemAddr + _ItemMagTimer) / 30
        item = _ParseItemMag(item)
    -- TOOL
    elseif item.data[1] == 3 then
        item.tool = {}
        if item.data[2] == 2 then
            item.data[5] = pso.read_u8(itemAddr + _ItemTechType)

            item = _ParseItemTechnique(item)
        else
            item.data[6] = bit.bxor(pso.read_u32(itemAddr + _ItemToolCount), (itemAddr + _ItemToolCount))

            item = _ParseItemTool(item)
        end
    -- MESETA
    elseif item.data[1] == 4 then
        item.data[13] = pso.read_u8(itemAddr + _ItemMesetaAmount + 0)
        item.data[14] = pso.read_u8(itemAddr + _ItemMesetaAmount + 1)
        item.data[15] = pso.read_u8(itemAddr + _ItemMesetaAmount + 2)
        item.data[16] = pso.read_u8(itemAddr + _ItemMesetaAmount + 3)

        item = _ParseItemMeseta(item)
    end

    return item
end

-- Reads items from the item pool
-- This function reads items from the owner (index) only
-- If owner(index) is -1, floor items will be read
-- if inverted is true, the item list will be read backwards
-- This is useful for the floor items, so the latest items
-- will be shown at the top
local function GetItemList(playerIndex, inverted)
    inverted = inverted or false

    if playerIndex == Me then
        playerIndex = pso.read_u32(_PlayerIndex)
    end

    local itemCount = pso.read_u32(_ItemArrayCount)
    local itemArray = pso.read_u32(_ItemArray)

    local startIndex = 1
    local endIndex = itemCount
    local step = 1

    if inverted then
        startIndex = itemCount
        endIndex = 1
        step = -1
    end

    local itemTable = {}
    local itemIndex = 0
    for i=startIndex, endIndex, step do
        local itemAddr = pso.read_u32(itemArray + 4 * (i - 1))
        if itemAddr ~= 0 then
            local owner = pso.read_i8(itemAddr + _ItemOwner)
            if owner == playerIndex then
                itemIndex = itemIndex + 1
                local item = ReadItemFromItemPool(itemAddr)
                item.index = itemIndex
                table.insert(itemTable, item)
            end
        end
    end

    return itemTable
end

return
{
    NoOwner = NoOwner,
    Me = Me,
    GetItemList = GetItemList
}
