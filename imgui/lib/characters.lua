_PlayerArray = 0x00A94254
_MyPlayerIndex = 0x00A9C4F4

function GetPlayerList()
    addrList = {}

    for i=1,12,1 do
        playerAddress = pso.read_u32(_PlayerArray + (i - 1) * 4)
        if playerAddress ~= 0 then
            table.insert(addrList, { index = i, address = playerAddress })
        end
    end

    return addrList
end

function GetPlayerName(player)
    return pso.read_wstr(player + 0x428 + 4, 10)
end

function GetPlayerHP(player)
    return pso.read_u32(player + 0x334)
end

function GetPlayerMaxHP(player)
    return pso.read_u32(player + 0x2BC)
end

return 
{
    GetPlayerList = GetPlayerList,
    GetPlayerName = GetPlayerName,
    GetPlayerHP = GetPlayerHP,
    GetPlayerMaxHP = GetPlayerMaxHP,
}