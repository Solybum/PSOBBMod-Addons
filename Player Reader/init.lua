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

    options.p2EnableWindow          = lib_helpers.NotNilOrDefault(options.p2EnableWindow, true)
    options.p2Changed               = lib_helpers.NotNilOrDefault(options.p2Changed, false)
    options.p2Anchor                = lib_helpers.NotNilOrDefault(options.p2Anchor, 1)
    options.p2X                     = lib_helpers.NotNilOrDefault(options.p2X, 250)
    options.p2Y                     = lib_helpers.NotNilOrDefault(options.p2Y, 30)
    options.p2W                     = lib_helpers.NotNilOrDefault(options.p2W, 150)
    options.p2H                     = lib_helpers.NotNilOrDefault(options.p2H, 45)
    options.p2NoTitleBar            = lib_helpers.NotNilOrDefault(options.p2NoTitleBar, "NoTitleBar")
    options.p2NoResize              = lib_helpers.NotNilOrDefault(options.p2NoResize, "NoResize")
    options.p2NoMove                = lib_helpers.NotNilOrDefault(options.p2NoMove, "NoMove")
    options.p2NoScrollbar           = lib_helpers.NotNilOrDefault(options.p2NoScrollbar, "NoScrollbar")
    options.p2TransparentWindow     = lib_helpers.NotNilOrDefault(options.p2TransparentWindow, true)
    options.p2SD                    = lib_helpers.NotNilOrDefault(options.p2SD, true)

    options.p3EnableWindow          = lib_helpers.NotNilOrDefault(options.p3EnableWindow, true)
    options.p3Changed               = lib_helpers.NotNilOrDefault(options.p3Changed, false)
    options.p3Anchor                = lib_helpers.NotNilOrDefault(options.p3Anchor, 1)
    options.p3X                     = lib_helpers.NotNilOrDefault(options.p3X, 250)
    options.p3Y                     = lib_helpers.NotNilOrDefault(options.p3Y, 30)
    options.p3W                     = lib_helpers.NotNilOrDefault(options.p3W, 150)
    options.p3H                     = lib_helpers.NotNilOrDefault(options.p3H, 45)
    options.p3NoTitleBar            = lib_helpers.NotNilOrDefault(options.p3NoTitleBar, "NoTitleBar")
    options.p3NoResize              = lib_helpers.NotNilOrDefault(options.p3NoResize, "NoResize")
    options.p3NoMove                = lib_helpers.NotNilOrDefault(options.p3NoMove, "NoMove")
    options.p3NoScrollbar           = lib_helpers.NotNilOrDefault(options.p3NoScrollbar, "NoScrollbar")
    options.p3TransparentWindow     = lib_helpers.NotNilOrDefault(options.p3TransparentWindow, true)
    options.p3SD                    = lib_helpers.NotNilOrDefault(options.p3SD, true)

    options.p4EnableWindow          = lib_helpers.NotNilOrDefault(options.p4EnableWindow, true)
    options.p4Changed               = lib_helpers.NotNilOrDefault(options.p4Changed, false)
    options.p4Anchor                = lib_helpers.NotNilOrDefault(options.p4Anchor, 1)
    options.p4X                     = lib_helpers.NotNilOrDefault(options.p4X, 250)
    options.p4Y                     = lib_helpers.NotNilOrDefault(options.p4Y, 30)
    options.p4W                     = lib_helpers.NotNilOrDefault(options.p4W, 150)
    options.p4H                     = lib_helpers.NotNilOrDefault(options.p4H, 45)
    options.p4NoTitleBar            = lib_helpers.NotNilOrDefault(options.p4NoTitleBar, "NoTitleBar")
    options.p4NoResize              = lib_helpers.NotNilOrDefault(options.p4NoResize, "NoResize")
    options.p4NoMove                = lib_helpers.NotNilOrDefault(options.p4NoMove, "NoMove")
    options.p4NoScrollbar           = lib_helpers.NotNilOrDefault(options.p4NoScrollbar, "NoScrollbar")
    options.p4TransparentWindow     = lib_helpers.NotNilOrDefault(options.p4TransparentWindow, true)
    options.p4SD                    = lib_helpers.NotNilOrDefault(options.p4SD, true)

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
        p1Anchor = 3,
        p1X = 5,
        p1Y = -5,
        p1W = 150,
        p1H = 80,
        p1NoTitleBar = "NoTitleBar",
        p1NoResize = "NoResize",
        p1NoMove = "NoMove",
        p1NoScrollbar = "NoScrollbar",
        p1TransparentWindow = false,
        p1SD = true,

        p2EnableWindow = true,
        p2Changed = false,
        p2Anchor = 3,
        p2X = 160,
        p2Y = -5,
        p2W = 150,
        p2H = 80,
        p2NoTitleBar = "NoTitleBar",
        p2NoResize = "NoResize",
        p2NoMove = "NoMove",
        p2NoScrollbar = "NoScrollbar",
        p2TransparentWindow = false,
        p2SD = true,

        p3EnableWindow = true,
        p3Changed = false,
        p3Anchor = 3,
        p3X = 315,
        p3Y = -5,
        p3W = 150,
        p3H = 80,
        p3NoTitleBar = "NoTitleBar",
        p3NoResize = "NoResize",
        p3NoMove = "NoMove",
        p3NoScrollbar = "NoScrollbar",
        p3TransparentWindow = false,
        p3SD = true,

        p4EnableWindow = true,
        p4Changed = true,
        p4Anchor = 3,
        p4X = 470,
        p4Y = -5,
        p4W = 150,
        p4H = 80,
        p4NoTitleBar = "NoTitleBar",
        p4NoResize = "NoResize",
        p4NoMove = "NoMove",
        p4NoScrollbar = "NoScrollbar",
        p4TransparentWindow = false,
        p4SD = true,
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
        io.write("\n")
        io.write(string.format("    p2EnableWindow = %s,\n", tostring(options.p2EnableWindow)))
        io.write(string.format("    p2Changed = %s,\n", tostring(options.p2Changed)))
        io.write(string.format("    p2Anchor = %i,\n", options.p2Anchor))
        io.write(string.format("    p2X = %i,\n", options.p2X))
        io.write(string.format("    p2Y = %i,\n", options.p2Y))
        io.write(string.format("    p2W = %i,\n", options.p2W))
        io.write(string.format("    p2H = %i,\n", options.p2H))
        io.write(string.format("    p2NoTitleBar = \"%s\",\n", options.p2NoTitleBar))
        io.write(string.format("    p2NoResize = \"%s\",\n", options.p2NoResize))
        io.write(string.format("    p2NoMove = \"%s\",\n", options.p2NoMove))
        io.write(string.format("    p2NoScrollbar = \"%s\",\n", options.p2NoScrollbar))
        io.write(string.format("    p2TransparentWindow = %s,\n", tostring(options.p2TransparentWindow)))
        io.write(string.format("    p2SD = %s,\n", tostring(options.p2SD)))
        io.write("\n")
        io.write(string.format("    p3EnableWindow = %s,\n", tostring(options.p3EnableWindow)))
        io.write(string.format("    p3Changed = %s,\n", tostring(options.p3Changed)))
        io.write(string.format("    p3Anchor = %i,\n", options.p3Anchor))
        io.write(string.format("    p3X = %i,\n", options.p3X))
        io.write(string.format("    p3Y = %i,\n", options.p3Y))
        io.write(string.format("    p3W = %i,\n", options.p3W))
        io.write(string.format("    p3H = %i,\n", options.p3H))
        io.write(string.format("    p3NoTitleBar = \"%s\",\n", options.p3NoTitleBar))
        io.write(string.format("    p3NoResize = \"%s\",\n", options.p3NoResize))
        io.write(string.format("    p3NoMove = \"%s\",\n", options.p3NoMove))
        io.write(string.format("    p3NoScrollbar = \"%s\",\n", options.p3NoScrollbar))
        io.write(string.format("    p3TransparentWindow = %s,\n", tostring(options.p3TransparentWindow)))
        io.write(string.format("    p3SD = %s,\n", tostring(options.p3SD)))
        io.write("\n")
        io.write(string.format("    p4EnableWindow = %s,\n", tostring(options.p4EnableWindow)))
        io.write(string.format("    p4Changed = %s,\n", tostring(options.p4Changed)))
        io.write(string.format("    p4Anchor = %i,\n", options.p4Anchor))
        io.write(string.format("    p4X = %i,\n", options.p4X))
        io.write(string.format("    p4Y = %i,\n", options.p4Y))
        io.write(string.format("    p4W = %i,\n", options.p4W))
        io.write(string.format("    p4H = %i,\n", options.p4H))
        io.write(string.format("    p4NoTitleBar = \"%s\",\n", options.p4NoTitleBar))
        io.write(string.format("    p4NoResize = \"%s\",\n", options.p4NoResize))
        io.write(string.format("    p4NoMove = \"%s\",\n", options.p4NoMove))
        io.write(string.format("    p4NoScrollbar = \"%s\",\n", options.p4NoScrollbar))
        io.write(string.format("    p4TransparentWindow = %s,\n", tostring(options.p4TransparentWindow)))
        io.write(string.format("    p4SD = %s,\n", tostring(options.p4SD)))
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
        lib_helpers.imguiProgressBar(true, hp/mhp, -1.0, 13.0 * options.fontScale, hpColor, nil, hp)
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

