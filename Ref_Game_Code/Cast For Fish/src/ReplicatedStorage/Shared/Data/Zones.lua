-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local GameConfig = require(script.Parent.Parent.GameConfig)
local t1 = {
    {
        id = "shallows",
        name = "Shallows",
        folder = "Shallows",
        icon = "🌴",
        Color = fromRGB(90, 225, 120)
    },
    {
        id = "coral_reef",
        name = "Coral Reef",
        folder = "Coral Reef",
        icon = "🐠",
        Color = fromRGB(255, 120, 180)
    },
    {
        id = "deep_sea",
        name = "Deep Sea",
        folder = "Deep Sea",
        icon = "🌊",
        Color = fromRGB(90, 150, 255)
    },
    {
        id = "kelp_forest",
        name = "Kelp Forest",
        folder = "Kelp Forest",
        icon = "🌿",
        Color = fromRGB(60, 190, 110),
        world = {
            water = fromRGB(30, 120, 110),
            seabed = fromRGB(60, 90, 60),
            cliff = fromRGB(70, 95, 70),
            cap = fromRGB(110, 200, 90),
            fog = fromRGB(30, 110, 90),
            glow = fromRGB(150, 255, 140)
        }
    },
    {
        id = "mangrove_swamp",
        name = "Mangrove Swamp",
        folder = "Mangrove Swamp",
        icon = "🐸",
        Color = fromRGB(150, 170, 70),
        world = {
            water = fromRGB(70, 105, 60),
            seabed = fromRGB(80, 65, 45),
            cliff = fromRGB(95, 75, 50),
            cap = fromRGB(120, 150, 60),
            fog = fromRGB(70, 95, 50),
            glow = fromRGB(210, 255, 120)
        }
    },
    {
        id = "frozen_fjord",
        name = "Frozen Fjord",
        folder = "Frozen Fjord",
        icon = "❄️",
        Color = fromRGB(150, 225, 255),
        world = {
            water = fromRGB(90, 170, 220),
            seabed = fromRGB(150, 190, 220),
            cliff = fromRGB(130, 165, 200),
            cap = fromRGB(240, 248, 255),
            fog = fromRGB(110, 180, 225),
            glow = fromRGB(190, 240, 255)
        }
    },
    {
        id = "sunken_ruins",
        name = "Sunken Ruins",
        folder = "Sunken Ruins",
        icon = "🏛️",
        Color = fromRGB(235, 205, 120),
        world = {
            water = fromRGB(40, 130, 150),
            seabed = fromRGB(170, 160, 125),
            cliff = fromRGB(150, 140, 110),
            cap = fromRGB(215, 200, 150),
            fog = fromRGB(45, 125, 140),
            glow = fromRGB(255, 220, 110)
        }
    },
    {
        id = "volcanic_vents",
        name = "Volcanic Vents",
        folder = "Volcanic Vents",
        icon = "🌋",
        Color = fromRGB(255, 110, 50),
        world = {
            water = fromRGB(120, 45, 40),
            seabed = fromRGB(45, 38, 42),
            cliff = fromRGB(55, 45, 48),
            cap = fromRGB(255, 120, 40),
            fog = fromRGB(110, 40, 30),
            glow = fromRGB(255, 140, 40)
        }
    },
    {
        id = "crystal_caverns",
        name = "Crystal Caverns",
        folder = "Crystal Caverns",
        icon = "💎",
        Color = fromRGB(200, 130, 255),
        world = {
            water = fromRGB(90, 60, 170),
            seabed = fromRGB(60, 50, 95),
            cliff = fromRGB(70, 55, 110),
            cap = fromRGB(190, 130, 255),
            fog = fromRGB(85, 55, 160),
            glow = fromRGB(230, 160, 255)
        }
    },
    {
        id = "shipwreck_graveyard",
        name = "Shipwreck Graveyard",
        folder = "Shipwreck Graveyard",
        icon = "⚓",
        Color = fromRGB(150, 165, 150),
        world = {
            water = fromRGB(55, 85, 90),
            seabed = fromRGB(85, 85, 75),
            cliff = fromRGB(80, 85, 80),
            cap = fromRGB(135, 150, 130),
            fog = fromRGB(50, 80, 85),
            glow = fromRGB(150, 255, 200)
        }
    },
    {
        id = "abyssal_trench",
        name = "Abyssal Trench",
        folder = "Abyssal Trench",
        icon = "🕳️",
        Color = fromRGB(120, 60, 200),
        world = {
            water = fromRGB(20, 14, 50),
            seabed = fromRGB(22, 18, 34),
            cliff = fromRGB(28, 22, 44),
            cap = fromRGB(90, 40, 160),
            fog = fromRGB(14, 8, 34),
            glow = fromRGB(255, 70, 230)
        }
    },
    {
        id = "storm_sea",
        name = "Storm Sea",
        folder = "Storm Sea",
        icon = "⚡",
        Color = fromRGB(255, 235, 90),
        world = {
            water = fromRGB(50, 65, 105),
            seabed = fromRGB(60, 66, 85),
            cliff = fromRGB(70, 76, 96),
            cap = fromRGB(130, 140, 165),
            fog = fromRGB(45, 58, 95),
            glow = fromRGB(255, 240, 110)
        }
    },
    {
        id = "celestial_ocean",
        name = "Celestial Ocean",
        folder = "Celestial Ocean",
        icon = "🌌",
        Color = fromRGB(255, 190, 250),
        world = {
            water = fromRGB(60, 40, 140),
            seabed = fromRGB(40, 30, 90),
            cliff = fromRGB(50, 36, 110),
            cap = fromRGB(255, 200, 250),
            fog = fromRGB(50, 30, 120),
            glow = fromRGB(255, 245, 190)
        }
    },
    {
        id = "toxic_lagoon",
        name = "Toxic Lagoon",
        folder = "Toxic Lagoon",
        icon = "☣️",
        Color = fromRGB(160, 255, 60),
        world = {
            water = fromRGB(70, 150, 40),
            seabed = fromRGB(60, 70, 40),
            cliff = fromRGB(75, 80, 60),
            cap = fromRGB(150, 220, 60),
            fog = fromRGB(60, 130, 30),
            glow = fromRGB(190, 255, 60)
        }
    },
    {
        id = "clockwork_depths",
        name = "Clockwork Depths",
        folder = "Clockwork Depths",
        icon = "⚙️",
        Color = fromRGB(230, 160, 70),
        world = {
            water = fromRGB(60, 90, 100),
            seabed = fromRGB(95, 75, 50),
            cliff = fromRGB(110, 85, 55),
            cap = fromRGB(215, 160, 70),
            fog = fromRGB(55, 80, 85),
            glow = fromRGB(255, 190, 90)
        }
    },
    {
        id = "neon_reef",
        name = "Neon Reef",
        folder = "Neon Reef",
        icon = "🌃",
        Color = fromRGB(255, 60, 200),
        world = {
            water = fromRGB(40, 20, 90),
            seabed = fromRGB(26, 22, 50),
            cliff = fromRGB(34, 28, 64),
            cap = fromRGB(255, 60, 200),
            fog = fromRGB(40, 16, 80),
            glow = fromRGB(60, 240, 255)
        }
    },
    {
        id = "primeval_sea",
        name = "Primeval Sea",
        folder = "Primeval Sea",
        icon = "🦕",
        Color = fromRGB(120, 200, 90),
        world = {
            water = fromRGB(40, 120, 100),
            seabed = fromRGB(110, 95, 60),
            cliff = fromRGB(120, 100, 70),
            cap = fromRGB(90, 170, 70),
            fog = fromRGB(40, 105, 80),
            glow = fromRGB(255, 200, 90)
        }
    },
    {
        id = "nightmare_sea",
        name = "Nightmare Sea",
        folder = "Nightmare Sea",
        icon = "👁️",
        Color = fromRGB(220, 40, 60),
        world = {
            water = fromRGB(60, 10, 20),
            seabed = fromRGB(24, 14, 18),
            cliff = fromRGB(32, 18, 22),
            cap = fromRGB(150, 20, 40),
            fog = fromRGB(50, 6, 14),
            glow = fromRGB(255, 50, 70)
        }
    },
    {
        id = "glitch_rift",
        name = "Glitch Rift",
        folder = "Glitch Rift",
        icon = "👾",
        Color = fromRGB(90, 255, 200),
        world = {
            water = fromRGB(10, 30, 40),
            seabed = fromRGB(14, 14, 18),
            cliff = fromRGB(20, 20, 26),
            cap = fromRGB(90, 255, 200),
            fog = fromRGB(8, 24, 30),
            glow = fromRGB(255, 60, 220)
        }
    },
    {
        id = "divine_throne",
        name = "Throne of the Gods",
        folder = "Throne of the Gods",
        icon = "👑",
        Color = fromRGB(255, 225, 120),
        world = {
            water = fromRGB(120, 190, 255),
            seabed = fromRGB(235, 230, 215),
            cliff = fromRGB(245, 240, 230),
            cap = fromRGB(255, 215, 110),
            fog = fromRGB(130, 190, 250),
            glow = fromRGB(255, 235, 150)
        }
    },
    {
        id = "candy_cove",
        name = "Candy Cove",
        folder = "Candy Cove",
        icon = "🍬",
        Color = fromRGB(255, 110, 170),
        world = {
            water = fromRGB(140, 230, 225),
            seabed = fromRGB(250, 225, 180),
            cliff = fromRGB(235, 200, 150),
            cap = fromRGB(255, 160, 200),
            fog = fromRGB(150, 225, 225),
            glow = fromRGB(255, 245, 170),
            layers = {
                fromRGB(255, 250, 245),
                fromRGB(235, 60, 80)
            }
        }
    }
}
local t2 = {}

for v1, v2 in ipairs(t1) do
    v2.index = v1
    v2.startDistance = (v1 - 1) * GameConfig.ZONE_LENGTH
    v2.endDistance = v1 * GameConfig.ZONE_LENGTH
    t2[v2.id] = v2
end

return {
    List = t1,
    ById = t2
}
