local pmt = require("solylib.pmt")
local unitxt = require("solylib.unitxt")
local lib_characters = require("solylib.characters")

local _ItemArray = 0x00A8D81C
local _ItemArrayCount = 0x00A8D820

local _Meseta =  0xE4C
local _BankPointer =    0x00A95DE0 + 0x18

local _ItemID = 0xD8
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
local _ItemBarrierDfp = 0x1E4
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
local _PlayerIndex =  0x00A9C4F4

local NoOwner = -1
local Me = -2

-- Hardcoded to check for specific items.
local function IsKillCountItem(item)
    if item.data[1] == 0x00 then
        -- Weapon
        -- Includes Tsumikiri J-Sword and Excalibur because the kill count
        -- stays in the item data for most servers.
        return item.data[2] == 0x33 or item.data[2] == 0xAB or 
               item.data[2] == 0x32 or item.data[2] == 0xAC

    elseif item.data[1] == 0x01 and item.data[2] == 0x03 then
        -- Unit
        -- Includes Adept and Proof of Sword-Saint because kill count
        -- stays in the item data on most servers due to a bug.
        return item.data[3] == 0x4D or item.data[3] == 0x4F or
               item.data[3] == 0x50 or item.data[3] == 0x4E
    end
    return false
end

-- Looks at item.data and returns the kill count if one exists.
local function GetKillCountFromItemData(item)
    -- Offset because lua is 1-based...
    local offset = 1

    -- kill count is in big endian. Read both bytes and convert
    -- TODO: Could kill count be stored somewhere else in the item data? In another attr slot?
    local b1 = item.data[offset + 0x0A] or 0
    local b2 = item.data[offset + 0x0B] or 0 
    local dataKills = bit.bor(bit.lshift(b1, 8), b2)

    if bit.band(dataKills, 0x8000) == 0 then
        -- Not marked as having a kill count. Could be that the server
        -- removed it or the item was created without one.
        return 0
    end
    -- And strip the kill counter flag
    return bit.band(dataKills, 0x7FFF)
end

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

    local pmtW = pmt.GetItemData(item.data)

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

    if item.weapon.special == 0 then
        item.weapon.special = pmtW.weapon.special
    end

    item.weapon.isSRank = (item.data[2] >= 0x70 and item.data[2] < 0x89) or (item.data[2] >= 0xA5 and item.data[2] < 0xAA)
    -- SRANK
    if item.weapon.isSRank then
        item.weapon.nameSrank = unitxt.GetSRankName(item.data)
        item.weapon.specialSRank = item.data[3]
    -- NON SRANK
    else
        item.weapon.stats = {0,0,0,0,0,0}
        item.weapon.statpresence = {0,0,0,0,0}
        if item.data[7] < 6 then
            item.weapon.stats[item.data[7] + 1] = item.data[8]
            item.weapon.statpresence[item.data[7]] = 1
            if item.weapon.stats[item.data[7] + 1] > 127 then
                item.weapon.stats[item.data[7] + 1] = item.weapon.stats[item.data[7] + 1] - 256
            end
        end
        if item.data[9] < 6 then
            item.weapon.stats[item.data[9] + 1] = item.data[10]
            item.weapon.statpresence[item.data[9]] = 1
            if item.weapon.stats[item.data[9] + 1] > 127 then
                item.weapon.stats[item.data[9] + 1] = item.weapon.stats[item.data[9] + 1] - 256
            end
        end
        if item.data[11] < 6 then
            item.weapon.stats[item.data[11] + 1] = item.data[12]
            item.weapon.statpresence[item.data[11]] = 1
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

    local pmtF = pmt.GetItemData(item.data)
    item.armor.dfpMax = pmtF.armor.dfpR
    item.armor.evpMax = pmtF.armor.evpR
    return item
end

local function _ParseItemBarrier(item)
    item.armor.dfp = item.data[7]
    item.armor.evp = item.data[9]

    local pmtF = pmt.GetItemData(item.data)
    item.armor.dfpMax = pmtF.armor.dfpR
    item.armor.evpMax = pmtF.armor.evpR
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

