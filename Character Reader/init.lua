local itemReader = require("Character Reader/ItemReader")
local _MesetaAddress    = 0x00AA70F0
-- count is somewher else, but if data[0] == 0, item is empty
local _InvPointer = 0x00A95DE0 + 0x1C
-- count, meseta, data
local _BankPointer      = 0x00A95DE0 + 0x18

local function tableMerge(t1, t2)
   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end 
 
   return t1
end

local init = function()
    return 
    {
        name = "Character Reader",
        version = "1.1",
        author = "Solybum"
    }
end

local readInventory = function()
    local invString = ""
    local meseta
    local count
    local address
    
    meseta = pso.read_i32(_MesetaAddress)
    address = pso.read_i32(_InvPointer)
    count = pso.read_u8(address)
    address = address + 4
    
    invString = invString .. string.format("Count: % 3i\t Meseta: % 6i\n\n", count, meseta)
    for i=1,count,1
    do
        data1 = {}
        data2 = {}
        item = {}
        pso.read_mem(data1, address + 8 , 12)
        pso.read_mem(data2, address + 8 + 16, 4)
        address = address + 28
        
        item = tableMerge(data1, data2)
        itemNameRes = itemReader.getItemName(item, true)
        
        invString = invString .. 
            string.format("%02i: %s\n", i, itemNameRes)
    end
    
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
    
    invString = invString .. string.format("Count: % 3i\t Meseta: % 6i\n\n", count, meseta)
    for i=1,count,1
    do
        data1 = {}
        data2 = {}
        item = {}
        pso.read_mem(data1, address, 12)
        pso.read_mem(data2, address + 16, 4)
        itemCount = pso.read_u8(address + 20)
        
        if data1[1] == 3 then
            data1[6] = itemCount
        end
        address = address + 24
        
        item = tableMerge(data1, data2)
        itemNameRes = itemReader.getItemName(item, true)
        
        invString = invString .. 
            string.format("%03i: %s\n", i, itemNameRes)
    end
    
    return invString
end

local frames = 0
local text = ""
local inv = true
local force = true

local present = function()
    imgui.Begin("Character Reader")
    if inv then
        if imgui.Button("Inventory") then
            inv = false
            force = true
        end
    else
        if imgui.Button("Bank") then
            inv = true
            force = true
        end
    end
    
    -- refresh every 60 frames
    if frames >= 60 or force == 1 then
        local ltext
        frames = 0
        text = "";
        
        if inv then
            ltext = readInventory()
        else
            ltext = readBank()
        end
        
        text = text .. ltext
    else
        frames = frames + 1
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