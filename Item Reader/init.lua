local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_menu = require("solylib.menu")
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
    options.hideMagColor              = lib_helpers.NotNilOrDefault(options.hideMagColor, false)
    options.itemNameLength            = lib_helpers.NotNilOrDefault(options.itemNameLength, 0)
    options.updateThrottle            = lib_helpers.NotNilOrDefault(options.updateThrottle, 0)
    options.server                    = lib_helpers.NotNilOrDefault(options.server, 1)

    if options.aio == nil or type(options.aio) ~= "table" then
        options.aio = {}
    end
    options.aio.EnableWindow            = lib_helpers.NotNilOrDefault(options.aio.EnableWindow, true)
    options.aio.HideWhenMenu            = lib_helpers.NotNilOrDefault(options.aio.HideWhenMenu, true)
    options.aio.HideWhenSymbolChat      = lib_helpers.NotNilOrDefault(options.aio.HideWhenSymbolChat, true)
    options.aio.HideWhenMenuUnavailable = lib_helpers.NotNilOrDefault(options.aio.HideWhenMenuUnavailable, true)
    options.aio.changed                 = lib_helpers.NotNilOrDefault(options.aio.changed, true)
    options.aio.Anchor                  = lib_helpers.NotNilOrDefault(options.aio.Anchor, 1)
    options.aio.X                       = lib_helpers.NotNilOrDefault(options.aio.X, 50)
    options.aio.Y                       = lib_helpers.NotNilOrDefault(options.aio.Y, 5)
    options.aio.W                       = lib_helpers.NotNilOrDefault(options.aio.W, 450)
    options.aio.H                       = lib_helpers.NotNilOrDefault(options.aio.H, 350)
    options.aio.NoTitleBar              = lib_helpers.NotNilOrDefault(options.aio.NoTitleBar, "")
    options.aio.NoResize                = lib_helpers.NotNilOrDefault(options.aio.NoResize, "")
    options.aio.NoMove                  = lib_helpers.NotNilOrDefault(options.aio.NoMove, "")
    options.aio.AlwaysAutoResize        = lib_helpers.NotNilOrDefault(options.aio.AlwaysAutoResize, "")
    options.aio.TransparentWindow       = lib_helpers.NotNilOrDefault(options.aio.TransparentWindow, false)
    options.aio.ShowButtonSaveToFile    = lib_helpers.NotNilOrDefault(options.aio.ShowButtonSaveToFile, true)
    options.aio.SelectedInventory       = lib_helpers.NotNilOrDefault(options.aio.SelectedInventory, 1)

    if options.floor == nil or type(options.floor) ~= "table" then
        options.floor = {}
    end
    options.floor.EnableWindow                 = lib_helpers.NotNilOrDefault(options.floor.EnableWindow, true)
    options.floor.HideWhenMenu                 = lib_helpers.NotNilOrDefault(options.floor.HideWhenMenu, true)
    options.floor.HideWhenSymbolChat           = lib_helpers.NotNilOrDefault(options.floor.HideWhenSymbolChat, true)
    options.floor.HideWhenMenuUnavailable      = lib_helpers.NotNilOrDefault(options.floor.HideWhenMenuUnavailable, true)
    options.floor.changed                      = lib_helpers.NotNilOrDefault(options.floor.changed, true)
    options.floor.Anchor                       = lib_helpers.NotNilOrDefault(options.floor.Anchor, 1)
    options.floor.X                            = lib_helpers.NotNilOrDefault(options.floor.X, 50)
    options.floor.Y                            = lib_helpers.NotNilOrDefault(options.floor.Y, 50)
    options.floor.W                            = lib_helpers.NotNilOrDefault(options.floor.W, 450)
    options.floor.H                            = lib_helpers.NotNilOrDefault(options.floor.H, 350)
    options.floor.NoTitleBar                   = lib_helpers.NotNilOrDefault(options.floor.NoTitleBar, "")
    options.floor.NoResize                     = lib_helpers.NotNilOrDefault(options.floor.NoResize, "")
    options.floor.NoMove                       = lib_helpers.NotNilOrDefault(options.floor.NoMove, "")
    options.floor.AlwaysAutoResize             = lib_helpers.NotNilOrDefault(options.floor.AlwaysAutoResize, "")
    options.floor.TransparentWindow            = lib_helpers.NotNilOrDefault(options.floor.TransparentWindow, false)
    options.floor.ShowInvMesetaAndItemCount    = lib_helpers.NotNilOrDefault(options.floor.ShowInvMesetaAndItemCount, false)
    options.floor.ShowMultiFloor               = lib_helpers.NotNilOrDefault(options.floor.ShowMultiFloor, false)
    options.floor.OtherFloorsBrightnessPercent = lib_helpers.NotNilOrDefault(options.floor.OtherFloorsBrightnessPercent, 100)
    options.floor.OtherFloorsPrependString     = lib_helpers.NotNilOrDefault(options.floor.OtherFloorsPrependString, "")
    options.floor.EnableFilters                = lib_helpers.NotNilOrDefault(options.floor.EnableFilters, false)

    if options.floor.filter == nil or type(options.floor.filter) ~= "table" then
        options.floor.filter = {}
    end
    options.floor.filter.HitMin			    = lib_helpers.NotNilOrDefault(options.floor.filter.HitMin, 40)
    options.floor.filter.HideLowHitWeapons  = lib_helpers.NotNilOrDefault(options.floor.filter.HideLowHitWeapons, false)
    options.floor.filter.HideLowSocketArmor = lib_helpers.NotNilOrDefault(options.floor.filter.HideLowSocketArmor, false)
    options.floor.filter.HideUselessUnits   = lib_helpers.NotNilOrDefault(options.floor.filter.HideUselessUnits, false)
    options.floor.filter.HideUselessTechs   = lib_helpers.NotNilOrDefault(options.floor.filter.HideUselessTechs, false)
    options.floor.filter.HideMonomates      = lib_helpers.NotNilOrDefault(options.floor.filter.HideMonomates, false)
    options.floor.filter.HideDimates        = lib_helpers.NotNilOrDefault(options.floor.filter.HideDimates, false)
    options.floor.filter.HideTrimates       = lib_helpers.NotNilOrDefault(options.floor.filter.HideTrimates, false)
    options.floor.filter.HideMonofluids     = lib_helpers.NotNilOrDefault(options.floor.filter.HideMonofluids, false)
    options.floor.filter.HideDifluids       = lib_helpers.NotNilOrDefault(options.floor.filter.HideDifluids, false)
    options.floor.filter.HideTrifluids      = lib_helpers.NotNilOrDefault(options.floor.filter.HideTrifluids, false)
    options.floor.filter.HideSolAtomizers   = lib_helpers.NotNilOrDefault(options.floor.filter.HideSolAtomizers, false)
    options.floor.filter.HideMoonAtomizers  = lib_helpers.NotNilOrDefault(options.floor.filter.HideMoonAtomizers, false)
    options.floor.filter.HideStarAtomizers  = lib_helpers.NotNilOrDefault(options.floor.filter.HideStarAtomizers, false)
    options.floor.filter.HideAntidotes      = lib_helpers.NotNilOrDefault(options.floor.filter.HideAntidotes, false)
    options.floor.filter.HideAntiparalysis  = lib_helpers.NotNilOrDefault(options.floor.filter.HideAntiparalysis, false)
    options.floor.filter.HideTelepipes      = lib_helpers.NotNilOrDefault(options.floor.filter.HideTelepipes, false)
    options.floor.filter.HideTrapVisions    = lib_helpers.NotNilOrDefault(options.floor.filter.HideTrapVisions, false)
    options.floor.filter.HideMonogrinders   = lib_helpers.NotNilOrDefault(options.floor.filter.HideMonogrinders, false)
    options.floor.filter.HideDigrinders     = lib_helpers.NotNilOrDefault(options.floor.filter.HideDigrinders, false)
    options.floor.filter.HideTrigrinders    = lib_helpers.NotNilOrDefault(options.floor.filter.HideTrigrinders, false)
    options.floor.filter.HideHPMats         = lib_helpers.NotNilOrDefault(options.floor.filter.HideHPMats, false)
    options.floor.filter.HidePowerMats      = lib_helpers.NotNilOrDefault(options.floor.filter.HidePowerMats, false)
    options.floor.filter.HideLuckMats       = lib_helpers.NotNilOrDefault(options.floor.filter.HideLuckMats, false)
    options.floor.filter.HideMindMats       = lib_helpers.NotNilOrDefault(options.floor.filter.HideMindMats, false)
    options.floor.filter.HideDefenseMats    = lib_helpers.NotNilOrDefault(options.floor.filter.HideDefenseMats, false)
    options.floor.filter.HideEvadeMats      = lib_helpers.NotNilOrDefault(options.floor.filter.HideEvadeMats, false)

    if options.mags == nil or type(options.mags) ~= "table" then
        options.mags = {}
    end
    options.mags.EnableWindow             = lib_helpers.NotNilOrDefault(options.mags.EnableWindow, true)
    options.mags.HideWhenMenu             = lib_helpers.NotNilOrDefault(options.mags.HideWhenMenu, true)
    options.mags.HideWhenSymbolChat       = lib_helpers.NotNilOrDefault(options.mags.HideWhenSymbolChat, true)
    options.mags.HideWhenMenuUnavailable  = lib_helpers.NotNilOrDefault(options.mags.HideWhenMenuUnavailable, true)
    options.mags.changed                  = lib_helpers.NotNilOrDefault(options.mags.changed, true)
    options.mags.Anchor                   = lib_helpers.NotNilOrDefault(options.mags.Anchor, 1)
    options.mags.X                        = lib_helpers.NotNilOrDefault(options.mags.X, 50)
    options.mags.Y                        = lib_helpers.NotNilOrDefault(options.mags.Y, 50)
    options.mags.W                        = lib_helpers.NotNilOrDefault(options.mags.W, 450)
    options.mags.H                        = lib_helpers.NotNilOrDefault(options.mags.H, 350)
    options.mags.NoTitleBar               = lib_helpers.NotNilOrDefault(options.mags.NoTitleBar, "")
    options.mags.NoResize                 = lib_helpers.NotNilOrDefault(options.mags.NoResize, "")
    options.mags.NoMove                   = lib_helpers.NotNilOrDefault(options.mags.NoMove, "")
    options.mags.TransparentWindow        = lib_helpers.NotNilOrDefault(options.mags.TransparentWindow, false)
    options.mags.printItemIndex           = lib_helpers.NotNilOrDefault(options.mags.printItemIndex, true)
    options.mags.showItemIDs              = lib_helpers.NotNilOrDefault(options.mags.showItemIDs, false)
    options.mags.showItemData             = lib_helpers.NotNilOrDefault(options.mags.showItemData, false)
    options.mags.showEquippedItems        = lib_helpers.NotNilOrDefault(options.mags.showEquippedItems, true)
    options.mags.hideMagStats             = lib_helpers.NotNilOrDefault(options.mags.hideMagStats, false)
    options.mags.hideMagPBs               = lib_helpers.NotNilOrDefault(options.mags.hideMagPBs, false)
    options.mags.hideMagColor             = lib_helpers.NotNilOrDefault(options.mags.hideMagColor, false)
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
        hideMagColor = false,
        itemNameLength = 0,
        updateThrottle = 0,
        server = 1,
        aio = {
            EnableWindow = true,
            HideWhenMenu = false,
            HideWhenSymbolChat = false,
            HideWhenMenuUnavailable = false,
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
            HideWhenMenu = false,
            HideWhenSymbolChat = false,
            HideWhenMenuUnavailable = false,
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
            TransparentWindow = false,
            ShowMultiFloor = false,
            OtherFloorsBrightnessPercent = 100,
            OtherFloorsPrependString = "",
            EnableFilters = false,
            filter = {
                HitMin = 40,
                HideLowHitWeapons = false,
                HideLowSocketArmor = false,
                HideUselessUnits = false,
                HideUselessTechs = false,
                HideMonomates = false,
                HideDimates = false,
                HideTrimates = false,
                HideMonofluids = false,
                HideDifluids = false,
                HideTrifluids = false,
                HideSolAtomizers = false,
                HideMoonAtomizers = false,
                HideStarAtomizers = false,
                HideAntidotes = false,
                HideAntiparalysis = false,
                HideTelepipes = false,
                HideTrapVisions = false,
                HideMonogrinders = false,
                HideDigrinders = false,
                HideTrigrinders = false,
                HideHPMats = false,
                HidePowerMats = false,
                HideLuckMats = false,
                HideMindMats = false,
                HideDefenseMats = false,
                HideEvadeMats = false,
            },
        },
        mags = {
            EnableWindow = true,
            HideWhenMenu = false,
            HideWhenSymbolChat = false,
            HideWhenMenuUnavailable = false,
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
            TransparentWindow = false,
            printItemIndex = true,
            showItemIDs = false,
            showItemData = false,
            showEquippedItems = false,
            hideMagStats = false,
            hideMagPBs = false,
            hideMagColor = false,
        }
    }
