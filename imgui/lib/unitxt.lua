unitxtPointer = 0x00A9CD50
unitxtItemName = 0x04
unitxtMonsterName = 0x08
unitxtItemDesc = 0x0C
unitxtMonsterNameUlt = 0x10

function _Read(group, index)
    address = pso.read_u32(unitxtPointer)
    if address == 0 then
        return nil
    end
    
    address = address + group
    address = pso.read_u32(address)
    if address == 0 then
        return nil
    end
    
    address = address + 4 * index
    address = pso.read_u32(address)
    if address == 0 then
        return nil
    end
    
    return pso.read_wstr(address, 256)
end

function Read(group, index)
    return _Read(group, index)
end

function GetItemName(index)
    return _Read(unitxtItemName, index)
end

function GetItemDescription(index)
    return _Read(unitxtItemDesc, index)
end

function GetMonsterName(index, ultimate)
    ultimate = ultimate or false
    if ultimate then
        return _Read(unitxtMonsterNameUlt, index)
    else
        return _Read(unitxtMonsterName, index)
    end
end

return
{
    Read = Read,
    GetItemName = GetItemName,
    GetItemDescription = GetItemDescription,
    GetMonsterName = GetMonsterName,
}
