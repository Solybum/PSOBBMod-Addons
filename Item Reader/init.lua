local lib_helpers = require("solylib.helpers")
local lib_theme = require("solylib.theme")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local cfg = require("Item Reader.configuration")

local function ProcessWeapon(item)
    local result = ""

    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if cfg.showEquippedItems then
        if item.equipped then
            lib_helpers.TextC(false, lib_items_cfg.white, "[")
            lib_helpers.TextC(false, lib_items_cfg.itemEquipped, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    if item.weapon.wrapped or item.weapon.untekked then
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
        if item.weapon.wrapped and item.weapon.untekked then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "W|U")
        elseif item.weapon.wrapped then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "W")
        elseif item.weapon.untekked then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "U")
        end
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
    end

    if item.weapon.isSRank then
        result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSRankTitle, "S-RANK ")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSRankName, "%s ", item.name)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSRankCustomName, "%s ", item.weapon.nameSrank)

        if item.weapon.grind > 0 then
             result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponGrind, "+%i ", item.weapon.grind)
        end
        
        if item.weapon.specialSRank ~= 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSRankSpecial, lib_unitxt.GetSRankSpecialName(item.weapon.specialSRank))
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    else
        local nameColor = lib_items_cfg.weaponName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)
    
        if item.weapon.grind > 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponGrind, "+%i ", item.weapon.grind)
        end
    
        if item.weapon.special ~= 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[item.weapon.special + 1], lib_unitxt.GetSpecialName(item.weapon.special))
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
        for i=2,5,1 do
            local stat = item.weapon.stats[i]
    
            local statColor = lib_items_cfg.grey
            for i2=1,table.getn(lib_items_cfg.weaponAttributes),2 do
                if stat <= lib_items_cfg.weaponAttributes[i2] then
                    statColor = lib_items_cfg.weaponAttributes[i2 + 1]
                end
            end
    
            result = result .. lib_helpers.TextC(false, statColor, "%i", stat)
    
            if i < 5 then
                result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
            else
                result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "|")
            end
        end
    
        local stat = item.weapon.stats[6]
        local statColor = lib_items_cfg.grey
        for i2=1,table.getn(lib_items_cfg.weaponHit),2 do
            if stat <= lib_items_cfg.weaponHit[i2] then
                statColor = lib_items_cfg.weaponHit[i2 + 1]
            end
        end
        result = result .. lib_helpers.TextC(false, statColor, "%i", stat)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
    
        if item.kills ~= 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponKills, "%iK", item.kills)
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    return result
end
local function ProcessFrame(item)
    local result = ""

    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if cfg.showEquippedItems then
        if item.equipped then
            lib_helpers.TextC(false, lib_items_cfg.white, "[")
            lib_helpers.TextC(false, lib_items_cfg.itemEquipped, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")

    local statColor
    if item.armor.dfp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.dfp)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.dfpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.dfpMax)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, " | ")

    if item.armor.evp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.evp)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.evpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.evpMax)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.armorSlots, "%iS", item.armor.slots)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    return result
end
local function ProcessBarrier(item)
    local result = ""

    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if cfg.showEquippedItems then
        if item.equipped then
            lib_helpers.TextC(false, lib_items_cfg.white, "[")
            lib_helpers.TextC(false, lib_items_cfg.itemEquipped, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")

    local statColor
    if item.armor.dfp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.dfp)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.dfpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.dfpMax)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, " | ")

    if item.armor.evp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.evp)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.evpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. lib_helpers.TextC(false, statColor, "%i", item.armor.evpMax)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    return result
end
local function ProcessUnit(item)
    local result = ""

    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if cfg.showEquippedItems then
        if item.equipped then
            lib_helpers.TextC(false, lib_items_cfg.white, "[")
            lib_helpers.TextC(false, lib_items_cfg.itemEquipped, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    local nameStr = item.name
    local nameColor = lib_items_cfg.unitName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end

    if item.unit.mod == 0 then
    elseif item.unit.mod == -2 then
        nameStr = nameStr .. "--"
    elseif item.unit.mod == -1 then
        nameStr = nameStr .. "-"
    elseif item.unit.mod == 1 then
        nameStr = nameStr .. "+"
    elseif item.unit.mod == 2 then
        nameStr = nameStr .. "++"
    end

    result = result .. lib_helpers.TextC(false, nameColor, "%s ", nameStr)

    if item.kills ~= 0 then
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponKills, "%iK", item.kills)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
    end

    return result
end
local function ProcessMag(item)
    local result = ""

    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if cfg.showEquippedItems then
        if item.equipped then
            lib_helpers.TextC(false, lib_items_cfg.white, "[")
            lib_helpers.TextC(false, lib_items_cfg.itemEquipped, "E")
            lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    end

    local nameColor = lib_items_cfg.magName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magColor, lib_unitxt.GetMagColor(item.mag.color))
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.def)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.pow)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.dex)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.mind)
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbL, cfg.shortPBNames))
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "|")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbC, cfg.shortPBNames))
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "|")
    result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbR, cfg.shortPBNames))
    result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    local timerColor = lib_items_cfg.white
    for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
        if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
            timerColor = lib_items_cfg.magFeedTimer[i + 1]
        end
    end

    lib_helpers.TextC(false, lib_items_cfg.white, "[")
    lib_helpers.TextC(false, timerColor, "%i", item.mag.timer)
    lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    return result