end

-- Append server specific items
lib_items_list.AddServerItems(options.server)
lib_unitxt.AddServerMagColors(options.server)

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
        io.write(string.format("    hideMagColor = %s,\n", tostring(options.hideMagColor)))
        io.write(string.format("    itemNameLength = %s,\n", tostring(options.itemNameLength)))
        io.write(string.format("    server = %s,\n", tostring(options.server)))
        io.write(string.format("    updateThrottle = %i,\n", tostring(options.updateThrottle)))
        io.write(string.format("    aio = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.aio.EnableWindow)))
        io.write(string.format("        HideWhenMenu = %s,\n", tostring(options.aio.HideWhenMenu)))
        io.write(string.format("        HideWhenSymbolChat = %s,\n", tostring(options.aio.HideWhenSymbolChat)))
        io.write(string.format("        HideWhenMenuUnavailable = %s,\n", tostring(options.aio.HideWhenMenuUnavailable)))
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
        io.write(string.format("        HideWhenMenu = %s,\n", tostring(options.floor.HideWhenMenu)))
        io.write(string.format("        HideWhenSymbolChat = %s,\n", tostring(options.floor.HideWhenSymbolChat)))
        io.write(string.format("        HideWhenMenuUnavailable = %s,\n", tostring(options.floor.HideWhenMenuUnavailable)))
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
        io.write(string.format("        ShowInvMesetaAndItemCount = %s,\n", options.floor.ShowInvMesetaAndItemCount))
        io.write(string.format("        ShowMultiFloor = %s,\n", options.floor.ShowMultiFloor))
        io.write(string.format("        OtherFloorsBrightnessPercent = %i,\n", options.floor.OtherFloorsBrightnessPercent))
        io.write(string.format("        OtherFloorsPrependString = \"%s\",\n", options.floor.OtherFloorsPrependString))
        io.write(string.format("        EnableFilters = %s,\n", options.floor.EnableFilters))
        io.write(string.format("        filter = {\n"))
        io.write(string.format("            HitMin = %s,\n", options.floor.filter.HitMin))
        io.write(string.format("            HideLowHitWeapons = %s,\n", options.floor.filter.HideLowHitWeapons))
        io.write(string.format("            HideLowSocketArmor = %s,\n", options.floor.filter.HideLowSocketArmor))
        io.write(string.format("            HideUselessUnits = %s,\n", options.floor.filter.HideUselessUnits))
        io.write(string.format("            HideUselessTechs = %s,\n", options.floor.filter.HideUselessTechs))
        io.write(string.format("            HideMonomates = %s,\n", options.floor.filter.HideMonomates))
        io.write(string.format("            HideDimates = %s,\n", options.floor.filter.HideDimates))
        io.write(string.format("            HideTrimates = %s,\n", options.floor.filter.HideTrimates))
        io.write(string.format("            HideMonofluids = %s,\n", options.floor.filter.HideMonofluids))
        io.write(string.format("            HideDifluids = %s,\n", options.floor.filter.HideDifluids))
        io.write(string.format("            HideTrifluids = %s,\n", options.floor.filter.HideTrifluids))
        io.write(string.format("            HideSolAtomizers = %s,\n", options.floor.filter.HideSolAtomizers))
        io.write(string.format("            HideMoonAtomizers = %s,\n", options.floor.filter.HideMoonAtomizers))
        io.write(string.format("            HideStarAtomizers = %s,\n", options.floor.filter.HideStarAtomizers))
        io.write(string.format("            HideAntidotes = %s,\n", options.floor.filter.HideAntidotes))
        io.write(string.format("            HideAntiparalysis = %s,\n", options.floor.filter.HideAntiparalysis))
        io.write(string.format("            HideTelepipes = %s,\n", options.floor.filter.HideTelepipes))
        io.write(string.format("            HideTrapVisions = %s,\n", options.floor.filter.HideTrapVisions))
        io.write(string.format("            HideMonogrinders = %s,\n", options.floor.filter.HideMonogrinders))
        io.write(string.format("            HideDigrinders = %s,\n", options.floor.filter.HideDigrinders))
        io.write(string.format("            HideTrigrinders = %s,\n", options.floor.filter.HideTrigrinders))
        io.write(string.format("            HideHPMats = %s,\n", options.floor.filter.HideHPMats))
        io.write(string.format("            HidePowerMats = %s,\n", options.floor.filter.HidePowerMats))
        io.write(string.format("            HideLuckMats = %s,\n", options.floor.filter.HideLuckMats))
        io.write(string.format("            HideMindMats = %s,\n", options.floor.filter.HideMindMats))
        io.write(string.format("            HideDefenseMats = %s,\n", options.floor.filter.HideDefenseMats))
        io.write(string.format("            HideEvadeMats = %s,\n", options.floor.filter.HideEvadeMats))
        io.write(string.format("        },\n"))
        io.write(string.format("    },\n"))
        io.write(string.format("    mags = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.mags.EnableWindow)))
        io.write(string.format("        HideWhenMenu = %s,\n", tostring(options.mags.HideWhenMenu)))
        io.write(string.format("        HideWhenSymbolChat = %s,\n", tostring(options.mags.HideWhenSymbolChat)))
        io.write(string.format("        HideWhenMenuUnavailable = %s,\n", tostring(options.mags.HideWhenMenuUnavailable)))
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
        io.write(string.format("        printItemIndex = %s,\n", options.mags.printItemIndex))
        io.write(string.format("        showItemIDs = %s,\n", options.mags.showItemIDs))
        io.write(string.format("        showItemData = %s,\n", options.mags.showItemData))
        io.write(string.format("        showEquippedItems = %s,\n", options.mags.showEquippedItems))
        io.write(string.format("        hideMagStats = %s,\n", options.mags.hideMagStats))
        io.write(string.format("        hideMagPBs = %s,\n", options.mags.hideMagPBs))
        io.write(string.format("        hideMagColor = %s,\n", options.mags.hideMagColor))
        io.write(string.format("    },\n"))
        io.write("}\n")

        io.close(file)
    end
end

local overrideAlphaPercent = 1
local TextCCallback = nil

-- Wrapper function to simplify color changes.
local function TextCWrapper(newLine, col, fmt, ...)
    -- Update the color if one was specified here.
    col = col or 0xFFFFFFFF

    local rgb = bit.band(col, 0x00FFFFFF)
    local oldAlpha = bit.rshift(col, 24)
    local newAlpha = math.floor(oldAlpha * overrideAlphaPercent)
    col = bit.bor(bit.lshift(newAlpha, 24), rgb)

    return lib_helpers.TextC(newLine, col, fmt, ...)
end

-- Function to set or reset the overrideAlphaPercent for TextCWrapper.
local function SetTextCAlphaPercent(alphaOpt)
    if not alphaOpt then
        overrideAlphaPercent = 1 -- default
    elseif alphaOpt and alphaOpt >= 0 and alphaOpt <= 1 then
        overrideAlphaPercent = alphaOpt
    end
end

-- Provide a callback to call on the item before displaying anything on that line.
local function SetTextCPrependCallback(func)
    TextCCallback = func or nil
end

-- Clears the additional wrapper functionality.
local function ClearTextCOptions()
    SetTextCAlphaPercent()
    SetTextCPrependCallback()
end

-- Called to start the next line for an item. If a callback is provided, also calls it.
local function BeginImguiLineForItem(item)
    TextCWrapper(true, 0, "")
    if TextCCallback then
        TextCCallback(item)
    end
end

-- Callback for BeginImguiLineForItem() to add an indicator string at the beginning of a line.
local function PrependMultifloorStringToItem(item)
    local myFloor = lib_characters.GetCurrentFloorSelf()
    if (TextCWrapper and item and item.floorNumber and item.floorNumber ~= myFloor and
        options.floor.OtherFloorsPrependString and string.len(options.floor.OtherFloorsPrependString) > 0) then

        -- Handle '%' again if someone hasn't updated their plugin or if they manually edited options.lua.
        -- Check if we can use
        local canUseString = (pso.require_version ~= nil and pso.require_version(3, 6, 0))
        local str = options.floor.OtherFloorsPrependString
        if canUseString or string.match(str, "%%") == nil then
            -- Either plugin supports the string as-is or the string is sanitized already
            TextCWrapper(false, lib_items_cfg.white, "%s ", str)
        end
    end
end

local function TrimString(text, length)
    -- default to "???" to prevent crashing for techniques when doing Alt+Backspace
    text = text or "???"
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

local function writeArmorStats(item, floor)
    local result = ""

    result = result .. TextCWrapper(false, lib_items_cfg.white, "[")

    local statColor
    if item.armor.dfp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. TextCWrapper(false, statColor, "%i", item.armor.dfp)
    result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
    if item.armor.dfpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. TextCWrapper(false, statColor, "%i", item.armor.dfpMax)

    result = result .. TextCWrapper(false, lib_items_cfg.white, " | ")

    if item.armor.evp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. TextCWrapper(false, statColor, "%i", item.armor.evp)
    result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
    if item.armor.evpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    result = result .. TextCWrapper(false, statColor, "%i", item.armor.evpMax)
    result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")

    return result
end

local function ProcessWeapon(item, floor)
    local result = ""

    local nameColor = lib_items_cfg.weaponName
    local item_cfg = lib_items_list.t[item.hex]
    local show_item = true

    if item.weapon.isSRank == false then
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        elseif floor and options.floor.EnableFilters and options.floor.filter.HideLowHitWeapons then
            show_item = false
            -- Hide weapon drops with less then 40h untekked
            if item.weapon.stats[6] >= options.floor.filter.HitMin then
                show_item = true
            end
        end
    end

    if show_item then
        BeginImguiLineForItem(item)

        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        if options.showEquippedItems then
            if item.equipped then
                TextCWrapper(false, lib_items_cfg.white, "[")
                TextCWrapper(false, lib_items_cfg.itemEquipped, "E")
                TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        end

        if item.weapon.wrapped or item.weapon.untekked then
            result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
            if item.weapon.wrapped and item.weapon.untekked then
                result = result .. TextCWrapper(false, lib_items_cfg.weaponUntekked, "W|U")
            elseif item.weapon.wrapped then
                result = result .. TextCWrapper(false, lib_items_cfg.weaponUntekked, "W")
            elseif item.weapon.untekked then
                result = result .. TextCWrapper(false, lib_items_cfg.weaponUntekked, "U")
            end
            result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
        end

        if item.weapon.isSRank then
            result = result .. TextCWrapper(false, lib_items_cfg.weaponSRankTitle, "S-RANK ")
            result = result .. TextCWrapper(false, lib_items_cfg.weaponSRankName, "%s ", item.name)
            result = result .. TextCWrapper(false, lib_items_cfg.weaponSRankCustomName, "%s ", item.weapon.nameSrank)

            if item.weapon.grind > 0 then
                 result = result .. TextCWrapper(false, lib_items_cfg.weaponGrind, "+%i ", item.weapon.grind)
            end

            if item.weapon.specialSRank ~= 0 then
                result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
                result = result .. TextCWrapper(false, lib_items_cfg.weaponSRankSpecial[item.weapon.specialSRank], lib_unitxt.GetSRankSpecialName(item.weapon.specialSRank))
                result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        else
            result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

            if item.weapon.grind > 0 then
                result = result .. TextCWrapper(false, lib_items_cfg.weaponGrind, "+%i ", item.weapon.grind)
            end

            if item.weapon.special ~= 0 then
                result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
                result = result .. TextCWrapper(false, lib_items_cfg.weaponSpecial[item.weapon.special + 1], lib_unitxt.GetSpecialName(item.weapon.special))
                result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
            end

            result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
            for i=2,5,1 do
                local stat = item.weapon.stats[i]

                local statColor = lib_items_cfg.grey
                for i2=1,table.getn(lib_items_cfg.weaponAttributes),5 do
                    if stat <= lib_items_cfg.weaponAttributes[i2] then
                        statColor = lib_items_cfg.weaponAttributes[i2 + (i-1)]
                    end
                end
                if item.weapon.statpresence[i - 1] == 1 and item.weapon.stats[i] == 0 then
                    statColor = lib_items_cfg.red
                end

                result = result .. TextCWrapper(false, statColor, "%i", stat)

                if i < 5 then
                    result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
                else
                    result = result .. TextCWrapper(false, lib_items_cfg.white, "|")
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
            result = result .. TextCWrapper(false, statColor, "%i", stat)
            result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")

            if item.kills ~= 0 then
                result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
                result = result .. TextCWrapper(false, lib_items_cfg.weaponKills, "%iK", item.kills)
                result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        end
    end

    return result
end
local function ProcessFrame(item, floor)
    local result = ""

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    local show_item = true

    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    elseif floor and options.floor.EnableFilters and options.floor.filter.HideLowSocketArmor then
        show_item = false
        -- Show 4 socket armors
        if item.armor.slots == 4 then
            show_item = true
        end
    end

    if show_item then
        BeginImguiLineForItem(item)


        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        if options.showEquippedItems then
            if item.equipped then
                TextCWrapper(false, lib_items_cfg.white, "[")
                TextCWrapper(false, lib_items_cfg.itemEquipped, "E")
                TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        end

        result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
        result = result .. writeArmorStats(item)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
        result = result .. TextCWrapper(false, lib_items_cfg.armorSlots, "%iS", item.armor.slots)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
    end

    return result
end
local function ProcessBarrier(item, floor)
    local result = ""

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    local show_item = true

    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    elseif floor and options.floor.EnableFilters and options.floor.filter.HideLowSocketArmor then
        show_item = false
        -- No exceptions at the moment
    end

    if show_item then
        BeginImguiLineForItem(item)

        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        if options.showEquippedItems then
            if item.equipped then
                TextCWrapper(false, lib_items_cfg.white, "[")
                TextCWrapper(false, lib_items_cfg.itemEquipped, "E")
                TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        end

        result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
        result = result .. writeArmorStats(item)
    end

    return result
end
local function ProcessUnit(item, floor)
    local result = ""

    local nameColor = lib_items_cfg.unitName
    local item_cfg = lib_items_list.t[item.hex]
    local show_item = true

    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    elseif floor and options.floor.EnableFilters and options.floor.filter.HideUselessUnits then
        show_item = false
        -- No exceptions at the moment
    end

    if show_item then
        BeginImguiLineForItem(item)

        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        if options.showEquippedItems then
            if item.equipped then
                TextCWrapper(false, lib_items_cfg.white, "[")
                TextCWrapper(false, lib_items_cfg.itemEquipped, "E")
                TextCWrapper(false, lib_items_cfg.white, "] ")
            end
        end

        local nameStr = item.name

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

        result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(nameStr, options.itemNameLength))

        if item.kills ~= 0 then
            result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
            result = result .. TextCWrapper(false, lib_items_cfg.weaponKills, "%iK", item.kills)
            result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
        end
    end

    return result
end
local function ProcessMag(item, fromMagWindow)
    local result = ""
    BeginImguiLineForItem(item)

    if
        (not fromMagWindow and options.showItemIDs)
        or (fromMagWindow and options.mags.showItemIDs)
    then
        TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
    end

    if
        (not fromMagWindow and options.showItemData)
        or (fromMagWindow and options.mags.showItemData)
    then
        TextCWrapper(false, 0xFFFFFFFF,
            "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
            item.data[1], item.data[2], item.data[3], item.data[4],
            item.data[5], item.data[6], item.data[7], item.data[8],
            item.data[9], item.data[10], item.data[11], item.data[12],
            item.data[13], item.data[14], item.data[15], item.data[16])
    end

    if
        (not fromMagWindow and options.printItemIndex)
        or (fromMagWindow and options.mags.printItemIndex)
    then
        TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
    end

    if
        (not fromMagWindow and options.showEquippedItems)
        or (fromMagWindow and options.mags.showEquippedItems)
    then
        if item.equipped then
            TextCWrapper(false, lib_items_cfg.white, "[")
            TextCWrapper(false, lib_items_cfg.itemEquipped, "E")
            TextCWrapper(false, lib_items_cfg.white, "] ")
        end
    end

    local nameColor = lib_items_cfg.magName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))

    local timerColor = lib_items_cfg.white
    for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
        if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
            timerColor = lib_items_cfg.magFeedTimer[i + 1]
        end
    end

    TextCWrapper(false, lib_items_cfg.white, "[")
    TextCWrapper(false, timerColor, os.date("!%M:%S", item.mag.timer))
    TextCWrapper(false, lib_items_cfg.white, "] ")

    if
        (not fromMagWindow and not options.hideMagStats)
        or (fromMagWindow and not options.mags.hideMagStats)
    then
        result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
        result = result .. TextCWrapper(false, lib_items_cfg.magStats, "%.2f", item.mag.def)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
        result = result .. TextCWrapper(false, lib_items_cfg.magStats, "%.2f", item.mag.pow)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
        result = result .. TextCWrapper(false, lib_items_cfg.magStats, "%.2f", item.mag.dex)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "/")
        result = result .. TextCWrapper(false, lib_items_cfg.magStats, "%.2f", item.mag.mind)
        result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
    end

    if
        (not fromMagWindow and not options.hideMagPBs)
        or (fromMagWindow and not options.mags.hideMagPBs)
    then
        result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
        result = result .. TextCWrapper(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbL, options.shortPBNames))
        result = result .. TextCWrapper(false, lib_items_cfg.white, "|")
        result = result .. TextCWrapper(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbC, options.shortPBNames))
        result = result .. TextCWrapper(false, lib_items_cfg.white, "|")
        result = result .. TextCWrapper(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbR, options.shortPBNames))
        result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
    end

    if
        (not fromMagWindow and not options.hideMagColor)
        or (fromMagWindow and not options.mags.hideMagColor)
    then
        result = result .. TextCWrapper(false, lib_items_cfg.white, "[")
        result = result .. TextCWrapper(false, lib_items_cfg.magColor, lib_unitxt.GetMagColor(item.mag.color))
        result = result .. TextCWrapper(false, lib_items_cfg.white, "] ")
    end

    return result
