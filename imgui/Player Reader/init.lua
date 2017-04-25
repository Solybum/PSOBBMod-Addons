helpers = require("lib.helpers")
characters = require("lib.characters")

function Test()
    playerList = characters.GetPlayerList()
    playerListCount = table.getn(playerList)

    for i=1,playerListCount,1 do
        index = playerList[i].index
        address = playerList[i].address
        name = characters.GetPlayerName(address)
        helpers.imguiTextLine(string.format("%2i: %s", index, name))
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

