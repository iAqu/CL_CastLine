-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local IndexZones = require(script.Parent:WaitForChild("IndexZones"))
local t1 = {}

t1.CYCLE = 86400
t1.SLOTS = { "early", "mid", "late" }
t1.CRAFT_HAND = 3.05
t1.PLAIN_OK = {
    "Silver",
    "Gold",
    "Molten",
    "Radioactive",
    "Admin",
    "Shadow",
    "Ghost",
    "Voidstorm",
    "Meteorite",
    "PinkMoon",
    "Fossilized",
    "Electric",
    "Hallowed",
    "Rainbow"
}

function t1.Fill(p1, p2) -- line: 51
    -- upvalues: t1 (copy)
    local t2 = {}

    for v1, v2 in ipairs(p2) do
        local v3 = if v2.mutation == nil or v2.mutation == "None" then "" else v2.mutation
        local v4 = v2.species .. "|" .. v3

        t2[v4] = t2[v4] or {}
        table.insert(t2[v4], v1)
    end

    local fish = p1.fish
    local t3 = {}
    local t4 = {}
    local v6 = {}
    local n1 = -1

    local function fill(p3, p4) -- line: 62
        -- upvalues: t2 (copy), fish (copy), t3 (copy), t4 (copy), v6 (ref), n1 (ref), fill (copy), t1 (copy)
        local v7 = n1

        if v7 ~= #fish and not (p4 + (#fish - p3 + 1) <= n1) then
            if #fish < p3 then
                v6 = table.clone(t4)
                n1 = p4
            else
                local v8 = fish[p3]
                local t5 = {
                    v8.mutation or ""
                }
                local _ipairs = ipairs
                local orMutations = v8.orMutations
                local v9, v10

                if orMutations then
                    v9 = orMutations
                    v10 = true
                elseif v8.mutation ~= nil then
                    v10 = false
                else
                    local PLAIN_OK = t1.PLAIN_OK

                    if PLAIN_OK then
                        v9 = PLAIN_OK
                        v10 = true
                    else
                        v10 = false
                    end
                end

                if not v10 then
                    v9 = {}
                end

                for _, v11 in _ipairs(v9) do
                    t5[#t5 + 1] = v11
                end

                for _, v12 in ipairs(t5) do
                    local v13 = v8.species .. "|" .. v12
                    local v14 = t2[v13]
                    local v15 = t3[v13] or 0

                    if v14 and v15 < #v14 then
                        t3[v13] = v15 + 1
                        t4[p3] = v14[v15 + 1]
                        fill(p3 + 1, p4 + 1)
                        t3[v13] = v15
                        t4[p3] = nil
                    end
                end

                fill(p3 + 1, p4)
            end
        end
    end

    fill(1, 0)

    return v6, n1
end

function t1.Match(p5, p6) -- line: 88
    -- upvalues: t1 (copy)
    local v16, v17 = t1.Fill(p5, p6)

    if v17 ~= #p5.fish or not v16 then
        v16 = nil
    end

    return v16
end

local function n(p7, p8, p9, p10) -- line: 94
    local t6 = {}

    for i = 1, p7 do
        t6[i] = {
            species = p8,
            mutation = p9,
            orMutations = p10
        }
    end

    return t6
end

local function join(...) -- line: 99
    local t7 = {}

    for _, v18 in ipairs({ ... }) do
        for _, v19 in ipairs(v18) do
            t7[#t7 + 1] = v19
        end
    end

    return t7
end

local t8 = {
    id = "SirKnightfish",
    name = "Sir Knightfish Bait",
    catches = "ArmoredSwordfish",
    zone = 1,
    model = "Bait",
    fish = n(3, "Swordfish"),
    tint = Color3.fromRGB(150, 160, 185)
}
local t9 = {
    id = "Mosasaurus",
    name = "Mosasaurus Bait",
    catches = "BluePlesiosaur",
    model = "BaitJaw"
}
local Whale = n(3, "Whale")
local t10 = {}

t10[1] = {
    species = "MidnightWhale",
    mutation = nil,
    orMutations = nil
}
t9.fish = join(Whale, t10)
t9.tint = Color3.fromRGB(40, 90, 200)

local t11 = {
    id = "HumpbackWhale",
    name = "Humpback Whale Bait",
    catches = "MidnightWhale",
    model = "Bait",
    fish = n(4, "Whale"),
    tint = Color3.fromRGB(90, 105, 135)
}
local t12 = {
    id = "BattleMosasaurus",
    name = "Battle Mosasaurus Bait",
    catches = "SpikedPurple",
    zone = 1,
    model = "BaitFang",
    fish = n(3, "BluePlesiosaur"),
    tint = Color3.fromRGB(150, 60, 200)
}
local t13 = {
    id = "TheMaw",
    name = "The Maw Bait",
    catches = "TheMaw",
    model = "BaitJaw",
    fish = n(3, "JawAngler"),
    tint = Color3.fromRGB(60, 45, 70)
}
local t14 = {
    id = "Scar",
    name = "Scar Bait",
    catches = "RazorfinLeviathan",
    model = "BaitJaw"
}
local TheMaw = n(2, "TheMaw")
local t15 = {}

t15[1] = {
    species = "ArmoredSwordfish",
    mutation = nil,
    orMutations = nil
}
t14.fish = join(TheMaw, t15)
t14.tint = Color3.fromRGB(40, 30, 50)

local t16 = {
    id = "Gammadron",
    name = "Gammadron Bait",
    catches = "Gammadron",
    model = "Bait",
    fish = n(4, "NRGShark"),
    tint = Color3.fromRGB(100, 255, 50)
}
local t17 = {
    id = "PoisonedLeviathan",
    name = "Poisoned Leviathan Bait",
    catches = "GlowSerpent",
    model = "BaitFang",
    fish = n(4, "MutatedSailfish"),
    tint = Color3.fromRGB(150, 230, 40)
}
local t18 = {
    id = "AbyssalFang",
    name = "Abyssal Fang Bait",
    catches = "AbyssalFang",
    model = "BaitFang"
}
local MidnightLoosejaw = n(2, "MidnightLoosejaw")
local t19 = {}

t19[1] = {
    species = "MidnightLoosejaw",
    mutation = "Shadow",
    orMutations = nil
}

local t20 = {}

t20[1] = {
    species = "AbyssalLurefish",
    mutation = nil,
    orMutations = nil
}
t18.fish = join(MidnightLoosejaw, t19, t20)
t18.tint = Color3.fromRGB(70, 90, 160)

local t21 = {
    id = "DemonShark",
    name = "Demon Shark Bait",
    catches = "BonefinBarracuda",
    model = "BaitJaw"
}
local t22 = {}

t22[1] = {
    species = "GlowbonePiranha",
    mutation = nil,
    orMutations = nil
}

local t23 = {}

t23[1] = {
    species = "GlowbonePiranha",
    mutation = "Shadow",
    orMutations = nil
}
t21.fish = join(t22, t23, (n(2, "GhostfinAngelfish")))
t21.tint = Color3.fromRGB(150, 25, 35)

local t24 = {
    id = "LavaSawfather",
    name = "Sawfather Bait",
    catches = "Sawfather",
    model = "BaitJaw"
}
local Molten = n(3, "GoldenFangfish", "Molten")
local t25 = {}

t25[1] = {
    species = "GleamingGoldfish",
    mutation = nil,
    orMutations = nil
}
t24.fish = join(Molten, t25)
t24.tint = Color3.fromRGB(255, 120, 40)

local t26 = {
    id = "Sharktacle",
    name = "Sharktacle Bait",
    catches = "Sharktacle",
    model = "BaitFang"
}
local GemTitan = n(2, "GemTitan")
local t27 = {}

t27[1] = {
    species = "GemTitan",
    mutation = "Molten",
    orMutations = nil
}
t26.fish = join(GemTitan, t27)
t26.tint = Color3.fromRGB(200, 55, 35)

local t28 = {
    id = "VoidriftShark",
    name = "Voidrift Shark Bait",
    catches = "VoidglowLeviathan",
    model = "BaitJaw"
}
local Radioactive = n(3, "GlowfangAngler", "Radioactive")
local t29 = {}

t29[1] = {
    species = "VoidfangLeviathan",
    mutation = nil,
    orMutations = nil
}
t28.fish = join(Radioactive, t29)
t28.tint = Color3.fromRGB(120, 60, 200)

local t30 = {
    id = "Dreadfin",
    name = "Dreadfin Bait",
    catches = "ObsidianSerpent",
    model = "BaitFang"
}
local PurpleTitan = n(2, "PurpleTitan")
local t31 = {}

t31[1] = {
    species = "PurpleTitan",
    mutation = "Radioactive",
    orMutations = nil
}
t30.fish = join(PurpleTitan, t31)
t30.tint = Color3.fromRGB(45, 25, 70)

local t32 = {
    id = "Turtleroid",
    name = "Turtleroid Bait",
    catches = "Turtleroid",
    model = "Bait"
}
local t33 = {}

t33[1] = {
    species = "MoonrockPuffer",
    mutation = "Shadow",
    orMutations = nil
}
t32.fish = join(t33, (n(3, "MoonrockPuffer")))
t32.tint = Color3.fromRGB(125, 135, 155)

local t34 = {
    id = "EclipsedOrcawhale",
    name = "Eclipsed Orcawhale Bait",
    catches = "EclipsedOrcawhale",
    model = "BaitJaw"
}
local StarskyManta = n(3, "StarskyManta")
local t35 = {}

t35[1] = {
    species = "SaturnRay",
    mutation = "Shadow",
    orMutations = nil
}
t34.fish = join(StarskyManta, t35)
t34.tint = Color3.fromRGB(40, 45, 85)

local t36 = {
    id = "Starmaw",
    name = "Starmaw Bait",
    catches = "Starmaw",
    model = "BaitFang"
}
local ConstellationKoi = n(3, "ConstellationKoi")
local t37 = {}

t37[1] = {
    species = "CyberShark",
    mutation = "Shadow",
    orMutations = nil
}
t36.fish = join(ConstellationKoi, t37)
t36.tint = Color3.fromRGB(130, 80, 220)

local t38 = {
    id = "MoonlightLeviathan",
    name = "Moonlight Leviathan Bait",
    catches = "MoonlightLeviathan",
    model = "BaitLure"
}
local t39 = {}

t39[1] = {
    species = "EclipsedOrcawhale",
    mutation = nil,
    orMutations = nil
}

local t40 = {}

t40[1] = {
    species = "Turtleroid",
    mutation = nil,
    orMutations = nil
}
t38.fish = join(t39, t40)
t38.tint = Color3.fromRGB(190, 210, 255)

local t41 = {
    id = "StarlightLeviathan",
    name = "Starlight Leviathan Bait",
    catches = "StarlightLeviathan",
    model = "BaitFang"
}
local t42 = {}

t42[1] = {
    species = "EclipsedOrcawhale",
    mutation = nil,
    orMutations = nil
}

local t43 = {}

t43[1] = {
    species = "Starmaw",
    mutation = nil,
    orMutations = nil
}
t41.fish = join(t42, t43)
t41.tint = Color3.fromRGB(90, 150, 255)
t1.ALWAYS = {
    t8,
    t9,
    t11,
    t12,
    t13,
    t14,
    t16,
    t17,
    t18,
    t21,
    t24,
    t26,
    t28,
    t30,
    t32,
    t34,
    t36,
    t38,
    t41
}

local t44 = {
    id = "VikingSwordfish",
    name = "Swordviking Battleship Bait",
    catches = "VikingSwordfish",
    product = 3720965143,
    price = 199,
    buyZone = 2,
    slot = "early",
    model = "BaitViking",
    scale = 1.5,
    anyZone = true
}
local t45 = {}

t45[1] = {
    species = "Kraken",
    mutation = nil,
    orMutations = nil
}

local t46 = {}

t46[1] = {
    species = "ArmoredSwordfish",
    mutation = nil,
    orMutations = nil
}

local t47 = {}

t47[1] = {
    species = "MidnightWhale",
    mutation = nil,
    orMutations = nil
}

local t48 = {}

t48[1] = {
    species = "BluePlesiosaur",
    mutation = nil,
    orMutations = nil
}
t44.fish = join(t45, t46, t47, t48)
t44.summon = {
    beats = 6,
    every = 2,
    wait = 3,
    sink = 14,
    pulse = { "rbxassetid://133396060859544", 1.2 },
    roar = { "rbxassetid://137628815514180", 2 },
    music = {
        id = 122681644942798,
        at = 0,
        volume = 1.5
    },
    cannons = {
        gap = 0.22,
        every = { 5, 8 },
        shots = { 3, 5 },
        sound = { "rbxassetid://124604771046108", 1.6 },
        muzzles = {
            bone = "Spine_02",
            side = 0.09,
            up = 0.06,
            along = { -0.03, -0.09, -0.15, -0.21 }
        }
    },
    glow = Color3.fromRGB(255, 165, 70),
    theme = {
        cannon = true,
        shock = Color3.fromRGB(255, 170, 60),
        tint = Color3.fromRGB(255, 236, 215),
        bait = Color3.fromRGB(255, 160, 50),
        sparks = Color3.fromRGB(255, 215, 130),
        smoke = {
            Color3.fromRGB(150, 120, 100),
            Color3.fromRGB(60, 50, 45)
        }
    }
}

local t49 = {
    id = "CrownedMosasaur",
    name = "Poseidon's Mosasaur Bait",
    catches = "CrownedMosasaur",
    product = 3720965161,
    price = 199,
    buyZone = 3,
    slot = "early",
    model = "BaitCrowned",
    scale = 1.5,
    anyZone = true
}
local SpikedPurple = n(2, "SpikedPurple")
local t50 = {}

t50[1] = {
    species = "BluePlesiosaur",
    mutation = nil,
    orMutations = nil
}

local t51 = {}

t51[1] = {
    species = "SpottedSnapjaw",
    mutation = nil,
    orMutations = nil
}
t49.fish = join(SpikedPurple, t50, t51)
t49.summon = {
    beats = 7,
    every = 2,
    wait = 3,
    sink = 14,
    pulse = { "rbxassetid://9125484367", 1.2 },
    roar = { "rbxassetid://9113987603", 2 },
    music = {
        id = 1839703769,
        at = 0
    },
    cry = {
        chance = 0.45,
        most = 3,
        pitch = { 0.82, 0.98 },
        sound = { "rbxassetid://9113980319", 1.5 }
    },
    glow = Color3.fromRGB(70, 255, 150),
    theme = {
        tide = {
            current = Color3.fromRGB(40, 255, 150),
            gold = Color3.fromRGB(255, 205, 80)
        },
        shock = Color3.fromRGB(20, 200, 110),
        tint = Color3.fromRGB(190, 255, 215),
        bait = Color3.fromRGB(60, 255, 130),
        sparks = Color3.fromRGB(255, 220, 120),
        smoke = {
            Color3.fromRGB(30, 150, 105),
            Color3.fromRGB(4, 40, 34)
        }
    }
}

local t52 = {
    id = "Copshark",
    name = "Copshark Bait",
    catches = "Copshark",
    product = 3720965172,
    price = 299,
    buyZone = 5,
    slot = "mid",
    model = "BaitCopshark",
    scale = 1.5,
    anyZone = true
}
local t53 = {}

t53[1] = {
    species = "Nightcrawler",
    mutation = nil,
    orMutations = nil
}
t52.fish = join(t53, (n(2, "PhantomShark")))
t52.summon = {
    beats = 10,
    every = 1.25,
    wait = 3,
    sink = 14,
    pulse = { "rbxassetid://123668927084742", 1 },
    pulses = {
        { "rbxassetid://123668927084742", 1 },
        { "rbxassetid://138651783706047", 1 }
    },
    hammer = {
        dur = 1,
        rate = 13,
        pop = 0.12,
        kick = 0.35,
        rattle = 0.12,
        volume = 0.35
    },
    music = {
        id = 1848090337,
        at = 0,
        volume = 1.5
    },
    siren = {
        fadeIn = 3.5,
        sound = { "rbxassetid://9056622054", 0.55 },
        pods = { Vector3.new(-0.2625, 0.274, -0.2366), (Vector3.new(0.2625, 0.274, -0.2366)) }
    },
    glow = Color3.fromRGB(130, 160, 255),
    theme = {
        siren = {
            red = Color3.fromRGB(255, 30, 30),
            blue = Color3.fromRGB(30, 90, 255)
        },
        shock = Color3.fromRGB(255, 30, 30),
        tint = Color3.fromRGB(215, 222, 255),
        bait = Color3.fromRGB(235, 240, 255),
        sparks = Color3.fromRGB(235, 240, 255),
        smoke = {
            Color3.fromRGB(20, 30, 90),
            Color3.fromRGB(2, 4, 20)
        }
    }
}

local t54 = {
    id = "CrownedParasite",
    name = "Crowned Parasite Bait",
    catches = "CrownedParasite",
    product = 3720961581,
    price = 449,
    buyZone = 6,
    slot = "late",
    model = "BaitParasite",
    scale = 1.5,
    anyZone = true
}
local t55 = {}

t55[1] = {
    species = "VoidspikedBattleworm",
    mutation = nil,
    orMutations = nil
}

local t56 = {}

t56[1] = {
    species = "Voidlurker",
    mutation = nil,
    orMutations = nil
}

local t57 = {}

t57[1] = {
    species = "Voidbloom",
    mutation = nil,
    orMutations = nil
}

local t58 = {}

t58[1] = {
    species = "BubblegumCrab",
    mutation = nil,
    orMutations = nil
}
t54.fish = join(t55, t56, t57, t58)
t54.summon = {
    beats = 3,
    every = 7,
    wait = 3,
    wide = 28,
    sink = 14,
    pulse = { "rbxassetid://9038132226", 1 },
    roar = { "rbxassetid://97372816926607", 1.5 },
    music = {
        id = 97173389940773,
        at = 0
    },
    blink = {
        out = 0.12,
        into = 0.2,
        cooldown = 0.9,
        color = Color3.fromRGB(200, 130, 255)
    },
    glow = Color3.fromRGB(190, 110, 255),
    theme = {
        storm = {
            flash = Color3.fromRGB(195, 130, 255),
            bolt = Color3.fromRGB(200, 140, 255),
            sounds = { "rbxassetid://72403829271690", "rbxassetid://85687875166035", "rbxassetid://97372816926607" }
        },
        void = {
            star = Color3.fromRGB(215, 180, 255),
            core = Color3.fromRGB(255, 120, 220)
        },
        tide = {
            current = Color3.fromRGB(150, 70, 255),
            gold = Color3.fromRGB(255, 100, 215)
        },
        lightning = Color3.fromRGB(175, 80, 255),
        rave = Color3.fromRGB(190, 110, 255),
        shock = Color3.fromRGB(150, 60, 255),
        tint = Color3.fromRGB(205, 185, 250),
        bait = Color3.fromRGB(200, 110, 255),
        sparks = Color3.fromRGB(255, 200, 245)
    }
}

local t59 = {
    id = "HazmatHammerhead",
    name = "Hazmat Hammerhead Bait",
    catches = "HazmatHammerhead",
    product = 3720972342,
    price = 199,
    buyZone = 3,
    slot = "early",
    model = "BaitHazmat",
    scale = 1.5,
    anyZone = true
}
local GlowSerpent = n(2, "GlowSerpent")
local t60 = {}

t60[1] = {
    species = "RoyalHammersnout",
    mutation = nil,
    orMutations = nil
}

local t61 = {}

t61[1] = {
    species = "VenomfangCarapace",
    mutation = nil,
    orMutations = nil
}
t59.fish = join(GlowSerpent, t60, t61)
t59.summon = {
    beats = 6,
    every = 2,
    wait = 3,
    pop = 1.5,
    sink = 14,
    pulse = { "rbxassetid://95973258480483", 1.2 },
    roar = { "rbxassetid://81768325426833", 2 },
    music = {
        id = 88275367596456,
        at = 13,
        volume = 1.5
    },
    cry = {
        chance = 0.35,
        most = 4,
        pitch = { 0.85, 1.05 },
        sound = { "rbxassetid://81768325426833", 1.5 }
    },
    glow = Color3.fromRGB(140, 255, 60),
    theme = {
        lava = {
            core = Color3.fromRGB(225, 255, 150),
            hot = Color3.fromRGB(110, 255, 40),
            deep = Color3.fromRGB(20, 95, 10),
            smoke = Color3.fromRGB(80, 125, 55)
        },
        shock = Color3.fromRGB(80, 255, 40),
        tint = Color3.fromRGB(220, 255, 205),
        bait = Color3.fromRGB(120, 255, 40),
        sparks = Color3.fromRGB(215, 255, 120),
        smoke = {
            Color3.fromRGB(70, 160, 40),
            Color3.fromRGB(12, 45, 8)
        }
    }
}

local t62 = {
    id = "Gravedigger",
    name = "Gravedigger Bait",
    catches = "Gravedigger",
    product = 3720988813,
    price = 299,
    buyZone = 5,
    slot = "mid",
    model = "BaitGravedigger",
    scale = 1.5,
    anyZone = true
}
local t63 = {}

t63[1] = {
    species = "Nightcrawler",
    mutation = nil,
    orMutations = nil
}

local AbyssalFang = n(2, "AbyssalFang")
local t64 = {}

t64[1] = {
    species = "BonefinBarracuda",
    mutation = nil,
    orMutations = nil
}
t62.fish = join(t63, AbyssalFang, t64)
t62.summon = {
    beats = 7,
    every = 3.5,
    wait = 3,
    sink = 14,
    pulse = { "rbxassetid://135916945188311", 1 },
    music = {
        id = 9112863325,
        at = 0,
        volume = 1.5
    },
    hum = {
        fadeIn = 2,
        sound = { "rbxassetid://9112859961", 1.2 }
    },
    lantern = {
        pod = Vector3.new(0.389, 0.112, -0.432),
        color = Color3.fromRGB(255, 200, 110)
    },
    glow = Color3.fromRGB(255, 160, 60),
    theme = {
        shock = Color3.fromRGB(255, 170, 60),
        tint = Color3.fromRGB(255, 242, 222),
        bait = Color3.fromRGB(255, 190, 80),
        sparks = Color3.fromRGB(255, 220, 120),
        smoke = {
            Color3.fromRGB(170, 115, 60),
            Color3.fromRGB(70, 40, 20)
        }
    }
}

local t65 = {
    id = "WizardSquid",
    name = "Squizward Bait",
    catches = "WizardSquid",
    product = 3721011817,
    price = 449,
    buyZone = 6,
    slot = "late",
    model = "BaitWizard",
    scale = 1.5,
    anyZone = true
}
local t66 = {}

t66[1] = {
    species = "Voidspine",
    mutation = nil,
    orMutations = nil
}
t65.fish = join(t66, (n(2, "ObsidianSerpent")))
t65.summon = {
    beats = 6,
    every = 2.5,
    wait = 3,
    pop = 1.5,
    wide = 28,
    sink = 14,
    pulse = { "rbxassetid://75127344844404", 1 },
    roar = { "rbxassetid://126941244422484", 1.5 },
    music = {
        id = 1848104196,
        at = 0
    },
    spell = {
        charge = 0.45,
        flight = 0.28,
        pod = Vector3.new(0.07, 0.37, -0.46),
        rune = { 24, 8 },
        color = Color3.fromRGB(185, 85, 255),
        core = Color3.fromRGB(250, 230, 255),
        star = Color3.fromRGB(225, 190, 255),
        sounds = {
            cast = { "rbxassetid://130293516985070", 1.5 },
            stun = { "rbxassetid://9116384485", 1.6 }
        },
        daze = {
            blur = 10,
            into = 0.12,
            hold = 0.8,
            out = 1.6
        }
    },
    blink = {
        out = 0.12,
        into = 0.2,
        by = 1.2,
        color = Color3.fromRGB(200, 120, 255),
        poof = Color3.fromRGB(165, 80, 255)
    },
    glow = Color3.fromRGB(190, 110, 255),
    theme = {
        rune = {
            size = 46,
            color = Color3.fromRGB(200, 120, 255)
        },
        void = {
            star = Color3.fromRGB(225, 190, 255),
            core = Color3.fromRGB(255, 210, 120)
        },
        tide = {
            current = Color3.fromRGB(145, 70, 255),
            gold = Color3.fromRGB(255, 205, 110)
        },
        shock = Color3.fromRGB(150, 70, 255),
        tint = Color3.fromRGB(230, 220, 255),
        bait = Color3.fromRGB(195, 100, 255),
        sparks = Color3.fromRGB(255, 220, 140),
        smoke = {
            Color3.fromRGB(120, 60, 200),
            Color3.fromRGB(30, 10, 60)
        }
    }
}
t1.POOL = { t44, t49, t52, t54, t59, t62, t65 }

for _, v20 in ipairs(t1.POOL) do
    v20.timed = true
end

local t67 = {
    id = "SunwingManta",
    name = "Sunwing Manta Bait",
    catches = "GoldenCrescentBlade",
    model = "BaitFang",
    fish = join(n(2, "Stingray", "Gold"), (n(2, "GoldenKoi", "Gold"))),
    tint = Color3.fromRGB(240, 190, 40)
}
local t68 = {
    id = "CrownedAngler",
    name = "Crowned Angler Bait",
    catches = "CrownedAngler",
    model = "BaitLure",
    fish = n(4, "ZigzagFish")
}
local t69 = {
    id = "Sawfather",
    name = "Sawfather Bait",
    catches = "Sawfather",
    model = "Bait"
}
local FrilledFish = n(3, "FrilledFish")
local t70 = {}

t70[1] = {
    species = "BonejawSerpent",
    mutation = nil,
    orMutations = nil
}
t69.fish = join(FrilledFish, t70)
t1.RETIRED = {
    t67,
    t68,
    t69,
    {
        id = "Devildra",
        name = "Devildra Bait",
        catches = "CrimsonHydra",
        model = "BaitJaw",
        fish = n(4, "Sawfather"),
        tint = Color3.fromRGB(170, 20, 30)
    },
    {
        id = "Clownshark",
        name = "Clownshark Bait",
        catches = "ClownShark",
        model = "BaitFang",
        fish = n(3, "NRGShark"),
        tint = Color3.fromRGB(230, 70, 90)
    },
    {
        id = "LanternMaw",
        name = "Lantern Maw Bait",
        catches = "LanternAngler",
        model = "BaitLure",
        fish = n(3, "AbyssalLurefish", "Silver"),
        tint = Color3.fromRGB(205, 210, 220)
    },
    {
        id = "Phantomshark",
        name = "Phantomshark Bait",
        catches = "PhantomShark",
        model = "BaitFang",
        fish = n(3, "GlowbonePiranha", "Shadow"),
        tint = Color3.fromRGB(60, 20, 90)
    }
}

for _, v21 in ipairs(t1.RETIRED) do
    v21.retired = true
end

local t71 = {
    id = "Kraken",
    name = "Kraken Bait",
    catches = "Kraken",
    zone = 1,
    model = "BaitKraken",
    scale = 2,
    anyZone = true,
    product = 3717077321,
    price = 149,
    fish = n(3, "ArmoredSwordfish"),
    summon = {
        beats = 8,
        every = 2,
        wait = 3,
        sink = 14,
        pulse = { "rbxassetid://127335073160285", 1 },
        roar = { "rbxassetid://140038836025872", 2 },
        music = {
            id = 1839703769,
            at = 0
        },
        cry = {
            chance = 0.45,
            most = 3,
            pitch = { 0.82, 1.18 },
            sound = { "rbxassetid://130140111140874", 1.5 }
        },
        glow = Color3.fromRGB(150, 225, 255)
    }
}
local t72 = {
    id = "Crocodon",
    name = "Crocodon Bait",
    catches = "Crocodon",
    zone = 1,
    model = "BaitCrocodon",
    scale = 2,
    anyZone = true,
    product = 3717365525,
    price = 199,
    fish = n(3, "SpikedPurple"),
    summon = {
        beats = 8,
        every = 2,
        wait = 3,
        sink = 14,
        pulse = { "rbxassetid://1457700352", 1 },
        roar = { "rbxassetid://140038836025872", 2 },
        music = {
            id = 70615932668908,
            at = 0
        },
        cry = {
            chance = 0.45,
            most = 3,
            pitch = { 0.82, 1.18 },
            sound = { "rbxassetid://130140111140874", 1.5 }
        },
        glow = Color3.fromRGB(255, 70, 50),
        theme = {
            shock = Color3.fromRGB(255, 40, 30),
            tint = Color3.fromRGB(255, 190, 180),
            bait = Color3.fromRGB(255, 50, 35),
            sparks = Color3.fromRGB(255, 170, 140),
            lightning = Color3.fromRGB(255, 45, 30)
        }
    }
}
local t73 = {
    id = "Nightcrawler",
    name = "Nightcrawler Bait",
    catches = "Nightcrawler",
    zone = 4,
    model = "BaitNightcrawler",
    scale = 2,
    anyZone = true,
    product = 3717365584,
    price = 349
}
local t74 = {}

t74[1] = {
    species = "CrimsonDreadfish",
    mutation = nil,
    orMutations = nil
}

local t75 = {}

t75[1] = {
    species = "BonefinBarracuda",
    mutation = nil,
    orMutations = nil
}
t73.fish = join(t74, t75, (n(2, "AbyssalFang")))
t73.summon = {
    beats = 5,
    every = 3.5,
    wait = 3,
    after = 0.2,
    sink = 14,
    pulse = { "rbxassetid://98222932487230", 1.2 },
    scream = { "rbxassetid://9043345728", 2.5 },
    music = {
        id = 140704980462451,
        at = 0,
        volume = 1.5
    },
    visitRoar = {
        hold = 2.5,
        sound = { "rbxassetid://132560717714270", 3 }
    },
    jumpscare = {
        hold = 2,
        sound = { "rbxassetid://9043345728", 3 }
    },
    glow = Color3.fromRGB(255, 140, 40),
    theme = {
        night = true,
        shock = Color3.fromRGB(150, 45, 10),
        tint = Color3.fromRGB(255, 205, 175),
        bait = Color3.fromRGB(255, 130, 40),
        sparks = Color3.fromRGB(255, 160, 80),
        smoke = {
            Color3.fromRGB(55, 22, 8),
            Color3.fromRGB(6, 3, 2)
        }
    }
}

local t76 = {
    id = "PoisonedHexjaw",
    name = "Poisoned Hexjaw Bait",
    catches = "PoisonedHexjaw",
    zone = 3,
    product = 3718281158,
    price = 299,
    model = "BaitHexjaw",
    scale = 2,
    anyZone = true
}
local GlowSerpent2 = n(2, "GlowSerpent")
local t77 = {}

t77[1] = {
    species = "Gammadron",
    mutation = nil,
    orMutations = nil
}
t76.fish = join(GlowSerpent2, t77)
t76.summon = {
    beats = 8,
    every = 1.5,
    wait = 3,
    sink = 14,
    pulse = { "rbxassetid://139190048645306", 1.2 },
    roar = { "rbxassetid://125150648739091", 2 },
    music = {
        id = 88275367596456,
        at = 13,
        volume = 1.5
    },
    cry = {
        chance = 0.45,
        most = 3,
        pitch = { 0.85, 1.15 },
        sound = { "rbxassetid://80757394205708", 1.5 }
    },
    glow = Color3.fromRGB(140, 255, 60),
    theme = {
        rave = Color3.fromRGB(80, 255, 60),
        shock = Color3.fromRGB(60, 255, 40),
        tint = Color3.fromRGB(200, 255, 170),
        bait = Color3.fromRGB(120, 255, 40),
        sparks = Color3.fromRGB(190, 255, 120),
        lightning = Color3.fromRGB(80, 255, 60)
    }
}

local t78 = {
    id = "Megalodon",
    name = "Megalodon Bait",
    catches = "Megalodon",
    zone = 2,
    product = 3718281133,
    price = 249,
    model = "BaitMegalodon",
    scale = 1.2,
    anyZone = true,
    fish = n(3, "RazorfinLeviathan"),
    jaws = {
        upper = 0,
        lower = 0.42,
        wide = 0.25,
        antic = 0.3,
        snap = 0.07,
        hold = 0.1,
        reopen = 0.4
    },
    summon = {
        beats = 12,
        every = 1,
        wait = 3,
        sink = 14,
        pulse = { "rbxassetid://114303603199822", 1.2 },
        roar = { "rbxassetid://137145949028887", 2 },
        music = {
            id = 131430400979893,
            at = 19
        },
        cry = {
            chance = 0.2,
            most = 6,
            pitch = { 0.9, 1.1 },
            sounds = {
                { "rbxassetid://86547343520576", 1.5 },
                { "rbxassetid://130746080350885", 1.5 }
            }
        },
        glow = Color3.fromRGB(45, 110, 255),
        theme = {
            shark = true,
            shock = Color3.fromRGB(20, 55, 200),
            tint = Color3.fromRGB(165, 185, 255),
            bait = Color3.fromRGB(40, 105, 255),
            sparks = Color3.fromRGB(110, 170, 255),
            smoke = {
                Color3.fromRGB(25, 60, 200),
                Color3.fromRGB(3, 8, 40)
            },
            rim = Color3.fromRGB(40, 110, 255)
        }
    }
}
local t79 = {
    id = "EclipsedLeviathan",
    name = "Eclipsed Leviathan Bait",
    catches = "EclipsedLeviathan",
    zone = 7,
    product = 3720495423,
    price = 499,
    model = "BaitEclipsedLeviathan",
    scale = 2,
    anyZone = true
}
local t80 = {}

t80[1] = {
    species = "MoonlightLeviathan",
    mutation = nil,
    orMutations = nil
}

local t81 = {}

t81[1] = {
    species = "StarlightLeviathan",
    mutation = nil,
    orMutations = nil
}
t79.fish = join(t80, t81)
t79.summon = {
    beats = 5,
    every = 3,
    wait = 3,
    pop = 1.5,
    wide = 32,
    sink = 14,
    pulse = { "rbxassetid://9038127589", 1.2 },
    roar = { "rbxassetid://9118307005", 2 },
    music = {
        id = 132740081128452,
        at = 0,
        volume = 1.5
    },
    cry = {
        chance = 0.8,
        most = 2,
        noRepeat = true,
        pitch = { 0.9, 1.1 },
        sounds = {
            { "rbxassetid://9118308291", 1.5 },
            { "rbxassetid://9125826410", 1.5 },
            { "rbxassetid://9125823844", 1.5 }
        }
    },
    glow = Color3.fromRGB(190, 215, 255),
    theme = {
        shock = Color3.fromRGB(225, 235, 255),
        tint = Color3.fromRGB(165, 170, 230),
        bait = Color3.fromRGB(200, 220, 255),
        sparks = Color3.fromRGB(235, 242, 255),
        lightning = Color3.fromRGB(170, 200, 255),
        rave = Color3.fromRGB(235, 242, 255)
    }
}
t1.UNKNOWN = {
    t71,
    t72,
    t73,
    t76,
    t78,
    t79,
    {
        id = "Godsaw",
        name = "Sawgod Abomination Bait",
        catches = "Godsaw",
        zone = 5,
        product = 3720577880,
        price = 399,
        model = "BaitGodsaw",
        scale = 2,
        anyZone = true,
        fish = join(n(2, "Sawfather"), (n(2, "Sharktacle"))),
        summon = {
            beats = 5,
            every = 3,
            wait = 3,
            pop = 1.5,
            wide = 32,
            sink = 14,
            pulse = { "rbxassetid://9113435763", 1 },
            roar = { "rbxassetid://73208296937635", 2 },
            music = {
                id = 70615932668908,
                at = 0
            },
            cry = {
                chance = 0.8,
                most = 2,
                pitch = { 0.9, 1.1 },
                sounds = {
                    { "rbxassetid://73208296937635", 1.5 },
                    { "rbxassetid://73208296937635", 1.5 },
                    { "rbxassetid://110716346002611", 1.5 },
                    { "rbxassetid://119184309554795", 1.5 }
                }
            },
            glow = Color3.fromRGB(255, 120, 30),
            theme = {
                shock = Color3.fromRGB(255, 100, 20),
                tint = Color3.fromRGB(255, 232, 210),
                bait = Color3.fromRGB(255, 125, 30),
                sparks = Color3.fromRGB(255, 205, 110),
                lightning = Color3.fromRGB(255, 150, 40),
                rave = Color3.fromRGB(255, 140, 35),
                lava = {
                    core = Color3.fromRGB(255, 220, 130),
                    hot = Color3.fromRGB(255, 120, 30),
                    deep = Color3.fromRGB(150, 25, 5),
                    smoke = Color3.fromRGB(125, 85, 70)
                }
            }
        }
    },
    {
        id = "Voidspine",
        name = "Voidscreecher Bait",
        catches = "Voidspine",
        zone = 6,
        product = 3720801897,
        price = 449,
        model = "BaitVoidspine",
        scale = 2,
        anyZone = true,
        fish = join(n(2, "VoidglowLeviathan"), (n(2, "ObsidianSerpent"))),
        summon = {
            beats = 6,
            every = 3,
            wait = 3,
            pop = 1.5,
            after = 0.2,
            wide = 32,
            sink = 14,
            pulse = { "rbxassetid://1843025676", 1 },
            scream = { "rbxassetid://9043346124", 2.5 },
            music = {
                id = 140337873904870,
                at = 0
            },
            cry = {
                chance = 0.8,
                most = 2,
                noRepeat = true,
                pitch = { 0.9, 1.1 },
                sounds = {
                    { "rbxassetid://9043346124", 1.5 },
                    { "rbxassetid://9043345438", 1.5 },
                    { "rbxassetid://9043345011", 1.5 },
                    { "rbxassetid://9043345131", 1.5 }
                }
            },
            jumpscare = {
                hold = 2,
                sounds = {
                    { "rbxassetid://9043345011", 3 },
                    { "rbxassetid://9043345012", 3 }
                },
                daze = {
                    blur = 12,
                    into = 0.15,
                    hold = 0.9,
                    out = 1.8,
                    ring = { "rbxassetid://113959661495991", 0.6 }
                }
            },
            glow = Color3.fromRGB(190, 110, 255),
            theme = {
                shock = Color3.fromRGB(150, 60, 255),
                tint = Color3.fromRGB(235, 225, 255),
                bait = Color3.fromRGB(185, 90, 255),
                sparks = Color3.fromRGB(230, 200, 255),
                lightning = Color3.fromRGB(175, 80, 255),
                rave = Color3.fromRGB(190, 110, 255),
                void = {
                    star = Color3.fromRGB(215, 180, 255),
                    core = Color3.fromRGB(200, 140, 255)
                }
            }
        }
    }
}

for _, v22 in ipairs(t1.UNKNOWN) do
    v22.unknown = true
end

t1.TUTORIAL = {
    {
        id = "Deepstalker",
        name = "Crimson Deepstalker Bait",
        catches = "ColossalSquid",
        model = "BaitFang",
        anyZone = true,
        fish = n(3, "Octopus"),
        tint = Color3.fromRGB(170, 40, 55)
    }
}

for _, v23 in ipairs(t1.TUTORIAL) do
    v23.tutorial = true
end

function t1.Unusual(p11) -- line: 916
    -- upvalues: t1 (copy)
    local t82 = {}
    local v24

    for _, v25 in ipairs(t1.UNKNOWN) do
        if (not v25.starts or v25.starts <= p11) and (not v25.ends or p11 < v25.ends) then
            t82[#t82 + 1] = v25
        end

        for _, v27 in ipairs({
                v25.starts or (-1e999),
                v25.ends or (-1e999)
            }) do
            if p11 < v27 then
                v24 = math.min(v24 or 1e999, v27)
            end
        end
    end

    return t82, v24
end

function t1.EndsAt(p12, p13) -- line: 929
    -- upvalues: t1 (copy)
    if p12.unknown then
        return p12.ends
    end

    return if p12.timed then (math.floor(p13 / t1.CYCLE) + 1) * t1.CYCLE else nil
end

local function shuffled(p14, p15, p16) -- line: 942
    local t83 = {}

    for i = 1, p14 do
        t83[i] = i
    end

    local v30 = Random.new(p15 * 7919 + p16)

    for i = p14, 2, -1 do
        local v31 = v30:NextInteger(1, i)
        local v32 = t83[v31]
        local v33 = t83[i]

        t83[i] = v32
        t83[v31] = v33
    end

    return t83
end

local function tierOrder(p17, p18, p19) -- line: 952
    -- upvalues: shuffled (copy)
    if p17 < 3 then
        local t84 = {}

        for i = 1, p17 do
            t84[i] = i
        end

        return t84
    end

    local v34 = shuffled(p17, p18, p19)

    if v34[1] == shuffled(p17, p18 - 1, p19)[p17] then
        local v35 = v34[2]
        local v36 = v34[1]

        v34[1] = v35
        v34[2] = v36
    end

    return v34
end

function t1.Stock(p20) -- line: 964
    -- upvalues: t1 (copy), tierOrder (copy)
    local v38 = math.floor(p20 / t1.CYCLE)
    local t85 = {}

    for _, v39 in ipairs(t1.ALWAYS) do
        t85[#t85 + 1] = v39
    end

    for v40, v41 in ipairs(t1.SLOTS) do
        local t86 = {}

        for _, v42 in ipairs(t1.POOL) do
            if v42.slot == v41 then
                t86[#t86 + 1] = v42
            end
        end

        if #t86 > 0 then
            local v45 = tierOrder(#t86, math.floor(v38 / #t86), v40)

            t85[#t85 + 1] = t86[v45[v38 % #t86 + 1]]
        end
    end

    return t85, (v38 + 1) * t1.CYCLE, v38
end

function t1.ZoneOf(p21) -- line: 987
    -- upvalues: IndexZones (copy)
    return p21.zone or IndexZones[p21.catches]
end

local function permanentUnknown(p22) -- line: 996
    -- upvalues: t1 (copy)
    local v46, v47 = t1.Unusual(p22)
    local t87 = {}

    for _, v48 in ipairs(v46) do
        if not v48.ends then
            t87[#t87 + 1] = v48
        end
    end

    return t87, v47
end

function t1.StockIn(p23, p24) -- line: 1005
    -- upvalues: t1 (copy), permanentUnknown (copy)
    local t88 = {}

    for _, v49 in ipairs(t1.ALWAYS) do
        if t1.ZoneOf(v49) == p24 then
            t88[#t88 + 1] = v49
        end
    end

    local v50, v51 = permanentUnknown(p23)

    for _, v52 in ipairs(v50) do
        if t1.ZoneOf(v52) == p24 then
            t88[#t88 + 1] = v52
        end
    end

    return t88, v51
end

function t1.StockZones(p25) -- line: 1017
    -- upvalues: t1 (copy), permanentUnknown (copy)
    local t89 = {}

    for _, v53 in ipairs(t1.ALWAYS) do
        local v54 = t1.ZoneOf(v53)

        if v54 then
            t89[v54] = true
        end
    end

    for _, v55 in ipairs((permanentUnknown(p25))) do
        local v56 = t1.ZoneOf(v55)

        if v56 then
            t89[v56] = true
        end
    end

    local t90 = {}

    for v57 in pairs(t89) do
        t90[#t90 + 1] = v57
    end

    table.sort(t90)

    return t90
end

function t1.Limited(p26) -- line: 1034
    -- upvalues: t1 (copy)
    local v58, v59 = t1.Stock(p26)
    local t91 = {}

    for i = #t1.ALWAYS + 1, #v58 do
        t91[#t91 + 1] = v58[i]
    end

    local v60, v61 = t1.Unusual(p26)

    for _, v62 in ipairs(v60) do
        if v62.ends then
            t91[#t91 + 1] = v62
        end
    end

    return t91, (math.min(v59, v61 or 1e999))
end

return t1
