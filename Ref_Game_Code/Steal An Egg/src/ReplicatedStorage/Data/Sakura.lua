-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local t1 = {}
local v1 = t1

t1.EventName = "GreatBloom"
t1.CurrencyId = "SakuraCrystals"
t1.MutationName = "Sakura"
t1.SpecialMutationName = "GreatBloom"
t1.TreeTag = "SakuraBloomTree"
t1.CrystalTag = "SakuraCrystal"
t1.BatToolAttribute = "IsBat"
t1.Bloom = {
    IntervalSeconds = 1800,
    OffsetSeconds = 900,
    DurationSeconds = 285,
    NightPollSeconds = 0.5,
    EndsAtAttribute = "GreatBloomEndsAt",
    MaxActiveTrees = 50,
    SpawnDelayMin = 0.25,
    SpawnDelayMax = 0.75,
    SpawnClearance = 6,
    SpawnAttempts = 40,
    HitCooldownSeconds = 0.6,
    HitHoldSeconds = 0.2,
    EndingWarningSeconds = 30,
    HitRange = 10,
    SpawnShakeRadius = 10,
    CrystalScale = 0.22,
    CrystalPickupRange = 10,
    CrystalLifetimeSeconds = 60,
    CrystalSpreadRadius = 14,
    Sizes = {
        {
            Id = "Small",
            Weight = 50,
            Hits = 1,
            CrystalsPerHit = 0,
            ScatterCrystals = 1,
            ScatterCrystalValue = 5
        },
        {
            Id = "Medium",
            Weight = 30,
            Hits = 2,
            CrystalsPerHit = 0,
            ScatterCrystals = 2,
            ScatterCrystalValue = 5
        },
        {
            Id = "Large",
            Weight = 15,
            Hits = 3,
            CrystalsPerHit = 0,
            ScatterCrystals = 4,
            ScatterCrystalValue = 5
        },
        {
            Id = "Gigantic",
            Weight = 5,
            Hits = 3,
            CrystalsPerHit = 0,
            ScatterCrystals = 6,
            ScatterCrystalValue = 5
        }
    }
}
t1.Incubator = {
    Cost = 1000,
    MaxChargePercent = 150,
    SpecialChanceAt100 = 2.5,
    SpecialChanceAtMax = 5,
    LuckBoostMultiplier = 2,
    MaxLuckBoosts = 3,
    LuckBoostProductNames = { "SakuraLuckBoost1", "SakuraLuckBoost2", "SakuraLuckBoost3" }
}
t1.Sounds = {
    TreeSpawn = 116457372922007,
    TreeHit = 84529703733081,
    TreeBreak = 83426144942407,
    CrystalPickup = 98181315786739,
    CrystalsGained = 72831064837421,
    Deposit = 133204478644023,
    Mutate = 139860804876890,
    CraneFlap = 9120779671,
    Bloom = 9116418035,
    Unlocked = 102177008084626,
    TutorialOpen = 89550685069550
}
t1.AreaDisplay = {
    AreaId = "CherryBlossom",
    DisplayName = "Cherry Blossom",
    Emoji = "🌸",
    Lighting = "CherryBlossom",
    Rarity = Rarity.Rarities.Divine
}
t1.Quest = {
    CraneAssetId = "Crane"
}

local function GetRequiredCrystals() -- line: 123
    -- upvalues: v1 (ref)
    return v1.Incubator.Cost
end

local v2 = v1

v2.GetRequiredCrystals = GetRequiredCrystals

function v2.GetChargePercent(p1, p2) -- line: 127
    -- upvalues: v1 (ref)
    if p2 <= 0 then
        return 0
    end

    return (math.clamp(p1 / p2 * 100, 0, v1.Incubator.MaxChargePercent))
end

function v2.GetLuckMultiplier(p3) -- line: 135
    -- upvalues: v1 (ref)
    return v1.Incubator.LuckBoostMultiplier ^ p3
end

