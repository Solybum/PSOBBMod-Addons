local helpers = require("soly.lib.helpers")
local pmt = require("soly.lib.pmt")
local unitxt = require("soly.lib.unitxt")
local items = require("soly.lib.items")
local cfg = require("soly.Character Reader.configuration")

local _MesetaAddress    = 0x00AA70F0
local _InvPointer = 0x00A95DE0 + 0x1C
local _BankPointer      = 0x00A95DE0 + 0x18

local _PlayerArray = 0x00A94254
local _PlayerMyIndex = 0x00A9C4F4
local _PlayerNameOff = 0x428

local _ItemArray = 0x00A8D81C
local _ItemArrayCount = 0x00A8D820
local _ItemOwner = 0xE4
local _ItemCode = 0xF2
local _ItemEquipped = 0x190
---- For the item pool
local _ItemKills = 0xE8
local _ItemWrapped = 0xDC -- value & 0x00000400
local _ItemWepGrind = 0x1F5
local _ItemWepSpecial = 0x1F6
local _ItemWepStats = 0x1C8
local _ItemArmSlots = 0x1B8
local _ItemFrameDef = 0x1B9
local _ItemFrameEvp = 0x1BA
local _ItemBarrierDef = 0x1E4
local _ItemBarrierEvp = 0x1E5
local _ItemUnitMod = 0x1DC
local _ItemMagStats = 0x1C0
local _ItemMagPBHas = 0x1C8
local _ItemMagPB = 0x1C9
local _ItemMagColor = 0x1CA
local _ItemMagSync = 0x1BE
local _ItemMagIQ = 0x1BC
local _ItemMagTimer = 0x1B4
local _ItemToolCount = 0x104
local _ItemTechType = 0x108
local _ItemMesetaAmount = 0x100

-- Arrays
local srankSpecial =
{
    "", "Jellen", "Zalure", "HP Regeneration", "TP Regeneration",
    "Burning", "Tempest", "Blizzard", "Arrest", "Chaos", "Hell",
    "Spirit", "Berserk", "Demon's", "Gush", "Geist", "King's",
}
local magColor =
{
    "Red", "Blue", "Yellow", "Green", "Purple", "Black", "White",
    "Cyan", "Brown", "Orange", "Slate Blue", "Olive", "Turquoise",
    "Fuschia", "Grey", "Cream", "Pink", "Dark Green",
}
local magNewColor =
{
    0x09, 0x01, 0x02, 0x11, 0x0A, 0x05, 0x06, 0x0B, 0x05, 0x00, 0x07, 0x0B, 0x0C, 0x04, 0x05, 0x06, 0x0E, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x11, 0x04, 0x05, 0x06, 0x08, 0x11, 0x0D, 0x01, 0x02, 0x0C, 0x04, 0x05, 0x06, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x11, 0x04, 0x0E, 0x06, 0x01, 0x0E, 0x09, 0x07, 0x02, 0x11, 0x04, 0x05, 0x06, 0x04, 0x11, 0x0D, 0x01, 0x0B, 0x11, 0x0D, 0x05, 0x06,
    0x00, 0x01, 0x0B, 0x11, 0x04, 0x05, 0x06, 0x0F, 0x05, 0x09, 0x07, 0x02, 0x11, 0x04, 0x05, 0x0F, 0x06, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x0B, 0x11, 0x0A, 0x05, 0x06, 0x06, 0x09, 0x09, 0x01, 0x02, 0x11, 0x0A, 0x0E, 0x06, 0x01, 0x04, 0x0D, 0x07, 0x01, 0x0C, 0x0A, 0x05, 0x06,
    0x10, 0x07, 0x02, 0x11, 0x0A, 0x05, 0x0A, 0x00, 0x07, 0x00, 0x01, 0x08, 0x11, 0x04, 0x09, 0x0F, 0x0D, 0x02, 0x0A, 0x07, 0x02, 0x0C, 0x04, 0x0E, 0x0E,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x10, 0x01, 0x00, 0x07, 0x02, 0x0C, 0x04, 0x05, 0x06, 0x10, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x0D, 0x01, 0x02, 0x11, 0x04, 0x05, 0x06, 0x00, 0x11, 0x08, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x04, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x10, 0x05, 0x09, 0x01, 0x0B, 0x0C, 0x04, 0x05, 0x06, 0x0E, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x01, 0x02, 0x0C, 0x04, 0x05, 0x0F, 0x0A, 0x04, 0x0D, 0x01, 0x08, 0x11, 0x04, 0x05, 0x0F, 0x05, 0x10, 0x10, 0x07, 0x02, 0x0B, 0x0A, 0x0A, 0x0F,
    0x00, 0x01, 0x0B, 0x0C, 0x04, 0x05, 0x06, 0x08, 0x0A, 0x0D, 0x07, 0x02, 0x11, 0x0A, 0x05, 0x06, 0x01, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x07, 0x02, 0x11, 0x04, 0x05, 0x06, 0x09, 0x0C, 0x00, 0x01, 0x02, 0x11, 0x0D, 0x05, 0x10, 0x01, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
}
-- End of Arrays

