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

local function GetPlayerTechStatus(player, tech)
    tech = tech or 0
    if tech ~= 0 then
        tech = 1
    end

    local type = pso.read_u32(player + 0x274 + tech * 12)
    local multiplier = pso.read_f32(player + 0x278 + tech * 12)
    local frames = pso.read_u32(player + 0x27C + tech * 12)

    local name = "?"
    if type == 9 then
        name = "S"
    elseif type == 10 then
        name = "D"
    elseif type == 11 then
        name = "J"
    elseif type == 12 then
        name = "Z"
    end

    local level = tonumber(string.format("%.0f", ((multiplier * 100) - 10) / 1.30))
    local time = tonumber(string.format("%.0f", frames / 30))
    local totalTime = ((level * 10) + 40)

    -- adjust level after it was used
    level = level + 1

    return
    {
        type = type,
        multiplier = multiplier,
        frames = frames,

        name = name,
        level = level,
        time = time,
        totalTime = totalTime
    }
end

return
{
    GetPlayerList = GetPlayerList,
    GetPlayerName = GetPlayerName,
    GetPlayerHP = GetPlayerHP,
    GetPlayerMaxHP = GetPlayerMaxHP,
    GetPlayerTechStatus = GetPlayerTechStatus,
}
