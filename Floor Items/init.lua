local lib_helpers = require("solylib.helpers")
local lib_theme = require("solylib.theme")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local cfg = require("Floor Items.configuration")

local function ProcessWeapon(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)
    
    if item.weapon.wrapped or item.weapon.untekked then
        lib_helpers.TextC(false, lib_items_cfg.white, " [")
        if item.weapon.wrapped and item.weapon.untekked then
            lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "W|U")
        elseif item.weapon.wrapped then
            lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "W")
        elseif item.weapon.untekked then
            lib_helpers.TextC(false, lib_items_cfg.weaponUntekked, "U")
        end
        lib_helpers.TextC(false, lib_items_cfg.white, "]")
    end

    if item.weapon.isSRank then
        lib_helpers.TextC(false, lib_items_cfg.weaponSRankTitle, " S-RANK")
        lib_helpers.TextC(false, lib_items_cfg.weaponSRankName, " %s", item.name)
        lib_helpers.TextC(false, lib_items_cfg.weaponSRankCustomName, " %s", item.weapon.nameSrank)

        if item.weapon.grind > 0 then
            lib_helpers.TextC(false, lib_items_cfg.weaponGrind, "+%i", item.weapon.grind)
        end
        
        if item.weapon.specialSRank ~= 0 then
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.weaponSRankSpecial, lib_unitxt.GetSRankSpecialName(item.weapon.specialSRank))
            lib_helpers.TextC(false, lib_items_cfg.white, "]")
        end
    else
        local nameColor = lib_items_cfg.weaponName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        lib_helpers.TextC(false, nameColor, " %s", item.name)
    
        if item.weapon.grind > 0 then
            lib_helpers.TextC(false, lib_items_cfg.weaponGrind, " +%i", item.weapon.grind)
        end
    
        if item.weapon.special ~= 0 then
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[item.weapon.special + 1], lib_unitxt.GetSpecialName(item.weapon.special))
            lib_helpers.TextC(false, lib_items_cfg.white, "]")
        end
    
        lib_helpers.TextC(false, lib_items_cfg.white, " [")
        for i=2,5,1 do
            local stat = item.weapon.stats[i]
    
            local statColor = lib_items_cfg.grey
            for i2=1,table.getn(lib_items_cfg.weaponAttributes),2 do
                if stat <= lib_items_cfg.weaponAttributes[i2] then
                    statColor = lib_items_cfg.weaponAttributes[i2 + 1]
                end
            end
    
            lib_helpers.TextC(false, statColor, "%i", stat)
    
            if i < 5 then
                lib_helpers.TextC(false, lib_items_cfg.white, "/")
            else
                lib_helpers.TextC(false, lib_items_cfg.white, "|")
            end
        end
    
        local stat = item.weapon.stats[6]
        local statColor = lib_items_cfg.grey
        for i2=1,table.getn(lib_items_cfg.weaponHit),2 do
            if stat <= lib_items_cfg.weaponHit[i2] then
                statColor = lib_items_cfg.weaponHit[i2 + 1]
            end
        end
        lib_helpers.TextC(false, statColor, "%i", stat)
        lib_helpers.TextC(false, lib_items_cfg.white, "]")
    
        if item.kills ~= 0 then
            lib_helpers.TextC(false, lib_items_cfg.white, " [")
            lib_helpers.TextC(false, lib_items_cfg.weaponKills, "%iK", item.kills)
            lib_helpers.TextC(false, lib_items_cfg.white, "]")
        end
    end
end

local function ProcessFrame(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    lib_helpers.TextC(false, nameColor, " %s", item.name)

    
    lib_helpers.TextC(false, lib_items_cfg.white, " [")

    local statColor
    if item.armor.dfp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.dfp)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.dfpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.dfpMax)

    lib_helpers.TextC(false, lib_items_cfg.white, " | ")

    if item.armor.evp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.evp)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.evpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.evpMax)

    lib_helpers.TextC(false, lib_items_cfg.white, "]")

    lib_helpers.TextC(false, lib_items_cfg.white, " [")
    lib_helpers.TextC(false, lib_items_cfg.armorSlots, "%iS", item.armor.slots)
    lib_helpers.TextC(false, lib_items_cfg.white, "]")
end

local function ProcessBarrier(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

    local nameColor = lib_items_cfg.armorName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    lib_helpers.TextC(false, nameColor, " %s", item.name)

    lib_helpers.TextC(false, lib_items_cfg.white, " [")

    local statColor
    if item.armor.dfp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.dfp)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.dfpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.dfpMax)

    lib_helpers.TextC(false, lib_items_cfg.white, " | ")

    if item.armor.evp == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.evp)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    if item.armor.evpMax == 0 then
        statColor = lib_items_cfg.grey
    else
        statColor = lib_items_cfg.armorStats
    end
    lib_helpers.TextC(false, statColor, "%i", item.armor.evpMax)

    lib_helpers.TextC(false, lib_items_cfg.white, "]")
end

