local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_theme = require("solylib.theme")
local lib_characters = require("solylib.characters")
local cfg = require("Player Reader.configuration")
local optionsLoaded, options = pcall(require, "Player Reader.options")

local optionsFileName = "addons/Player Reader/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = options.configurationEnableWindow == nil and true or options.configurationEnableWindow
    options.enable = options.enable == nil and true or options.enable
    options.useCustomTheme = options.useCustomTheme == nil and true or options.useCustomTheme
    options.fontScale = options.fontScale or 1.0

    options.playersEnableWindow = options.playersEnableWindow == nil and true or options.playersEnableWindow
    options.playersChanged = options.playersChanged == nil and true or options.playersChanged
    options.playersAnchor = options.playersAnchor or 1
    options.playersX = options.playersX or 50
    options.playersY = options.playersY or 50
    options.playersW = options.playersW or 450
    options.playersH = options.playersH or 350
    options.playersNoTitleBar = options.playersNoTitleBar or ""
    options.playersNoResize = options.playersNoResize or ""
else
    options = 
    {
        configurationEnableWindow = true,
        enable = true,
        useCustomTheme = false,
        fontScale = 1.0,

        playersEnableWindow = true,
        playersChanged = false,
        playersAnchor = 1,
        playersX = 50,
        playersY = 50,
        playersW = 450,
        playersH = 350,
        playersNoTitleBar = "",
        playersNoResize = "",
    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return {\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    useCustomTheme = %s,\n", tostring(options.enable)))
        io.write(string.format("    fontScale = %s,\n", tostring(options.fontScale)))
        io.write("\n")
        io.write(string.format("    playersEnableWindow = %s,\n", tostring(options.playersEnableWindow)))
        io.write(string.format("    playersChanged = %s,\n", tostring(options.playersChanged)))
        io.write(string.format("    playersAnchor = %i,\n", options.playersAnchor))
        io.write(string.format("    playersX = %i,\n", options.playersX))
        io.write(string.format("    playersY = %i,\n", options.playersY))
        io.write(string.format("    playersW = %i,\n", options.playersW))
        io.write(string.format("    playersH = %i,\n", options.playersH))
        io.write(string.format("    playersNoTitleBar = \"%s\",\n", options.playersNoTitleBar))
        io.write(string.format("    playersNoResize = \"%s\",\n", options.playersNoResize))
        io.write("}\n")

        io.close(file)
    end
end

local function PresentPlayers()
    local playerList = lib_characters.GetPlayerList()
    local playerListCount = table.getn(playerList)

    imgui.Columns(4)

    for i=1,playerListCount,1 do
        local index = playerList[i].index
        local address = playerList[i].address

        local name = lib_characters.GetPlayerName(address)
        local hp = lib_characters.GetPlayerHP(address)
        local mhp = lib_characters.GetPlayerMaxHP(address)
        local hpColor = lib_helpers.HPToGreenRedGradient(hp/mhp)
        local atkTech = lib_characters.GetPlayerTechStatus(address, 0)
        local defTech = lib_characters.GetPlayerTechStatus(address, 1)

        lib_helpers.Text(true, "%2i", index)
        imgui.NextColumn()
        lib_helpers.Text(true, name)
        imgui.NextColumn()
        lib_helpers.imguiProgressBar(hp/mhp, -1.0, 13.0 * options.fontScale, hp, lib_helpers.HPToGreenRedGradient(hp/mhp), cfg.fontColor, true)
        imgui.NextColumn()
        if atkTech.type == 0 then
            lib_helpers.Text(true, "---")
        else
            lib_helpers.Text(true, "%s %i: %s", atkTech.name, atkTech.level, os.date("!%M:%S", atkTech.time))
        end
        if defTech.type == 0 then
            lib_helpers.Text(true, "---")
        else
            lib_helpers.Text(true, "%s %i: %s", defTech.name, defTech.level, os.date("!%M:%S", defTech.time))
        end
        imgui.NextColumn()
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
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    -- Push custom theme, only if enabled
    if options.useCustomTheme then
        lib_theme.Push()
    end

    if options.playersEnableWindow then
        if firstPresent or options.playersChanged then
            options.playersChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.playersX, options.playersY, options.playersW, options.playersH, options.playersAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.playersW, options.playersH, "Always");
        end

        if imgui.Begin("Player Reader - Players", nil, { options.playersNoTitleBar, options.playersNoResize }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentPlayers()
        end
        imgui.End()
    end

    -- Pop custom theme, only if enabled
    if options.useCustomTheme then
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

    core_mainmenu.add_button("Player Reader", mainMenuButtonHandler)

    return
    {
        name = "Players",
        version = "1.0.2",
        author = "Solybum",
        description = "Information about players in a lobby",
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