local getSrankName = function(data)
    local srankName = ""
    local temp = 0
    for i=1,6,2 do
        local n = bit.lshift(data[7 + i - 1], 8) + data[8 + i - 1]
        n = n - 0x8000

        temp = math.floor(n / 0x400) + 0x40
        if temp > 0x40 and temp < 0x60 and i ~= 1 then
            srankName = srankName .. string.char(temp)
        end
        n = n % 0x400

        temp = math.floor(n / 0x20) + 0x40
        if temp > 0x40 and temp < 0x60 then
            srankName = srankName .. string.char(temp)
        end
        n = n % 0x20

        temp = n + 0x40
        if temp > 0x40 and temp < 0x60 then
            srankName = srankName .. string.char(temp)
        end
    end
    return srankName
end

local getLeftPBValue = function(pb)
    local pbs = { 0,0,0,0,0,0,0,0, }

    pbs[bit.band(pb, 7) + 1] = 1
    pbs[bit.rshift(bit.band(pb, 56), 3) + 1] = 1

    pb = bit.band(pb, 0xC0)
    pb = bit.rshift(pb, 6)

    for i=1,6,1 do
        if pbs[i] == 1 then
            -- continue
        else
            if pb == 0 then
                return (i - 1);
            else
                pb = pb - 1
            end
        end
    end
    return -1;
end

