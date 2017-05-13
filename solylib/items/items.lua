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
local _ItemFrameDef = 0x1B9
local _ItemFrameEvp = 0x1BA
local _ItemBarrierDef = 0x1E4
local _ItemBarrierEvp = 0x1E5
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
                return (i - 1);
            else
                pb = pb - 1
            end
        end
    end
    return -1;
end

local function _ParseItemMag(item)
    item.name = unitxt.GetItemName(pmt.GetItemUnitxtID(item.data))
    item.mag.Color = unitxt.GetMagColor(item.data[16])

    item.mag.DFP = (bit.lshift(item.data[6],  8) + item.data[5] ) / 100.0
    item.mag.ATP = (bit.lshift(item.data[8],  8) + item.data[7] ) / 100.0
    item.mag.ATA = (bit.lshift(item.data[10], 8) + item.data[9] ) / 100.0
    item.mag.MST = (bit.lshift(item.data[12], 8) + item.data[11]) / 100.0

    if bit.band(item.data[15], 1) ~= 0 then
        item.mag.pbCenter = bit.band(item.data[4], 7)
    else
        item.mag.pbCenter = -1
    end
    if bit.band(item.data[15], 2) ~= 0 then
        item.mag.pbRight = bit.rshift(bit.band(item.data[4], 56), 3)
    else
        item.mag.pbRight = -1
    end
    if bit.band(item.data[15], 4) ~= 0 then
        item.mag.pbLeft = _GetLeftPBValue(item.data[4])
    else
        item.mag.pbLeft = -1
    end

    return item
end

local function ReadItemFromItemPool(itemAddr, floor)
    floor = floor or false

    local item = {}
    item.data = {0,0,0,0,0,0,0,0,0,0,0,0}

    item.type = -1

    item.data[1] = pso.read_u8(itemAddr + _ItemCode + 0)
    item.data[2] = pso.read_u8(itemAddr + _ItemCode + 1)
    item.data[3] = pso.read_u8(itemAddr + _ItemCode + 2)
    item.equipped = bit.band(pso.read_u8(itemAddr +  _ItemEquipped), 1) == 1

    -- WEAPON
    if item.data[1] == 0 then
        item.type = 0
        item.subtype = 0
    
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
    
        -- itemStr = formatPrintWeapon(index, itemName, item, equipped, floor)
    -- ARMOR
    elseif item.data[1] == 1 then
        -- FRAME
        if item.data[2] == 1 then
            item.type = 1
            item.subtype = 0
    
            item.data[6] = pso.read_u8(itemAddr + _ItemArmSlots)
            item.data[7] = pso.read_u8(itemAddr + _ItemFrameDef)
            item.data[9] = pso.read_u8(itemAddr + _ItemFrameEvp)
    
            -- itemStr = formatPrintArmor(index, itemName, item, equipped)
        -- BARRIER
        elseif item.data[2] == 2 then
            item.type = 1
            item.subtype = 1
    
            item.data[7] = pso.read_u8(itemAddr + _ItemBarrierDef)
            item.data[9] = pso.read_u8(itemAddr + _ItemBarrierEvp)
    
            --itemStr = formatPrintArmor(index, itemName, item, equipped)
        -- UNIT
        elseif item.data[2] == 3 then
            item.type = 1
            item.subtype = 2
    
            item.data[7] = pso.read_u8(itemAddr + _ItemUnitMod + 0)
            item.data[8] = pso.read_u8(itemAddr + _ItemUnitMod + 1)
    
            if item.data[3] == 0x4D or item.data[3] == 0x4F then
                item.kills = pso.read_u16(itemAddr + _ItemKills)
            end
    
            -- itemStr = formatPrintUnit(index, itemName, item, equipped)
        end
    -- MAG
    elseif item.data[1] == 2 then
        item.type = 2
    
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
        item.type = 3
        if item.data[2] == 2 then
            item.subtype = 1
    
            item.data[5] = pso.read_u8(itemAddr + _ItemTechType)
        else
            item.subtype = 0
    
            item.data[6] = bit.bxor(pso.read_u32(itemAddr + _ItemToolCount), (itemAddr + _ItemToolCount))
        end
    -- MESETA
    elseif item.data[1] == 4 then
        item.type = 4
    
        item.meseta = pso.read_u32(itemAddr + _ItemMesetaAmount)
    end

    return item;
end

-- Reads items from the item pool
-- This function reads items from the owner (index) only
-- If owner(index) is -1, floor items will be read
-- if inverted is true, the item list will be read backwards
-- This is useful for the floor items, so the latest items
-- will be shown at the top
local function GetItemList(playerIndex, inverted)
    inverted = inverted or false

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

    for i=startIndex, endIndex, step do
        local itemAddr = pso.read_u32(itemArray + 4 * (i - 1))

        if itemAddr ~= 0 then
            local owner = pso.read_i8(itemAddr + _ItemOwner)

            if owner == playerIndex then
                local item = ReadItemFromItemPool(itemAddr, playerIndex == -1)
                table.insert(itemTable, item)
            end
        end
    end

    return itemTable;
end

return
{
    GetItemList = GetItemList
}
