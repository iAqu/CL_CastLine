-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Testing = {
        IgnoreOwnedPasses = true
    },
    Products = {
        PumpkinMonster = {
            Id = 3720851921,
            Price = 499,
            Name = "Pumpkin Monster",
            Gift = true,
            Grant = {
                OfBest = 9,
                Animals = { "LivingPumpkin" }
            }
        },
        HalloweenEgg1 = {
            Id = 3720852227,
            Price = 80,
            Name = "Halloween Egg",
            Gift = true,
            Grant = {
                Eggs = {
                    Halloween = 1
                }
            }
        },
        HalloweenEgg3 = {
            Id = 3720852473,
            Price = 200,
            Name = "3 Halloween Eggs",
            Gift = true,
            Grant = {
                Eggs = {
                    Halloween = 3
                }
            }
        },
        GiantSquid = {
            Id = 3720852702,
            Price = 299,
            Name = "Giant Squid",
            Gift = true,
            Grant = {
                OfBest = 3,
                Animals = { "GiantSquid" }
            }
        },
        WoollyMammoth = {
            Id = 3720853314,
            Price = 199,
            Name = "Woolly Mammoth",
            Gift = true,
            Grant = {
                OfBest = 1.5,
                Animals = { "WoollyMammoth" }
            }
        },
        MagmaEgg1 = {
            Id = 3715669287,
            Price = 60,
            Name = "Magma Egg",
            Retired = true,
            Grant = {
                Eggs = {
                    Magma = 1
                }
            }
        },
        MagmaEgg3 = {
            Id = 3715669379,
            Price = 150,
            Name = "3 Magma Eggs",
            Retired = true,
            Grant = {
                Eggs = {
                    Magma = 3
                }
            }
        },
        RainbowEgg1 = {
            Id = 3715669443,
            Price = 99,
            Name = "Rainbow Egg",
            Gift = true,
            Grant = {
                Eggs = {
                    Rainbow = 1
                }
            }
        },
        RainbowEgg3 = {
            Id = 3715669538,
            Price = 249,
            Name = "3 Rainbow Eggs",
            Gift = true,
            Grant = {
                Eggs = {
                    Rainbow = 3
                }
            }
        },
        ServerLuck1 = {
            Id = 3715669657,
            Price = 25,
            Name = "Server Luck 2x",
            Grant = {
                Luck = true
            }
        },
        ServerLuck2 = {
            Id = 3715669675,
            Price = 50,
            Name = "Server Luck 4x",
            Grant = {
                Luck = true
            }
        },
        ServerLuck3 = {
            Id = 3715669726,
            Price = 100,
            Name = "Server Luck 8x",
            Grant = {
                Luck = true
            }
        },
        ServerLuck4 = {
            Id = 3715669746,
            Price = 200,
            Name = "Server Luck 16x",
            Grant = {
                Luck = true
            }
        },
        SuperThrow = {
            Id = 3718173532,
            Price = 9,
            Name = "Super Lucky Throw",
            Grant = {
                SuperThrow = 1
            }
        },
        LuckyPack1 = {
            Id = 3721171209,
            Price = 39,
            Name = "5 Lucky Throws",
            Icon = "rbxassetid://76876336442748",
            Gift = true,
            Grant = {
                SuperThrow = 5
            }
        },
        LuckyPack2 = {
            Id = 3721171227,
            Price = 69,
            Name = "10 Lucky Throws",
            Icon = "rbxassetid://136571569250604",
            Gift = true,
            Grant = {
                SuperThrow = 10
            }
        },
        LuckyPack3 = {
            Id = 3721171243,
            Price = 299,
            Name = "50 Lucky Throws",
            Icon = "rbxassetid://78620094963422",
            Gift = true,
            Grant = {
                SuperThrow = 50
            }
        },
        LuckyPack4 = {
            Id = 3721171266,
            Price = 499,
            Name = "100 Lucky Throws",
            Icon = "rbxassetid://118909789025605",
            Gift = true,
            Grant = {
                SuperThrow = 100
            }
        },
        MoneyPack1 = {
            Id = 3721117253,
            Price = 4,
            Name = "Money Pack 1",
            Icon = "rbxassetid://77291583631831",
            Gift = true,
            Grant = {
                MoneyMinutes = 3
            }
        },
        MoneyPack2 = {
            Id = 3721117373,
            Price = 39,
            Name = "Money Pack 2",
            Icon = "rbxassetid://91462310564962",
            Gift = true,
            Grant = {
                MoneyMinutes = 18
            }
        },
        MoneyPack3 = {
            Id = 3721117384,
            Price = 79,
            Name = "Money Pack 3",
            Icon = "rbxassetid://115918281979828",
            Gift = true,
            Grant = {
                MoneyMinutes = 90
            }
        },
        MoneyPack4 = {
            Id = 3721117404,
            Price = 199,
            Name = "Money Pack 4",
            Icon = "rbxassetid://135570068849350",
            Gift = true,
            Grant = {
                MoneyMinutes = 300
            }
        },
        PowerPack1 = {
            Id = 3721117418,
            Price = 2,
            Name = "Throw Power Pack 1",
            Icon = "rbxassetid://132850250270840",
            Gift = true,
            Grant = {
                Power = 5
            }
        },
        PowerPack2 = {
            Id = 3721117432,
            Price = 9,
            Name = "Throw Power Pack 2",
            Icon = "rbxassetid://126438798279234",
            Gift = true,
            Grant = {
                Power = 30
            }
        },
        PowerPack3 = {
            Id = 3721117452,
            Price = 39,
            Name = "Throw Power Pack 3",
            Icon = "rbxassetid://124489722456137",
            Gift = true,
            Grant = {
                Power = 150
            }
        },
        PowerPack4 = {
            Id = 3721117466,
            Price = 99,
            Name = "Throw Power Pack 4",
            Icon = "rbxassetid://99487328697272",
            Gift = true,
            Grant = {
                Power = 500
            }
        },
        UltraPack = {
            Id = 3715669779,
            Price = 640,
            Name = "Ultra Pack",
            Retired = true,
            Grant = {
                Money = 6E+19,
                Animals = { "WingedImp", "Cerberus" }
            }
        },
        Jellyfish = {
            Id = 3715669788,
            Price = 40,
            Name = "Jellyfish",
            Retired = true,
            Grant = {
                Animals = { "Jellyfish" }
            }
        },
        Fenrir = {
            Id = 3715669827,
            Price = 156,
            Name = "Fenrir",
            Retired = true,
            Grant = {
                Animals = { "Fenrir" }
            }
        },
        Velociraptor = {
            Id = 3715669844,
            Price = 4400,
            Name = "Velociraptor",
            Retired = true,
            Grant = {
                Animals = { "Velicoraptor" }
            }
        },
        Hydra = {
            Id = 3715669884,
            Price = 12000,
            Name = "Hydra",
            Retired = true,
            Grant = {
                Animals = { "Hydra" }
            }
        },
        GiftDoubleCash = {
            Id = 3715669894,
            Price = 60,
            Name = "x2 Cash",
            GiftOnly = true,
            Grant = {
                Pass = "DoubleCash"
            }
        },
        GiftDoubleXp = {
            Id = 3715669939,
            Price = 76,
            Name = "x2 Training Power",
            GiftOnly = true,
            Grant = {
                Pass = "DoubleXp"
            }
        }
    },
    Passes = {
        DoubleCash = {
            Id = 1998783910,
            Price = 60,
            Name = "x2 Cash",
            Attribute = "CashMultiplier",
            Multiplier = 2,
            GiftProduct = "GiftDoubleCash"
        },
        DoubleXp = {
            Id = 1998987840,
            Price = 76,
            Name = "x2 Training Power",
            Attribute = "XpMultiplier",
            Multiplier = 2,
            GiftProduct = "GiftDoubleXp"
        }
    },
    ServerLuck = {
        MaxMultiplier = 16,
        Duration = 900,
        ExtendDuration = 900,
        ExtendGrace = 120,
        Tiers = { "ServerLuck1", "ServerLuck2", "ServerLuck3", "ServerLuck4" }
    },
    SuperThrow = {
        Product = "SuperThrow",
        MinThrows = 15,
        Rolls = 30,
        Icon = "rbxassetid://78380080100902"
    },
    Packs = {
        LuckyBase = "SuperThrow",
        MinIncome = 1,
        Money = { "MoneyPack1", "MoneyPack2", "MoneyPack3", "MoneyPack4" },
        Power = { "PowerPack1", "PowerPack2", "PowerPack3", "PowerPack4" },
        Lucky = { "LuckyPack1", "LuckyPack2", "LuckyPack3", "LuckyPack4" }
    },
    PackOffers = {
        ShowTime = 20,
        QuietAtStart = 150,
        MinThrows = 6,
        GapAny = 240,
        GapSameKind = 480,
        Backoff = 1.5,
        GapMax = 1200,
        TargetRepeats = 2,
        CloseShare = 0.35,
        GoodMeter = 0.7,
        TrainSeconds = 75,
        StuckMinutes = 7,
        StuckThrows = 4,
        LongTraining = 120,
        WaitMinutes = 4,
        MinGapMinutes = 1.5
    },
    FreeAnimal = "Hyena",
    FreeAnimalTag = {
        AfterThrows = 4,
        Delay = 10
    },
    Gift = {
        FreeForDevelopers = true,
        RequestTimeout = 30,
        PaymentTimeout = 180,
        DeniesToBlock = 2,
        BlockDuration = 600,
        RequestCooldown = 2,
        Items = {
            {
                Product = "PumpkinMonster"
            },
            {
                Product = "HalloweenEgg1"
            },
            {
                Product = "HalloweenEgg3"
            },
            {
                Product = "GiantSquid"
            },
            {
                Product = "WoollyMammoth"
            },
            {
                Product = "RainbowEgg1"
            },
            {
                Product = "RainbowEgg3"
            },
            {
                Pass = "DoubleCash"
            },
            {
                Pass = "DoubleXp"
            },
            {
                Product = "MoneyPack1"
            },
            {
                Product = "MoneyPack2"
            },
            {
                Product = "MoneyPack3"
            },
            {
                Product = "MoneyPack4"
            },
            {
                Product = "PowerPack1"
            },
            {
                Product = "PowerPack2"
            },
            {
                Product = "PowerPack3"
            },
            {
                Product = "PowerPack4"
            },
            {
                Product = "LuckyPack1"
            },
            {
                Product = "LuckyPack2"
            },
            {
                Product = "LuckyPack3"
            },
            {
                Product = "LuckyPack4"
            }
        }
    },
    ProductById = {}
}

