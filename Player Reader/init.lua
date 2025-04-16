local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_menu = require("solylib.menu")
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


    options.configurationEnableWindow    = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                       = lib_helpers.NotNilOrDefault(options.enable, true)

    options.allPlayersEnableWindow       = lib_helpers.NotNilOrDefault(options.allPlayersEnableWindow, true)
    options.allHideWhenMenu              = lib_helpers.NotNilOrDefault(options.allHideWhenMenu, true)
    options.allHideWhenSymbolChat        = lib_helpers.NotNilOrDefault(options.allHideWhenSymbolChat, true)
    options.allHideWhenMenuUnavailable   = lib_helpers.NotNilOrDefault(options.allHideWhenMenuUnavailable, true)
    options.allPlayersChanged            = lib_helpers.NotNilOrDefault(options.allPlayersChanged, false)
    options.allPlayersAnchor             = lib_helpers.NotNilOrDefault(options.allPlayersAnchor, 1)
    options.allPlayersX                  = lib_helpers.NotNilOrDefault(options.allPlayersX, 50)
    options.allPlayersY                  = lib_helpers.NotNilOrDefault(options.allPlayersY, 50)
    options.allPlayersW                  = lib_helpers.NotNilOrDefault(options.allPlayersW, 450)
    options.allPlayersH                  = lib_helpers.NotNilOrDefault(options.allPlayersH, 350)
    options.allPlayersNoTitleBar         = lib_helpers.NotNilOrDefault(options.allPlayersNoTitleBar, "")
    options.allPlayersNoResize           = lib_helpers.NotNilOrDefault(options.allPlayersNoResize, "")
    options.allPlayersNoMove             = lib_helpers.NotNilOrDefault(options.allPlayersNoMove, "")
    options.allPlayersTransparentWindow  = lib_helpers.NotNilOrDefault(options.allPlayersTransparentWindow, false)
    options.allPlayersListHorizontal     = lib_helpers.NotNilOrDefault(options.allPlayersListHorizontal, false)
    options.allPlayersListMaxLength      = lib_helpers.NotNilOrDefault(options.allPlayersListMaxLength, 4)
    options.allPlayersShowIndex          = lib_helpers.NotNilOrDefault(options.allPlayersShowIndex, false)
    options.allPlayersShowName           = lib_helpers.NotNilOrDefault(options.allPlayersShowName, false)
    options.allPlayersShowHpBar          = lib_helpers.NotNilOrDefault(options.allPlayersShowHpBar, false)
    options.allPlayersShowBuff           = lib_helpers.NotNilOrDefault(options.allPlayersShowBuff, false)

    options.singlePlayersEnableWindow    = lib_helpers.NotNilOrDefault(options.singlePlayersEnableWindow, true)
    options.singlePlayersShowBarText     = lib_helpers.NotNilOrDefault(options.singlePlayersShowBarText, true)
    options.singlePlayersShowBarMaxValue = lib_helpers.NotNilOrDefault(options.singlePlayersShowBarMaxValue, true)

    if options.players == nil or type(options.players) ~= "table" then
        options.players = {}
    end

    for i = 1, 4, 1 do
        if options.players[i] == nil or type(options.players[i]) ~= "table" then
            options.players[i] = {}
        end

        options.players[i].EnableWindow            = lib_helpers.NotNilOrDefault(options.players[i].EnableWindow, true)
        options.players[i].HideWhenMenu            = lib_helpers.NotNilOrDefault(options.players[i].HideWhenMenu, true)
        options.players[i].HideWhenSymbolChat      = lib_helpers.NotNilOrDefault(options.players[i].HideWhenSymbolChat,
            true)
        options.players[i].HideWhenMenuUnavailable = lib_helpers.NotNilOrDefault(
            options.players[i].HideWhenMenuUnavailable, true)
        options.players[i].Changed                 = lib_helpers.NotNilOrDefault(options.players[i].Changed, false)
        options.players[i].Anchor                  = lib_helpers.NotNilOrDefault(options.players[i].Anchor, 3)
        options.players[i].X                       = lib_helpers.NotNilOrDefault(options.players[i].X,
            (5 * 1) + (150 * (i - 1)))
        options.players[i].Y                       = lib_helpers.NotNilOrDefault(options.players[i].Y, -5)
        options.players[i].W                       = lib_helpers.NotNilOrDefault(options.players[i].W, 150)
        options.players[i].H                       = lib_helpers.NotNilOrDefault(options.players[i].H, 45)
        options.players[i].ShowName                = lib_helpers.NotNilOrDefault(options.players[i].ShowName, false)
        options.players[i].ShowHPBar               = lib_helpers.NotNilOrDefault(options.players[i].ShowHPBar, false)
        options.players[i].SD                      = lib_helpers.NotNilOrDefault(options.players[i].SD, true)
        options.players[i].Invulnerability         = lib_helpers.NotNilOrDefault(options.players[i].Invulnerability, true)
        options.players[i].NoTitleBar              = lib_helpers.NotNilOrDefault(options.players[i].NoTitleBar,
            "NoTitleBar")
        options.players[i].NoResize                = lib_helpers.NotNilOrDefault(options.players[i].NoResize, "NoResize")
        options.players[i].NoMove                  = lib_helpers.NotNilOrDefault(options.players[i].NoMove, "NoMove")
        options.players[i].NoScrollbar             = lib_helpers.NotNilOrDefault(options.players[i].NoScrollbar,
            "NoScrollbar")
        options.players[i].AlwaysAutoResize        = lib_helpers.NotNilOrDefault(options.players[i].AlwaysAutoResize,
            "AlwaysAutoResize")
        options.players[i].TransparentWindow       = lib_helpers.NotNilOrDefault(options.players[i].TransparentWindow,
            false)
    end

    if options.myself == nil or type(options.myself) ~= "table" then
        options.myself = {}
    end

    options.myself.EnableWindow            = lib_helpers.NotNilOrDefault(options.myself.EnableWindow, false)
    options.myself.HideWhenMenu            = lib_helpers.NotNilOrDefault(options.myself.HideWhenMenu, true)
    options.myself.HideWhenSymbolChat      = lib_helpers.NotNilOrDefault(options.myself.HideWhenSymbolChat, true)
    options.myself.HideWhenMenuUnavailable = lib_helpers.NotNilOrDefault(options.myself.HideWhenMenuUnavailable, true)
    options.myself.ShowName                = lib_helpers.NotNilOrDefault(options.myself.ShowName, false)
    options.myself.ShowBarText             = lib_helpers.NotNilOrDefault(options.myself.ShowBarText, false)
    options.myself.ShowBarMaxValue         = lib_helpers.NotNilOrDefault(options.myself.ShowBarMaxValue, false)
    options.myself.ShowHPBar               = lib_helpers.NotNilOrDefault(options.myself.ShowHPBar, false)
    options.myself.SD                      = lib_helpers.NotNilOrDefault(options.myself.SD, true)
    options.myself.Invulnerability         = lib_helpers.NotNilOrDefault(options.myself.Invulnerability, true)
    options.myself.Changed                 = lib_helpers.NotNilOrDefault(options.myself.Changed, false)
    options.myself.Anchor                  = lib_helpers.NotNilOrDefault(options.myself.Anchor, 3)
    options.myself.X                       = lib_helpers.NotNilOrDefault(options.myself.X, (5 * 1))
    options.myself.Y                       = lib_helpers.NotNilOrDefault(options.myself.Y, -5)
    options.myself.W                       = lib_helpers.NotNilOrDefault(options.myself.W, 150)
    options.myself.H                       = lib_helpers.NotNilOrDefault(options.myself.H, 45)
    options.myself.NoTitleBar              = lib_helpers.NotNilOrDefault(options.myself.NoTitleBar, "NoTitleBar")
    options.myself.NoResize                = lib_helpers.NotNilOrDefault(options.myself.NoResize, "NoResize")
    options.myself.NoMove                  = lib_helpers.NotNilOrDefault(options.myself.NoMove, "NoMove")
    options.myself.NoScrollbar             = lib_helpers.NotNilOrDefault(options.myself.NoScrollbar, "NoScrollbar")
    options.myself.AlwaysAutoResize        = lib_helpers.NotNilOrDefault(options.myself.AlwaysAutoResize,
        "AlwaysAutoResize")
    options.myself.TransparentWindow       = lib_helpers.NotNilOrDefault(options.myself.TransparentWindow, false)
