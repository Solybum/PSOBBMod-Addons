-- Menu state offsets
local offsets = {
    0x00A98478,
    0x00000010,
    0x0000001E,
}

local menuClosed = 0x42
local menuOpen = 0x43
local wordSelectOpen = 0x40

-- Internal function to read the menu state
local function _getMenuState()
    local address = 0
    local value = -1
    local bad_read = false
    for k, v in pairs(offsets) do
        if address ~= -1 then
            address = pso.read_u32(address + v)
            if address == 0 then
                address = -1
            end
        end
    end
    if address ~= -1 then
        value = bit.band(address, 0xFFFF)
    end
    return value
end

-- Get if the menu is open
-- Sadly this is ALL menus, apparently, need to find something to identify each type of menu...
local function IsMenuOpen()
    local menuState = _getMenuState()
    return menuState == menuOpen
end

-- Get if word select/symbol chat is open
local function IsSymbolChatOpen()
    local menuState = _getMenuState()
    return menuState == wordSelectOpen
end

-- Get if the menu state could not be read
local function IsMenuUnavailable()
    local menuState = _getMenuState()
    return menuState == -1
end

return
{
    IsMenuOpen = IsMenuOpen,
    IsSymbolChatOpen = IsSymbolChatOpen,
    IsMenuUnavailable = IsMenuUnavailable,
}
