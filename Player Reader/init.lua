local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local cfg = require("Player Reader.configuration")
local optionsLoaded, options = pcall(require, "Player Reader.options")

local optionsFileName = "addons/Player Reader/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.fontScale                 = lib_helpers.NotNilOrDefault(options.fontScale, 1.0)

    options.playersEnableWindow          = lib_helpers.NotNilOrDefault(options.playersEnableWindow, true)
    options.playersChanged               = lib_helpers.NotNilOrDefault(options.playersChanged, false)
    options.playersAnchor                = lib_helpers.NotNilOrDefault(options.playersAnchor, 1)
    options.playersX                     = lib_helpers.NotNilOrDefault(options.playersX, 50)
    options.playersY                     = lib_helpers.NotNilOrDefault(options.playersY, 50)
    options.playersW                     = lib_helpers.NotNilOrDefault(options.playersW, 450)
    options.playersH                     = lib_helpers.NotNilOrDefault(options.playersH, 350)
    options.playersNoTitleBar            = lib_helpers.NotNilOrDefault(options.playersNoTitleBar, "")
    options.playersNoResize              = lib_helpers.NotNilOrDefault(options.playersNoResize, "")
    options.playersNoMove                = lib_helpers.NotNilOrDefault(options.playersNoMove, "")
    options.playersTransparentWindow     = lib_helpers.NotNilOrDefault(options.playersTransparentWindow, false)

    options.p1EnableWindow          = lib_helpers.NotNilOrDefault(options.p1EnableWindow, true)
    options.p1Changed               = lib_helpers.NotNilOrDefault(options.p1Changed, false)
    options.p1Anchor                = lib_helpers.NotNilOrDefault(options.p1Anchor, 1)
    options.p1X                     = lib_helpers.NotNilOrDefault(options.p1X, 250)
    options.p1Y                     = lib_helpers.NotNilOrDefault(options.p1Y, 30)
    options.p1W                     = lib_helpers.NotNilOrDefault(options.p1W, 150)
    options.p1H                     = lib_helpers.NotNilOrDefault(options.p1H, 45)
    options.p1NoTitleBar            = lib_helpers.NotNilOrDefault(options.p1NoTitleBar, "NoTitleBar")
    options.p1NoResize              = lib_helpers.NotNilOrDefault(options.p1NoResize, "NoResize")
    options.p1NoMove                = lib_helpers.NotNilOrDefault(options.p1NoMove, "NoMove")
    options.p1NoScrollbar           = lib_helpers.NotNilOrDefault(options.p1NoScrollbar, "NoScrollbar")
    options.p1TransparentWindow     = lib_helpers.NotNilOrDefault(options.p1TransparentWindow, true)
    options.p1SD                    = lib_helpers.NotNilOrDefault(options.p1SD, true)

else
    options = 
    {
        configurationEnableWindow = true,
        enable = true,
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
        playersNoMove = "",
        playersTransparentWindow = false,

        p1EnableWindow = true,
        p1Changed = false,
        p1Anchor = 1,
        p1X = 250,
        p1Y = 30,
        p1W = 150,
        p1H = 45,
        p1NoTitleBar = "NoTitleBar",
        p1NoResize = "NoResize",
        p1NoMove = "NoMove",
        p1NoScrollbar = "NoScrollbar",
        p1TransparentWindow = true,
        p1SD = true,
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
        io.write(string.format("    playersNoMove = \"%s\",\n", options.playersNoMove))
        io.write(string.format("    playersTransparentWindow = %s,\n", tostring(options.playersTransparentWindow)))
        io.write("\n")
        io.write(string.format("    p1EnableWindow = %s,\n", tostring(options.p1EnableWindow)))
        io.write(string.format("    p1Changed = %s,\n", tostring(options.p1Changed)))
        io.write(string.format("    p1Anchor = %i,\n", options.p1Anchor))
        io.write(string.format("    p1X = %i,\n", options.p1X))
        io.write(string.format("    p1Y = %i,\n", options.p1Y))
        io.write(string.format("    p1W = %i,\n", options.p1W))
        io.write(string.format("    p1H = %i,\n", options.p1H))
        io.write(string.format("    p1NoTitleBar = \"%s\",\n", options.p1NoTitleBar))
        io.write(string.format("    p1NoResize = \"%s\",\n", options.p1NoResize))
        io.write(string.format("    p1NoMove = \"%s\",\n", options.p1NoMove))
        io.write(string.format("    p1NoScrollbar = \"%s\",\n", options.p1NoScrollbar))
        io.write(string.format("    p1TransparentWindow = %s,\n", tostring(options.p1TransparentWindow)))
        io.write(string.format("    p1SD = %s,\n", tostring(options.p1SD)))
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

        local name = string.gsub(lib_characters.GetPlayerName(address), "%%", "%%%%")
        local hp = lib_characters.GetPlayerHP(address)
        local mhp = lib_characters.GetPlayerMaxHP(address)
        local hpColor = lib_helpers.HPToGreenRedGradient(hp/mhp)
        local atkTech = lib_characters.GetPlayerTechStatus(address, 0)
        local defTech = lib_characters.GetPlayerTechStatus(address, 1)

        lib_helpers.Text(true, "%2i", index)
        imgui.NextColumn()
        lib_helpers.Text(true, name)
        imgui.NextColumn()
        lib_helpers.imguiProgressBar(true, hp/mhp, -1.0, 13.0 * options.fontScale, hp, lib_helpers.HPToGreenRedGradient(hp/mhp))
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

local function PresentPlayer(index)
    local address = lib_characters.GetPlayer(index)

    if address == 0 then
        return
    end

    local atkTech = lib_characters.GetPlayerTechStatus(address, 0)
    local defTech = lib_characters.GetPlayerTechStatus(address, 1)

    if options.p1SD == true then
        if atkTech.type == 0 then
            lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %i: %s", atkTech.name, atkTech.level, os.date("!%M:%S", atkTech.time))
        end
        if defTech.type == 0 then
            lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %i: %s", defTech.name, defTech.level, os.date("!%M:%S", defTech.time))
        end
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

    if options.playersEnableWindow then
        if firstPresent or options.playersChanged then
            options.playersChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.playersX, options.playersY, options.playersW, options.playersH, options.playersAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.playersW, options.playersH, "Always");
        end

        if imgui.Begin("Player Reader - Players", nil, { options.playersNoTitleBar, options.playersNoResize, options.playersNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentPlayers()
        end
        imgui.End()
    end

    if options.p1EnableWindow then
        if firstPresent or options.p1Changed then
            options.p1Changed = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.p1X, options.p1Y, options.p1W, options.p1H, options.p1Anchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.p1W, options.p1H, "Always");
        end

        if options.p1TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Player Reader - Player 1", nil, { options.p1NoTitleBar, options.p1NoResize, options.p1NoMove, options.p1NoScrollbar }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentPlayer(0)
        end

        imgui.End()

        if options.p1TransparentWindow == true then
            imgui.PopStyleColor()
        end
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
        version = "1.0.3",
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
