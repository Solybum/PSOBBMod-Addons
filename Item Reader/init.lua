local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local lib_theme_loaded, lib_theme = pcall(require, "Theme Editor.theme")
local cfg = require("Item Reader.configuration")
local optionsLoaded, options = pcall(require, "Item Reader.options")

local optionsFileName = "addons/Item Reader/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.useCustomTheme            = lib_helpers.NotNilOrDefault(options.useCustomTheme, false)
    options.fontScale                 = lib_helpers.NotNilOrDefault(options.fontScale, 1.0)
    options.printItemIndex            = lib_helpers.NotNilOrDefault(options.printItemIndex, true)
    options.showEquippedItems         = lib_helpers.NotNilOrDefault(options.showEquippedItems, true)
    options.shortPBNames              = lib_helpers.NotNilOrDefault(options.shortPBNames, true)
    options.ignoreMeseta              = lib_helpers.NotNilOrDefault(options.ignoreMeseta, false)
    options.invertItemList            = lib_helpers.NotNilOrDefault(options.invertItemList, false)
    options.hideMagStats              = lib_helpers.NotNilOrDefault(options.hideMagStats, false)
    options.hideMagPBs                = lib_helpers.NotNilOrDefault(options.hideMagPBs, false)

    options.aioEnableWindow         = lib_helpers.NotNilOrDefault(options.aioEnableWindow, true)
    options.aioChanged              = lib_helpers.NotNilOrDefault(options.aioChanged, false)
    options.aioAnchor               = lib_helpers.NotNilOrDefault(options.aioAnchor, 1)
    options.aioX                    = lib_helpers.NotNilOrDefault(options.aioX, 50)
    options.aioY                    = lib_helpers.NotNilOrDefault(options.aioY, 5)
    options.aioW                    = lib_helpers.NotNilOrDefault(options.aioW, 450)
    options.aioH                    = lib_helpers.NotNilOrDefault(options.aioH, 350)
    options.aioNoTitleBar           = lib_helpers.NotNilOrDefault(options.aioNoTitleBar, "")
    options.aioNoResize             = lib_helpers.NotNilOrDefault(options.aioNoResize, "")
    options.aioNoMove               = lib_helpers.NotNilOrDefault(options.aioNoMove, "")
    options.aioShowButtonSaveToFile = lib_helpers.NotNilOrDefault(options.aioShowButtonSaveToFile, true)
    options.aioSaveFileName         = lib_helpers.NotNilOrDefault(options.saveFileName, "addons/saved_inventory.txt")
    options.aioSelectedInventory    = lib_helpers.NotNilOrDefault(options.aioSelectedInventory, 1)

    options.floorEnableWindow = lib_helpers.NotNilOrDefault(options.floorEnableWindow, true)
    options.floorChanged      = lib_helpers.NotNilOrDefault(options.floorChanged, false)
    options.floorAnchor       = lib_helpers.NotNilOrDefault(options.floorAnchor, 1)
    options.floorX            = lib_helpers.NotNilOrDefault(options.floorX, 50)
    options.floorY            = lib_helpers.NotNilOrDefault(options.floorY, 50)
    options.floorW            = lib_helpers.NotNilOrDefault(options.floorW, 450)
    options.floorH            = lib_helpers.NotNilOrDefault(options.floorH, 350)
    options.floorNoTitleBar   = lib_helpers.NotNilOrDefault(options.floorNoTitleBar, "")
    options.floorNoResize     = lib_helpers.NotNilOrDefault(options.floorNoResize, "")
    options.floorNoMove       = lib_helpers.NotNilOrDefault(options.floorNoMove, "")

    options.magsEnableWindow = lib_helpers.NotNilOrDefault(options.magsEnableWindow, true)
    options.magsChanged      = lib_helpers.NotNilOrDefault(options.magsChanged, false)
    options.magsAnchor       = lib_helpers.NotNilOrDefault(options.magsAnchor, 1)
    options.magsX            = lib_helpers.NotNilOrDefault(options.magsX, 50)
    options.magsY            = lib_helpers.NotNilOrDefault(options.magsY, 50)
    options.magsW            = lib_helpers.NotNilOrDefault(options.magsW, 450)
    options.magsH            = lib_helpers.NotNilOrDefault(options.magsH, 350)
    options.magsNoTitleBar   = lib_helpers.NotNilOrDefault(options.magsNoTitleBar, "")
    options.magsNoResize     = lib_helpers.NotNilOrDefault(options.magsNoResize, "")
    options.magsNoMove       = lib_helpers.NotNilOrDefault(options.magsNoMove, "")