-- format and print each item type
local formatPrintWeapon = function(itemIndex, name, data, equipped, floor)
    equipped = equipped or false
    floor = floor or false
    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then
        retStr = retStr .. itemIndexStr
    end

    if cfg.itemsShowEquipped and equipped then
        helpers.imguiText("[", cfg.white)
        helpers.imguiText("E", cfg.itemEquipped)
        helpers.imguiText("] ", cfg.white)
    end

    local wrapStr = nil
    if data[5] > 0xBF then
        wrapStr = "W|U"
    elseif data[5] > 0x7F then
        wrapStr = "U"
    elseif data[5] > 0x3F then
        wrapStr = "W"
    end

    if wrapStr ~= nil then
        retStr = retStr .. "["
        helpers.imguiText("[", cfg.white)
        retStr = retStr .. wrapStr
        helpers.imguiText(wrapStr, cfg.weaponUntekked)
        retStr = retStr .. "] "
        helpers.imguiText("] ", cfg.white)
    end

    -- SRANK
    if (data[2] > 0x6F and data[2] < 0x89) or (data[2] > 0xA4 and data[2] < 0xAA) then
        local srankName = getSrankName(data)

        local srankTitle = "S-RANK "
        name = name .. " "

        retStr = retStr .. srankTitle
        helpers.imguiText(srankTitle, cfg.weaponSRankTitle)
        retStr = retStr .. name
        helpers.imguiText(name, cfg.weaponSRankName)
        retStr = retStr .. srankName
        helpers.imguiText(srankName, cfg.weaponSRankCustomName)

        if data[4] > 0 then
            local grindStr = string.format(" +%i", data[4])
            retStr = retStr .. grindStr
            helpers.imguiText(grindStr, cfg.weaponGrind)
        end

        local spec = data[3]
        if spec ~= 0 then
            local specialStr = "special"
            if spec < table.getn(srankSpecial) then
                specialStr = string.format("%s", srankSpecial[spec + 1])
            end

            retStr = retStr .. " ["
            helpers.imguiText(" [", cfg.white)
            retStr = retStr .. specialStr
            helpers.imguiText(specialStr, cfg.weaponSRankSpecial)
            retStr = retStr .. "]"
            helpers.imguiText("]", cfg.white)
        end
    -- NON SRANK
    else
        retStr = retStr .. name
        local hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
        local itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.weaponName)
        end

        if data[4] > 0 then
            local grindStr = string.format(" +%i", data[4])
            retStr = retStr .. grindStr
            helpers.imguiText(grindStr, cfg.weaponGrind)
        end

        local spec = data[5] % 64
        if spec ~= 0 then
            local specialStr = "special"
            specialStr = unitxt.GetSpecialName(spec)

            retStr = retStr .. " ["
            helpers.imguiText(" [", cfg.white)
            retStr = retStr .. specialStr
            helpers.imguiText(specialStr, cfg.weaponSpecial[spec + 1])
            retStr = retStr .. "]"
            helpers.imguiText("]", cfg.white)
        end

        local stats = {0,0,0,0,0,0}
        if data[7] < 6 then
            stats[data[7] + 1] = data[8]
            if stats[data[7] + 1] > 127 then
                stats[data[7] + 1] = stats[data[7] + 1] - 256
            end
        end
        if data[9] < 6 then
            stats[data[9] + 1] = data[10]
            if stats[data[9] + 1] > 127 then
                stats[data[9] + 1] = stats[data[9] + 1] - 256
            end
        end
        if data[11] < 6 then
            stats[data[11] + 1] = data[12]
            if stats[data[11] + 1] > 127 then
                stats[data[11] + 1] = stats[data[11] + 1] - 256
            end
        end

        retStr = retStr .. " ["
        helpers.imguiText(" [", cfg.white)

        for i=2,5,1 do
            local stat = stats[i]
            local statStr = string.format("%i", stat)
            retStr = retStr .. statStr

            local statColor = 0
            for i2=1,table.getn(cfg.weaponAttributes),2 do
                if statColor == 0 then
                    if stat <= cfg.weaponAttributes[i2] then
                        statColor = i2 + 1
                    end
                end
            end

            if floor or cfg.weaponAttributesEnabled then
                helpers.imguiText(statStr, cfg.weaponAttributes[statColor])
            else
                if stat == 0 then
                    helpers.imguiText(statStr, cfg.grey)
                else
                    helpers.imguiText(statStr, cfg.white)
                end
            end

            retStr = retStr .. "/"
            helpers.imguiText("/", cfg.white)
        end

        local stat = stats[6]
        local statStr = string.format("%i", stat)
        retStr = retStr .. statStr

        local statColor = 0
        for i2=1,table.getn(cfg.weaponHit),2 do
            if statColor == 0 then
                if stat <= cfg.weaponHit[i2] then
                    statColor = i2 + 1
                end
            end
        end

        if floor or cfg.weaponAttributesEnabled then
            helpers.imguiText(statStr, cfg.weaponHit[statColor])
        else
            if stat == 0 then
                helpers.imguiText(statStr, cfg.grey)
            else
                helpers.imguiText(statStr, cfg.white)
            end
        end

        retStr = retStr .. "]"
        helpers.imguiText("]", cfg.white)

        if data[11] >= 0x80 then
            local kills = ((bit.lshift(data[11], 8) + data[12]) - 0x8000)
            local killsStr = string.format("%iK", kills)

            retStr = retStr .. " ["
            helpers.imguiText(" [", cfg.white)
            retStr = retStr .. killsStr
            helpers.imguiText(killsStr, cfg.weaponKills)
            retStr = retStr .. "]"
            helpers.imguiText("]", cfg.white)
        end
    end

    return retStr
