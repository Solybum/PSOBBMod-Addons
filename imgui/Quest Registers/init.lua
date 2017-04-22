helpers = require("lib.helpers")
regTable = {}
differentColorDuration = 2.0

function ReadQuestRegisters()
    qRegAddr = 0x00A954B0
    qRegMem = pso.read_u32(qRegAddr)
    if qRegMem ~= 0 then
        for i=1,256,1 do
            -- Get register value
            qRegVal = pso.read_u32(qRegMem + (i - 1) * 4)

            -- If we have nil, add the new register but use the current value 
            -- to not trigger the different color
            if regTable[i] == nil then
                regTable[i] = { qRegVal, 0 }
            end
            
            -- If it changed, update the value and clock
            if regTable[i][1] ~= qRegVal then
                regTable[i][1] = qRegVal
                regTable[i][2] = os.clock()
            end
            
            color = 0xFFFFFFFF
            -- If it changed recently, set a different color
            if regTable[i][2] + differentColorDuration > os.clock() then
                color = 0xFFFF0000
            end
            -- Finally print the thing
            helpers.imguiTextLine(string.format("R%-3i: %08X %i", (i -1), qRegVal, qRegVal), color)
        end
    else
        helpers.imguiTextLine("Not in a quest", 0xFFFF0000)
    end
end


function present()
    imgui.Begin("Quest Registers")
    -- imgui.SetWindowFontScale(1.0)
    ReadQuestRegisters()
    imgui.End()
end

-- Idea of Lemon
function init()
    return 
    {
        name = "Quest Registers",
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