else
    options =
    {
        configurationEnableWindow = true,
        enable = true,

        allPlayersEnableWindow = true,
        allHideWhenMenu = false,
        allHideWhenSymbolChat = false,
        allHideWhenMenuUnavailable = false,
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
        allPlayersListHorizontal = true,
        allPlayersListMaxLength = 4,
        allPlayersShowName = true,
        allPlayersShowIndex = true,
        allPlayersShowHpBar = true,
        allPlayersShowBuff = true,

        singlePlayersEnableWindow = true,
        singlePlayersShowBarText = false,
        singlePlayersShowBarMaxValue = true,
    }

    options.players = {}

    for i = 1, 4, 1 do
        options.players[i]                         = {}
        options.players[i].EnableWindow            = true
        options.players[i].HideWhenMenu            = false
        options.players[i].HideWhenSymbolChat      = false
        options.players[i].HideWhenMenuUnavailable = false
        options.players[i].ShowName                = false
        options.players[i].ShowHPBar               = false
        options.players[i].SD                      = true
        options.players[i].Invulnerability         = true
        options.players[i].NoTitleBar              = "NoTitleBar"
        options.players[i].NoResize                = "NoResize"
        options.players[i].NoMove                  = "NoMove"
        options.players[i].NoScrollbar             = "NoScrollbar"
        options.players[i].AlwaysAutoResize        = "AlwaysAutoResize"
        options.players[i].TransparentWindow       = false
        options.players[i].Changed                 = false
        options.players[i].Anchor                  = 3
        options.players[i].X                       = (5 * 1) + (150 * (i - 1))
        options.players[i].Y                       = -5
        options.players[i].W                       = 150
        options.players[i].H                       = 45
    end

    options.myself                         = {}
    options.myself.EnableWindow            = false
    options.myself.HideWhenMenu            = false
    options.myself.HideWhenSymbolChat      = false
    options.myself.HideWhenMenuUnavailable = false
    options.myself.ShowName                = false
    options.myself.ShowBarText             = false
    options.myself.ShowBarMaxValue         = false
    options.myself.ShowHPBar               = false
    options.myself.SD                      = true
    options.myself.Invulnerability         = true
    options.myself.Changed                 = false
    options.myself.Anchor                  = 3
    options.myself.X                       = (5 * 1)
    options.myself.Y                       = -5
    options.myself.W                       = -150
    options.myself.H                       = 45
    options.myself.NoTitleBar              = "NoTitleBar"
    options.myself.NoResize                = "NoResize"
    options.myself.NoMove                  = "NoMove"
    options.myself.NoScrollbar             = "NoScrollbar"
    options.myself.AlwaysAutoResize        = "AlwaysAutoResize"
    options.myself.TransparentWindow       = false
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write("\n")
        io.write(string.format("    allPlayersEnableWindow = %s,\n", tostring(options.allPlayersEnableWindow)))
        io.write(string.format("    allHideWhenMenu = %s,\n", tostring(options.allHideWhenMenu)))
        io.write(string.format("    allHideWhenSymbolChat = %s,\n", tostring(options.allHideWhenSymbolChat)))
        io.write(string.format("    allHideWhenMenuUnavailable = %s,\n", tostring(options.allHideWhenMenuUnavailable)))
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
        io.write(string.format("    allPlayersListHorizontal = %s,\n", tostring(options.allPlayersListHorizontal)))
        io.write(string.format("    allPlayersListMaxLength = %s,\n", tostring(options.allPlayersListMaxLength)))
        io.write(string.format("    allPlayersShowIndex = %s,\n", tostring(options.allPlayersShowIndex)))
        io.write(string.format("    allPlayersShowName = %s,\n", tostring(options.allPlayersShowName)))
        io.write(string.format("    allPlayersShowHpBar = %s,\n", tostring(options.allPlayersShowHpBar)))
        io.write(string.format("    allPlayersShowBuff = %s,\n", tostring(options.allPlayersShowBuff)))
        io.write("\n")
        io.write(string.format("    singlePlayersEnableWindow = %s,\n", tostring(options.singlePlayersEnableWindow)))
        io.write(string.format("    singlePlayersShowBarText = %s,\n", tostring(options.singlePlayersShowBarText)))
        io.write(string.format("    singlePlayersShowBarMaxValue = %s,\n", tostring(options.singlePlayersShowBarMaxValue)))
        io.write("\n")

        io.write(string.format("    players = {\n"))
        for i = 1, 4, 1 do
            io.write(string.format("        {\n"))
            io.write(string.format("            EnableWindow = %s,\n", tostring(options.players[i].EnableWindow)))
            io.write(string.format("            HideWhenMenu = %s, \n", tostring(options.players[i].HideWhenMenu)))
            io.write(string.format("            HideWhenSymbolChat = %s, \n",
                tostring(options.players[i].HideWhenSymbolChat)))
            io.write(string.format("            HideWhenMenuUnavailable = %s, \n",
                tostring(options.players[i].HideWhenUnavailable)))
            io.write(string.format("            ShowName = %s,\n", tostring(options.players[i].ShowName)))
            io.write(string.format("            ShowHPBar = %s,\n", tostring(options.players[i].ShowHPBar)))
            io.write(string.format("            SD = %s,\n", tostring(options.players[i].SD)))
            io.write(string.format("            Invulnerability = %s,\n", tostring(options.players[i].Invulnerability)))
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
            io.write(string.format("            TransparentWindow = %s,\n",
                tostring(options.players[i].TransparentWindow)))


            io.write(string.format("        },\n"))
        end
        io.write(string.format("    },\n"))

        io.write(string.format("   myself = {\n"))
        io.write(string.format("        EnableWindow = %s,\n", tostring(options.myself.EnableWindow)))
        io.write(string.format("        HideWhenMenu = %s,\n", tostring(options.myself.HideWhenMenu)))
        io.write(string.format("        HideWhenSymbolChat = %s,\n", tostring(options.myself.HideWhenSymbolChat)))
        io.write(string.format("        HideWhenMenuUnavailable = %s,\n",
            tostring(options.myself.HideWhenMenuUnavailable)))
        io.write(string.format("        ShowName = %s,\n", tostring(options.myself.ShowName)))
        io.write(string.format("        ShowBarText = %s,\n", tostring(options.myself.ShowBarText)))
        io.write(string.format("        ShowBarMaxValue = %s,\n", tostring(options.myself.ShowBarMaxValue)))
        io.write(string.format("        ShowHPBar = %s,\n", tostring(options.myself.ShowHPBar)))
        io.write(string.format("        SD = %s,\n", tostring(options.myself.SD)))
        io.write(string.format("        Invulnerability = %s,\n", tostring(options.myself.Invulnerability)))
        io.write(string.format("        Changed = %s,\n", tostring(options.myself.Changed)))
        io.write(string.format("        Anchor = %i,\n", options.myself.Anchor))
        io.write(string.format("        X = %i,\n", options.myself.X))
        io.write(string.format("        Y = %i,\n", options.myself.Y))
        io.write(string.format("        W = %i,\n", options.myself.W))
        io.write(string.format("        H = %i,\n", options.myself.H))
        io.write(string.format("        NoTitleBar = \"%s\",\n", options.myself.NoTitleBar))
        io.write(string.format("        NoResize = \"%s\",\n", options.myself.NoResize))
        io.write(string.format("        NoMove = \"%s\",\n", options.myself.NoMove))
        io.write(string.format("        NoScrollbar = \"%s\",\n", options.myself.NoScrollbar))
        io.write(string.format("        AlwaysAutoResize = \"%s\",\n", options.myself.AlwaysAutoResize))
        io.write(string.format("        TransparentWindow = %s,\n", tostring(options.myself.TransparentWindow)))
        io.write(string.format("   },\n"))

        io.write("}\n")

        io.close(file)
    end
