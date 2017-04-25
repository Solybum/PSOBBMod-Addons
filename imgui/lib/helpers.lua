function tableMerge(t1, t2)
   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end

local function GetColorAsFloats(color)
    color = color or 0xFFFFFFFF

    a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    b = bit.band(color, 0xFF) / 255;

    return {r, g, b, a}
end

-- Prints text in the same line, with the given color
local function imguiText(text, color)
    color = color or cfg.white

    c = GetColorAsFloats(color)

    imgui.SameLine(0, 0)
    imgui.TextColored(c[1], c[2], c[3], c[4], text)
end
-- Prints text in a new line, with the given color
local function imguiTextLine(text, color)
    color = color or cfg.white

    if newline == false then
        imgui.SameLine(0, 0)
    end
    
    c = GetColorAsFloats(color)
    imgui.TextColored(c[1], c[2], c[3], c[4], text)
end

local function imguiProgressBar(progress, x, y, overlay, barColor, textColor)
    x = x or -1.0
    y = y or 0.0
    barColor = barColor or 0xFFFFFFFF
    textColor = textColor or 0xFFFFFFFF
    
    if progress == nil then
        imgui.Text("imguiProgressBar() Invalid progress")
        return
    end

    c = GetColorAsFloats(textColor)
    imgui.PushStyleColor("Text", c[1], c[2], c[3], c[4])
    c = GetColorAsFloats(barColor)
    imgui.PushStyleColor("PlotHistogram", c[1], c[2], c[3], c[4])
    imgui.ProgressBar(progress, x, y, overlay)
    imgui.PopStyleColor(2)
end

return
{
    tablelength = tablelength,
    tableMerge = tableMerge,
    GetColorAsFloats = GetColorAsFloats,
    imguiText = imguiText,
    imguiTextLine = imguiTextLine,
    imguiProgressBar = imguiProgressBar,
}