end
local function ProcessTool(item, floor)
    local result = ""

    local nameColor
    local item_cfg = lib_items_list.t[item.hex]
    local show_item = true

    if item.data[2] == 2 then
        nameColor = lib_items_cfg.techName
    else
        nameColor = lib_items_cfg.toolName
    end

    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end

    if floor then
        -- Process Technique Disks
        if options.floor.EnableFilters and options.floor.filter.HideUselessTechs and item.data[2] == 0x02 then
            show_item = false
            -- Is Reverser/Ryuker
            if item.data[5] == 0x11 or item.data[5] == 0x0E then
                show_item = true
            -- Is Good Anti?
            elseif item.data[5] == 0x10 then
                if item.tool.level == 5 or item.tool.level >= 7 then
                    show_item = true
                end
            -- Is Good Megid/Grants
            elseif item.data[5] == 0x12 or item.data[5] == 0x09 then
                if item.tool.level >= 26 then
                    show_item = true
                end
            -- Is good support spell
            elseif item.data[5] == 0x0A or item.data[5] == 0x0B or item.data[5] == 0x0C or item.data[5] == 0x0D or item.data[5] == 0x0F then
                if item.tool.level == 15 or item.tool.level == 20 or item.tool.level >= 30 then
                    show_item = true
                end
            -- Is a max tier tech?
            elseif item.tool.level == 15 or item.tool.level == 20 or item.tool.level >= 29 then
                show_item = true
            end
        -- Hide Monomates, Dimates, Monofluids, Difluids, Antidotes, Antiparalysis, Telepipe, and Trap Visions
        elseif options.floor.EnableFilters and
                ((options.floor.filter.HideMonomates     and item.data[2] == 0x00 and item.data[3] == 0x00) or
                 (options.floor.filter.HideDimates       and item.data[2] == 0x00 and item.data[3] == 0x01) or
                 (options.floor.filter.HideTrimates      and item.data[2] == 0x00 and item.data[3] == 0x02) or
                 (options.floor.filter.HideMonofluids    and item.data[2] == 0x01 and item.data[3] == 0x00) or
                 (options.floor.filter.HideDifluids      and item.data[2] == 0x01 and item.data[3] == 0x01) or
                 (options.floor.filter.HideTrifluids     and item.data[2] == 0x01 and item.data[3] == 0x02) or
                 (options.floor.filter.HideSolAtomizers  and item.data[2] == 0x03 and item.data[3] == 0x00) or
                 (options.floor.filter.HideMoonAtomizers and item.data[2] == 0x04 and item.data[3] == 0x00) or
                 (options.floor.filter.HideStarAtomizers and item.data[2] == 0x05 and item.data[3] == 0x00) or
                 (options.floor.filter.HideAntidotes     and item.data[2] == 0x06 and item.data[3] == 0x00) or
                 (options.floor.filter.HideAntiparalysis and item.data[2] == 0x06 and item.data[3] == 0x01) or
                 (options.floor.filter.HideTelepipes     and item.data[2] == 0x07 and item.data[3] == 0x00) or
                 (options.floor.filter.HideTrapVisions   and item.data[2] == 0x08 and item.data[3] == 0x00) or
                 (options.floor.filter.HideMonogrinders  and item.data[2] == 0x0A and item.data[3] == 0x00) or
                 (options.floor.filter.HideDigrinders    and item.data[2] == 0x0A and item.data[3] == 0x01) or
                 (options.floor.filter.HideTrigrinders   and item.data[2] == 0x0A and item.data[3] == 0x02) or
                 (options.floor.filter.HidePowerMats     and item.data[2] == 0x0B and item.data[3] == 0x00) or
                 (options.floor.filter.HideMindMats      and item.data[2] == 0x0B and item.data[3] == 0x01) or
                 (options.floor.filter.HideEvadeMats     and item.data[2] == 0x0B and item.data[3] == 0x02) or
                 (options.floor.filter.HideHPMats        and item.data[2] == 0x0B and item.data[3] == 0x03) or
                 (options.floor.filter.HideDefenseMats   and item.data[2] == 0x0B and item.data[3] == 0x05) or
                 (options.floor.filter.HideLuckMats      and item.data[2] == 0x0B and item.data[3] == 0x06)) then
            show_item = false
        end
    end

    if show_item then
        BeginImguiLineForItem(item)

        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        if item.data[2] == 2 then
            result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
            result = result .. TextCWrapper(false, lib_items_cfg.techLevel, "Lv%i ", item.tool.level)
        else
            result = result .. TextCWrapper(false, nameColor, "%s ", TrimString(item.name, options.itemNameLength))
            if item.tool.count > 0 then
                result = result .. TextCWrapper(false, lib_items_cfg.toolAmount, "x%i ", item.tool.count)
            end
        end
    end

    return result