end

local function PresentPlayers()
    local playerList = lib_characters.GetPlayerList()
    local playerListCount = table.getn(playerList)

    local totalColumns = 0

    -- Determine the necessary totalColumns
    if options.allPlayersShowIndex then
        totalColumns = totalColumns + 1
    end

    if options.allPlayersShowName then
        totalColumns = totalColumns + 1
    end

    if options.allPlayersShowHpBar then
        totalColumns = totalColumns + 1
    end

    if options.allPlayersShowBuff then
        totalColumns = totalColumns + 1
    end

    if options.allPlayersListHorizontal then
        if playerListCount == nil
            or playerListCount <= 0
            or options.allPlayersListMaxLength == nil
            or options.allPlayersListMaxLength <= 0
        then
            -- Columns must be greather than 0
            imgui.Columns(1)
        else
            -- Allow the user to decide the maximum players shown
            imgui.Columns(options.allPlayersListMaxLength)
        end
    else
        imgui.Columns(totalColumns)
    end

    for i = 1, playerListCount, 1 do
        if i > options.allPlayersListMaxLength then
            return
        end

        local index = playerList[i].index
        local address = playerList[i].address

        local name = lib_characters.GetPlayerName(address)
        -- Escape '%' in the name but only if the plugin isn't updated
        if pso.require_version == nil or not pso.require_version(3, 6, 0) then
            name = string.gsub(name, "%%", "%%%%")
        end
        local hp = lib_characters.GetPlayerHP(address)
        local mhp = lib_characters.GetPlayerMaxHP(address)
        local hpColor = lib_helpers.HPToGreenRedGradient(hp / mhp)
        local atkTech = lib_characters.GetPlayerTechniqueStatus(address, 0)
        local defTech = lib_characters.GetPlayerTechniqueStatus(address, 1)
        local invuln = lib_characters.GetPlayerInvulnerabilityStatus(address)

        if options.allPlayersShowIndex then
            lib_helpers.Text(true, "%2i", index)

            if not options.allPlayersListHorizontal then
                imgui.NextColumn()
            end
        end

        if options.allPlayersShowName then
            lib_helpers.Text(true, "%s", name)
            if not options.allPlayersListHorizontal then
                imgui.NextColumn()
            end
        end

        if options.allPlayersShowHpBar then
            lib_helpers.imguiProgressBar(true, hp / mhp, -1.0, imgui.GetFontSize(), hpColor, nil, hp)
            if not options.allPlayersListHorizontal then
                imgui.NextColumn()
            end
        end

        if options.allPlayersShowBuff then
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
            if not options.allPlayersListHorizontal then
                imgui.NextColumn()
            end
        end

        if options.allPlayersListHorizontal then
            imgui.NextColumn()
        end
    end
