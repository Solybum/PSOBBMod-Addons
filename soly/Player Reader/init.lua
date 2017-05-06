local helpers = require("soly.lib.helpers")
local characters = require("soly.lib.characters")
local cfg = require("soly.Player Reader.configuration")

local function Test()
    local playerList = characters.GetPlayerList()
    local playerListCount = table.getn(playerList)

    imgui.Columns(3)

    for i=1,playerListCount,1 do
        local index = playerList[i].index
        local address = playerList[i].address

        local name = characters.GetPlayerName(address)
        local hp = characters.GetPlayerHP(address)
        local mhp = characters.GetPlayerMaxHP(address)
        local hpColor = helpers.HPToGreenRedGradient(hp/mhp)

        helpers.imguiText(string.format("%2i", index), cfg.fontColor, true)
        imgui.NextColumn()
        helpers.imguiText(name, cfg.fontColor, true)
        imgui.NextColumn()
        helpers.imguiProgressBar(hp/mhp, -1.0, 13.0 * cfg.fontSize, hp, helpers.HPToGreenRedGradient(hp/mhp), cfg.fontColor, true)
        imgui.NextColumn()
    end
end

local function present()
    if (not cfg.showPlayerReader) then
        return
    end
	imgui.Begin("Player Reader")
	imgui.SetWindowFontScale(1.0)
	Test()
	imgui.End()
end

local function init()
    return
    {
        name = "Player Reader",
        version = "1.0.0",
        author = "Solybum",
        present = present
    }
end

return {
    __addon = {
        init = init
    }
}
