helpers = require("lib.helpers")
items = require("lib.Items")
cfg = require("Character Reader.Configuration")
ir = require("Character Reader.ItemReader")

_MesetaAddress    = 0x00AA70F0
_InvPointer = 0x00A95DE0 + 0x1C
_BankPointer      = 0x00A95DE0 + 0x18

_PlayerArray = 0x00A94254
_PlayerMyIndex = 0x00A9C4F4
_PlayerNameOff = 0x428

_ItemArray = 0x00A8D81C
_ItemArrayCount = 0x00A8D820
_ItemOwner = 0xE4
_ItemCode = 0xF2
_ItemEquipped = 0x190
---- For the item pool
_ItemKills = 0xE8
_ItemWrapped = 0xDC -- value & 0x00000400
_ItemWepGrind = 0x1F5
_ItemWepSpecial = 0x1F6
_ItemWepStats = 0x1C8
_ItemArmSlots = 0x1B8
_ItemFrameDef = 0x1B9
_ItemFrameEvp = 0x1BA
_ItemBarrierDef = 0x1E4
_ItemBarrierEvp = 0x1E5
_ItemUnitMod = 0x1DC
_ItemMagStats = 0x1C0
_ItemMagPBHas = 0x1C8
_ItemMagPB = 0x1C9
_ItemMagColor = 0x1CA
_ItemMagSync = 0x1BE
_ItemMagIQ = 0x1BC
_ItemMagTimer = 0x1B4
_ItemToolCount = 0x104
_ItemTechType = 0x108
_ItemMesetaAmount = 0x100

-- Arrays
techNames = 
{
    "Foie", "Gifoie", "Rafoie",
    "Barta", "Gibarta", "Rabarta",
    "Zonde", "Gizonde", "Razonde",
    "Grants", "Deband",
    "Jellen", "Zalure",
    "Shifta", "Ryuker",
    "Resta", "Anti",
    "Reverser", "Megid",
}
specialNames = 
{
    "None", 
    "Draw", "Drain", "Fill", "Gush",
    "Heart", "Mind", "Soul", "Geist", 
    "Master's", "Lord's", "King's",
    "Charge", "Spirit", "Berserk",
    "Ice", "Frost", "Freeze", "Blizzard",
    "Bind", "Hold", "Seize", "Arrest",
    "Heat", "Fire", "Flame", "Burning",
    "Shock", "Thunder", "Storm", "Tempest",
    "Dim", "Shadow", "Dark", "Hell",
    "Panic", "Riot", "Havoc", "Chaos",
    "Devil's", "Demon's",
}
srankSpecial = 
{
    "", "Jellen", "Zalure", "HP Regeneration", "TP Regeneration",
    "Burning", "Tempest", "Blizzard", "Arrest", "Chaos", "Hell",
    "Spirit", "Berserk", "Demon's", "Gush", "Geist", "King's",
}
magColor = 
{
    "Red", "Blue", "Yellow", "Green", "Purple", "Black", "White",
    "Cyan", "Brown", "Orange", "Slate Blue", "Olive", "Turquoise",
    "Fuschia", "Grey", "Cream", "Pink", "Dark Green",
}
magNewColor = 
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
photonBlast = 
{
    "Farlla", "Estlla", "Golla", "Pilla", "Leilla", "Twins", "Invalid_1", "Invalid_2"
}
-- End of Arrays


