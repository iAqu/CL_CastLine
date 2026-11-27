-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Passes = {
        CashX2 = {
            Id = 2064279287,
            Price = 149,
            WasPrice = 199
        },
        StrengthX2 = {
            Id = 2064259376,
            Price = 99,
            WasPrice = 149
        },
        VIP = {
            Id = 2064218058,
            Price = 149,
            WasPrice = 349
        },
        LuckX2 = {
            Id = 2074762533,
            Price = 179,
            WasPrice = 249
        },
        AutoClicker = {
            Id = 2074360578,
            Price = 149,
            WasPrice = 299
        },
        AutoTrain = {
            Id = 2074942507,
            Price = 149,
            WasPrice = 199
        }
    },
    Items = {
        MegaAnimal = {
            Id = 3726120498,
            Price = 499
        },
        Kraken = {
            Id = 3729897479,
            Price = 349
        },
        Mermaid = {
            Id = 3732895405,
            Price = 249
        },
        Exclusive1 = {
            Id = 3726120914,
            Price = 149
        },
        Exclusive2 = {
            Id = 3726120936,
            Price = 229
        },
        Exclusive3 = {
            Id = 3726120971,
            Price = 299
        },
        ExclusivePack = {
            Id = 3732895437,
            Price = 249
        },
        StarterPack = {
            Id = 3726120990,
            Price = 39
        },
        MediumPack = {
            Id = 3726121026,
            Price = 129
        },
        ProPack = {
            Id = 3726121054,
            Price = 249
        },
        ServerLuck2 = {
            Id = 3726121091,
            Price = 19
        },
        ServerLuck3 = {
            Id = 3726121138,
            Price = 29
        },
        ServerLuck4 = {
            Id = 3726121171,
            Price = 59
        },
        ServerLuck5 = {
            Id = 3726121207,
            Price = 99
        },
        ServerLuck6 = {
            Id = 3726121254,
            Price = 139
        },
        ServerLuck7 = {
            Id = 3726121299,
            Price = 199
        },
        StrengthBoost2 = {
            Id = 3730688714,
            Price = 5
        },
        StrengthBoost3 = {
            Id = 3730688848,
            Price = 15
        },
        StrengthBoost4 = {
            Id = 3730688852,
            Price = 29
        },
        StrengthBoost5 = {
            Id = 3730688859,
            Price = 49
        },
        StrengthBoost6 = {
            Id = 3730688864,
            Price = 79
        },
        StrengthBoost7 = {
            Id = 3730688873,
            Price = 119
        },
        PotionCash = {
            Id = 3726121342,
            Price = 19
        },
        PotionStrength = {
            Id = 3726121392,
            Price = 19
        },
        Cash1 = {
            Id = 3726121439,
            Price = 29
        },
        Cash2 = {
            Id = 3726121488,
            Price = 59
        },
        Cash3 = {
            Id = 3726121526,
            Price = 99
        },
        Cash4 = {
            Id = 3726121568,
            Price = 179
        },
        Cash5 = {
            Id = 3726121606,
            Price = 449
        },
        Strength1 = {
            Id = 3726121647,
            Price = 29
        },
        Strength2 = {
            Id = 3726121691,
            Price = 59
        },
        Strength3 = {
            Id = 3726121725,
            Price = 149
        },
        NextRod = {
            Id = 3726121767,
            Price = 49
        },
        NextBarbell = {
            Id = 3726121805,
            Price = 29
        },
        NextPen = {
            Id = 3726121849,
            Price = 19
        },
        Revive = {
            Id = 3726121882,
            Price = 9
        },
        RebirthSkip = {
            Id = 3726121916,
            Price = 49
        },
        OfflineX2 = {
            Id = 3729897480,
            Price = 29
        },
        BaitDiamond = {
            Id = 3731591126,
            Price = 49
        },
        BaitRainbow = {
            Id = 3731591131,
            Price = 99
        },
        GiftVIP = {
            Id = 3732895439,
            Price = 149
        },
        GiftCashX2 = {
            Id = 3732895440,
            Price = 149
        },
        GiftStrengthX2 = {
            Id = 3732895445,
            Price = 99
        }
    },
    Gifts = {
        VIP = "GiftVIP",
        CashX2 = "GiftCashX2",
        StrengthX2 = "GiftStrengthX2"
    },
    VipBonus = 1.2,
    VipDailyEvery = 86400,
    VipDailyMinutes = 30,
    VipDailyMin = 25000,
    FreeGift = {
        Every = 14400,
        FirstAfter = 1800,
        CashMinutes = 5,
        CashMin = 100
    },
    PotionMult = 2,
    PotionTime = 900,
    Potions = {
        {
            Key = "PotionCash",
            Stat = "Cash",
            Name = "2x Cash",
            Icon = "💰",
            Image = "rbxassetid://102475454447507"
        },
        {
            Key = "PotionStrength",
            Stat = "Strength",
            Name = "2x Strength",
            Icon = "💪",
            Image = "rbxassetid://85932648081137"
        }
    }
}

