local addons = {}
table.insert(addons, require("soly.Character Reader.init"))
table.insert(addons, require("soly.Monster HP.init"))
table.insert(addons, require("soly.Player Reader.init"))

local present = function()
	for i, a in ipairs(addons) do
		a.__addon.init().present()
	end
end

local init = function()
    return
    {
        name = "Soly Addons",
        version = "1.0.0",
        author = "Solybum",
        description = "Wrapper to load addons in deeper directory levels",
        present = present,
    }
end

return {
    __addon = {
        init = init
    },
}
