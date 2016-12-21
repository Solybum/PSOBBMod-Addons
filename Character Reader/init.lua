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
    
    if index == -1 then
        index = -1
    else
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
                item = {}
                pso.read_mem(item, iAddr + _ItemCode, 3)
                
                itemNameRes = itemReader.getItemName(item, false)
                
                invString = invString .. string.format("%03i: %s\n", localCount + 1, itemNameRes)
                
                localCount = localCount + 1
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
        
        itemNameRes = itemReader.getItemName(item, true)
        
        invString = invString .. string.format("%03i: %s\n", i, itemNameRes)
    end
    
    return invString
end

local frames = 0
local selection = 2
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