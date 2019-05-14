local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_menu = require("solylib.menu")
local lib_items = require("solylib.items.items")
local cfg = require("Scape Reader.configuration")
local optionsLoaded, options = pcall(require, "Scape Reader.options")

local optionsFileName = "addons/Scape Reader/options.lua"
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.EnableWindow = lib_helpers.NotNilOrDefault(options.EnableWindow, true)
    options.HideWhenMenu = lib_helpers.NotNilOrDefault(options.HideWhenMenu, true)
    options.HideWhenSymbolChat = lib_helpers.NotNilOrDefault(options.HideWhenSymbolChat, true)
    options.HideWhenMenuUnavailable = lib_helpers.NotNilOrDefault(options.HideWhenMenuUnavailable, true)
    options.changed = lib_helpers.NotNilOrDefault(options.changed, true)
    options.Anchor = lib_helpers.NotNilOrDefault(options.Anchor, 1)
    options.X = lib_helpers.NotNilOrDefault(options.X, 50)
    options.Y = lib_helpers.NotNilOrDefault(options.Y, 50)
    options.W = lib_helpers.NotNilOrDefault(options.W, 450)
    options.H = lib_helpers.NotNilOrDefault(options.H, 350)
    options.NoTitleBar = lib_helpers.NotNilOrDefault(options.NoTitleBar, "")
    options.NoResize = lib_helpers.NotNilOrDefault(options.NoResize, "")
    options.NoMove = lib_helpers.NotNilOrDefault(options.NoMove, "")
    options.TransparentWindow = lib_helpers.NotNilOrDefault(options.TransparentWindow, false)
else
    options =
    {
        configurationEnableWindow = true,
        EnableWindow = true,
        HideWhenMenu = false,
        HideWhenSymbolChat = false,
        HideWhenMenuUnavailable = false,
        changed = true,
        Anchor = 1,
        X = 50,
        Y = 50,
        W = 110,
        H = 60,
        NoTitleBar = "",
        NoResize = "",
        NoMove = "",
        AlwaysAutoResize = "",
        TransparentWindow = false,
    }
end


local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    EnableWindow = %s,\n", tostring(options.EnableWindow)))
        io.write(string.format("    ScapeCountLow = %i,\n", options.ScapeCountLow))
        io.write(string.format("    ScapeCountHigh = %i,\n", options.ScapeCountHigh))
        io.write(string.format("    HideWhenMenu = %s,\n", tostring(options.HideWhenMenu)))
        io.write(string.format("    HideWhenSymbolChat = %s,\n", tostring(options.HideWhenSymbolChat)))
        io.write(string.format("    HideWhenMenuUnavailable = %s,\n", tostring(options.HideWhenMenuUnavailable)))
        io.write(string.format("    Anchor = %i,\n", options.Anchor))
        io.write(string.format("    X = %i,\n", options.X))
        io.write(string.format("    Y = %i,\n", options.Y))
        io.write(string.format("    W = %i,\n", options.W))
        io.write(string.format("    H = %i,\n", options.H))
        io.write(string.format("    NoTitleBar = \"%s\",\n", options.NoTitleBar))
        io.write(string.format("    NoResize = \"%s\",\n", options.NoResize))
        io.write(string.format("    NoMove = \"%s\",\n", options.NoMove))
        io.write(string.format("    AlwaysAutoResize = \"%s\",\n", options.AlwaysAutoResize))
        io.write(string.format("    TransparentWindow = %s,\n", options.TransparentWindow))
        io.write("}\n")

        io.close(file)
    end
end

local function isScapeDoll(item)
    if item.data[1] == 3 and item.hex == 0x030900 then
        return true
    end
    return false
end

local function PresentScapes()
    local itemList = lib_items.GetItemList(lib_items.Me, false)
    local itemCount = table.getn(itemList)
    local scapes = 0
    for i = 1, itemCount, 1 do
        if isScapeDoll(itemList[i]) then
            scapes = scapes + 1
        end
    end
    local color = 0xFF00F714
    if scapes <= options.ScapeCountLow then
        color = 0xFFFF0000
    elseif scapes < options.ScapeCountHigh then
        color = 0xFFFFAA00
    end
    lib_helpers.TextC(false, color, "%i %s", scapes, "Scape Dolls")
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

    if (options.EnableWindow == true)
            and (options.HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
            and (options.HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
            and (options.HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false) then
        local windowName = "Scape Reader"

        if options.TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end


        if options.AlwaysAutoResize == "AlwaysAutoResize" then
            imgui.SetNextWindowSizeConstraints(0, 0, options.W, options.H)
        end

        if imgui.Begin(windowName,
            nil,
            {
                options.NoTitleBar,
                options.NoResize,
                options.NoMove,
                options.AlwaysAutoResize,
            }) then
            PresentScapes()

            lib_helpers.WindowPositionAndSize(windowName,
                options.X,
                options.Y,
                options.W,
                options.H,
                options.Anchor,
                options.AlwaysAutoResize,
                options.changed)
        end
        imgui.End()

        if options.TransparentWindow == true then
            imgui.PopStyleColor()
        end

        options.changed = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Scape Reader", mainMenuButtonHandler)

    return
    {
        name = "Scape Reader",
        version = "1.0.0",
        author = "MarcherTech",
        description = "Scape Doll Count",
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
