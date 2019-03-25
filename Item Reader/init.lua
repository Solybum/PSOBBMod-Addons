local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local cfg = require("Item Reader.configuration")
local optionsLoaded, options = pcall(require, "Item Reader.options")

local optionsFileName = "addons/Item Reader/options.lua"
local ConfigurationWindow
local inventoryDirectory = "addons/Item Reader/inventory/"
local currentInventoryFile = ""

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.printItemIndex            = lib_helpers.NotNilOrDefault(options.printItemIndex, true)
    options.showItemIDs               = lib_helpers.NotNilOrDefault(options.showItemIDs, false)
    options.showItemData              = lib_helpers.NotNilOrDefault(options.showItemData, false)
    options.showEquippedItems         = lib_helpers.NotNilOrDefault(options.showEquippedItems, true)
    options.shortPBNames              = lib_helpers.NotNilOrDefault(options.shortPBNames, true)
    options.ignoreMeseta              = lib_helpers.NotNilOrDefault(options.ignoreMeseta, false)
    options.invertItemList            = lib_helpers.NotNilOrDefault(options.invertItemList, false)
    options.hideMagStats              = lib_helpers.NotNilOrDefault(options.hideMagStats, false)
    options.hideMagPBs                = lib_helpers.NotNilOrDefault(options.hideMagPBs, false)
    options.itemNameLength            = lib_helpers.NotNilOrDefault(options.itemNameLength, 0)
    options.server                    = lib_helpers.NotNilOrDefault(options.server, 1)

    if options.aio == nil or type(options.aio) ~= "table" then
        options.aio = {}
    end
    options.aio.EnableWindow         = lib_helpers.NotNilOrDefault(options.aio.EnableWindow, true)
    options.aio.changed              = lib_helpers.NotNilOrDefault(options.aio.changed, true)
    options.aio.Anchor               = lib_helpers.NotNilOrDefault(options.aio.Anchor, 1)
    options.aio.X                    = lib_helpers.NotNilOrDefault(options.aio.X, 50)
    options.aio.Y                    = lib_helpers.NotNilOrDefault(options.aio.Y, 5)
    options.aio.W                    = lib_helpers.NotNilOrDefault(options.aio.W, 450)
    options.aio.H                    = lib_helpers.NotNilOrDefault(options.aio.H, 350)
    options.aio.NoTitleBar           = lib_helpers.NotNilOrDefault(options.aio.NoTitleBar, "")
    options.aio.NoResize             = lib_helpers.NotNilOrDefault(options.aio.NoResize, "")
    options.aio.NoMove               = lib_helpers.NotNilOrDefault(options.aio.NoMove, "")
    options.aio.AlwaysAutoResize     = lib_helpers.NotNilOrDefault(options.aio.AlwaysAutoResize, "")
    options.aio.TransparentWindow    = lib_helpers.NotNilOrDefault(options.aio.TransparentWindow, false)
    options.aio.ShowButtonSaveToFile = lib_helpers.NotNilOrDefault(options.aio.ShowButtonSaveToFile, true)
    options.aio.SelectedInventory    = lib_helpers.NotNilOrDefault(options.aio.SelectedInventory, 1)

    if options.floor == nil or type(options.floor) ~= "table" then
        options.floor = {}
    end
    options.floor.EnableWindow       = lib_helpers.NotNilOrDefault(options.floor.EnableWindow, true)
    options.floor.changed            = lib_helpers.NotNilOrDefault(options.floor.changed, true)
    options.floor.Anchor             = lib_helpers.NotNilOrDefault(options.floor.Anchor, 1)
    options.floor.X                  = lib_helpers.NotNilOrDefault(options.floor.X, 50)
    options.floor.Y                  = lib_helpers.NotNilOrDefault(options.floor.Y, 50)
    options.floor.W                  = lib_helpers.NotNilOrDefault(options.floor.W, 450)
    options.floor.H                  = lib_helpers.NotNilOrDefault(options.floor.H, 350)
    options.floor.NoTitleBar         = lib_helpers.NotNilOrDefault(options.floor.NoTitleBar, "")
    options.floor.NoResize           = lib_helpers.NotNilOrDefault(options.floor.NoResize, "")
    options.floor.NoMove             = lib_helpers.NotNilOrDefault(options.floor.NoMove, "")
    options.floor.AlwaysAutoResize   = lib_helpers.NotNilOrDefault(options.floor.AlwaysAutoResize, "")
    options.floor.TransparentWindow  = lib_helpers.NotNilOrDefault(options.floor.TransparentWindow, false)

    if options.mags == nil or type(options.mags) ~= "table" then
        options.mags = {}
    end
    options.mags.EnableWindow        = lib_helpers.NotNilOrDefault(options.mags.EnableWindow, true)
    options.mags.changed             = lib_helpers.NotNilOrDefault(options.mags.changed, true)
    options.mags.Anchor              = lib_helpers.NotNilOrDefault(options.mags.Anchor, 1)
    options.mags.X                   = lib_helpers.NotNilOrDefault(options.mags.X, 50)
    options.mags.Y                   = lib_helpers.NotNilOrDefault(options.mags.Y, 50)
    options.mags.W                   = lib_helpers.NotNilOrDefault(options.mags.W, 450)
    options.mags.H                   = lib_helpers.NotNilOrDefault(options.mags.H, 350)
    options.mags.NoTitleBar          = lib_helpers.NotNilOrDefault(options.mags.NoTitleBar, "")
    options.mags.NoResize            = lib_helpers.NotNilOrDefault(options.mags.NoResize, "")
    options.mags.NoMove              = lib_helpers.NotNilOrDefault(options.mags.NoMove, "")
    options.mags.TransparentWindow   = lib_helpers.NotNilOrDefault(options.mags.TransparentWindow, false)
