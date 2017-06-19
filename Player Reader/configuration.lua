local function ConfigurationWindow(configuration)
    local this = 
    {
        title = "Player Reader - Configuration",
        fontScale = 1.0,
        open = false,
        changed = false,
    }

    local _configuration = configuration

    local _showWindowSettings = function()
        local success
        local anchorList =
        {
            "Top Left (Disabled)", "Left", "Bottom Left",
            "Top", "Center", "Bottom",
            "Top Right", "Right", "Bottom Right",
        }

        if imgui.TreeNodeEx("General", "DefaultOpen") then
            if imgui.Checkbox("Enable", _configuration.enable) then
                _configuration.enable = not _configuration.enable
                this.changed = true
            end

            if imgui.Checkbox("Use custom theme", _configuration.useCustomTheme) then
                _configuration.useCustomTheme = not _configuration.useCustomTheme
                this.changed = true
            end

            success, _configuration.fontScale = imgui.InputFloat("Font Scale", _configuration.fontScale)
            if success then
                this.changed = true
            end
            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Players") then
            if imgui.Checkbox("Enable", _configuration.playersEnableWindow) then
                _configuration.playersEnableWindow = not _configuration.playersEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.playersNoTitleBar == "NoTitleBar") then
                if _configuration.playersNoTitleBar == "NoTitleBar" then
                    _configuration.playersNoTitleBar = ""
                else
                    _configuration.playersNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.playersNoResize == "NoResize") then
                if _configuration.playersNoResize == "NoResize" then
                    _configuration.playersNoResize = ""
                else
                    _configuration.playersNoResize = "NoResize"
                end
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(150)
            success, _configuration.playersAnchor = imgui.Combo("Anchor", _configuration.playersAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.playersChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.playersX = imgui.InputInt("X", _configuration.playersX)
            imgui.PopItemWidth()
            if success then
                _configuration.playersChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.playersY = imgui.InputInt("Y", _configuration.playersY)
            imgui.PopItemWidth()
            if success then
                _configuration.playersChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.playersW = imgui.InputInt("Width", _configuration.playersW)
            imgui.PopItemWidth()
            if success then
                _configuration.playersChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.playersH = imgui.InputInt("Height", _configuration.playersH)
            imgui.PopItemWidth()
            if success then
                _configuration.playersChanged = true
                this.changed = true
            end
            imgui.TreePop()
        end
    end

    this.Update = function()
        if this.open == false then
            return
        end

        local success

        imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
        success, this.open = imgui.Begin(this.title, this.open)
        imgui.SetWindowFontScale(this.fontScale)

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return 
{
    ConfigurationWindow = ConfigurationWindow,
}
