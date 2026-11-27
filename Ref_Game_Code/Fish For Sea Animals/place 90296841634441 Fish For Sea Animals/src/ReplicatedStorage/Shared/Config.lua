-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Canyon = require(script.Parent.Canyon)
local Economy = require(script.Parent.Economy)
local t1 = {
    Rarities = {
        {
            Name = "Common",
            Size = 4,
            Color = Color3.fromRGB(200, 200, 210),
            Gradient = {
                Color3.fromRGB(245, 245, 250),
                Color3.fromRGB(145, 150, 165)
            }
        },
        {
            Name = "Uncommon",
            Size = 4.8,
            Color = Color3.fromRGB(95, 225, 85),
            Gradient = {
                Color3.fromRGB(200, 255, 140),
                Color3.fromRGB(35, 175, 75)
            }
        },
        {
            Name = "Rare",
            Size = 5.6,
            Color = Color3.fromRGB(70, 165, 255),
            Gradient = {
                Color3.fromRGB(130, 235, 255),
                Color3.fromRGB(40, 95, 255)
            }
        },
        {
            Name = "Epic",
            Size = 6.6,
            Color = Color3.fromRGB(185, 85, 255),
            Gradient = {
                Color3.fromRGB(245, 150, 255),
                Color3.fromRGB(115, 40, 230)
            }
        },
        {
            Name = "Legendary",
            Size = 8,
            Color = Color3.fromRGB(255, 195, 40),
            Gradient = {
                Color3.fromRGB(255, 245, 130),
                Color3.fromRGB(255, 140, 20)
            }
        },
        {
            Name = "Mythic",
            Size = 9.5,
            Color = Color3.fromRGB(255, 60, 120),
            Gradient = {
                Color3.fromRGB(255, 150, 190),
                Color3.fromRGB(215, 20, 75)
            }
        },
        {
            Name = "Ancient",
            Size = 10.5,
            Shine = true,
            Color = Color3.fromRGB(215, 175, 120),
            Gradient = {
                Color3.fromRGB(240, 220, 180),
                Color3.fromRGB(150, 105, 60)
            }
        },
        {
            Name = "Celestial",
            Size = 11,
            Shine = true,
            Color = Color3.fromRGB(110, 140, 255),
            Gradient = {
                Color3.fromRGB(255, 250, 200),
                Color3.fromRGB(40, 60, 160)
            }
        },
        {
            Name = "Cosmic",
            Size = 11.5,
            Shine = true,
            Color = Color3.fromRGB(200, 100, 255),
            Gradient = {
                Color3.fromRGB(255, 130, 230),
                Color3.fromRGB(70, 60, 220)
            }
        },
        {
            Name = "Prismatic",
            Size = 12,
            Shine = true,
            Color = Color3.fromRGB(130, 255, 235),
            Gradient = {
                Color3.fromRGB(255, 120, 160),
                Color3.fromRGB(255, 240, 120),
                Color3.fromRGB(120, 255, 200),
                Color3.fromRGB(140, 160, 255)
            }
        },
        {
            Name = "Titan",
            Size = 14,
            Shine = true,
            Color = Color3.fromRGB(255, 140, 60),
            Gradient = {
                Color3.fromRGB(255, 200, 120),
                Color3.fromRGB(120, 85, 50)
            }
        },
        {
            Name = "Abyssal",
            Size = 13,
            Shine = true,
            Color = Color3.fromRGB(150, 70, 230),
            Gradient = {
                Color3.fromRGB(210, 140, 255),
                Color3.fromRGB(25, 10, 45)
            }
        },
        {
            Name = "Secret",
            Size = 14,
            Shine = true,
            Color = Color3.fromRGB(255, 255, 255),
            Gradient = {
                Color3.fromRGB(255, 225, 90),
                Color3.fromRGB(30, 30, 35)
            }
        },
        {
            Name = "Radiant",
            Size = 14.5,
            Shine = true,
            Color = Color3.fromRGB(255, 225, 140),
            Gradient = {
                Color3.fromRGB(255, 255, 245),
                Color3.fromRGB(255, 225, 130),
                Color3.fromRGB(215, 160, 40)
            }
        },
        {
            Name = "Tempest",
            Size = 15,
            Shine = true,
            Color = Color3.fromRGB(90, 200, 255),
            Gradient = {
                Color3.fromRGB(200, 245, 255),
                Color3.fromRGB(60, 170, 255),
                Color3.fromRGB(45, 50, 75)
            }
        },
        {
            Name = "Glitched",
            Size = 15.5,
            Shine = true,
            Color = Color3.fromRGB(255, 60, 220),
            Gradient = {
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(255, 40, 220),
                Color3.fromRGB(20, 20, 30),
                Color3.fromRGB(0, 255, 160)
            }
        },
        {
            Name = "Dusk",
            Size = 16,
            Shine = true,
            Color = Color3.fromRGB(255, 150, 110),
            Gradient = {
                Color3.fromRGB(255, 205, 150),
                Color3.fromRGB(200, 90, 140),
                Color3.fromRGB(40, 35, 95)
            }
        },
        {
            Name = "Nightfall",
            Size = 16,
            Shine = true,
            Color = Color3.fromRGB(120, 110, 255),
            Gradient = {
                Color3.fromRGB(190, 200, 255),
                Color3.fromRGB(70, 60, 200),
                Color3.fromRGB(8, 8, 30)
            }
        },
        {
            Name = "Lumen",
            Size = 16.5,
            Shine = true,
            Color = Color3.fromRGB(110, 255, 230),
            Gradient = {
                Color3.fromRGB(230, 255, 250),
                Color3.fromRGB(60, 240, 210),
                Color3.fromRGB(10, 70, 90)
            }
        },
        {
            Name = "Phantom",
            Size = 16.5,
            Shine = true,
            Color = Color3.fromRGB(200, 225, 255),
            Gradient = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(170, 200, 240),
                Color3.fromRGB(70, 80, 120)
            }
        },
        {
            Name = "Quicksilver",
            Size = 17,
            Shine = true,
            Color = Color3.fromRGB(215, 225, 235),
            Gradient = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(150, 160, 175),
                Color3.fromRGB(240, 245, 250),
                Color3.fromRGB(90, 100, 115)
            }
        },
        {
            Name = "Thermal",
            Size = 17,
            Shine = true,
            Color = Color3.fromRGB(255, 120, 40),
            Gradient = {
                Color3.fromRGB(255, 240, 120),
                Color3.fromRGB(255, 110, 30),
                Color3.fromRGB(110, 20, 10)
            }
        },
        {
            Name = "Bonecrest",
            Size = 17.5,
            Shine = true,
            Color = Color3.fromRGB(240, 230, 205),
            Gradient = {
                Color3.fromRGB(255, 250, 235),
                Color3.fromRGB(215, 200, 165),
                Color3.fromRGB(90, 75, 55)
            }
        },
        {
            Name = "Dreadnought",
            Size = 17.5,
            Shine = true,
            Color = Color3.fromRGB(150, 175, 165),
            Gradient = {
                Color3.fromRGB(210, 230, 220),
                Color3.fromRGB(100, 125, 120),
                Color3.fromRGB(190, 80, 40)
            }
        },
        {
            Name = "Hadal",
            Size = 18,
            Shine = true,
            Color = Color3.fromRGB(60, 120, 255),
            Gradient = {
                Color3.fromRGB(140, 200, 255),
                Color3.fromRGB(30, 60, 200),
                Color3.fromRGB(0, 0, 20)
            }
        },
        {
            Name = "Fathom",
            Size = 18.5,
            Shine = true,
            Color = Color3.fromRGB(255, 70, 90),
            Gradient = {
                Color3.fromRGB(255, 220, 120),
                Color3.fromRGB(255, 50, 80),
                Color3.fromRGB(60, 0, 70),
                Color3.fromRGB(0, 0, 0)
            }
        }
    },
    RarityByName = {}
}

