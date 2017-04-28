local helpers = require("lib.helpers")
local characters = require("lib.characters")
local cfg = require("Player Reader.configuration")

local function Test()
    playerList = characters.GetPlayerList()
    playerListCount = table.getn(playerList)

    imgui.Columns(3)

    for i=1,playerListCount,1 do
        index = playerList[i].index
        address = playerList[i].address

        name = characters.GetPlayerName(address)
        hp = characters.GetPlayerHP(address)
        mhp = characters.GetPlayerMaxHP(address)
        hpColor = HPToGreenRedGradient(hp/mhp)

        helpers.imguiText(string.format("%2i", index), cfg.fontColor, true)
        imgui.NextColumn()
        helpers.imguiText(name, cfg.fontColor, true)
        imgui.NextColumn()
        helpers.imguiProgressBar(hp/mhp, -1.0, 13.0 * cfg.fontSize, hp, helpers.HPToGreenRedGradient(hp/mhp), cfg.fontColor, true)
        imgui.NextColumn()
    end
end

local function present()
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
        author = "Solybum"
    }
end

pso.on_init(init)

if cfg.showPlayerReader then
	pso.on_present(present)
end

return {
    init = init,
    present = present,
}