end
local formatPrintArmor = function(itemIndex, name, data, equipped)
    equipped = equipped or false
    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then
        retStr = retStr .. itemIndexStr
    end

    if cfg.itemsShowEquipped and equipped then
        helpers.imguiText("[", cfg.white)
        helpers.imguiText("E", cfg.itemEquipped)
        helpers.imguiText("] ", cfg.white)
    end

    retStr = retStr .. name
    local hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
    local itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.armorName)
    end

    local dfp = bit.lshift(data[8], 8) + data[7]
    local evp = bit.lshift(data[10], 8) + data[9]
    local dfpStr = string.format("%i", dfp)
    local evpStr = string.format("%i", evp)

    retStr = retStr .. " ["
    helpers.imguiText(" [", cfg.white)
    retStr = retStr .. dfpStr
    if dfp == 0 then
        helpers.imguiText(dfpStr, cfg.grey)
    else
        helpers.imguiText(dfpStr, cfg.armorStats)
    end
    retStr = retStr .. "/"
    helpers.imguiText("/", cfg.white)
    retStr = retStr .. evpStr
    if evp == 0 then
        helpers.imguiText(evpStr, cfg.grey)
    else
        helpers.imguiText(evpStr, cfg.armorStats)
    end
    retStr = retStr .. "]"
    helpers.imguiText("]", cfg.white)

    if data[2] == 1 then 
        retStr = retStr .. " ["
        helpers.imguiText(" [", cfg.white)

        local slotStr = string.format("%iS", data[6])
        retStr = retStr .. slotStr
        helpers.imguiText(slotStr, cfg.armorSlots)

        retStr = retStr .. "]"
        helpers.imguiText("]", cfg.white)
    end
    return retStr
end
local formatPrintUnit = function(itemIndex, name, data, equipped)
    equipped = equipped or false
    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then
        retStr = retStr .. itemIndexStr
    end

    if cfg.itemsShowEquipped and equipped then
        helpers.imguiText("[", cfg.white)
        helpers.imguiText("E", cfg.itemEquipped)
        helpers.imguiText("] ", cfg.white)
    end

    retStr = retStr .. name
    local hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
    local itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.unitName)
    end

    local mod = data[7]
    local modStr = ""
    if mod > 127 then
        mod = mod - 256
    end

    if mod == 0 then
    elseif mod == 1 then
        modStr = " +"
    elseif mod > 1 then
        modStr = " ++"
    elseif mod == -1 then
        modStr = " -"
    elseif mod < -1 then
        modStr = " --"
    end
    retStr = retStr .. modStr
    helpers.imguiText(modStr, cfg.unitName)

    if data[11] >= 0x80 then
        local kills = ((bit.lshift(data[11], 8) + data[12]) - 0x8000)
        local killsStr = string.format("%iK", kills)

        retStr = retStr .. " ["
        helpers.imguiText(" [", cfg.white)
        retStr = retStr .. killsStr
        helpers.imguiText(killsStr, cfg.unitKills)
        retStr = retStr .. "]"
        helpers.imguiText("]", cfg.white)
    end
    return retStr
end

local formatPrintMag = function(itemIndex, name, data, equipped)
    equipped = equipped or false
    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then
        retStr = retStr .. itemIndexStr
    end

    if cfg.itemsShowEquipped and equipped then
        helpers.imguiText("[", cfg.white)
        helpers.imguiText("E", cfg.itemEquipped)
        helpers.imguiText("] ", cfg.white)
    end

    retStr = retStr .. name
    local hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8)
    local itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.magName)
    end

    local colorStr  = "Not Set"
    if data[16] < table.getn(magColor) then
        colorStr  = magColor[data[16] + 1]
    end

    retStr = retStr .. " ["
    helpers.imguiText(" [", cfg.white)
    retStr = retStr .. colorStr
    helpers.imguiText(colorStr, cfg.magColor)
    retStr = retStr .. "]"
    helpers.imguiText("]", cfg.white)

    retStr = retStr .. " ["
    helpers.imguiText(" [", cfg.white)

    for i=1,4,1 do
        local val = bit.lshift(data[6 + (i - 1) * 2],  8) + data[5 + (i - 1) * 2]

        local statStr = string.format("%.2f", val/100)
        retStr = retStr .. statStr
        helpers.imguiText(statStr, cfg.magStats)

        if i < 4 then
            retStr = retStr .. "/"
            helpers.imguiText("/", cfg.white)
        end
    end

    retStr = retStr .. "]"
    helpers.imguiText("]", cfg.white)

    if cfg.magShowPBs then
        retStr = retStr .. " ["
        helpers.imguiText(" [", cfg.white)

        local pbStr = ""
        if bit.band(data[15], 4) ~= 0 then
            local leftPBVal = getLeftPBValue(data[4])
            if leftPBVal == -1 then
                pbStr = "Error"
            else
                pbStr = unitxt.GetPhotonBlastName(leftPBVal, cfg.magShortPBs)
            end
        else
            pbStr = " "
        end
        retStr = retStr .. pbStr
        helpers.imguiText(pbStr, cfg.magPB)

        retStr = retStr .. "|"
        helpers.imguiText("|", cfg.white)

        if bit.band(data[15], 1) ~= 0 then
            pbStr = unitxt.GetPhotonBlastName(bit.band(data[4], 7), cfg.magShortPBs)
        else
            pbStr = " "
        end
        retStr = retStr .. pbStr
        helpers.imguiText(pbStr, cfg.magPB)

        retStr = retStr .. "|"
        helpers.imguiText("|", cfg.white)

        if bit.band(data[15], 2) ~= 0 then
            pbStr = unitxt.GetPhotonBlastName(bit.rshift(bit.band(data[4], 56), 3), cfg.magShortPBs)
        else
            pbStr = " "
        end
        retStr = retStr .. pbStr
        helpers.imguiText(pbStr, cfg.magPB)

        retStr = retStr .. "]"
        helpers.imguiText("]", cfg.white)
    end

    return retStr
