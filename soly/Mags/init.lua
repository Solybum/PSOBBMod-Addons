local helpers = require("soly.lib.helpers")
local unitxt = require("soly.lib.unitxt")
local libitems = require("soly.lib.items.items")
local cfg = require("soly.Mags.configuration")

local _PlayerMyIndex = 0x00A9C4F4

local function DisplayMags()
    local playerIndex = pso.read_u32(_PlayerMyIndex)
    local itemList = libitems.GetItemList(playerIndex, false)

    for index, item in ipairs(itemList) do
        if item.type == 2 then

            -- Index
            local text = string.format("%2i", index)
            helpers.imguiText(text, cfg.fontColor, false)

            -- Name
            text = string.format(" %s", item.name)
            helpers.imguiText(text, cfg.fontColor, false)

            -- Stats
            text = string.format(" [%.2f/%.2f/%.2f/%.2f]", 
                item.mag.DFP,
                item.mag.ATP,
                item.mag.ATA,
                item.mag.MST)
            helpers.imguiText(text, cfg.fontColor, false)

            -- PBs
            text = string.format(" [%s|%s|%s]", 
                unitxt.GetPhotonBlastName(item.mag.pbLeft, true),
                unitxt.GetPhotonBlastName(item.mag.pbCenter, true),
                unitxt.GetPhotonBlastName(item.mag.pbRight, true))
            helpers.imguiText(text, cfg.fontColor, false)

            -- Feed timer
            helpers.imguiText(" [", cfg.fontColor)
            local feedtimerStr = string.format("%is", item.mag.timer)

            local ftColor = 0
            for i=1,table.getn(cfg.magFeedTimerColors),2 do
                if ftColor == 0 then
                    if item.mag.timer < cfg.magFeedTimerColors[i] then
                        ftColor = i + 1
                    end
                end
            end

            if item.mag.timer <= 0 then
                helpers.imguiText(cfg.readyToBeFedString, cfg.magFeedTimerColors[ftColor])
            else
                helpers.imguiText(feedtimerStr, cfg.magFeedTimerColors[ftColor])
            end
            helpers.imguiText("]", cfg.fontColor, false)

            helpers.imguiText("", cfg.fontColor, true)
        end
    end

end

local function present()
    if cfg.enable == false then
        return
    end

    imgui.Begin("Mags")
    imgui.SetWindowFontScale(cfg.fontSize)
    DisplayMags()
    imgui.End()
end

local function init()
    return
    {
        name = "Mags",
        version = "1.0.0",
        author = "Solybum",
        description = "Mag list to know when to feed them",
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
