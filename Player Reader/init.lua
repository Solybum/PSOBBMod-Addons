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
    if options == nil or type(options) ~= "table" then
        options = {}
    end


    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.fontScale                 = lib_helpers.NotNilOrDefault(options.fontScale, 1.0)

    options.allPlayersEnableWindow          = lib_helpers.NotNilOrDefault(options.allPlayersEnableWindow, true)
    options.allPlayersChanged               = lib_helpers.NotNilOrDefault(options.allPlayersChanged, false)
    options.allPlayersAnchor                = lib_helpers.NotNilOrDefault(options.allPlayersAnchor, 1)
    options.allPlayersX                     = lib_helpers.NotNilOrDefault(options.allPlayersX, 50)
    options.allPlayersY                     = lib_helpers.NotNilOrDefault(options.allPlayersY, 50)
    options.allPlayersW                     = lib_helpers.NotNilOrDefault(options.allPlayersW, 450)
    options.allPlayersH                     = lib_helpers.NotNilOrDefault(options.allPlayersH, 350)
    options.allPlayersNoTitleBar            = lib_helpers.NotNilOrDefault(options.allPlayersNoTitleBar, "")
    options.allPlayersNoResize              = lib_helpers.NotNilOrDefault(options.allPlayersNoResize, "")
    options.allPlayersNoMove                = lib_helpers.NotNilOrDefault(options.allPlayersNoMove, "")
    options.allPlayersTransparentWindow     = lib_helpers.NotNilOrDefault(options.allPlayersTransparentWindow, false)

    options.singlePlayersEnableWindow     = lib_helpers.NotNilOrDefault(options.singlePlayersEnableWindow, true)
    options.singlePlayersShowBarText      = lib_helpers.NotNilOrDefault(options.singlePlayersShowBarText, true)
    options.singlePlayersShowBarMaxValue  = lib_helpers.NotNilOrDefault(options.singlePlayersShowBarMaxValue, true)

    if options.players == nil or type(options.players) ~= "table" then
        options.players = {}
    end

    for i=1,4,1 do
        if options.players[i] == nil or type(options.players[i]) ~= "table" then
            options.players[i] = {}
        end

        options.players[i].EnableWindow          = lib_helpers.NotNilOrDefault(options.players[i].EnableWindow, true)
        options.players[i].Changed               = lib_helpers.NotNilOrDefault(options.players[i].Changed, false)
        options.players[i].Anchor                = lib_helpers.NotNilOrDefault(options.players[i].Anchor, 3)
        options.players[i].X                     = lib_helpers.NotNilOrDefault(options.players[i].X, (5 * 1) + (150 * (i - 1)))
        options.players[i].Y                     = lib_helpers.NotNilOrDefault(options.players[i].Y, -5)
        options.players[i].W                     = lib_helpers.NotNilOrDefault(options.players[i].W, 150)
        options.players[i].H                     = lib_helpers.NotNilOrDefault(options.players[i].H, 45)
        options.players[i].NoTitleBar            = lib_helpers.NotNilOrDefault(options.players[i].NoTitleBar, "NoTitleBar")
        options.players[i].NoResize              = lib_helpers.NotNilOrDefault(options.players[i].NoResize, "NoResize")
        options.players[i].NoMove                = lib_helpers.NotNilOrDefault(options.players[i].NoMove, "NoMove")
        options.players[i].NoScrollbar           = lib_helpers.NotNilOrDefault(options.players[i].NoScrollbar, "NoScrollbar")
        options.players[i].AlwaysAutoResize      = lib_helpers.NotNilOrDefault(options.players[i].AlwaysAutoResize, "AlwaysAutoResize")
        options.players[i].TransparentWindow     = lib_helpers.NotNilOrDefault(options.players[i].TransparentWindow, false)
        options.players[i].SD                    = lib_helpers.NotNilOrDefault(options.players[i].SD, true)
        options.players[i].Invulnerability       = lib_helpers.NotNilOrDefault(options.players[i].Invulnerability, true)
    
    end
