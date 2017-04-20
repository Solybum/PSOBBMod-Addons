helpers = require("lib.helpers")
unitxt = require("lib.Unitxt")
monsters = require("Monster HP.Monsters")

cfgFontColor = 0xFFFFFFFF
cfgFontSize = 1.0

_PlayerCount = 0x00AAE168
_Difficulty = 0x00A9CD68

_MonsterCount = 0x00AAE164
_MonsterArray = 0x00AAD720

_MonsterPosX = 0x38
_MonsterPosY = 0x3C
_MonsterPosZ = 0x40
_MonsterID = 0x378
_MonsterHP = 0x334
_MonsterHPMax = 0x2BC

local function GetHPColorGradient(percent)
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

local function readMonsters()
    difficulty = pso.read_u32(_Difficulty)
    playerCount = pso.read_u32(_PlayerCount)
    monsterCount = pso.read_u32(_MonsterCount)
    

    imgui.Columns(2)
    helpers.imguiTextLine("Monster", 0xFFFFFFFF)
    imgui.NextColumn()
    helpers.imguiTextLine("HP", 0xFFFFFFFF)
    imgui.NextColumn()

    for i=1,monsterCount,1 do
        mAddr = pso.read_u32(_MonsterArray + 4 * (i - 1 + playerCount))

        if mAddr ~= 0 then
            mID = pso.read_u32(mAddr + _MonsterID)

            if mID ~= 0 then
                --mPosX = pso.read_f32(mAddr + _MonsterPosX)
                --mPosY = pso.read_f32(mAddr + _MonsterPosY)
                --mPosZ = pso.read_f32(mAddr + _MonsterPosZ)
                mHP = pso.read_u16(mAddr + _MonsterHP)
                mHPMax = pso.read_u16(mAddr + _MonsterHPMax)
                
                mName = unitxt.ReadMonsterName(mID, difficulty)
                mColor = 0xFFFFFFFF
                mDisplay = true

                if monsters.m[mID] ~= nil then
                    mColor = monsters.m[mID][1]
                    mDisplay = monsters.m[mID][2]
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

local present = function()
    imgui.Begin("Monsters")
    imgui.SetWindowFontScale(cfgFontSize)
    readMonsters()
    imgui.End()
end

local init = function()
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