for v1, v2 in pairs(t1.Products) do
    v2.Key = v1
    t1.ProductById[v2.Id] = v2
end

for v3, v4 in pairs(t1.Passes) do
    v4.Key = v3
end

function t1.GetProduct(p1) -- line: 286
    -- upvalues: t1 (copy)
    return t1.Products[p1]
end

function t1.GetPass(p2) -- line: 290
    -- upvalues: t1 (copy)
    return t1.Passes[p2]
end

function t1.FormatOfBest(p3) -- line: 295
    return tostring((math.floor((p3 or 0) * 100 + 0.5))) .. "%"
end

function t1.EggPrice(p4) -- line: 301
    -- upvalues: t1 (copy)
    for _, v7 in pairs(t1.Products) do
        local Eggs = v7.Grant.Eggs

        if Eggs and Eggs[p4] == 1 and not v7.Grant.Money and not v7.Grant.Animals then
            return v7.Price
        end
    end

    return nil
end

function t1.PackKind(p5) -- line: 314
    -- upvalues: t1 (copy)
    local v8 = t1.Products[p5]

    if not v8 then
        return nil
    end

    if v8.Grant.MoneyMinutes then
        return "Money"
    end

    if v8.Grant.Power then
        return "Power"
    end

    return if v8.Grant.SuperThrow and table.find(t1.Packs.Lucky, p5) then "Lucky" else nil