else
    options =
    {
        configurationEnableWindow = true,

        enable = true,
        printItemIndex = true,
        showItemIDs = false,
        showItemData = false,
        showEquippedItems = true,
        shortPBNames = true,
        ignoreMeseta = false,
        invertItemList = false,
        hideMagStats = false,
        hideMagPBs = false,
        itemNameLength = 0,
        server = 1,
        aio = {
            EnableWindow = true,
            changed = true,
            Anchor = 1,
            X = 50,
            Y = 50,
            W = 450,
            H = 350,
            NoTitleBar = "",
            NoResize = "",
            NoMove = "",
            AlwaysAutoResize = "",
            TransparentWindow = false;
            ShowButtonSaveToFile = true,
            SelectedInventory = 1,
        },
        floor = {
            EnableWindow = true,
            changed = true,
            Anchor = 1,
            X = 50,
            Y = 50,
            W = 450,
            H = 350,
            NoTitleBar = "",
            NoResize = "",
            NoMove = "",
            AlwaysAutoResize = "",
            TransparentWindow = false;
        },
        mags = {
            EnableWindow = true,
            changed = true,
            Anchor = 1,
            X = 50,
            Y = 50,
            W = 450,
            H = 350,
            NoTitleBar = "",
            NoResize = "",
            NoMove = "",
            AlwaysAutoResize = "",
            TransparentWindow = false;
        }
    }
end

