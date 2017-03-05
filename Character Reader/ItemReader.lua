_uniPtr = 0x00A9CD50
_uniItemOffset = 0x04
_pmtPtr = 0x00A8DC94
_pmtWeaponOff = 0x00
_pmtArmorOff = 0x04
_pmtUnitOff = 0x08
_pmtMagOff = 0x10
_pmtToolOff = 0x0C

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