local getSrankName = function(data)
    srankName = ""
    temp = 0
    for i=1,6,2 do
        n = bit.lshift(data[7 + i - 1], 8) + data[8 + i - 1]
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
    pbs = { 0,0,0,0,0,0,0,0, }

    pbs[bit.band(pb, 7) + 1] = 1
    pbs[bit.rshift(bit.band(pb, 56), 3) + 1] = 1
    
    pb = bit.band(pb, 0xC0)
    pb = bit.rshift(pb, 6)
    
    for i=1,6,1 do
        if pbs[i] == 1 then
            -- continue
        else
            if pb == 0 then
                return i;
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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
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

    wrapStr = nil
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
        srankName = getSrankName(data)

        srankTitle = "S-RANK "
        name = name .. " "

        retStr = retStr .. srankTitle
        helpers.imguiText(srankTitle, cfg.weaponSRankTitle)
        retStr = retStr .. name
        helpers.imguiText(name, cfg.weaponSRankName)
        retStr = retStr .. srankName
        helpers.imguiText(srankName, cfg.weaponSRankCustomName)

        if data[4] > 0 then
            grindStr = string.format(" +%i", data[4])
            retStr = retStr .. grindStr
            helpers.imguiText(grindStr, cfg.weaponGrind)
        end

        spec = data[3]
        if spec ~= 0 then
            specialStr = "special"
            if spec < helpers.tablelength(srankSpecial) then
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
        hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
        itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.weaponName)
        end

        if data[4] > 0 then
            grindStr = string.format(" +%i", data[4])
            retStr = retStr .. grindStr
            helpers.imguiText(grindStr, cfg.weaponGrind)
        end

        spec = data[5] % 64
        if spec ~= 0 then
            specialStr = "special"
            if spec < helpers.tablelength(specialNames) then
                specialStr = string.format("%s", specialNames[spec + 1])
            end

            retStr = retStr .. " ["
            helpers.imguiText(" [", cfg.white)
            retStr = retStr .. specialStr
            helpers.imguiText(specialStr, cfg.weaponSpecial[spec + 1])
            retStr = retStr .. "]"
            helpers.imguiText("]", cfg.white)
        end

        stats = {0,0,0,0,0,0}
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
            stat = stats[i]
            statStr = string.format("%i", stat)
            retStr = retStr .. statStr

            statColor = 0
            for i2=1,helpers.tablelength(cfg.weaponAttributes),2 do
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

        stat = stats[6]
        statStr = string.format("%i", stat)
        retStr = retStr .. statStr

        statColor = 0
        for i2=1,helpers.tablelength(cfg.weaponHit),2 do
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
            kills = ((bit.lshift(data[11], 8) + data[12]) - 0x8000)
            killsStr = string.format("%iK", kills)

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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
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
    hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
    itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.armorName)
    end
    
    dfp = bit.lshift(data[8], 8) + data[7]
    evp = bit.lshift(data[10], 8) + data[9]
    dfpStr = string.format("%i", dfp)
    evpStr = string.format("%i", evp)

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

        slotStr = string.format("%iS", data[6])
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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
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
    hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
    itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.unitName)
    end

    mod = data[7]
    modStr = ""
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
        kills = ((bit.lshift(data[11], 8) + data[12]) - 0x8000)
            killsStr = string.format("%iK", kills)

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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
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
    hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8)
    itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.magName)
    end
    
    colorStr  = "Not Set"
    if data[16] < helpers.tablelength(magColor) then
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
        val = bit.lshift(data[6 + (i - 1) * 2],  8) + data[5 + (i - 1) * 2]

        statStr = string.format("%.2f", val/100)
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

        pbStr = ""
        if bit.band(data[15], 4) ~= 0 then
            leftPBVal = getLeftPBValue(data[4])
            if leftPBVal == -1 then
                pbStr = "Error"
            else
                pbStr = photonBlast[leftPBVal]
            end
        else
            pbStr = "Empty"
        end
        retStr = retStr .. pbStr
        helpers.imguiText(pbStr, cfg.magPB)

        retStr = retStr .. "|"
        helpers.imguiText("|", cfg.white)

        if bit.band(data[15], 1) ~= 0 then
            pbStr = photonBlast[bit.band(data[4], 7) + 1]
        else
            pbStr = "Empty"
        end
        retStr = retStr .. pbStr
        helpers.imguiText(pbStr, cfg.magPB)

        retStr = retStr .. "|"
        helpers.imguiText("|", cfg.white)

        if bit.band(data[15], 2) ~= 0 then
            pbStr = photonBlast[bit.rshift(bit.band(data[4], 56), 3) + 1]
        else
            pbStr = "Empty"
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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then 
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then 
        retStr = retStr .. itemIndexStr
    end

    if data[2] == 2 then
        name = "Invalid technique"
        techLvStr = string.format(" Lv%i", data[3] + 1)

        if data[5] < helpers.tablelength(techNames) then
            name = string.format("%s", techNames[data[5] + 1])
        end

        retStr = name .. techLvStr
        hexCode = bit.lshift(5, 16) + bit.lshift(data[5],  8) + data[3]
        itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.techName)
        end
        helpers.imguiText(techLvStr, cfg.techLevel)
    else
        retStr = retStr .. name
        hexCode = bit.lshift(data[1], 16) + bit.lshift(data[2],  8) + data[3]
        itemCfg = items.t[hexCode]
        if itemCfg ~= nil and itemCfg[1] ~= 0 then
            helpers.imguiText(name, itemCfg[1])
        else
            helpers.imguiText(name, cfg.toolName)
        end
        if data[6] > 1 then
            amountStr = string.format(" x%i", data[6])
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

    retStr = ""
    itemIndexStr = string.format("%03i ", itemIndex)
    if cfg.printItemIndex then 
        helpers.imguiText(itemIndexStr, cfg.itemIndex)
    end
    if cfg.printItemIndexToFile then 
        retStr = retStr .. itemIndexStr
    end

    meseta = bit.lshift(item[13],  0) + 
        bit.lshift(item[14],  8) + 
        bit.lshift(item[15], 16) + 
        bit.lshift(item[16], 24)

    name = name
    retStr = retStr .. name

    hexCode = 0x040000
    itemCfg = items.t[hexCode]
    if itemCfg ~= nil and itemCfg[1] ~= 0 then
        helpers.imguiText(name, itemCfg[1])
    else
        helpers.imguiText(name, cfg.mesetaName)
    end

    mesetaStr = string.format(" x%i", meseta)
    helpers.imguiText(mesetaStr, cfg.mesetaAmount)

    retStr = retStr .. mesetaStr
    return retStr