else
    options = 
    {
        configurationEnableWindow = true,
        enable = true,
        fontScale = 1.0,

        allPlayersEnableWindow = true,
        allPlayersChanged = false,
        allPlayersAnchor = 1,
        allPlayersX = 50,
        allPlayersY = 50,
        allPlayersW = 450,
        allPlayersH = 350,
        allPlayersNoTitleBar = "",
        allPlayersNoResize = "",
        allPlayersNoMove = "",
        allPlayersTransparentWindow = false,

        singlePlayersEnableWindow = true,
        singlePlayersShowBarText = false,
        singlePlayersShowBarMaxValue = true,
    }

    options.players = {}

    for i=1,4,1 do
        options.players[i] = {}
        options.players[i].EnableWindow = true
        options.players[i].Changed = false
        options.players[i].Anchor = 3
        options.players[i].X = (5 * 1) + (150 * (i - 1))
        options.players[i].Y = -5
        options.players[i].W = 150
        options.players[i].H = 45
        options.players[i].NoTitleBar = "NoTitleBar"
        options.players[i].NoResize = "NoResize"
        options.players[i].NoMove = "NoMove"
        options.players[i].NoScrollbar = "NoScrollbar"
        options.players[i].AlwaysAutoResize = "AlwaysAutoResize"
        options.players[i].TransparentWindow = false
        options.players[i].SD = true
        options.players[i].Invulnerability = true
    end
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
        io.write(string.format("    allPlayersEnableWindow = %s,\n", tostring(options.allPlayersEnableWindow)))
        io.write(string.format("    allPlayersChanged = %s,\n", tostring(options.allPlayersChanged)))
        io.write(string.format("    allPlayersAnchor = %i,\n", options.allPlayersAnchor))
        io.write(string.format("    allPlayersX = %i,\n", options.allPlayersX))
        io.write(string.format("    allPlayersY = %i,\n", options.allPlayersY))
        io.write(string.format("    allPlayersW = %i,\n", options.allPlayersW))
        io.write(string.format("    allPlayersH = %i,\n", options.allPlayersH))
        io.write(string.format("    allPlayersNoTitleBar = \"%s\",\n", options.allPlayersNoTitleBar))
        io.write(string.format("    allPlayersNoResize = \"%s\",\n", options.allPlayersNoResize))
        io.write(string.format("    allPlayersNoMove = \"%s\",\n", options.allPlayersNoMove))
        io.write(string.format("    allPlayersTransparentWindow = %s,\n", tostring(options.allPlayersTransparentWindow)))
        io.write("\n")
        io.write(string.format("    singlePlayersEnableWindow = %s,\n", tostring(options.singlePlayersEnableWindow)))
        io.write(string.format("    singlePlayersShowBarText = %s,\n", tostring(options.singlePlayersShowBarText)))
        io.write(string.format("    singlePlayersShowBarMaxValue = %s,\n", tostring(options.singlePlayersShowBarMaxValue)))
        io.write("\n")

        io.write(string.format("    players = {\n"))
        for i=1,4,1 do
            io.write(string.format("        {\n"))
            io.write(string.format("            EnableWindow = %s,\n", tostring(options.players[i].EnableWindow)))
            io.write(string.format("            Changed = %s,\n", tostring(options.players[i].Changed)))
            io.write(string.format("            Anchor = %i,\n", options.players[i].Anchor))
            io.write(string.format("            X = %i,\n", options.players[i].X))
            io.write(string.format("            Y = %i,\n", options.players[i].Y))
            io.write(string.format("            W = %i,\n", options.players[i].W))
            io.write(string.format("            H = %i,\n", options.players[i].H))
            io.write(string.format("            NoTitleBar = \"%s\",\n", options.players[i].NoTitleBar))
            io.write(string.format("            NoResize = \"%s\",\n", options.players[i].NoResize))
            io.write(string.format("            NoMove = \"%s\",\n", options.players[i].NoMove))
            io.write(string.format("            NoScrollbar = \"%s\",\n", options.players[i].NoScrollbar))
            io.write(string.format("            AlwaysAutoResize = \"%s\",\n", options.players[i].AlwaysAutoResize))
            io.write(string.format("            TransparentWindow = %s,\n", tostring(options.players[i].TransparentWindow)))
            io.write(string.format("            SD = %s,\n", tostring(options.players[i].SD)))
            io.write(string.format("            Invulnerability = %s,\n", tostring(options.players[i].Invulnerability)))
            io.write(string.format("        },\n"))
        end
        io.write(string.format("    },\n"))
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
        local atkTech = lib_characters.GetPlayerTechniqueStatus(address, 0)
        local defTech = lib_characters.GetPlayerTechniqueStatus(address, 1)
        local invuln = lib_characters.GetPlayerInvulnerabilityStatus(address)

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
		if invuln.time == 0 then
            lib_helpers.Text(true, "---")
        else
            lib_helpers.Text(true, "%s: %s", "Inv.", os.date("!%M:%S", invuln.time))
        end
        imgui.NextColumn()
    end
end

