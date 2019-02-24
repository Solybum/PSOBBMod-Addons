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
            "Schthack",
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
            if imgui.Checkbox("Enable", _configuration.aio.EnableWindow) then
                _configuration.aio.EnableWindow = not _configuration.aio.EnableWindow
                _configuration.aio.changed = true
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.aio.NoTitleBar == "NoTitleBar") then
                if _configuration.aio.NoTitleBar == "NoTitleBar" then
                    _configuration.aio.NoTitleBar = ""
                else
                    _configuration.aio.NoTitleBar = "NoTitleBar"
                end
                _configuration.aio.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.aio.NoResize == "NoResize") then
                if _configuration.aio.NoResize == "NoResize" then
                    _configuration.aio.NoResize = ""
                else
                    _configuration.aio.NoResize = "NoResize"
                end
                _configuration.aio.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.aio.NoMove == "NoMove") then
                if _configuration.aio.NoMove == "NoMove" then
                    _configuration.aio.NoMove = ""
                else
                    _configuration.aio.NoMove = "NoMove"
                end
                _configuration.aio.changed = true
                this.changed = true
            end
            if imgui.Checkbox("Always Auto Resize", _configuration.aio.AlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.aio.AlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.aio.AlwaysAutoResize = ""
                else
                    _configuration.aio.AlwaysAutoResize = "AlwaysAutoResize"
                end
                _configuration.aio.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.aio.TransparentWindow) then
                _configuration.aio.TransparentWindow = not _configuration.aio.TransparentWindow
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.aio.Anchor = imgui.Combo("Anchor", _configuration.aio.Anchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.aio.X = imgui.InputInt("X", _configuration.aio.X)
            imgui.PopItemWidth()
            if success then
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.aio.Y = imgui.InputInt("Y", _configuration.aio.Y)
            imgui.PopItemWidth()
            if success then
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.aio.W = imgui.InputInt("Width", _configuration.aio.W)
            imgui.PopItemWidth()
            if success then
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.aio.H = imgui.InputInt("Height", _configuration.aio.H)
            imgui.PopItemWidth()
            if success then
                _configuration.aio.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Show \"Save to file\" button", _configuration.aio.ShowButtonSaveToFile) then
                _configuration.aio.ShowButtonSaveToFile = not _configuration.aio.ShowButtonSaveToFile
                _configuration.aio.changed = true
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Floor") then
            if imgui.Checkbox("Enable", _configuration.floor.EnableWindow) then
                _configuration.floor.EnableWindow = not _configuration.floor.EnableWindow
                _configuration.floor.changed = true
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.floor.NoTitleBar == "NoTitleBar") then
                if _configuration.floor.NoTitleBar == "NoTitleBar" then
                    _configuration.floor.NoTitleBar = ""
                else
                    _configuration.floor.NoTitleBar = "NoTitleBar"
                end
                _configuration.floor.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.floor.NoResize == "NoResize") then
                if _configuration.floor.NoResize == "NoResize" then
                    _configuration.floor.NoResize = ""
                else
                    _configuration.floor.NoResize = "NoResize"
                end
                _configuration.floor.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.floor.NoMove == "NoMove") then
                if _configuration.floor.NoMove == "NoMove" then
                    _configuration.floor.NoMove = ""
                else
                    _configuration.floor.NoMove = "NoMove"
                end
                _configuration.floor.changed = true
                this.changed = true
            end
            if imgui.Checkbox("Always Auto Resize", _configuration.floor.AlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.floor.AlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.floor.AlwaysAutoResize = ""
                else
                    _configuration.floor.AlwaysAutoResize = "AlwaysAutoResize"
                end
                _configuration.floor.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.floor.TransparentWindow) then
                _configuration.floor.TransparentWindow = not _configuration.floor.TransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.floor.Anchor = imgui.Combo("Anchor", _configuration.floor.Anchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.floor.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.floor.X = imgui.InputInt("X", _configuration.floor.X)
            imgui.PopItemWidth()
            if success then
                _configuration.floor.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.floor.Y = imgui.InputInt("Y", _configuration.floor.Y)
            imgui.PopItemWidth()
            if success then
                _configuration.floor.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.floor.W = imgui.InputInt("Width", _configuration.floor.W)
            imgui.PopItemWidth()
            if success then
                _configuration.floor.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.floor.H = imgui.InputInt("Height", _configuration.floor.H)
            imgui.PopItemWidth()
            if success then
                _configuration.floor.changed = true
                this.changed = true
            end
            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Mags") then
            if imgui.Checkbox("Enable", _configuration.mags.EnableWindow) then
                _configuration.mags.EnableWindow = not _configuration.mags.EnableWindow
                _configuration.mags.changed = true
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.mags.NoTitleBar == "NoTitleBar") then
                if _configuration.mags.NoTitleBar == "NoTitleBar" then
                    _configuration.mags.NoTitleBar = ""
                else
                    _configuration.mags.NoTitleBar = "NoTitleBar"
                end
                _configuration.mags.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.mags.NoResize == "NoResize") then
                if _configuration.mags.NoResize == "NoResize" then
                    _configuration.mags.NoResize = ""
                else
                    _configuration.mags.NoResize = "NoResize"
                end
                _configuration.mags.changed = true
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.mags.NoMove == "NoMove") then
                if _configuration.mags.NoMove == "NoMove" then
                    _configuration.mags.NoMove = ""
                else
                    _configuration.mags.NoMove = "NoMove"
                end
                _configuration.mags.changed = true
                this.changed = true
            end
            if imgui.Checkbox("Always Auto Resize", _configuration.mags.AlwaysAutoResize == "AlwaysAutoResize") then
                if _configuration.mags.AlwaysAutoResize == "AlwaysAutoResize" then
                    _configuration.mags.AlwaysAutoResize = ""
                else
                    _configuration.mags.AlwaysAutoResize = "AlwaysAutoResize"
                end
                _configuration.mags.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.mags.TransparentWindow) then
                _configuration.mags.TransparentWindow = not _configuration.mags.TransparentWindow
                _configuration.mags.changed = true
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.mags.Anchor = imgui.Combo("Anchor", _configuration.mags.Anchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.mags.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.mags.X = imgui.InputInt("X", _configuration.mags.X)
            imgui.PopItemWidth()
            if success then
                _configuration.mags.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.mags.Y = imgui.InputInt("Y", _configuration.mags.Y)
            imgui.PopItemWidth()
            if success then
                _configuration.mags.changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.mags.W = imgui.InputInt("Width", _configuration.mags.W)
            imgui.PopItemWidth()
            if success then
                _configuration.mags.changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.mags.H = imgui.InputInt("Height", _configuration.mags.H)
            imgui.PopItemWidth()
            if success then
                _configuration.mags.changed = true
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