end
local formatPrintTool = function(itemIndex, name, data)
    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then 
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then 
        retStr = retStr .. itemIndexStr
    end

    if data[2] == 2 then
        name = unitxt.GetTechniqueName(data[5])
        local techLvStr = string.format("Lv%i", data[3] + 1)

        retStr = name .. techLvStr
        local hexCode = bit.lshift(5, 16) + bit.lshift(data[5],  8) + data[3]
        local itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.techName)
        end
        helpers.imguiText(techLvStr, cfg.techLevel)
    else
        retStr = retStr .. name
        local hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
        local itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.toolName)
        end
        if data[6] > 1 then
            local amountStr = string.format(" x%i", data[6])
            retStr = retStr .. amountStr
            helpers.imguiText(amountStr, cfg.toolAmount)
        end
    end
    return retStr
end

local formatPrintMeseta = function(itemIndex, name, data)
    if cfg.ignoreMeseta then
        return nil
    end

    -- new line
    imgui.Text("")

    local retStr = ""
    local itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then
        retStr = retStr .. itemIndexStr
    end

    local meseta = bit.lshift(data[13],  0) +
        bit.lshift(data[14],  8) +
        bit.lshift(data[15], 16) +
        bit.lshift(data[16], 24)

    name = name
    retStr = retStr .. name

    local hexCode = 0x040000
    local itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.mesetaName)
    end

    local mesetaStr = string.format(" x%i", meseta)
    helpers.imguiText(mesetaStr, cfg.mesetaAmount)

    retStr = retStr .. mesetaStr
    return retStr
end

