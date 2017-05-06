local helpers = require("soly.lib.helpers")
local unitxt = require("soly.lib.Unitxt")
local monsters = require("soly.Monster HP.monsters")
local cfg = require("soly.Monster HP.configuration")

local _PlayerArray = 0x00A94254
local _PlayerIndex = 0x00A9C4F4
local _PlayerCount = 0x00AAE168
local _Difficulty = 0x00A9CD68

local _PosX = 0x38
local _PosY = 0x3C
local _PosZ = 0x40

local _EntityCount = 0x00AAE164
local _EntityArray = 0x00AAD720

local _MonsterUnitxtID = 0x378
local _MonsterHP = 0x334
local _MonsterHPMax = 0x2BC

local function GetMonsterList()
    local monsterList = {}

    local difficulty = pso.read_u32(_Difficulty)
    local ultimate = difficulty == 3

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    -- return the empty list
    if pAddr == 0 then
        return monsterList
    end

    -- Get player position
    local pPosX = pso.read_f32(pAddr + _PosX)
    local pPosZ = pso.read_f32(pAddr + _PosZ)

    for i=1,entityCount,1 do
        local mAddr = pso.read_u32(_EntityArray + 4 * (i - 1 + playerCount))

        -- If we got a pointer, then read from it
        if mAddr ~= 0 then
            -- Get monster data
            local mUnitxtID = pso.read_u32(mAddr + _MonsterUnitxtID)
            local mHP = pso.read_u16(mAddr + _MonsterHP)
            local mHPMax = pso.read_u16(mAddr + _MonsterHPMax)
            local mPosX = pso.read_f32(mAddr + _PosX)
            local mPosZ = pso.read_f32(mAddr + _PosZ)

            -- Calculate the distance between it and the player
            local xDist = math.abs(pPosX - mPosX)
            local zDist = math.abs(pPosZ - mPosZ)
            local tDist = math.sqrt(xDist ^ 2 + zDist ^ 2)

            -- Other data
            local mName = unitxt.GetMonsterName(mUnitxtID, ultimate)
            local mColor = 0xFFFFFFFF
            local mDisplay = true

            if monsters.m[mUnitxtID] ~= nil then
                mColor = monsters.m[mUnitxtID][1]
                mDisplay = monsters.m[mUnitxtID][2]
            end

            if monsters.maxDistance ~= 0 and tDist > monsters.maxDistance then
                mDisplay = false
            end

            table.insert(monsterList, { show = mDisplay, name = mName, HP = mHP, HPMax = mHPMax, color = mColor })
        end
    end

    return monsterList
end

local function PrintMonsters()
    local monsterList = GetMonsterList()
    local monsterListCount = table.getn(monsterList)

    imgui.Columns(2)

    for i=1,monsterListCount,1 do
        if monsterList[i].show then
            local mHP = monsterList[i].HP
            local mHPMax = monsterList[i].HPMax

            helpers.imguiText(monsterList[i].name, monsterList[i].color, true)
            imgui.NextColumn()
            helpers.imguiProgressBar(mHP/mHPMax, -1.0, 13.0 * cfg.fontSize, mHP, helpers.HPToGreenRedGradient(mHP/mHPMax), cfg.fontColor, true)
            imgui.NextColumn()
        end
    end
end

local function present()
    if (not cfg.showMonsterHP) then
        return
    end
    imgui.Begin("Monsters")
    imgui.SetWindowFontScale(cfg.fontSize)
    PrintMonsters()
    imgui.End()
end

local function init()
    return
    {
        name = "Monster HP",
        version = "1.0.1",
        author = "Solybum",
        present = present
    }
end

return {
    __addon = {
        init = init
    }
}
