-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)

local function wholes(p1, p2) -- line: 36
    for v1, v2 in p1 do
        assert(v2 % 1 == 0, (("%*.%* must be a whole number"):format(p2, v1)))
    end
end

local t1 = {
    EventName = "RaceRally",
    Currency = "RaceTokens",
    CurrencyName = "Trophies",
    CurrencyIcon = "rbxassetid://119210375463488",
    Track = "RaceTrack",
    Zone = "Abyss Ocean",
    DefaultRacer = "Ostrich",
    Attributes = table.freeze({
        JoinEndsAt = "RaceRallyJoinEndsAt",
        HeatJoinEndsAt = "RaceRallyHeatJoinEndsAt",
        Window = "RaceRallyWindow",
        Running = "RaceRallyRunning"
    }),
    PlayerAttributes = table.freeze({
        Queued = "RaceRallyQueued"
    }),
    Racers = table.freeze({
        Ostrich = table.freeze({
            Order = 1,
            DisplayName = "Ostrich",
            Mount = "Ostrich",
            Asset = "Ostrich"
        }),
        Seahorse = table.freeze({
            Order = 2,
            DisplayName = "Seahorse",
            Mount = "RaceSeahorse",
            Asset = "Race Seahorse"
        }),
        Lizard = table.freeze({
            Order = 3,
            DisplayName = "Lizard",
            Mount = "RaceLizard",
            Asset = "Race Lizard"
        }),
        Bird = table.freeze({
            Order = 4,
            DisplayName = "Bird",
            Mount = "RaceBird",
            Asset = "Race Bird"
        }),
        Cheetah = table.freeze({
            Order = 5,
            DisplayName = "Cheetah",
            Mount = "RaceCheetah",
            Asset = "Race Cheetah"
        }),
        Snail = table.freeze({
            Order = 6,
            DisplayName = "Engine Snail",
            Mount = "EngineSnail",
            Asset = "Engine Snail"
        })
    })
}

t1.Payouts = BalanceConfig.Bind("Game.Balance.RaceRallyPayouts", {
    First = 2500,
    Second = 2025,
    Third = 1550,
    Finish = 1750,
    Unfinished = 0,
    WinPoints = 1
}, true, false, function(p3) -- line: 114
    for v5, v6 in p3 do
        assert(v6 % 1 == 0, (("RaceRallyPayouts.%* must be a whole number"):format(v5)))
    end
end)
t1.Shop = BalanceConfig.Bind("Game.Balance.RaceRallyShop", {
    MutationToken = {
        Order = 1,
        Price = 475,
        Limit = 0,
        RestockSeconds = 0,
        Reward = {
            Kind = "MutationConsumable",
            MutationId = "Nitro",
            Amount = 1
        }
    },
    CashBooster = {
        Order = 2,
        Price = 275,
        Limit = 0,
        RestockSeconds = 0,
        Reward = {
            Kind = "CashBooster"
        }
    },
    SpeedBoost = {
        Order = 3,
        Price = 375,
        Limit = 0,
        RestockSeconds = 0,
        Reward = {
            Kind = "SpeedBoost"
        }
    },
    TreadmillBoost = {
        Order = 4,
        Price = 375,
        Limit = 0,
        RestockSeconds = 0,
        Reward = {
            Kind = "TreadmillBoost"
        }
    },
    RacingBat = {
        Order = 5,
        Price = 10000,
        Limit = 1,
        RestockSeconds = 0,
        Reward = {
            Kind = "Gear",
            GearId = "Racing Bat",
            Amount = 1
        }
    }
}, {
    Price = true,
    Limit = true,
    RestockSeconds = true
}, true, function(p4) -- line: 160
    for v9, v10 in p4 do
        local v11 = ("RaceRallyShop.%*"):format(v9)

        for v12, v13 in v10 do
            assert(v13 % 1 == 0, (("%*.%* must be a whole number"):format(v11, v12)))
        end

        assert(v10.Price > 0, (("RaceRallyShop.%*.Price must be positive"):format(v9)))
    end
end)
t1.Milestones = BalanceConfig.Bind("Game.Balance.RaceRallyMilestones", {
    Wins1 = {
        Order = 1,
        Wins = 1,
        Rewards = {
            {
                Kind = "Egg",
                Category = "Race Seahorse"
            },
            {
                Kind = "Racer",
                Racer = "Seahorse"
            }
        }
    },
    Wins3 = {
        Order = 2,
        Wins = 3,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 475
            }
        }
    },
    Wins5 = {
        Order = 3,
        Wins = 5,
        Rewards = {
            {
                Kind = "Egg",
                Category = "Race Lizard"
            },
            {
                Kind = "Racer",
                Racer = "Lizard"
            }
        }
    },
    Wins7 = {
        Order = 4,
        Wins = 7,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 475
            }
        }
    },
    Wins10 = {
        Order = 5,
        Wins = 10,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 625
            }
        }
    },
    Wins12 = {
        Order = 6,
        Wins = 12,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 625
            }
        }
    },
    Wins15 = {
        Order = 7,
        Wins = 15,
        Rewards = {
            {
                Kind = "Egg",
                Category = "Race Bird"
            },
            {
                Kind = "Racer",
                Racer = "Bird"
            }
        }
    },
    Wins17 = {
        Order = 8,
        Wins = 17,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 845
            }
        }
    },
    Wins19 = {
        Order = 9,
        Wins = 19,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 845
            }
        }
    },
    Wins21 = {
        Order = 10,
        Wins = 21,
        Rewards = {
            {
                Kind = "Egg",
                Category = "Race Cheetah"
            },
            {
                Kind = "Racer",
                Racer = "Cheetah"
            }
        }
    },
    Wins24 = {
        Order = 11,
        Wins = 24,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 1250
            }
        }
    },
    Wins27 = {
        Order = 12,
        Wins = 27,
        Rewards = {
            {
                Kind = "Tokens",
                Amount = 1250
            }
        }
    },
    Wins30 = {
        Order = 13,
        Wins = 30,
        Rewards = {
            {
                Kind = "Egg",
                Category = "Engine Snail"
            },
            {
                Kind = "Racer",
                Racer = "Snail"
            }
        }
    }
}, {
    Wins = true
}, true, function(p5) -- line: 222
    for v18, v19 in p5 do
        local v20 = ("RaceRallyMilestones.%*"):format(v18)

        for v21, v22 in v19 do
            assert(v22 % 1 == 0, (("%*.%* must be a whole number"):format(v20, v21)))
        end

        assert(v19.Wins >= 1, (("RaceRallyMilestones.%*.Wins must be at least 1"):format(v18)))
    end
