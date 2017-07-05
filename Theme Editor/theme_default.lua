local enable = false

local styleColors = 
{
    { name = "Text"                   , color = { 0.90, 0.90, 0.90, 1.00, } },
    { name = "TextDisabled"           , color = { 0.60, 0.60, 0.60, 1.00, } },
    { name = "WindowBg"               , color = { 0.00, 0.00, 0.00, 0.70, } },
    { name = "ChildWindowBg"          , color = { 0.00, 0.00, 0.00, 0.00, } },
    { name = "PopupBg"                , color = { 0.05, 0.05, 0.10, 0.90, } },
    { name = "Border"                 , color = { 0.70, 0.70, 0.70, 0.65, } },
    { name = "BorderShadow"           , color = { 0.00, 0.00, 0.00, 0.00, } },
    { name = "FrameBg"                , color = { 0.80, 0.80, 0.80, 0.30, } },
    { name = "FrameBgHovered"         , color = { 0.90, 0.80, 0.80, 0.40, } },
    { name = "FrameBgActive"          , color = { 0.90, 0.65, 0.65, 0.45, } },
    { name = "TitleBg"                , color = { 0.27, 0.27, 0.54, 0.83, } },
    { name = "TitleBgCollapsed"       , color = { 0.40, 0.40, 0.80, 0.20, } },
    { name = "TitleBgActive"          , color = { 0.32, 0.32, 0.63, 0.87, } },
    { name = "MenuBarBg"              , color = { 0.40, 0.40, 0.55, 0.80, } },
    { name = "ScrollbarBg"            , color = { 0.20, 0.25, 0.30, 0.60, } },
    { name = "ScrollbarGrab"          , color = { 0.40, 0.40, 0.80, 0.30, } },
    { name = "ScrollbarGrabHovered"   , color = { 0.40, 0.40, 0.80, 0.40, } },
    { name = "ScrollbarGrabActive"    , color = { 0.80, 0.50, 0.50, 0.40, } },
    { name = "ComboBg"                , color = { 0.20, 0.20, 0.20, 0.99, } },
    { name = "CheckMark"              , color = { 0.90, 0.90, 0.90, 0.50, } },
    { name = "SliderGrab"             , color = { 1.00, 1.00, 1.00, 0.30, } },
    { name = "SliderGrabActive"       , color = { 0.80, 0.50, 0.50, 1.00, } },
    { name = "Button"                 , color = { 0.67, 0.40, 0.40, 0.60, } },
    { name = "ButtonHovered"          , color = { 0.67, 0.40, 0.40, 1.00, } },
    { name = "ButtonActive"           , color = { 0.80, 0.50, 0.50, 1.00, } },
    { name = "Header"                 , color = { 0.40, 0.40, 0.90, 0.45, } },
    { name = "HeaderHovered"          , color = { 0.45, 0.45, 0.90, 0.80, } },
    { name = "HeaderActive"           , color = { 0.53, 0.53, 0.87, 0.80, } },
    { name = "Column"                 , color = { 0.50, 0.50, 0.50, 1.00, } },
    { name = "ColumnHovered"          , color = { 0.70, 0.60, 0.60, 1.00, } },
    { name = "ColumnActive"           , color = { 0.90, 0.70, 0.70, 1.00, } },
    { name = "ResizeGrip"             , color = { 1.00, 1.00, 1.00, 0.30, } },
    { name = "ResizeGripHovered"      , color = { 1.00, 1.00, 1.00, 0.60, } },
    { name = "ResizeGripActive"       , color = { 1.00, 1.00, 1.00, 0.90, } },
    { name = "CloseButton"            , color = { 0.50, 0.50, 0.90, 0.50, } },
    { name = "CloseButtonHovered"     , color = { 0.70, 0.70, 0.90, 0.60, } },
    { name = "CloseButtonActive"      , color = { 0.70, 0.70, 0.70, 1.00, } },
    { name = "PlotLines"              , color = { 1.00, 1.00, 1.00, 1.00, } },
    { name = "PlotLinesHovered"       , color = { 0.90, 0.70, 0.00, 1.00, } },
    { name = "PlotHistogram"          , color = { 0.90, 0.70, 0.00, 1.00, } },
    { name = "PlotHistogramHovered"   , color = { 1.00, 0.60, 0.00, 1.00, } },
    { name = "TextSelectedBg"         , color = { 0.00, 0.00, 1.00, 0.35, } },
    { name = "ModalWindowDarkening"   , color = { 0.20, 0.20, 0.20, 0.35, } },
}

local function Push()
    local startIndex = 1
    local endIndex = table.getn(styleColors)
    local step = 1

    for i=startIndex, endIndex, step do
        local name = styleColors[i].name
        local c = styleColors[i].color

        imgui.PushStyleColor(name, c[1], c[2], c[3], c[4])
    end
end

local function Pop()
    imgui.PopStyleColor(table.getn(styleColors))
end

return
{
    enable = enable,
    styleColors = styleColors,
    Push = Push,
    Pop = Pop,
}
