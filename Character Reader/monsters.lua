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

local function readMonsters()
    difficulty = pso.read_u32(_Difficulty)
    playerCount = pso.read_u32(_PlayerCount)
    monsterCount = pso.read_u32(_MonsterCount)
    
    -- dataStr = string.format("%-20s %-11s % 8s % 8s % 8s", "Monster", "HP", "X", "Y", "Z")
    -- imguiPrint(dataStr, 0xFFFFFFFF, true)
    imgui.Columns(5)
    imguiPrint("Monster", 0xFFFFFFFF, true)
    imgui.NextColumn()
    imguiPrint("HP", 0xFFFFFFFF, true)
    imgui.NextColumn()
    imguiPrint("X", 0xFFFFFFFF, true)
    imgui.NextColumn()
    imguiPrint("Y", 0xFFFFFFFF, true)
    imgui.NextColumn()
    imguiPrint("Z", 0xFFFFFFFF, true)
    imgui.NextColumn()

    for i=1,monsterCount,1 do
        mAddr = pso.read_u32(_MonsterArray + 4 * (i - 1 + playerCount))

        if mAddr ~= 0 then
            mID = pso.read_u32(mAddr + _MonsterID)

            if mID > 0 and mID < 100 then
                mPosX = pso.read_f32(mAddr + _MonsterPosX)
                mPosY = pso.read_f32(mAddr + _MonsterPosY)
                mPosZ = pso.read_f32(mAddr + _MonsterPosZ)
                mHP = pso.read_u16(mAddr + _MonsterHP)
                mHPMax = pso.read_u16(mAddr + _MonsterHPMax)
                
                mName = unitxt.ReadMonsterName(mID, difficulty)

                -- dataStr = string.format("%-20s % 5i/% 5i % 8.2f % 8.2f % 8.2f", mName, mHP, mHPMax, mPosX, mPosY, mPosZ)
                -- imguiPrint(dataStr, 0xFFFFFFFF, true)

                imguiPrint(string.format("%s", mName), 0xFFFFFFFF, true)
                imgui.NextColumn()
                imguiPrint(string.format("% 5i/% 5i", mHP, mHPMax), 0xFFFFFFFF, true)
                imgui.NextColumn()
                imguiPrint(string.format("%.2f", mPosX), 0xFFFFFFFF, true)
                imgui.NextColumn()
                imguiPrint(string.format("%.2f", mPosY), 0xFFFFFFFF, true)
                imgui.NextColumn()
                imguiPrint(string.format("%.2f", mPosZ), 0xFFFFFFFF, true)
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