end

function t1.PackAmount(p6) -- line: 324
    -- upvalues: t1 (copy)
    local v9 = t1.Products[p6]
    local Grant = v9 and v9.Grant or {}

    return Grant.MoneyMinutes or Grant.Power or Grant.SuperThrow or 0
end

function t1.PackMoney(p7, p8) -- line: 331
    -- upvalues: t1 (copy)
    local v10 = t1.Products[p7]
    local MoneyMinutes = v10 and v10.Grant.MoneyMinutes or 0

    return (math.floor(math.max(tonumber(p8) or 0, t1.Packs.MinIncome or 0) * MoneyMinutes * 60 + 0.5))
end

function t1.PackBonus(p9, p10) -- line: 344
    -- upvalues: t1 (copy)
    local v14 = p10
    local v15 = t1.PackKind(p9)

    if not v15 then
        return 0
    end

    v14 = p10 or function(p11) -- line: 347
        return p11.Price
    end

    local function perRobux(p12) -- line: 348
        -- upvalues: v14 (ref), t1 (copy)
        local v16 = t1.PackAmount(p12.Key)
        local v17 = v14

        return v16 / math.max(tonumber(v17(p12)) or p12.Price, 1)
    end

    local v19 = t1.Products[v15 == "Lucky" and t1.Packs.LuckyBase or t1.Packs[v15][1]]
    local v22 = t1.PackAmount(v19.Key) / math.max(tonumber(v14(v19)) or v19.Price, 1)

    if v22 <= 0 then
        return 0
    end

    local v23 = t1.Products[p9]
    local v26 = (t1.PackAmount(v23.Key) / math.max(tonumber(v14(v23)) or v23.Price, 1) / v22 - 1) * 100
    local v27 = if v26 >= 100 then 50 else 10

    return (math.max(0, math.floor(v26 / v27 + 1E-06) * v27))
end

function t1.GetGiftItem(p13) -- line: 360
    -- upvalues: t1 (copy)
    for _, v30 in ipairs(t1.Gift.Items) do
        if v30.Product == p13 then
            return v30, t1.Products[p13]
        end

        if v30.Pass == p13 then
            local v31 = t1.Passes[p13]

            return v30, v31 and t1.Products[v31.GiftProduct]
        end
    end

    return nil
end

return t1
