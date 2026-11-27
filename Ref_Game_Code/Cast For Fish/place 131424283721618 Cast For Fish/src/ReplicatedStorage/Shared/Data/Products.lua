-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Gamepasses = {
        {
            key = "DoubleCash",
            id = 2079818285,
            robux = 80,
            name = "x2 Cash",
            text = "Double cash\nfrom every\nfish!",
            boost = "CashBoost"
        },
        {
            key = "DoubleTraining",
            id = 2079260305,
            robux = 120,
            name = "x2 Training Power",
            text = "Double XP\non every\nrep!",
            boost = "TrainBoost"
        },
        {
            key = "SkipCutscene",
            id = 2079608303,
            robux = 149,
            name = "Skip Cutscenes",
            text = "Jump straight\nto your catch.\nFish faster!",
            badge = "SKIP",
            symbol = ">>"
        },
        {
            key = "DoubleLuck",
            id = 2087858422,
            robux = 199,
            name = "x2 Luck",
            text = "Double luck\non every\ncast!",
            boost = "PassLuck"
        },
        {
            key = "AutoCast",
            id = 2088050444,
            robux = 149,
            name = "Auto Cast",
            text = "Casts for\nyou on the\ndock!",
            badge = "AUTO"
        },
        {
            key = "VIP",
            id = 2088418573,
            robux = 249,
            name = "VIP",
            text = "x1.5 cash\n+ VIP tags\n+ Reef Rod!",
            boost = "VipCash",
            boostValue = 1.5,
            badge = "x1.5",
            symbol = "VIP",
            rod = "reef",
            featured = true,
            unlocked = "VIP unlocked! 1.5× cash, VIP tags + Reef Rod!"
        },
        {
            key = "OfflinePro",
            id = 2088760499,
            robux = 149,
            name = "Offline Pro",
            text = "x2 offline\ncash, up to\n24 hours!",
            badge = "x2",
            symbol = "Zz"
        }
    },
    CashPacks = {
        {
            key = "Cash1",
            id = 3730320163,
            robux = 20,
            minutes = 15,
            min = 3000,
            ribbon = "Good Value"
        },
        {
            key = "Cash2",
            id = 3730320177,
            robux = 48,
            minutes = 60,
            min = 18000,
            ribbon = "Better Value"
        },
        {
            key = "Cash3",
            id = 3730320184,
            robux = 64,
            minutes = 120,
            min = 36000,
            ribbon = "Great Value"
        },
        {
            key = "Cash4",
            id = 3730320190,
            robux = 160,
            minutes = 360,
            min = 110000,
            ribbon = "Most Value"
        }
    },
    PowerPacks = {
        {
            key = "Power1",
            id = 3730320195,
            robux = 22,
            power = 3,
            ribbon = "Good Value"
        },
        {
            key = "Power2",
            id = 3730320207,
            robux = 56,
            power = 10,
            ribbon = "Better Value"
        },
        {
            key = "Power3",
            id = 3730320217,
            robux = 240,
            power = 35,
            ribbon = "Great Value"
        },
        {
            key = "Power4",
            id = 3730320220,
            robux = 400,
            power = 60,
            ribbon = "Most Value"
        }
    },
    LuckyPacks = {
        {
            key = "Lucky1",
            id = 3730320224,
            robux = 22,
            casts = 3,
            ribbon = "Good Value"
        },
        {
            key = "Lucky2",
            id = 3730320227,
            robux = 56,
            casts = 10,
            ribbon = "Better Value"
        },
        {
            key = "Lucky3",
            id = 3730320241,
            robux = 240,
            casts = 35,
            ribbon = "Great Value"
        },
        {
            key = "Lucky4",
            id = 3730320245,
            robux = 400,
            casts = 60,
            ribbon = "Most Value"
        }
    },
    Crates = {
        {
            key = "SpiritLantern",
            name = "Spirit Lantern",
            tag = "NEW!",
            text = "Light it to summon a Spirit fish!",
            v = 1,
            s = 1,
            percent = true,
            floor = 25,
            pool = {
                {
                    fish = "daruma_puffer",
                    chance = 40,
                    pct = 125
                },
                {
                    fish = "shogun_koi",
                    chance = 26,
                    pct = 190
                },
                {
                    fish = "origami_ray",
                    chance = 18,
                    pct = 275
                },
                {
                    fish = "raijin_catfish",
                    chance = 10,
                    pct = 400
                },
                {
                    fish = "kitsune",
                    chance = 5,
                    pct = 650
                },
                {
                    fish = "floating_shrine",
                    chance = 1,
                    pct = 1500
                }
            },
            buy = {
                {
                    key = "Lantern1",
                    id = 3730320251,
                    robux = 64,
                    count = 1
                },
                {
                    key = "Lantern3",
                    id = 3730320258,
                    robux = 160,
                    count = 3
                },
                {
                    key = "Lantern10",
                    id = 3730320264,
                    robux = 520,
                    count = 10
                }
            }
        },
        {
            key = "RainbowCrate",
            name = "Rainbow Crate",
            tag = "LIMITED",
            text = "Earns like a Zone 4 to Zone 10 fish!",
            v = 4,
            s = 4,
            fixed = true,
            pool = {
                {
                    fish = "stingray",
                    chance = 45,
                    like = "thornpike"
                },
                {
                    fish = "parrotfish",
                    chance = 30,
                    like = "swamp_gar"
                },
                {
                    fish = "anglerfish",
                    chance = 17,
                    like = "glacier_pike"
                },
                {
                    fish = "goblin_shark",
                    chance = 7,
                    like = "obsidian_shark"
                },
                {
                    fish = "leviathan",
                    chance = 1,
                    like = "rustjaw"
                }
            },
            buy = {
                {
                    key = "RainbowCrate1",
                    id = 3730320269,
                    robux = 80,
                    count = 1
                },
                {
                    key = "RainbowCrate3",
                    id = 3730320273,
                    robux = 200,
                    count = 3
                }
            }
        },
        {
            key = "CosmicEgg",
            name = "Cosmic Egg",
            tag = "EVENT",
            text = "Laid by Khaos during the Cosmic Flood!",
            v = 1,
            s = 1,
            percent = true,
            floor = 25,
            event = true,
            pool = {
                {
                    fish = "stardust_guppy",
                    chance = 45,
                    pct = 50
                },
                {
                    fish = "astro_axolotl",
                    chance = 30,
                    pct = 70
                },
                {
                    fish = "saucer_flounder",
                    chance = 18,
                    pct = 90
                },
                {
                    fish = "galaxy_angler",
                    chance = 7,
                    pct = 115
                }
            },
            buy = {}
        },
        {
            key = "GoldenHarvest",
            name = "Golden Harvest",
            tag = "LIMITED",
            text = "Thanksgiving only! Hatch a Harvest fish!",
            v = 1,
            s = 1,
            percent = true,
            floor = 25,
            endsAt = 1795885200,
            pool = {
                {
                    fish = "turkey_trout",
                    chance = 40,
                    pct = 125
                },
                {
                    fish = "cranberry_koi",
                    chance = 26,
                    pct = 190
                },
                {
                    fish = "stuffing_snapper",
                    chance = 18,
                    pct = 275
                },
                {
                    fish = "pumpkin_pike",
                    chance = 10,
                    pct = 400
                },
                {
                    fish = "gravy_grouper",
                    chance = 5,
                    pct = 650
                },
                {
                    fish = "golden_gobbler",
                    chance = 1,
                    pct = 1500
                }
            },
            buy = {
                {
                    key = "Harvest1",
                    id = 3735039231,
                    robux = 64,
                    count = 1
                },
                {
                    key = "Harvest3",
                    id = 3735039372,
                    robux = 160,
                    count = 3
                },
                {
                    key = "Harvest10",
                    id = 3735039441,
                    robux = 520,
                    count = 10
                }
            }
        }
    },
    LadderFish = {
        key = "LadderFish",
        name = "Thanksgiving Pack",
        tag = "LIMITED",
        text = "Thanksgiving Pack exclusive!",
        v = 1,
        s = 1,
        percent = true,
        floor = 25,
        reward = true,
        pool = {
            {
                fish = "butterball_blowfish",
                chance = 0,
                pct = 150
            },
            {
                fish = "pumpkin_pufferfish",
                chance = 0,
                pct = 300
            },
            {
                fish = "cran_bass",
                chance = 0,
                pct = 500
            },
            {
                fish = "golden_gobbler_marlin",
                chance = 0,
                pct = 1000
            }
        },
        buy = {}
    }
}

