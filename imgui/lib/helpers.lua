function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function tableMerge(t1, t2)
   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end

-- By default it will print on the same line
local function imguiPrint(text, color, newline)
    color = color or cfg.white
    newline = newline or false

    if newline == false then
        imgui.SameLine(0, 0)
    end
    
    a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    b = bit.band(color, 0xFF) / 255;

    imgui.TextColored(r, g, b, a, text)
end

local imguiProgressBar = function(progress, x, y, overlay, barColor, textColor)
    x = x or -1.0
    y = y or 0.0
    barColor = barColor or 0xFFFFFFFF
    textColor = textColor or 0xFFFFFFFF
    
    if progress == nil then
        imgui.Text("imguiProgressBar() Invalid progress")
        return
    end

    a = bit.band(bit.rshift(textColor, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(textColor, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(textColor, 8), 0xFF) / 255;
    b = bit.band(textColor, 0xFF) / 255;
    imgui.PushStyleColor("Text", r, g, b, a)

    a = bit.band(bit.rshift(barColor, 24), 0xFF) / 255;
    r = bit.band(bit.rshift(barColor, 16), 0xFF) / 255;
    g = bit.band(bit.rshift(barColor, 8), 0xFF) / 255;
    b = bit.band(barColor, 0xFF) / 255;
    imgui.PushStyleColor("PlotHistogram", r, g, b, a)
    imgui.ProgressBar(progress, x, y, overlay)
    imgui.PopStyleColor(2)
end

return
{
    tablelength = tablelength,
    tableMerge = tableMerge,
    imguiPrint = imguiPrint,
    imguiProgressBar = imguiProgressBar,
}