end
local function ProcessMeseta(item)
    local result = ""
    if options.showItemIDs == false and options.ignoreMeseta == false then
        BeginImguiLineForItem(item)

        if options.showItemIDs then
            TextCWrapper(false, 0xFFFFFFFF, "%08X ", item.id)
        end

        if options.showItemData then
            TextCWrapper(false, 0xFFFFFFFF,
                "[%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X,%02X%02X%02X%02X] ",
                item.data[1], item.data[2], item.data[3], item.data[4],
                item.data[5], item.data[6], item.data[7], item.data[8],
                item.data[9], item.data[10], item.data[11], item.data[12],
                item.data[13], item.data[14], item.data[15], item.data[16])
        end

        if options.printItemIndex then
            TextCWrapper(false, lib_items_cfg.itemIndex, "% 3i ", item.index)
        end

        result = result .. TextCWrapper(false, lib_items_cfg.mesetaName, "%s ", item.name)
        result = result .. TextCWrapper(false, lib_items_cfg.mesetaAmount, "%i ", item.meseta)
    end
    return result
end
local function ProcessItem(item, floor, save, fromMagWindow)
    floor = floor or false
    save = save or false
    fromMagWindow = fromMagWindow or false

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
        itemStr = ProcessWeapon(item, floor)
    elseif item.data[1] == 1 then
        if item.data[2] == 1 then
            itemStr = ProcessFrame(item, floor)
        elseif item.data[2] == 2 then
            itemStr = ProcessBarrier(item, floor)
        elseif item.data[2] == 3 then
            itemStr = ProcessUnit(item, floor)
        end
    elseif item.data[1] == 2 then
        itemStr = ProcessMag(item, fromMagWindow)
    elseif item.data[1] == 3 then
        itemStr = ProcessTool(item, floor)
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

