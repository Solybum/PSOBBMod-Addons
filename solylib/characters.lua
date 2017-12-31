local _PlayerArray = 0x00A94254
local _MyPlayerIndex = 0x00A9C4F4

local function GetSelf()
    local myIndex = pso.read_u32(_MyPlayerIndex)
    local playerAddress = pso.read_u32(_PlayerArray + myIndex * 4)

    return playerAddress
end

local function GetPlayer(index)
    local playerAddress = pso.read_u32(_PlayerArray + index * 4)

    return playerAddress
end

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

local function GetPlayerCoordinates(player)
    local x = pso.read_f32(player + 0x38)
    local y = pso.read_f32(player + 0x3C)
    local z = pso.read_f32(player + 0x40)

    return
    {
        x = x,
        y = y,
        z = z,
    }
end

local function GetPlayerName(player)
    local playerName = pso.read_wstr(player + 0x428, 12)

    if string.sub(playerName, 1, 1) == "\t" then
        playerName = string.sub(playerName, 3, string.len(playerName))
    end

    return playerName
end

local function GetPlayerLevel(player)
    return (pso.read_u32(player + 0xE44) + 1)
end

local function GetPlayerHP(player)
    return pso.read_u16(player + 0x334)
end

local function GetPlayerMaxHP(player)
    return pso.read_u16(player + 0x2BC)
end

local function GetPlayerTP(player)
    return pso.read_u16(player + 0x336)
end

local function GetPlayerMaxTP(player)
    return pso.read_u16(player + 0x2BE)
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

    local level = tonumber(string.format("%.0f", ((math.abs(multiplier) * 100) - 10) / 1.30))
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

local function GetPlayerFrozenStatus(player)
    return pso.read_u32(player + 0x268) == 0x02
end
local function GetPlayerConfusedStatus(player)
    return pso.read_u32(player + 0x268) == 0x12
end
local function GetPlayerParalyzedStatus(player)
    return pso.read_u32(player + 0x25C) == 0x10
end

return
{
    GetSelf = GetSelf,
    GetPlayer = GetPlayer,
    GetPlayerList = GetPlayerList,
    GetPlayerName = GetPlayerName,
    GetPlayerLevel = GetPlayerLevel,
    GetPlayerHP = GetPlayerHP,
    GetPlayerMaxHP = GetPlayerMaxHP,
    GetPlayerTP = GetPlayerTP,
    GetPlayerMaxTP = GetPlayerMaxTP,
    GetPlayerTechStatus = GetPlayerTechStatus,
    GetPlayerFrozenStatus = GetPlayerFrozenStatus,
    GetPlayerConfusedStatus = GetPlayerConfusedStatus,
    GetPlayerParalyzedStatus = GetPlayerParalyzedStatus,
}
