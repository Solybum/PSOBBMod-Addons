local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Timer - Configuration",
        open = false,
        changed = false,
    }

    local keysLoaded, keys = pcall(require, "solylib.keys")

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

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Stopwatch") then
            if imgui.Checkbox("Enable", _configuration.stopwatchEnableWindow) then
                _configuration.stopwatchEnableWindow = not _configuration.stopwatchEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.stopwatchNoTitleBar == "NoTitleBar") then
                if _configuration.stopwatchNoTitleBar == "NoTitleBar" then
                    _configuration.stopwatchNoTitleBar = ""
                else
                    _configuration.stopwatchNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.stopwatchNoResize == "NoResize") then
                if _configuration.stopwatchNoResize == "NoResize" then
                    _configuration.stopwatchNoResize = ""
                else
                    _configuration.stopwatchNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.stopwatchNoMove == "NoMove") then
                if _configuration.stopwatchNoMove == "NoMove" then
                    _configuration.stopwatchNoMove = ""
                else
                    _configuration.stopwatchNoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.stopwatchNoScrollbar == "NoScrollbar") then
                if _configuration.stopwatchNoScrollbar == "NoScrollbar" then
                    _configuration.stopwatchNoScrollbar = ""
                else
                    _configuration.stopwatchNoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end
            if imgui.Checkbox("Always Auto Resize", _configuration.stopwatchAlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.stopwatchAlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.stopwatchAlwaysAutoResize = ""
                else
                    _configuration.stopwatchAlwaysAutoResize = "AlwaysAutoResize"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.stopwatchTransparentWindow) then
                _configuration.stopwatchTransparentWindow = not _configuration.stopwatchTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.stopwatchAnchor = imgui.Combo("Anchor", _configuration.stopwatchAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.stopwatchChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.stopwatchX = imgui.InputInt("X", _configuration.stopwatchX)
            imgui.PopItemWidth()
            if success then
                _configuration.stopwatchChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.stopwatchY = imgui.InputInt("Y", _configuration.stopwatchY)
            imgui.PopItemWidth()
            if success then
                _configuration.stopwatchChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.stopwatchW = imgui.InputInt("Width", _configuration.stopwatchW)
            imgui.PopItemWidth()
            if success then
                _configuration.stopwatchChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.stopwatchH = imgui.InputInt("Height", _configuration.stopwatchH)
            imgui.PopItemWidth()
            if success then
                _configuration.stopwatchChanged = true
                this.changed = true
            end

            if keysLoaded and imgui.TreeNodeEx("Hotkeys") then
                imgui.PushItemWidth(200)
                success, _configuration.stopwatchHotkeysStart = imgui.Combo("Start", _configuration.stopwatchHotkeysStart, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.stopwatchChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.stopwatchHotkeysStop = imgui.Combo("Stop", _configuration.stopwatchHotkeysStop, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.stopwatchChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.stopwatchHotkeysResume = imgui.Combo("Resume", _configuration.stopwatchHotkeysResume, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.stopwatchChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.stopwatchHotkeysReset = imgui.Combo("Reset", _configuration.stopwatchHotkeysReset, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.stopwatchChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.stopwatchHotkeysSplit = imgui.Combo("Split", _configuration.stopwatchHotkeysSplit, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.stopwatchChanged = true
                    this.changed = true
                end
                imgui.TreePop()
            end
            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Countdown") then
            if imgui.Checkbox("Enable", _configuration.countdownEnableWindow) then
                _configuration.countdownEnableWindow = not _configuration.countdownEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.countdownNoTitleBar == "NoTitleBar") then
                if _configuration.countdownNoTitleBar == "NoTitleBar" then
                    _configuration.countdownNoTitleBar = ""
                else
                    _configuration.countdownNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.countdownNoResize == "NoResize") then
                if _configuration.countdownNoResize == "NoResize" then
                    _configuration.countdownNoResize = ""
                else
                    _configuration.countdownNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.countdownNoMove == "NoMove") then
                if _configuration.countdownNoMove == "NoMove" then
                    _configuration.countdownNoMove = ""
                else
                    _configuration.countdownNoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.countdownNoScrollbar == "NoScrollbar") then
                if _configuration.countdownNoScrollbar == "NoScrollbar" then
                    _configuration.countdownNoScrollbar = ""
                else
                    _configuration.countdownNoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end
            if imgui.Checkbox("Always Auto Resize", _configuration.countdownAlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.countdownAlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.countdownAlwaysAutoResize = ""
                else
                    _configuration.countdownAlwaysAutoResize = "AlwaysAutoResize"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.countdownTransparentWindow) then
                _configuration.countdownTransparentWindow = not _configuration.countdownTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.countdownAnchor = imgui.Combo("Anchor", _configuration.countdownAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.countdownChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.countdownX = imgui.InputInt("X", _configuration.countdownX)
            imgui.PopItemWidth()
            if success then
                _configuration.countdownChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.countdownY = imgui.InputInt("Y", _configuration.countdownY)
            imgui.PopItemWidth()
            if success then
                _configuration.countdownChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.countdownW = imgui.InputInt("Width", _configuration.countdownW)
            imgui.PopItemWidth()
            if success then
                _configuration.countdownChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.countdownH = imgui.InputInt("Height", _configuration.countdownH)
            imgui.PopItemWidth()
            if success then
                _configuration.countdownChanged = true
                this.changed = true
            end

            if keysLoaded and imgui.TreeNodeEx("Hotkeys") then
                imgui.PushItemWidth(200)
                success, _configuration.countdownHotkeysStart = imgui.Combo("Start", _configuration.countdownHotkeysStart, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.countdownChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.countdownHotkeysStop = imgui.Combo("Stop", _configuration.countdownHotkeysStop, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.countdownChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.countdownHotkeysResume = imgui.Combo("Resume", _configuration.countdownHotkeysResume, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.countdownChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.countdownHotkeysReset = imgui.Combo("Reset", _configuration.countdownHotkeysReset, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.countdownChanged = true
                    this.changed = true
                end

                imgui.PushItemWidth(200)
                success, _configuration.countdownHotkeysAdd30 = imgui.Combo("Add 30 Seconds", _configuration.countdownHotkeysAdd30, keys.keys, table.getn(keys.keys))
                imgui.PopItemWidth()
                if success then
                    _configuration.countdownChanged = true
                    this.changed = true
                end
                imgui.TreePop()
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

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return
{
    ConfigurationWindow = ConfigurationWindow,
}
