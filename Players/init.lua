local helpers = require("solylib.helpers")
local characters = require("solylib.characters")
local cfg = require("Players.configuration")

local function PresentPlayers()
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
    if cfg.enable == false then
        return
    end

    imgui.Begin("Players")
    imgui.SetWindowFontScale(cfg.fontSize)
    PresentPlayers()
    imgui.End()
end

local function init()
    return
    {
        name = "Players",
        version = "1.0.1",
        author = "Solybum",
        description = "Work in progress",
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
