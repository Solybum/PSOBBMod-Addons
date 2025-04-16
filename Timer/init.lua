local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local cfg = require("Timer.configuration")
local optionsLoaded, options = pcall(require, "Timer.options")
local keysLoaded, keys = pcall(require, "solylib.keys")

local optionsFileName = "addons/Timer/options.lua"
local firstPresent = true
local ConfigurationWindow

local key_pressed
local last_key_pressed = 0

if keysLoaded == false then
    local function getKeyID(keyName)
        return 0
    end

    keys = {
        getKeyID = getKeyID,
    }
end

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    if options == nil or type(options) ~= "table" then
        options = {}
    end


    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)

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
    options.stopwatchHotkeysStart         = lib_helpers.NotNilOrDefault(options.stopwatchHotkeysStart, -1)
    options.stopwatchHotkeysStop          = lib_helpers.NotNilOrDefault(options.stopwatchHotkeysStop, -1)
    options.stopwatchHotkeysResume        = lib_helpers.NotNilOrDefault(options.stopwatchHotkeysResume, -1)
    options.stopwatchHotkeysReset         = lib_helpers.NotNilOrDefault(options.stopwatchHotkeysReset, -1)
    options.stopwatchHotkeysSplit         = lib_helpers.NotNilOrDefault(options.stopwatchHotkeysSplit, -1)

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
    options.countdownHotkeysStart         = lib_helpers.NotNilOrDefault(options.countdownHotkeysStart, -1)
    options.countdownHotkeysStop          = lib_helpers.NotNilOrDefault(options.countdownHotkeysStop, -1)
    options.countdownHotkeysResume        = lib_helpers.NotNilOrDefault(options.countdownHotkeysResume, -1)
    options.countdownHotkeysReset         = lib_helpers.NotNilOrDefault(options.countdownHotkeysReset, -1)
    options.countdownHotkeysAdd30         = lib_helpers.NotNilOrDefault(options.countdownHotkeysAdd30, -1)