local update_delay = (options.updateThrottle * 1000)
local current_time = 0
local last_inventory_index = -1
local last_inventory_time = 0
local cache_inventory = nil
local last_bank_time = 0
local cache_bank = nil
local last_floor_time = 0
local cache_floor = nil
local last_mags_time = 0
local cache_mags = nil

local function PresentInventory(save, index)
    ClearTextCOptions()
    index = index or lib_items.Me

    if last_inventory_time + update_delay < current_time or last_inventory_index ~= index or cache_inventory == nil then
        cache_inventory = lib_items.GetInventory(index)
        last_inventory_index = index
        last_inventory_time = current_time
    end

    local itemCount = table.getn(cache_inventory.items)
    TextCWrapper(false, lib_items_cfg.itemIndex, "Meseta: %i | Items: %i / 30", cache_inventory.meseta, itemCount)

    for i=1,itemCount,1 do
        ProcessItem(cache_inventory.items[i], false, save)
    end
end
local function PresentBank(save)
    ClearTextCOptions()
    if last_bank_time + update_delay < current_time or cache_bank == nil then
        cache_bank = lib_items.GetBank()
        last_bank_time = current_time
    end
    local itemCount = table.getn(cache_bank.items)

    TextCWrapper(false, lib_items_cfg.itemIndex, "Meseta: %i | Items: %i / 200", cache_bank.meseta, itemCount)

    for i=1,itemCount,1 do
        ProcessItem(cache_bank.items[i], false, save)
    end
