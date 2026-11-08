-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)

require(ReplicatedStorage.Data.RaceRally)

local t1 = {}

t1.Prizes = BalanceConfig.Bind("Game.Balance.TheHollowPrizes", {
    Win1 = {
        Order = 1,
        Wins = 1,
        Rewards = {
            {
                Kind = "CashBooster",
                Multiplier = 1.5,
                Seconds = 300
            }
        }
    },
    Win2 = {
        Order = 2,
        Wins = 2,
        Rewards = {
            {
                Kind = "CashBooster",
                Multiplier = 2,
                Seconds = 600
            }
        }
    },
    Win3 = {
        Order = 3,
        Wins = 3,
        Rewards = {
            {
                Kind = "SpeedBoost",
                Seconds = 600
            }
        }
    }
}, {
    Wins = true
}, true, function(p1) -- line: 23
    for v1, v2 in p1 do
        assert(v2.Wins >= 1 and v2.Wins % 1 == 0, (("TheHollowPrizes.%*.Wins must be a whole number of at least 1"):format(v1)))
    end
end)

function t1.OrderedPrizes() -- line: 30
    -- upvalues: t1 (copy)
    local t2 = {}

    for v5, v6 in t1.Prizes do
        table.insert(t2, {
            Id = v5,
            Config = v6
        })
    end

    table.sort(t2, function(p2, p3) -- line: 35
        return p2.Config.Order < p3.Config.Order
    end)

    return t2
end

return table.freeze(t1)