end)
t1.RepeatId = "Repeat"
t1.Repeat = BalanceConfig.Bind("Game.Balance.RaceRallyRepeat", {
    After = 30,
    Every = 5,
    Rewards = {
        {
            Kind = "Tokens",
            Amount = 1250
        }
    }
}, {
    After = true,
    Every = true
}, false, function(p6) -- line: 242
    for v27, v28 in p6 do
        assert(v28 % 1 == 0, (("RaceRallyRepeat.%* must be a whole number"):format(v27)))
    end

    assert(p6.After >= 0, "RaceRallyRepeat.After can't be negative")
    assert(p6.Every >= 1, "RaceRallyRepeat.Every must be at least 1")
end)

local function ordered(p7) -- line: 249
    local t2 = {}

    for v33, v34 in p7 do
        table.insert(t2, {
            Id = v33,
            Config = v34
        })
    end

    table.sort(t2, function(p8, p9) -- line: 254
        return p8.Config.Order < p9.Config.Order
    end)

    return t2
end

function t1.OrderedRacers() -- line: 260
    -- upvalues: t1 (copy), ordered (copy)
    return (ordered(t1.Racers))
end

function t1.OrderedOffers() -- line: 264
    -- upvalues: t1 (copy), ordered (copy)
    return (ordered(t1.Shop))
end

function t1.OrderedMilestones() -- line: 268
    -- upvalues: t1 (copy), ordered (copy)
    return (ordered(t1.Milestones))
end

function t1.RepeatsEarned(p10) -- line: 273
    -- upvalues: t1 (copy)
    local Repeat = t1.Repeat

    return math.max(p10 - Repeat.After, 0) // Repeat.Every
end

function t1.RepeatWins(p11) -- line: 279
    -- upvalues: t1 (copy)
    local Repeat = t1.Repeat

    return Repeat.After + p11 * Repeat.Every
end

function t1.PlaceTokens(p12, p13) -- line: 285
    -- upvalues: t1 (copy)
    local Payouts = t1.Payouts

    if not p13 then
        return Payouts.Unfinished
    end

    if p12 == 1 then
        return Payouts.First
    end

    if p12 == 2 then
        return Payouts.Second
    end

    if p12 == 3 then
        return Payouts.Third
    end

    return Payouts.Finish
end

function t1.RestockPeriod(p14, p15) -- line: 298
    if p14.RestockSeconds > 0 then
        return p15 // p14.RestockSeconds
    end

    return 0
end

function t1.PurchasedCount(p16, p17, p18) -- line: 303
    -- upvalues: t1 (copy)
    if p16 == nil or p16.Period ~= t1.RestockPeriod(p17, p18) then
        return 0
    end

    return p16.Count
end

function t1.ResolveRacer(p19, p20) -- line: 315
    -- upvalues: t1 (copy)
    if t1.Racers[p19] ~= nil and (p20[p19] or p19 == t1.DefaultRacer) then
        return p19
    end

    return t1.DefaultRacer
end

t1.DoubleTrophies = table.freeze({
    Key = "DoubleTrophies",
    ProductId = 3717648487,
    DevProductId = 3717648477,
    Icon = "rbxassetid://137714350382416"
})

function t1.DoubleTrophiesProductId() -- line: 332
    -- upvalues: t1 (copy)
    local DoubleTrophies = t1.DoubleTrophies

    if game.GameId == 10650210095 then
        return DoubleTrophies.DevProductId
    end

    return DoubleTrophies.ProductId
end

function t1.OwnsDoubleTrophies(p21) -- line: 337
    -- upvalues: t1 (copy)
    return p21 ~= nil and p21[tostring(t1.DoubleTrophiesProductId())] == true
end

return table.freeze(t1)