local function ReadItemData(itemAddr)
    local item = {}
    item.address = itemAddr

    item.data = {0,0,0,0,0,0,0,0,0,0,0,0}

    item.id = pso.read_u32(itemAddr + _ItemID)

    -- Initialize the item data
    item.data[1] = pso.read_u8(itemAddr + _ItemCode + 0)
    item.data[2] = pso.read_u8(itemAddr + _ItemCode + 1)
    item.data[3] = pso.read_u8(itemAddr + _ItemCode + 2)
    item.data[4] = 0
    item.data[5] = 0
    item.data[6] = 0
    item.data[7] = 0
    item.data[8] = 0
    item.data[9] = 0
    item.data[10] = 0
    item.data[11] = 0
    item.data[12] = 0
    item.data[13] = 0
    item.data[14] = 0
    item.data[15] = 0
    item.data[16] = 0

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

        if IsKillCountItem(item) then
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

            item = _ParseItemFrame(item)
        -- BARRIER
        elseif item.data[2] == 2 then
            item.armor = {}

            item.data[7] = pso.read_u8(itemAddr + _ItemBarrierDfp)
            item.data[9] = pso.read_u8(itemAddr + _ItemBarrierEvp)

            item = _ParseItemBarrier(item)
        -- UNIT
        elseif item.data[2] == 3 then
            item.unit = {}

            item.data[7] = pso.read_u8(itemAddr + _ItemUnitMod + 0)
            item.data[8] = pso.read_u8(itemAddr + _ItemUnitMod + 1)

            if IsKillCountItem(item) then
                item.kills = pso.read_u16(itemAddr + _ItemKills)
            end

            item = _ParseItemUnit(item)
        end
    -- MAG
    elseif item.data[1] == 2 then
        item.mag = {}

        -- Strip the level from the mag's hex.
        item.hex = bit.band(item.hex, 0xFFFF00)

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

        item.mag.timer = (29 + pso.read_f32(itemAddr + _ItemMagTimer)) / 30
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

local function ReadBankItemData(itemAddr)
    local item = {}
    item.address = itemAddr

    item.data = {0,0,0,0,0,0,0,0,0,0,0,0}

    item.id = pso.read_u32(itemAddr + 12)

    item.data[1] = pso.read_u8(itemAddr + 0)
    item.data[2] = pso.read_u8(itemAddr + 1)
    item.data[3] = pso.read_u8(itemAddr + 2)
    item.data[4] = pso.read_u8(itemAddr + 3)
    item.data[5] = pso.read_u8(itemAddr + 4)
    item.data[6] = pso.read_u8(itemAddr + 5)
    item.data[7] = pso.read_u8(itemAddr + 6)
    item.data[8] = pso.read_u8(itemAddr + 7)
    item.data[9] = pso.read_u8(itemAddr + 8)
    item.data[10] = pso.read_u8(itemAddr + 9)
    item.data[11] = pso.read_u8(itemAddr + 10)
    item.data[12] = pso.read_u8(itemAddr + 11)
    item.data[13] = pso.read_u8(itemAddr + 16)
    item.data[14] = pso.read_u8(itemAddr + 17)
    item.data[15] = pso.read_u8(itemAddr + 18)
    item.data[16] = pso.read_u8(itemAddr + 19)

    if item.data[1] == 3 then
        item.data[6] = pso.read_u8(itemAddr + 20)
    end

    item.hex = bit.lshift(item.data[1], 16) + bit.lshift(item.data[2],  8) + item.data[3]
    item.kills = 0

    item.equipped = false

    item.name = unitxt.GetItemName(pmt.GetItemUnitxtID(item.data))

    -- WEAPON
    if item.data[1] == 0 then
        item.weapon = {}

        if IsKillCountItem(item) then
            item.kills = GetKillCountFromItemData(item)
        end

        item = _ParseItemWeapon(item)
    -- ARMOR
    elseif item.data[1] == 1 then
        -- FRAME
        if item.data[2] == 1 then
            item.armor = {}

            item = _ParseItemFrame(item)
        -- BARRIER
        elseif item.data[2] == 2 then
            item.armor = {}

            item = _ParseItemBarrier(item)
        -- UNIT
        elseif item.data[2] == 3 then
            item.unit = {}

            if IsKillCountItem(item) then
                item.kills = GetKillCountFromItemData(item)
            end

            item = _ParseItemUnit(item)
        end
    -- MAG
    elseif item.data[1] == 2 then
        item.mag = {}

        item.mag.timer = 210
        item = _ParseItemMag(item)
    -- TOOL
    elseif item.data[1] == 3 then
        item.tool = {}
        if item.data[2] == 2 then
            item = _ParseItemTechnique(item)
        else
            item = _ParseItemTool(item)
        end
    -- MESETA
    elseif item.data[1] == 4 then
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
                local item = ReadItemData(itemAddr)
                item.index = itemIndex
                table.insert(itemTable, item)
            end
        end
    end

    return itemTable
