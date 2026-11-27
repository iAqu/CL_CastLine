-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {
    {
        id = "wooden",
        name = "Wooden Dumbbell",
        zone = 1,
        price = 0,
        xp = 1,
        power = 6,
        Color = fromRGB(196, 140, 72)
    },
    {
        id = "steel",
        name = "Steel Dumbbell",
        zone = 1,
        price = 50,
        xp = 2,
        power = 6,
        Color = fromRGB(170, 180, 200)
    },
    {
        id = "titanium",
        name = "Titanium Dumbbell",
        zone = 1,
        price = 400,
        xp = 3,
        power = 6,
        Color = fromRGB(181, 199, 230)
    },
    {
        id = "gold",
        name = "Gold Dumbbell",
        zone = 2,
        price = 2000,
        xp = 4,
        power = 11,
        Color = fromRGB(255, 215, 40)
    },
    {
        id = "diamond",
        name = "Diamond Dumbbell",
        zone = 2,
        price = 12000,
        xp = 8,
        power = 11,
        Color = fromRGB(90, 225, 255)
    },
    {
        id = "ruby",
        name = "Ruby Dumbbell",
        zone = 2,
        price = 60000,
        xp = 11,
        power = 11,
        Color = fromRGB(205, 110, 132)
    },
    {
        id = "cosmic",
        name = "Cosmic Dumbbell",
        zone = 3,
        price = 5E+05,
        xp = 16,
        power = 11,
        Color = fromRGB(170, 90, 255)
    },
    {
        id = "cosmic2",
        name = "Heavy Cosmic Dumbbell",
        zone = 3,
        price = 1E+08,
        xp = 18,
        power = 13,
        Color = fromRGB(200, 148, 255)
    },
    {
        id = "cosmic3",
        name = "Mega Cosmic Dumbbell",
        zone = 3,
        price = 2E+09,
        xp = 21,
        power = 16,
        Color = fromRGB(213, 152, 157)
    },
    {
        id = "kelp",
        name = "Kelp Dumbbell",
        zone = 4,
        price = 9E+11,
        xp = 24,
        power = 32,
        Color = fromRGB(60, 190, 110)
    },
    {
        id = "kelp2",
        name = "Heavy Kelp Dumbbell",
        zone = 4,
        price = 5.4E+12,
        xp = 28,
        power = 39,
        Color = fromRGB(128, 213, 161)
    },
    {
        id = "kelp3",
        name = "Mega Kelp Dumbbell",
        zone = 4,
        price = 1.6E+13,
        xp = 32,
        power = 48,
        Color = fromRGB(157, 203, 85)
    },
    {
        id = "bog",
        name = "Bogwood Dumbbell",
        zone = 5,
        price = 1.8E+14,
        xp = 36,
        power = 64,
        Color = fromRGB(150, 170, 70)
    },
    {
        id = "bog2",
        name = "Heavy Bogwood Dumbbell",
        zone = 5,
        price = 1.3E+15,
        xp = 41,
        power = 80,
        Color = fromRGB(187, 200, 135)
    },
    {
        id = "bog3",
        name = "Mega Bogwood Dumbbell",
        zone = 5,
        price = 3.9E+15,
        xp = 48,
        power = 96,
        Color = fromRGB(203, 193, 65)
    },
    {
        id = "frost",
        name = "Frost Dumbbell",
        zone = 6,
        price = 3.6E+16,
        xp = 54,
        power = 120,
        Color = fromRGB(150, 225, 255)
    },
    {
        id = "frost2",
        name = "Heavy Frost Dumbbell",
        zone = 6,
        price = 3.1E+17,
        xp = 62,
        power = 150,
        Color = fromRGB(187, 235, 255)
    },
    {
        id = "frost3",
        name = "Mega Frost Dumbbell",
        zone = 6,
        price = 9.3E+17,
        xp = 71,
        power = 190,
        Color = fromRGB(203, 220, 157)
    },
    {
        id = "marble",
        name = "Marble Dumbbell",
        zone = 7,
        price = 7.2E+18,
        xp = 80,
        power = 250,
        Color = fromRGB(235, 205, 120)
    },
    {
        id = "marble2",
        name = "Heavy Marble Dumbbell",
        zone = 7,
        price = 7E+19,
        xp = 92,
        power = 300,
        Color = fromRGB(242, 223, 167)
    },
    {
        id = "marble3",
        name = "Mega Marble Dumbbell",
        zone = 7,
        price = 2.1E+20,
        xp = 110,
        power = 360,
        Color = fromRGB(245, 210, 90)
    },
    {
        id = "magma",
        name = "Magma Dumbbell",
        zone = 8,
        price = 1.4E+21,
        xp = 120,
        power = 490,
        Color = fromRGB(255, 110, 50)
    },
    {
        id = "magma2",
        name = "Heavy Magma Dumbbell",
        zone = 8,
        price = 1.6E+22,
        xp = 140,
        power = 600,
        Color = fromRGB(255, 161, 122)
    },
    {
        id = "magma3",
        name = "Mega Magma Dumbbell",
        zone = 8,
        price = 4.7E+22,
        xp = 160,
        power = 740,
        Color = fromRGB(255, 162, 55)
    },
    {
        id = "crystal",
        name = "Crystal Dumbbell",
        zone = 9,
        price = 2.9E+23,
        xp = 180,
        power = 980,
        Color = fromRGB(200, 130, 255)
    },
    {
        id = "crystal2",
        name = "Heavy Crystal Dumbbell",
        zone = 9,
        price = 3.5E+24,
        xp = 210,
        power = 1200,
        Color = fromRGB(219, 174, 255)
    },
    {
        id = "crystal3",
        name = "Mega Crystal Dumbbell",
        zone = 9,
        price = 1E+25,
        xp = 240,
        power = 1500,
        Color = fromRGB(227, 173, 157)
    },
    {
        id = "anchor",
        name = "Anchor Dumbbell",
        zone = 10,
        price = 1.5E+26,
        xp = 270,
        power = 1500,
        Color = fromRGB(150, 165, 150)
    },
    {
        id = "anchor2",
        name = "Heavy Anchor Dumbbell",
        zone = 10,
        price = 2E+27,
        xp = 310,
        power = 1800,
        Color = fromRGB(187, 197, 187)
    },
    {
        id = "anchor3",
        name = "Mega Anchor Dumbbell",
        zone = 10,
        price = 6.1E+27,
        xp = 360,
        power = 2100,
        Color = fromRGB(203, 190, 105)
    },
    {
        id = "abyss",
        name = "Abyss Dumbbell",
        zone = 11,
        price = 3.1E+28,
        xp = 400,
        power = 3000,
        Color = fromRGB(120, 60, 200)
    },
    {
        id = "abyss2",
        name = "Heavy Abyss Dumbbell",
        zone = 11,
        price = 4.4E+29,
        xp = 460,
        power = 3700,
        Color = fromRGB(167, 128, 219)
    },
    {
        id = "abyss3",
        name = "Mega Abyss Dumbbell",
        zone = 11,
        price = 1.3E+30,
        xp = 530,
        power = 4500,
        Color = fromRGB(187, 137, 130)
    },
    {
        id = "storm",
        name = "Storm Dumbbell",
        zone = 12,
        price = 6.1E+30,
        xp = 600,
        power = 6200,
        Color = fromRGB(255, 235, 90)
    },
    {
        id = "storm2",
        name = "Heavy Storm Dumbbell",
        zone = 12,
        price = 9.6E+31,
        xp = 690,
        power = 7600,
        Color = fromRGB(255, 242, 148)
    },
    {
        id = "storm3",
        name = "Mega Storm Dumbbell",
        zone = 12,
        price = 2.9E+32,
        xp = 790,
        power = 9400,
        Color = fromRGB(255, 225, 75)
    },
    {
        id = "astral",
        name = "Astral Dumbbell",
        zone = 13,
        price = 1.2E+33,
        xp = 900,
        power = 13000,
        Color = fromRGB(255, 190, 250)
    },
    {
        id = "astral2",
        name = "Heavy Astral Dumbbell",
        zone = 13,
        price = 2.1E+34,
        xp = 1000,
        power = 16000,
        Color = fromRGB(255, 213, 252)
    },
    {
        id = "astral3",
        name = "Mega Astral Dumbbell",
        zone = 13,
        price = 6.2E+34,
        xp = 1200,
        power = 19000,
        Color = fromRGB(255, 203, 155)
    },
    {
        id = "toxic",
        name = "Toxic Dumbbell",
        zone = 14,
        price = 2.5E+35,
        xp = 1350,
        power = 24000,
        Color = fromRGB(160, 255, 60)
    },
    {
        id = "toxic2",
        name = "Heavy Toxic Dumbbell",
        zone = 14,
        price = 4.7E+36,
        xp = 1600,
        power = 28000,
        Color = fromRGB(193, 255, 128)
    },
    {
        id = "toxic3",
        name = "Mega Toxic Dumbbell",
        zone = 14,
        price = 1.4E+37,
        xp = 1800,
        power = 36000,
        Color = fromRGB(207, 235, 60)
    },
    {
        id = "brass",
        name = "Clockwork Dumbbell",
        zone = 15,
        price = 4.9E+37,
        xp = 2000,
        power = 43000,
        Color = fromRGB(230, 160, 70)
    },
    {
        id = "brass2",
        name = "Heavy Clockwork Dumbbell",
        zone = 15,
        price = 1.2E+39,
        xp = 2300,
        power = 53000,
        Color = fromRGB(239, 193, 135)
    },
    {
        id = "brass3",
        name = "Mega Clockwork Dumbbell",
        zone = 15,
        price = 3.5E+39,
        xp = 2600,
        power = 66000,
        Color = fromRGB(243, 187, 65)
    },
    {
        id = "neon",
        name = "Neon Dumbbell",
        zone = 16,
        price = 9.8E+39,
        xp = 3000,
        power = 86000,
        Color = fromRGB(255, 60, 200)
    },
    {
        id = "neon2",
        name = "Heavy Neon Dumbbell",
        zone = 16,
        price = 2.5E+41,
        xp = 3400,
        power = 110000,
        Color = fromRGB(255, 128, 219)
    },
    {
        id = "neon3",
        name = "Mega Neon Dumbbell",
        zone = 16,
        price = 7.8E+41,
        xp = 4000,
        power = 130000,
        Color = fromRGB(255, 137, 130)
    },
    {
        id = "fossil",
        name = "Fossil Dumbbell",
        zone = 17,
        price = 2E+42,
        xp = 4500,
        power = 170000,
        Color = fromRGB(225, 215, 190)
    },
    {
        id = "fossil2",
        name = "Heavy Fossil Dumbbell",
        zone = 17,
        price = 4.9E+43,
        xp = 5200,
        power = 210000,
        Color = fromRGB(235, 229, 213)
    },
    {
        id = "fossil3",
        name = "Mega Fossil Dumbbell",
        zone = 17,
        price = 1.7E+44,
        xp = 5900,
        power = 260000,
        Color = fromRGB(240, 215, 125)
    },
    {
        id = "nightmare",
        name = "Nightmare Dumbbell",
        zone = 18,
        price = 3.9E+44,
        xp = 6800,
        power = 340000,
        Color = fromRGB(220, 40, 60)
    },
    {
        id = "nightmare2",
        name = "Heavy Nightmare Dumbbell",
        zone = 18,
        price = 9.8E+45,
        xp = 7800,
        power = 420000,
        Color = fromRGB(232, 115, 128)
    },
    {
        id = "nightmare3",
        name = "Mega Nightmare Dumbbell",
        zone = 18,
        price = 3.7E+46,
        xp = 9000,
        power = 520000,
        Color = fromRGB(237, 128, 60)
    },
    {
        id = "glitch",
        name = "Glitch Dumbbell",
        zone = 19,
        price = 7.9E+46,
        xp = 10000,
        power = 720000,
        Color = fromRGB(90, 255, 200)
    },
    {
        id = "glitch2",
        name = "Heavy Glitch Dumbbell",
        zone = 19,
        price = 2E+48,
        xp = 12000,
        power = 850000,
        Color = fromRGB(148, 255, 219)
    },
    {
        id = "glitch3",
        name = "Mega Glitch Dumbbell",
        zone = 19,
        price = 7.6E+48,
        xp = 13000,
        power = 1100000,
        Color = fromRGB(173, 235, 130)
    },
    {
        id = "divine",
        name = "Divine Dumbbell",
        zone = 20,
        price = 1.6E+49,
        xp = 15000,
        power = 1200000,
        Color = fromRGB(255, 225, 120)
    },
    {
        id = "divine2",
        name = "Heavy Divine Dumbbell",
        zone = 20,
        price = 3.9E+50,
        xp = 17000,
        power = 1400000,
        Color = fromRGB(255, 235, 167)
    },
    {
        id = "divine3",
        name = "Mega Divine Dumbbell",
        zone = 20,
        price = 1.5E+51,
        xp = 20000,
        power = 1600000,
        Color = fromRGB(255, 220, 90)
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.tier = v1
    t2[v2.id] = v2
end

return {
    List = t1,
    ById = t2
}