function t1.CrateByKey(p1) -- line: 119
    -- upvalues: t1 (copy)
    for _, v1 in ipairs(t1.Crates) do
        if v1.key == p1 then
            return v1
        end
    end

    return if p1 == t1.LadderFish.key then t1.LadderFish else nil
end

function t1.SecondsLeft(p2, p3) -- line: 131
    return if type(p2) == "table" and type(p2.endsAt) == "number" then math.max(0, p2.endsAt - p3) else nil
end

function t1.OnSale(p4, p5) -- line: 138
    -- upvalues: t1 (copy)
    local v5 = t1.SecondsLeft(p4, p5)

    if v5 == nil then
        return true
    end

    return v5 > 0
end

t1.OfflineDouble = {
    key = "OfflineDouble",
    id = 3730320283,
    robux = 40
}
t1.StarterPack = {
    key = "StarterPack",
    id = 3730335666,
    robux = 99,
    power = 500,
    cash = 1E+07,
    bait = "glow_grub"
}
t1.ProPack = {
    key = "ProPack",
    id = 3731958765,
    robux = 1299,
    fish = "kitsune",
    v = 1,
    s = 7,
    power = 5000,
    minutes = 720,
    min = 1E+07,
    bait = "golden_lure"
}
t1.RandomFish = {
    key = "RandomFish",
    id = 3733940560,
    robux = 49
}
t1.DonationsAll = {
    {
        key = "Donate10",
        id = 3730561571,
        robux = 10
    },
    {
        key = "Donate50",
        id = 3730561588,
        robux = 50
    },
    {
        key = "Donate100",
        id = 3730561593,
        robux = 100
    },
    {
        key = "Donate250",
        id = 3730561599,
        robux = 250
    },
    {
        key = "Donate500",
        id = 3730561604,
        robux = 500
    },
    {
        key = "Donate1000",
        id = 3730561609,
        robux = 1000
    },
    {
        key = "Donate5000",
        id = 3730561616,
        robux = 5000
    },
    {
        key = "Donate10000",
        id = 3730561623,
        robux = 10000
    }
}
t1.Donations = {
    t1.DonationsAll[2],
    t1.DonationsAll[4],
    t1.DonationsAll[6]
}
t1.Potions = {
    {
        key = "PotionLuck",
        id = 3731991978,
        robux = 39,
        buff = "luck",
        seconds = 900
    },
    {
        key = "PotionCash",
        id = 3731992088,
        robux = 24,
        buff = "cash",
        seconds = 900
    },
    {
        key = "PotionStrength",
        id = 3731992276,
        robux = 24,
        buff = "strength",
        seconds = 900
    },
    {
        key = "PotionCosmic",
        id = 3731992361,
        robux = 79,
        buff = "cosmic",
        seconds = 900
    }
}
t1.ServerLuck = {
    minutes = 15,
    tiers = {
        {
            key = "ServerLuck2",
            id = 3730589555,
            robux = 49,
            mult = 2
        },
        {
            key = "ServerLuck4",
            id = 3730589577,
            robux = 99,
            mult = 4
        },
        {
            key = "ServerLuck8",
            id = 3730589584,
            robux = 199,
            mult = 8
        },
        {
            key = "ServerLuck16",
            id = 3730589591,
            robux = 399,
            mult = 16
        },
        {
            key = "ServerLuck32",
            id = 3730589598,
            robux = 799,
            mult = 32
        }
    }
}
t1.GiftPasses = {
    {
        key = "GiftDoubleCash",
        pass = "DoubleCash",
        id = 3730589965,
        robux = 80
    },
    {
        key = "GiftDoubleTraining",
        pass = "DoubleTraining",
        id = 3730589968,
        robux = 120
    },
    {
        key = "GiftSkipCutscene",
        pass = "SkipCutscene",
        id = 3730589975,
        robux = 149
    },
    {
        key = "GiftDoubleLuck",
        pass = "DoubleLuck",
        id = 3730845917,
        robux = 199
    },
    {
        key = "GiftAutoCast",
        pass = "AutoCast",
        id = 3730845922,
        robux = 149
    },
    {
        key = "GiftVIP",
        pass = "VIP",
        id = 3735316469,
        robux = 249
    }
}
t1.Giftable = {
    cash = true,
    power = true,
    lucky = true,
    crate = true,
    giftPass = true
}
t1.FreeFish = {
    fish = "pufferfish",
    v = 2,
    s = 2
}

