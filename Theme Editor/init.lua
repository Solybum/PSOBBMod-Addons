local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local optionsLoaded, options = pcall(require, "Theme Editor.theme_custom")

local optionsFileName = "addons/Theme Editor/theme_custom.lua"
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
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    styleColors = styleColors,\n"))
        io.write(string.format("    Push = Push,\n"))
        io.write(string.format("    Pop = Pop,\n"))
        io.write(string.format("}\n"))
    
        io.close(file)
    end
end

local function PresentColorEditor()
    imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
    if imgui.Begin("Theme Editor") then
        -- TODO put all the stuff here
    end
    imgui.End()
end

local function present()
    local changed = false

    if options.enable == false then
        return
    end

    options.Push()

    PresentColorEditor()

    options.Pop()

    if changed then
        SaveOptions(options)
    end
end

local function init()
    local function mainMenuButtonHandler()
        options.enable = not options.enable
        SaveOptions(options)
    end

    core_mainmenu.add_button("Theme Editor", mainMenuButtonHandler)

    return
    {
        name = "Theme Editor",
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