local readItemFromPool = function (index, iAddr, floor, magOnly)
    floor = floor or false
    magOnly = magOnly or false
    local itemStr = ""
    local item = {0,0,0,0,0,0,0,0,0,0,0,0}
    item[1] = pso.read_u8(iAddr + _ItemCode + 0)
    item[2] = pso.read_u8(iAddr + _ItemCode + 1)
    item[3] = pso.read_u8(iAddr + _ItemCode + 2)
    local equipped = bit.band(pso.read_u8(iAddr +  _ItemEquipped), 1) == 1

    -- There is no name for meseta, we'll just skip naming it here
    local itemName
    if item[1] == 4 then
        itemName = "Meseta"
    else
        local unitxt_id = pmt.GetItemUnitxtID(item)
        itemName = unitxt.GetItemName(unitxt_id) or "Unknown"
    end

    -- Where the magic happens

    if magOnly then
        if item[1] == 2 then
            item[4] = pso.read_u8(iAddr + _ItemMagPB)
            item[5] = pso.read_u8(iAddr + _ItemMagStats + 0)
            item[6] = pso.read_u8(iAddr + _ItemMagStats + 1)
            item[7] = pso.read_u8(iAddr + _ItemMagStats + 2)
            item[8] = pso.read_u8(iAddr + _ItemMagStats + 3)
            item[9] = pso.read_u8(iAddr + _ItemMagStats + 4)
            item[10] = pso.read_u8(iAddr + _ItemMagStats + 5)
            item[11] = pso.read_u8(iAddr + _ItemMagStats + 6)
            item[12] = pso.read_u8(iAddr + _ItemMagStats + 7)
            item[13] = pso.read_u8(iAddr + _ItemMagSync)
            item[14] = pso.read_u8(iAddr + _ItemMagIQ)
            item[15] = pso.read_u8(iAddr + _ItemMagPBHas)
            item[16] = pso.read_u8(iAddr + _ItemMagColor)

            local feedtimer = pso.read_f32(iAddr + _ItemMagTimer) / 30
            itemStr = formatPrintMag(index, itemName, item, equipped)

            helpers.imguiText(" [", cfg.white)
            local feedtimerStr = string.format("%is", feedtimer)

            local ftColor = 0
            for i=1,table.getn(cfg.magFeedTimer),2 do
                if ftColor == 0 then
                    if feedtimer < cfg.magFeedTimer[i] then
                        ftColor = i + 1
                    end
                end
            end

            if feedtimer <= 0 then
                helpers.imguiText(cfg.magFeedReadyString, cfg.magFeedTimer[ftColor])
            else
                helpers.imguiText(feedtimerStr, cfg.magFeedTimer[ftColor])
            end
            helpers.imguiText("]", cfg.white)
        end
    else
        if floor then
            local hexCode = bit.lshift(item[1], 16) + bit.lshift(item[2],  8) +  item[3]
            if item[1] == 2 then
                hexCode = bit.lshift(item[1], 16) + bit.lshift(item[2],  8)
            elseif item[1] == 3 and item[2] == 2 then
                hexCode = bit.lshift(5, 16) + bit.lshift(item[5],  8) +  item[3]
            end
            local itemCfg = items.t[hexCode]
            if itemCfg ~= nil and itemCfg[2] == false then
                return nil
            end
        end
        -- WEAPON
        if item[1] == 0 then
            item[4] = pso.read_u8(iAddr + _ItemWepGrind)
            item[5] = pso.read_u8(iAddr + _ItemWepSpecial)
            item[7] = pso.read_u8(iAddr + _ItemWepStats + 0)
            item[8] = pso.read_u8(iAddr + _ItemWepStats + 1)
            item[9] = pso.read_u8(iAddr + _ItemWepStats + 2)
            item[10] = pso.read_u8(iAddr + _ItemWepStats + 3)
            item[11] = pso.read_u8(iAddr + _ItemWepStats + 4)
            item[12] = pso.read_u8(iAddr + _ItemWepStats + 5)

            if item[2] == 0x33 or item[2] == 0xAB then
                local kills = pso.read_u16(iAddr + _ItemKills)
                item[11] = (bit.rshift(kills, 8) + 0x80)
                item[12] = bit.band(kills, 0xFF)
            end

            itemStr = formatPrintWeapon(index, itemName, item, equipped, floor)
        -- ARMOR
        elseif item[1] == 1 then
            -- FRAME
            if item[2] == 1 then
                item[6] = pso.read_u8(iAddr + _ItemArmSlots)
                item[7] = pso.read_u8(iAddr + _ItemFrameDef)
                item[9] = pso.read_u8(iAddr + _ItemFrameEvp)

                itemStr = formatPrintArmor(index, itemName, item, equipped)
            -- BARRIER
            elseif item[2] == 2 then
                item[7] = pso.read_u8(iAddr + _ItemBarrierDef)
                item[9] = pso.read_u8(iAddr + _ItemBarrierEvp)

                itemStr = formatPrintArmor(index, itemName, item, equipped)
            -- UNIT
            elseif item[2] == 3 then
                item[7] = pso.read_u8(iAddr + _ItemUnitMod + 0)
                item[8] = pso.read_u8(iAddr + _ItemUnitMod + 1)

                if item[3] == 0x4D or item[3] == 0x4F then
                    local kills = pso.read_u16(iAddr + _ItemKills)
                    item[11] = (bit.rshift(kills, 8) + 0x80)
                    item[12] = bit.band(kills, 0xFF)
                end

                itemStr = formatPrintUnit(index, itemName, item, equipped)
            end
        -- MAG
        elseif item[1] == 2 then
            item[4] = pso.read_u8(iAddr + _ItemMagPB)
            item[5] = pso.read_u8(iAddr + _ItemMagStats + 0)
            item[6] = pso.read_u8(iAddr + _ItemMagStats + 1)
            item[7] = pso.read_u8(iAddr + _ItemMagStats + 2)
            item[8] = pso.read_u8(iAddr + _ItemMagStats + 3)
            item[9] = pso.read_u8(iAddr + _ItemMagStats + 4)
            item[10] = pso.read_u8(iAddr + _ItemMagStats + 5)
            item[11] = pso.read_u8(iAddr + _ItemMagStats + 6)
            item[12] = pso.read_u8(iAddr + _ItemMagStats + 7)
            item[13] = pso.read_u8(iAddr + _ItemMagSync)
            item[14] = pso.read_u8(iAddr + _ItemMagIQ)
            item[15] = pso.read_u8(iAddr + _ItemMagPBHas)
            item[16] = pso.read_u8(iAddr + _ItemMagColor)

            local feedtimer = pso.read_f32(iAddr + _ItemMagTimer) / 30
            itemStr = formatPrintMag(index, itemName, item, equipped)

            helpers.imguiText(" [", cfg.white)
            local feedtimerStr = string.format("%is", feedtimer)

            local ftColor = 0
            for i=1,table.getn(cfg.magFeedTimer),2 do
                if ftColor == 0 then
                    if feedtimer < cfg.magFeedTimer[i] then
                        ftColor = i + 1
                    end
                end
            end

            if feedtimer <= 0 then
                helpers.imguiText(cfg.magFeedReadyString, cfg.magFeedTimer[ftColor])
            else
                helpers.imguiText(feedtimerStr, cfg.magFeedTimer[ftColor])
            end
            helpers.imguiText("]", cfg.white)
        -- TOOL
        elseif item[1] == 3 then
            if item[2] == 2 then
                item[5] = pso.read_u8(iAddr + _ItemTechType)
            else
                item[6] = bit.bxor(pso.read_u32(iAddr + _ItemToolCount), (iAddr + _ItemToolCount))
            end
            itemStr = formatPrintTool(index, itemName, item)
        -- MESETA
        elseif item[1] == 4 then
            item[13] = pso.read_u8(iAddr + _ItemMesetaAmount + 0)
            item[14] = pso.read_u8(iAddr + _ItemMesetaAmount + 1)
            item[15] = pso.read_u8(iAddr + _ItemMesetaAmount + 2)
            item[16] = pso.read_u8(iAddr + _ItemMesetaAmount + 3)

            itemStr = formatPrintMeseta(index, itemName, item)
        end
    end

    return itemStr
