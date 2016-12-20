local _uniPtr = 0x00A9CD50
local _uniItemOffset = 0x04

local _pmtPtr = 0x00A8DC94
local _pmtWeaponOff = 0x00
local _pmtArmorOff = 0x04
local _pmtUnitOff = 0x08
local _pmtMagOff = 0x10
local _pmtToolOff = 0x0C

local _loaded = false
local itemNameList = {}

local techNames = 
{
    "Foie", "Gifoie", "Rafoie",
    "Barta", "Gibarta", "Rabarta",
    "Zonde", "Gizonde", "Razonde",
    "Grants", "Deband",
    "Jellen", "Zalure",
    "Shifta", "Ryuker",
    "Resta", "Anti",
    "Reverser", "Megid",
}
local specialNames = 
{
    "None", 
    "Draw", "Drain", "Fill", "Gush",
    "Heart", "Mind", "Soul", "Geist", 
    "Master's", "Lord's", "King's",
    "Charge", "Spirit", "Berserk",
    "Ice", "Frost", "Freeze", "Blizzard",
    "Bind", "Hold", "Seize", "Arrest",
    "Heat", "Fire", "Flame", "Burning",
    "Shock", "Thunder", "Storm", "Tempest",
    "Dim", "Shadow", "Dark", "Hell",
    "Panic", "Riot", "Havoc", "Chaos",
    "Devil's", "Demon's",
}

local _GetItemNameString = function(id)
    local str
    
    address = pso.read_u32(_uniPtr)
    if address == 0 then
        return nil
    end
    
    address = address + _uniItemOffset
    address = pso.read_u32(address)
    if address == 0 then
        return nil
    end
    
    address = address + 4 * id
    address = pso.read_u32(address)
    if address == 0 then
        return nil
    end
    
    str = pso.read_wstr(address, 128)
    return str
end

local _GetItemID = function(type, group, index)
    local id = -1
    
    address = pso.read_u32(_pmtPtr)
    if address == 0 then
        return -1
    end
    
    if type == 0 then
        address = pso.read_u32(address + _pmtWeaponOff)
        if address == 0 then
            return -1
        end
        
        groupAddress = address + 8 * group
        
        count = pso.read_u32(groupAddress)
        address = pso.read_u32(groupAddress + 4)
        if count < index or address == 0 then
            return -1
        end
        
        id = pso.read_i32(address + 44 * index)
    elseif type == 1 then
        if group == 1 or group == 2 then
            address = pso.read_u32(address + _pmtArmorOff)
            if address == 0 then
                return -1
            end
            
            
            address = address + 8 * (group - 1)
            
            count = pso.read_u32(address)
            address = pso.read_u32(address + 4)
            if count < index or address == 0 then
                return -1
            end
            
            id = pso.read_i32(address + 32 * index)
        elseif group == 3 then
            address = pso.read_u32(address + _pmtUnitOff)
            
            count = pso.read_u32(address)
            address = pso.read_u32(address + 4)
            if count < index or address == 0 then
                return -1
            end
            
            id = pso.read_i32(address + 20 * index)
        end
    elseif type == 2 then
        address = pso.read_u32(address + _pmtMagOff)
        
        count = pso.read_u32(address)
        address = pso.read_u32(address + 4)
        if count < group or address == 0 then
            return -1
        end
        
        id = pso.read_i32(address + 28 * group)
    elseif type == 3 then
        address = pso.read_u32(address + _pmtToolOff)
        if address == 0 then
            return -1
        end
        
        groupAddress = address + 8 * group
        
        count = pso.read_u32(groupAddress)
        address = pso.read_u32(groupAddress + 4)
        if count < index or address == 0 then
            return -1
        end
        
        id = pso.read_i32(address + 24 * index)
    end
    
    return id
end

local formatItemName = function(data, name)
    local str
    
    if data[1] == 0 then
        str = "Weapon "
    elseif data[1] == 1 then
        if data[2] == 1 or data[2] == 2 then
            str = "Armor  "
        elseif data[2] == 3 then
            str = "Unit   "
        end
    elseif data[1] == 2 then
        str = "Mag    "
    elseif data[1] == 3 then
        str = "Tool   "
    end
    
    str = str .. string.format("[%02X%02X%02X] %s", 
        data[1], data[2], data[3], name)
    
    return str
end

function getItemName(data, format)
    local str = ""
    
    -- check if its cached
    if false then
        str = "C " .. str
    else
        -- get item id
        id = _GetItemID(data[1], data[2], data[3])
        
        if id == -1 then
            str = nil
        else
            str = _GetItemNameString(id)
        end
    end
    
    if str ~= nil and format then
        str = formatItemName(data, str)
    end
    
    return str
end

function refreshItemNames()
    print("Items refreshed")
end

return {
    refresh = refresh,
    getItemName = getItemName,
}