end



local function PresentFloor()
    ClearTextCOptions()

    if options.floor.ShowMultiFloor then
        SetTextCPrependCallback(PrependMultifloorStringToItem)
    end

    if last_floor_time + update_delay < current_time or cache_floor == nil then
        if options.floor.ShowMultiFloor then
            cache_floor = lib_items.GetMultiFloorItemList(options.invertItemList)
        else
            cache_floor = lib_items.GetItemList(lib_items.NoOwner, options.invertItemList)
        end
        last_floor_time = current_time
    end
    local itemCount = table.getn(cache_floor)

    -- If user wants to display their meseta and inventory count, then go get the inventory cache.
    if options.floor.ShowInvMesetaAndItemCount then
        index = index or lib_items.Me
        if last_inventory_time + update_delay < current_time or last_inventory_index ~= index or cache_inventory == nil then
            cache_inventory = lib_items.GetInventory(index)
            last_inventory_index = index
            last_inventory_time = current_time
        end

        local invItemCount = table.getn(cache_inventory.items)
        TextCWrapper(false, lib_items_cfg.itemIndex, "Meseta: %i | Items: %i / 30", cache_inventory.meseta, invItemCount)
    end

    local myFloor = lib_characters.GetCurrentFloorSelf()

    for i=1,itemCount,1 do
        local item = cache_floor[i]
        -- If item isn't on the same floor, then it's from multifloor selection.
        if item.floorNumber and item.floorNumber ~= myFloor then
            SetTextCAlphaPercent(options.floor.OtherFloorsBrightnessPercent / 100)
        else
            SetTextCAlphaPercent()
        end
        ProcessItem(cache_floor[i], true, false)
    end
