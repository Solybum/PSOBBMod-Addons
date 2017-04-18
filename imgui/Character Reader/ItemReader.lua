unitxt = require("Character Reader/Unitxt")

pmtPoitner = 0x00A8DC94
pmtWeaponOffset = 0x00
pmtArmorOffset = 0x04
pmtUnitOffset = 0x08
pmtMagOffset = 0x10
pmtToolOffset = 0x0C

local _GetItemNameString = function(id)
    return unitxt.ReadItemName(id)
end
local _GetItemID = function(type, group, index)
    local id = -1
    
    address = pso.read_u32(pmtPoitner)
    if address == 0 then
        return -1
    end
    
    if type == 0 then
        address = pso.read_u32(address + pmtWeaponOffset)
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
            address = pso.read_u32(address + pmtArmorOffset)
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
            address = pso.read_u32(address + pmtUnitOffset)
            
            count = pso.read_u32(address)
            address = pso.read_u32(address + 4)
            if count < index or address == 0 then
                return -1
            end
            
            id = pso.read_i32(address + 20 * index)
        end
    elseif type == 2 then
        address = pso.read_u32(address + pmtMagOffset)
        
        count = pso.read_u32(address)
        address = pso.read_u32(address + 4)
        if count < group or address == 0 then
            return -1
        end
        
        id = pso.read_i32(address + 28 * group)
    elseif type == 3 then
        address = pso.read_u32(address + pmtToolOffset)
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
    
    id = _GetItemID(data[1], data[2], data[3])
    
    if id == -1 then
        str = "Unknown"
    else
        str = _GetItemNameString(id)
    end

    return str
end

return
{
    getItemName = getItemName,
}