function t1.FindProduct(p6) -- line: 209
    -- upvalues: t1 (copy)
    if p6 == 0 then
        return nil
    end

    for _, v6 in ipairs(t1.CashPacks) do
        if v6.id == p6 then
            return "cash", v6
        end
    end

    for _, v7 in ipairs(t1.PowerPacks) do
        if v7.id == p6 then
            return "power", v7
        end
    end

    for _, v8 in ipairs(t1.LuckyPacks) do
        if v8.id == p6 then
            return "lucky", v8
        end
    end

    for _, v9 in ipairs(t1.Crates) do
        for _, v10 in ipairs(v9.buy) do
            if v10.id == p6 then
                return "crate", v9, v10
            end
        end
    end

    if t1.OfflineDouble.id == p6 then
        return "offlineDouble", t1.OfflineDouble
    end

    if t1.StarterPack.id == p6 then
        return "starter", t1.StarterPack
    end

    if t1.ProPack.id == p6 then
        return "pro", t1.ProPack
    end

    if t1.RandomFish.id == p6 then
        return "randomFish", t1.RandomFish
    end

    for _, v11 in ipairs(t1.DonationsAll) do
        if v11.id == p6 then
            return "donation", v11
        end
    end

    for _, v12 in ipairs(t1.Potions) do
        if v12.id == p6 then
            return "potion", v12
        end
    end

    for _, v13 in ipairs(t1.ServerLuck.tiers) do
        if v13.id == p6 then
            return "serverLuck", v13
        end
    end

    for _, v14 in ipairs(t1.GiftPasses) do
        if v14.id == p6 then
            return "giftPass", v14
        end
    end

    local v15, v16 = require(script.Parent.TierLadder).FindProduct(p6)

    if v15 then
        return "ladder", v16, v15
    end

    return nil
