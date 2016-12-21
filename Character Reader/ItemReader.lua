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
local srankSpecial = 
{
    "", "Jellen", "Zalure", "HP Regeneration", "TP Regeneration",
    "Burning", "Tempest", "Blizzard", "Arrest", "Chaos", "Hell",
    "Spirit", "Berserk", "Demon's", "Gush", "Geist", "King's",
}
local magColor = 
{
    "Red", "Blue", "Yellow", "Green", "Purple", "Black", "White",
    "Cyan", "Brown", "Orange", "Slate Blue", "Olive", "Turquoise",
    "Fuschia", "Grey", "Cream", "Pink", "Dark Green",
}
local photonBlast = 
{
    "Farlla", "Estilla", "Golla", "Pilla", "Leilla", "Twins", "Invalid_1", "Invalid_2"
}
local leftPhotonBlast = 
{
    1,2,1,1,1,1,1,1,2,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
    2,3,3,2,2,2,2,2,3,2,3,2,2,2,2,2,
    3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,
    2,2,1,1,1,1,1,1,2,2,1,1,1,1,1,1,
    2,2,1,1,1,1,1,1,2,2,1,1,1,1,1,1,
    3,4,4,4,3,3,3,3,4,3,4,4,3,3,3,3,
    4,4,3,4,3,3,3,3,4,4,4,2,2,2,2,2,
    3,3,3,2,2,2,2,2,3,3,3,2,2,2,2,2,
    3,3,3,2,2,2,2,2,3,3,3,2,2,2,2,2,
    4,5,5,5,5,4,4,4,5,4,5,5,5,4,4,4,
    5,5,4,5,5,4,4,4,5,5,5,4,5,4,4,4,
    5,5,5,5,5,3,3,3,4,4,4,4,3,3,3,3,
    4,4,4,4,3,3,3,3,4,4,4,4,3,3,3,3,
}

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

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
function getItemName(data)
    local str = ""
    
    -- check if its cached
    if false then
        str = "C " .. str
    else
        -- get item id
        if data[1] == 3 and data[2] == 2 then
            id = _GetItemID(data[1], data[2], data[5])
        else
            id = _GetItemID(data[1], data[2], data[3])
        end
        
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

local formatWeaponName = function(data, name)
    local str = ""
    str = name
    
    if (data[2] > 0x6F and data[2] < 0x89) or (data[2] > 0xA4 and data[2] < 0xAA) then
        str = "SRANK "
        
        srankName = ""
        temp = 0
        for i=1,6,2 do
            n = bit.lshift(data[7 + i - 1], 8) + data[8 + i - 1]
            n = n - 0x8000
            
            temp = math.floor(n / 0x400) + 0x40
            if temp > 0x40 and temp < 0x60 and i ~= 1 then
                srankName = srankName .. string.char(temp)
            end
            n = n % 0x400
            
            temp = math.floor(n / 0x20) + 0x40
            if temp > 0x40 and temp < 0x60 then
                srankName = srankName .. string.char(temp)
            end
            n = n % 0x20
            
            temp = n + 0x40
            if temp > 0x40 and temp < 0x60 then
                srankName = srankName .. string.char(temp)
            end
        end
        str = str .. srankName
        
        str = str .. " " .. name
        
        if data[4] > 0 then
            str = str .. string.format(" +%i", data[4])
        end
        
        
        spec = data[3]
        if spec ~= 0 then
            if spec < tablelength(srankSpecial) then
                str = str .. string.format(" [%s]", srankSpecial[spec + 1])
            else
                str = str .. " <special>"
            end
        end
    else
        if data[4] > 0 then
            str = str .. string.format(" +%i", data[4])
        end
        
        stats = {0,0,0,0,0,0}
        if data[7] < 6 then
            stats[data[7] + 1] = data[8]
            if stats[data[7] + 1] > 127 then
                stats[data[7] + 1] = stats[data[7] + 1] - 256
            end
        end
        if data[9] < 6 then
            stats[data[9] + 1] = data[10]
            if stats[data[9] + 1] > 127 then
                stats[data[9] + 1] = stats[data[9] + 1] - 256
            end
        end
        if data[11] < 6 then
            stats[data[11] + 1] = data[12]
            if stats[data[11] + 1] > 127 then
                stats[data[11] + 1] = stats[data[11] + 1] - 256
            end
        end
        
        spec = data[5] % 64
        if spec ~= 0 then
        
            if spec < tablelength(specialNames) then
                str = str .. string.format(" [%s]", specialNames[spec + 1])
            else
                str = str .. " <special>"
            end
        end
        
        str = str .. string.format(" [%i/%i/%i/%i/%i]",
            stats[2],
            stats[3],
            stats[4],
            stats[5],
            stats[6])
    end
    
    if data[5] > 0xBF then
        str = str .. " [Untekked | Wrapped]"
    elseif data[5] > 0x7F then
        str = str .. " [Untekked]"
    elseif data[5] > 0x3F then
        str = str .. " [Wrapped]"
    end
    
    return str
