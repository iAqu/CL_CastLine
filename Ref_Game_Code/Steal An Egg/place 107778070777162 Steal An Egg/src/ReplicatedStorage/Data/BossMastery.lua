-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)

require(ReplicatedStorage.Shared.Types.BossMastery)

local Currency = require(ReplicatedStorage.Data.Currency)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rift = require(ReplicatedStorage.Data.Rift)
local t1 = {
    RiftbornEgg = {
        Id = "RiftbornEgg",
        DisplayName = "Riftborn Egg",
        Reward = {
            Kind = "RiftEgg",
            BannerId = "Verdant",
            Mutated = false
        }
    },
    RiftbeastsEgg = {
        Id = "RiftbeastsEgg",
        DisplayName = "Riftbeasts Egg",
        Reward = {
            Kind = "RiftEgg",
            BannerId = "Umbral",
            Mutated = false
        }
    },
    MutatedRiftbornEgg = {
        Id = "MutatedRiftbornEgg",
        DisplayName = "Mutated Riftborn Egg",
        Reward = {
            Kind = "RiftEgg",
            BannerId = "Verdant",
            Mutated = true
        }
    },
    RotationMutatedEgg = {
        Id = "RotationMutatedEgg",
        DisplayName = "Mutated Egg",
        Reward = {
            Kind = "RiftRotationEgg",
            Mutated = true
        }
    },
    TokenBoost = {
        Id = "TokenBoost",
        DisplayName = "Permanent Boss Token Boost",
        Reward = {
            Kind = "TokenBoost",
            Percent = 50
        }
    }
}
local t2 = {
    {
        Id = "Mastery3",
        Kills = 3,
        RewardId = "RiftbornEgg"
    },
    {
        Id = "Mastery5",
        Kills = 5,
        RewardId = "TokenBoost"
    },
    {
        Id = "Mastery10",
        Kills = 10,
        RewardId = "RiftbeastsEgg"
    },
    {
        Id = "Mastery15",
        Kills = 15,
        RewardId = "MutatedRiftbornEgg"
    },
    {
        Id = "Mastery20",
        Kills = 20,
        RewardId = "RotationMutatedEgg"
    },
    {
        Id = "Mastery30",
        Kills = 30,
        RewardId = "RotationMutatedEgg"
    }
}
local t3 = {}

for _, v1 in t2 do
    t3[v1.Id] = v1
end

local t4 = {
    {
        Id = "CashBooster",
        DisplayName = "2x Cash Booster",
        Icon = "rbxassetid://119640363267627",
        Price = 175,
        Reward = {
            Kind = "CashBooster"
        }
    },
    {
        Id = "SpeedBoost",
        DisplayName = "1.25x Speed",
        Icon = "rbxassetid://78137530993637",
        Price = 225,
        Reward = {
            Kind = "SpeedBoost"
        }
    },
    {
        Id = "TreadmillBooster",
        DisplayName = "2x Treadmill Booster",
        Icon = "rbxassetid://107126944152347",
        Price = 200,
        Reward = {
            Kind = "TreadmillBoost"
        }
    },
    {
        Id = "MutationConsumable",
        DisplayName = "Mutation Consumable",
        Icon = "rbxassetid://74755693699202",
        Price = 400,
        Reward = {
            Kind = "MutationConsumable"
        }
    }
}
local t5 = {}

for _, v2 in t4 do
    t5[v2.Id] = v2
end

local t6 = {
    Verdant = 55,
    Umbral = 40,
    Radiant = 5
}
local t7 = {
    MutationId = "Boss",
    InfiniteMilestoneId = "Infinite",
    Milestones = t2,
    ShopProducts = t4
}

local function getRewardSpec(p1) -- line: 173
    -- upvalues: t1 (copy)
    return t1[p1]
end

function t7.GetMilestone(p2) -- line: 177
    -- upvalues: t3 (copy)
    return t3[p2]
end

