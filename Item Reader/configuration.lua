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

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("AIO", "DefaultOpen") then
            if imgui.Checkbox("Enable", _configuration.aioEnableWindow) then
                _configuration.aioEnableWindow = not _configuration.aioEnableWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(150)
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