end
local function PresentMags()
    SetTextCAlphaPercent()
    if last_mags_time + update_delay < current_time or cache_mags == nil then
        cache_mags = lib_items.GetItemList(lib_items.Me, false)
        last_mags_time = current_time
    end
    local itemCount = table.getn(cache_mags)

    for i=1,itemCount,1 do
        if cache_mags[i].mag ~= nil then
            ProcessItem(cache_mags[i], false, false, true)
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
    if aioSelectedInventory == 1 then
        PresentInventory(save, lib_items.Me)
    elseif aioSelectedInventory == 2 then
        PresentBank(save)
    elseif aioSelectedInventory == 3 then
        PresentFloor()
    elseif aioSelectedInventory == 4 then
        PresentMags()
    else
        PresentInventory(save, aioSelectedInventory - 5)
    end
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
        -- Update the delay too
        update_delay = (options.updateThrottle * 1000)
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    --- Update timer for update throttle
    current_time = pso.get_tick_count()

    if (options.aio.EnableWindow == true)
        and (options.aio.HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
        and (options.aio.HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
        and (options.aio.HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
    then
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
    if (options.floor.EnableWindow == true)
        and (options.floor.HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
        and (options.floor.HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
        and (options.floor.HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
    then
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
    if (options.mags.EnableWindow == true)
        and (options.mags.HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
        and (options.mags.HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
        and (options.mags.HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
    then
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