end

function t1.PercentIncome(p7, p8, p9) -- line: 275
    local v18 = math.max(p9, p7.floor or 1) * p8.pct / 100

    if not (v18 < 1E+15) then
        return v18
    end

    return (math.floor(v18 + 0.5))
end

function t1.PercentBase(p10, p11, p12, p13) -- line: 282
    local Variants = require(script.Parent.Variants)
    local Sizes = require(script.Parent.Sizes)
    local v20 = type(p13) == "table" and p13.exact == true
    local v21 = Variants.List[if v20 then p13.v else p10.v or 1] or Variants.List[1]
    local v22 = Sizes.List[if v20 then p13.s else p10.s or 1] or Sizes.List[1]

    return math.max(p12, p10.floor or 1) * p11.pct / 100 / ((v21.mult or 1) * (v22.mult or 1))
end

function t1.FixedIncome(_, p15) -- line: 292
    local Fish = require(script.Parent.Fish)
    local v24 = p15.like and Fish.ById[p15.like]

    if v24 then
        return v24.income
    end

    return 0
end

function t1.FixedBase(p16, p17) -- line: 299
    -- upvalues: t1 (copy)
    local Variants = require(script.Parent.Variants)
    local Sizes = require(script.Parent.Sizes)
    local v25 = Variants.List[p16.v or 1] or Variants.List[1]
    local v26 = Sizes.List[p16.s or 1] or Sizes.List[1]

    return t1.FixedIncome(p16, p17) / ((v25.mult or 1) * (v26.mult or 1))