else
    options = 
    {
        configurationEnableWindow = true,

        enable = true,
        useCustomTheme = false,
        fontScale = 1.0,
        printItemIndex = true,
        showEquippedItems = true,
        shortPBNames = true,
        ignoreMeseta = false,
        invertItemList = false,
        hideMagStats = false,
        hideMagPBs = false,

        aioEnableWindow = true,
        aioChanged = false,
        aioAnchor = 1,
        aioX = 50,
        aioY = 50,
        aioW = 450,
        aioH = 350,
        aioNoTitleBar = "",
        aioNoResize = "",
        aioNoMove = "",
        auiShowButtonSaveToFile = true,
        aioSaveFileName = "addons/saved_inventory.txt",
        aioSelectedInventory = 1,

        floorEnableWindow = true,
        floorChanged = false,
        floorAnchor = 1,
        floorX = 50,
        floorY = 50,
        floorW = 450,
        floorH = 350,
        floorNoTitleBar = "",
        floorNoResize = "",
        floorNoMove = "",

        magsEnableWindow = true,
        magsChanged = false,
        magsAnchor = 1,
        magsX = 50,
        magsY = 50,
        magsW = 450,
        magsH = 350,
        magsNoTitleBar = "",
        magsNoResize = "",
        magsNoMove = "",
    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    useCustomTheme = %s,\n", tostring(options.enable)))
        io.write(string.format("    fontScale = %s,\n", tostring(options.fontScale)))
        io.write(string.format("    printItemIndex = %s,\n", tostring(options.printItemIndex)))
        io.write(string.format("    showEquippedItems = %s,\n", tostring(options.showEquippedItems)))
        io.write(string.format("    shortPBNames = %s,\n", tostring(options.shortPBNames)))
        io.write(string.format("    ignoreMeseta = %s,\n", tostring(options.ignoreMeseta)))
        io.write(string.format("    invertItemList = %s,\n", tostring(options.invertItemList)))
        io.write(string.format("    hideMagStats = %s,\n", tostring(options.hideMagStats)))
        io.write(string.format("    hideMagPBs = %s,\n", tostring(options.hideMagPBs)))
        io.write("\n")
        io.write(string.format("    aioEnableWindow = %s,\n", tostring(options.aioEnableWindow)))
        io.write(string.format("    aioChanged = %s,\n", tostring(options.aioChanged)))
        io.write(string.format("    aioAnchor = %i,\n", options.aioAnchor))
        io.write(string.format("    aioX = %i,\n", options.aioX))
        io.write(string.format("    aioY = %i,\n", options.aioY))
        io.write(string.format("    aioW = %i,\n", options.aioW))
        io.write(string.format("    aioH = %i,\n", options.aioH))
        io.write(string.format("    aioNoTitleBar = \"%s\",\n", options.aioNoTitleBar))
        io.write(string.format("    aioNoResize = \"%s\",\n", options.aioNoResize))
        io.write(string.format("    aioNoMove = \"%s\",\n", options.aioNoMove))
        io.write(string.format("    aioShowButtonSaveToFile = %s,\n",  tostring(options.aioShowButtonSaveToFile)))
        io.write(string.format("    aioSaveFileName = \"%s\",\n", options.aioSaveFileName))
        io.write(string.format("    aioSelectedInventory = %i,\n", options.aioSelectedInventory))
        io.write("\n")
        io.write(string.format("    floorEnableWindow = %s,\n", tostring(options.floorEnableWindow)))
        io.write(string.format("    floorChanged = %s,\n", tostring(options.floorChanged)))
        io.write(string.format("    floorAnchor = %i,\n", options.floorAnchor))
        io.write(string.format("    floorX = %i,\n", options.floorX))
        io.write(string.format("    floorY = %i,\n", options.floorY))
        io.write(string.format("    floorW = %i,\n", options.floorW))
        io.write(string.format("    floorH = %i,\n", options.floorH))
        io.write(string.format("    floorNoTitleBar = \"%s\",\n", options.floorNoTitleBar))
        io.write(string.format("    floorNoResize = \"%s\",\n", options.floorNoResize))
        io.write(string.format("    floorNoMove = \"%s\",\n", options.floorNoMove))
        io.write("\n")
        io.write(string.format("    magsEnableWindow = %s,\n", tostring(options.magsEnableWindow)))
        io.write(string.format("    magsChanged = %s,\n", tostring(options.magsChanged)))
        io.write(string.format("    magsAnchor = %i,\n", options.magsAnchor))
        io.write(string.format("    magsX = %i,\n", options.magsX))
        io.write(string.format("    magsY = %i,\n", options.magsY))
        io.write(string.format("    magsW = %i,\n", options.magsW))
        io.write(string.format("    magsH = %i,\n", options.magsH))
        io.write(string.format("    magsNoTitleBar = \"%s\",\n", options.magsNoTitleBar))
        io.write(string.format("    magsNoResize = \"%s\",\n", options.magsNoResize))
        io.write(string.format("    magsNoMove = \"%s\",\n", options.magsNoMove))
        io.write("}\n")

        io.close(file)
    end
end

local function ProcessWeapon(item)
    local result = ""
    imgui.Text("")
    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if options.showEquippedItems then
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
    imgui.Text("")
    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if options.showEquippedItems then
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
    imgui.Text("")
    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if options.showEquippedItems then
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
    imgui.Text("")
    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if options.showEquippedItems then
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
    imgui.Text("")
    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if options.showEquippedItems then
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

    if options.hideMagStats == false then
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.def)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.pow)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.dex)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "/")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.mind)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
    end

    if options.hideMagPBs == false then
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "[")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbL, options.shortPBNames))
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "|")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbC, options.shortPBNames))
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "|")
        result = result .. lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbR, options.shortPBNames))
        result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
    end

    local timerColor = lib_items_cfg.white
    for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
        if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
            timerColor = lib_items_cfg.magFeedTimer[i + 1]
        end
    end

    lib_helpers.TextC(false, lib_items_cfg.white, "[")
    lib_helpers.TextC(false, timerColor, os.date("!%M:%S", item.mag.timer))
    lib_helpers.TextC(false, lib_items_cfg.white, "] ")

    return result