end

local function PresentPlayer(address, sd, inv, showName, HPbar, showBarMaxValue, showHPTPText)
    if address == 0 then
        return
    end

    local name = lib_characters.GetPlayerName(address)
    -- Escape '%' in the name but only if the plugin isn't updated
    if pso.require_version == nil or not pso.require_version(3, 6, 0) then
        name = string.gsub(name, "%%", "%%%%")
    end
    local level = lib_characters.GetPlayerLevel(address)
    local hp = lib_characters.GetPlayerHP(address)
    local mhp = lib_characters.GetPlayerMaxHP(address)
    local tp = lib_characters.GetPlayerTP(address)
    local mtp = lib_characters.GetPlayerMaxTP(address)
    local atkTech = lib_characters.GetPlayerTechniqueStatus(address, 0)
    local defTech = lib_characters.GetPlayerTechniqueStatus(address, 1)
    local invuln = lib_characters.GetPlayerInvulnerabilityStatus(address)

    local hpColor = lib_helpers.HPToGreenRedGradient(hp / mhp)
    local tpColor = lib_helpers.HPToGreenRedGradient(tp / mtp)
    local barTextFormat = ""

    hpColor = 0xFF00F714
    if (hp / mhp) < 0.2 then
        hpColor = 0xFFEAF718
    end

    tpColor = 0xFF0088F4
    if (tp / mtp) < 0.2 then
        tpColor = 0xFFF7BB13
    end

    barTextFormat = "%d"
    if showBarMaxValue then
        barTextFormat = "%d / %d"
    end

    if showName == true then
        lib_helpers.Text(true, "%s Lv%d", name, level)
    end

    if showHPTPText == true then
        lib_helpers.Text(true, "HP: " .. barTextFormat, hp, mhp)
    end

    if HPbar == true then
        lib_helpers.imguiProgressBar(true, hp / mhp, 130, imgui.GetFontSize() * 0.5, hpColor, nil)
    end

    --if address == lib_characters.GetSelf() and mtp ~= 0 then
    --    if options.singlePlayersShowBarText then
    --        lib_helpers.Text(true, "TP: " .. barTextFormat, tp, mtp)
    --    end
    --    lib_helpers.imguiProgressBar(true, tp/mtp, 130, imgui.GetFontSize() * 0.5, tpColor, nil)
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

    if (options.allPlayersEnableWindow == true)
        and (options.allHideWhenMenu == false or lib_menu.IsMenuOpen() == false)
        and (options.allHideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
        and (options.allHideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
        and (options.allPlayersShowIndex or options.allPlayersShowName or options.allPlayersShowHpBar or options.allPlayersShowBuff)
    then
        if firstPresent or options.allPlayersChanged then
            options.allPlayersChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.allPlayersX, options.allPlayersY, options.allPlayersW,
                options.allPlayersH, options.allPlayersAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.allPlayersW, options.allPlayersH, "Always");
        end
        if options.allPlayersTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end
        if imgui.Begin("Player Reader - All Players", nil, { options.allPlayersNoTitleBar, options.allPlayersNoResize, options.allPlayersNoMove }) then
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
            for i = 1, 4, 1 do
                if (options.players[i].EnableWindow == true)
                    and (options.players[i].HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
                    and (options.players[i].HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
                    and (options.players[i].HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
                then
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
                            PresentPlayer(
                                address,
                                options.players[i].SD,
                                options.players[i].Invulnerability,
                                options.players[i].ShowName,
                                options.players[i].ShowHPBar,
                                options.singlePlayersShowBarMaxValue,
                                options.singlePlayersShowBarText)

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

    if (options.myself.EnableWindow == true)
        and (options.myself.HideWhenMenu == false or lib_menu.IsMenuOpen() == false)
        and (options.myself.HideWhenSymbolChat == false or lib_menu.IsSymbolChatOpen() == false)
        and (options.myself.HideWhenMenuUnavailable == false or lib_menu.IsMenuUnavailable() == false)
    then
        local myselfWindowTitle = "Player Reader - Myself"
        if firstPresent or options.myself.Changed then
            options.myself.Changed = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(
                options.myself.X,
                options.myself.Y,
                options.myself.W,
                options.myself.H,
                options.myself.Anchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            if options.myself.AlwaysAutoResize ~= "AlwaysAutoResize" then
                imgui.SetNextWindowSize(options.myself.W, options.myself.H, "Always");
            end
        end

        if options.myself.TransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin(myselfWindowTitle, nil,
                {
                    options.myself.NoTitleBar,
                    options.myself.NoResize,
                    options.myself.NoMove,
                    options.myself.NoScrollbar,
                    options.myself.AlwaysAutoResize,
                }
            ) then
            PresentPlayer(
                lib_characters.GetSelf(),
                options.myself.SD,
                options.myself.Invulnerability,
                options.myself.ShowName,
                options.myself.ShowHPBar,
                options.myself.ShowBarMaxValue,
                options.myself.ShowBarText)

            if options.myself.AlwaysAutoResize == "AlwaysAutoResize" then
                if options.myself.Anchor == 3 or options.myself.Anchor == 6 or options.myself.Anchor == 9 then
                    options.myself.H = imgui.GetWindowHeight()
                    local ps = lib_helpers.GetPosBySizeAndAnchor(
                        options.myself.X,
                        options.myself.Y,
                        options.myself.W,
                        options.myself.H,
                        options.myself.Anchor)
                    imgui.SetWindowPos(myselfWindowTitle, ps[1], ps[2], "Always");
                end
            end
        end
        imgui.End()

        if options.myself.TransparentWindow == true then
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
