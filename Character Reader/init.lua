local itemReader = require("Character Reader/ItemReader")

-- remove
local _MesetaAddress    = 0x00AA70F0
-- count is somewher else, but if data[0] == 0, item is empty
local _InvPointer = 0x00A95DE0 + 0x1C
-- end remove
-- count, meseta, data
local _BankPointer      = 0x00A95DE0 + 0x18

local _PlayerArray = 0x00A94254
local _PlayerMyIndex = 0x00A9C4F4
local _PlayerNameOff = 0x428

local _ItemArray = 0x00A8D81C
local _ItemArrayCount = 0x00A8D820
local _ItemOwner = 0xE4
local _ItemCode = 0xF2
---- For the item pool
local _ItemKills = 0xE8
local _ItemWepGrind = 0x1F5
local _ItemWepSpecial = 0x1F6
local _ItemWepStats = 0x1C8
local _ItemArmSlots = 0x1B8
local _ItemFrameDef = 0x1B9
local _ItemFrameEvp = 0x1BA
local _ItemBarrierDef = 0x1E4
local _ItemBarrierEvp = 0x1E5
local _ItemMagStats = 0x1C0
local _ItemMagPBHas = 0x1C8
local _ItemMagPB = 0x1C9
local _ItemMagColor = 0x1D0
local _ItemMagSync = 0x1BE
local _ItemMagIQ = 0x1BC
local _ItemMagTimer = 0x1B4
local _ItemMesetaAmount = 0x100


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function tableMerge(t1, t2)
   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end

local init = function()
    return 
    {
        name = "Character Reader",
        version = "1.2",
        author = "Solybum"
    }
end

local readItemList = function(index)
    local invString = ""
    local myAddress
    
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
    for i=1,iCount,1 do
        iAddr = pso.read_u32(ilAddress + 4 * (i - 1))
        if iAddr ~= 0 then
            owner = pso.read_i8(iAddr + _ItemOwner)
            if owner == index then
                item = {0,0,0,0,0,0,0,0,0,0,0,0}
                item[1] = pso.read_u8(iAddr + _ItemCode + 0)
                item[2] = pso.read_u8(iAddr + _ItemCode + 1)
                item[3] = pso.read_u8(iAddr + _ItemCode + 2)
                
                -- There is no name for meseta, we'll just skip naming it here
                if item[1] ~= 4 then
                    itemNameRes = itemReader.getItemName(item)
                end
                
                -- Where the magic happens
                if item[1] == 0 then
                    item[4] = pso.read_u8(iAddr + _ItemWepGrind)
                    item[5] = pso.read_u8(iAddr + _ItemWepSpecial)
                    item[7] = pso.read_u8(iAddr + _ItemWepStats + 0)
                    item[8] = pso.read_u8(iAddr + _ItemWepStats + 1)
                    item[9] = pso.read_u8(iAddr + _ItemWepStats + 2)
                    item[10] = pso.read_u8(iAddr + _ItemWepStats + 3)
                    item[11] = pso.read_u8(iAddr + _ItemWepStats + 4)
                    item[12] = pso.read_u8(iAddr + _ItemWepStats + 5)
                    
                    itemNameRes = itemReader.formatItemName(item, itemNameRes)
                elseif item[1] == 1 then
                    if item[2] == 1 then
                        item[5] = pso.read_u8(iAddr + _ItemArmSlots)
                        item[7] = pso.read_u8(iAddr + _ItemFrameDef)
                        item[9] = pso.read_u8(iAddr + _ItemFrameEvp)
                        
                        itemNameRes = itemReader.formatItemName(item, itemNameRes)
                    elseif item[2] == 2 then
                        item[7] = pso.read_u8(iAddr + _ItemBarrierDef)
                        item[9] = pso.read_u8(iAddr + _ItemBarrierEvp)
                        
                        itemNameRes = itemReader.formatItemName(item, itemNameRes)
                    elseif item[2] == 3 then
                        -- nothing for now
                    end
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
                    
                    itemNameRes = itemReader.formatItemName(item, itemNameRes)
                    
                    time = pso.read_f32(iAddr + _ItemMagTimer) / 30
                    
                    itemNameRes = itemNameRes .. string.format(" [Feed in: %is]", time)
                elseif item[1] == 3 then
                
                elseif item[1] == 4 then
                    itemNameRes = string.format("Meseta: %i", pso.read_u32(iAddr + _ItemMesetaAmount))
                end
                
                -- I'm not sure yet, I guess I can just read the ones that can have kills
                -- kills = pso.read_u16(iAddr + _ItemKills)
                -- if kills ~= 0 then
                --     itemNameRes = itemNameRes .. string.format(" [%ik]", kills)
                -- end
                
                -- Invert the list if its floor items, note that the indexing is inverted too
                -- but that's not a big deal, even better you know how many things have dropped
                -- Remove the comments if you want meseta to appear on the floor item list
                if index == -1 and item[1] ~= 4 then
                    invString = string.format("%03i: %s\n", localCount + 1, itemNameRes) .. invString
                    localCount = localCount + 1
                elseif item[1] ~= 4 then
                    invString = invString .. string.format("%03i: %s\n", localCount + 1, itemNameRes)
                    localCount = localCount + 1
                end
            end
        end
    end
    
    invString = string.format("Count: %i\n\n%s", localCount, invString)
    
    return invString
end
local readBank = function()
    local invString = ""
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
    
    invString = string.format("Count: %i\tMeseta: %i\n\n", count, meseta)
    for i=1,count,1 do
        item = {}
        for i=1,12,1 do
            byte = pso.read_u8(address + i - 1)
            table.insert(item, byte)
        end
        for i=1,4,1 do
            byte = pso.read_u8(address + 16 + i - 1)
            table.insert(item, byte)
        end
        itemCount = pso.read_u8(address + 20)
        
        if item[1] == 3 then
            item[6] = itemCount
        end
        address = address + 24
        
        itemNameRes = itemReader.getItemName(item)
        itemNameRes = itemReader.formatItemName(item, itemNameRes)
        -- get item data
        
        invString = invString .. string.format("%03i: %s\n", i, itemNameRes)
    end
    
    return invString
end

local frames = 0
local selection = 1
local status = true
local text = ""

local present = function()
    imgui.Begin("Character Reader")
    
    local list = { "Me", "Bank", "Floor"}
    status, selection = imgui.Combo("Inventory", selection, list, tablelength(list))
    
    -- refresh every 60 frames or when selection changes
    if frames == 0 or status then
        local ltext = ""
        frames = 60
        text = "";
        
        if selection == 1 then
            ltext = readItemList(0)
        elseif selection == 2 then
            ltext = readBank()
        elseif selection == 3 then
            ltext = readItemList(-1)
        end
        
        text = text .. ltext
    else
        frames = frames - 1
    end
    
    imgui.Text(text)
    
    imgui.End()
end

pso.on_init(init)
pso.on_present(present)

return {
    init = init,
    present = present,
}