-- Append server specific items
lib_items_list.AddServerItems(options.server)

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    printItemIndex = %s,\n", tostring(options.printItemIndex)))
        io.write(string.format("    showItemIDs = %s,\n", tostring(options.showItemIDs)))
        io.write(string.format("    showItemData = %s,\n", tostring(options.showItemData)))
        io.write(string.format("    showEquippedItems = %s,\n", tostring(options.showEquippedItems)))
        io.write(string.format("    shortPBNames = %s,\n", tostring(options.shortPBNames)))
        io.write(string.format("    ignoreMeseta = %s,\n", tostring(options.ignoreMeseta)))
        io.write(string.format("    invertItemList = %s,\n", tostring(options.invertItemList)))
        io.write(string.format("    hideMagStats = %s,\n", tostring(options.hideMagStats)))
        io.write(string.format("    hideMagPBs = %s,\n", tostring(options.hideMagPBs)))
        io.write(string.format("    itemNameLength = %s,\n", tostring(options.itemNameLength)))
        io.write(string.format("    server = %s,\n", tostring(options.server)))
        io.write(string.format("    aio = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.aio.EnableWindow)))
        io.write(string.format("        Anchor = %i,\n", options.aio.Anchor))
        io.write(string.format("        X = %i,\n", options.aio.X))
        io.write(string.format("        Y = %i,\n", options.aio.Y))
        io.write(string.format("        W = %i,\n", options.aio.W))
        io.write(string.format("        H = %i,\n", options.aio.H))
        io.write(string.format("        NoTitleBar = \"%s\",\n", options.aio.NoTitleBar))
        io.write(string.format("        NoResize = \"%s\",\n", options.aio.NoResize))
        io.write(string.format("        NoMove = \"%s\",\n", options.aio.NoMove))
        io.write(string.format("        AlwaysAutoResize = \"%s\",\n", options.aio.AlwaysAutoResize))
        io.write(string.format("        TransparentWindow = %s,\n", options.aio.TransparentWindow))
        io.write(string.format("        ShowButtonSaveToFile = %s,\n",  tostring(options.aio.ShowButtonSaveToFile)))
        io.write(string.format("        SelectedInventory = %i,\n", options.aio.SelectedInventory))
        io.write(string.format("    },\n"))
        io.write(string.format("    floor = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.floor.EnableWindow)))
        io.write(string.format("        Anchor = %i,\n", options.floor.Anchor))
        io.write(string.format("        X = %i,\n", options.floor.X))
        io.write(string.format("        Y = %i,\n", options.floor.Y))
        io.write(string.format("        W = %i,\n", options.floor.W))
        io.write(string.format("        H = %i,\n", options.floor.H))
        io.write(string.format("        NoTitleBar = \"%s\",\n", options.floor.NoTitleBar))
        io.write(string.format("        NoResize = \"%s\",\n", options.floor.NoResize))
        io.write(string.format("        NoMove = \"%s\",\n", options.floor.NoMove))
        io.write(string.format("        AlwaysAutoResize = \"%s\",\n", options.floor.AlwaysAutoResize))
        io.write(string.format("        TransparentWindow = %s,\n", options.floor.TransparentWindow))
        io.write(string.format("    },\n"))
        io.write(string.format("    mags = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.mags.EnableWindow)))
        io.write(string.format("        Anchor = %i,\n", options.mags.Anchor))
        io.write(string.format("        X = %i,\n", options.mags.X))
        io.write(string.format("        Y = %i,\n", options.mags.Y))
        io.write(string.format("        W = %i,\n", options.mags.W))
        io.write(string.format("        H = %i,\n", options.mags.H))
        io.write(string.format("        NoTitleBar = \"%s\",\n", options.mags.NoTitleBar))
        io.write(string.format("        NoResize = \"%s\",\n", options.mags.NoResize))
        io.write(string.format("        NoMove = \"%s\",\n", options.mags.NoMove))
        io.write(string.format("        AlwaysAutoResize = \"%s\",\n", options.mags.AlwaysAutoResize))
        io.write(string.format("        TransparentWindow = %s,\n", options.mags.TransparentWindow))
        io.write(string.format("    },\n"))
        io.write("}\n")

        io.close(file)
    end
end

local function TrimString(text, length)
    local result = text;
    if length > 0 then
        result = string.sub(text, 0, length)
        local strLength = string.len(text)
        strLength = strLength - 3
        if length < strLength then
            result = result .. "..."
        end
    end
    return result
end

local function ProcessWeapon(item)
    local result = ""
    imgui.Text("")

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

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
            result = result .. lib_helpers.TextC(false, lib_items_cfg.weaponSRankSpecial[item.weapon.specialSRank], lib_unitxt.GetSRankSpecialName(item.weapon.specialSRank))
            result = result .. lib_helpers.TextC(false, lib_items_cfg.white, "] ")
        end
    else
        local nameColor = lib_items_cfg.weaponName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

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
            if item.weapon.statpresence[i - 1] == 1 and item.weapon.stats[i] == 0 then
                statColor = lib_items_cfg.red
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
        if item.weapon.statpresence[5] == 1 and item.weapon.stats[6] == 0 then
            statColor = lib_items_cfg.red
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

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

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
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

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

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

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
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

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

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

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

    result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(nameStr, options.itemNameLength))

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

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

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
    result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

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

    if options.showItemIDs then
        lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if options.showItemData then
        lib_helpers.TextC(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

    if options.printItemIndex then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if item.data[2] == 2 then
        local nameColor = lib_items_cfg.techName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
        result = result .. lib_helpers.TextC(false, lib_items_cfg.techLevel, "Lv%i ", item.tool.level)
    else
        local nameColor = lib_items_cfg.toolName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        result = result .. lib_helpers.TextC(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
        if item.tool.count > 0 then
            result = result .. lib_helpers.TextC(false, lib_items_cfg.toolAmount, "x%i ", item.tool.count)
        end
    end

    return result
end
local function ProcessMeseta(item)
    local result = ""
    if options.showItemIDs == false and options.ignoreMeseta == false then
        imgui.Text("")

        if options.showItemIDs then
            lib_helpers.TextC(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            lib_helpers.TextC(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

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
    -- but only when item IDs are off
    if options.showItemIDs == false and floor == true then
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
        local file = io.open(currentInventoryFile, "a")
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
local aioSelectedInventory = options.aio.SelectedInventory
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

    if aioSelectedInventory < 4 and aioSelectedInventory ~= options.aio.SelectedInventory then
        options.aio.SelectedInventory = aioSelectedInventory
        SaveOptions(options)
    end

    if options.aio.ShowButtonSaveToFile then
        imgui.SameLine(0, 20)
        if imgui.Button("Save to file") then
            save = true
            currentInventoryFile = inventoryDirectory..os.date('%Y%m%d_%H%M%S').."_saved_inventory.txt"
            -- Create file
            local file = io.open(currentInventoryFile, "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end

    local childWindowName = "Item Reader - AIO - ItemList"
    --imgui.BeginChild(childWindowName, 0, 0, false, {"HorizontalScrollbar", "AlwaysAutoResize"})
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
    --imgui.EndChild()
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

    if options.aio.EnableWindow then
        local windowName = "Item Reader - AIO"

        if options.aio.TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if options.aio.AlwaysAutoResize == "AlwaysAutoResize" then
            imgui.SetNextWindowSizeConstraints(0, 0, options.aio.W, options.aio.H)
        end

        if imgui.Begin(windowName,
            nil,
            {
                options.aio.NoTitleBar,
                options.aio.NoResize,
                options.aio.NoMove,
                options.aio.AlwaysAutoResize,
            }
        ) then
            PresentAIO()

            lib_helpers.WindowPositionAndSize(windowName,
                options.aio.X,
                options.aio.Y,
                options.aio.W,
                options.aio.H,
                options.aio.Anchor,
                options.aio.AlwaysAutoResize,
                options.aio.changed)
        end
        imgui.End()

        if options.aio.TransparentWindow == true then
            imgui.PopStyleColor()
        end

        options.aio.changed = false
    end
    if options.floor.EnableWindow then
        local windowName = "Item Reader - Floor"

        if options.floor.TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if options.floor.AlwaysAutoResize == "AlwaysAutoResize" then
            imgui.SetNextWindowSizeConstraints(0, 0, options.floor.W, options.floor.H)
        end

        if imgui.Begin(windowName,
            nil,
            {
                options.floor.NoTitleBar,
                options.floor.NoResize,
                options.floor.NoMove,
                options.floor.AlwaysAutoResize,
            }
        ) then
            PresentFloor()

            lib_helpers.WindowPositionAndSize(windowName,
                options.floor.X,
                options.floor.Y,
                options.floor.W,
                options.floor.H,
                options.floor.Anchor,
                options.floor.AlwaysAutoResize,
                options.floor.changed)
        end
        imgui.End()

        if options.floor.TransparentWindow == true then
            imgui.PopStyleColor()
        end

        options.floor.changed = false
    end
    if options.mags.EnableWindow then
        local windowName = "Item Reader - Mags"

        if options.mags.TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end


        if options.mags.AlwaysAutoResize == "AlwaysAutoResize" then
            imgui.SetNextWindowSizeConstraints(0, 0, options.mags.W, options.mags.H)
        end

        if imgui.Begin(windowName,
            nil,
            {
                options.mags.NoTitleBar,
                options.mags.NoResize,
                options.mags.NoMove,
                options.mags.AlwaysAutoResize,
            }
        ) then
            PresentMags()

            lib_helpers.WindowPositionAndSize(windowName,
                options.mags.X,
                options.mags.Y,
                options.mags.W,
                options.mags.H,
                options.mags.Anchor,
                options.mags.AlwaysAutoResize,
                options.mags.changed)
        end
        imgui.End()

        if options.mags.TransparentWindow == true then
            imgui.PopStyleColor()
        end

        options.mags.changed = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Item Reader", mainMenuButtonHandler)

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
