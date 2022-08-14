-- Helper functions to get PSO's resolution Width and Height. 
-- Read the instructions containing address of a global passed to the device creation, and then
-- use that. Generally the same as the old globals read unless the client has SSAA enabled.
local function GetResolutionWidth()
    return pso.read_u32(pso.read_u32(0x82D140))
end

local function GetResolutionHeight()
    return pso.read_u32(pso.read_u32(0x82D18A))
end

local function GetPosBySizeAndAnchor(_x, _y, _w, _h, _anchor)
    local x
    local y

    local resW = GetResolutionWidth()
    local resH = GetResolutionHeight()

    -- Top left
    if _anchor == 1 then
        x = _x
        y = _y

    -- Left
    elseif _anchor == 2 then
        x = _x
        y = (resH / 2) - (_h / 2) + _y

    -- Bottom left
    elseif _anchor == 3 then
        x = _x
        y = resH - _h + _y

    -- Top
    elseif _anchor == 4 then
        x = (resW / 2) - (_w / 2) + _x
        y = _y

    -- Center
    elseif _anchor == 5 then
        x = (resW / 2) - (_w / 2) + _x
        y = (resH / 2) - (_h / 2) + _y

    -- Bottom
    elseif _anchor == 6 then
        x = (resW / 2) - (_w / 2) + _x
        y = resH - _h + _y

    -- Top right
    elseif _anchor == 7 then
        x = resW - _w + _x
        y = _y

    -- Right
    elseif _anchor == 8 then
        x = resW - _w + _x
        y = (resH / 2) - (_h / 2) + _y

    -- Bottom right
    elseif _anchor == 9 then
        x = resW - _w + _x
        y = resH - _h + _y

    -- Whatever
    else
        x = _x
        y = _y
    end

    return { x, y }
end

local function WindowPositionAndSize(windowName, X, Y, W, H, Anchor, AlwaysAutoResize, setSizeFromParams)
    local setSize = false
    local windowW = imgui.GetWindowWidth()
    local windowH = imgui.GetWindowHeight()

    if setSizeFromParams then
        windowW = W
        windowH = H
        if AlwaysAutoResize ~= "AlwaysAutoResize" then
            setSize = true
        end
    end

    if setSize then
        imgui.SetWindowSize(windowName, windowW, windowH, "Always");
    end

    local ps = GetPosBySizeAndAnchor(
        X,
        Y,
        windowW,
        windowH,
        Anchor)

    if Anchor ~= 1 then
        imgui.SetWindowPos(windowName, ps[1], ps[2], "Always");
    end
end

local function Round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function F32ToInt8(value)
    return Round(value * 255)
end

local function GetColorAsFloats(color)
    color = color or 0xFFFFFFFF

    local a = bit.band(bit.rshift(color, 24), 0xFF) / 255;
    local r = bit.band(bit.rshift(color, 16), 0xFF) / 255;
    local g = bit.band(bit.rshift(color, 8), 0xFF) / 255;
    local b = bit.band(color, 0xFF) / 255;

    return { r = r, g = g, b = b, a = a }
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

local function NotNilOrDefault(value, default)
    if value == nil then
        return default
    else
        return value
    end
end

-- Text functions
local function TextC(newLine, col, fmt, ...)
    newLine = newLine or false
    col = col or 0xFFFFFFFF
    fmt = fmt or "nil"

    if newLine == false then
        imgui.SameLine(0, 0)
    end

    local c = GetColorAsFloats(col)
    local str = string.format(fmt, ...)
    imgui.TextColored(c.r, c.g, c.b, c.a, str)
    return str
end
local function Text(newLine, fmt, ...)
    return TextC(newLine, 0xFFFFFFFF, fmt, ...)
end

local function imguiProgressBar(newLine, progress, x, y, barColor, textColor, fmt, ...)
    newLine = newLine or false
    progress = progress or 0
    x = x or -1.0
    y = y or 0.0
    fmt = fmt or ""

    local overlay = string.format(fmt, ...)

    if newLine == false then
        imgui.SameLine(0, 0)
    end

    if barColor ~= nil then
        local c = GetColorAsFloats(barColor)
        imgui.PushStyleColor("PlotHistogram", c.r, c.g, c.b, c.a)
    end
    if textColor ~= nil then
        local c = GetColorAsFloats(textColor)
        imgui.PushStyleColor("Text", c.r, c.g, c.b, c.a)
    end

    imgui.ProgressBar(progress, x, y, overlay)

    if textColor ~= nil then
        imgui.PopStyleColor()
    end
    if barColor ~= nil then
        imgui.PopStyleColor()
    end
end

return
{
    GetResolutionWidth = GetResolutionWidth,
    GetResolutionHeight = GetResolutionHeight,
    GetPosBySizeAndAnchor = GetPosBySizeAndAnchor,
    WindowPositionAndSize = WindowPositionAndSize,
    Round = Round,
    F32ToInt8 = F32ToInt8,
    GetColorAsFloats = GetColorAsFloats,
    HPToGreenRedGradient = HPToGreenRedGradient,
    NotNilOrDefault = NotNilOrDefault,
    imguiText = imguiText,
    Text = Text,
    TextC = TextC,
    imguiProgressBar = imguiProgressBar,
}
