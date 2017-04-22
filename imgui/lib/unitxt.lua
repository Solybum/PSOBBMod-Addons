unitxtPointer = 0x00A9CD50
specialBaseID = 0x005E4CBB
--unitxtItemName = 0x04
--unitxtMonsterName = 0x08
--unitxtItemDesc = 0x0C
--unitxtMonsterNameUlt = 0x10

function _Read(group, index)
    address = pso.read_u32(unitxtPointer)
    if address == 0 then
        return nil
    end
    
    address = address + (group * 4)
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
    return _Read(1, index)
end

function GetSpecialName(id)
    if id == 0 then
        return "None"
    end

    baseID = pso.read_u32(specialBaseID)
    return GetItemName(baseID + id)
end

function GetMonsterName(index, ultimate)
    ultimate = ultimate or false
    if ultimate then
        return _Read(4, index)
    else
        return _Read(2, index)
    end
end

function GetTechniqueName(id)
    return _Read(5, id)
end

function GetClassName(id)
    return _Read(8, id)
end

function GetPhotonBlastName(id)
    return _Read(9, id)
end

return
{
    Read = Read,
    GetItemName = GetItemName,
    GetSpecialName = GetSpecialName,
    GetMonsterName = GetMonsterName,
    GetTechniqueName = GetTechniqueName,
    GetClassName = GetClassName,
    GetPhotonBlastName = GetPhotonBlastName,
}
