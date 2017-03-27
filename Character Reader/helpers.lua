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

return
{
    tablelength = tablelength,
    tableMerge = tableMerge,
    imguiPrint = imguiPrint,
}