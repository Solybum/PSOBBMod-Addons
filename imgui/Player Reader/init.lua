helpers = require("lib.helpers")
characters = require("lib.characters")

cfgFontColor = 0xFFFFFFFF
cfgFontSize = 1.0

function Test()
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

        

        helpers.imguiText(string.format("%2i", index), cfgFontColor, true)
        imgui.NextColumn()
        helpers.imguiText(name, cfgFontColor, true)
        imgui.NextColumn()
        helpers.imguiProgressBar(hp/mhp, -1.0, 13.0 * cfgFontSize, hp, helpers.HPToGreenRedGradient(hp/mhp), cfgFontColor, true)
    end
end

function present()
    imgui.Begin("Player Reader")
    imgui.SetWindowFontScale(1.0)
    Test()
    imgui.End()
end

function init()
    return 
    {
        name = "Player Reader",
        version = "1.0.0",
        author = "Solybum"
    }
end

pso.on_init(init)
pso.on_present(present)

return {
    init = init,
    present = present,
}