t1.PackPotions = {
    t1.Potions[1],
    t1.Potions[2],
    {
        Stat = "Luck",
        Name = "2x Luck",
        Icon = "🍀",
        Image = "rbxassetid://107143611085209"
    }
}
t1.ServerLuckTime = 900
t1.ServerLuck = {}
t1.ServerLuckMax = 7

for i = 2, t1.ServerLuckMax do
    t1.ServerLuck[i] = "ServerLuck" .. i
end

t1.StrengthBoostTime = 900
t1.StrengthBoost = {}
t1.StrengthBoostMax = 7

for i = 2, t1.StrengthBoostMax do
    t1.StrengthBoost[i] = "StrengthBoost" .. i
end

t1.AutoTrainRate = 1
t1.AutoClickerRate = 12
t1.Limited = {
    Kraken = 100,
    Mermaid = 150,
    ExclusivePack = 250,
    Exclusive1 = 250,
    Exclusive2 = 250,
    Exclusive3 = 250
}
t1.Kraken = {
    Key = "Kraken",
    Id = "Kraken"
}
t1.Mermaid = {
    Key = "Mermaid",
    Id = "Mermaid"
}
t1.Exclusives = {
    {
        Key = "Exclusive1",
        Id = "TreasureTurtle",
        Tag = "CHEAP!"
    },
    {
        Key = "Exclusive2",
        Id = "CrystalLeviathan",
        Tag = "BEST DEAL!"
    },
    {
        Key = "Exclusive3",
        Id = "AbyssDragon",
        Tag = "LEGENDARY!"
    }
}
t1.ExclusivePack = {
    Key = "ExclusivePack",
    Name = "Exclusive Animal Pack",
    Worth = 677,
    Animals = { "TreasureTurtle", "CrystalLeviathan", "AbyssDragon" }
}
t1.CashPacks = {
    {
        Key = "Cash1",
        Name = "Pocket Change",
        Minutes = 10,
        Min = 15000,
        Image = "rbxassetid://85281907056626"
    },
    {
        Key = "Cash2",
        Name = "Treasure Pouch",
        Minutes = 30,
        Min = 60000,
        Image = "rbxassetid://81000804140671"
    },
    {
        Key = "Cash3",
        Name = "Treasure Chest",
        Minutes = 120,
        Min = 250000,
        Image = "rbxassetid://79855883403552"
    },
    {
        Key = "Cash4",
        Name = "Sunken Vault",
        Minutes = 480,
        Min = 2E+06,
        Image = "rbxassetid://129747157026367"
    },
    {
        Key = "Cash5",
        Name = "Pirate's Hoard",
        Minutes = 1440,
        Min = 1E+07,
        Image = "rbxassetid://100120120163176"
    }
}
t1.StrengthPacks = {
    {
        Key = "Strength1",
        Name = "Protein Snack",
        Minutes = 10,
        Min = 500,
        Image = "rbxassetid://79632371202724"
    },
    {
        Key = "Strength2",
        Name = "Protein Shake",
        Minutes = 30,
        Min = 3000,
        Image = "rbxassetid://130714345115846"
    },
    {
        Key = "Strength3",
        Name = "Protein Feast",
        Minutes = 90,
        Min = 20000,
        Image = "rbxassetid://132098567964150"
    }
}
t1.Packs = {
    {
        Key = "StarterPack",
        Name = "Starter Pack",
        CashMinutes = 60,
        CashMin = 1E+05,
        StrengthMinutes = 15,
        StrengthMin = 1000,
        Animal = "StarSeahorse",
        Potions = {
            Cash = 900,
            Luck = 900
        }
    },
    {
        Key = "MediumPack",
        Name = "Medium Pack",
        CashMinutes = 60,
        CashMin = 250000,
        StrengthMinutes = 30,
        StrengthMin = 3000,
        Animal = "GalaxyOrca",
        Potions = {
            Cash = 1800,
            Strength = 1800
        }
    },
    {
        Key = "ProPack",
        Name = "Pro Pack",
        CashMinutes = 240,
        CashMin = 1E+06,
        StrengthMinutes = 90,
        StrengthMin = 20000,
        Animal = "CosmicShark",
        Exclusive = "Exclusive1",
        Potions = {
            Cash = 3600,
            Strength = 3600
        }
    }
}