end

-- Reads the item data for an item in the floor storage. The floor storage
-- contains only the 16 bytes of item data, item ID, and positional data.
local function ReadMultiFloorItemData(itemAddr, floorNumber)
    local _MultiFloorItemDataOffset = 0x10
    local _MultiFloorItemData2Offset = 0x20
    local _MultiFloorItemIDOffset = 0x1C

    local item = {}
    item.address = itemAddr
    item.floorNumber = floorNumber

    item.data = {0,0,0,0,0,0,0,0,0,0,0,0}

    item.id = pso.read_u32(itemAddr + _MultiFloorItemIDOffset)

    item.data[1] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 0)
    item.data[2] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 1)
    item.data[3] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 2)
    item.data[4] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 3)
    item.data[5] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 4)
    item.data[6] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 5)
    item.data[7] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 6)
    item.data[8] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 7)
    item.data[9] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 8)
    item.data[10] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 9)
    item.data[11] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 10)
    item.data[12] = pso.read_u8(itemAddr + _MultiFloorItemDataOffset + 11)
    item.data[13] = pso.read_u8(itemAddr + _MultiFloorItemData2Offset + 0)
    item.data[14] = pso.read_u8(itemAddr + _MultiFloorItemData2Offset + 1)
    item.data[15] = pso.read_u8(itemAddr + _MultiFloorItemData2Offset + 2)
    item.data[16] = pso.read_u8(itemAddr + _MultiFloorItemData2Offset + 3)

    item.hex = bit.lshift(item.data[1], 16) + bit.lshift(item.data[2],  8) + item.data[3]
    item.kills = 0
    item.equipped = false

    item.name = unitxt.GetItemName(pmt.GetItemUnitxtID(item.data))

    -- WEAPON
    if item.data[1] == 0 then
        item.weapon = {}

        if IsKillCountItem(item) then
            item.kills = GetKillCountFromItemData(item)
        end

        item = _ParseItemWeapon(item)
    -- ARMOR
    elseif item.data[1] == 1 then
        -- FRAME
        if item.data[2] == 1 then
            item.armor = {}

            item = _ParseItemFrame(item)
        -- BARRIER
        elseif item.data[2] == 2 then
            item.armor = {}

            item = _ParseItemBarrier(item)
        -- UNIT
        elseif item.data[2] == 3 then
            item.unit = {}

            if IsKillCountItem(item) then
                item.kills = GetKillCountFromItemData(item)
            end

            item = _ParseItemUnit(item)
        end
    -- MAG
    elseif item.data[1] == 2 then
        item.mag = {}

        -- No mag timer available for mags on other floors. Could maybe lookup the
        -- mag in the local floor items array if the item is on current floor.
        item.mag.timer = 210 -- 3 minutes and 30 seconds
        --item.mag.timer = pso.read_f32(itemAddr + _ItemMagTimer) / 30

        item = _ParseItemMag(item)
    -- TOOL
    elseif item.data[1] == 3 then
        item.tool = {}
        if item.data[2] == 2 then
            item = _ParseItemTechnique(item)
        else
            item = _ParseItemTool(item)
        end
    -- MESETA
    elseif item.data[1] == 4 then
        item = _ParseItemMeseta(item)
    end

    return item
end

