local helpers = require("solylib.helpers")
local unitxt = require("solylib.Unitxt")
local cfgMonsters = require("Monster HP.monsters")
local cfg = require("Monster HP.configuration")

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

-- Special addresses for De Rol Le
local _BPDeRolLeData = 0x00A43CC8
local _MonsterDeRolLeHP = 0x6B4
local _MonsterDeRolLeHPMax = 0x6B0
local _MonsterDeRolLeSkullHP = 0x6B8
local _MonsterDeRolLeSkullHPMax = 0x20
local _MonsterDeRolLeShellHP = 0x39C
local _MonsterDeRolLeShellHPMax = 0x1C

-- Special addresses for Barba Ray
local _BPBarbaRayData = 0x00A43CC8
local _MonsterBarbaRayHP = 0x704
local _MonsterBarbaRayHPMax = 0x700
local _MonsterBarbaRaySkullHP = 0x708
local _MonsterBarbaRaySkullHPMax = 0x20
local _MonsterBarbaRayShellHP = 0x7AC
local _MonsterBarbaRayShellHPMax = 0x1C

local function CopyMonster(monster)
    local copy = {}

    copy.index    = monster.index
    copy.posX     = monster.posX
    copy.posY     = monster.posY
    copy.posZ     = monster.posZ
    copy.unitxtID = monster.unitxtID
    copy.HP       = monster.HP
    copy.HPMax    = monster.HPMax
    copy.HP2      = monster.HP2
    copy.HP2Max   = monster.HP2Max
    copy.name     = monster.name
    copy.color    = monster.color
    copy.display  = monster.display

    return copy
end

local function GetMonsterDataDeRolLe(monster)
    local maxDataPtr = pso.read_u32(_BPDeRolLeData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeSkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeShellHPMax)
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterDeRolLeHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterDeRolLeSkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterDataBarbaRay(monster)
    local maxDataPtr = pso.read_u32(_BPBarbaRayData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRaySkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRayShellHPMax)
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterBarbaRayHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterBarbaRaySkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterData(monster)
    monster.unitxtID = pso.read_u32(monster.address + _MonsterUnitxtID)
    monster.HP = pso.read_u16(monster.address + _MonsterHP)
    monster.HPMax = pso.read_u16(monster.address + _MonsterHPMax)
    monster.posX = pso.read_f32(monster.address + _PosX)
    monster.posY = pso.read_f32(monster.address + _PosY)
    monster.posZ = pso.read_f32(monster.address + _PosZ)

    -- Other stuff
    monster.name = unitxt.GetMonsterName(monster.unitxtID, ultimate)
    monster.color = 0xFFFFFFFF
    monster.display = true

    if monster.unitxtID == 45 then
        monster = GetMonsterDataDeRolLe(monster)
    end
    if monster.unitxtID == 73 then
        monster = GetMonsterDataBarbaRay(monster)
    end

    return monster
end

local function GetMonsterList()
    local monsterList = {}

    local difficulty = pso.read_u32(_Difficulty)
    local ultimate = difficulty == 3

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

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.display = true
        monster.index = i
        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))

        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster = GetMonsterData(monster)

            if cfgMonsters.m[monster.unitxtID] ~= nil then
                monster.color = cfgMonsters.m[monster.unitxtID].color
                monster.display = cfgMonsters.m[monster.unitxtID].display
            end

            -- Calculate the distance between it and the player
            -- And hide the monster if its too far
            local xDist = math.abs(pPosX - monster.posX)
            local zDist = math.abs(pPosZ - monster.posZ)
            local tDist = math.sqrt(xDist ^ 2 + zDist ^ 2)
        
            if cfgMonsters.maxDistance ~= 0 and tDist > cfgMonsters.maxDistance then
                monster.display = false
            end

            -- If we have De Rol Le, make a copy for the body HP
            if monster.unitxtID == 45 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            elseif monster.unitxtID == 73 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            end

        
            table.insert(monsterList, monster)
        end
        i = i + 1
    end

    return monsterList
end

local function PrintMonsters()
    local monsterList = GetMonsterList()
    local monsterListCount = table.getn(monsterList)

    imgui.Columns(2)

    for i=1,monsterListCount,1 do
        if monsterList[i].display then
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
    if cfg.enable == false then
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
        description = "List of nearby monsters with their HP",
        present = present,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