local function PresentPlayer(address)
    if address == 0 then
        return
    end

    local name = string.gsub(lib_characters.GetPlayerName(address), "%%", "%%%%")
    local level = lib_characters.GetPlayerLevel(address)
    local hp = lib_characters.GetPlayerHP(address)
    local mhp = lib_characters.GetPlayerMaxHP(address)
    local tp = lib_characters.GetPlayerTP(address)
    local mtp = lib_characters.GetPlayerMaxTP(address)
    local atkTech = lib_characters.GetPlayerTechStatus(address, 0)
    local defTech = lib_characters.GetPlayerTechStatus(address, 1)

    local hpColor = lib_helpers.HPToGreenRedGradient(hp/mhp)
    local tpColor = lib_helpers.HPToGreenRedGradient(tp/mtp)

    hpColor = 0xFF00F714
    if (hp/mhp) < 0.2 then
        hpColor = 0xFFEAF718
    end

    tpColor = 0xFF0088F4
    if (tp/mtp) < 0.2 then
        tpColor = 0xFFF7BB13
    end

    lib_helpers.Text(true, "%s Lv%d", name, level)
    lib_helpers.imguiProgressBar(true, hp/mhp, -1.0, 5.0 * options.fontScale, hpColor, nil, "\0%d/%d", hp, mhp)
    lib_helpers.imguiProgressBar(true, tp/mtp, -1.0, 5.0 * options.fontScale, tpColor, nil, "\0%d/%d", tp, mtp)

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

        if options.playersTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Player Reader - Players", nil, { options.playersNoTitleBar, options.playersNoResize, options.playersNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentPlayers()
        end
        imgui.End()

        if options.playersTransparentWindow == true then
            imgui.PopStyleColor()
        end
    end

    local playerIsInDedicatedLobby = true

    if playerIsInDedicatedLobby then
        if options.p1EnableWindow then
            local address = lib_characters.GetPlayer(0)
            if address ~= 0 then
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
                    PresentPlayer(address)
                end
                imgui.End()

                if options.p1TransparentWindow == true then
                    imgui.PopStyleColor()
                end
            end
        end

        if options.p2EnableWindow then
            local address = lib_characters.GetPlayer(1)
            if address ~= 0 then
                if firstPresent or options.p2Changed then
                    options.p2Changed = false
                    local ps = lib_helpers.GetPosBySizeAndAnchor(options.p2X, options.p2Y, options.p2W, options.p2H, options.p2Anchor)
                    imgui.SetNextWindowPos(ps[1], ps[2], "Always");
                    imgui.SetNextWindowSize(options.p2W, options.p2H, "Always");
                end

                if options.p2TransparentWindow == true then
                    imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
                end

                if imgui.Begin("Player Reader - Player 2", nil, { options.p2NoTitleBar, options.p2NoResize, options.p2NoMove, options.p2NoScrollbar }) then
                    imgui.SetWindowFontScale(options.fontScale)
                    PresentPlayer(address)
                end
                imgui.End()

                if options.p2TransparentWindow == true then
                    imgui.PopStyleColor()
                end
            end
        end

        if options.p3EnableWindow then
            local address = lib_characters.GetPlayer(2)
            if address ~= 0 then
                if firstPresent or options.p3Changed then
                    options.p3Changed = false
                    local ps = lib_helpers.GetPosBySizeAndAnchor(options.p3X, options.p3Y, options.p3W, options.p3H, options.p3Anchor)
                    imgui.SetNextWindowPos(ps[1], ps[2], "Always");
                    imgui.SetNextWindowSize(options.p3W, options.p3H, "Always");
                end

                if options.p3TransparentWindow == true then
                    imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
                end

                if imgui.Begin("Player Reader - Player 3", nil, { options.p3NoTitleBar, options.p3NoResize, options.p3NoMove, options.p3NoScrollbar }) then
                    imgui.SetWindowFontScale(options.fontScale)
                    PresentPlayer(address)
                end
                imgui.End()

                if options.p3TransparentWindow == true then
                    imgui.PopStyleColor()
                end
            end
        end

        if options.p4EnableWindow then
            local address = lib_characters.GetPlayer(3)
            if address ~= 0 then
                if firstPresent or options.p4Changed then
                    options.p4Changed = false
                    local ps = lib_helpers.GetPosBySizeAndAnchor(options.p4X, options.p4Y, options.p4W, options.p4H, options.p4Anchor)
                    imgui.SetNextWindowPos(ps[1], ps[2], "Always");
                    imgui.SetNextWindowSize(options.p4W, options.p4H, "Always");
                end

                if options.p4TransparentWindow == true then
                    imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
                end

                if imgui.Begin("Player Reader - Player 4", nil, { options.p4NoTitleBar, options.p4NoResize, options.p4NoMove, options.p4NoScrollbar }) then
                    imgui.SetWindowFontScale(options.fontScale)
                    PresentPlayer(address)
                end
                imgui.End()

                if options.p4TransparentWindow == true then
                    imgui.PopStyleColor()
                end
            end
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
