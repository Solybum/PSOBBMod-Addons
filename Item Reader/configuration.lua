local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Item Reader - Configuration",
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
            if imgui.Checkbox("Hide mag color", _configuration.hideMagColor) then
                _configuration.hideMagColor = not _configuration.hideMagColor
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.itemNameLength = imgui.InputInt("Max Item Name Length", _configuration.itemNameLength)
            imgui.PopItemWidth()
            if success then
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.updateThrottle = imgui.InputInt("Delay Update (seconds)", _configuration.updateThrottle)
            imgui.PopItemWidth()
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

            if imgui.Checkbox("Hide when menus are open", _configuration.aio.HideWhenMenu) then
                _configuration.aio.HideWhenMenu = not _configuration.aio.HideWhenMenu
                this.changed = true
            end
            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.aio.HideWhenSymbolChat) then
                _configuration.aio.HideWhenSymbolChat = not _configuration.aio.HideWhenSymbolChat
                this.changed = true
            end
            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.aio.HideWhenMenuUnavailable) then
                _configuration.aio.HideWhenMenuUnavailable = not _configuration.aio.HideWhenMenuUnavailable
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

        if imgui.Checkbox("Hide when menus are open", _configuration.floor.HideWhenMenu) then
                _configuration.floor.HideWhenMenu = not _configuration.floor.HideWhenMenu
                this.changed = true
            end
            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.floor.HideWhenSymbolChat) then
                _configuration.floor.HideWhenSymbolChat = not _configuration.floor.HideWhenSymbolChat
                this.changed = true
            end
            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.floor.HideWhenMenuUnavailable) then
                _configuration.floor.HideWhenMenuUnavailable = not _configuration.floor.HideWhenMenuUnavailable
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
                _configuration.floor.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Show inventory meseta and item count", _configuration.floor.ShowInvMesetaAndItemCount) then
                _configuration.floor.ShowInvMesetaAndItemCount = not _configuration.floor.ShowInvMesetaAndItemCount
                _configuration.floor.changed = true
                this.changed = true
            end

            if imgui.Checkbox("Show items on all floors", _configuration.floor.ShowMultiFloor) then
                _configuration.floor.ShowMultiFloor = not _configuration.floor.ShowMultiFloor
                _configuration.floor.changed = true
                this.changed = true
            end

            if _configuration.floor.ShowMultiFloor then
                if imgui.TreeNodeEx("Multi-floor options") then
                    imgui.PushItemWidth(100)
                    local enteredValue
                    success, enteredValue = imgui.InputInt("Brightness percent for other floors", _configuration.floor.OtherFloorsBrightnessPercent)
                    if success then
                        if enteredValue >= 0 and enteredValue <= 100 then
                            _configuration.floor.OtherFloorsBrightnessPercent = enteredValue
                        end
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.PopItemWidth()

                    imgui.PushItemWidth(100)
                    local otherFloorIndicator
                    success, otherFloorIndicator = imgui.InputText("Prepend indicator string for other floors", _configuration.floor.OtherFloorsPrependString, 32)
                    if success then
                        -- Check if the string is safe to use (plugin updated). If not, then sanitize it.
                        local canUseString = (pso.require_version ~= nil and pso.require_version(3, 6, 0))
                        if canUseString or string.find(otherFloorIndicator, "%%") == nil then
                            _configuration.floor.OtherFloorsPrependString = otherFloorIndicator
                            _configuration.floor.changed = true
                            this.changed = true
                        end
                    end
                    imgui.PopItemWidth()

                    imgui.SameLine(0, 9)
                    success = imgui.Button("Clear")
                    if success then
                        _configuration.floor.OtherFloorsPrependString = ""
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.TreePop()
                end
            end

            if imgui.Checkbox("Enable Filters", _configuration.floor.EnableFilters) then
                _configuration.floor.EnableFilters = not _configuration.floor.EnableFilters
                this.changed = true
            end
            if _configuration.floor.EnableFilters then
                if imgui.TreeNodeEx("Filter Drops") then
                    imgui.Text("Non-Rares")
                    
                    imgui.PushItemWidth(110)
                    success, _configuration.floor.filter.HitMin = imgui.InputInt("Minimum Hit", _configuration.floor.filter.HitMin)
                    imgui.PopItemWidth()
                    if success then
                        this.changed = true
                    end
                    
                    if imgui.Checkbox("Hide Low Hit Weapons", _configuration.floor.filter.HideLowHitWeapons) then
                        _configuration.floor.filter.HideLowHitWeapons = not _configuration.floor.filter.HideLowHitWeapons
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 9)
                    --imgui.SameLine(0, 25)
                    if imgui.Checkbox("Hide <4s Armor & Barriers", _configuration.floor.filter.HideLowSocketArmor) then
                        _configuration.floor.filter.HideLowSocketArmor = not _configuration.floor.filter.HideLowSocketArmor
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Useless Units", _configuration.floor.filter.HideUselessUnits) then
                        _configuration.floor.filter.HideUselessUnits = not _configuration.floor.filter.HideUselessUnits
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Hide Useless Techs", _configuration.floor.filter.HideUselessTechs) then
                        _configuration.floor.filter.HideUselessTechs = not _configuration.floor.filter.HideUselessTechs
                        _configuration.floor.changed = true
                        this.changed = true
                    end


                    imgui.Text("Consumables")
                    if imgui.Checkbox("Hide Monomates", _configuration.floor.filter.HideMonomates) then
                        _configuration.floor.filter.HideMonomates = not _configuration.floor.filter.HideMonomates
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 30)
                    --imgui.SameLine(0, 58)
                    if imgui.Checkbox("Hide Dimates", _configuration.floor.filter.HideDimates) then
                        _configuration.floor.filter.HideDimates = not _configuration.floor.filter.HideDimates
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 65)
                    --imgui.SameLine(0, 93)
                    if imgui.Checkbox("Hide Trimates", _configuration.floor.filter.HideTrimates) then
                        _configuration.floor.filter.HideTrimates = not _configuration.floor.filter.HideTrimates
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Monofluids", _configuration.floor.filter.HideMonofluids) then
                        _configuration.floor.filter.HideMonofluids = not _configuration.floor.filter.HideMonofluids
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 31)
                    --imgui.SameLine(0, 47)
                    if imgui.Checkbox("Hide Difluids", _configuration.floor.filter.HideDifluids) then
                        _configuration.floor.filter.HideDifluids = not _configuration.floor.filter.HideDifluids
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 66)
                    --imgui.SameLine(0, 83)
                    if imgui.Checkbox("Hide Trifluids", _configuration.floor.filter.HideTrifluids) then
                        _configuration.floor.filter.HideTrifluids = not _configuration.floor.filter.HideTrifluids
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Sol Atomizers", _configuration.floor.filter.HideSolAtomizers) then
                        _configuration.floor.filter.HideSolAtomizers = not _configuration.floor.filter.HideSolAtomizers
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Hide Moon Atomizers", _configuration.floor.filter.HideMoonAtomizers) then
                        _configuration.floor.filter.HideMoonAtomizers = not _configuration.floor.filter.HideMoonAtomizers
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 18)
                    if imgui.Checkbox("Hide Star Atomizers", _configuration.floor.filter.HideStarAtomizers) then
                        _configuration.floor.filter.HideStarAtomizers = not _configuration.floor.filter.HideStarAtomizers
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Antidotes", _configuration.floor.filter.HideAntidotes) then
                        _configuration.floor.filter.HideAntidotes = not _configuration.floor.filter.HideAntidotes
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 38)
                    --imgui.SameLine(0, 58)
                    if imgui.Checkbox("Hide Antiparalysis", _configuration.floor.filter.HideAntiparalysis) then
                        _configuration.floor.filter.HideAntiparalysis = not _configuration.floor.filter.HideAntiparalysis
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Telepipes", _configuration.floor.filter.HideTelepipes) then
                        _configuration.floor.filter.HideTelepipes = not _configuration.floor.filter.HideTelepipes
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 41)
                    --imgui.SameLine(0, 58)
                    if imgui.Checkbox("Hide Trap Visions", _configuration.floor.filter.HideTrapVisions) then
                        _configuration.floor.filter.HideTrapVisions = not _configuration.floor.filter.HideTrapVisions
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Scape Dolls", _configuration.floor.filter.HideScapeDolls) then
                        _configuration.floor.filter.HideScapeDolls = not _configuration.floor.filter.HideScapeDolls
                        _configuration.floor.changed = true
                        this.changed = true
                    end

                    imgui.Text("Grinders/Materials")
                    if imgui.Checkbox("Hide Monogrinders", _configuration.floor.filter.HideMonogrinders) then
                        _configuration.floor.filter.HideMonogrinders = not _configuration.floor.filter.HideMonogrinders
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 17)
                    --imgui.SameLine(0, 24)
                    if imgui.Checkbox("Hide Digrinders", _configuration.floor.filter.HideDigrinders) then
                        _configuration.floor.filter.HideDigrinders = not _configuration.floor.filter.HideDigrinders
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 51)
                    --imgui.SameLine(0, 62)
                    if imgui.Checkbox("Hide Trigrinders", _configuration.floor.filter.HideTrigrinders) then
                        _configuration.floor.filter.HideTrigrinders = not _configuration.floor.filter.HideTrigrinders
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide HP Materials", _configuration.floor.filter.HideHPMats) then
                        _configuration.floor.filter.HideHPMats = not _configuration.floor.filter.HideHPMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 21)
                    if imgui.Checkbox("Hide Power Mats", _configuration.floor.filter.HidePowerMats) then
                        _configuration.floor.filter.HidePowerMats = not _configuration.floor.filter.HidePowerMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 44)
                    --imgui.SameLine(0, 62)
                    if imgui.Checkbox("Hide Luck Mats", _configuration.floor.filter.HideLuckMats) then
                        _configuration.floor.filter.HideLuckMats = not _configuration.floor.filter.HideLuckMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Hide Mind Mats", _configuration.floor.filter.HideMindMats) then
                        _configuration.floor.filter.HideMindMats = not _configuration.floor.filter.HideMindMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 36)
                    --imgui.SameLine(0, 57)
                    if imgui.Checkbox("Hide Defense Mats", _configuration.floor.filter.HideDefenseMats) then
                        _configuration.floor.filter.HideDefenseMats = not _configuration.floor.filter.HideDefenseMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 32)
                    --imgui.SameLine(0, 40)
                    if imgui.Checkbox("Hide Evade Mats", _configuration.floor.filter.HideEvadeMats) then
                        _configuration.floor.filter.HideEvadeMats = not _configuration.floor.filter.HideEvadeMats
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Show Claire's Deal 5 Items", _configuration.floor.filter.ShowClairesDeal) then
                        _configuration.floor.filter.ShowClairesDeal = not _configuration.floor.filter.ShowClairesDeal
                        _configuration.floor.changed = true
                        this.changed = true
                    end
                    imgui.TreePop()
                end
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

            if imgui.Checkbox("Print item index", _configuration.mags.printItemIndex) then
                _configuration.mags.printItemIndex = not _configuration.mags.printItemIndex
                this.changed = true
            end
            if imgui.Checkbox("Show item IDs", _configuration.mags.showItemIDs) then
                _configuration.mags.showItemIDs = not _configuration.mags.showItemIDs
                this.changed = true
            end
            if imgui.Checkbox("Show item data", _configuration.mags.showItemData) then
                _configuration.mags.showItemData = not _configuration.mags.showItemData
                this.changed = true
            end
            if imgui.Checkbox("Show equipped items", _configuration.mags.showEquippedItems) then
                _configuration.mags.showEquippedItems = not _configuration.mags.showEquippedItems
                this.changed = true
            end
            if imgui.Checkbox("Hide mag stats", _configuration.mags.hideMagStats) then
                _configuration.mags.hideMagStats = not _configuration.mags.hideMagStats
                this.changed = true
            end
            if imgui.Checkbox("Hide mag PBs", _configuration.mags.hideMagPBs) then
                _configuration.mags.hideMagPBs = not _configuration.mags.hideMagPBs
                this.changed = true
            end
            if imgui.Checkbox("Hide mag color", _configuration.mags.hideMagColor) then
                _configuration.mags.hideMagColor = not _configuration.mags.hideMagColor
                this.changed = true
            end

            if imgui.Checkbox("Hide when menus are open", _configuration.mags.HideWhenMenu) then
                _configuration.mags.HideWhenMenu = not _configuration.mags.HideWhenMenu
                this.changed = true
            end
            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.mags.HideWhenSymbolChat) then
                _configuration.mags.HideWhenSymbolChat = not _configuration.mags.HideWhenSymbolChat
                this.changed = true
            end
            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.mags.HideWhenMenuUnavailable) then
                _configuration.mags.HideWhenMenuUnavailable = not _configuration.mags.HideWhenMenuUnavailable
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

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return
{
    ConfigurationWindow = ConfigurationWindow,
}