end

local readItemFromPoolForFloor = function()
end

local readItemList = function(index, save, magOnly)
    save = save or false
    magOnly = magOnly or false

    local invString = ""
    local myAddress = 0

    if index ~= -1 then
        index = pso.read_u32(_PlayerMyIndex)
    end

    if index ~= 0 then
        myAddress = pso.read_u32(_PlayerArray) + 4 * index
        if myAddress == 0 then
            return "Could not find data, if not in a lobby, get to one"
        end
    end

    local iCount = pso.read_u32(_ItemArrayCount)
    local ilAddress = pso.read_u32(_ItemArray)

    local localCount = 0;
    if index == -1 then
        local startIndex = iCount
        local endIndex = 1
        local step = -1

        if cfg.invertFloorItemsFlow then
            startIndex = 1
            endIndex = iCount
            step = 1
        end

        for i=startIndex,endIndex,step do
            local iAddr = pso.read_u32(ilAddress + 4 * (i - 1))

            if iAddr ~= 0 then
                local owner = pso.read_i8(iAddr + _ItemOwner)

                if owner == index then
                    localCount = localCount + 1

                    local itemStr = readItemFromPool(localCount, iAddr, true)

                    if save and itemStr ~= nil then
                        local file = io.open(cfg.invFileName, "a")
                        io.output(file)
                        io.write(itemStr .. "\n")
                        io.close(file)
                    end
                end
            end
        end
    else
        for i=1,iCount,1 do
            local iAddr = pso.read_u32(ilAddress + 4 * (i - 1))

            if iAddr ~= 0 then
                local owner = pso.read_i8(iAddr + _ItemOwner)

                if owner == index then
                    localCount = localCount + 1

                    local itemStr = readItemFromPool(localCount, iAddr, false, magOnly)

                    if save and itemStr ~= nil then
                        local file = io.open(cfg.invFileName, "a")
                        io.output(file)
                        io.write(itemStr .. "\n")
                        io.close(file)
                    end
                end
            end
        end
    end
