local core_mainmenu = require("core_mainmenu")

local enable = false
local optionsFileName = "addons/theme.ini"
local theme = 
{
    globalFontScale = 1.0,
    alpha = 1.0,
    colors = {
        { name = "Text"                   , default = 0xFFE6E6E6, custom = 0xFFE6E6E6 },
        { name = "TextDisabled"           , default = 0xFF999999, custom = 0xFF999999 },
        { name = "WindowBg"               , default = 0xB3000000, custom = 0xB3000000 },
        { name = "ChildWindowBg"          , default = 0x00000000, custom = 0x00000000 },
        { name = "PopupBg"                , default = 0xE60D0D1A, custom = 0xE60D0D1A },
        { name = "Border"                 , default = 0xA6B3B3B3, custom = 0xA6B3B3B3 },
        { name = "BorderShadow"           , default = 0x00000000, custom = 0x00000000 },
        { name = "FrameBg"                , default = 0x4DCCCCCC, custom = 0x4DCCCCCC },
        { name = "FrameBgHovered"         , default = 0x66E6CCCC, custom = 0x66E6CCCC },
        { name = "FrameBgActive"          , default = 0x73E6A6A6, custom = 0x73E6A6A6 },
        { name = "TitleBg"                , default = 0xD445458A, custom = 0xD445458A },
        { name = "TitleBgCollapsed"       , default = 0x336666CC, custom = 0x336666CC },
        { name = "TitleBgActive"          , default = 0xDE5252A1, custom = 0xDE5252A1 },
        { name = "MenuBarBg"              , default = 0xCC66668C, custom = 0xCC66668C },
        { name = "ScrollbarBg"            , default = 0x9933404D, custom = 0x9933404D },
        { name = "ScrollbarGrab"          , default = 0x4D6666CC, custom = 0x4D6666CC },
        { name = "ScrollbarGrabHovered"   , default = 0x666666CC, custom = 0x666666CC },
        { name = "ScrollbarGrabActive"    , default = 0x66CC8080, custom = 0x66CC8080 },
        { name = "ComboBg"                , default = 0xFC333333, custom = 0xFC333333 },
        { name = "CheckMark"              , default = 0x80E6E6E6, custom = 0x80E6E6E6 },
        { name = "SliderGrab"             , default = 0x4DFFFFFF, custom = 0x4DFFFFFF },
        { name = "SliderGrabActive"       , default = 0xFFCC8080, custom = 0xFFCC8080 },
        { name = "Button"                 , default = 0x99AB6666, custom = 0x99AB6666 },
        { name = "ButtonHovered"          , default = 0xFFAB6666, custom = 0xFFAB6666 },
        { name = "ButtonActive"           , default = 0xFFCC8080, custom = 0xFFCC8080 },
        { name = "Header"                 , default = 0x736666E6, custom = 0x736666E6 },
        { name = "HeaderHovered"          , default = 0xCC7373E6, custom = 0xCC7373E6 },
        { name = "HeaderActive"           , default = 0xCC8787DE, custom = 0xCC8787DE },
        { name = "Column"                 , default = 0xFF808080, custom = 0xFF808080 },
        { name = "ColumnHovered"          , default = 0xFFB39999, custom = 0xFFB39999 },
        { name = "ColumnActive"           , default = 0xFFE6B3B3, custom = 0xFFE6B3B3 },
        { name = "ResizeGrip"             , default = 0x4DFFFFFF, custom = 0x4DFFFFFF },
        { name = "ResizeGripHovered"      , default = 0x99FFFFFF, custom = 0x99FFFFFF },
        { name = "ResizeGripActive"       , default = 0xE6FFFFFF, custom = 0xE6FFFFFF },
        { name = "CloseButton"            , default = 0x808080E6, custom = 0x808080E6 },
        { name = "CloseButtonHovered"     , default = 0x99B3B3E6, custom = 0x99B3B3E6 },
        { name = "CloseButtonActive"      , default = 0xFFB3B3B3, custom = 0xFFB3B3B3 },
        { name = "PlotLines"              , default = 0xFFFFFFFF, custom = 0xFFFFFFFF },
        { name = "PlotLinesHovered"       , default = 0xFFE6B300, custom = 0xFFE6B300 },
        { name = "PlotHistogram"          , default = 0xFFE6B300, custom = 0xFFE6B300 },
        { name = "PlotHistogramHovered"   , default = 0xFFFF9900, custom = 0xFFFF9900 },
        { name = "TextSelectedBg"         , default = 0x590000FF, custom = 0x590000FF },
        { name = "ModalWindowDarkening"   , default = 0x59333333, custom = 0x59333333 },
    }
}