end

local readItemFromPool = function (index, iAddr, floor, magOnly)
    floor = floor or false
    magOnly = magOnly or false
    itemStr = ""
    item = {0,0,0,0,0,0,0,0,0,0,0,0}
    item[1] = pso.read_u8(iAddr + _ItemCode + 0)
    item[2] = pso.read_u8(iAddr + _ItemCode + 1)
    item[3] = pso.read_u8(iAddr + _ItemCode + 2)
    equipped = bit.band(pso.read_u8(iAddr +  _ItemEquipped), 1) == 1
    
    -- There is no name for meseta, we'll just skip naming it here
    if item[1] == 4 then
        itemName = "Meseta"
    else
        itemName = ir.getItemName(item) or "Unknown"
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

            feedtimer = pso.read_f32(iAddr + _ItemMagTimer) / 30
            itemStr = formatPrintMag(index, itemName, item, equipped)

            helpers.imguiText(" [", cfg.white)
            feedtimerStr = string.format("%is", feedtimer)

            ftColor = 0
            for i=1,helpers.tablelength(cfg.magFeedTimer),2 do
                if ftColor == 0 then
                    if feedtimer < cfg.magFeedTimer[i] then
                        ftColor = i + 1
                    end
                end
            end

            if feedtimer <= 0 then
                helpers.imguiText("Feed Me!!!", cfg.magFeedTimer[ftColor])
            else
                helpers.imguiText(feedtimerStr, cfg.magFeedTimer[ftColor])
            end
            helpers.imguiText("]", cfg.white)
        end
    else 
        if floor then
            hexCode = bit.lshift(item[1], 16) + bit.lshift(item[2],  8) +  item[3]
            if item[1] == 2 then
                hexCode = bit.lshift(item[1], 16) + bit.lshift(item[2],  8)
            elseif item[1] == 3 and item[2] == 2 then
                hexCode = bit.lshift(5, 16) + bit.lshift(item[5],  8) +  item[3]
            end
            itemCfg = items.t[hexCode]
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
                kills = pso.read_u16(iAddr + _ItemKills)
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
                    kills = pso.read_u16(iAddr + _ItemKills)
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

            feedtimer = pso.read_f32(iAddr + _ItemMagTimer) / 30
            itemStr = formatPrintMag(index, itemName, item, equipped)

            helpers.imguiText(" [", cfg.white)
            feedtimerStr = string.format("%is", feedtimer)

            ftColor = 0
            for i=1,helpers.tablelength(cfg.magFeedTimer),2 do
                if ftColor == 0 then
                    if feedtimer < cfg.magFeedTimer[i] then
                        ftColor = i + 1
                    end
                end
            end

            if feedtimer <= 0 then
                helpers.imguiText("Feed Me!!!", cfg.magFeedTimer[ftColor])
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
            item[13] = pso.read_u32(iAddr + _ItemMesetaAmount + 0)
            item[14] = pso.read_u32(iAddr + _ItemMesetaAmount + 1)
            item[15] = pso.read_u32(iAddr + _ItemMesetaAmount + 2)
            item[16] = pso.read_u32(iAddr + _ItemMesetaAmount + 3)

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
    
    iCount = pso.read_u32(_ItemArrayCount)
    ilAddress = pso.read_u32(_ItemArray)

    localCount = 0;
    if index == -1 then
        startIndex = iCount
        endIndex = 1
        step = -1

        if cfg.invertFloorItemsFlow then
            startIndex = 1
            endIndex = iCount
            step = 1
        end

        for i=startIndex,endIndex,step do
            iAddr = pso.read_u32(ilAddress + 4 * (i - 1))

            if iAddr ~= 0 then
                owner = pso.read_i8(iAddr + _ItemOwner)

                if owner == index then
                    localCount = localCount + 1

                    itemStr = readItemFromPool(localCount, iAddr, true)

                    if save and itemStr ~= nil then
                        file = io.open(cfg.invFileName, "a")
                        io.output(file)
                        io.write(itemStr .. "\n")
                        io.close(file)
                    end
                end
            end
        end
    else
        for i=1,iCount,1 do
            iAddr = pso.read_u32(ilAddress + 4 * (i - 1))

            if iAddr ~= 0 then
                owner = pso.read_i8(iAddr + _ItemOwner)

                if owner == index then
                    localCount = localCount + 1

                    itemStr = readItemFromPool(localCount, iAddr, false, magOnly)

                    if save and itemStr ~= nil then
                        file = io.open(cfg.invFileName, "a")
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
    
    localCount = 0
    imgui.Text(string.format("Count: %i\tMeseta: %i\n", count, meseta))
    for i=1,count,1 do
        localCount = localCount + 1
        
        item = {}
        for i=1,12,1 do
            byte = pso.read_u8(address + i - 1)
            table.insert(item, byte)
        end
        for i=1,4,1 do
            byte = pso.read_u8(address + 16 + i - 1)
            table.insert(item, byte)
        end

        if item[1] == 3 then
            item[6] = pso.read_u8(address + 20)
        end
        address = address + 24
        
        itemName = ir.getItemName(item) or "Unknown"
        itemStr = ""
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
            file = io.open(cfg.invFileName, "a")
            io.output(file)
            io.write(itemStr .. "\n")
            io.close(file)
        end
    end
end

local selection = 1
local status = true

local present = function()
    if cfg.mainWindow then
        imgui.Begin("Character Reader")
        imgui.SetWindowFontScale(cfg.fontSize)

        local list = { "Inventory", "Bank", "Floor" }
        status, selection = imgui.Combo(" ", selection, list, helpers.tablelength(list))
        imgui.SameLine(0, 0)

        save = false
        if imgui.Button("Save to file") then
            save = true
            -- Write nothing to it so its cleared works for appending
            file = io.open(cfg.invFileName, "w")
            io.output(file)
            io.write("")
            io.close(file)
        end

        if selection == 1 then
            readItemList(0, save)
        elseif selection == 2 then
            readBank(save)
        elseif selection == 3 then
            readItemList(-1)
        end

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
        version = "1.4.8",
        author = "Solybum"
    }
end

pso.on_init(init)
pso.on_present(present)

return {
    init = init,
    present = present,
}
