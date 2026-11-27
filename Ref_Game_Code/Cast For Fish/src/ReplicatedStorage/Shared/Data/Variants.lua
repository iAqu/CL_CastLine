-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    {
        id = "Normal",
        odds = 1,
        mult = 1,
        Color = fromRGB(255, 255, 255)
    },
    {
        id = "Gold",
        odds = 8,
        mult = 5,
        Color = fromRGB(255, 215, 40)
    },
    {
        id = "Diamond",
        odds = 35,
        mult = 10,
        Color = fromRGB(90, 225, 255)
    },
    {
        id = "Rainbow",
        odds = 150,
        mult = 25,
        Color = fromRGB(255, 110, 200)
    },
    {
        id = "Void",
        odds = 5000,
        mult = 100,
        Color = fromRGB(150, 60, 255)
    },
    {
        id = "Ruby",
        odds = 12,
        mult = 6,
        Color = fromRGB(255, 70, 95)
    },
    {
        id = "Emerald",
        odds = 20,
        mult = 8,
        Color = fromRGB(70, 225, 120)
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.index = v1
    v2.name = v2.id
    t2[v2.id] = v2
end

return {
    List = t1,
    ById = t2
}
