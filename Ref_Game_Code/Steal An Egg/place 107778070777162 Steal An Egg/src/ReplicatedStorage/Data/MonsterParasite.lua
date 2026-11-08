-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Flyswatter = require(ReplicatedStorage.Data.Gears.Configs.Flyswatter)
local MonsterParasiteFlags = require(ReplicatedStorage.Shared.Flags.MonsterParasiteFlags)
local MonsterParasite = require(ReplicatedStorage.Shared.Types.MonsterParasite)
local RewardIds = MonsterParasite.RewardIds
local t1 = {
    Snow = 29,
    Volcano = 26,
    ["Abyss Ocean"] = 18,
    Prehistoric = 15,
    Cosmic = 13,
    ["Cherry Blossom"] = 11,
    ["Titan Temple"] = 9
}
local t2 = {
    {
        Charge = 0,
        Scale = 1
    },
    {
        Charge = 20,
        Scale = 1.12
    },
    {
        Charge = 40,
        Scale = 1.25
    },
    {
        Charge = 60,
        Scale = 1.45
    },
    {
        Charge = 80,
        Scale = 1.75
    },
    {
        Charge = 100,
        Scale = 2
    }
}
local t3 = {
    "Monster1",
    "Monster2",
    "Monster3",
    "Monster4"
}
local t4 = {
    "ChestOrigin",
    "MouthCenter1",
    "Tongue3"
}
local t5 = {
    {
        Idle = 128217356432291,
        Yank = 86644195835902
    },
    {
        Idle = 99744254158313,
        Yank = 131549849408123
    },
    {
        Idle = 122218896916983,
        Yank = 140178521003505
    },
    {
        Idle = 124151642143348,
        Yank = 110901356129499,
        Burp = 94789436133823
    }
}

local function GetMonsterModelIndex(p1) -- line: 208
    if p1 >= 80 then
        return 4
    end

    if p1 >= 60 then
        return 3
    end

    if p1 >= 40 then
        return 2
    end

    return 1
end

