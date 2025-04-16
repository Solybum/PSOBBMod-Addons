local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Player Reader - Configuration",
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

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("All players") then
            if imgui.Checkbox("Enable", _configuration.allPlayersEnableWindow) then
                _configuration.allPlayersEnableWindow = not _configuration.allPlayersEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("Hide when menus are open", _configuration.allHideWhenMenu) then
                _configuration.allHideWhenMenu = not _configuration.allHideWhenMenu
                this.changed = true
            end

            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.allHideWhenSymbolChat) then
                _configuration.allHideWhenSymbolChat = not _configuration.allHideWhenSymbolChat
                this.changed = true
            end

            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.allHideWhenMenuUnavailable) then
                _configuration.allHideWhenMenuUnavailable = not _configuration.allHideWhenMenuUnavailable
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.allPlayersNoTitleBar == "NoTitleBar") then
                if _configuration.allPlayersNoTitleBar == "NoTitleBar" then
                    _configuration.allPlayersNoTitleBar = ""
                else
                    _configuration.allPlayersNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end

            if imgui.Checkbox("No resize", _configuration.allPlayersNoResize == "NoResize") then
                if _configuration.allPlayersNoResize == "NoResize" then
                    _configuration.allPlayersNoResize = ""
                else
                    _configuration.allPlayersNoResize = "NoResize"
                end
                this.changed = true
            end

            if imgui.Checkbox("No move", _configuration.allPlayersNoMove == "NoMove") then
                if _configuration.allPlayersNoMove == "NoMove" then
                    _configuration.allPlayersNoMove = ""
                else
                    _configuration.allPlayersNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.allPlayersTransparentWindow) then
                _configuration.allPlayersTransparentWindow = not _configuration.allPlayersTransparentWindow
                this.changed = true
            end

            if imgui.Checkbox("Display horizontal", _configuration.allPlayersListHorizontal) then
                _configuration.allPlayersListHorizontal = not _configuration.allPlayersListHorizontal
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.allPlayersListMaxLength = imgui.InputInt("Maximum players to display",
                _configuration.allPlayersListMaxLength)
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end

            if imgui.TreeNodeEx("Columns") then
                if imgui.Checkbox("Show Index", _configuration.allPlayersShowIndex) then
                    _configuration.allPlayersShowIndex = not _configuration.allPlayersShowIndex
                    this.changed = true
                end

                if imgui.Checkbox("Show player names", _configuration.allPlayersShowName) then
                    _configuration.allPlayersShowName = not _configuration.allPlayersShowName
                    this.changed = true
                end

                if imgui.Checkbox("Show player HP bar", _configuration.allPlayersShowHpBar) then
                    _configuration.allPlayersShowHpBar = not _configuration.allPlayersShowHpBar
                    this.changed = true
                end

                if imgui.Checkbox("Show player buffs", _configuration.allPlayersShowBuff) then
                    _configuration.allPlayersShowBuff = not _configuration.allPlayersShowBuff
                    this.changed = true
                end
                imgui.TreePop()
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.allPlayersAnchor = imgui.Combo("Anchor", _configuration.allPlayersAnchor, anchorList,
                table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.allPlayersX = imgui.InputInt("X", _configuration.allPlayersX)
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.allPlayersY = imgui.InputInt("Y", _configuration.allPlayersY)
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.allPlayersW = imgui.InputInt("Width", _configuration.allPlayersW)
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.allPlayersH = imgui.InputInt("Height", _configuration.allPlayersH)
            imgui.PopItemWidth()
            if success then
                _configuration.allPlayersChanged = true
                this.changed = true
            end
            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Single players") then
            if imgui.Checkbox("Enable", _configuration.singlePlayersEnableWindow) then
                _configuration.singlePlayersEnableWindow = not _configuration.singlePlayersEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("Show HP text", _configuration.singlePlayersShowBarText) then
                _configuration.singlePlayersShowBarText = not _configuration.singlePlayersShowBarText
                this.changed = true
            end
            if imgui.Checkbox("Show Max HP", _configuration.singlePlayersShowBarMaxValue) then
                _configuration.singlePlayersShowBarMaxValue = not _configuration.singlePlayersShowBarMaxValue
                this.changed = true
            end

            for i = 1, 4, 1 do
                local singlePlayerTitle = string.format("Player %d", i)
                if imgui.TreeNodeEx(singlePlayerTitle) then
                    if imgui.Checkbox("Enable", _configuration.players[i].EnableWindow) then
                        _configuration.players[i].EnableWindow = not _configuration.players[i].EnableWindow
                        this.changed = true
                    end

                    if imgui.Checkbox("Hide when menus are open", _configuration.players[i].HideWhenMenu) then
                        _configuration.players[i].HideWhenMenu = not _configuration.players[i].HideWhenMenu
                        this.changed = true
                    end

                    if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.players[i].HideWhenSymbolChat) then
                        _configuration.players[i].HideWhenSymbolChat = not _configuration.players[i].HideWhenSymbolChat
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide when menu is unavailable", _configuration.players[i].HideWhenMenuUnavailable) then
                        _configuration.players[i].HideWhenMenuUnavailable = not _configuration.players[i]
                            .HideWhenMenuUnavailable
                        this.changed = true
                    end

                    if imgui.Checkbox("Show Character Name and Level", _configuration.players[i].ShowName) then
                        _configuration.players[i].ShowName = not _configuration.players[i].ShowName
                        this.changed = true
                    end

                    if imgui.Checkbox("Show HP bar", _configuration.players[i].ShowHPBar) then
                        _configuration.players[i].ShowHPBar = not _configuration.players[i].ShowHPBar
                        this.changed = true
                    end
                    if imgui.Checkbox("Show Shifta/Deband (Jellen/Zalure)", _configuration.players[i].SD) then
                        _configuration.players[i].SD = not _configuration.players[i].SD
                        this.changed = true
                    end

                    if imgui.Checkbox("Show Invincibility", _configuration.players[i].Invulnerability) then
                        _configuration.players[i].Invulnerability = not _configuration.players[i].Invulnerability
                        this.changed = true
                    end

                    if imgui.Checkbox("No title bar", _configuration.players[i].NoTitleBar == "NoTitleBar") then
                        if _configuration.players[i].NoTitleBar == "NoTitleBar" then
                            _configuration.players[i].NoTitleBar = ""
                        else
                            _configuration.players[i].NoTitleBar = "NoTitleBar"
                        end
                        this.changed = true
                    end

                    if imgui.Checkbox("No resize", _configuration.players[i].NoResize == "NoResize") then
                        if _configuration.players[i].NoResize == "NoResize" then
                            _configuration.players[i].NoResize = ""
                        else
                            _configuration.players[i].NoResize = "NoResize"
                        end
                        this.changed = true
                    end

                    if imgui.Checkbox("No move", _configuration.players[i].NoMove == "NoMove") then
                        if _configuration.players[i].NoMove == "NoMove" then
                            _configuration.players[i].NoMove = ""
                        else
                            _configuration.players[i].NoMove = "NoMove"
                        end

                        this.changed = true
                    end
                    if imgui.Checkbox("No scrollbar", _configuration.players[i].NoScrollbar == "NoScrollbar") then
                        if _configuration.players[i].NoScrollbar == "NoScrollbar" then
                            _configuration.players[i].NoScrollbar = ""
                        else
                            _configuration.players[i].NoScrollbar = "NoScrollbar"
                        end

                        this.changed = true
                    end

                    if imgui.Checkbox("Always auto resize", _configuration.players[i].AlwaysAutoResize == "AlwaysAutoResize") then
                        if _configuration.players[i].AlwaysAutoResize == "AlwaysAutoResize" then
                            _configuration.players[i].AlwaysAutoResize = ""
                        else
                            _configuration.players[i].AlwaysAutoResize = "AlwaysAutoResize"
                        end

                        this.changed = true
                    end

                    if imgui.Checkbox("Transparent Window", _configuration.players[i].TransparentWindow) then
                        _configuration.players[i].TransparentWindow = not _configuration.players[i].TransparentWindow
                        this.changed = true
                    end

                    imgui.Text("Position and Size")
                    imgui.PushItemWidth(200)
                    success, _configuration.players[i].Anchor = imgui.Combo("Anchor", _configuration.players[i].Anchor,
                        anchorList, table.getn(anchorList))
                    imgui.PopItemWidth()
                    if success then
                        _configuration.players[i].Changed = true
                        this.changed = true
                    end

                    imgui.PushItemWidth(100)
                    success, _configuration.players[i].X = imgui.InputInt("X", _configuration.players[i].X)
                    imgui.PopItemWidth()
                    if success then
                        _configuration.players[i].Changed = true
                        this.changed = true
                    end

                    imgui.SameLine(0, 38)
                    imgui.PushItemWidth(100)
                    success, _configuration.players[i].Y = imgui.InputInt("Y", _configuration.players[i].Y)
                    imgui.PopItemWidth()
                    if success then
                        _configuration.players[i].Changed = true
                        this.changed = true
                    end

                    imgui.PushItemWidth(100)
                    success, _configuration.players[i].W = imgui.InputInt("Width", _configuration.players[i].W)
                    imgui.PopItemWidth()
                    if success then
                        _configuration.players[i].Changed = true
                        this.changed = true
                    end

                    imgui.SameLine(0, 10)
                    imgui.PushItemWidth(100)
                    success, _configuration.players[i].H = imgui.InputInt("Height", _configuration.players[i].H)
                    imgui.PopItemWidth()
                    if success then
                        _configuration.players[i].Changed = true
                        this.changed = true
                    end

                    imgui.TreePop()
                end
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Myself") then
            if imgui.Checkbox("Enable", _configuration.myself.EnableWindow) then
                _configuration.myself.EnableWindow = not _configuration.myself.EnableWindow
                this.changed = true
            end

            if imgui.Checkbox("Hide when menus are open", _configuration.myself.HideWhenMenu) then
                _configuration.myself.HideWhenMenu = not _configuration.myself.HideWhenMenu
                this.changed = true
            end

            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.myself.HideWhenSymbolChat) then
                _configuration.myself.HideWhenSymbolChat = not _configuration.myself.HideWhenSymbolChat
                this.changed = true
            end

            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.myself.HideWhenMenuUnavailable) then
                _configuration.myself.HideWhenMenuUnavailable = not _configuration.myself.HideWhenMenuUnavailable
                this.changed = true
            end

            if imgui.Checkbox("Show Character Name and Level", _configuration.myself.ShowName) then
                _configuration.myself.ShowName = not _configuration.myself.ShowName
                this.changed = true
            end

            if imgui.Checkbox("Show HP text", _configuration.myself.ShowBarText) then
                _configuration.myself.ShowBarText = not _configuration.myself.ShowBarText
                this.changed = true
            end

            if imgui.Checkbox("Show Max HP", _configuration.myself.ShowBarMaxValue) then
                _configuration.myself.ShowBarMaxValue = not _configuration.myself.ShowBarMaxValue
                this.changed = true
            end

            if imgui.Checkbox("Show HP bar", _configuration.myself.ShowHPBar) then
                _configuration.myself.ShowHPBar = not _configuration.myself.ShowHPBar
                this.changed = true
            end

            if imgui.Checkbox("Show Shifta/Deband (Jellen/Zalure)", _configuration.myself.SD) then
                _configuration.myself.SD = not _configuration.myself.SD
                this.changed = true
            end

            if imgui.Checkbox("Show Invincibility", _configuration.myself.Invulnerability) then
                _configuration.myself.Invulnerability = not _configuration.myself.Invulnerability
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.myself.NoTitleBar == "NoTitleBar") then
                if _configuration.myself.NoTitleBar == "NoTitleBar" then
                    _configuration.myself.NoTitleBar = ""
                else
                    _configuration.myself.NoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end

            if imgui.Checkbox("No resize", _configuration.myself.NoResize == "NoResize") then
                if _configuration.myself.NoResize == "NoResize" then
                    _configuration.myself.NoResize = ""
                else
                    _configuration.myself.NoResize = "NoResize"
                end
                this.changed = true
            end

            if imgui.Checkbox("No move", _configuration.myself.NoMove == "NoMove") then
                if _configuration.myself.NoMove == "NoMove" then
                    _configuration.myself.NoMove = ""
                else
                    _configuration.myself.NoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("No scrollbar", _configuration.myself.NoScrollbar == "NoScrollbar") then
                if _configuration.myself.NoScrollbar == "NoScrollbar" then
                    _configuration.myself.NoScrollbar = ""
                else
                    _configuration.myself.NoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Always auto resize", _configuration.myself.AlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.myself.AlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.myself.AlwaysAutoResize = ""
                else
                    _configuration.myself.AlwaysAutoResize = "AlwaysAutoResize"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent Window", _configuration.myself.TransparentWindow) then
                _configuration.myself.TransparentWindow = not _configuration.myself.TransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.myself.Anchor = imgui.Combo("Anchor", _configuration.myself.Anchor, anchorList,
                table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.myself.Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.myself.X = imgui.InputInt("X", _configuration.myself.X)
            imgui.PopItemWidth()
            if success then
                _configuration.myself.Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.myself.Y = imgui.InputInt("Y", _configuration.myself.Y)
            imgui.PopItemWidth()
            if success then
                _configuration.myself.Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.myself.W = imgui.InputInt("Width", _configuration.myself.W)
            imgui.PopItemWidth()
            if success then
                _configuration.myself.Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.myself.H = imgui.InputInt("Height", _configuration.myself.H)
            imgui.PopItemWidth()
            if success then
                _configuration.myself.Changed = true
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

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return
{
    ConfigurationWindow = ConfigurationWindow,
}
