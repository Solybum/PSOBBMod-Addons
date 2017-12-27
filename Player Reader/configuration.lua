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
            if imgui.Checkbox("No move", _configuration.playersNoMove == "NoMove") then
                if _configuration.playersNoMove == "NoMove" then
                    _configuration.playersNoMove = ""
                else
                    _configuration.playersNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.playersTransparentWindow) then
                _configuration.playersTransparentWindow = not _configuration.playersTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
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

        if imgui.TreeNodeEx("P1") then
            if imgui.Checkbox("Enable", _configuration.p1EnableWindow) then
                _configuration.p1EnableWindow = not _configuration.p1EnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.p1NoTitleBar == "NoTitleBar") then
                if _configuration.p1NoTitleBar == "NoTitleBar" then
                    _configuration.p1NoTitleBar = ""
                else
                    _configuration.p1NoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.p1NoResize == "NoResize") then
                if _configuration.p1NoResize == "NoResize" then
                    _configuration.p1NoResize = ""
                else
                    _configuration.p1NoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.p1NoMove == "NoMove") then
                if _configuration.p1NoMove == "NoMove" then
                    _configuration.p1NoMove = ""
                else
                    _configuration.p1NoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.p1NoScrollbar == "NoScrollbar") then
                if _configuration.p1NoScrollbar == "NoScrollbar" then
                    _configuration.p1NoScrollbar = ""
                else
                    _configuration.p1NoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent Window", _configuration.p1TransparentWindow) then
                _configuration.p1TransparentWindow = not _configuration.p1TransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.p1Anchor = imgui.Combo("Anchor", _configuration.p1Anchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.p1Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.p1X = imgui.InputInt("X", _configuration.p1X)
            imgui.PopItemWidth()
            if success then
                _configuration.p1Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.p1Y = imgui.InputInt("Y", _configuration.p1Y)
            imgui.PopItemWidth()
            if success then
                _configuration.p1Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.p1W = imgui.InputInt("Width", _configuration.p1W)
            imgui.PopItemWidth()
            if success then
                _configuration.p1Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.p1H = imgui.InputInt("Height", _configuration.p1H)
            imgui.PopItemWidth()
            if success then
                _configuration.p1Changed = true
                this.changed = true
            end

            if imgui.Checkbox("S/D (J/Z)", _configuration.p1SD) then
                _configuration.p1SD = not _configuration.p1SD
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