function t7.FinalMilestone() -- line: 181
    -- upvalues: t2 (copy)
    return t2[#t2]
end

function t7.GetMilestoneKills(p3) -- line: 185
    -- upvalues: BossMasteryFlags (copy)
    local v3 = BossMasteryFlags.MilestoneKillOverrides:Get()[p3.Id]

    if v3 == nil then
        return p3.Kills
    end

    return v3
end

function t7.GetMilestoneRewardId(p4) -- line: 193
    -- upvalues: BossMasteryFlags (copy), t1 (copy)
    local v4 = BossMasteryFlags.MilestoneRewardIdOverrides:Get()[p4.Id]

    if v4 == nil or t1[v4] == nil then
        return p4.RewardId
    end

    return v4
end

function t7.GetMilestoneReward(p5) -- line: 202
    -- upvalues: t1 (copy), t7 (copy)
    local v6 = t1[t7.GetMilestoneRewardId(p5)]

    if not v6 then
        v6 = t1[p5.RewardId]
    end

    assert(v6 ~= nil, (("Unknown Boss Mastery reward for %*"):format(p5.Id)))

    return v6.Reward
end

function t7.GetInfiniteRewardId() -- line: 209
    -- upvalues: BossMasteryFlags (copy), t1 (copy)
    local v9 = BossMasteryFlags.InfiniteRewardId:Get()
    local v10 = t1[v9]

    if v10 ~= nil and (v10.Reward.Kind == "RiftEgg" or v10.Reward.Kind == "RiftRotationEgg") then
        return v9
    end

    return "RotationMutatedEgg"
end

function t7.GetInfiniteReward() -- line: 224
    -- upvalues: t1 (copy), t7 (copy)
    return assert(t1[t7.GetInfiniteRewardId()], "Infinite Boss Mastery reward spec is missing").Reward
end

function t7.InfiniteRevealKey(p6) -- line: 232
    -- upvalues: t7 (copy)
    return (("%*:%*"):format(t7.InfiniteMilestoneId, p6))
end

function t7.GetTokenBoostPercent(p7) -- line: 236
    -- upvalues: BossMasteryFlags (copy), t7 (copy)
    local v13 = t7.GetMilestoneReward(p7)

    if v13.Kind ~= "TokenBoost" then
        return 0
    end

    local v14 = BossMasteryFlags.TokenBoostPercentOverrides:Get()[p7.Id]

    if v14 == nil then
        return v13.Percent
    end

    return v14
end

function t7.GetShopProduct(p8) -- line: 249
    -- upvalues: t5 (copy)
    return t5[p8]
end

function t7.GetShopProducts() -- line: 253
    -- upvalues: BossMasteryFlags (copy), t5 (copy)
    local t8 = {}
    local t9 = {}

    for _, v15 in BossMasteryFlags.ShopProductIds:Get() do
        local v16 = t5[v15]

        if v16 ~= nil and not t9[v15] then
            t9[v15] = true
            table.insert(t8, v16)
        end
    end

    return t8
end

function t7.IsShopProductListed(p9) -- line: 266
    -- upvalues: t7 (copy)
    for _, v17 in t7.GetShopProducts() do
        if v17.Id == p9 then
            return true
        end
    end

    return false
end

function t7.GetShopPrice(p10) -- line: 275
    -- upvalues: BossMasteryFlags (copy)
    local v18 = BossMasteryFlags.ShopPriceOverrides:Get()[p10.Id]

    if v18 == nil then
        return p10.Price
    end

    return v18
end

function t7.GetShopDisplayName(p11) -- line: 283
    -- upvalues: BossMasteryFlags (copy)
    local Reward = p11.Reward

    if Reward.Kind == "CashBooster" then
        return (("%*x Cash Booster"):format((BossMasteryFlags.CashBoosterMultiplier:Get())))
    end

    if Reward.Kind == "SpeedBoost" then
        return (("%*x Speed"):format((BossMasteryFlags.SpeedBoostMultiplier:Get())))
    end

    if Reward.Kind == "TreadmillBoost" then
        return (("%*x Treadmill Booster"):format((BossMasteryFlags.TreadmillBoostMultiplier:Get())))
    end

    return p11.DisplayName
end

function t7.GetShopQuantity(p12) -- line: 295
    -- upvalues: BossMasteryFlags (copy)
    if p12.Reward.Kind == "Traps" then
        return BossMasteryFlags.TrapsPerPurchase:Get()
    end

    return 1
end

function t7.GetShopQuantityText(p13) -- line: 302
    -- upvalues: BossMasteryFlags (copy), t7 (copy)
    local Reward = p13.Reward

    if Reward.Kind == "CashBooster" then
        return (("%*m"):format((math.max(math.floor(BossMasteryFlags.CashBoosterDurationSeconds:Get() / 60), 0))))
    end

    if Reward.Kind == "SpeedBoost" then
        return (("%*m"):format((math.max(math.floor(BossMasteryFlags.SpeedBoostDurationSeconds:Get() / 60), 0))))
    end

    if Reward.Kind == "TreadmillBoost" then
        return (("%*m"):format((math.max(math.floor(BossMasteryFlags.TreadmillBoostDurationSeconds:Get() / 60), 0))))
    end

    if Reward.Kind == "MutationConsumable" then
        return (("%*%%"):format((BossMasteryFlags.MutationConsumableSuccessPercent:Get())))
    end

    return (("x%*"):format((t7.GetShopQuantity(p13))))
end

function t7.RewardNeedsReveal(p14) -- line: 327
    if p14.Kind == "RiftEgg" then
        return true
    end

    return p14.Kind == "RiftRotationEgg"
end

function t7.GetRotationBannerWeights() -- line: 331
    -- upvalues: BossMasteryFlags (copy), Rift (copy), t6 (copy)
    local v25 = BossMasteryFlags.InfiniteBannerWeights:Get()
    local v26 = table.clone(t6)

    for v27, v28 in v25 do
        if Rift.GetBanner(v27) ~= nil then
            v26[v27] = v28
        end
    end

    return v26
end

function t7.RollBannerId(p15) -- line: 342
    -- upvalues: t7 (copy)
    local v29 = t7.GetRotationBannerWeights()
    local n1 = 0

    for _, v30 in v29 do
        if v30 > 0 then
            n1 += v30
        end
    end

    if n1 <= 0 then
        return nil
    end

    local v31 = p15:NextNumber() * n1
    local n2 = 0
    local v32

    for v33, v34 in v29 do
        if not (v34 <= 0) then
            n2 += v34

            if v31 <= n2 then
                return v33
            end

            v32 = v33
        end
    end

    return v32
end

function t7.RollReveal(p16, p17) -- line: 370
    -- upvalues: Rift (copy), t7 (copy)
    local v35

    if p16.Kind == "RiftEgg" then
        v35 = p16.BannerId
    else
        if p16.Kind ~= "RiftRotationEgg" then
            return nil
        end

        v35 = t7.RollBannerId(p17)

        if v35 == nil then
            return nil
        end
    end

    local v36 = Rift.RollPet(v35, p17)

    return if v36 ~= nil then {
        BannerId = v35,
        AssetId = v36
    } else nil
end

function t7.FillMissingReveals(p18, p19) -- line: 394
    -- upvalues: Assets (copy), Rift (copy), t2 (copy), t7 (copy)
    local v37 = table.clone(p18.RevealedRewards or {})
    local v38 = false

    local function ensure(p20, p21) -- line: 401
        -- upvalues: p19 (copy), v37 (copy), v38 (ref), Assets (copy), Rift (copy), t7 (copy)
        local v39 = v37[p20]

        if v39 ~= nil then
            if (p21.Kind ~= "RiftEgg" or v39.BannerId == p21.BannerId) and Assets.Directory[v39.AssetId] ~= nil and Rift.BannerContainsPet(v39.BannerId, v39.AssetId) then
                return
            end

            v37[p20] = nil
            v38 = true
        end

        local v40 = t7.RollReveal(p21, p19)

        if v40 ~= nil then
            v37[p20] = v40
            v38 = true
        end
    end

    for _, v41 in t2 do
        if not p18.ClaimedMilestoneIds[v41.Id] then
            ensure(v41.Id, t7.GetMilestoneReward(v41))
        end
    end

    local v42 = t7.ClaimableInfiniteCount(p18)
    local v43 = t7.GetInfiniteReward()

    if p18.ClaimedMilestoneIds[t7.FinalMilestone().Id] then
        local v44 = math.max(v42, 1)

        for i = p18.InfiniteRewardsClaimed + 1, p18.InfiniteRewardsClaimed + v44 do
            ensure(t7.InfiniteRevealKey(i), v43)
        end
    end

    if not v38 then
        return p18
    end

    local v45 = table.clone(p18)

    v45.RevealedRewards = v37

    return v45
end

function t7.TokenBoostMultiplierFor(p22) -- line: 448
    -- upvalues: BossMasteryFlags (copy)
    local n3 = 0

    for v46, v47 in p22 do
        local v48 = BossMasteryFlags.TokenBoostPercentOverrides:Get()[v46]

        if v48 == nil then
            v48 = v47
        end

        n3 += v48
    end

    return n3 / 100 + 1
end

function t7.NextMilestoneFor(p23) -- line: 460
    -- upvalues: t2 (copy), t7 (copy)
    for _, v49 in t2 do
        if p23 < t7.GetMilestoneKills(v49) then
            return v49
        end
    end

    return nil
end

function t7.ClaimableInfiniteCount(p24) -- line: 469
    -- upvalues: BossMasteryFlags (copy), t7 (copy)
    local v50 = t7.FinalMilestone()

    if not p24.ClaimedMilestoneIds[v50.Id] then
        return 0
    end

    local v51 = BossMasteryFlags.InfiniteRewardEveryKills:Get()

    return (math.max(math.max((p24.Mastery - t7.GetMilestoneKills(v50)) // v51, 0) - p24.InfiniteRewardsClaimed, 0))
end

local function bossEggIcon() -- line: 483
    -- upvalues: Mutations (copy)
    local Boss = Mutations.Get("Boss")

    if Boss == nil or Boss.EggIcon == nil then
        return "rbxassetid://121553987798547"
    end

    return Boss.EggIcon
end

local function tokenBoostPresentation(p25) -- line: 491
    -- upvalues: Currency (copy)
    return {
        Title = "Permanent Token Boost",
        HoverTitle = "BOSS TOKEN BOOST",
        Icon = assert(Currency.Directory.BossTokens.Icon, "Boss Tokens icon is missing"),
        Amount = ("+%*%%"):format(p25),
        HoverDescription = ("Earn +%*%% Boss Tokens from boss kills"):format(p25)
    }
end

local function rotationEggIcons() -- line: 504
    -- upvalues: Rift (copy), t7 (copy)
    local v54 = t7.GetRotationBannerWeights()
    local t11 = {}

    for _, v55 in Rift.Banners do
        if not ((v54[v55.Id] or 0) <= 0) then
            local v56 = Rift.GetBannerEggIcon(v55.Id)

            if v56 ~= nil then
                table.insert(t11, v56)
            end
        end
    end

    return t11
end

function t7.GetRewardPresentation(p26, _, p28) -- line: 519
    -- upvalues: Currency (copy), Mutations (copy), Rift (copy), t5 (copy), t7 (copy), rotationEggIcons (copy)
    if p26.Kind == "TokenBoost" then
        local Percent = p26.Percent

        return {
            Title = "Permanent Token Boost",
            HoverTitle = "BOSS TOKEN BOOST",
            Icon = assert(Currency.Directory.BossTokens.Icon, "Boss Tokens icon is missing"),
            Amount = ("+%*%%"):format(Percent),
            HoverDescription = ("Earn +%*%% Boss Tokens from boss kills"):format(Percent)
        }
    end

    local v57 = ("x%*"):format(p28 or 1)

    if p26.Kind == "RiftEgg" then
        local v58 = Rift.GetBannerDisplayName(p26.BannerId)
        local t13 = {}

        t13.Title = if p26.Mutated then ("Mutated %* Egg"):format(v58) else ("%* Egg"):format(v58)

        local v59 = Rift.GetBannerEggIcon(p26.BannerId)

        if not v59 then
            local Boss = Mutations.Get("Boss")

            v59 = if Boss == nil or Boss.EggIcon == nil then "rbxassetid://121553987798547" else Boss.EggIcon
        end

        t13.Icon = v59
        t13.Amount = v57
        t13.HoverTitle = string.upper(if p26.Mutated then ("MUTATED %* EGG"):format(v58) else ("%* EGG"):format(v58))
        t13.HoverDescription = if p26.Mutated then ("Awards a %* Egg with the Fractured mutation"):format(v58) else ("Awards a %* Egg"):format(v58)

        return t13
    end

    if p26.Kind == "RiftRotationEgg" then
        local v60 = rotationEggIcons()
        local t14 = {
            Title = "Random Mutated Egg",
            HoverTitle = "MUTATED EGG",
            HoverDescription = "Awards a random egg with the Fractured mutation"
        }
        local v61 = v60[1]

        if not v61 then
            local Boss = Mutations.Get("Boss")

            v61 = if Boss == nil or Boss.EggIcon == nil then "rbxassetid://121553987798547" else Boss.EggIcon
        end

        t14.Icon = v61
        t14.CycleIcons = v60
        t14.Amount = v57

        return t14
    end

    local v63 = t5[if p26.Kind == "CashBooster" then "CashBooster"
        elseif p26.Kind == "SpeedBoost" then "SpeedBoost"
        elseif p26.Kind == "TreadmillBoost" then "TreadmillBooster"
        else "MutationConsumable"]
    local t15 = {}

    if v63 then
        t15.Title = t7.GetShopDisplayName(v63)
        t15.Icon = v63.Icon
    else
        t15.Title = "Reward"

        local Boss = Mutations.Get("Boss")

        t15.Icon = if Boss == nil or Boss.EggIcon == nil then "rbxassetid://121553987798547" else Boss.EggIcon
    end

    t15.Amount = v57

    return t15
end

function t7.GetMilestonePresentation(p29, p30, p31) -- line: 574
    -- upvalues: Currency (copy), t7 (copy)
    local v64 = t7.GetMilestoneReward(p29)

    if v64.Kind ~= "TokenBoost" then
        return t7.GetRewardPresentation(v64, p30, p31)
    end

    local v65 = t7.GetTokenBoostPercent(p29)

    return {
        Title = "Permanent Token Boost",
        HoverTitle = "BOSS TOKEN BOOST",
        Icon = assert(Currency.Directory.BossTokens.Icon, "Boss Tokens icon is missing"),
        Amount = ("+%*%%"):format(v65),
        HoverDescription = ("Earn +%*%% Boss Tokens from boss kills"):format(v65)
    }
end

return table.freeze(t7)
