-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    RewardIds = table.freeze({
        EggGrowthBoost = "EggGrowthBoost",
        SpeedBoost = "SpeedBoost",
        TreadmillBoost = "TreadmillBoost",
        ExclusiveWeapon = "ExclusiveWeapon",
        MonsterEgg = "MonsterEgg"
    }),
    RetiredRewardIds = table.freeze({
        Cash = "Cash",
        SpeedSmall = "SpeedSmall",
        SpeedLarge = "SpeedLarge"
    })
}
local v1 = t.union(t.literal(t1.RewardIds.EggGrowthBoost), t.literal(t1.RewardIds.SpeedBoost), t.literal(t1.RewardIds.TreadmillBoost), t.literal(t1.RewardIds.ExclusiveWeapon), t.literal(t1.RewardIds.MonsterEgg), t.literal(t1.RetiredRewardIds.Cash), t.literal(t1.RetiredRewardIds.SpeedSmall), t.literal(t1.RetiredRewardIds.SpeedLarge))
local v2 = t.interface({
    Id = v1,
    DisplayName = t.string,
    Amount = t.optional(t.number),
    ItemId = t.optional(t.string),
    Egg = t.optional(t.interface({
        Uid = t.string,
        AssetCategory = t.string,
        Mutation = t.string
    }))
})

t1.PendingRewardSchema = t.interface({
    OpeningId = t.string,
    Reward = v2,
    SerializedEgg = t.optional(Eggs.SchemaValidation.SerializedSavedEgg)
})
t1.StateSchema = t.interface({
    Charge = t.number,
    PendingChests = t.number,
    TotalFeeds = t.number,
    PendingReward = t.optional(t1.PendingRewardSchema),
    EggGrowthBoostExpiresAt = t.optional(t.number),
    SpeedBoostExpiresAt = t.optional(t.number)
})
t1.EventStateSchema = t.interface({
    Active = t.boolean,
    EndsAt = t.number,
    ServerTime = t.number
})
t1.SnapshotSchema = t.interface({
    Event = t1.EventStateSchema,
    State = t1.StateSchema
})
t1.FeedResultSchema = t.interface({
    Success = t.boolean,
    Message = t.string,
    EggUid = t.optional(t.string),
    PreviousCharge = t.optional(t.number),
    Charge = t.optional(t.number),
    PendingChests = t.optional(t.number)
})
t1.ChestResultSchema = t.interface({
    Success = t.boolean,
    Message = t.string,
    OpeningId = t.optional(t.string),
    Reward = t.optional(v2),
    PendingChests = t.optional(t.number)
})
t1.RevealResultSchema = t.interface({
    Success = t.boolean,
    Message = t.string
})
t1.TakeResultSchema = t.interface({
    Success = t.boolean,
    Message = t.string
})
t1.ViewRewardsPromptName = "ViewRewardsPrompt"
t1.ViewRewardsPromptText = "View Rewards"
t1.ChargeDrainAttributeName = "MonsterChargeDrain"
t1.ChargeDrainDuration = 0.5
t1.ChargeGainAttributeName = "MonsterChargeGain"
t1.ChargeGainCueTimeout = 4
t1.BoostKinds = table.freeze({
    EggGrowth = "EggGrowth",
    Speed = "Speed"
})
t1.BoostRewardIds = table.freeze({
    EggGrowth = t1.RewardIds.EggGrowthBoost,
    Speed = t1.RewardIds.SpeedBoost
})

function t1.BoostExpiresAt(p1, p2) -- line: 295
    -- upvalues: t1 (copy)
    if p1 ~= nil then
        local v3 = if p2 == t1.BoostKinds.EggGrowth then p1.EggGrowthBoostExpiresAt else p1.SpeedBoostExpiresAt

        if type(v3) == "number" then
            return v3
        end
    end

    return 0
end

function t1.BoostRemainingSeconds(p3, p4, p5) -- line: 306
    -- upvalues: Workspace (copy), t1 (copy)
    local v4 = if p5 == nil then Workspace:GetServerTimeNow() else p5

    return (math.max(t1.BoostExpiresAt(p3, p4) - v4, 0))
end

function t1.IsBoostActive(p6, p7, p8) -- line: 315
    -- upvalues: t1 (copy)
    return t1.BoostRemainingSeconds(p6, p7, p8) > 0
end

function t1.RefreshBoost(p9, p10, p11, p12) -- line: 330
    -- upvalues: t1 (copy)
    local v6 = table.clone(p9)
    local v8 = math.max(p12 + p11, t1.BoostExpiresAt(p9, p10))

    if p10 == t1.BoostKinds.EggGrowth then
        v6.EggGrowthBoostExpiresAt = v8
    else
        v6.SpeedBoostExpiresAt = v8
    end

    return v6
end

function t1.DefaultState() -- line: 349
    return {
        Charge = 0,
        PendingChests = 0,
        TotalFeeds = 0
    }
end

return table.freeze(t1)
