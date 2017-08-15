local function ConfigurationWindow(configuration)
    local this = 
    {
        title = "Monster Reader - Configuration",
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

            if imgui.Checkbox("Invert monster list", _configuration.invertMonsterList) then
                _configuration.invertMonsterList = not _configuration.invertMonsterList
                this.changed = true
            end
            if imgui.Checkbox("Show current room only", _configuration.showCurrentRoomOnly) then
                _configuration.showCurrentRoomOnly = not _configuration.showCurrentRoomOnly
                this.changed = true
            end
            if imgui.Checkbox("Show monster status", _configuration.showMonsterStatus) then
                _configuration.showMonsterStatus = not _configuration.showMonsterStatus
                this.changed = true
            end
            if imgui.Checkbox("Show monster ID", _configuration.showMonsterID) then
                _configuration.showMonsterID = not _configuration.showMonsterID
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("HP") then
            if imgui.Checkbox("Enable", _configuration.mhpEnableWindow) then
                _configuration.mhpEnableWindow = not _configuration.mhpEnableWindow
                this.changed = true
            end
            
            if imgui.Checkbox("No title bar", _configuration.mhpNoTitleBar == "NoTitleBar") then
                if _configuration.mhpNoTitleBar == "NoTitleBar" then
                    _configuration.mhpNoTitleBar = ""
                else
                    _configuration.mhpNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.mhpNoResize == "NoResize") then
                if _configuration.mhpNoResize == "NoResize" then
                    _configuration.mhpNoResize = ""
                else
                    _configuration.mhpNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.mhpNoMove == "NoMove") then
                if _configuration.mhpNoMove == "NoMove" then
                    _configuration.mhpNoMove = ""
                else
                    _configuration.mhpNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.mhpTransparentWindow) then
                _configuration.mhpTransparentWindow = not _configuration.mhpTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.mhpAnchor = imgui.Combo("Anchor", _configuration.mhpAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end
            
            imgui.PushItemWidth(100)
            success, _configuration.mhpX = imgui.InputInt("X", _configuration.mhpX)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end
            
            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.mhpY = imgui.InputInt("Y", _configuration.mhpY)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end
            
            imgui.PushItemWidth(100)
            success, _configuration.mhpW = imgui.InputInt("Width", _configuration.mhpW)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end
            
            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.mhpH = imgui.InputInt("Height", _configuration.mhpH)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Target") then
            if imgui.Checkbox("Enable", _configuration.targetEnableWindow) then
                _configuration.targetEnableWindow = not _configuration.targetEnableWindow
                this.changed = true
            end
            
            if imgui.Checkbox("No title bar", _configuration.targetNoTitleBar == "NoTitleBar") then
                if _configuration.targetNoTitleBar == "NoTitleBar" then
                    _configuration.targetNoTitleBar = ""
                else
                    _configuration.targetNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.targetNoResize == "NoResize") then
                if _configuration.targetNoResize == "NoResize" then
                    _configuration.targetNoResize = ""
                else
                    _configuration.targetNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.targetNoMove == "NoMove") then
                if _configuration.targetNoMove == "NoMove" then
                    _configuration.targetNoMove = ""
                else
                    _configuration.targetNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.targetTransparentWindow) then
                _configuration.targetTransparentWindow = not _configuration.targetTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.targetAnchor = imgui.Combo("Anchor", _configuration.targetAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end
            
            imgui.PushItemWidth(100)
            success, _configuration.targetX = imgui.InputInt("X", _configuration.targetX)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end
            
            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.targetY = imgui.InputInt("Y", _configuration.targetY)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end
            
            imgui.PushItemWidth(100)
            success, _configuration.targetW = imgui.InputInt("Width", _configuration.targetW)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end
            
            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.targetH = imgui.InputInt("Height", _configuration.targetH)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
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