end
local function ProcessTool(item)
    local result = ""
    imgui.Text("")
    if options.printItemIndex then
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
    if not options.ignoreMeseta then
        imgui.Text("")
        if options.printItemIndex then
            lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        result = result .. lib_helpers.TextC(false, lib_items_cfg.mesetaName, "%s ", item.name)
        result = result .. lib_helpers.TextC(false, lib_items_cfg.mesetaAmount, "%i ", item.meseta)
    end
    return result
end
local function ProcessItem(item, floor, save)
    floor = floor or false
    save = save or false

    -- Do not process disabled items when it's floor list
    if floor == true then
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[2] == false then
            return
        end
    end

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
        local file = io.open(options.aioSaveFileName, "a")
        io.output(file)
        io.write(itemStr .. "\n")
        io.close(file)
    end
end

local function PresentInventory(save, index)
    index = index or lib_items.Me
    local inventory = lib_items.GetInventory(index)
    local itemCount = table.getn(inventory.items)
    
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "Meseta: %i", inventory.meseta)
    
    for i=1,itemCount,1 do
        ProcessItem(inventory.items[i], false, save)
    end
end
local function PresentBank(save)
    local bank = lib_items.GetBank()
    local itemCount = table.getn(bank.items)

    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "Meseta: %i | Count: %i", bank.meseta, itemCount)

    for i=1,itemCount,1 do
        ProcessItem(bank.items[i], false, save)
    end
end
local function PresentFloor()
    local itemList = lib_items.GetItemList(lib_items.NoOwner, options.invertItemList)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        ProcessItem(itemList[i], true, false)
    end