local function buildMonstrousEggIdsList() -- line: 225
    -- upvalues: ReplicatedStorage (copy)
    local t6 = {}

    for _, v1 in require(ReplicatedStorage.Data.Areas).Directory["Titan Temple"].DropTable do
        table.insert(t6, {
            Id = v1[1],
            Weight = v1[2]
        })
    end

    assert(#t6 > 0, "Titan Temple has no drop table for the Monstrous Egg")

    return t6
end

local t8 = {
    {
        Weight = 43.5,
        DisplayName = "1.25x Egg Growth",
        DisplayNote = "5 Minutes",
        Rarity = "Common",
        Icon = "rbxassetid://84954605144740",
        Id = RewardIds.EggGrowthBoost,
        Metadata = {
            DurationSeconds = 300,
            Multiplier = 1.25
        }
    },
    {
        Weight = 30,
        DisplayName = "1.25x Speed",
        DisplayNote = "5 Minutes",
        Rarity = "Uncommon",
        Icon = "rbxassetid://78137530993637",
        Id = RewardIds.SpeedBoost,
        Metadata = {
            DurationSeconds = 300,
            Multiplier = 1.25
        }
    },
    {
        Weight = 20,
        DisplayName = "2x Treadmill Speed",
        DisplayNote = "5 Minutes",
        Rarity = "Rare",
        Id = RewardIds.TreadmillBoost,
        Metadata = {
            DurationSeconds = 300
        }
    },
    {
        Weight = 5,
        DisplayName = "Flyswatter",
        Rarity = "Epic",
        Id = RewardIds.ExclusiveWeapon,
        DuplicateRewardId = RewardIds.TreadmillBoost,
        Icon = Flyswatter.Icon,
        Metadata = {
            GearId = Flyswatter._id
        }
    },
    {
        Weight = 1.5,
        DisplayName = "PARASITE EGG",
        DisplayNote = "Guaranteed Monstrous Mutation",
        NoteIsPanelOnly = true,
        Rarity = "BEST REWARD",
        Icon = "rbxassetid://121553987798547",
        Id = RewardIds.MonsterEgg,
        Metadata = {
            MutationId = "Monstrous",
            EggIdsList = buildMonstrousEggIdsList()
        }
    }
}

local function RewardLabel(p2) -- line: 314
    if p2.DisplayNote == nil or p2.NoteIsPanelOnly then
        return p2.DisplayName
    end

    return (("%* (%*)"):format(p2.DisplayName, p2.DisplayNote))
end

local function GetReward(p3) -- line: 322
    -- upvalues: t8 (copy)
    for _, v3 in t8 do
        if v3.Id == p3 then
            return v3
        end
    end

    error(("Unknown Monster Chest reward %*"):format(p3), 2)
end

local t9 = {
    EventName = "MonsterParasite",
    EndsAt = 1788620400,
    MinimumRarityNumber = 5,
    EligibilityGuardId = "Jungle",
    SpawnChanceByArea = t1,
    ChargePerFeed = 20,
    MaxCharge = 100,
    BellyStages = t2,
    Rewards = t8,
    FeedDistance = 14,
    HudDistance = 24,
    RequestCooldown = 0.75,
    PromptHoldDuration = 0.25,
    MonsterOffset = CFrame.new(0, 0, -8),
    MarkerFolderName = "MonsterParasiteMarkers",
    MonsterSpawnMarkerName = "MonsterSpawn",
    ChestSpawnMarkerName = "MonsterChestSpawn",
    ChestSpawnCFrameAttributeName = "MonsterChestSpawnCFrame",
    AssetsFolderName = "MonsterParasite",
    ParasiteModelName = "Parasite",
    ParasiteVisualName = "MonsterParasiteVisual",
    ParasiteIdleAnimationId = 113082199990805,
    ParasiteCrownOffset = Vector2.zero,
    ParasiteScaleMultiplier = 0.45,
    MonsterModelName = "Monster",
    MonsterModelNames = t3,
    MonsterModelIndexAttributeName = "MonsterModelIndex",
    MonsterRetiringAttributeName = "MonsterRetiring",
    MonsterRetireSeconds = 0.45,
    MonsterAnimationIdsByIndex = t5,
    ChestModelName = "MonsterChest",
    ChestToolName = "Monster Chest",
    ChestToolItemType = "MonsterChest",
    ChestToolScale = 0.42,
    ChestToolGrip = CFrame.new(0, -0.15, -0.35) * CFrame.Angles(0, 1.5707963267948966, 0),
    ChestToolIcon = "rbxassetid://139693832314356",
    ChestPickupDuration = 0.6,
    ParasiteBillboardName = "MonsterParasite",
    ParasiteBillboardScale = 0.5,
    ParasiteHighlightName = "MonsterParasiteHighlight",
    ParasiteHighlightColor = Color3.fromRGB(198, 158, 255),
    ParasiteHighlightTransparency = 0.25,
    ParasiteHighlightFillTransparency = 0.7,
    HudName = "MonsterChargeUI",
    WorldFolderName = "MonsterParasiteMonsters",
    PadName = "Monster",
    MonsterDisplayName = "The Hungry Monster",
    TalkPromptName = "TalkPrompt",
    TalkPromptText = "Who are you?",
    FeedPromptName = "FeedPrompt",
    FeedPromptText = "Feed Parasite",
    ChestPromptName = "ChestPrompt",
    ChestPromptText = "Claim Monster Chest",
    DialogueText = "Parasites make me stronger. Bring me an infested egg, and I will eat the parasite without harming what is inside.",
    RewardTitle = "MONSTER CHEST REWARD",
    BellyPartName = "Belly",
    ParasiteEatTargetPartName = "ParasiteEatTarget",
    TongueTipName = "Tongue3",
    ChestOriginPartName = "ChestOrigin",
    ChestOriginNames = t4,
    GrabMarkerName = "Grab",
    BurpMarkerName = "burp_start",
    ChestOffset = CFrame.new(0, 2, -4),
    YankDuration = 0.35,
    BellyTweenDuration = 0.45,
    FullChargeHoldDuration = 0.8,
    FullChargeModelHoldDuration = 15,
    BurpBeatDuration = 0.18,
    RoarDuration = 0.55,
    ChestLaunchDelay = 0.06,
    ChestLaunchDuration = 0.78,
    ChestBounceDuration = 0.4,
    ChestLaunchHeight = 5,
    ChestBounceHeight = 1.4,
    ChestLaunchStartScale = 0.65,
    ChestLaunchSpins = 2,
    ChestLaunchBeatFallback = 2.4,
    ChestThrowDistanceMin = 12,
    ChestThrowDistanceMax = 19,
    ChestThrowSpreadDegrees = 26,
    ChestThrowStraightJitterDegrees = 5,
    ChestThrowAttempts = 5,
    ChestGroundRestDuration = 0.3,
    ChestPickupRise = 2.5,
    ChestGroundProbeHeight = 6,
    ChestGroundProbeDepth = 90,
    ChestImpactShakeMagnitude = 1.4,
    ChestImpactShakeRoughness = 9,
    ChestImpactShakeFadeIn = 0.04,
    ChestImpactShakeFadeOut = 0.5,
    ChestImpactShakeRange = 110,
    SoundFolderName = "MonsterParasite",
    YankSoundName = "Yank",
    ChompSoundName = "Chomp",
    BurpSoundName = "Burp",
    RoarSoundName = "Roar",
    EnergyBurstSoundName = "EnergyBurst",
    ChestLandingSoundName = "ChestLanding",
    ChestSoundName = "ChestOpen",
    VfxFolderName = "MonsterParasite",
    EnergyBurstVfxName = "EnergyBurst",
    SwapPoofVfxName = "SwapPoof",
    GroundHitParticlesName = "BigHitGroundAttach",
    HudRootName = "Root",
    HudBarName = "Bar",
    HudFillName = "Fill",
    HudPercentName = "Percent",
    HudStatusName = "Status",
    HudTimerName = "Timer",
    HudChargingText = "MONSTER CHARGE",
    HudReadyText = "MONSTER CHEST READY!",
    GetSpawnChance = function(p4) -- GetSpawnChance | line: 468
        -- upvalues: MonsterParasiteFlags (copy), t1 (copy)
        local v4 = MonsterParasiteFlags.SpawnChanceByArea:Get()[p4]

        if v4 == nil then
            return t1[p4] or 0
        end

        return v4
    end,
    GetBellyScale = function(p5) -- GetBellyScale | line: 477
        -- upvalues: t2 (copy)
        local Scale = t2[1].Scale

        for _, v5 in t2 do
            if p5 < v5.Charge then
                break
            end

            Scale = v5.Scale
        end

        return Scale
    end,
    GetMonsterModelIndex = GetMonsterModelIndex,
    GetReward = GetReward,
    RewardLabel = RewardLabel,
    BoostMultiplier = function(p6) -- BoostMultiplier | line: 493
        -- upvalues: MonsterParasite (copy), t8 (copy)
        local v6 = MonsterParasite.BoostRewardIds[p6]
        local v7 = false
        local v8

        for _, v9 in t8 do
            if v9.Id == v6 then
                v8 = v9
                v7 = true
                break
            end
        end

        if not v7 then
            v8 = nil
            error(("Unknown Monster Chest reward %*"):format(v6), 2)
        end

        return v8.Metadata.Multiplier or 1
    end,
    BoostDurationSeconds = function(p7) -- BoostDurationSeconds | line: 496
        -- upvalues: MonsterParasite (copy), t8 (copy)
        local v10 = MonsterParasite.BoostRewardIds[p7]
        local v11 = false
        local v12

        for _, v13 in t8 do
            if v13.Id == v10 then
                v12 = v13
                v11 = true
                break
            end
        end

        if not v11 then
            v12 = nil
            error(("Unknown Monster Chest reward %*"):format(v10), 2)
        end

        return v12.Metadata.DurationSeconds or 0
    end,
    GetRewardWeight = function(p8) -- GetRewardWeight | line: 499
        -- upvalues: MonsterParasiteFlags (copy), t8 (copy)
        local v14 = MonsterParasiteFlags.RewardWeights:Get()[p8]

        if v14 ~= nil then
            return v14
        end

        local v15 = false
        local v16

        for _, v17 in t8 do
            if v17.Id == p8 then
                v16 = v17
                v15 = true
                break
            end
        end

        if not v15 then
            v16 = nil
            error(("Unknown Monster Chest reward %*"):format(p8), 2)
        end

        return v16.Weight
    end
}
local v18 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.MonsterParasite", t9, {
    MinimumRarityNumber = true,
    ChargePerFeed = true,
    MaxCharge = true,
    FeedDistance = true,
    RequestCooldown = true,
    PromptHoldDuration = true
}, false, function(p9) -- line: 522
    assert(p9.ChargePerFeed > 0 and p9.MaxCharge > 0 and p9.FeedDistance > 0)
