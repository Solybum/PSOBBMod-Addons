helpers = require("Character Reader/Helpers")
unitxt = require("Character Reader/Unitxt")

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

-- Helper function to print on the widget's window
-- By default it will print on the same line
local function imguiPrint(text, color, newline)
    color = color or cfg.white
    newline = newline or false

    if newline == false then
        imgui.SameLine(0, 0)
    end
    
    a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    b = bit.band(color, 0xFF) / 255;

    imgui.TextColored(r, g, b, a, text)
end

local function GetHPColorGradient(percent)
    a = 0xC0000000
    r = 1 - (percent * 255)
    g = (percent * 255)
    b = 0

    color = a + 
    bit.lshift(bit.band(r, 0xFF), 16) + 
    bit.lshift(bit.band(g, 0xFF), 8) + 
    bit.lshift(bit.band(b, 0xFF), 0)
    return color
end

local function readMonsters()
    difficulty = pso.read_u32(_Difficulty)
    playerCount = pso.read_u32(_PlayerCount)
    monsterCount = pso.read_u32(_MonsterCount)
    

    imgui.Columns(2)
    imguiPrint("Monster", 0xFFFFFFFF, true)
    imgui.NextColumn()
    imguiPrint("HP", 0xFFFFFFFF, true)
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

                imguiPrint(string.format("%s", mName), 0xFFFFFFFF, true)
                imgui.NextColumn()
                helpers.imguiProgressBar(mHP/mHPMax, -1.0, 13.0 * cfg.fontSize, mHP, GetHPColorGradient(mHP/mHPMax))
                imgui.NextColumn()
            end
        end
     end
end

local present = function()
    imgui.Begin("Monsters")
    imgui.SetWindowFontScale(cfg.fontSize)
    readMonsters()
    imgui.End()
end

return {
    present = present,
}