for v1, v2 in t1.Rarities do
    v2.Index = v1
    t1.RarityByName[v2.Name] = v2
end

local function sequence(p1) -- line: 48
    local t2 = {}

    for v3, v4 in p1 do
        table.insert(t2, ColorSequenceKeypoint.new((v3 - 1) / (#p1 - 1), v4))
    end

    return ColorSequence.new(t2)
end

function t1.rarityGradient(p2) -- line: 57
    -- upvalues: sequence (copy)
    return sequence(p2.Gradient or {
        p2.Color:Lerp(Color3.new(1, 1, 1), 0.55),
        p2.Color
    })
end

t1.Mutations = {
    {
        Name = "Galaxy",
        Reflectance = 0.25,
        Shine = true,
        Dark = Color3.fromRGB(8, 4, 28),
        Light = Color3.fromRGB(70, 35, 165),
        Material = Enum.Material.SmoothPlastic,
        Gradient = {
            Color3.fromRGB(255, 140, 255),
            Color3.fromRGB(90, 70, 255),
            Color3.fromRGB(20, 10, 70)
        }
    },
    {
        Name = "Rainbow",
        Rainbow = true,
        Shine = true,
        Material = Enum.Material.SmoothPlastic,
        Gradient = {
            Color3.fromRGB(255, 90, 90),
            Color3.fromRGB(255, 220, 80),
            Color3.fromRGB(90, 255, 120),
            Color3.fromRGB(80, 170, 255),
            Color3.fromRGB(200, 90, 255)
        }
    },
    {
        Name = "Diamond",
        Reflectance = 0.3,
        Transparency = 0.05,
        Dark = Color3.fromRGB(45, 120, 200),
        Light = Color3.fromRGB(125, 195, 235),
        Material = Enum.Material.Glass,
        Gradient = {
            Color3.fromRGB(235, 255, 255),
            Color3.fromRGB(90, 190, 255)
        }
    },
    {
        Name = "Ruby",
        Reflectance = 0.35,
        Transparency = 0.05,
        Shine = true,
        Dark = Color3.fromRGB(110, 0, 20),
        Light = Color3.fromRGB(255, 70, 95),
        Material = Enum.Material.Glass,
        Gradient = {
            Color3.fromRGB(255, 170, 180),
            Color3.fromRGB(230, 20, 60),
            Color3.fromRGB(120, 0, 25)
        }
    },
    {
        Name = "Emerald",
        Reflectance = 0.35,
        Transparency = 0.05,
        Dark = Color3.fromRGB(0, 85, 45),
        Light = Color3.fromRGB(70, 235, 135),
        Material = Enum.Material.Glass,
        Gradient = {
            Color3.fromRGB(190, 255, 210),
            Color3.fromRGB(20, 175, 85)
        }
    },
    {
        Name = "Gold",
        Reflectance = 0.15,
        Dark = Color3.fromRGB(150, 95, 20),
        Light = Color3.fromRGB(230, 185, 70),
        Material = Enum.Material.Foil,
        Gradient = {
            Color3.fromRGB(255, 245, 160),
            Color3.fromRGB(215, 140, 20)
        }
    },
    {
        Name = "Albino",
        Dark = Color3.fromRGB(195, 178, 184),
        Light = Color3.fromRGB(228, 222, 222),
        Material = Enum.Material.SmoothPlastic,
        Eyes = Color3.fromRGB(235, 70, 100),
        Gradient = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 180, 200)
        }
    }
}
t1.MutationByName = {}

for _, v6 in t1.Mutations do
    t1.MutationByName[v6.Name] = v6
end

t1.Mutations = {}

for _, v7 in Economy.Mutations do
    local v10 = assert(t1.MutationByName[v7.Name], (("Economy: no mutation look for %*"):format(v7.Name)))

    v10.Chance = v7.Percent / 100
    v10.Mult = v7.Income

    if v7.Percent > 0 then
        table.insert(t1.Mutations, v10)
    end
end

for v11, v12 in t1.MutationByName do
    assert(v12.Mult, (("Config: mutation %* has no Economy.Mutations entry"):format(v11)))
end

t1.MutationLuckPower = Economy.MutationLuckPower
t1.MutationLuckCap = Economy.MutationLuckCap
t1.Sizes = {
    {
        Name = "Big",
        Color = Color3.fromRGB(150, 230, 255),
        Gradient = {
            Color3.fromRGB(225, 250, 255),
            Color3.fromRGB(110, 200, 255)
        }
    },
    {
        Name = "Large",
        Color = Color3.fromRGB(120, 255, 170),
        Gradient = {
            Color3.fromRGB(215, 255, 225),
            Color3.fromRGB(60, 210, 120)
        }
    },
    {
        Name = "Huge",
        Color = Color3.fromRGB(255, 225, 90),
        Gradient = {
            Color3.fromRGB(255, 250, 190),
            Color3.fromRGB(255, 175, 30)
        }
    },
    {
        Name = "Colossal",
        Color = Color3.fromRGB(255, 150, 60),
        Gradient = {
            Color3.fromRGB(255, 215, 150),
            Color3.fromRGB(235, 90, 20)
        }
    },
    {
        Name = "Gigantic",
        Color = Color3.fromRGB(255, 80, 100),
        Gradient = {
            Color3.fromRGB(255, 180, 190),
            Color3.fromRGB(210, 25, 60)
        }
    },
    {
        Name = "Titanic",
        Shine = true,
        Color = Color3.fromRGB(200, 100, 255),
        Gradient = {
            Color3.fromRGB(240, 190, 255),
            Color3.fromRGB(130, 40, 230)
        }
    },
    {
        Name = "Monstrous",
        Shine = true,
        Color = Color3.fromRGB(170, 255, 60),
        Gradient = {
            Color3.fromRGB(230, 255, 160),
            Color3.fromRGB(60, 160, 20),
            Color3.fromRGB(20, 40, 10)
        }
    },
    {
        Name = "Cosmic",
        Shine = true,
        Color = Color3.fromRGB(150, 120, 255),
        Gradient = {
            Color3.fromRGB(255, 150, 240),
            Color3.fromRGB(110, 90, 255),
            Color3.fromRGB(25, 15, 80)
        }
    },
    {
        Name = "Infinite",
        Shine = true,
        Color = Color3.fromRGB(255, 255, 255),
        Gradient = {
            Color3.fromRGB(255, 110, 110),
            Color3.fromRGB(255, 235, 110),
            Color3.fromRGB(110, 255, 160),
            Color3.fromRGB(110, 170, 255),
            Color3.fromRGB(230, 110, 255)
        }
    }
}
t1.SizeByName = {}
assert(#Economy.Sizes == #t1.Sizes, "Economy.Sizes and Config.Sizes need the same sizes")

for v15, v16 in t1.Sizes do
    local v17 = Economy.Sizes[v15]

    assert(v17.Name == v16.Name, (("Economy.Sizes[%*] is %*, Config.Sizes[%*] is %*"):format(v15, v17.Name, v15, v16.Name)))
    v16.Index = v15
    v16.Chance = v17.Percent / 100
    v16.Mult = v17.Income
    v16.Scale = v17.Income ^ 0.3
    t1.SizeByName[v16.Name] = v16
end

t1.SizeLuckPower = Economy.SizeLuckPower
t1.SizeLuckCap = Economy.SizeLuckCap
t1.SizeStepMax = Economy.SizeStepMax
t1.BoostMult = 2
t1.BoostDuration = 3
t1.BoostWindow = 4
t1.BoostEvery = { 3, 5 }
t1.BoostColor = Color3.fromRGB(170, 70, 255)

function t1.repClock(p3, p4) -- line: 135
    -- upvalues: t1 (copy)
    local BoostUntil = p3:GetAttribute("BoostUntil")

    if BoostUntil and p4 < BoostUntil then
        local v20 = BoostUntil - t1.BoostDuration

        return v20 + math.max(p4 - v20, 0) * t1.BoostMult
    end

    return p4
end

function t1.repsPerSecond(p5, p6) -- line: 144
    -- upvalues: t1 (copy)
    local BoostUntil = p5 and p5:GetAttribute("BoostUntil")

    if BoostUntil and p6 < BoostUntil then
        return t1.BoostMult
    end

    return 1
end

t1.AdminUserIds = { 10816065985 }
t1.PassesOff = { 10816065985 }
t1.LuckStages = {
    {
        Title = "LUCKY!",
        Color = Color3.fromRGB(120, 255, 140)
    },
    {
        Title = "VERY LUCKY!",
        Color = Color3.fromRGB(90, 200, 255)
    },
    {
        Title = "INSANE LUCK!",
        Color = Color3.fromRGB(200, 110, 255)
    },
    {
        Title = "MIRACLE!",
        Color = Color3.fromRGB(255, 200, 60)
    },
    {
        Title = "UNREAL!",
        Color = Color3.fromRGB(255, 80, 120)
    },
    {
        Title = "IMPOSSIBLE!",
        Color = Color3.fromRGB(255, 255, 255)
    },
    {
        Title = "JACKPOT!",
        Color = Color3.fromRGB(255, 205, 50)
    },
    {
        Title = "MYTHICAL!",
        Color = Color3.fromRGB(255, 55, 75)
    },
    {
        Title = "COSMIC!",
        Color = Color3.fromRGB(70, 225, 255)
    },
    {
        Title = "DIVINE!",
        Color = Color3.fromRGB(255, 245, 200)
    },
    {
        Title = "BEYOND!",
        Color = Color3.fromRGB(255, 120, 255)
    }
}
t1.AnnounceLuckStage = 9

function t1.luckStage(p7) -- line: 180
    -- upvalues: t1 (copy)
    return (math.clamp(math.floor((math.log10((math.max(p7, 1))))) - 2, 0, #t1.LuckStages))
end

t1.MinCast = Economy.MinCast
t1.LastBiomeEnd = Economy.LastBiomeEnd
t1.MaxStuds = Canyon.END - 8
t1.Biomes = {
    {
        Name = "Backyard Pond",
        Icon = "🏡",
        Banner = "rbxassetid://116709053624959",
        Color = Color3.fromRGB(80, 175, 70)
    },
    {
        Name = "Misty Lake",
        Icon = "🌫️",
        Banner = "rbxassetid://73841740122563",
        Color = Color3.fromRGB(110, 150, 200)
    },
    {
        Name = "Mangrove Swamp",
        Icon = "🌿",
        Banner = "rbxassetid://113647955424244",
        Color = Color3.fromRGB(95, 125, 55)
    },
    {
        Name = "Sunny Shallows",
        Icon = "🏖️",
        Banner = "rbxassetid://123401730539579",
        Color = Color3.fromRGB(235, 185, 90)
    },
    {
        Name = "Coral Reef",
        Icon = "🪸",
        Banner = "rbxassetid://94167418241053",
        Color = Color3.fromRGB(250, 115, 135)
    },
    {
        Name = "Kelp Forest",
        Icon = "🌱",
        Banner = "rbxassetid://86426132739985",
        Color = Color3.fromRGB(50, 145, 95)
    },
    {
        Name = "Open Ocean",
        Icon = "🌊",
        Banner = "rbxassetid://97159882043371",
        Color = Color3.fromRGB(40, 110, 220)
    },
    {
        Name = "Frozen Sea",
        Icon = "❄️",
        Banner = "rbxassetid://105157385267126",
        Color = Color3.fromRGB(130, 200, 245)
    },
    {
        Name = "Abyss Trench",
        Icon = "🦑",
        Banner = "rbxassetid://127819779512655",
        Color = Color3.fromRGB(70, 50, 140)
    },
    {
        Name = "Volcanic Depths",
        Icon = "🌋",
        Banner = "rbxassetid://77579487543348",
        Color = Color3.fromRGB(215, 75, 30)
    },
    {
        Name = "Sunken Atlantis",
        Icon = "🏛️",
        Color = Color3.fromRGB(215, 175, 70)
    },
    {
        Name = "Storm Sea",
        Icon = "⛈️",
        Color = Color3.fromRGB(70, 95, 130)
    },
    {
        Name = "The Rift",
        Icon = "🌀",
        Color = Color3.fromRGB(190, 50, 210)
    },
    {
        Name = "Twilight Zone",
        Icon = "🌆",
        Color = Color3.fromRGB(60, 95, 170)
    },
    {
        Name = "Midnight Zone",
        Icon = "🌑",
        Color = Color3.fromRGB(35, 35, 95)
    },
    {
        Name = "Lantern Caves",
        Icon = "🏮",
        Color = Color3.fromRGB(80, 220, 200)
    },
    {
        Name = "Glass Sponge Reef",
        Icon = "🧽",
        Color = Color3.fromRGB(190, 215, 230)
    },
    {
        Name = "Brine Pools",
        Icon = "🧂",
        Color = Color3.fromRGB(170, 180, 195)
    },
    {
        Name = "Hydrothermal Vents",
        Icon = "♨️",
        Color = Color3.fromRGB(240, 110, 40)
    },
    {
        Name = "Whale Fall",
        Icon = "🦴",
        Color = Color3.fromRGB(225, 215, 190)
    },
    {
        Name = "Sunken Fleet",
        Icon = "⚓",
        Color = Color3.fromRGB(110, 135, 125)
    },
    {
        Name = "Hadal Trench",
        Icon = "🕳️",
        Color = Color3.fromRGB(40, 80, 210)
    },
    {
        Name = "The Maw",
        Icon = "👁️",
        Color = Color3.fromRGB(230, 50, 80)
    }
}

for v26, v27 in t1.Biomes do
    v27.Start = assert(Economy.BiomeStart[v27.Name], (("Economy: no BiomeStart for %*"):format(v27.Name)))
    v27.Index = v26
    v27.World = Canyon.worldOfBiome(v26)
end

assert(#t1.Biomes == Canyon.COUNT, "Config.Biomes and shared/Canyon need the same number of biomes")
t1.Worlds = {}

for v31, v32 in Canyon.WORLDS do
    local v33 = t1.Biomes[v32.Last + 1]

    t1.Worlds[v31] = {
        Index = v31,
        Name = v32.Name,
        First = v32.First,
        Last = v32.Last,
        Start = t1.Biomes[v32.First].Start,
        Finish = if v33 then v33.Start else Economy.LastBiomeEnd
    }
end

function t1.worldOfBiome(p8) -- line: 244
    -- upvalues: Canyon (copy)
    return Canyon.worldOfBiome(p8)
end

function t1.worldAt(p9) -- line: 249
    -- upvalues: Canyon (copy)
    return Canyon.worldAt(-p9.Z)
end

function t1.worldFolder(p10) -- line: 256
    local Map = workspace:FindFirstChild("Map")

    return Map and Map:FindFirstChild("World" .. p10)
end

function t1.inWorlds(p11) -- line: 262
    -- upvalues: Canyon (copy), t1 (copy)
    local t4 = {}

    for i = 1, #Canyon.WORLDS do
        local v34 = t1.worldFolder(i)
        local v35 = v34 and v34:FindFirstChild(p11)

        if v35 then
            table.insert(t4, v35)
        end
    end

    return t4
end

function t1.plotFolders() -- line: 277
    -- upvalues: t1 (copy)
    return t1.inWorlds("Plots")
end

function t1.allPlots() -- line: 282
    -- upvalues: t1 (copy)
    local t5 = {}

    for _, v36 in t1.plotFolders() do
        for _, child in v36:GetChildren() do
            table.insert(t5, child)
        end
    end

    return t5
end

function t1.plotWorld(p12) -- line: 292
    return p12:GetAttribute("World") or 1
end

function t1.plotOf(p13, p14) -- line: 297
    -- upvalues: t1 (copy)
    p14 = p14 or 1

    for _, v38 in t1.plotFolders() do
        for _, child in v38:GetChildren() do
            if child:GetAttribute("OwnerUserId") == p13 and t1.plotWorld(child) == p14 then
                return child
            end
        end
    end

    return nil
end

function t1.playerWorld(p15) -- line: 310
    -- upvalues: t1 (copy)
    local v39 = p15.Character and p15.Character:FindFirstChild("HumanoidRootPart")

    if v39 then
        return t1.worldAt(v39.Position)
    end

    return p15:GetAttribute("World") or 1
end

function t1.clampToWorld(p16, p17) -- line: 321
    -- upvalues: Economy (copy), t1 (copy)
    local v40 = t1.Worlds[p17] or t1.Worlds[1]
    local v41 = t1.Biomes[v40.First]
    local v42 = t1.Biomes[v40.First + 1]
    local Start = v41.Start

    if v40.Index > 1 and v42 then
        Start += (v42.Start - v41.Start) * Economy.MinCast / Economy.BiomeStart["Misty Lake"]
    end

    return (math.clamp(p16, Start, v40.Finish - 1))
end

local World2 = Economy.World2

function t1.virtualBiome(p18) -- line: 336
    -- upvalues: Canyon (copy), t1 (copy), World2 (copy)
    if Canyon.worldOfBiome((math.max(p18, 1))) == 1 then
        return p18
    end

    return World2.FirstLike + (p18 - t1.Worlds[2].First) * World2.BiomeStep
end

function t1.throwFor(p19) -- line: 344
    -- upvalues: t1 (copy), World2 (copy)
    local v44 = t1.Biomes[p19]

    if not v44 then
        return 1e999
    end

    return v44.World ~= 1 and World2.Reach[p19 - t1.Worlds[v44.World].First + 1] or v44.Start
end

function t1.worldThrow(p20, p21) -- line: 358
    -- upvalues: t1 (copy)
    local v45 = t1.Worlds[p21]

    if not v45 or v45.Index == 1 then
        return p20
    end

    local Biomes = t1.Biomes
    local v46 = t1.throwFor(v45.First)

    if p20 < v46 then
        return Biomes[v45.First].Start * p20 / v46
    end

    for i = v45.First, v45.Last do
        local v47 = t1.throwFor(i)
        local v48 = if i < v45.Last then t1.throwFor(i + 1) else v45.Finish

        if p20 < v48 then
            local v49 = if i < v45.Last then Biomes[i + 1].Start else v45.Finish

            return Biomes[i].Start + (p20 - v47) / (v48 - v47) * (v49 - Biomes[i].Start)
        end
    end

    return v45.Finish + (p20 - v45.Finish)
end

function t1.reachBiome(p22, p23) -- line: 380
    -- upvalues: t1 (copy)
    return t1.biomeAt(t1.clampToWorld(t1.worldThrow(t1.reach(p22), p23), p23))
end

t1.Rods = {
    {
        Name = "Twig Rod",
        Rarity = "Common",
        Color = Color3.fromRGB(140, 96, 58),
        Accent = Color3.fromRGB(90, 60, 35)
    },
    {
        Name = "Bamboo Rod",
        Rarity = "Uncommon",
        Color = Color3.fromRGB(196, 190, 90),
        Accent = Color3.fromRGB(110, 140, 50)
    },
    {
        Name = "Fiberglass Rod",
        Rarity = "Rare",
        Color = Color3.fromRGB(70, 150, 240),
        Accent = Color3.fromRGB(235, 235, 245)
    },
    {
        Name = "Carbon Rod",
        Rarity = "Rare",
        Color = Color3.fromRGB(40, 40, 46),
        Accent = Color3.fromRGB(230, 50, 50)
    },
    {
        Name = "Coral Rod",
        Rarity = "Epic",
        Neon = true,
        Color = Color3.fromRGB(255, 120, 130),
        Accent = Color3.fromRGB(255, 220, 120)
    },
    {
        Name = "Tidecaller Rod",
        Rarity = "Epic",
        Neon = true,
        Color = Color3.fromRGB(30, 170, 160),
        Accent = Color3.fromRGB(120, 255, 230)
    },
    {
        Name = "Golden Rod",
        Rarity = "Legendary",
        Neon = true,
        Color = Color3.fromRGB(255, 200, 50),
        Accent = Color3.fromRGB(255, 255, 200)
    },
    {
        Name = "Frostbite Rod",
        Rarity = "Legendary",
        Neon = true,
        Color = Color3.fromRGB(170, 225, 255),
        Accent = Color3.fromRGB(90, 200, 255)
    },
    {
        Name = "Abyssal Rod",
        Rarity = "Mythic",
        Neon = true,
        Color = Color3.fromRGB(70, 30, 120),
        Accent = Color3.fromRGB(190, 90, 255)
    },
    {
        Name = "Magma Rod",
        Rarity = "Mythic",
        Neon = true,
        Color = Color3.fromRGB(50, 30, 30),
        Accent = Color3.fromRGB(255, 120, 30)
    },
    {
        Name = "Starlight Rod",
        Rarity = "Ancient",
        Neon = true,
        Color = Color3.fromRGB(25, 35, 90),
        Accent = Color3.fromRGB(255, 235, 150)
    },
    {
        Name = "Nebula Rod",
        Rarity = "Celestial",
        Neon = true,
        Color = Color3.fromRGB(95, 40, 150),
        Accent = Color3.fromRGB(255, 120, 220)
    },
    {
        Name = "Kraken Rod",
        Rarity = "Cosmic",
        Neon = true,
        Color = Color3.fromRGB(30, 75, 70),
        Accent = Color3.fromRGB(230, 40, 60)
    },
    {
        Name = "Twilight Rod",
        Rarity = "Dusk",
        Neon = true,
        Color = Color3.fromRGB(45, 60, 120),
        Accent = Color3.fromRGB(255, 170, 120)
    },
    {
        Name = "Midnight Rod",
        Rarity = "Nightfall",
        Neon = true,
        Color = Color3.fromRGB(20, 20, 45),
        Accent = Color3.fromRGB(120, 110, 255)
    },
    {
        Name = "Lantern Rod",
        Rarity = "Lumen",
        Neon = true,
        Color = Color3.fromRGB(40, 70, 75),
        Accent = Color3.fromRGB(110, 255, 230)
    },
    {
        Name = "Glass Sponge Rod",
        Rarity = "Phantom",
        Neon = true,
        Color = Color3.fromRGB(200, 220, 235),
        Accent = Color3.fromRGB(255, 255, 255)
    },
    {
        Name = "Brine Rod",
        Rarity = "Quicksilver",
        Neon = true,
        Color = Color3.fromRGB(150, 160, 175),
        Accent = Color3.fromRGB(235, 245, 255)
    },
    {
        Name = "Vent Rod",
        Rarity = "Thermal",
        Neon = true,
        Color = Color3.fromRGB(40, 30, 30),
        Accent = Color3.fromRGB(255, 120, 40)
    },
    {
        Name = "Bone Rod",
        Rarity = "Bonecrest",
        Neon = true,
        Color = Color3.fromRGB(230, 220, 195),
        Accent = Color3.fromRGB(120, 255, 200)
    },
    {
        Name = "Salvage Rod",
        Rarity = "Dreadnought",
        Neon = true,
        Color = Color3.fromRGB(95, 110, 105),
        Accent = Color3.fromRGB(255, 200, 80)
    },
    {
        Name = "Trench Rod",
        Rarity = "Hadal",
        Neon = true,
        Color = Color3.fromRGB(15, 25, 60),
        Accent = Color3.fromRGB(80, 150, 255)
    },
    {
        Name = "Leviathan Rod",
        Rarity = "Fathom",
        Neon = true,
        Color = Color3.fromRGB(35, 10, 30),
        Accent = Color3.fromRGB(255, 60, 90)
    }
}
assert(#Economy.Rods == #t1.Rods, "Economy.Rods and Config.Rods need the same rods")

for v51, v52 in t1.Rods do
    local v53 = Economy.Rods[v51]

    assert(v53.Name == v52.Name, (("Economy.Rods[%*] is %*, Config.Rods[%*] is %*"):format(v51, v53.Name, v51, v52.Name)))

    local Reel, Price = v53.Reel, v53.Price

    v52.Reel = Reel
    v52.Price = Price
end

t1.Baits = {
    {
        Key = "Cricket",
        Rarity = "Rare",
        Color = Color3.fromRGB(110, 150, 60),
        Accent = Color3.fromRGB(200, 230, 120)
    },
    {
        Key = "GoldenWorm",
        Rarity = "Legendary",
        Color = Color3.fromRGB(255, 200, 50),
        Accent = Color3.fromRGB(255, 245, 170)
    },
    {
        Key = "GlowShrimp",
        Rarity = "Ancient",
        Color = Color3.fromRGB(255, 120, 90),
        Accent = Color3.fromRGB(120, 255, 230)
    },
    {
        Key = "GalaxyLure",
        Rarity = "Cosmic",
        Color = Color3.fromRGB(70, 40, 170),
        Accent = Color3.fromRGB(255, 130, 230)
    },
    {
        Key = "StormLure",
        Rarity = "Abyssal",
        Color = Color3.fromRGB(45, 55, 80),
        Accent = Color3.fromRGB(120, 200, 255)
    },
    {
        Key = "DiamondLure",
        Rarity = "Radiant",
        Color = Color3.fromRGB(120, 210, 255),
        Accent = Color3.fromRGB(235, 255, 255)
    },
    {
        Key = "RainbowBait",
        Rarity = "Glitched",
        Rainbow = true,
        Color = Color3.fromRGB(255, 90, 90),
        Accent = Color3.fromRGB(255, 255, 255)
    }
}
t1.BaitByKey = {}

for v56, v57 in t1.Baits do
    local v58 = Economy.Baits[v56]

    assert(v58.Key == v57.Key, (("Economy.Baits[%*] is %*, Config.Baits[%*] is %*"):format(v56, v58.Key, v56, v57.Key)))

    local Name, Luck, Rainbow, Price = v58.Name, v58.Luck, v58.Rainbow, v58.Price
    local Product = v58.Product

    v57.Name = Name
    v57.Luck = Luck
    v57.RainbowMult = Rainbow
    v57.Price = Price
    v57.Product = Product
    t1.BaitByKey[v57.Key] = v57
end

function t1.baitLuck(p24) -- line: 440
    -- upvalues: t1 (copy)
    local v61 = p24 and t1.BaitByKey[p24]

    if v61 then
        return v61.Luck
    end

    return 1
end

t1.Barbells = {}

for v62, v63 in Economy.Barbells do
    t1.Barbells[v62] = {
        PerSec = v63.Strength * Economy.BarbellXPMult,
        Price = v63.Price,
        Model = string.format("BB_Tier%02d", v62)
    }
end

t1.BarbellMaxWidth = 14

function t1.barbellScale(p25) -- line: 454
    -- upvalues: t1 (copy)
    if p25.X > t1.BarbellMaxWidth then
        return t1.BarbellMaxWidth / p25.X
    end

    return 1
end

t1.PerfectQuality = 0.86
t1.PerfectLuck = 1.5
t1.MaxInventory = 1e999
t1.HotbarSlots = 10
t1.SellMultiplier = Economy.SellSeconds
t1.MegaMult = 9
t1.ShopAnimalMin = 100
t1.CastCooldown = 3
t1.CastPace = 0.7
t1.StrengthPerLevel = Economy.StrengthPerLevel

local LevelMerge = Economy.LevelMerge

local function stepXP(p26) -- line: 486
    -- upvalues: Economy (copy)
    local v64 = Economy.XPEarly[p26]

    if v64 then
        return (math.round(v64 * Economy.XPScale))
    end

    return (math.max(math.round(Economy.XPBase * p26 ^ Economy.XPGrowth), 1))
end

local t6 = {
    0
}
local v68 = Economy.XPGrowth + 1
local v69 = Economy.XPBase / v68

local function totalFor(p27) -- line: 497
    -- upvalues: Economy (copy), t6 (copy), v68 (copy), v69 (copy), totalFor (copy)
    if p27 > 1E+05 then
        return totalFor(1E+05) + v69 * ((p27 - 0.5) ^ v68 - 99999.5 ^ v68)
    end

    while #t6 < p27 do
        local v70 = #t6
        local v71 = v70 + 1
        local v72 = t6[v70]
        local v73 = Economy.XPEarly[v70]

        t6[v71] = v72 + (if v73 then math.round(v73 * Economy.XPScale) else math.max(math.round(Economy.XPBase * v70 ^ Economy.XPGrowth), 1))
    end

    return t6[p27]
end

function t1.strengthLevelTotal(p28) -- line: 510
    -- upvalues: LevelMerge (copy), totalFor (copy)
    return (totalFor(LevelMerge * (math.max(math.floor(p28), 1) - 1) + 1))
end

local function stepOf(p29) -- line: 517
    -- upvalues: Economy (copy), t6 (copy), v68 (copy), v69 (copy), totalFor (copy)
    local v79 = math.max(p29, 0)

    while #t6 < 1E+05 do
        local v80 = #t6
        local v81 = v80 + 1
        local v82 = t6[v80]
        local v83 = Economy.XPEarly[v80]

        t6[v81] = v82 + (if v83 then math.round(v83 * Economy.XPScale) else math.max(math.round(Economy.XPBase * v80 ^ Economy.XPGrowth), 1))
    end

    local v88

    if t6[1E+05] <= v79 then
        while #t6 < 1E+05 do
            local v89 = #t6
            local v90 = v89 + 1
            local v91 = t6[v89]
            local v92 = Economy.XPEarly[v89]

            t6[v90] = v91 + (if v92 then math.round(v92 * Economy.XPScale) else math.max(math.round(Economy.XPBase * v89 ^ Economy.XPGrowth), 1))
        end

        v88 = math.max(math.floor(((v79 - t6[1E+05]) / v69 + 99999.5 ^ v68) ^ (1 / v68) + 0.5), 1E+05)

        while v88 > 1E+05 and v79 < totalFor(v88) do
            v88 -= 1
        end

        while totalFor(v88 + 1) <= v79 do
            v88 += 1
        end
    else
        v88 = 1

        local n1 = 2

        while totalFor(n1) <= v79 do
            v88 = n1
            n1 *= 2
        end

        while n1 - v88 > 1 do
            local v99 = (v88 + n1) // 2

            if totalFor(v99) <= v79 then
                v88 = v99
            else
                n1 = v99
            end
        end
    end

    return v88
end

function t1.strengthLevelOf(p30) -- line: 548
    -- upvalues: LevelMerge (copy), stepOf (copy)
    return (stepOf((math.max(p30, 0))) - 1) // LevelMerge + 1
end

function t1.strengthOf(p31) -- line: 553
    -- upvalues: t1 (copy)
    return (t1.strengthLevelOf(p31) - 1) * t1.StrengthPerLevel
end

t1.ThrowBase = Economy.ThrowBase
t1.ThrowPerStrength = Economy.ThrowPerStrength
t1.ThrowExponent = Economy.ThrowExponent

function t1.throwPower(p32) -- line: 563
    -- upvalues: t1 (copy)
    return t1.ThrowBase + t1.ThrowPerStrength * math.max(p32, 0) ^ t1.ThrowExponent
end

function t1.strengthLevelForThrow(p33) -- line: 568
    -- upvalues: t1 (copy)
    return math.ceil((math.max(p33 - t1.ThrowBase, 0) / t1.ThrowPerStrength) ^ (1 / t1.ThrowExponent) / t1.StrengthPerLevel - 1E-09) + 1
end

function t1.xpForThrow(p34) -- line: 574
    -- upvalues: t1 (copy)
    return t1.strengthLevelTotal(t1.strengthLevelForThrow(p34))
end

local function usualTier(p35) -- line: 589
    -- upvalues: Economy (copy), t1 (copy)
    local LevelTierFit = Economy.LevelTierFit

    return (math.clamp(LevelTierFit.Tier + (math.log(math.max(p35, 1), 2) - math.log(LevelTierFit.Strength, 2)) / LevelTierFit.Log2PerTier, 1, #t1.Barbells))
end

local function tierRepXP(p36) -- line: 596
    -- upvalues: t1 (copy)
    local v106 = math.floor(p36)
    local v109 = math.min(v106 + 1, #t1.Barbells)
    local PerSec = t1.Barbells[v106].PerSec

    return PerSec * (t1.Barbells[v109].PerSec / PerSec) ^ (p36 - v106)
end

local function tierOfRepXP(p37) -- line: 604
    -- upvalues: t1 (copy)
    local Barbells = t1.Barbells

    if p37 <= Barbells[1].PerSec then
        return 1
    end

    for i = 1, #Barbells - 1 do
        local PerSec = Barbells[i].PerSec
        local PerSec2 = Barbells[i + 1].PerSec

        if p37 <= PerSec2 then
            return i + math.log(p37 / PerSec) / math.log(PerSec2 / PerSec)
        end
    end

    return #Barbells
end

local function repsShare(p38) -- line: 620
    -- upvalues: Economy (copy)
    local v114 = math.clamp((p38 - 1) / (Economy.RepsFullTier - 1), 0, 1)

    return (Economy.RepsEarly / Economy.RepsPerLevel) ^ (1 - v114)
end

function t1.levelCostFull(p39) -- line: 627
    -- upvalues: Economy (copy), t1 (copy)
    local RepsPerLevel, LevelTierFit = Economy.RepsPerLevel, Economy.LevelTierFit
    local v119 = math.clamp(LevelTierFit.Tier + (math.log(math.max(p39, 1), 2) - math.log(LevelTierFit.Strength, 2)) / LevelTierFit.Log2PerTier, 1, #t1.Barbells)
    local v120 = math.floor(v119)
    local v123 = math.min(v120 + 1, #t1.Barbells)
    local PerSec = t1.Barbells[v120].PerSec

    return (math.max(math.floor(RepsPerLevel * (PerSec * (t1.Barbells[v123].PerSec / PerSec) ^ (v119 - v120))), 1))
end

function t1.levelCost(p40, p41) -- line: 633
    -- upvalues: Economy (copy), t1 (copy), tierOfRepXP (copy)
    local LevelTierFit = Economy.LevelTierFit
    local v130 = math.clamp(LevelTierFit.Tier + (math.log(math.max(p40, 1), 2) - math.log(LevelTierFit.Strength, 2)) / LevelTierFit.Log2PerTier, 1, #t1.Barbells)
    local RepsPerLevel = Economy.RepsPerLevel
    local v132 = math.clamp((v130 - 1) / (Economy.RepsFullTier - 1), 0, 1)
    local v133 = RepsPerLevel * (Economy.RepsEarly / Economy.RepsPerLevel) ^ (1 - v132)
    local v134 = math.floor(v130)
    local v137 = math.min(v134 + 1, #t1.Barbells)
    local PerSec = t1.Barbells[v134].PerSec
    local v138 = v133 * (PerSec * (t1.Barbells[v137].PerSec / PerSec) ^ (v130 - v134))

    if p41 and p41 > 0 then
        local MinRepsPerLevel = Economy.MinRepsPerLevel
        local v140 = math.clamp((tierOfRepXP(p41) - 1) / (Economy.RepsFullTier - 1), 0, 1)

        v138 = math.max(v138, MinRepsPerLevel * (Economy.RepsEarly / Economy.RepsPerLevel) ^ (1 - v140) * p41)
    end

    return (math.max(math.floor(v138), 1))
end

local t7 = { 0 }

function t1.levelFromXP(p42) -- line: 644
    -- upvalues: t1 (copy), t7 (copy)
    local v143 = math.max(p42, 0)

    while t7[#t7] <= v143 and #t7 < 2E+05 do
        local v144 = t7[#t7]

        table.insert(t7, v144 + t1.levelCost(t1.strengthOf(v144)))
    end

    local v146 = 1
    local v147 = #t7

    while v146 < v147 do
        local v148 = (v146 + v147 + 1) // 2

        if t7[v148] <= v143 then
            v146 = v148
        else
            v147 = v148 - 1
        end
    end

    return v146, v143 - t7[v146]
end

function t1.reach(p43) -- line: 663
    -- upvalues: t1 (copy)
    return t1.throwPower(p43)
end

function t1.castDistance(p44, p45) -- line: 668
    -- upvalues: t1 (copy)
    local v149 = if t1.PerfectQuality <= p45 then 1 else p45 * 0.65 + 0.35

    return (math.max(t1.reach(p44) * v149, t1.MinCast))
end

function t1.capMeters(p46) -- line: 675
    -- upvalues: t1 (copy)
    local v151 = p46 and p46 > 0 and t1.Biomes[p46 + 1]

    if v151 then
        return v151.Start - 1
    end

    return 1e999
end

function t1.toStuds(p47) -- line: 682
    -- upvalues: Canyon (copy), t1 (copy)
    local Biomes = t1.Biomes

    for v152, v153 in Biomes do
        local v154 = if Biomes[v152 + 1] then Biomes[v152 + 1].Start else t1.LastBiomeEnd

        if p47 < v154 or v152 == #Biomes then
            local v156 = math.clamp((p47 - v153.Start) / (v154 - v153.Start), 0, 1)

            return (math.min(Canyon.studsAt(v152 - 1 + v156), t1.MaxStuds))
        end
    end

    return t1.MaxStuds
end

function t1.toMeters(p48) -- line: 695
    -- upvalues: Canyon (copy), t1 (copy)
    local Biomes = t1.Biomes
    local v158 = Canyon.progress((math.max(p48, 0)))
    local v161 = math.clamp(math.floor(v158) + 1, 1, #Biomes)
    local Start = Biomes[v161].Start
    local v162 = if Biomes[v161 + 1] then Biomes[v161 + 1].Start else t1.LastBiomeEnd

    return Start + math.clamp(v158 - (v161 - 1), 0, 1) * (v162 - Start)
end

t1.OddsBase = 8.1
t1.BiomeOddsStep = 3.5
t1.WorldOddsJump = Economy.World2.OddsJump

function t1.oddsScale(p49) -- line: 714
    -- upvalues: Canyon (copy), t1 (copy)
    if p49 <= 1 then
        return 1
    end

    return t1.OddsBase * t1.BiomeOddsStep ^ (p49 - 2) * t1.WorldOddsJump ^ (Canyon.worldOfBiome(p49) - 1)
end

local function luckCap(p50) -- line: 727
    -- upvalues: Canyon (copy)
    return Canyon.SEGMENT * Canyon.WORLDS[Canyon.worldAt(p50)].Last - 8
end

local BiomeLuck = Economy.BiomeLuck

function t1.distanceLuck(p51) -- line: 731
    -- upvalues: Canyon (copy), BiomeLuck (copy)
    local v164 = Canyon.progress((math.max(p51, 0)))
    local v167 = math.clamp(math.floor(v164) + 1, 1, #BiomeLuck)
    local v171 = BiomeLuck[v167] + ((BiomeLuck[v167 + 1] or BiomeLuck[v167]) - BiomeLuck[v167]) * math.clamp(v164 - (v167 - 1), 0, 1)
    local v172 = v164 * Canyon.SEGMENT
    local v173 = math.max(p51, 0)

    return (math.min(v172, Canyon.SEGMENT * Canyon.WORLDS[Canyon.worldAt(v173)].Last - 8) / 16 + 1) * v171
end

function t1.castLuck(p52) -- line: 738
    -- upvalues: t1 (copy)
    return t1.distanceLuck(t1.toStuds(p52))
end

t1.LuckTilt = 0.13

function t1.biomeAt(p53) -- line: 748
    -- upvalues: t1 (copy)
    local n2 = 1

    for v175, v176 in t1.Biomes do
        if v176.Start <= p53 then
            n2 = v175
        end
    end

    return n2
end

function t1.nextBiome(p54) -- line: 759
    -- upvalues: t1 (copy)
    for _, v177 in t1.Biomes do
        if p54 < v177.Start then
            return v177
        end
    end

    return nil
end

function t1.throwText(p55, p56) -- line: 770
    -- upvalues: t1 (copy)
    local v178 = t1.nextBiome(p55)
    local v179 = ("%*m"):format((p56((math.floor(p55)))))

    if v178 then
        return (("%* / %*m to %*"):format(v179, p56(v178.Start), v178.Name))
    end

    return v179
end

function t1.fishPower(p57, p58, p59) -- line: 778
    -- upvalues: Economy (copy)
    return Economy.FishPower[math.clamp(p57, 1, #Economy.FishPower)] * (1 + Economy.RarityPower * math.max(p58 - p59, 0))
end

function t1.fightRatio(p60, p61) -- line: 784
    -- upvalues: t1 (copy)
    return p60 / t1.Rods[math.clamp(p61, 1, #t1.Rods)].Reel
end

function t1.biomeAtStuds(p62) -- line: 789
    -- upvalues: Canyon (copy)
    return Canyon.biomeAt(p62)
end

t1.PenLevels = {}

for v184, v185 in Economy.PlotUpgrades do
    t1.PenLevels[v184] = {
        Capacity = v185.Animals,
        Length = 40 + 10 * v184,
        Price = v185.Price
    }
end

function t1.penCapacity(p63) -- line: 800
    -- upvalues: t1 (copy)
    return t1.PenLevels[math.clamp(p63, 1, #t1.PenLevels)].Capacity
end

function t1.bossRodPower(p64) -- line: 806
    -- upvalues: Economy (copy), t1 (copy)
    local Boss = Economy.Boss

    return Boss.RodStep ^ (math.clamp(p64, 1, #t1.Rods) - Boss.RecommendedRod)
end

function t1.bossHealth(p65) -- line: 812
    -- upvalues: Economy (copy), t1 (copy)
    return Economy.Boss.HealthPerPlayer * t1.bossRodPower(p65)
end

function t1.bossCash(p66, p67) -- line: 818
    -- upvalues: Economy (copy)
    local Boss = Economy.Boss
    local v189 = math.clamp(p66, 1, #Economy.Rods)
    local v190 = Economy.Rods[v189 + 1]

    return (if v190 then v190.Price else Economy.Rods[v189].Price * Boss.RodNextStep) * (if p67 then Boss.WinRodCash else Boss.EscapeRodCash)
end

function t1.subBossPower(p68) -- line: 827
    -- upvalues: Economy (copy), t1 (copy)
    return Economy.Boss.RodStep ^ (math.clamp(p68, 1, #t1.Rods) - Economy.SubBoss.RecommendedRod)
end

function t1.subBossHealth(p69) -- line: 831
    -- upvalues: Economy (copy), t1 (copy)
    return Economy.SubBoss.HealthPerPlayer * t1.subBossPower(p69)
end

t1.TooStrongRatio = 2

function t1.tankBoostMult(p70) -- line: 841
    -- upvalues: Economy (copy)
    return Economy.TankBoost.Income ^ math.max(p70 or 0, 0)
end

function t1.tankBoostPrice(p71) -- line: 846
    -- upvalues: Economy (copy)
    return Economy.TankBoost.Price * Economy.TankBoost.PriceGrowth ^ math.max(p71 or 0, 0)
end

local LegacyPrices = Economy.LegacyPrices

local function lower(p72, p73, p74) -- line: 854
    if not p74 or not p73 then
        return p72
    end

    return (math.min(p72, p73))
end

function t1.rodPrice(p75, p76) -- line: 858
    -- upvalues: t1 (copy), LegacyPrices (copy)
    local v194 = t1.Rods[p75]

    if not v194 then
        return 1e999
    end

    local Price = v194.Price
    local v195 = LegacyPrices.Rods[p75]

    if not p76 or not v195 then
        return Price
    end

    return (math.min(Price, v195))
end

function t1.barbellPrice(p77, p78) -- line: 863
    -- upvalues: t1 (copy), LegacyPrices (copy)
    local v196 = t1.Barbells[p77]

    if not v196 then
        return 1e999
    end

    local Price = v196.Price
    local v197 = LegacyPrices.Barbells[p77]

    if not p78 or not v197 then
        return Price
    end

    return (math.min(Price, v197))
end

function t1.penPrice(p79, p80) -- line: 868
    -- upvalues: t1 (copy), LegacyPrices (copy)
    local v198 = t1.PenLevels[p79]

    if not v198 then
        return 1e999
    end

    local Price = v198.Price
    local v199 = LegacyPrices.PlotUpgrades[p79]

    if not p80 or not v199 then
        return Price
    end

    return (math.min(Price, v199))
end

function t1.penNextPrice(p81, p82, p83) -- line: 874
    -- upvalues: t1 (copy)
    if t1.PenLevels[p81 + 1] then
        return (t1.penPrice(p81 + 1, p83))
    end

    return (t1.tankBoostPrice(p82))
end

function t1.rebirthStrength(p84) -- line: 884
    -- upvalues: Economy (copy), t1 (copy)
    return t1.strengthOf(50000 * Economy.XPGain * 5 ^ p84)
end

function t1.rebirthCost(p85) -- line: 888
    return 45 ^ p85 * 5E+08
end

t1.RebirthStep = 0.5

function t1.rebirthMultiplier(p86) -- line: 894
    -- upvalues: t1 (copy)
    return 1 + t1.RebirthStep * p86
end

t1.TutorialDone = 7
t1.TutorialFirstCatch = "Tadpole"
t1.TutorialSecondCatch = "Perch"
t1.TutorialSecondMutation = "Gold"
t1.TutorialSecondDistance = { 110, 160 }
t1.OfflineRate = 0.5
t1.OfflineMax = 28800
t1.OfflineMin = 60
t1.FeedbackTopics = { "Bug", "Idea", "Too slow", "Confusing", "Same animals again", "Not what I expected", "Animals look bad", "Other" }
t1.FeedbackMaxText = 300
t1.Survey = {
    Id = "Survey1",
    RewardStat = "Strength",
    RewardSeconds = 300,
    Questions = {
        {
            Text = "What's your favorite part?",
            Answers = { "Fishing", "Collecting animals", "Upgrading", "Mini games" }
        },
        {
            Text = "What should we add next?",
            Answers = { "Trading", "Animals that follow you", "Boss fish events", "More biomes" }
        },
        {
            Text = "Why do you usually stop playing?",
            Answers = { "It gets too slow", "Nothing new to do", "Hard to understand", "I just had to go" }
        }
    }
}
t1.StartingMoney = Economy.StartingMoney
t1.Event = {
    Title = "NEW BIOMES!",
    StartsAt = 1794070800,
    EventId = "808527636686045763",
    Lines = { "Brand new waters to fish!", "New animals & rarities" }
}
t1.Icons = {
    Cash = "rbxassetid://71628031548829",
    Strength = "rbxassetid://110891746929383",
    Luck = "rbxassetid://107143611085209",
    Studs = "rbxassetid://119333628586137",
    Diamond = "rbxassetid://99103671929281",
    Expand = "rbxassetid://110584804968584",
    AutoTrain = "rbxassetid://136756925629856",
    AutoClicker = "rbxassetid://137820363850571"
}
t1.Font = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
t1.Sounds = {
    ShopBell = "rbxassetid://127488139302452",
    Splash = "rbxassetid://9125703162",
    Whoosh = "rbxassetid://9120972321",
    CastSwing = "rbxassetid://90429269035664",
    CastLine = "rbxassetid://119135010875996",
    Reel = "rbxassetid://79404754846319",
    Bubbles = "rbxassetid://9125409816",
    BubbleSwell = "rbxassetid://9113604980",
    Reveal = "rbxassetid://123469584917030",
    Cash = "rbxassetid://607665037",
    Click = "rbxassetid://8755541422",
    Pop = "rbxassetid://6586979979",
    Clank = "rbxassetid://9125370141",
    Rep = "rbxassetid://139540283473798",
    Tick = "rbxassetid://119354387183704",
    ReelClick = "rbxassetid://119354387183704",
    Place = "rbxassetid://109359226723492",
    GoodCast = "rbxassetid://135165335432475",
    SpeedUp = "rbxassetid://118134581974347",
    Dock = "rbxassetid://71894224454156",
    BaitFlight = "rbxassetid://5813077875",
    OddsRise = "rbxassetid://124533678673427",
    Ambience = "rbxassetid://9116971178",
    LuckTick = "rbxassetid://139804904213958",
    LuckRung = "rbxassetid://76834925120308",
    LuckRungHit = "rbxassetid://139520673393967",
    LuckRungRewards = "rbxassetid://96102213526905",
    Lightning = "rbxassetid://77831426573414",
    LevelUp = "rbxassetid://112485797063762",
    LevelUpAgain = "rbxassetid://127199850989931",
    Luck1 = "rbxassetid://117011707307950",
    Luck2 = "rbxassetid://118074575456339",
    Luck3 = "rbxassetid://1841310289",
    Luck4 = "rbxassetid://119620526223720",
    Luck5 = "rbxassetid://1837564490",
    Luck6 = "rbxassetid://9039598193",
    Luck7 = "rbxassetid://1837830119",
    Luck8 = "rbxassetid://1841760054",
    Luck9 = "rbxassetid://9119609644",
    Luck10 = "rbxassetid://1846902441",
    Luck11 = "rbxassetid://103626556433205",
    LuckHeartbeat = "rbxassetid://9043365842",
    LuckSwell = "rbxassetid://1843029045",
    LuckShatter = "rbxassetid://9114590265",
    Snore = "rbxassetid://135148954440171",
    Scream = "rbxassetid://118503101889893",
    Flex = "rbxassetid://123816138175923",
    Bite = "rbxassetid://115878657073501",
    AnimeImpact = "rbxassetid://76282244357184",
    Laugh = "rbxassetid://113174873617518",
    BooWomp = "rbxassetid://18965815228",
    TripShocked = "rbxassetid://139345986070502",
    TripGasp = "rbxassetid://87055715509196",
    TripCall = "rbxassetid://91257505505742",
    TripJumpscare = "rbxassetid://395999128",
    TripDizzy = "rbxassetid://8730871251",
    TripBonk = "rbxassetid://137041944943141",
    TripCall2 = "rbxassetid://7971843171",
    BossFirstRoar = "rbxassetid://120033344996381",
    BossRoar = "rbxassetid://140520408524334",
    BossHitRoar = "rbxassetid://110716346002611",
    BossGrowl = "rbxassetid://9113971531",
    MetalClang = "rbxassetid://9125782404",
    ChairCreak = "rbxassetid://9120806410",
    SubBoom = "rbxassetid://1837830119",
    Rumble = "rbxassetid://9113222970",
    BigSplash = "rbxassetid://9119476512",
    Sinking = "rbxassetid://9113603652",
    Splat = "rbxassetid://9120572959",
    Spit = "rbxassetid://9120086770",
    BossGotAnimal = "rbxassetid://341542294",
    BossScreech = "rbxassetid://117561590219576",
    BossExplosion = "rbxassetid://103626556433205"
}

return t1