end)
local t10 = {}

for _, v20 in t8 do
    t10[v20.Id] = {
        DurationSeconds = v20.Metadata.DurationSeconds,
        Multiplier = v20.Metadata.Multiplier
    }
end

local v21 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.MonsterChestRewards", t10, true, false)

local function refreshRewards() -- line: 542
    -- upvalues: RewardIds (copy), buildMonstrousEggIdsList (copy), t8 (copy), v21 (copy)
    for _, v22 in t8 do
        local v23 = v21[v22.Id]

        v22.Metadata.DurationSeconds = v23.DurationSeconds
        v22.Metadata.Multiplier = v23.Multiplier

        if v23.DurationSeconds then
            v22.DisplayNote = `{ v23.DurationSeconds / 60 } Minutes`

            if v22.Id == RewardIds.EggGrowthBoost then
                v22.DisplayName = ("%*x Egg Growth"):format(v23.Multiplier)
            end

            if v22.Id == RewardIds.SpeedBoost then
                v22.DisplayName = ("%*x Speed"):format(v23.Multiplier)
            end
        end

        if v22.Id == RewardIds.MonsterEgg then
            v22.Metadata.EggIdsList = buildMonstrousEggIdsList()
        end
    end
end

refreshRewards()
require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(refreshRewards)

return v18