end
local function ProcessTool(item)
    local result = ""
    if cfg.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if item.data[2] == 2 then
        local nameColor = lib_items_cfg.techName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.techLevel, "Lv%i ", item.tool.level)
    else
        local nameColor = lib_items_cfg.toolName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", item.name)
        if item.tool.count > 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.toolAmount, "x%i ", item.tool.count)
        end
    end

    return result
end
local function ProcessMeseta(item)
    local result = ""
    if not cfg.ignoreMeseta then
        if cfg.printItemIndex then
            lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        result = result .. lib_helpers.TextC(false, lib_items_cfg.mesetaName, "%s ", item.name)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.mesetaAmount, "%i ", item.meseta)
    end
    return result
end
local function ProcessItem(item, save)
    save = save or false
    imgui.Text("")

    local itemStr = ""
    if item.data[1] == 0 then
        itemStr = ProcessWeapon(item)
    elseif item.data[1] == 1 then
        if item.data[2] == 1 then
            itemStr = ProcessFrame(item)
        elseif item.data[2] == 2 then
            itemStr = ProcessBarrier(item)
        elseif item.data[2] == 3 then
            itemStr = ProcessUnit(item)
        end
    elseif item.data[1] == 2 then
        itemStr = ProcessMag(item)
    elseif item.data[1] == 3 then
        itemStr = ProcessTool(item)
    elseif item.data[1] == 4 then
        itemStr = ProcessMeseta(item)
    end

    if save then
        local file = io.open(cfg.saveFileName, "a")
        io.output(file)
        io.write(itemStr .. "\n")
        io.close(file)
    end
end

local function PresentInventory(save)
    local inventory = lib_items.GetInventory(lib_items.Me)
    local itemCount = table.getn(inventory.items)

    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "Meseta: %i", inventory.meseta)

    for i=1,itemCount,1 do
        ProcessItem(inventory.items[i], save)
    end
end
local function PresentBank(save)
    local bank = lib_items.GetBank()
    local itemCount = table.getn(bank.items)

    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "Meseta: %i | Count: %i", bank.meseta, itemCount)

    for i=1,itemCount,1 do
        ProcessItem(bank.items[i], save)
    end
end
local function PresentFloor()
    local itemList = lib_items.GetItemList(lib_items.NoOwner, cfg.invertItemList)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        ProcessItem(itemList[i])
    end
end
local function PresentMags()
    local itemList = lib_items.GetItemList(lib_items.Me, false)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        if itemList[i].mag ~= nil then
            ProcessItem(itemList[i])
        end
    end
end

local aioStatus = true
local aioSelection = 1
local function PresentAIO()
    local save = false

    local selectionList = { "Inventory", "Bank", "Floor", "Mags" }
    imgui.PushItemWidth(150)
    aioStatus, aioSelection = imgui.Combo(" ", aioSelection, selectionList, table.getn(selectionList))
    imgui.PopItemWidth()

    if cfg.showButtonSaveToFile then
        imgui.SameLine(0, 20)
        if imgui.Button("Save to file") then
            save = true
            -- Write nothing to it so its cleared works for appending
            local file = io.open(cfg.saveFileName, "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end

    imgui.BeginChild("ItemList", 0)
    imgui.SetWindowFontScale(cfg.fontSize)
    if aioSelection == 1 then
        PresentInventory(save)
    elseif aioSelection == 2 then
        PresentBank(save)
    elseif aioSelection == 3 then
        PresentFloor(save)
    elseif aioSelection == 4 then
        PresentMags(save)
    end
    imgui.EndChild()
end

local function present()
    if cfg.enable == false then
        return
    end

    if cfg.enableAIOWindow then
        imgui.Begin("Item Reader - AIO")
        imgui.SetWindowFontScale(cfg.fontSize)
        PresentAIO()
        imgui.End()
    end
    if cfg.enableInventoryWindow then
        imgui.Begin("Item Reader - Inventory")
        imgui.SetWindowFontScale(cfg.fontSize)
        PresentInventory()
        imgui.End()
    end
    if cfg.enableBankWindow then
        imgui.Begin("Item Reader - Bank")
        imgui.SetWindowFontScale(cfg.fontSize)
        PresentBank()
        imgui.End()
    end
    if cfg.enableFloorWindow then
        imgui.Begin("Item Reader - Floor")
        imgui.SetWindowFontScale(cfg.fontSize)
        PresentFloor()
        imgui.End()
    end
    if cfg.enableMagsWindow then
        imgui.Begin("Item Reader - Mags")
        imgui.SetWindowFontScale(cfg.fontSize)
        PresentMags()
        imgui.End()
    end
end

local function init()
    return
    {
        name = "Item Reader",
        version = "1.0.0",
        author = "Solybum",
        description = "Information about items, anywhere",
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
