function tableMerge(t1, t2)
   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end

function GetColorAsFloats(color)
    color = color or 0xFFFFFFFF

    a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    b = bit.band(color, 0xFF) / 255;

    return {r, g, b, a}
end

function HPToGreenRedGradient(percent)
    a = 1 - percent + 0.4
    r = 1 - percent
    g = percent
    b = 0

    if a > 1.0 then
        a = 1.0
    end

    color = 
    bit.lshift(bit.band((a * 255), 0xFF), 24) + 
    bit.lshift(bit.band((r * 255), 0xFF), 16) + 
    bit.lshift(bit.band((g * 255), 0xFF), 8) + 
    bit.lshift(bit.band((b * 255), 0xFF), 0)
    return color
end

function imguiText(text, color, newLine)
    color = color or 0xFFFFFFFF
    newLine = newLine or false
    
    if newLine == false then
        imgui.SameLine(0, 0)
    end

    c = GetColorAsFloats(color)
    imgui.TextColored(c[1], c[2], c[3], c[4], text)
end

function imguiProgressBarLine(progress, x, y, overlay, barColor, textColor)
    
    imguiProgressBar(progress, x, y, overlay, barColor, textColor)
end

function imguiProgressBar(progress, x, y, overlay, barColor, textColor, newLine)
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

    c = GetColorAsFloats(textColor)
    imgui.PushStyleColor("Text", c[1], c[2], c[3], c[4])
    c = GetColorAsFloats(barColor)
    imgui.PushStyleColor("PlotHistogram", c[1], c[2], c[3], c[4])
    imgui.ProgressBar(progress, x, y, overlay)
    imgui.PopStyleColor(2)
end

return
{
    tableMerge = tableMerge,
    GetColorAsFloats = GetColorAsFloats,
    HPToGreenRedGradient = HPToGreenRedGradient,
    imguiText = imguiText,
    imguiProgressBar = imguiProgressBar,
}