local function ProcessUnit(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

    local nameStr = item.name
    local nameColor = lib_items_cfg.unitName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end

    if item.unit.mod == 0 then
    elseif item.unit.mod == -2 then
        nameStr = nameStr .. "--"
    elseif item.unit.mod == -1 then
        nameStr = nameStr .. "-"
    elseif item.unit.mod == 1 then
        nameStr = nameStr .. "+"
    elseif item.unit.mod == 2 then
        nameStr = nameStr .. "++"
    end
    
    lib_helpers.TextC(false, nameColor, " %s", nameStr)

    if item.kills ~= 0 then
        lib_helpers.TextC(false, lib_items_cfg.white, " [")
        lib_helpers.TextC(false, lib_items_cfg.weaponKills, "%iK", item.kills)
        lib_helpers.TextC(false, lib_items_cfg.white, "]")
    end
end

local function ProcessMag(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

    local nameColor = lib_items_cfg.magName
    local item_cfg = lib_items_list.t[item.hex]
    if item_cfg ~= nil and item_cfg[1] ~= 0 then
        nameColor = item_cfg[1]
    end
    lib_helpers.TextC(false, nameColor, " %s", item.name)

    lib_helpers.TextC(false, lib_items_cfg.white, " [")
    lib_helpers.TextC(false, lib_items_cfg.magColor, lib_unitxt.GetMagColor(item.mag.color))
    lib_helpers.TextC(false, lib_items_cfg.white, "]")

    lib_helpers.TextC(false, lib_items_cfg.white, " [")
    lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.def)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.pow)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.dex)
    lib_helpers.TextC(false, lib_items_cfg.white, "/")
    lib_helpers.TextC(false, lib_items_cfg.magStats, "%.2f", item.mag.mind)
    lib_helpers.TextC(false, lib_items_cfg.white, "]")
    
    lib_helpers.TextC(false, lib_items_cfg.white, " [")
    lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbL, cfg.shortPBNames))
    lib_helpers.TextC(false, lib_items_cfg.white, "|")
    lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbC, cfg.shortPBNames))
    lib_helpers.TextC(false, lib_items_cfg.white, "|")
    lib_helpers.TextC(false, lib_items_cfg.magPB, lib_unitxt.GetPhotonBlastName(item.mag.pbR, cfg.shortPBNames))
    lib_helpers.TextC(false, lib_items_cfg.white, "]")

    local timerColor = lib_items_cfg.white
    for i=1,table.getn(lib_items_cfg.magFeedTimer),2 do
        if item.mag.timer < lib_items_cfg.magFeedTimer[i] then
            timerColor = lib_items_cfg.magFeedTimer[i + 1]
        end
    end

    lib_helpers.TextC(false, lib_items_cfg.white, " [")
    lib_helpers.TextC(false, timerColor, "%i", item.mag.timer)
    lib_helpers.TextC(false, lib_items_cfg.white, "]")
end

local function ProcessTool(item)
    lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)

    if item.data[2] == 2 then
        local nameColor = lib_items_cfg.techName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        lib_helpers.TextC(false, nameColor, " %s", item.name)
        lib_helpers.TextC(false, lib_items_cfg.techLevel, "Lv%i", item.tool.level)
    else
        local nameColor = lib_items_cfg.toolName
        local item_cfg = lib_items_list.t[item.hex]
        if item_cfg ~= nil and item_cfg[1] ~= 0 then
            nameColor = item_cfg[1]
        end
        lib_helpers.TextC(false, nameColor, " %s", item.name)
        if item.tool.count > 0 then
            lib_helpers.TextC(false, lib_items_cfg.toolAmount, " x%i", item.tool.count)
        end
    end
end

local function ProcessMeseta(item)
    if not cfg.ignoreMeseta then
        lib_helpers.TextC(false, lib_items_cfg.itemIndex, "% 3i", item.index)
        lib_helpers.TextC(false, lib_items_cfg.mesetaName, " %s", item.name)
        lib_helpers.TextC(false, lib_items_cfg.mesetaAmount, " %i", item.meseta)
    end
end

local function Main()
    local itemList = lib_items.GetItemList(lib_items.NoOwner, cfg.invertItemList)
    local itemCount = table.getn(itemList)

    for i=1,itemCount,1 do
        local item = itemList[i]
        -- New line here
        imgui.Text("")

        if item.data[1] == 0 then
            ProcessWeapon(item)
        elseif item.data[1] == 1 then
            if item.data[2] == 1 then
                ProcessFrame(item)
            elseif item.data[2] == 2 then
                ProcessBarrier(item)
            elseif item.data[2] == 3 then
                ProcessUnit(item)
            end
        elseif item.data[1] == 2 then
            ProcessMag(item)
        elseif item.data[1] == 3 then
            ProcessTool(item)
        elseif item.data[1] == 4 then
            ProcessMeseta(item)
        end
    end
end

local function present()
    if cfg.enable == false then
        return
    end

    --lib_theme.Push()
    imgui.Begin("Floor Items")
    imgui.SetWindowFontScale(cfg.fontSize)
    Main()
    imgui.End()
    --lib_theme.Pop()
end

local function init()
    return
    {
        name = "Floor Items",
        version = "1.0.0",
        author = "Solybum",
        description = "Information about items on the floor",
        present = present,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
