local lib_helpers = require("solylib.helpers")
local lib_theme = require("solylib.theme")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local cfg = require("Mags.configuration")

local function Main()
    local itemList = lib_items.GetItemList(lib_items.Me, false)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        local item = itemList[i]
        if item.mag ~= nil then
            -- new line
            imgui.Text("")

            -- Item index
            local indexStr = string.format("% 3i", item.index)
            lib_helpers.imguiText(indexStr, lib_items_cfg.itemIndex)

            -- Equipped
            lib_helpers.imguiText(" [", lib_items_cfg.white)
            lib_helpers.imguiText("E", lib_items_cfg.itemEquipped)
            lib_helpers.imguiText("]", lib_items_cfg.white)

            -- Mag name
            lib_helpers.imguiText(" ", lib_items_cfg.white)
            local item_cfg = lib_items_list.t[item.hex]
            if item_cfg ~= nil and item_cfg[1] ~= 0 then
                lib_helpers.imguiText(item.name, item_cfg[1])
            else
                lib_helpers.imguiText(item.name, lib_items_cfg.magName)
            end

            -- Mag color
            lib_helpers.imguiText(" [", lib_items_cfg.white)
            lib_helpers.imguiText(item.mag.color, lib_items_cfg.magColor)
            lib_helpers.imguiText("]", lib_items_cfg.white)

            -- Mag stats

            lib_helpers.imguiText(" [", lib_items_cfg.white)
            lib_helpers.imguiText(item.mag.def, lib_items_cfg.magStats)
            lib_helpers.imguiText("/", lib_items_cfg.white)
            lib_helpers.imguiText(item.mag.pow, lib_items_cfg.magStats)
            lib_helpers.imguiText("/", lib_items_cfg.white)
            lib_helpers.imguiText(item.mag.dex, lib_items_cfg.magStats)
            lib_helpers.imguiText("/", lib_items_cfg.white)
            lib_helpers.imguiText(item.mag.mind, lib_items_cfg.magStats)
            lib_helpers.imguiText("]", lib_items_cfg.white)
            
            -- Mag PBs
            lib_helpers.imguiText(" [", lib_items_cfg.white)
            lib_helpers.imguiText(lib_unitxt.GetPhotonBlastName(item.mag.pbL, cfg.shortPBNames), lib_items_cfg.magPB)
            lib_helpers.imguiText("|", lib_items_cfg.white)
            lib_helpers.imguiText(lib_unitxt.GetPhotonBlastName(item.mag.pbC, cfg.shortPBNames), lib_items_cfg.magPB)
            lib_helpers.imguiText("|", lib_items_cfg.white)
            lib_helpers.imguiText(lib_unitxt.GetPhotonBlastName(item.mag.pbR, cfg.shortPBNames), lib_items_cfg.magPB)
            lib_helpers.imguiText("]", lib_items_cfg.white)

            -- Mag timer
            local timerStr = string.format("%i", item.mag.timer)
            local timerColor = lib_items_cfg.white
            for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
                if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
                    timerColor = lib_items_cfg.magFeedTimer[i + 1]
                end
            end

            lib_helpers.imguiText(" [", lib_items_cfg.white)
            lib_helpers.imguiText(timerStr, timerColor)
            lib_helpers.imguiText("]", lib_items_cfg.white)
        end
    end
end

local function present()
    if cfg.enable == false then
        return
    end

    lib_theme.Push()
    imgui.Begin("Mags")
    imgui.SetWindowFontScale(cfg.fontSize)
    Main()
    imgui.End()
    lib_theme.Pop()
end

local function init()
    return
    {
        name = "Mags",
        version = "1.0.0",
        author = "Solybum",
        description = "Information about mags in the player's inventory",
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
