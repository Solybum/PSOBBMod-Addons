local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local cfg = require("Timer.configuration")
local optionsLoaded, options = pcall(require, "Timer.options")

local optionsFileName = "addons/Timer/options.lua"
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

    options.stopwatchEnableWindow         = lib_helpers.NotNilOrDefault(options.stopwatchEnableWindow, true)
    options.stopwatchChanged              = lib_helpers.NotNilOrDefault(options.stopwatchChanged, false)
    options.stopwatchAnchor               = lib_helpers.NotNilOrDefault(options.stopwatchAnchor, 1)
    options.stopwatchX                    = lib_helpers.NotNilOrDefault(options.stopwatchX, 50)
    options.stopwatchY                    = lib_helpers.NotNilOrDefault(options.stopwatchY, 50)
    options.stopwatchW                    = lib_helpers.NotNilOrDefault(options.stopwatchW, 450)
    options.stopwatchH                    = lib_helpers.NotNilOrDefault(options.stopwatchH, 350)
    options.stopwatchNoTitleBar           = lib_helpers.NotNilOrDefault(options.stopwatchNoTitleBar, "")
    options.stopwatchNoResize             = lib_helpers.NotNilOrDefault(options.stopwatchNoResize, "")
    options.stopwatchNoMove               = lib_helpers.NotNilOrDefault(options.stopwatchNoMove, "")
    options.stopwatchNoScrollbar          = lib_helpers.NotNilOrDefault(options.stopwatchNoScrollbar, "")
    options.stopwatchAlwaysAutoResize     = lib_helpers.NotNilOrDefault(options.stopwatchAlwaysAutoResize, "")
    options.stopwatchTransparentWindow    = lib_helpers.NotNilOrDefault(options.stopwatchTransparentWindow, false)

    options.countdownEnableWindow         = lib_helpers.NotNilOrDefault(options.countdownEnableWindow, true)
    options.countdownChanged              = lib_helpers.NotNilOrDefault(options.countdownChanged, false)
    options.countdownAnchor               = lib_helpers.NotNilOrDefault(options.countdownAnchor, 1)
    options.countdownX                    = lib_helpers.NotNilOrDefault(options.countdownX, 50)
    options.countdownY                    = lib_helpers.NotNilOrDefault(options.countdownY, 50)
    options.countdownW                    = lib_helpers.NotNilOrDefault(options.countdownW, 450)
    options.countdownH                    = lib_helpers.NotNilOrDefault(options.countdownH, 350)
    options.countdownNoTitleBar           = lib_helpers.NotNilOrDefault(options.countdownNoTitleBar, "")
    options.countdownNoResize             = lib_helpers.NotNilOrDefault(options.countdownNoResize, "")
    options.countdownNoMove               = lib_helpers.NotNilOrDefault(options.countdownNoMove, "")
    options.countdownNoScrollbar          = lib_helpers.NotNilOrDefault(options.countdownNoScrollbar, "")
    options.countdownAlwaysAutoResize     = lib_helpers.NotNilOrDefault(options.countdownAlwaysAutoResize, "")
    options.countdownTransparentWindow    = lib_helpers.NotNilOrDefault(options.countdownTransparentWindow, false)
