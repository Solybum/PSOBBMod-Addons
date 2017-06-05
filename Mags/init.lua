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
            -- Get a new line
            lib_helpers.TextC(true, 0, "")

            -- Item index
            lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

            -- Equipped
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.itemIndex, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "]")

            -- Mag name
            local nameColor = lib_items_cfg.magName
            local item_cfg = lib_items_list.t[item.hex]
            if item_cfg ~= nil and item_cfg[1] ~= 0 then
                nameColor = item_cfg[1]
            end
            lib_helpers.TextC(false, nameColor, " %s", item.name)

            -- Mag color
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.magColor, lib_unitxt.GetMagColor(item.mag.color))
            lib_helpers.TextC(false, lib_items_cfg.white, "]")

            -- Mag stats

            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.def)
            lib_helpers.TextC(false, lib_items_cfg.white, "/")
            lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.pow)
            lib_helpers.TextC(false, lib_items_cfg.white, "/")
            lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.dex)
            lib_helpers.TextC(false, lib_items_cfg.white, "/")
            lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.mind)
            lib_helpers.TextC(false, lib_items_cfg.white, "]")
            
            -- Mag PBs
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbL, cfg.shortPBNames))
            lib_helpers.TextC(false, lib_items_cfg.white, "|")
            lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbC, cfg.shortPBNames))
            lib_helpers.TextC(false, lib_items_cfg.white, "|")
            lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbR, cfg.shortPBNames))
            lib_helpers.TextC(false, lib_items_cfg.white, "]")

            -- Mag timer
            local timerColor = lib_items_cfg.white
            for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
                if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
                    timerColor = lib_items_cfg.magFeedTimer[i + 1]
                end
            end

            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, timerColor, "%i", item.mag.timer)
            lib_helpers.TextC(false, lib_items_cfg.white, "]")
        end
    end
end

local function present()
    if cfg.enable == false then
        return
    end

    imgui.Begin("Mags")
    imgui.SetWindowFontScale(cfg.fontSize)
    Main()
    imgui.End()
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