function t1.scaled(p1, p2, p3) -- line: 213
    return (math.max(p3, (math.floor(p1 * p2 * 60))))
end

function t1.packCash(p4, p5) -- line: 218
    -- upvalues: t1 (copy)
    return p4.Cash or t1.scaled(p5, p4.CashMinutes, p4.CashMin)
end

function t1.packStrength(p6, p7) -- line: 222
    -- upvalues: t1 (copy)
    return p6.Strength or t1.scaled(p7, p6.StrengthMinutes, p6.StrengthMin)
end

t1.BarbellSkipMinutes = 30

function t1.canSkipBarbell(p8, p9) -- line: 230
    -- upvalues: t1 (copy)
    return p8 <= p9 * t1.BarbellSkipMinutes * 60
end

t1.RebirthSkipShare = 0.75

function t1.canSkipRebirth(p10, p11) -- line: 238
    -- upvalues: t1 (copy)
    return p11 * t1.RebirthSkipShare <= p10
end

function t1.serverLuckOffer(p12) -- line: 243
    -- upvalues: t1 (copy)
    local v4 = math.clamp(p12 + 1, 2, t1.ServerLuckMax)

    return t1.ServerLuck[v4], v4
end

function t1.strengthBoostOffer(p13) -- line: 248
    -- upvalues: t1 (copy)
    local v6 = math.clamp(p13 + 1, 2, t1.StrengthBoostMax)

    return t1.StrengthBoost[v6], v6
end

function t1.strengthBoostNow(p14) -- line: 254
    local v7 = p14:GetAttribute("StrengthBoostLeft") or 0

    if v7 > 0 then
        return v7, p14:GetAttribute("StrengthBoostMult") or 1
    end

    return v7, 1
end

function t1.giftPass(p15) -- line: 260
    -- upvalues: t1 (copy)
    for v8, v9 in t1.Gifts do
        if v9 == p15 then
            return v8
        end
    end

    return nil
end

function t1.get(p16) -- line: 270
    -- upvalues: t1 (copy)
    return t1.Items[p16] or t1.Passes[p16]
end

function t1.isPass(p17) -- line: 274
    -- upvalues: t1 (copy)
    return t1.Passes[p17] ~= nil
end

function t1.saleOff(p18, p19) -- line: 279
    -- upvalues: t1 (copy)
    local v10 = t1.Passes[p18]

    return if v10 and v10.WasPrice and not (v10.WasPrice <= p19) then math.floor((1 - p19 / v10.WasPrice) * 100 + 0.5) else nil
end

for _, v12 in {
        t1.Exclusives,
        t1.CashPacks,
        t1.StrengthPacks,
        t1.Packs,
        t1.Potions
    } do
    for _, v13 in v12 do
        assert(t1.Items[v13.Key], (("Products: no item %*"):format(v13.Key)))
    end
end

for v16 in t1.Limited do
    assert(t1.Items[v16], (("Products: no item %*"):format(v16)))
end

for _, v19 in t1.StrengthBoost do
    assert(t1.Items[v19], (("Products: no item %*"):format(v19)))
end

for _, v22 in t1.ServerLuck do
    assert(t1.Items[v22], (("Products: no item %*"):format(v22)))
end

for v25, v26 in t1.Gifts do
    assert(t1.Passes[v25] and t1.Items[v26], (("Products: bad gift %*"):format(v26)))
end

return t1