local function PresentPlayer(address, sd, inv)
    if address == 0 then
        return
    end

    local name = string.gsub(lib_characters.GetPlayerName(address), "%%", "%%%%")
    local level = lib_characters.GetPlayerLevel(address)
    local hp = lib_characters.GetPlayerHP(address)
    local mhp = lib_characters.GetPlayerMaxHP(address)
    local tp = lib_characters.GetPlayerTP(address)
    local mtp = lib_characters.GetPlayerMaxTP(address)
    local atkTech = lib_characters.GetPlayerTechniqueStatus(address, 0)
    local defTech = lib_characters.GetPlayerTechniqueStatus(address, 1)
    local invuln = lib_characters.GetPlayerInvulnerabilityStatus(address)

    local hpColor = lib_helpers.HPToGreenRedGradient(hp/mhp)
    local tpColor = lib_helpers.HPToGreenRedGradient(tp/mtp)
    local barTextFormat = ""

    hpColor = 0xFF00F714
    if (hp/mhp) < 0.2 then
        hpColor = 0xFFEAF718
    end

    tpColor = 0xFF0088F4
    if (tp/mtp) < 0.2 then
        tpColor = 0xFFF7BB13
    end

    barTextFormat = "%d"
    if options.singlePlayersShowBarMaxValue then
        barTextFormat = "%d / %d"
    end

    lib_helpers.Text(true, "%s Lv%d", name, level)
    if options.singlePlayersShowBarText then
        lib_helpers.Text(true, "HP: " .. barTextFormat, hp, mhp)
    end
    lib_helpers.imguiProgressBar(true, hp/mhp, 130, 5.0 * options.fontScale, hpColor, nil)

    --if address == lib_characters.GetSelf() and mtp ~= 0 then
    --    if options.singlePlayersShowBarText then
    --        lib_helpers.Text(true, "TP: " .. barTextFormat, tp, mtp)
    --    end
    --    lib_helpers.imguiProgressBar(true, tp/mtp, 130, 5.0 * options.fontScale, tpColor, nil)
    --end

    if sd == true then
        if atkTech.type == 0 then
            --lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %02i: %s", atkTech.name, atkTech.level, os.date("!%M:%S", atkTech.time))
        end
        if defTech.type == 0 then
            --lib_helpers.Text(true, "")
        else
            lib_helpers.Text(true, "%s %02i: %s", defTech.name, defTech.level, os.date("!%M:%S", defTech.time))
        end
    end
    
    if inv == true then
        if invuln.time > 0 then
            lib_helpers.Text(true, "%-4s: %s", "Inv.", os.date("!%M:%S", invuln.time))
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

    if options.allPlayersEnableWindow then
        if firstPresent or options.allPlayersChanged then
            options.allPlayersChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.allPlayersX, options.allPlayersY, options.allPlayersW, options.allPlayersH, options.allPlayersAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.allPlayersW, options.allPlayersH, "Always");
        end

        if options.allPlayersTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Player Reader - All Players", nil, { options.allPlayersNoTitleBar, options.allPlayersNoResize, options.allPlayersNoMove }) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentPlayers()
        end
        imgui.End()

        if options.allPlayersTransparentWindow == true then
            imgui.PopStyleColor()
        end
    end

    local playerIsInDedicatedLobby = true

    if playerIsInDedicatedLobby then
        if options.singlePlayersEnableWindow then
            for i=1,4,1 do
                if options.players[i].EnableWindow then
                    local address = lib_characters.GetPlayer(i - 1)
                    if address ~= 0 then
                        local playerWindowTitle = string.format("Player Reader - Player %d", i)
                        if firstPresent or options.players[i].Changed then
                            options.players[i].Changed = false
                            local ps = lib_helpers.GetPosBySizeAndAnchor(
                                options.players[i].X,
                                options.players[i].Y,
                                options.players[i].W,
                                options.players[i].H,
                                options.players[i].Anchor)
                            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
                            if options.players[i].AlwaysAutoResize ~= "AlwaysAutoResize" then
                                imgui.SetNextWindowSize(options.players[i].W, options.players[i].H, "Always");
                            end
                        end

                        if options.players[i].TransparentWindow == true then
                            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
                        end

                        if imgui.Begin(playerWindowTitle, nil,
                            {
                                options.players[i].NoTitleBar,
                                options.players[i].NoResize,
                                options.players[i].NoMove,
                                options.players[i].NoScrollbar,
                                options.players[i].AlwaysAutoResize,
                            }
                        ) then
                            imgui.SetWindowFontScale(options.fontScale)
                            PresentPlayer(address, options.players[i].SD, options.players[i].Invulnerability)

                            if options.players[i].AlwaysAutoResize == "AlwaysAutoResize" then
                                if options.players[i].Anchor == 3 or options.players[i].Anchor == 6 or options.players[i].Anchor == 9 then
                                    options.players[i].H = imgui.GetWindowHeight()
                                    local ps = lib_helpers.GetPosBySizeAndAnchor(
                                        options.players[i].X,
                                        options.players[i].Y,
                                        options.players[i].W,
                                        options.players[i].H,
                                        options.players[i].Anchor)
                                    imgui.SetWindowPos(playerWindowTitle, ps[1], ps[2], "Always");
                                end
                            end
                        end
                        imgui.End()

                        if options.players[i].TransparentWindow == true then
                            imgui.PopStyleColor()
                        end
                    end
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