else
    options =
    {
        configurationEnableWindow = true,
        enable = true,
        fontScale = 1.0,

        stopwatchEnableWindow = true,
        stopwatchChanged = false,
        stopwatchAnchor = 1,
        stopwatchX = 50,
        stopwatchY = 50,
        stopwatchW = 450,
        stopwatchH = 350,
        stopwatchNoTitleBar = "",
        stopwatchNoResize = "",
        stopwatchNoMove = "",
        stopwatchNoScrollbar = "",
        stopwatchAlwaysAutoResize = "",
        stopwatchTransparentWindow = false,

        countdownEnableWindow = true,
        countdownChanged = false,
        countdownAnchor = 1,
        countdownX = 50,
        countdownY = 50,
        countdownW = 450,
        countdownH = 350,
        countdownNoTitleBar = "",
        countdownNoResize = "",
        countdownNoMove = "",
        countdownNoScrollbar = "",
        countdownAlwaysAutoResize = "",
        countdownTransparentWindow = false,
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
        io.write(string.format("    stopwatchEnableWindow = %s,\n", tostring(options.stopwatchEnableWindow)))
        io.write(string.format("    stopwatchChanged = %s,\n", tostring(options.stopwatchChanged)))
        io.write(string.format("    stopwatchAnchor = %i,\n", options.stopwatchAnchor))
        io.write(string.format("    stopwatchX = %i,\n", options.stopwatchX))
        io.write(string.format("    stopwatchY = %i,\n", options.stopwatchY))
        io.write(string.format("    stopwatchW = %i,\n", options.stopwatchW))
        io.write(string.format("    stopwatchH = %i,\n", options.stopwatchH))
        io.write(string.format("    stopwatchNoTitleBar = \"%s\",\n", options.stopwatchNoTitleBar))
        io.write(string.format("    stopwatchNoResize = \"%s\",\n", options.stopwatchNoResize))
        io.write(string.format("    stopwatchNoMove = \"%s\",\n", options.stopwatchNoMove))
        io.write(string.format("    stopwatchNoScrollbar = \"%s\",\n", options.stopwatchNoScrollbar))
        io.write(string.format("    stopwatchAlwaysAutoResize = \"%s\",\n", options.stopwatchAlwaysAutoResize))
        io.write(string.format("    stopwatchTransparentWindow = %s,\n", tostring(options.stopwatchTransparentWindow)))
        io.write("\n")
        io.write(string.format("    countdownEnableWindow = %s,\n", tostring(options.countdownEnableWindow)))
        io.write(string.format("    countdownChanged = %s,\n", tostring(options.countdownChanged)))
        io.write(string.format("    countdownAnchor = %i,\n", options.countdownAnchor))
        io.write(string.format("    countdownX = %i,\n", options.countdownX))
        io.write(string.format("    countdownY = %i,\n", options.countdownY))
        io.write(string.format("    countdownW = %i,\n", options.countdownW))
        io.write(string.format("    countdownH = %i,\n", options.countdownH))
        io.write(string.format("    countdownNoTitleBar = \"%s\",\n", options.countdownNoTitleBar))
        io.write(string.format("    countdownNoResize = \"%s\",\n", options.countdownNoResize))
        io.write(string.format("    countdownNoMove = \"%s\",\n", options.countdownNoMove))
        io.write(string.format("    countdownNoScrollbar = \"%s\",\n", options.countdownNoScrollbar))
        io.write(string.format("    countdownAlwaysAutoResize = \"%s\",\n", options.countdownAlwaysAutoResize))
        io.write(string.format("    countdownTransparentWindow = %s,\n", tostring(options.countdownTransparentWindow)))
        io.write("}\n")

        io.close(file)
    end
end

local function secondsToTime(seconds)
    local result = ""
    local h = math.floor(seconds / 3600)
    local m = math.floor(seconds / 60) % 60
    local s = seconds % 60

    result = string.format("%02d:%02d:%02d", h, m, s)

    return result
end

local stopwatch = {
    isRunning = false,
    startTime = 0,
    stopTime = 0,
    lastTime = 0,
    lastSplit = 0,
}
-- Template
local split = {
    name = "",
    delta = 0,
}
local splitsCount = 0
local splits = {}

local function PresentStopwatch()
    local currentTime = os.time()
    if stopwatch.isRunning == true then
        if stopwatch.lastTime < currentTime then
            stopwatch.stopTime = stopwatch.stopTime + 1
            stopwatch.lastTime = currentTime
        end
    end

    ellapsed = stopwatch.stopTime - stopwatch.startTime

    -- Splits first
    for k, v in pairs(splits) do
        imgui.Text(string.format("% 5s: %s", v.name, secondsToTime(v.delta)))
    end

    imgui.SetWindowFontScale(options.fontScale * 3)
    imgui.Text(secondsToTime(ellapsed))
    imgui.SetWindowFontScale(options.fontScale)

    if stopwatch.isRunning == false then
        if imgui.Button("Start") then
            if stopwatch.startTime == 0 then
                local currentTime = os.time()
                stopwatch.startTime = currentTime
                stopwatch.stopTime = currentTime
                stopwatch.lastTime = currentTime
                stopwatch.lastSplit = currentTime
            end
            stopwatch.isRunning = true
        end
    else
        if imgui.Button("Stop") then
            stopwatch.isRunning = false
        end
    end
    if stopwatch.isRunning == true then
        imgui.SameLine(0)
        if imgui.Button("Split") then
            local split = {
                name = "",
                delta = 0,
            }
            split.name = ""..splitsCount + 1
            split.delta = stopwatch.stopTime - stopwatch.lastSplit
            table.insert(splits, split)
            splitsCount = splitsCount + 1
            stopwatch.lastSplit = stopwatch.stopTime
        end
    end
    if stopwatch.isRunning == false then
        if stopwatch.startTime ~= 0 then
            imgui.SameLine(0)
            if imgui.Button("Reset") then
                stopwatch.startTime = 0
                stopwatch.stopTime = 0
                stopwatch.lastTime = 0
                stopwatch.isRunning = false
                splits = {}
            end
        end
    end
end

local countdown = {
    isRunning = false,
    startTime = 0,
    stopTime = 0,
    lastTime = 0,
    timeString = "",
}

local function PresentCountdown()
    local currentTime = os.time()
    if countdown.isRunning == true then
        if countdown.lastTime < currentTime then
            countdown.stopTime = countdown.stopTime + 1
            countdown.lastTime = currentTime
        end
    end

    ellapsed = countdown.startTime - countdown.stopTime
    if ellapsed < 0 then
        ellapsed = 0
    end

    if countdown.isRunning == false and ellapsed == 0 then
        imgui.Text("TODO Countdown input, default 5 min")
    else
        imgui.SetWindowFontScale(options.fontScale * 3)
        imgui.Text(secondsToTime(ellapsed))
        imgui.SetWindowFontScale(options.fontScale)
    end

    if countdown.isRunning == false then
        if imgui.Button("Start") then
            if countdown.startTime == 0 then
                countdown.startTime = os.time()
                countdown.stopTime = countdown.startTime
                countdown.lastTime = countdown.lastTime

                -- TODO get seconds from input, prolly accept formatted time string
                countdown.startTime = countdown.startTime + 300
            end
            countdown.isRunning = true
        end
    else
        if imgui.Button("Stop") then
            countdown.isRunning = false
        end
    end
    if countdown.isRunning then
        imgui.SameLine(0)
        if imgui.Button("Reset") then
            countdown.startTime = 0
            countdown.stopTime = 0
            countdown.lastTime = 0
            countdown.isRunning = false
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

    if options.stopwatchEnableWindow then
        if firstPresent or options.stopwatchChanged then
            options.stopwatchChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(
                options.stopwatchX,
                options.stopwatchY,
                options.stopwatchW,
                options.stopwatchH,
                options.stopwatchAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            if options.stopwatchAlwaysAutoResize ~= "AlwaysAutoResize" then
                imgui.SetNextWindowSize(options.stopwatchW, options.stopwatchH, "Always");
            end
        end

        if options.stopwatchTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Stopwatch", nil,
            {
                options.stopwatchNoTitleBar,
                options.stopwatchNoResize,
                options.stopwatchNoMove,
                options.stopwatchNoScrollbar,
                options.stopwatchAlwaysAutoResize,
            }
        ) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentStopwatch()

            if options.stopwatchAlwaysAutoResize == "AlwaysAutoResize" then
                options.stopwatchH = imgui.GetWindowHeight()
                local ps = lib_helpers.GetPosBySizeAndAnchor(
                    options.stopwatchX,
                    options.stopwatchY,
                    options.stopwatchW,
                    options.stopwatchH,
                    options.stopwatchAnchor)
                imgui.SetWindowPos("Stopwatch", ps[1], ps[2], "Always");
            end
        end
        imgui.End()

        if options.stopwatchTransparentWindow == true then
            imgui.PopStyleColor()
        end
    end

    if options.countdownEnableWindow then
        if firstPresent or options.countdownChanged then
            options.countdownChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(
                options.countdownX,
                options.countdownY,
                options.countdownW,
                options.countdownH,
                options.countdownAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            if options.countdownAlwaysAutoResize ~= "AlwaysAutoResize" then
                imgui.SetNextWindowSize(options.countdownW, options.countdownH, "Always");
            end
        end

        if options.countdownTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Countdown", nil,
            {
                options.countdownNoTitleBar,
                options.countdownNoResize,
                options.countdownNoMove,
                options.countdownNoScrollbar,
                options.countdownAlwaysAutoResize,
            }
        ) then
            imgui.SetWindowFontScale(options.fontScale)
            PresentCountdown()

            if options.countdownAlwaysAutoResize == "AlwaysAutoResize" then
                options.countdownH = imgui.GetWindowHeight()
                local ps = lib_helpers.GetPosBySizeAndAnchor(
                    options.countdownX,
                    options.countdownY,
                    options.countdownW,
                    options.countdownH,
                    options.countdownAnchor)
                imgui.SetWindowPos("Countdown", ps[1], ps[2], "Always");
            end
        end
        imgui.End()

        if options.countdownTransparentWindow == true then
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

    core_mainmenu.add_button("Timer", mainMenuButtonHandler)

    return
    {
        name = "Timer",
        version = "1.0.0",
        author = "Solybum",
        description = "Countdown timer and stopwatch",
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
