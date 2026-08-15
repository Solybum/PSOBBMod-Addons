-- solylib/image.lua
--
-- Thin convenience wrapper around pso.load_texture / pso.unload_texture and
-- the imgui.Image / imgui.ImageButton bindings.
--
-- Textures are cached by absolute-ish key (whatever string the caller passes)
-- so the same file is only loaded once even if many addons request it.
--
-- Lifetime: textures are released automatically when the Lua state reloads
-- (pso.reload), because the C++ side tracks every handle returned by
-- pso.load_texture and frees them before the new state starts. Callers can
-- still free a specific texture early with image.Unload(path).
--
-- Usage:
--     local image = require("solylib.image")
--
--     local function present()
--         -- Display an image at its native size:
--         image.Draw("addons/MyAddon/icon.png")
--
--         -- Or at a specific size:
--         image.Draw("addons/MyAddon/icon.png", 64, 64)
--
--         -- As a clickable button:
--         if image.Button("addons/MyAddon/btn.png", 32, 32) then
--             -- clicked
--         end
--     end

local cache = {}

local function load(path)
    local entry = cache[path]
    if entry and entry.handle then
        return entry
    end

    local handle, w, h = pso.load_texture(path)
    if not handle then
        cache[path] = { handle = nil, error = w or "unknown error" }
        return cache[path]
    end

    entry = { handle = handle, width = w, height = h }
    cache[path] = entry
    return entry
end

local function Draw(path, width, height, tint, border)
    local entry = load(path)
    if not entry.handle then
        imgui.TextColored(1, 0.3, 0.3, 1, "[image] " .. (entry.error or path))
        return false
    end

    local w = width or entry.width
    local h = height or entry.height

    if tint and border then
        imgui.Image(entry.handle, w, h, 0, 0, 1, 1, tint[1], tint[2], tint[3], tint[4],
            border[1], border[2], border[3], border[4])
    elseif tint then
        imgui.Image(entry.handle, w, h, 0, 0, 1, 1, tint[1], tint[2], tint[3], tint[4])
    else
        imgui.Image(entry.handle, w, h)
    end
    return true
end

local function Button(path, width, height, framePadding, bgColor, tint)
    local entry = load(path)
    if not entry.handle then
        return imgui.Button("[missing] " .. path)
    end

    local w = width or entry.width
    local h = height or entry.height
    local pad = framePadding or -1

    if bgColor and tint then
        return imgui.ImageButton(entry.handle, w, h, 0, 0, 1, 1, pad,
            bgColor[1], bgColor[2], bgColor[3], bgColor[4],
            tint[1], tint[2], tint[3], tint[4])
    elseif bgColor then
        return imgui.ImageButton(entry.handle, w, h, 0, 0, 1, 1, pad,
            bgColor[1], bgColor[2], bgColor[3], bgColor[4])
    else
        return imgui.ImageButton(entry.handle, w, h, 0, 0, 1, 1, pad)
    end
end

local function Size(path)
    local entry = load(path)
    if not entry.handle then
        return 0, 0
    end
    return entry.width, entry.height
end

local function Handle(path)
    local entry = load(path)
    return entry.handle, entry.width or 0, entry.height or 0
end

local function Unload(path)
    local entry = cache[path]
    if entry and entry.handle then
        pso.unload_texture(entry.handle)
    end
    cache[path] = nil
end

local function UnloadAll()
    for path, entry in pairs(cache) do
        if entry.handle then
            pso.unload_texture(entry.handle)
        end
        cache[path] = nil
    end
end

return {
    Draw = Draw,
    Button = Button,
    Size = Size,
    Handle = Handle,
    Unload = Unload,
    UnloadAll = UnloadAll,
}
