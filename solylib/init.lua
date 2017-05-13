local function present()
end

local function init()
    return
    {
        name = "Soly Lib",
        version = "1.0.0",
        author = "Solybum",
        description = "Libraries for the addons",
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
