local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local optionsDefault = require("Theme Editor.theme_default")
local optionsLoaded, options = pcall(require, "Theme Editor.theme_custom")

local optionsFileName = "addons/Theme Editor/theme_custom.lua"
if optionsLoaded == false then
    options = require("Theme Editor.theme_default")
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write(string.format("local enable = %s\n", tostring(options.enable)))
        io.write(string.format("\n"))
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
        io.write(string.format("    enable = enable,\n"))
        io.write(string.format("    styleColors = styleColors,\n"))
        io.write(string.format("    Push = Push,\n"))
        io.write(string.format("    Pop = Pop,\n"))
        io.write(string.format("}\n"))
    
        io.close(file)
    end
end

local function PresentColorEditor(label, col, col_d)
    local changed = false
    local i =
    {
        lib_helpers.F32ToInt8(col[1]),
        lib_helpers.F32ToInt8(col[2]),
        lib_helpers.F32ToInt8(col[3]),
        lib_helpers.F32ToInt8(col[4]),
    }
    local i_d =
    {
        lib_helpers.F32ToInt8(col_d[1]),
        lib_helpers.F32ToInt8(col_d[2]),
        lib_helpers.F32ToInt8(col_d[3]),
        lib_helpers.F32ToInt8(col_d[4]),
    }

    local ids = { "##X", "##Y", "##Z", "##W" }
    local fmt = { "R:%3.0f", "G:%3.0f", "B:%3.0f", "A:%3.0f" }

    imgui.BeginGroup()
    imgui.PushID(label)

    imgui.PushItemWidth(50)
    for n = 1, 4, 1 do
        local changedDragInt = false
        if n ~= 1 then
            imgui.SameLine(0, 5)
        end
        
        changedDragInt, i[n] = imgui.DragInt(ids[n], i[n], 1.0, 0, 255, fmt[n])
    end
    imgui.PopItemWidth()

    imgui.SameLine(0, 5)
    imgui.ColorButton(col[1], col[2], col[3], 1.0)
    if imgui.IsItemHovered() then
        imgui.SetTooltip(
            string.format(
                "Color:\n(%.2f,%.2f,%.2f,%.2f)\n#%02X%02X%02X%02X",
                col[1], col[2], col[3], col[4],
                col[1] * 255,
                col[2] * 255,
                col[3] * 255,
                col[4] * 255
            )
        )
    end

    imgui.SameLine(0, 5)
    imgui.Text(label)

    for n = 1, 4, 1 do
        col[n] = i[n] / 255

        if i[n] ~= i_d[n] then
            changed = true
        end
    end

    if changed then
        imgui.SameLine(0, 5)
        if imgui.Button("Revert") then
            for n = 1, 4, 1 do
                col[n] = col_d[n]
            end
        end
    end

    imgui.PopID()
    imgui.EndGroup()
end

local exportHex = false
local exportedHex = false
local exportHexStr = ""

local function PresentColorEditors()
    local save = false

    imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
    if imgui.Begin("Theme Editor") then
        if imgui.Button("Save") then
            save = true
        end

        if imgui.Button("Export Hex") then
            exportHex = true
            exportedHex = false
            exportHexStr = "[ImGuiIO]\n" ..
                           "FontGlobalScale         = 1.0\n" ..
                           "\n" ..
                           "[ImGuiStyle]\n" ..
                           "UseCustomTheme          = 1\n" ..
                           "Alpha                   = 1.0\n"
        end

        if exportedHex == true then
            imgui.Text("Copied theme data to clipboard")
            imgui.Text("Replace the contents of your theme.ini file")
            imgui.Text("")
        end

        imgui.BeginChild("ColorList", 0)

        for i = 1, table.getn(options.styleColors), 1 do
            PresentColorEditor(options.styleColors[i].name,
                options.styleColors[i].color,
                optionsDefault.styleColors[i].color)

            if exportHex == true then
                exportHexStr = exportHexStr ..
                    string.format("%-24s= %08X\n",
                        options.styleColors[i].name,
                        bit.lshift(lib_helpers.F32ToInt8(options.styleColors[i].color[4]), 24),
                        bit.lshift(lib_helpers.F32ToInt8(options.styleColors[i].color[1]), 16),
                        bit.lshift(lib_helpers.F32ToInt8(options.styleColors[i].color[2]), 8),
                        bit.lshift(lib_helpers.F32ToInt8(options.styleColors[i].color[3]), 0))
            end
        end

        if exportHex == true then
            imgui.SetClipboardText(exportHexStr)
            if exportedHex == false then
                exportedHex = true
            end
            exportHex = false
        end

        imgui.EndChild()
    end
    imgui.End()

    return save
end

local function present()
    local save = false

    if options.enable == false then
        return
    end

    --options.Push()

    save = PresentColorEditors()

    --options.Pop()

    if save then
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
