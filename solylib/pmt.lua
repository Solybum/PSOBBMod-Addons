local pmtPointer = 0x00A8DC94
local pmtWeaponOffset = 0x00
local pmtArmorOffset = 0x04
local pmtUnitOffset = 0x08
local pmtMagOffset = 0x10
local pmtToolOffset = 0x0C

local pmtAddress = 0

local function LoadPMTAddress()
    pmtAddress = pso.read_u32(pmtPointer)
    return pmtAddress ~= 0
end

local function _GetItemAddress(type, group, index)
    local result = 0
    if LoadPMTAddress() ~= 0 then
        if type == 0 then
            local weaponAddress = pso.read_u32(pmtAddress + pmtWeaponOffset)
            if weaponAddress ~= 0 then
                local groupAddress = weaponAddress + 8 * group

                local count = pso.read_u32(groupAddress)
                local itemAddress = pso.read_u32(groupAddress + 4)

                if index < count and itemAddress ~= 0 then
                    result = itemAddress + 44 * index
                end
            end
        elseif type == 1 then
            if group == 1 or group == 2 then
                local armorAddress = pso.read_u32(pmtAddress + pmtArmorOffset)
                if armorAddress ~= 0 then
                    local groupAddress = armorAddress + 8 * (group - 1)

                    local count = pso.read_u32(groupAddress)
                    local itemAddress = pso.read_u32(groupAddress + 4)

                    if index < count and itemAddress ~= 0 then
                        result = itemAddress + 32 * index
                    end
                end
            elseif group == 3 then
                local unitAddress = pso.read_u32(pmtAddress + pmtUnitOffset)

                local count = pso.read_u32(unitAddress)
                local itemAddress = pso.read_u32(unitAddress + 4)

                if index < count and itemAddress ~= 0 then
                    result = itemAddress + 20 * index
                end
            end
        elseif type == 2 then
            local magAddress = pso.read_u32(pmtAddress + pmtMagOffset)

            local count = pso.read_u32(magAddress)
            local itemAddress = pso.read_u32(magAddress + 4)

            if group < count and itemAddress ~= 0 then
                result = itemAddress + 28 * group
            end
        elseif type == 3 then
            local toolAddress = pso.read_u32(pmtAddress + pmtToolOffset)
            if toolAddress ~= 0 then
                local groupAddress = toolAddress + 8 * group

                local count = pso.read_u32(groupAddress)
                local itemAddress = pso.read_u32(groupAddress + 4)

                if index < count and itemAddress ~= 0 then
                    result = itemAddress + 24 * index
                end
            end
        end
    end
    return result
end

-- Easy UnitxtID lookup
local function _GetItemUnitxtID(type, group, index)
    local id = -1
    local itemAddress = _GetItemAddress(type, group, index)
    if itemAddress ~= 0 then
        id = pso.read_i32(itemAddress)
    end
    return id
end
local function GetItemUnitxtID(data)
    return _GetItemUnitxtID(data[1], data[2], data[3])
end

-- Full item data lookup
local function _GetWeaponData(group, index, itemdata, itemAddress)
    
    return itemdata
end
local function _GetArmorData(group, index, itemdata, itemAddress)
    itemdata.armor = {}
    itemdata.armor.dfp = 0
    itemdata.armor.evp = 0
    itemdata.armor.blockParticle = 0
    itemdata.armor.blockEffect = 26
    itemdata.armor._class = 0
    itemdata.armor.level = 1
    itemdata.armor.efr = 0
    itemdata.armor.eth = 0
    itemdata.armor.eic = 0
    itemdata.armor.edk = 0
    itemdata.armor.elt = 0
    itemdata.armor.dfpR = 0
    itemdata.armor.evpR = 0
    itemdata.armor.statBoost = 0
    itemdata.armor.techBoost = 0
    itemdata.armor.unknown1 = 0
    itemdata.armor.unknown2 = 0

    itemdata.id =                   pso.read_u32(itemAddress + 32 * index + 0)
    itemdata.model =                pso.read_u16(itemAddress + 32 * index + 4)
    itemdata.texture =              pso.read_u16(itemAddress + 32 * index + 6)
    itemdata.teampoints =           pso.read_u32(itemAddress + 32 * index + 8)
    itemdata.armor.dfp =            pso.read_u16(itemAddress + 32 * index + 12)
    itemdata.armor.evp =            pso.read_u16(itemAddress + 32 * index + 14)
    itemdata.armor.blockParticle =  pso.read_u8(itemAddress + 32 * index + 16)
    itemdata.armor.blockEffect =    pso.read_u8(itemAddress + 32 * index + 17)
    itemdata.armor._class =         pso.read_u16(itemAddress + 32 * index + 18)
    itemdata.armor.level =          pso.read_u8(itemAddress + 32 * index + 20) + 1
    itemdata.armor.efr =            pso.read_i8(itemAddress + 32 * index + 21)
    itemdata.armor.eth =            pso.read_i8(itemAddress + 32 * index + 22)
    itemdata.armor.eic =            pso.read_i8(itemAddress + 32 * index + 23)
    itemdata.armor.edk =            pso.read_i8(itemAddress + 32 * index + 24)
    itemdata.armor.elt =            pso.read_i8(itemAddress + 32 * index + 25)
    itemdata.armor.dfpR =           pso.read_u8(itemAddress + 32 * index + 26)
    itemdata.armor.evpR =           pso.read_u8(itemAddress + 32 * index + 27)
    itemdata.armor.statBoost =      pso.read_u8(itemAddress + 32 * index + 28)
    itemdata.armor.techBoost =      pso.read_u8(itemAddress + 32 * index + 29)
    itemdata.armor.unknown1 =       pso.read_u8(itemAddress + 32 * index + 30)
    itemdata.armor.unknown2 =       pso.read_u8(itemAddress + 32 * index + 31)

    return itemdata
end
local function _GetUnitData(index, itemdata, itemAddress)

    return itemdata
end
local function _GetMagData(index, itemdata, itemAddress)

    return itemdata
end
local function _GetToolData(group, index, itemdata, itemAddress)

    return itemdata
end

local function _GetItemData(type, group, index)
    local itemdata = {}
    itemdata.id = -1
    itemdata.model = -1
    itemdata.texture = -1
    itemdata.teampoints = 0

    local itemAddress = _GetItemAddress(type, group, index)
    if itemAddress ~= 0 then
        if type == 0 then
            itemdata = _GetWeaponData(group, index, itemdata, itemAddress)
        elseif type == 1 then
            if group == 1 or group == 2 then
                itemdata = _GetArmorData(group, index, itemdata, itemAddress)
            elseif group == 3 then
                itemdata = _GetUnitData(index, itemdata, itemAddress)
            end
        elseif type == 2 then
            itemdata = _GetMagData(index, itemdata, itemAddress)
        elseif type == 3 then
            itemdata = _GetToolData(group, index, itemdata, itemAddress)
        end
    end
    return itemdata
end
local function GetItemData(data)
    return _GetItemData(data[1], data[2], data[3])
end

return
{
    GetItemUnitxtID = GetItemUnitxtID,
    GetItemData = GetItemData,
}
