local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local cfg = require("Theme Editor.configuration")
local optionsLoaded, options = pcall(require, "Theme Editor.theme_custom")

local optionsFileName = "addons/Theme Editor/theme_custom.lua"
local ConfigurationWindow

if optionsLoaded == false then
    options = require("Theme Editor.theme_default")
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write(string.format("local styleColors =\n"))
        io.write(string.format("{\n"))

        local startIndex = 1
        local endIndex = table.getn(options.styleColors)
        local step = 1

        for i=startIndex, endIndex, step do
            local name = options.styleColors[i].name
            local c = options.styleColors[i].color
            io.write(string.format("    { name = %-25s, color = { %.2f, %.2f, %.2f, %.2f, } },\n", "\"" .. name .. "\"", c[1], c[2], c[3], c[4]))
        end 

        io.write(string.format("}\n"))
        io.write(string.format("\n"))
        io.write(string.format("local function Push()\n"))
        io.write(string.format("    local startIndex = 1\n"))
        io.write(string.format("    local endIndex = table.getn(styleColors)\n"))
        io.write(string.format("    local step = 1\n"))
        io.write(string.format("\n"))
        io.write(string.format("    for i=startIndex, endIndex, step do\n"))
        io.write(string.format("        local name = styleColors[i].name\n"))
        io.write(string.format("        local c = styleColors[i].color\n"))
        io.write(string.format("\n"))
        io.write(string.format("        imgui.PushStyleColor(name, c[1], c[2], c[3], c[4])\n"))
        io.write(string.format("    end\n"))
        io.write(string.format("end\n"))
        io.write(string.format("\n"))
        io.write(string.format("local function Pop()\n"))
        io.write(string.format("    imgui.PopStyleColor(table.getn(styleColors))\n"))
        io.write(string.format("end\n"))
        io.write(string.format("\n"))
        io.write(string.format("return\n"))
        io.write(string.format("{\n"))
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(ConfigurationWindow.open)))
        io.write(string.format("    styleColors = styleColors,\n"))
        io.write(string.format("    Push = Push,\n"))
        io.write(string.format("    Pop = Pop,\n"))
        io.write(string.format("}\n"))
    
        io.close(file)
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
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
        SaveOptions(options)
    end

    core_mainmenu.add_button("Theme Editor", mainMenuButtonHandler)

    return
    {
        name = "Theme",
        version = "1.0.0",
        author = "Solybum",
        description = "Theme editor, output used by addons",
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
