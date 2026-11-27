-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    {
        id = "Normal",
        chance = 0.30005,
        lucky = 0,
        mult = 1,
        scale = 1,
        Color = fromRGB(255, 255, 255)
    },
    {
        id = "Big",
        chance = 0.22,
        lucky = 0,
        mult = 1.5,
        scale = 1.25,
        Color = fromRGB(255, 255, 255)
    },
    {
        id = "Jumbo",
        chance = 0.17,
        lucky = 0,
        mult = 2.25,
        scale = 1.55,
        Color = fromRGB(255, 255, 255)
    },
    {
        id = "Huge",
        chance = 0.13,
        lucky = 0.05,
        mult = 3.38,
        scale = 1.9,
        Color = fromRGB(255, 225, 90)
    },
    {
        id = "Mammoth",
        chance = 0.1,
        lucky = 0.25,
        mult = 5.06,
        scale = 2.4,
        Color = fromRGB(255, 165, 70)
    },
    {
        id = "Gigantic",
        chance = 0.05,
        lucky = 0.3,
        mult = 7.59,
        scale = 3,
        Color = fromRGB(255, 95, 95)
    },
    {
        id = "Titanic",
        chance = 0.02,
        lucky = 0.2,
        mult = 11.39,
        scale = 3.7,
        Color = fromRGB(255, 110, 190)
    },
    {
        id = "Behemoth",
        chance = 0.007,
        lucky = 0.11,
        mult = 17.09,
        scale = 4.6,
        Color = fromRGB(190, 110, 255)
    },
    {
        id = "Galactic",
        chance = 0.002,
        lucky = 0.05,
        mult = 25.63,
        scale = 5.6,
        Color = fromRGB(110, 190, 255)
    },
    {
        id = "Endless",
        chance = 7E-04,
        lucky = 0.025,
        mult = 38.44,
        scale = 7,
        Color = fromRGB(255, 255, 255)
    },
    {
        id = "Eternal",
        chance = 2E-04,
        lucky = 0.01,
        mult = 57.66,
        scale = 8.4,
        Color = fromRGB(255, 215, 120)
    },
    {
        id = "Infinite",
        chance = 5E-05,
        lucky = 0.005,
        mult = 86.49,
        scale = 10,
        Color = fromRGB(120, 255, 220)
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.index = v1
    v2.name = v2.id
    t2[v2.id] = v2
end

return {
    NORMAL_INDEX = 1,
    List = t1,
    ById = t2
}