end
local formatArmorName = function(data, name)
    local str = ""
    
    str = str .. name
    
    str = str .. 
        string.format(" [DEF: %i/EVP: %i]",
            bit.lshift(data[8], 8) + data[7],
            bit.lshift(data[10], 8) + data[9])
    
    if data[2] == 1 then 
        str = str .. string.format(" [%is]", data[6])
    end
    
    return str
end
local formatUnitName = function(data, name)
    local str = ""
    
    str = str .. name
    mod = data[7]
    
    if mod > 127 then
        mod = mod - 128
    end
    
    if mod == 0 then
    elseif mod == 1 then
        str = str .. "+"
    elseif mod > 1 then
        str = str .. "++"
    elseif mod == -1 then
        str = str .. "-"
    elseif mod < -1 then
        str = str .. "--"
    end
    
    if data[3] == 0x4D or data[3] == 0x4F then
        kills = bit.lshift(data[11], 8) + data[12]
        str = str .. string.format(" [%ik]", kills - 0x8000)
    end
    
    return str
end
local formatMagName = function(data, name)
    local str = ""
    
    str = str .. name
    --if data[16] < tablelength(magColor) then
    --    str = str .. " [" .. magColor[data[16] + 1] .. "]"
    --else
    --    str = " <color>"
    --end
    
    atts = {}
    for i=1,4,1 do
        val = bit.lshift(data[6 + (i - 1) * 2],  8) + data[5 + (i - 1) * 2]
        table.insert(atts, val/100)
    end
    
    str = str .. string.format(" [%.2f/%.2f/%.2f/%.2f]", atts[1], atts[2], atts[3], atts[4])
    
    --if bit.band(data[15], 4) == 4 then
    --str = str .. " [" .. photonBlast[leftPhotonBlast[data[4] + 1] + 1]
    --else
    --    str = str .. "[Empty"
    --end
    --if bit.band(data[15], 2) == 2 then
    --    str = str .. " | " .. photonBlast[bit.band(data[4], 7) + 1]
    --else
    --    str = str .. " | Empty"
    --end
    --if bit.band(data[15], 1) == 1 then
    --    str = str .. " | " .. photonBlast[bit.rshift(bit.band(data[4], 56), 3) + 1] .. "]"
    --else
    --    str = str .. " | Empty]"
    --end
    
    return str
end
local formatToolName = function(data, name)
    local str = ""
    
    if data[2] == 2 then
        if data[5] < tablelength(techNames) then
            str = string.format("%s Lv%i", techNames[data[5] + 1], data[3] + 1)
        else
            str = "Invalid technique"
        end
    else
        str = string.format("%s", name)
        if data[6] > 1 then
            str = str .. string.format(" x%i", data[6])
        end
    end
    return str
end
function formatItemName(data, name)
    local str = ""
    
    if data[1] == 0 then
        str = formatWeaponName(data, name)
    elseif data[1] == 1 then
        if data[2] == 1 or data[2] == 2 then
            str = formatArmorName(data, name)
        elseif data[2] == 3 then
            str = formatUnitName(data, name)
        end
    elseif data[1] == 2 then
        str = formatMagName(data, name)
    elseif data[1] == 3 then
        str = formatToolName(data, name)
    end
    
    return str
end

function refreshItemNames()
    print("Items refreshed")
end

return {
    refresh = refresh,
    getItemName = getItemName,
    formatItemName = formatItemName,
    getSpecialName = nil,
    getTechName = nil,
}