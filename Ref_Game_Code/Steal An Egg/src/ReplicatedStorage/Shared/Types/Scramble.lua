-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local ScrambleRules = require(ReplicatedStorage.Shared.Util.ScrambleRules)

local function v1(p1) -- line: 5
    -- upvalues: ScrambleRules (copy)
    return ScrambleRules.Integer(p1, 0, ScrambleRules.MAX_SAMPLES)
end

return table.freeze({
    Blank = ScrambleRules.Blank,
    State = t.interface({
        Wallets = t.map(t.string, v1),
        LostParts = t.interface({
            LostPart1 = t.optional(t.boolean),
            LostPart2 = t.optional(t.boolean)
        }),
        DroneParts = function(p2) -- DroneParts | line: 29
            -- upvalues: ScrambleRules (copy)
            return ScrambleRules.Integer(p2, 0, 3)
        end,
        Discovered = t.boolean,
        Completed = t.boolean,
        RewardUid = t.string,
        MutationConsumables = t.optional(v1),
        ShopSequence = v1,
        ShopPurchases = t.optional(t.map(t.string, t.map(t.string, t.interface({
            Period = t.string,
            Count = v1
        })))),
        LastOperation = t.string,
        Receipts = t.map(t.string, t.interface({
            ProductId = v1,
            EventId = t.string,
            Amount = v1
        })),
        Mastery = t.optional(v1),
        ClaimedMilestoneIds = t.optional(t.map(t.string, t.boolean)),
        InfiniteRewardsClaimed = t.optional(v1)
    })
})