end
local readBank = function(save)
    local meseta
    local count
    local address

    address = pso.read_i32(_BankPointer)
    if address == 0 then
        return "Error reading bank data"
    end

    address = address + 0x021C
    count = pso.read_u8(address)
    address = address + 4
    meseta = pso.read_i32(address)
    address = address + 4

    local localCount = 0
    imgui.Text(string.format("Count: %i\tMeseta: %i\n", count, meseta))
    for i=1,count,1 do
        localCount = localCount + 1

        local item = {}
        for i=1,12,1 do
            local byte = pso.read_u8(address + i - 1)
            table.insert(item, byte)
        end
        for i=1,4,1 do
            local byte = pso.read_u8(address + 16 + i - 1)
            table.insert(item, byte)
        end

        if item[1] == 3 then
            item[6] = pso.read_u8(address + 20)
        end
        address = address + 24

        local unitxt_id = pmt.GetItemUnitxtID(item)
        local itemName = unitxt.GetItemName(unitxt_id) or "Unknown"
        local itemStr = ""
        -- WEAPON
        if item[1] == 0 then
            itemStr = formatPrintWeapon(localCount, itemName, item)
        -- ARMOR
        elseif item[1] == 1 then
            -- FRAME
            if item[2] == 1 or item[2] == 2 then
                itemStr = formatPrintArmor(localCount, itemName, item)
            -- BARRIER
            elseif item[2] == 2 then
                itemStr = formatPrintArmor(localCount, itemName, item)
            -- UNIT
            elseif item[2] == 3 then
                itemStr = formatPrintUnit(localCount, itemName, item)
            end
        -- MAG
        elseif item[1] == 2 then
            itemStr = formatPrintMag(localCount, itemName, item)
        -- TOOL
        elseif item[1] == 3 then
            itemStr = formatPrintTool(localCount, itemName, item)
        -- MESETA
        elseif item[1] == 4 then
            itemStr = formatPrintMeseta(localCount, itemName, item)
        end

        if save then
            local file = io.open(cfg.invFileName, "a")
            io.output(file)
            io.write(itemStr .. "\n")
            io.close(file)
        end
    end
end

local getDefaultSelection = function()
    local default = cfg.defaultSelection or 1
    if default < 1 or default > 3 then
        default = 1
    end
    return default
end

local selection = getDefaultSelection()
local status = true

local present = function()
    if cfg.mainWindow then
        local save = false
        imgui.Begin("Character Reader")
        imgui.SetWindowFontScale(cfg.fontSize)

        local list = { "Inventory", "Bank", "Floor" }
        status, selection = imgui.Combo(" ", selection, list, table.getn(list))

        if cfg.showSaveToFile then
            imgui.SameLine(0, 5)
            if imgui.Button("Save to file") then
                save = true
                -- Write nothing to it so its cleared works for appending
                local file = io.open(cfg.invFileName, "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end

        if cfg.showDedicatedMagWindowToggle then
            imgui.SameLine(0, 5)
            if imgui.Button("Mag") then
                cfg.dedicatedMagWindow = not cfg.dedicatedMagWindow
            end
        end

        imgui.BeginChild("ItemList", 0)
        if selection == 1 then
            readItemList(0, save)
        elseif selection == 2 then
            readBank(save)
        elseif selection == 3 then
            readItemList(-1)
        end
        imgui.EndChild()

        imgui.End()
    end

    if cfg.floorItemsWindow then
        imgui.Begin("Floor Items")
        imgui.SetWindowFontScale(cfg.fontSize)
        readItemList(-1)
        imgui.End()
    end

    if cfg.dedicatedMagWindow then
        imgui.Begin("Mags")
        imgui.SetWindowFontScale(cfg.fontSize)
        readItemList(0, false, true)
        imgui.End()
    end
end

local init = function()
    return
    {
        name = "Character Reader",
        version = "1.4.9",
        author = "Solybum",
        present = present
    }
end

return 
{
    __addon = 
    {
        init = init
    },
}