end
local function PresentMags()
    local itemList = lib_items.GetItemList(lib_items.Me, false)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        if itemList[i].mag ~= nil then
            ProcessItem(itemList[i], false, false)
        end
    end
end

local function BuildAIOSelection()
    local selectionList = { "Inventory", "Bank", "Floor", "Mags" }

    --local playerList = lib_characters.GetPlayerList()
    --local playerListCount = table.getn(playerList)
    --for i=1, playerListCount, 1 do
    --    local playerName = lib_characters.GetPlayerName(playerList[i].address)
    --    table.insert(selectionList, playerName)
    --end

    return selectionList
end

local aioStatus = true
local aioSelectedInventory = options.aioSelectedInventory
local function PresentAIO()
    local save = false

    local selectionList = BuildAIOSelection()
    local selectionListCount = table.getn(selectionList)
    if aioSelectedInventory > selectionListCount then
        aioSelectedInventory = 1
    end

    imgui.PushItemWidth(150)
    aioStatus, aioSelectedInventory = imgui.Combo(" ", aioSelectedInventory, selectionList, selectionListCount)
    imgui.PopItemWidth()

    if aioSelectedInventory < 4 and aioSelectedInventory ~= options.aioSelectedInventory then
        options.aioSelectedInventory = aioSelectedInventory
        SaveOptions(options)
    end

    if options.aioShowButtonSaveToFile then
        imgui.SameLine(0, 20)
        if imgui.Button("Save to file") then
            save = true
            -- Write nothing to it so its cleared works for appending
            local file = io.open(options.aioSaveFileName, "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end

    imgui.BeginChild("ItemList", 0)
    imgui.SetWindowFontScale(options.fontScale)
    if aioSelectedInventory == 1 then
        PresentInventory(save, lib_items.Me)
    elseif aioSelectedInventory == 2 then
        PresentBank(save)
    elseif aioSelectedInventory == 3 then
        PresentFloor(save)
    elseif aioSelectedInventory == 4 then
        PresentMags(save)
    else
        PresentInventory(save, aioSelectedInventory - 5)
    end
    imgui.EndChild()
end

local function present()
    -- If the addon has never been used, open the config window
    -- and disable the config window setting
    if options.configurationEnableWindow then
        ConfigurationWindow.open = true
        options.configurationEnableWindow = false
    end
    ConfigurationWindow.Update()

    if ConfigurationWindow.changed then
        ConfigurationWindow.changed = false
        SaveOptions(options)
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    -- Push custom theme, only if enabled
    if lib_theme_loaded and options.useCustomTheme then
        lib_theme.Push()
    end

    if options.aioEnableWindow then
        if firstPresent or options.aioChanged then
            options.aioChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.aioX, options.aioY, options.aioW, options.aioH, options.aioAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.aioW, options.aioH, "Always");
        end

        if imgui.Begin("Item Reader - AIO", nil, { options.aioNoTitleBar, options.aioNoResize, options.aioNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentAIO()
        end
        imgui.End()
    end
    if options.floorEnableWindow then
        if firstPresent or options.floorChanged then
            options.floorChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.floorX, options.floorY, options.floorW, options.floorH, options.floorAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.floorW, options.floorH, "Always");
        end

        if imgui.Begin("Item Reader - Floor", nil, { options.floorNoTitleBar, options.floorNoResize, options.floorNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentFloor()
        end
        imgui.End()
    end
    if options.magsEnableWindow then
        if firstPresent or options.magsChanged then
            options.magsChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.magsX, options.magsY, options.magsW, options.magsH, options.magsAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.magsW, options.magsH, "Always");
        end

        if imgui.Begin("Item Reader - Mags", nil, { options.magsNoTitleBar, options.magsNoResize, options.magsNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentMags()
        end
        imgui.End()
    end

    -- Pop custom theme, only if enabled
    if lib_theme_loaded and options.useCustomTheme then
        lib_theme.Pop()
    end

    if firstPresent then
        firstPresent = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Item Reader", mainMenuButtonHandler)

    if lib_theme_loaded == false then
        print("Item Reader: lib_theme couldn't be loaded")
    end

    return
    {
        name = "Item Reader",
        version = "1.0.2",
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
