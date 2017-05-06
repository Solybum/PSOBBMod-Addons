local addons = {}

local function present()
    for i, a in ipairs(addons) do
        a.present()
    end
end

local function init()
    table.insert(addons, {addon = require("soly.Character Reader")})
    table.insert(addons, {addon = require("soly.Mags")})
    table.insert(addons, {addon = require("soly.Monster HP")})
    table.insert(addons, {addon = require("soly.Player Reader")})

    for i, a in ipairs(addons) do
        a.present = a.addon.__addon.init().present
    end

    return
    {
        name = "Soly Addons",
        version = "1.0.0",
        author = "Solybum",
        description = "Wrapper to load addons in deeper directory levels",
        present = present,
    }
end

return 
{
    __addon =
    {
        init = init
    },
}
