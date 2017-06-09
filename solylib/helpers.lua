local function GetColorAsFloats(color)
    color = color or 0xFFFFFFFF

    local a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    local r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    local g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    local b = bit.band(color, 0xFF) / 255;

    return {r, g, b, a}
end

local function HPToGreenRedGradient(percent)
    local a = 1 - percent + 0.4
    local r = 1 - percent
    local g = percent
    local b = 0

    if a > 1.0 then
        a = 1.0
    end

    local color =
        bit.lshift(bit.band((a * 255), 0xFF), 24) +
        bit.lshift(bit.band((r * 255), 0xFF), 16) +
        bit.lshift(bit.band((g * 255), 0xFF), 8) +
        bit.lshift(bit.band((b * 255), 0xFF), 0)
    return color
end

local function imguiText(text, color, newLine)
    color = color or 0xFFFFFFFF
    newLine = newLine or false

    if newLine == false then
        imgui.SameLine(0, 0)
    end

    local c = GetColorAsFloats(color)
    imgui.TextColored(c[1], c[2], c[3], c[4], text)
end

-- Text functions
local function Text(newLine, fmt, ...)
    return TextC(newLine, 0xFFFFFFFF, fmt, ...)
end
local function TextC(newLine, col, fmt, ...)
    newLine = newLine or false
    col = col or 0xFFFFFFFF
    fmt = fmt or "nil"

    if newLine == false then
        imgui.SameLine(0, 0)
    end

    local c = GetColorAsFloats(col)
    local str = string.format(fmt, ...)
    imgui.TextColored(c[1], c[2], c[3], c[4], str)
    return str
end

local function imguiProgressBar(progress, x, y, overlay, barColor, textColor, newLine)
    x = x or -1.0
    y = y or 0.0
    barColor = barColor or 0xFFFFFFFF
    textColor = textColor or 0xFFFFFFFF
    newLine = newLine or false

    if progress == nil then
        imgui.Text("imguiProgressBar() Invalid progress")
        return
    end

    if newLine == false then
        imgui.SameLine(0, 0)
    end

    local c = GetColorAsFloats(textColor)
    imgui.PushStyleColor("Text", c[1], c[2], c[3], c[4])
    c = GetColorAsFloats(barColor)
    imgui.PushStyleColor("PlotHistogram", c[1], c[2], c[3], c[4])
    imgui.ProgressBar(progress, x, y, overlay)
    imgui.PopStyleColor(2)
end

return
{
    GetColorAsFloats = GetColorAsFloats,
    HPToGreenRedGradient = HPToGreenRedGradient,
    imguiText = imguiText,
    Text = Text,
    TextC = TextC,
    imguiProgressBar = imguiProgressBar,
}