local function ParseTheme()

end

local function ExportTheme()
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)
        io.write('[ImGuiIO]\n')
        io.write(string.format("%-24s= %f\n", "FontGlobalScale", theme.globalFontScale))
        io.write(string.format("\n"))
        io.write('[ImGuiStyle]\n')
        io.write(string.format("%-24s= %f\n", "Alpha", theme.alpha))

        local startIndex = 1
        local endIndex = table.getn(theme.colors)
        local step = 1

        for i=startIndex, endIndex, step do
            local name = theme.colors[i].name
            local c = theme.colors[i].custom

            io.write(string.format("%-24s= %08X\n", name, c))
        end

        io.close(file)
    end
end

-- UI stuff
local function PresentColorEditor(label, default, custom)
    local changed = false
    local i_default =
    {
        bit.band(bit.rshift(default, 24), 0xFF),
        bit.band(bit.rshift(default, 16), 0xFF),
        bit.band(bit.rshift(default, 8), 0xFF),
        bit.band(default, 0xFF)
    }
    local i_custom =
    {
        bit.band(bit.rshift(custom, 24), 0xFF),
        bit.band(bit.rshift(custom, 16), 0xFF),
        bit.band(bit.rshift(custom, 8), 0xFF),
        bit.band(custom, 0xFF)
    }

    local ids = { "##X", "##Y", "##Z", "##W" }
    local fmt = { "A:%3.0f", "B:%3.0f", "G:%3.0f", "B:%3.0f" }

    imgui.BeginGroup()
    imgui.PushID(label)

    imgui.PushItemWidth(50)
    for n = 1, 4, 1 do
        local changedDragInt = false
        if n ~= 1 then
            imgui.SameLine(0, 5)
        end
        
        changedDragInt, i_custom[n] = imgui.DragInt(ids[n], i_custom[n], 1.0, 0, 255, fmt[n])
    end
    imgui.PopItemWidth()

    imgui.SameLine(0, 5)
    imgui.ColorButton(i_custom[2] / 255, i_custom[3] / 255, i_custom[4] / 255, 1.0)
    if imgui.IsItemHovered() then
        imgui.SetTooltip(
            string.format(
                "#%02X%02X%02X%02X",
                i_custom[4],
                i_custom[1],
                i_custom[2],
                i_custom[3]
            )
        )
    end

    imgui.SameLine(0, 5)
    imgui.Text(label)

    default = 
    bit.lshift(i_default[1], 24) +
    bit.lshift(i_default[2], 16) +
    bit.lshift(i_default[3], 8) +
    bit.lshift(i_default[4], 0)

    custom = 
    bit.lshift(i_custom[1], 24) +
    bit.lshift(i_custom[2], 16) +
    bit.lshift(i_custom[3], 8) +
    bit.lshift(i_custom[4], 0)

    if custom ~= default then
        imgui.SameLine(0, 5)
        if imgui.Button("Revert") then
            custom = default
        end
    end

    imgui.PopID()
    imgui.EndGroup()

    return custom
end

local function PresentColorEditors()
    imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
    if imgui.Begin("Theme Editor") then
        if imgui.Button("Save") then
            ExportTheme()
        end

        imgui.BeginChild("ColorList", 0)

        for i = 1, table.getn(theme.colors), 1 do
            theme.colors[i].custom = PresentColorEditor(theme.colors[i].name, theme.colors[i].default, theme.colors[i].custom)
        end

        imgui.EndChild()
    end
    imgui.End()
end

local function present()
    if enable == false then
        return
    end

    PresentColorEditors()
end

local function init()
    local function mainMenuButtonHandler()
        -- Parse theme since we will enable the window
        if options == false then
            ParseTheme()
        end
        enable = not options
    end

    core_mainmenu.add_button("Theme Editor", mainMenuButtonHandler)

    return
    {
        name = "Theme Editor",
        version = "1.1.0",
        author = "Solybum",
        description = "Theme editor for framework global theme",
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