local function GetMultiFloorItemList(inverted)
    local ptrsToFloorsArray = pso.read_u32(0xA8D8A0)
    local itemsPerFloorArray = pso.read_u32(0xA8D89C)
    local itemTable = {}
    local itemIndex = 0
    if (0 == ptrsToFloorsArray or 0 == itemsPerFloorArray) then
        return itemTable
    end

    local myFloor = lib_characters.GetCurrentFloorSelf()

    -- Loop through all floor numbers and read the stored floor items.
    -- Note that PSOBB has a limit on a vanilla client for number of items
    -- stored. But the current floor's items are generated on demand regardless
    -- of that storage limit. So for the current floor, read the item list using
    -- the regular code.
    for i=0,17 do
        if myFloor == i then
            local currentFloorItems = GetItemList(NoOwner, inverted)
            -- Append to the table
            for _,v in pairs(currentFloorItems) do
                table.insert(itemTable, v)
            end
        else
            local thisFloorsItems = pso.read_u32(ptrsToFloorsArray + 4 * i)
            local thisFloorsNumItems = pso.read_u32(itemsPerFloorArray + i * 4)
            local startIndex = 0
            local endIndex = thisFloorsNumItems - 1 -- lua is 1-based...
            for j=startIndex,endIndex,1 do
                local itemAddr = thisFloorsItems + j * 0x24
                local item = ReadMultiFloorItemData(itemAddr, i)
                table.insert(itemTable, item)
            end
        end
    end

    -- sort table by IDs. Since it's only floor items, no need to care about owner.
    local sortFunction =
        function (left, right)
            if inverted then
                return left.id > right.id
            else
                return left.id < right.id
            end
        end

    -- Sort the items in order by item ID. IDs are unique in the room so with 'inverted' set,
    -- the newest drops in the party would be at the top.
    table.sort(itemTable, sortFunction)
    -- Item index isn't very useful but for the Floor Reader on a single floor, it's just
    -- 1..max. Maintain that here because otherwise the indices are out of order.
    for itemIndex=1,#itemTable do
        itemTable[itemIndex].index = itemIndex
    end
    return itemTable
end

-- Reads a player's inventory (meseta and items)
-- If owner(index) is -2, the function will automatically obtain the client's playerIndex
local function GetInventory(playerIndex)
    if playerIndex == Me then
        playerIndex = pso.read_u32(_PlayerIndex)
    end

    local listItem = 0

    local playerAddr = pso.read_u32(_PlayerArray + 4 * playerIndex)
    if playerAddr ~= 0 then
        local listPtr = pso.read_u32(playerAddr + 0xDF4)
        if listPtr ~= 0 then
            local listAddr = pso.read_u32(listPtr + 0x1C4)
            if listAddr ~= 0 then
                listItem = pso.read_u32(listAddr + 0x18)
            end
        end
    end

    local inventory = {}
    inventory.meseta = 0
    if playerAddr ~= 0 then
        inventory.meseta = pso.read_u32(playerAddr + _Meseta)
    end

    inventory.items = {}
    local itemIndex = 0
    while listItem ~= 0 do
        local itemAddr = pso.read_u32(listItem + 0x1C)

        if itemAddr ~= 0 then
            itemIndex = itemIndex + 1
            local item = ReadItemData(itemAddr)
            item.index = itemIndex
            table.insert(inventory.items, item)
        end

        listItem = pso.read_u32(listItem + 0x10)
    end
    return inventory
end

-- Reads the client's bank (meseta and items)
local function GetBank()
    local bank = {}
    bank.meseta = 0
    bank.items = {}

    local bankAddress = pso.read_i32(_BankPointer)
    if bankAddress ~= 0 then
        bankAddress = bankAddress + 0x021C

        local count = pso.read_u8(bankAddress)
        bank.meseta = pso.read_i32(bankAddress + 4)

        local itemIndex = 0
        for i=1,count,1 do
            itemIndex = itemIndex + 1
            local item = ReadBankItemData(bankAddress + 8 + 24 * i - 24)
            item.index = itemIndex
            table.insert(bank.items, item)
        end
    end

    return bank
end

return
{
    NoOwner = NoOwner,
    Me = Me,
    GetItemList = GetItemList,
    GetInventory = GetInventory,
    GetBank = GetBank,
    GetMultiFloorItemList = GetMultiFloorItemList,
}