function v2.CanBuyLuckBoost(p4, p5) -- line: 139
    -- upvalues: v1 (ref)
    if not p4.Unlocked then
        return false, "The Sakura Incubator is still sealed"
    end

    if p4.Egg == false then
        return false, "Place an egg inside first"
    end

    if p4.LuckBoost >= v1.Incubator.MaxLuckBoosts then
        return false, "This egg already has max luck"
    end

    if p5 == p4.LuckBoost + 1 then
        return true, nil
    end

    return false, "Wrong luck boost tier for this egg"
end

function v2.GetFreeChargeCap(p6) -- line: 162
    -- upvalues: v1 (ref)
    return (math.ceil(p6 * v1.Incubator.MaxChargePercent / 100))
end

function v2.GetMutationChance(p7) -- line: 166
    return (math.clamp(p7, 0, 100))
end

function v2.GetEffectiveMutationChance(p8, p9) -- line: 171
    -- upvalues: v1 (ref)
    return 100 - v1.GetSpecialChance(p8, p9)
end

function v2.GetSpecialChance(p10, p11) -- line: 175
    -- upvalues: AdminBoosts (copy), v1 (ref)
    local Incubator = v1.Incubator
    local v8 = math.max(p10 - 100, 0) / math.max(Incubator.MaxChargePercent - 100, 1)
    local v9 = Incubator.SpecialChanceAt100 + (Incubator.SpecialChanceAtMax - Incubator.SpecialChanceAt100) * v8
    local v10 = AdminBoosts.ReadMultiplier(AdminBoosts.VIDEO_LUCK)

    return (math.clamp(v9 * v1.GetLuckMultiplier(p11) * v10, 0, 100))
end

function v2.PickTreeSize(p12) -- line: 184
    -- upvalues: v1 (ref)
    local Sizes = v1.Bloom.Sizes
    local n1 = 0

    for _, v12 in Sizes do
        n1 += v12.Weight
    end

    local v13 = p12:NextNumber() * n1
    local n2 = 0

    for _, v14 in Sizes do
        n2 += v14.Weight

        if v13 <= n2 then
            return v14
        end
    end

    return Sizes[#Sizes]
end

function v2.GetTreeSize(p13) -- line: 206
    -- upvalues: v1 (ref)
    for _, v15 in v1.Bloom.Sizes do
        if v15.Id == p13 then
            return v15
        end
    end

    error((("Unknown Sakura tree size %*"):format(p13)))
end

function v2.HasSakuraMutation(p14) -- line: 216
    -- upvalues: v1 (ref)
    if p14 == nil then
        return false
    end

    if table.find(p14, v1.MutationName) == nil then
        return table.find(p14, v1.SpecialMutationName) ~= nil
    end

    return true
end

function v2.IsBatTool(p15) -- line: 225
    -- upvalues: v1 (ref)
    return p15:GetAttribute(v1.BatToolAttribute) == true
end

v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Sakura", v2, {
    Bloom = {
        IntervalSeconds = true,
        OffsetSeconds = true,
        DurationSeconds = true,
        MaxActiveTrees = true,
        SpawnDelayMin = true,
        SpawnDelayMax = true,
        HitCooldownSeconds = true,
        HitRange = true,
        CrystalPickupRange = true,
        CrystalLifetimeSeconds = true,
        Sizes = true
    },
    Incubator = {
        Cost = true,
        MaxChargePercent = true,
        SpecialChanceAt100 = true,
        SpecialChanceAtMax = true,
        LuckBoostMultiplier = true,
        MaxLuckBoosts = true
    }
}, false, function(p16) -- line: 256
    assert(p16.Bloom.IntervalSeconds > 0 and p16.Bloom.DurationSeconds > 0)
    assert(p16.Bloom.SpawnDelayMax >= p16.Bloom.SpawnDelayMin and p16.Bloom.SpawnDelayMin > 0)
    assert(p16.Bloom.MaxActiveTrees % 1 == 0)
    assert(p16.Incubator.Cost > 0 and p16.Incubator.MaxChargePercent > 100)
    assert(p16.Incubator.SpecialChanceAt100 <= 100 and p16.Incubator.SpecialChanceAtMax <= 100)
    assert(p16.Incubator.MaxLuckBoosts % 1 == 0 and p16.Incubator.MaxLuckBoosts <= 3)
end)

return v1
