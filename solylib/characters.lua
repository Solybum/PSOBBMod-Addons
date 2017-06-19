local _PlayerArray = 0x00A94254
local _MyPlayerIndex = 0x00A9C4F4

local function GetPlayerList()
    local addrList = {}

    for i=1,12,1 do
        local playerAddress = pso.read_u32(_PlayerArray + (i - 1) * 4)
        if playerAddress ~= 0 then
            table.insert(addrList, { index = i, address = playerAddress })
        end
    end

    return addrList
end

local function GetPlayerName(player)
    local playerName = pso.read_wstr(player + 0x428, 12)

    if string.sub(playerName, 1, 1) == "\t" then
        playerName = string.sub(playerName, 3, string.len(playerName))
    end

    return playerName
end

local function GetPlayerHP(player)
    return pso.read_u16(player + 0x334)
end

local function GetPlayerMaxHP(player)
    return pso.read_u16(player + 0x2BC)
end

return
{
    GetPlayerList = GetPlayerList,
    GetPlayerName = GetPlayerName,
    GetPlayerHP = GetPlayerHP,
    GetPlayerMaxHP = GetPlayerMaxHP,
}
