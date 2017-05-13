local helpers = require("soly.lib.helpers")
local cfg = require("soly.Quest Registers.configuration")

local addrQuestRegisterMemory = 0x00A954B0
local regTable = {}

local function SetupTable()
    local time = os.time()

    local i1 = 1
    while i1 < 257 do
        local reg = {}
        reg.value = 0
        reg.color = cfg.fontColor
        reg.time = time

        regTable[i1] = reg
        i1 = i1 + 1
    end
end

function ReadQuestRegisters()
    local time = os.time()

    local i1 = 1
    while i1 < 257 do
        -- always reset the color
        regTable[i1].color = cfg.fontColor
        local qRegMem = pso.read_u32(addrQuestRegisterMemory)
        if qRegMem ~= 0 then
            -- Get register value
            local qRegVal = pso.read_u32(qRegMem + (i1 - 1) * 4)

            -- If it changed, update the value and clock
            if regTable[i1].value ~= qRegVal then
                regTable[i1].value = qRegVal
                regTable[i1].time = time
            end

            regTable[i1].color = cfg.fontColor
            -- If it changed recently, set a different color
            if regTable[i1].time + cfg.registerChangedDuration > time then
                regTable[i1].color = cfg.registerChangedColor
            end
        end
        i1 = i1 + 1
    end
end

local function PrintQuestRegisters()
    local i1 = 1
    while i1 < 257 do
        helpers.imguiText(string.format("R%-3i: %08X %i", i1 - 1, regTable[i1].value, regTable[i1].value), regTable[i1].color, true)
        i1 = i1 + 1
    end
end

local function present()
    if cfg.enable == false then
        return
    end

    imgui.Begin("Quest Registers")
    imgui.SetWindowFontScale(cfg.fontSize)

    if pcall(ReadQuestRegisters) then
        PrintQuestRegisters()
    else
        helpers.imguiText("Could not read memory, warping?", cfg.fontColor, true)
    end

    imgui.End()
end

local function init()
    SetupTable()

    return
    {
        name = "Quest Registers",
        version = "1.0.0",
        author = "Solybum",
        description = "Quest register reader, original idea of Lemon",
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