end

function t1.LikeZone(p18) -- line: 308
    local Fish = require(script.Parent.Fish)
    local Zones = require(script.Parent.Zones)
    local v27 = p18.like and Fish.ById[p18.like]

    if v27 then
        for v28, v29 in ipairs(Zones.List) do
            if v29.id == v27.zone then
                return v28, v29.name
            end
        end
    end

    return nil, nil
end

function t1.CrateBase(p19, p20, p21) -- line: 325
    -- upvalues: t1 (copy)
    if p19.percent then
        return t1.PercentBase(p19, p20, p21 or 0)
    end

    if p19.fixed then
        return t1.FixedBase(p19, p20)
    end

    return nil
end

function t1.CrateIncome(p22, p23, p24) -- line: 333
    -- upvalues: t1 (copy)
    if p22.percent then
        return t1.PercentIncome(p22, p23, p24 or 0)
    end

    if p22.fixed then
        return t1.FixedIncome(p22, p23)
    end

    return nil
end

local t2, t3

local function crateIndex() -- line: 347
    -- upvalues: t1 (copy), t2 (ref), t3 (ref)
    if t2 then
        return t2, t3
    end

    local t4 = {}

    t2 = {}
    t3 = t4

    local _ipairs = ipairs
    local LadderFish, Crates = t1.LadderFish, t1.Crates

    for _, v30 in _ipairs({
            LadderFish,
            table.unpack(Crates)
        }) do
        for _, v31 in ipairs(v30.pool) do
            if v30.percent then
                local t5 = t2

                t5[v31.fish] = { v30, v31 }
            else
                local t6 = t3

                t6[v31.fish] = { v30, v31 }
            end
        end
    end

    return t2, t3
end

function t1.CrateOf(p25) -- line: 363
    -- upvalues: crateIndex (copy)
    local v32 = type(p25) == "table"
    local v33 = if v32 then type(p25.id) == "string" else nil

    if v32 and v33 then
        local v34, v35 = crateIndex()
        local v36 = v34[p25.id]

        if v36 then
            return v36[1], v36[2]
        end

        local v37 = v35[p25.id]

        if v37 and (p25.b ~= nil or p25.v == v37[1].v and p25.s == v37[1].s) then
            return v37[1], v37[2]
        end
    end

    return nil, nil
end

function t1.SpiritBest(p26) -- line: 381
    -- upvalues: t1 (copy), crateIndex (copy)
    local Roll = require(script.Parent.Parent.Roll)
    local v38 = crateIndex()
    local n1 = 1

    for _, v39 in ipairs(t1.Crates) do
        if v39.percent then
            n1 = v39.floor or 1
            break
        end
    end

    for _, v40 in ipairs(p26) do
        for _, v42 in ipairs(v40) do
            if type(v42) == "table" and not v38[v42.id] then
                local v43 = Roll.incomeOf(v42)

                if n1 < v43 and v43 == v43 and v43 < 1e999 then
                    n1 = v43
                end
            end
        end
    end

    return n1
end

function t1.IsCrateFish(p27) -- line: 405
    -- upvalues: t1 (copy)
    if type(p27) ~= "table" then
        return false
    end

    if p27.b == nil then
        return t1.CrateOf(p27) ~= nil
    end

    return true
end

function t1.IsPercentFish(p28) -- line: 412
    -- upvalues: crateIndex (copy)
    if type(p28) == "table" and type(p28.id) == "string" then
        return crateIndex()[p28.id] ~= nil
    end

    return false
end

function t1.SpiritEntry(p29) -- line: 421
    -- upvalues: crateIndex (copy)
    local v45 = crateIndex()[p29]

    if v45 then
        return v45[1], v45[2]
    end

    return nil, nil
end

function t1.CashFor(p30, p31) -- line: 430
    return (math.max(p30.min, (math.floor(p31 * p30.minutes * 60))))
end

return t1
