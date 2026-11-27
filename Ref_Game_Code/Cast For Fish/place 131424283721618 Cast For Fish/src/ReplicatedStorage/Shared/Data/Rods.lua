-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    {
        id = "bamboo",
        name = "Bamboo Rod",
        rarity = "Common",
        zone = "shallows",
        price = 0,
        speed = 1,
        Color = fromRGB(190, 160, 90),
        Color2 = fromRGB(120, 90, 50)
    },
    {
        id = "reef",
        name = "Reef Rod",
        rarity = "Uncommon",
        zone = "coral_reef",
        price = 250000,
        speed = 1.07,
        Color = fromRGB(255, 120, 160),
        Color2 = fromRGB(60, 200, 210)
    },
    {
        id = "deep",
        name = "Deep Sea Rod",
        rarity = "Rare",
        zone = "deep_sea",
        price = 5E+09,
        speed = 1.14,
        Color = fromRGB(60, 90, 190),
        Color2 = fromRGB(120, 255, 230),
        Glow = fromRGB(120, 255, 230)
    },
    {
        id = "kelp",
        name = "Kelp Rod",
        rarity = "Epic",
        zone = "kelp_forest",
        price = 5E+12,
        speed = 1.21,
        Color = fromRGB(60, 150, 80),
        Color2 = fromRGB(150, 230, 110)
    },
    {
        id = "bog",
        name = "Bogwood Rod",
        rarity = "Epic",
        zone = "mangrove_swamp",
        price = 1E+15,
        speed = 1.28,
        Color = fromRGB(110, 80, 50),
        Color2 = fromRGB(170, 200, 70),
        Glow = fromRGB(210, 255, 120)
    },
    {
        id = "frost",
        name = "Frost Rod",
        rarity = "Legendary",
        zone = "frozen_fjord",
        price = 2E+17,
        speed = 1.36,
        Color = fromRGB(190, 230, 255),
        Color2 = fromRGB(90, 170, 240),
        Glow = fromRGB(190, 240, 255)
    },
    {
        id = "marble",
        name = "Marble Rod",
        rarity = "Legendary",
        zone = "sunken_ruins",
        price = 4E+19,
        speed = 1.43,
        Color = fromRGB(235, 230, 215),
        Color2 = fromRGB(255, 205, 70)
    },
    {
        id = "magma",
        name = "Magma Rod",
        rarity = "Mythic",
        zone = "volcanic_vents",
        price = 8E+21,
        speed = 1.5,
        Color = fromRGB(50, 42, 46),
        Color2 = fromRGB(255, 120, 40),
        Glow = fromRGB(255, 140, 40)
    },
    {
        id = "crystal",
        name = "Crystal Rod",
        rarity = "Mythic",
        zone = "crystal_caverns",
        price = 1.6E+24,
        speed = 1.57,
        Color = fromRGB(200, 140, 255),
        Color2 = fromRGB(120, 230, 255),
        Glow = fromRGB(230, 160, 255)
    },
    {
        id = "anchor",
        name = "Anchor Rod",
        rarity = "Secret",
        zone = "shipwreck_graveyard",
        price = 3.2E+26,
        speed = 1.64,
        Color = fromRGB(110, 120, 115),
        Color2 = fromRGB(190, 110, 60),
        Glow = fromRGB(150, 255, 200)
    },
    {
        id = "abyss",
        name = "Abyss Rod",
        rarity = "Divine",
        zone = "abyssal_trench",
        price = 6.4E+28,
        speed = 1.71,
        Color = fromRGB(30, 18, 55),
        Color2 = fromRGB(130, 60, 210),
        Glow = fromRGB(255, 70, 230)
    },
    {
        id = "storm",
        name = "Storm Rod",
        rarity = "Celestial",
        zone = "storm_sea",
        price = 1.3E+31,
        speed = 1.78,
        Color = fromRGB(80, 90, 120),
        Color2 = fromRGB(255, 235, 90),
        Glow = fromRGB(255, 240, 110)
    },
    {
        id = "astral",
        name = "Astral Rod",
        rarity = "Sovereign",
        zone = "celestial_ocean",
        price = 2.6E+33,
        speed = 1.86,
        Color = fromRGB(70, 45, 150),
        Color2 = fromRGB(255, 200, 250),
        Glow = fromRGB(255, 245, 190)
    },
    {
        id = "toxic",
        name = "Toxic Rod",
        rarity = "Ascended",
        zone = "toxic_lagoon",
        price = 5.2E+35,
        speed = 1.9,
        Color = fromRGB(70, 80, 55),
        Color2 = fromRGB(160, 255, 60),
        Glow = fromRGB(190, 255, 60)
    },
    {
        id = "brass",
        name = "Clockwork Rod",
        rarity = "Ascended",
        zone = "clockwork_depths",
        price = 1E+38,
        speed = 1.94,
        Color = fromRGB(190, 135, 60),
        Color2 = fromRGB(95, 70, 45),
        Glow = fromRGB(255, 190, 90)
    },
    {
        id = "neon",
        name = "Neon Rod",
        rarity = "Primordial",
        zone = "neon_reef",
        price = 2E+40,
        speed = 1.98,
        Color = fromRGB(30, 24, 60),
        Color2 = fromRGB(255, 60, 200),
        Glow = fromRGB(60, 240, 255)
    },
    {
        id = "fossil",
        name = "Fossil Rod",
        rarity = "Primordial",
        zone = "primeval_sea",
        price = 4E+42,
        speed = 2.02,
        Color = fromRGB(225, 215, 190),
        Color2 = fromRGB(255, 170, 50),
        Glow = fromRGB(255, 200, 90)
    },
    {
        id = "nightmare",
        name = "Nightmare Rod",
        rarity = "Omega",
        zone = "nightmare_sea",
        price = 8E+44,
        speed = 2.06,
        Color = fromRGB(26, 14, 18),
        Color2 = fromRGB(200, 30, 50),
        Glow = fromRGB(255, 50, 70)
    },
    {
        id = "glitch",
        name = "Glitch Rod",
        rarity = "Transcendent",
        zone = "glitch_rift",
        price = 1.6E+47,
        speed = 2.1,
        Color = fromRGB(20, 20, 26),
        Color2 = fromRGB(90, 255, 200),
        Glow = fromRGB(255, 60, 220)
    },
    {
        id = "divine",
        name = "Divine Rod",
        rarity = "Absolute",
        zone = "divine_throne",
        price = 3.2E+49,
        speed = 2.15,
        Color = fromRGB(250, 246, 235),
        Color2 = fromRGB(255, 215, 110),
        Glow = fromRGB(255, 235, 150)
    },
    {
        id = "candy",
        name = "Candy Cove Rod",
        rarity = "Arcane",
        zone = "candy_cove",
        price = 6.4E+51,
        speed = 2.2,
        Color = fromRGB(206, 18, 73),
        Color2 = fromRGB(82, 219, 191),
        Glow = fromRGB(255, 102, 132)
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.order = v1
    v2.tier = v1

    if v1 == 1 then
        v2.strength = 1
    else
        v2.strength = 1 + v1 / 100
    end

    t2[v2.id] = v2
end

local t3 = {
    {
        id = "harvest_rod",
        name = "Harvest Rod",
        rarity = "Harvest",
        exclusive = true,
        price = 0,
        speed = 2.2,
        strength = 1.25,
        source = "Thanksgiving Ladder",
        Color = fromRGB(176, 104, 46),
        Color2 = fromRGB(255, 196, 64),
        Glow = fromRGB(255, 150, 50)
    }
}

for v3, v4 in ipairs(t3) do
    v4.order = -v3
    v4.tier = 0
    t2[v4.id] = v4
end

return {
    List = t1,
    ById = t2,
    Exclusive = t3,
    StrengthOf = function(p1) -- StrengthOf | line: 47
        -- upvalues: t2 (copy)
        local v5 = p1 and t2[p1]

        if v5 then
            return v5.strength
        end

        return 1
    end
}