else
    options =
    {
        configurationEnableWindow = true,
        enable = true,

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
        stopwatchHotkeysStart = 0,
        stopwatchHotkeysStop = 0,
        stopwatchHotkeysResume = 0,
        stopwatchHotkeysReset = 0,
        stopwatchHotkeysSplit = 0,

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
        countdownHotkeysStart = 0,
        countdownHotkeysStop = 0,
        countdownHotkeysResume = 0,
        countdownHotkeysReset = 0,
        countdownHotkeysAdd30 = 0,
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
        io.write(string.format("    stopwatchHotkeysStart = %s,\n", tostring(options.stopwatchHotkeysStart)))
        io.write(string.format("    stopwatchHotkeysStop = %s,\n", tostring(options.stopwatchHotkeysStop)))
        io.write(string.format("    stopwatchHotkeysResume = %s,\n", tostring(options.stopwatchHotkeysResume)))
        io.write(string.format("    stopwatchHotkeysReset = %s,\n", tostring(options.stopwatchHotkeysReset)))
        io.write(string.format("    stopwatchHotkeysSplit = %s,\n", tostring(options.stopwatchHotkeysSplit)))
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
        io.write(string.format("    countdownHotkeysStart = %s,\n", tostring(options.countdownHotkeysStart)))
        io.write(string.format("    countdownHotkeysStop = %s,\n", tostring(options.countdownHotkeysStop)))
        io.write(string.format("    countdownHotkeysResume = %s,\n", tostring(options.countdownHotkeysResume)))
        io.write(string.format("    countdownHotkeysReset = %s,\n", tostring(options.countdownHotkeysReset)))
        io.write(string.format("    countdownHotkeysAdd30 = %s,\n", tostring(options.countdownHotkeysAdd30)))
        io.write("}\n")

        io.close(file)
    end
end

local function secondsToTime(milliseconds)
    local result = ""
    local h = math.floor(milliseconds / 3600000)
    local m = math.floor(milliseconds / 60000) % 60
    local s = math.floor(milliseconds / 1000) % 60
    local f = milliseconds % 1000

    result = string.format("%02d:%02d:%02d:%03d", h, m, s, f)

    return result
end

key_pressed = function(key)
    -- Only save the last key pressed when
    -- It's one of the ones we have setup
    if
        keys.getKeyID(options.stopwatchHotkeysStart) == key or
        keys.getKeyID(options.stopwatchHotkeysStop) == key or
        keys.getKeyID(options.stopwatchHotkeysResume) == key or
        keys.getKeyID(options.stopwatchHotkeysReset) == key or
        keys.getKeyID(options.stopwatchHotkeysSplit) == key or
        keys.getKeyID(options.countdownHotkeysStart) == key or
        keys.getKeyID(options.countdownHotkeysStop) == key or
        keys.getKeyID(options.countdownHotkeysResume) == key or
        keys.getKeyID(options.countdownHotkeysReset) == key or
        keys.getKeyID(options.countdownHotkeysAdd30) == key
    then
        last_key_pressed = key
    end
end

local stopwatch = {
    isRunning = false,
    startTime = 0,
    stopTime = 0,
    lastTime = 0,
    currentTime = 0,
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
    local currentTime = pso.get_tick_count()
    if stopwatch.isRunning == true then
        stopwatch.stopTime = stopwatch.stopTime + currentTime - stopwatch.lastTime
        stopwatch.lastTime = currentTime
    end

    local ellapsed = stopwatch.stopTime - stopwatch.startTime

    -- Splits first
    for k, v in pairs(splits) do
        imgui.Text(string.format("% 5s: %s", v.name, secondsToTime(v.delta)))
    end

    imgui.SetWindowFontScale(3)
    imgui.Text(secondsToTime(ellapsed))
    imgui.SetWindowFontScale(1)

    if stopwatch.isRunning == false then
        if stopwatch.startTime == 0 then
            if imgui.Button("Start") or keys.getKeyID(options.stopwatchHotkeysStart) == last_key_pressed then
                last_key_pressed = 0;
                stopwatch.startTime = currentTime
                stopwatch.stopTime = currentTime
                stopwatch.lastTime = currentTime
                stopwatch.lastSplit = currentTime
                stopwatch.isRunning = true
            end
        else
            if imgui.Button("Resume") or keys.getKeyID(options.stopwatchHotkeysResume) == last_key_pressed then
                last_key_pressed = 0;
                stopwatch.lastTime = currentTime
                stopwatch.isRunning = true
            end
        end
    else
        if imgui.Button("Stop") or keys.getKeyID(options.stopwatchHotkeysStop) == last_key_pressed then
            last_key_pressed = 0;
            stopwatch.isRunning = false
        end
    end
    if stopwatch.isRunning == true then
        imgui.SameLine(0)
        if imgui.Button("Split") or keys.getKeyID(options.stopwatchHotkeysSplit) == last_key_pressed then
            last_key_pressed = 0;
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
            if imgui.Button("Reset") or keys.getKeyID(options.stopwatchHotkeysReset) == last_key_pressed then
                last_key_pressed = 0;
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
    local currentTime = pso.get_tick_count()
    if countdown.isRunning == true then
        countdown.stopTime = countdown.stopTime + currentTime - countdown.lastTime
        countdown.lastTime = currentTime
    end

    local ellapsed = countdown.startTime - countdown.stopTime
    if ellapsed < 0 then
        ellapsed = 0
    end

    imgui.SetWindowFontScale(3)
    if countdown.isRunning == false and ellapsed == 0 then
        imgui.Text("TODO Countdown input, default 5 min")
    else
        imgui.Text(secondsToTime(ellapsed))
    end
    imgui.SetWindowFontScale(1)

    if countdown.startTime ~= 0 and keys.getKeyID(options.countdownHotkeysAdd30) == last_key_pressed then
        last_key_pressed = 0;
        countdown.startTime = countdown.startTime + 30000
    end

    if countdown.isRunning == false then
        if countdown.startTime == 0 then
            if imgui.Button("Start") or keys.getKeyID(options.countdownHotkeysStart) == last_key_pressed then
                last_key_pressed = 0;
                countdown.startTime = currentTime
                countdown.stopTime = currentTime
                countdown.lastTime = currentTime
                countdown.lastSplit = currentTime
                countdown.isRunning = true

                countdown.startTime = countdown.startTime + 300000
            end
        else
            if imgui.Button("Resume") or keys.getKeyID(options.countdownHotkeysResume) == last_key_pressed then
                last_key_pressed = 0;
                countdown.lastTime = currentTime
                countdown.isRunning = true
            end
        end
    else
        if imgui.Button("Stop") or keys.getKeyID(options.countdownHotkeysStop) == last_key_pressed then
            last_key_pressed = 0;
            countdown.isRunning = false
        end
    end
    if countdown.isRunning == false then
        if countdown.startTime ~= 0 then
            imgui.SameLine(0)
            if imgui.Button("Reset") or keys.getKeyID(options.countdownHotkeysReset) == last_key_pressed then
                last_key_pressed = 0;
                countdown.startTime = 0
                countdown.stopTime = 0
                countdown.lastTime = 0
                countdown.isRunning = false
            end
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
        key_pressed = key_pressed,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
