local themeLoaded, theme = pcall(require, "Theme Editor.theme_custom")

if themeLoaded == false then
    theme = require("Theme Editor.theme_default")
end

return
{
    Push = theme.Push,
    Pop = theme.Pop,
}
