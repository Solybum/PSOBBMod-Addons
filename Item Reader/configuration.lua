local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Item Reader - Configuration",
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
        local serverList =
        {
            "Vanilla",
            "Ultima",
            "Ephinea",
            "Schthach",
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

            if imgui.Checkbox("Print item index", _configuration.printItemIndex) then
                _configuration.printItemIndex = not _configuration.printItemIndex
                this.changed = true
            end
            if imgui.Checkbox("Show item IDs", _configuration.showItemIDs) then
                _configuration.showItemIDs = not _configuration.showItemIDs
                this.changed = true
            end
            if imgui.Checkbox("Show item data", _configuration.showItemData) then
                _configuration.showItemData = not _configuration.showItemData
                this.changed = true
            end
            if imgui.Checkbox("Show equipped items", _configuration.showEquippedItems) then
                _configuration.showEquippedItems = not _configuration.showEquippedItems
                this.changed = true
            end
            if imgui.Checkbox("Short photon blast names", _configuration.shortPBNames) then
                _configuration.shortPBNames = not _configuration.shortPBNames
                this.changed = true
            end
            if imgui.Checkbox("Ignore meseta", _configuration.ignoreMeseta) then
                _configuration.ignoreMeseta = not _configuration.ignoreMeseta
                this.changed = true
            end
            if imgui.Checkbox("Invert floor item list", _configuration.invertItemList) then
                _configuration.invertItemList = not _configuration.invertItemList
                this.changed = true
            end
            if imgui.Checkbox("Hide mag stats", _configuration.hideMagStats) then
                _configuration.hideMagStats = not _configuration.hideMagStats
                this.changed = true
            end
            if imgui.Checkbox("Hide mag PBs", _configuration.hideMagPBs) then
                _configuration.hideMagPBs = not _configuration.hideMagPBs
                this.changed = true
            end

            success, _configuration.itemNameLength = imgui.InputInt("Max Item Name Length", _configuration.itemNameLength)
            if success then
                this.changed = true
            end

            imgui.PushItemWidth(200)
            success, _configuration.server = imgui.Combo("Server", _configuration.server, serverList, table.getn(serverList))
            imgui.PopItemWidth()
            if success then
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("AIO") then
            if imgui.Checkbox("Enable", _configuration.aioEnableWindow) then
                _configuration.aioEnableWindow = not _configuration.aioEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.aioNoTitleBar == "NoTitleBar") then
                if _configuration.aioNoTitleBar == "NoTitleBar" then
                    _configuration.aioNoTitleBar = ""
                else
                    _configuration.aioNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.aioNoResize == "NoResize") then
                if _configuration.aioNoResize == "NoResize" then
                    _configuration.aioNoResize = ""
                else
                    _configuration.aioNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.aioNoMove == "NoMove") then
                if _configuration.aioNoMove == "NoMove" then
                    _configuration.aioNoMove = ""
                else
                    _configuration.aioNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.aioTransparentWindow) then
                _configuration.aioTransparentWindow = not _configuration.aioTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.aioAnchor = imgui.Combo("Anchor", _configuration.aioAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.aioChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.aioX = imgui.InputInt("X", _configuration.aioX)
            imgui.PopItemWidth()
            if success then
                _configuration.aioChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.aioY = imgui.InputInt("Y", _configuration.aioY)
            imgui.PopItemWidth()
            if success then
                _configuration.aioChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.aioW = imgui.InputInt("Width", _configuration.aioW)
            imgui.PopItemWidth()
            if success then
                _configuration.aioChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.aioH = imgui.InputInt("Height", _configuration.aioH)
            imgui.PopItemWidth()
            if success then
                _configuration.aioChanged = true
                this.changed = true
            end

            if imgui.Checkbox("Show \"Save to file\" button", _configuration.aioShowButtonSaveToFile) then
                _configuration.aioShowButtonSaveToFile = not _configuration.aioShowButtonSaveToFile
                this.changed = true
            end

            imgui.PushItemWidth(200)
            success, _configuration.aioSaveFileName = imgui.InputText("Save file path", _configuration.aioSaveFileName, 255, 0, nil, _configuration.aioSaveFileName)
            imgui.PopItemWidth()
            if success then
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Floor") then
            if imgui.Checkbox("Enable", _configuration.floorEnableWindow) then
                _configuration.floorEnableWindow = not _configuration.floorEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.floorNoTitleBar == "NoTitleBar") then
                if _configuration.floorNoTitleBar == "NoTitleBar" then
                    _configuration.floorNoTitleBar = ""
                else
                    _configuration.floorNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.floorNoResize == "NoResize") then
                if _configuration.floorNoResize == "NoResize" then
                    _configuration.floorNoResize = ""
                else
                    _configuration.floorNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.floorNoMove == "NoMove") then
                if _configuration.floorNoMove == "NoMove" then
                    _configuration.floorNoMove = ""
                else
                    _configuration.floorNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.floorTransparentWindow) then
                _configuration.floorTransparentWindow = not _configuration.floorTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.floorAnchor = imgui.Combo("Anchor", _configuration.floorAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.floorChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.floorX = imgui.InputInt("X", _configuration.floorX)
            imgui.PopItemWidth()
            if success then
                _configuration.floorChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.floorY = imgui.InputInt("Y", _configuration.floorY)
            imgui.PopItemWidth()
            if success then
                _configuration.floorChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.floorW = imgui.InputInt("Width", _configuration.floorW)
            imgui.PopItemWidth()
            if success then
                _configuration.floorChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.floorH = imgui.InputInt("Height", _configuration.floorH)
            imgui.PopItemWidth()
            if success then
                _configuration.floorChanged = true
                this.changed = true
            end
            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Mags") then
            if imgui.Checkbox("Enable", _configuration.magsEnableWindow) then
                _configuration.magsEnableWindow = not _configuration.magsEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.magsNoTitleBar == "NoTitleBar") then
                if _configuration.magsNoTitleBar == "NoTitleBar" then
                    _configuration.magsNoTitleBar = ""
                else
                    _configuration.magsNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.magsNoResize == "NoResize") then
                if _configuration.magsNoResize == "NoResize" then
                    _configuration.magsNoResize = ""
                else
                    _configuration.magsNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.magsNoMove == "NoMove") then
                if _configuration.magsNoMove == "NoMove" then
                    _configuration.magsNoMove = ""
                else
                    _configuration.magsNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.magsTransparentWindow) then
                _configuration.magsTransparentWindow = not _configuration.magsTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.magsAnchor = imgui.Combo("Anchor", _configuration.magsAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.magsChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.magsX = imgui.InputInt("X", _configuration.magsX)
            imgui.PopItemWidth()
            if success then
                _configuration.magsChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.magsY = imgui.InputInt("Y", _configuration.magsY)
            imgui.PopItemWidth()
            if success then
                _configuration.magsChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.magsW = imgui.InputInt("Width", _configuration.magsW)
            imgui.PopItemWidth()
            if success then
                _configuration.magsChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.magsH = imgui.InputInt("Height", _configuration.magsH)
            imgui.PopItemWidth()
            if success then
                _configuration.magsChanged = true
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
