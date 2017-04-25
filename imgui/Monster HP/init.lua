helpers = require("lib.helpers")
unitxt = require("lib.Unitxt")
monsters = require("Monster HP.Monsters")

cfgFontColor = 0xFFFFFFFF
cfgFontSize = 1.0

_PlayerArray = 0x00A94254
_PlayerIndex = 0x00A9C4F4
_PlayerCount = 0x00AAE168
_Difficulty = 0x00A9CD68

_PosX = 0x38
_PosY = 0x3C
_PosZ = 0x40

_MonsterCount = 0x00AAE164
_MonsterArray = 0x00AAD720

_MonsterUnitxtID = 0x378
_MonsterHP = 0x334
_MonsterHPMax = 0x2BC

function GetHPColorGradient(percent)
    a = 1 - percent + 0.4
    r = 1 - percent
    g = percent
    b = 0

    if a > 1.0 then
        a = 1.0
    end

    color = 
    bit.lshift(bit.band((a * 255), 0xFF), 24) + 
    bit.lshift(bit.band((r * 255), 0xFF), 16) + 
    bit.lshift(bit.band((g * 255), 0xFF), 8) + 
    bit.lshift(bit.band((b * 255), 0xFF), 0)
    return color
end

function readMonsters()
    difficulty = pso.read_u32(_Difficulty)
    ultimate = difficulty == 3

    playerCount = pso.read_u32(_PlayerCount)
    monsterCount = pso.read_u32(_MonsterCount)
    
    pIndex = pso.read_u32(_PlayerIndex)
    pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    imgui.Columns(2)
    helpers.imguiTextLine("Monster", 0xFFFFFFFF)
    imgui.NextColumn()
    helpers.imguiTextLine("HP", 0xFFFFFFFF)
    imgui.NextColumn()

    for i=1,monsterCount,1 do
        mAddr = pso.read_u32(_MonsterArray + 4 * (i - 1 + playerCount))

        if mAddr ~= 0 then
            -- Get position of entities
            pPosX = pso.read_f32(pAddr + _PosX)
            pPosZ = pso.read_f32(pAddr + _PosZ)
            mPosX = pso.read_f32(mAddr + _PosX)
            mPosZ = pso.read_f32(mAddr + _PosZ)

            -- Calculate the distance between them
            xDist = math.abs(pPosX - mPosX)
            zDist = math.abs(pPosZ - mPosZ)
            tDist = math.sqrt(xDist ^ 2 + zDist ^ 2)
            

            -- Do not show monsters that are too far away
            if monsters.maxDistance == 0 or tDist < monsters.maxDistance then
                -- Get some data about the monster
                mUnitxtID = pso.read_u32(mAddr + _MonsterUnitxtID)
                mHP = pso.read_u16(mAddr + _MonsterHP)
                mHPMax = pso.read_u16(mAddr + _MonsterHPMax)

                mName = unitxt.GetMonsterName(mUnitxtID, ultimate)
                mColor = 0xFFFFFFFF
                mDisplay = true

                if monsters.m[mUnitxtID] ~= nil then
                    mColor = monsters.m[mUnitxtID][1]
                    mDisplay = monsters.m[mUnitxtID][2]
                end

                if mDisplay == true then
                    helpers.imguiTextLine(string.format("%s", mName), mColor)
                    imgui.NextColumn()
                    helpers.imguiProgressBar(mHP/mHPMax, -1.0, 13.0 * cfgFontSize, mHP, GetHPColorGradient(mHP/mHPMax), cfgFontColor)
                    imgui.NextColumn()
                end
            end
        end
     end
end

function present()
    imgui.Begin("Monsters")
    imgui.SetWindowFontScale(cfgFontSize)
    readMonsters()
    imgui.End()
end

function init()
    return 
    {
        name = "Monster HP",
        version = "1.0.0",
        author = "Solybum"
    }
end

pso.on_init(init)
pso.on_present(present)

return {
    init = init,
    present = present,
}
