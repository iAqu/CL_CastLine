-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    {
        id = "Common",
        Color = fromRGB(190, 195, 205),
        Color2 = fromRGB(150, 155, 168)
    },
    {
        id = "Uncommon",
        Color = fromRGB(120, 225, 100),
        Color2 = fromRGB(70, 185, 70)
    },
    {
        id = "Rare",
        Color = fromRGB(90, 170, 255),
        Color2 = fromRGB(50, 110, 235)
    },
    {
        id = "Epic",
        Color = fromRGB(190, 120, 255),
        Color2 = fromRGB(130, 60, 220)
    },
    {
        id = "Legendary",
        Color = fromRGB(255, 180, 60),
        Color2 = fromRGB(245, 120, 30)
    },
    {
        id = "Mythic",
        Color = fromRGB(255, 100, 130),
        Color2 = fromRGB(225, 45, 80)
    },
    {
        id = "Secret",
        Color = fromRGB(70, 70, 80),
        Color2 = fromRGB(25, 25, 32)
    },
    {
        id = "Divine",
        Color = fromRGB(255, 245, 190),
        Color2 = fromRGB(255, 215, 110)
    },
    {
        id = "Celestial",
        Color = fromRGB(150, 220, 255),
        Color2 = fromRGB(255, 170, 225)
    },
    {
        id = "Eternal",
        Color = fromRGB(250, 245, 255),
        Color2 = fromRGB(180, 100, 255)
    },
    {
        id = "Cosmic",
        Color = fromRGB(90, 150, 255),
        Color2 = fromRGB(30, 50, 190)
    },
    {
        id = "Supreme",
        Color = fromRGB(200, 255, 110),
        Color2 = fromRGB(110, 215, 50)
    },
    {
        id = "Sovereign",
        Color = fromRGB(255, 220, 110),
        Color2 = fromRGB(170, 90, 230)
    },
    {
        id = "Ascended",
        Color = fromRGB(255, 250, 220),
        Color2 = fromRGB(120, 220, 255)
    },
    {
        id = "Primordial",
        Color = fromRGB(170, 235, 120),
        Color2 = fromRGB(200, 120, 50)
    },
    {
        id = "Omega",
        Color = fromRGB(255, 80, 80),
        Color2 = fromRGB(70, 10, 24)
    },
    {
        id = "Transcendent",
        Color = fromRGB(120, 255, 220),
        Color2 = fromRGB(230, 90, 255)
    },
    {
        id = "Apex",
        Color = fromRGB(255, 255, 255),
        Color2 = fromRGB(255, 80, 160)
    },
    {
        id = "Absolute",
        Color = fromRGB(30, 30, 38),
        Color2 = fromRGB(255, 215, 70)
    },
    {
        id = "Exalted",
        Color = fromRGB(255, 244, 205),
        Color2 = fromRGB(255, 196, 70)
    },
    {
        id = "Paradox",
        Color = fromRGB(70, 230, 240),
        Color2 = fromRGB(40, 60, 170)
    },
    {
        id = "Genesis",
        Color = fromRGB(255, 120, 40),
        Color2 = fromRGB(255, 222, 110)
    },
    {
        id = "Singularity",
        Color = fromRGB(205, 120, 255),
        Color2 = fromRGB(18, 6, 40)
    },
    {
        id = "Arcane",
        Color = fromRGB(255, 140, 220),
        Color2 = fromRGB(80, 230, 255)
    },
    {
        id = "Spirit",
        Color = fromRGB(255, 150, 175),
        Color2 = fromRGB(120, 70, 225)
    },
    {
        id = "Astral",
        Color = fromRGB(120, 220, 255),
        Color2 = fromRGB(70, 26, 150)
    },
    {
        id = "Harvest",
        Color = fromRGB(255, 196, 70),
        Color2 = fromRGB(196, 70, 24)
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.order = v1
    v2.name = v2.id
    t2[v2.id] = v2
end

return {
    List = t1,
    ById = t2
}
