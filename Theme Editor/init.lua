local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local cfg = require("Theme Editor.configuration")
local optionsLoaded, options = pcall(require, "Theme Editor.theme_custom")

local optionsFileName = "addons/Theme Editor/theme_custom.lua"
local ConfigurationWindow

if optionsLoaded then
    -- TODO code this
else
    options = require("Theme Editor.theme_default")
end

local function SaveOptions(options)
-- TODO code this
    --local file = io.open(optionsFileName, "w")
    --if file ~= nil then
    --    io.output(file)
    --
    --    io.write("return\n")
    --    io.write("{\n")
    --    io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
    --    io.write(string.format("    enable = %s,\n", tostring(options.enable)))
    --    io.write(string.format("    useCustomTheme = %s,\n", tostring(options.enable)))
    --    io.write(string.format("    fontScale = %s,\n", tostring(options.fontScale)))
    --    io.write("\n")
    --    io.write(string.format("    playersEnableWindow = %s,\n", tostring(options.playersEnableWindow)))
    --    io.write(string.format("    playersChanged = %s,\n", tostring(options.playersChanged)))
    --    io.write(string.format("    playersAnchor = %i,\n", options.playersAnchor))
    --    io.write(string.format("    playersX = %i,\n", options.playersX))
    --    io.write(string.format("    playersY = %i,\n", options.playersY))
    --    io.write(string.format("    playersW = %i,\n", options.playersW))
    --    io.write(string.format("    playersH = %i,\n", options.playersH))
    --    io.write(string.format("    playersNoTitleBar = \"%s\",\n", options.playersNoTitleBar))
    --    io.write(string.format("    playersNoResize = \"%s\",\n", options.playersNoResize))
    --    io.write("}\n")
    --
    --    io.close(file)
    --end
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
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Theme Editor", mainMenuButtonHandler)

    return
    {
        name = "Theme",
        version = "1.0.0",
        author = "Solybum",
        description = "Theme editor, output used by addons",
        -- Restore present when finished
        present = nil,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
