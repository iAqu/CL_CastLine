-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local vipGamepassName, fishLuckGamepassName, mutationLuckGamepassName, cashGamepassName = v1.vipGamepassName, v1.fishLuckGamepassName, v1.mutationLuckGamepassName, v1.cashGamepassName
local powerTrainingGamepassName, extraAquariumFishGamepassName = v1.powerTrainingGamepassName, v1.extraAquariumFishGamepassName
local exclusiveFishConfigs = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").exclusiveFishConfigs
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins")
local magmaRodSkinId, thunderchordRodSkinId = v2.magmaRodSkinId, v2.thunderchordRodSkinId
local mountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").mountFishData
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils")
local baitAuraRollRobuxPrice, baitAuraSlot2RobuxPrice, baitAuraSlot3RobuxPrice = v3.baitAuraRollRobuxPrice, v3.baitAuraSlot2RobuxPrice, v3.baitAuraSlot3RobuxPrice
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config")
local ogPrimeDeveloperProductId, premiumFishHologramDeveloperProductId, premiumFomoCharmDeveloperProductId = v4.ogPrimeDeveloperProductId, v4.premiumFishHologramDeveloperProductId, v4.premiumFomoCharmDeveloperProductId
local aquariumCrateProducts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").aquariumCrateProducts
local maxBackpackUpgradeCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils").maxBackpackUpgradeCount
local t1 = {
    AquariumCrate = "aquariumCrate",
    AquariumSkin = "aquariumSkin",
    BackpackCapacity = "backpackCapacity",
    BaitAuraSlot = "baitAuraSlot",
    Bundle = "bundle",
    Charm = "charm",
    ExclusiveFish = "exclusiveFish",
    FishingRod = "fishingRod",
    FishingRodSkin = "fishingRodSkin",
    Gamepass = "gamepass",
    HologramSkin = "hologramSkin",
    MoneyPack = "moneyPack",
    MountFish = "mountFish",
    OfflineEarningsMultiplier = "offlineEarningsMultiplier",
    PlaytimeWheelExtraSpin = "playtimeWheelExtraSpin",
    PowerBoost = "powerBoost",
    Reroll = "reroll",
    ServerLuck = "serverLuck",
    SkipAquariumUpgrade = "skipAquariumUpgrade",
    SkipRebirth = "skipRebirth",
    TimeSkip = "timeSkip",
    Title = "title",
    TrainingWeight = "trainingWeight"
}
local t2 = {
    3611900150, 3611900241, 3611900286, 3611900323, 3611900375
}
local t3 = {
    149, 224, 299, 374, 449
}

local function getBackpackUpgradeRobuxPrice(p1) -- line: 81
    -- upvalues: maxBackpackUpgradeCount (copy), t3 (copy)
    return if not (p1 < 0) and not (maxBackpackUpgradeCount <= p1) then t3[math.floor(p1 / 10) + 1] else nil
end

local t4 = {
    0,
    baitAuraSlot2RobuxPrice,
    baitAuraSlot3RobuxPrice
}
local t5 = {
    9, 59, 179, 499, 888
}
local t6 = {
    WSwordfish = 3611265063,
    CookedWhale = 3611265003
}
local t7 = {}
local v6 = #t7
local t8 = {}

local function v7(p2) -- line: 207
    return p2.productId ~= 0
end

local n1 = 0

for v8, v9 in aquariumCrateProducts do
    local _ = v8 - 1

    if v9.productId ~= 0 == true then
        n1 += 1
        t8[n1] = v9
    end
end

local v10 = table.create(#t8)

local function v11(p3) -- line: 220
    -- upvalues: t1 (copy)
    return {
        quantity = p3.quantity,
        storeProductId = p3.productId,
        storeProductType = t1.AquariumCrate
    }
end

for v12, v13 in t8 do
    local _ = v12 - 1

    v10[v12] = {
        quantity = v13.quantity,
        storeProductId = v13.productId,
        storeProductType = t1.AquariumCrate
    }
end

local v14 = #v10

table.move(v10, 1, v14, v6 + 1, t7)

local v15 = v6 + v14

t7[v15 + 1] = {
    backpackUpgradeTier = 1,
    slotsGranted = 20,
    storeProductId = 3611900150,
    storeProductType = t1.BackpackCapacity
}
t7[v15 + 2] = {
    backpackUpgradeTier = 2,
    slotsGranted = 20,
    storeProductId = 3611900241,
    storeProductType = t1.BackpackCapacity
}
t7[v15 + 3] = {
    backpackUpgradeTier = 3,
    slotsGranted = 20,
    storeProductId = 3611900286,
    storeProductType = t1.BackpackCapacity
}
t7[v15 + 4] = {
    backpackUpgradeTier = 4,
    slotsGranted = 20,
    storeProductId = 3611900323,
    storeProductType = t1.BackpackCapacity
}
t7[v15 + 5] = {
    backpackUpgradeTier = 5,
    slotsGranted = 20,
    storeProductId = 3611900375,
    storeProductType = t1.BackpackCapacity
}
t7[v15 + 6] = {
    titleId = "ogPrime",
    storeProductType = t1.Title,
    storeProductId = ogPrimeDeveloperProductId
}
t7[v15 + 7] = {
    charmId = "premiumFomo",
    storeProductType = t1.Charm,
    storeProductId = premiumFomoCharmDeveloperProductId
}
t7[v15 + 8] = {
    hologramSkinName = "PremiumCake",
    storeProductType = t1.HologramSkin,
    storeProductId = premiumFishHologramDeveloperProductId
}
t7[v15 + 9] = {
    gamepassProductId = 1883602582,
    gamepassTitle = "VIP",
    devProductId = 3611088337,
    storeProductType = t1.Gamepass,
    gamepassName = vipGamepassName
}
t7[v15 + 10] = {
    gamepassProductId = 1883500540,
    gamepassTitle = "2x Fish Luck",
    devProductId = 3611088749,
    storeProductType = t1.Gamepass,
    gamepassName = fishLuckGamepassName
}
t7[v15 + 11] = {
    gamepassProductId = 1882726559,
    gamepassTitle = "2x Mutation Luck",
    devProductId = 3611088771,
    storeProductType = t1.Gamepass,
    gamepassName = mutationLuckGamepassName
}
t7[v15 + 12] = {
    gamepassProductId = 1883674522,
    gamepassTitle = "x2 Cash",
    devProductId = 3611088391,
    storeProductType = t1.Gamepass,
    gamepassName = cashGamepassName
}
t7[v15 + 13] = {
    gamepassProductId = 1883902538,
    gamepassTitle = "x2 Power",
    devProductId = 3611088363,
    storeProductType = t1.Gamepass,
    gamepassName = powerTrainingGamepassName
}
t7[v15 + 14] = {
    gamepassProductId = 1893520389,
    gamepassTitle = "+1 Fish in Aquarium",
    devProductId = 3611088799,
    storeProductType = t1.Gamepass,
    gamepassName = extraAquariumFishGamepassName
}
t7[v15 + 15] = {
    tier = 1,
    storeProductId = 3611087294,
    storeProductType = t1.ServerLuck
}
t7[v15 + 16] = {
    tier = 2,
    storeProductId = 3611087397,
    storeProductType = t1.ServerLuck
}
t7[v15 + 17] = {
    storeProductId = 3604936492,
    storeProductType = t1.OfflineEarningsMultiplier
}

local t9 = {}
local v16 = #t9

for v17, v18 in mountFishData do
    v16 += 1
    t9[v16] = { v17, v18 }
end

local v19 = table.create(#t9)

local function v20(p4) -- line: 343
    -- upvalues: t1 (copy), t6 (copy)
    local v21 = p4[1]
    local v22 = p4[2]

    return {
        giftOnlyProductId = t6[v21],
        storeProductType = t1.MountFish,
        mountFishName = v21,
        storeProductId = v22.productId
    }
end

for v23, v24 in t9 do
    local _ = v23 - 1
    local v25 = v24[1]
    local v26 = v24[2]

    v19[v23] = {
        giftOnlyProductId = t6[v25],
        storeProductType = t1.MountFish,
        mountFishName = v25,
        storeProductId = v26.productId
    }
end

local v27 = #v19

table.move(v19, 1, v27, v15 + 18, t7)

local v28 = v15 + v27
local v29 = table.create(#exclusiveFishConfigs)

local function v30(p5) -- line: 362
    -- upvalues: t1 (copy)
    local t10 = {
        storeProductType = t1.ExclusiveFish,
        fishName = p5.fishName
    }
    local productId = p5.productId

    t10.storeProductId = if productId == nil then 0 else productId

    return t10
end

for v31, v32 in exclusiveFishConfigs do
    local _ = v31 - 1
    local t11 = {
        storeProductType = t1.ExclusiveFish,
        fishName = v32.fishName
    }
    local productId = v32.productId

    t11.storeProductId = if productId == nil then 0 else productId
    v29[v31] = t11
end

local v33 = #v29

table.move(v29, 1, v33, v28 + 18, t7)

local v34 = v28 + v33

t7[v34 + 18] = {
    bundleName = "StarterPack",
    bundleTitle = "Starter Pack",
    storeProductId = 3605342526,
    storeProductType = t1.Bundle
}
t7[v34 + 19] = {
    bundleName = "BossAutokill",
    bundleTitle = "Auto-Kill Boss Fish",
    giftOnlyProductId = 3612017517,
    storeProductId = 3612017485,
    storeProductType = t1.Bundle
}
t7[v34 + 20] = {
    giftOnlyProductId = 3611265495,
    skinName = "Volcanic",
    storeProductId = 3606489756,
    storeProductType = t1.AquariumSkin
}
t7[v34 + 21] = {
    weightId = "PufferfishBarbell",
    storeProductId = 3605426341,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 22] = {
    weightId = "AnchorBarbell",
    storeProductId = 3605426371,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 23] = {
    weightId = "ShipwreckBarbell",
    storeProductId = 3605426442,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 24] = {
    weightId = "CardsBarbell",
    storeProductId = 3605426466,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 25] = {
    weightId = "KrakenBarbell",
    storeProductId = 3605426746,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 26] = {
    weightId = "PoseidonBarbell",
    storeProductId = 3605426807,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 27] = {
    weightId = "DiamondBarbell",
    storeProductId = 3605426869,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 28] = {
    weightId = "BlackholeBarbell",
    storeProductId = 3605426899,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 29] = {
    weightId = "JudgementBarbell",
    storeProductId = 3605426914,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 30] = {
    weightId = "PrimalBarbell",
    storeProductId = 3606652013,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 31] = {
    weightId = "UwuBarbell",
    storeProductId = 3611410880,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 32] = {
    weightId = "ScifiBarbell",
    storeProductId = 3711099798,
    storeProductType = t1.TrainingWeight
}
t7[v34 + 33] = {
    rodId = "BambooRod",
    storeProductId = 0,
    storeProductType = t1.FishingRod
}
t7[v34 + 34] = {
    rodId = "GoldRod",
    storeProductId = 3605425111,
    storeProductType = t1.FishingRod
}
t7[v34 + 35] = {
    rodId = "AnchorRod",
    storeProductId = 3605425149,
    storeProductType = t1.FishingRod
}
t7[v34 + 36] = {
    rodId = "BassRod",
    storeProductId = 3605425634,
    storeProductType = t1.FishingRod
}
t7[v34 + 37] = {
    rodId = "TridentRod",
    storeProductId = 3605425668,
    storeProductType = t1.FishingRod
}
t7[v34 + 38] = {
    rodId = "BloodthornRod",
    storeProductId = 3605425709,
    storeProductType = t1.FishingRod
}
t7[v34 + 39] = {
    rodId = "LavaCrystalRod",
    storeProductId = 3605425749,
    storeProductType = t1.FishingRod
}
t7[v34 + 40] = {
    rodId = "AngelRod",
    storeProductId = 3605425769,
    storeProductType = t1.FishingRod
}
t7[v34 + 41] = {
    rodId = "CosmicRod",
    storeProductId = 3605425793,
    storeProductType = t1.FishingRod
}
t7[v34 + 42] = {
    rodId = "ExcaliburRod",
    storeProductId = 3605425816,
    storeProductType = t1.FishingRod
}
t7[v34 + 43] = {
    rodId = "PrimalRod",
    storeProductId = 3606651887,
    storeProductType = t1.FishingRod
}
t7[v34 + 44] = {
    rodId = "UwuRod",
    storeProductId = 3611410930,
    storeProductType = t1.FishingRod
}
t7[v34 + 45] = {
    rodId = "SaberRod",
    storeProductId = 3711099671,
    storeProductType = t1.FishingRod
}
t7[v34 + 46] = {
    storeProductId = 3708828617,
    storeProductType = t1.FishingRodSkin,
    skinId = magmaRodSkinId
}
t7[v34 + 47] = {
    storeProductId = 3708828726,
    storeProductType = t1.FishingRodSkin,
    skinId = thunderchordRodSkinId
}
t7[v34 + 48] = {
    spinCount = 1,
    storeProductId = 3605428399,
    storeProductType = t1.PlaytimeWheelExtraSpin
}
t7[v34 + 49] = {
    spinCount = 5,
    storeProductId = 3605428428,
    storeProductType = t1.PlaytimeWheelExtraSpin
}
t7[v34 + 50] = {
    storeProductId = 3606318315,
    level = 1,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 51] = {
    storeProductId = 3606318406,
    level = 2,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 52] = {
    storeProductId = 3606318462,
    level = 3,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 53] = {
    storeProductId = 3606318491,
    level = 4,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 54] = {
    storeProductId = 3606318509,
    level = 5,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 55] = {
    storeProductId = 3606318569,
    level = 6,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 56] = {
    storeProductId = 3606318581,
    level = 7,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 57] = {
    storeProductId = 3606319663,
    level = 8,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 58] = {
    storeProductId = 3606710265,
    level = 9,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 59] = {
    storeProductId = 3611420382,
    level = 10,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 60] = {
    storeProductId = 3711115621,
    level = 11,
    storeProductType = t1.SkipRebirth
}
t7[v34 + 61] = {
    storeProductId = 3606300104,
    tier = 1,
    storeProductType = t1.SkipAquariumUpgrade
}
t7[v34 + 62] = {
    storeProductId = 3606300137,
    tier = 2,
    storeProductType = t1.SkipAquariumUpgrade
}
t7[v34 + 63] = {
    storeProductId = 3606300159,
    tier = 3,
    storeProductType = t1.SkipAquariumUpgrade
}
t7[v34 + 64] = {
    storeProductId = 3606300209,
    tier = 4,
    storeProductType = t1.SkipAquariumUpgrade
}
t7[v34 + 65] = {
    storeProductId = 3606496171,
    bonusMultiplier = 1,
    storeProductType = t1.PowerBoost
}
t7[v34 + 66] = {
    storeProductId = 3606496209,
    bonusMultiplier = 2,
    storeProductType = t1.PowerBoost
}
t7[v34 + 67] = {
    storeProductId = 3606496236,
    bonusMultiplier = 3,
    storeProductType = t1.PowerBoost
}
t7[v34 + 68] = {
    storeProductId = 3606496269,
    bonusMultiplier = 4,
    storeProductType = t1.PowerBoost
}
t7[v34 + 69] = {
    storeProductId = 3606496306,
    bonusMultiplier = 5,
    storeProductType = t1.PowerBoost
}
t7[v34 + 70] = {
    giftOnlyProductId = 3611265349,
    storeProductId = 3607628963,
    rerolls = 1,
    storeProductType = t1.Reroll
}
t7[v34 + 71] = {
    giftOnlyProductId = 3611265373,
    storeProductId = 3607629488,
    rerolls = 5,
    storeProductType = t1.Reroll
}
t7[v34 + 72] = {
    giftOnlyProductId = 3611265395,
    storeProductId = 3607629697,
    rerolls = 10,
    storeProductType = t1.Reroll
}
t7[v34 + 73] = {
    storeProductId = 3607711687,
    slotIndex = 1,
    storeProductType = t1.BaitAuraSlot
}
t7[v34 + 74] = {
    storeProductId = 3607711715,
    slotIndex = 2,
    storeProductType = t1.BaitAuraSlot
}
t7[v34 + 75] = {
    giftOnlyProductId = 3611265468,
    storeProductId = 3605367452,
    cashAmount = 40000,
    storeProductType = t1.MoneyPack
}
t7[v34 + 76] = {
    giftOnlyProductId = 3611265442,
    storeProductId = 3605367488,
    cashAmount = 220000,
    storeProductType = t1.MoneyPack
}
t7[v34 + 77] = {
    giftOnlyProductId = 3611265422,
    storeProductId = 3605367512,
    cashAmount = 445000,
    storeProductType = t1.MoneyPack
}
t7[v34 + 78] = {
    storeProductId = 3605367827,
    seconds = 300,
    storeProductType = t1.TimeSkip
}
t7[v34 + 79] = {
    storeProductId = 3605367866,
    seconds = 1800,
    storeProductType = t1.TimeSkip
}

local function getStoreGamepassConfigurations() -- line: 703
    -- upvalues: t1 (copy), t7 (copy)
    local t12 = {}

    local function v35(p6) -- line: 706
        -- upvalues: t1 (copy)
        return p6.storeProductType == t1.Gamepass
    end

    local n2 = 0

    for v36, v37 in t7 do
        local _ = v36 - 1

        if v37.storeProductType == t1.Gamepass == true then
            n2 += 1
            t12[n2] = v37
        end
    end

    return t12
end

local function getServerLuckProductIdForTier(p7) -- line: 725
    -- upvalues: t1 (copy), t7 (copy)
    local v38

    for v39, v40 in t7 do
        local _ = v39 - 1

        if (v40.storeProductType == t1.ServerLuck and v40.tier == p7) == true then
            v38 = v40
            break
        end

        v38 = nil
    end

    return if v38 and v38.storeProductId ~= 0 then v38.storeProductId else nil
end

local function getMountFishStoreProductId(p8) -- line: 750
    -- upvalues: t1 (copy), t7 (copy)
    local v41

    for v42, v43 in t7 do
        local _ = v42 - 1

        if (v43.storeProductType == t1.MountFish and v43.mountFishName == p8) == true then
            v41 = v43
            break
        end

        v41 = nil
    end

    return if v41 and v41.storeProductId ~= 0 then v41.storeProductId else nil
end

local function getProductConfigurationByProductId(p9) -- line: 769
    -- upvalues: t1 (copy), t7 (copy)
    if p9 <= 0 then
        return {
            kind = "error",
            reason = "Product id must be positive"
        }
    end

    local function v44(p10) -- line: 777
        -- upvalues: p9 (copy), t1 (copy)
        if p10.storeProductType == t1.Gamepass then
            if p10.gamepassProductId == p9 then
                return true
            end

            return p10.devProductId == p9
        end

        if p10.storeProductType == t1.ServerLuck then
            return p10.storeProductId == p9
        end

        if p10.storeProductType == t1.Bundle
            or p10.storeProductType == t1.AquariumSkin
            or p10.storeProductType == t1.MoneyPack
            or p10.storeProductType == t1.MountFish
            or p10.storeProductType == t1.Reroll
            or p10.storeProductType == t1.BaitAuraSlot then
            if p10.storeProductId == p9 then
                return true
            end

            return p10.giftOnlyProductId == p9
        end

        if p10.storeProductType == t1.BackpackCapacity then
            if p10.storeProductId == 0 then
                return false
            end

            return p10.storeProductId == p9
        end

        if p10.storeProductType == t1.ExclusiveFish then
            return p10.storeProductId == p9
        end

        if p10.storeProductType == t1.TimeSkip then
            if p10.storeProductId == p9 then
                return true
            end

            return p10.giftOnlyProductId == p9
        end

        if p10.storeProductType == t1.Title or p10.storeProductType == t1.Charm or p10.storeProductType == t1.HologramSkin then
            if p10.storeProductId == 0 then
                return false
            end

            return p10.storeProductId == p9
        end

        if p10.storeProductType == t1.OfflineEarningsMultiplier or p10.storeProductType == t1.AquariumCrate then
            return p10.storeProductId == p9
        end

        if p10.storeProductType == t1.FishingRod
            or p10.storeProductType == t1.FishingRodSkin
            or p10.storeProductType == t1.TrainingWeight
            or p10.storeProductType == t1.PlaytimeWheelExtraSpin
            or p10.storeProductType == t1.PowerBoost
            or p10.storeProductType == t1.SkipRebirth then
            if p10.storeProductId == p9 then
                return true
            end

            return p10.giftOnlyProductId == p9
        end

        if p10.storeProductType ~= t1.SkipAquariumUpgrade then
            return false
        end

        if p10.storeProductId == p9 then
            return true
        end

        return p10.giftOnlyProductId == p9
    end

    local v45

    for v46, v47 in t7 do
        if v44(v47, v46 - 1, t7) == true then
            v45 = v47
            break
        end
    end

    if v45 then
        return {
            kind = "success",
            data = v45
        }
    end

    return {
        kind = "error",
        reason = ("Unknown product id: %*"):format(p9)
    }
end

local t13 = {
    3605343777, 3608909353, 3611323012
}

local function isNonCatalogStoreProductId(p11) -- line: 880
    -- upvalues: aquariumCrateProducts (copy), t13 (copy)
    local v48 = table.find(t13, p11) ~= nil

    if not v48 then
        v48 = false

        for v49, v50 in aquariumCrateProducts do
            local _ = v49 - 1

            if v50.productId > 0 and v50.productId == p11 then
                v48 = true
                break
            end

            v48 = false
        end
    end

    return v48
end

local function getAllStorePriceTargets() -- line: 906
    -- upvalues: t1 (copy), t7 (copy), t13 (copy)
    local t14 = {}
    local t15 = {}

    for _, v51 in t7 do
        if v51.storeProductType == t1.Gamepass then
            local gamepassProductId = v51.gamepassProductId
            local GamePass = Enum.InfoType.GamePass

            if gamepassProductId ~= 0 then
                local v52 = ("%*:%*"):format(GamePass.Name, gamepassProductId)

                if t15[v52] == nil then
                    t15[v52] = true
                    table.insert(t14, {
                        id = gamepassProductId,
                        infoType = GamePass
                    })
                end
            end
        else
            local storeProductId = v51.storeProductId
            local Product = Enum.InfoType.Product

            if storeProductId ~= 0 then
                local v53 = ("%*:%*"):format(Product.Name, storeProductId)

                if t15[v53] == nil then
                    t15[v53] = true
                    table.insert(t14, {
                        id = storeProductId,
                        infoType = Product
                    })
                end
            end
        end
    end

    for _, v54 in t13 do
        local Product = Enum.InfoType.Product

        if v54 ~= 0 then
            local v55 = ("%*:%*"):format(Product.Name, v54)

            if t15[v55] == nil then
                t15[v55] = true
                table.insert(t14, {
                    id = v54,
                    infoType = Product
                })
            end
        end
    end

    return t14
end

local function getTrainingWeightProductId(p12) -- line: 936
    -- upvalues: t1 (copy), t7 (copy)
    local v56

    for v57, v58 in t7 do
        local _ = v57 - 1

        if (v58.storeProductType == t1.TrainingWeight and v58.weightId == p12) == true then
            v56 = v58
            break
        end

        v56 = nil
    end

    return if v56 and v56.storeProductId ~= 0 then v56.storeProductId else nil
end

local function getPlaytimeWheelExtraSpinProductId(p13) -- line: 955
    -- upvalues: t1 (copy), t7 (copy)
    local v59

    for v60, v61 in t7 do
        local _ = v60 - 1

        if (v61.storeProductType == t1.PlaytimeWheelExtraSpin and v61.spinCount == p13) == true then
            v59 = v61
            break
        end

        v59 = nil
    end

    return if v59 and v59.storeProductId ~= 0 then v59.storeProductId else nil
end

local function getSkipRebirthProductId(p14) -- line: 974
    -- upvalues: t1 (copy), t7 (copy)
    local v62

    for v63, v64 in t7 do
        local _ = v63 - 1

        if (v64.storeProductType == t1.SkipRebirth and v64.level == p14) == true then
            v62 = v64
            break
        end

        v62 = nil
    end

    return if v62 and v62.storeProductId ~= 0 then v62.storeProductId else nil
end

local t19 = {
    99, 129, 159, 189, 219, 249, 299, 349,
    399, 499, 549
}

local function getRebirthSkipRobuxPrice(p15) -- line: 995
    -- upvalues: t19 (copy)
    return t19[p15]
end

local function getSkipAquariumUpgradeProductId(p16) -- line: 998
    -- upvalues: t1 (copy), t7 (copy)
    local v65

    for v66, v67 in t7 do
        local _ = v66 - 1

        if (v67.storeProductType == t1.SkipAquariumUpgrade and v67.tier == p16) == true then
            v65 = v67
            break
        end

        v65 = nil
    end

    return if v65 and v65.storeProductId ~= 0 then v65.storeProductId else nil
end

local function getFishingRodProductId(p17) -- line: 1017
    -- upvalues: t1 (copy), t7 (copy)
    local v68

    for v69, v70 in t7 do
        local _ = v69 - 1

        if (v70.storeProductType == t1.FishingRod and v70.rodId == p17) == true then
            v68 = v70
            break
        end

        v68 = nil
    end

    return if v68 and v68.storeProductId ~= 0 then v68.storeProductId else nil
end

local function getFishingRodSkinProductId(p18) -- line: 1036
    -- upvalues: t1 (copy), t7 (copy)
    local v71

    for v72, v73 in t7 do
        local _ = v72 - 1

        if (v73.storeProductType == t1.FishingRodSkin and v73.skinId == p18) == true then
            v71 = v73
            break
        end

        v71 = nil
    end

    return if v71 and v71.storeProductId ~= 0 then v71.storeProductId else nil
end

local function getPowerBoostProductIds() -- line: 1055
    -- upvalues: t1 (copy), t7 (copy)
    local t20 = {}

    local function v74(p19) -- line: 1058
        -- upvalues: t1 (copy)
        return p19.storeProductType == t1.PowerBoost
    end

    local n3 = 0

    for v75, v76 in t7 do
        local _ = v75 - 1

        if v76.storeProductType == t1.PowerBoost == true then
            n3 += 1
            t20[n3] = v76
        end
    end

    local v77 = table.create(#t20)

    local function v78(p20) -- line: 1071
        return {
            bonusMultiplier = p20.bonusMultiplier,
            productId = p20.storeProductId
        }
    end

    for v79, v80 in t20 do
        local _ = v79 - 1

        v77[v79] = {
            bonusMultiplier = v80.bonusMultiplier,
            productId = v80.storeProductId
        }
    end

    return v77
end

local function getTimeSkipConfigs() -- line: 1083
    -- upvalues: t1 (copy), t7 (copy)
    local t21 = {}

    local function v81(p21) -- line: 1086
        -- upvalues: t1 (copy)
        return p21.storeProductType == t1.TimeSkip
    end

    local n4 = 0

    for v82, v83 in t7 do
        local _ = v82 - 1

        if v83.storeProductType == t1.TimeSkip == true then
            n4 += 1
            t21[n4] = v83
        end
    end

    return t21
end

local function getMoneyPackConfigs() -- line: 1099
    -- upvalues: t1 (copy), t7 (copy)
    local t22 = {}

    local function v84(p22) -- line: 1102
        -- upvalues: t1 (copy)
        return p22.storeProductType == t1.MoneyPack
    end

    local n5 = 0

    for v85, v86 in t7 do
        local _ = v85 - 1

        if v86.storeProductType == t1.MoneyPack == true then
            n5 += 1
            t22[n5] = v86
        end
    end

    return t22
end

local function getRerollProductId(p23) -- line: 1115
    local v87 = if p23 == nil then 1 else p23
    local v88 = if v87 == 10 then 3607629697 elseif v87 == 5 then 3607629488 else 3607628963

    return if v88 ~= 0 then v88 else nil
end

local function getBaitAuraSlotProductId(p24) -- line: 1122
    if p24 == 1 then
        return 3607711687
    end

    return if p24 == 2 then 3607711715 else nil
end

local function getBackpackUpgradeProductId(p25) -- line: 1132
    -- upvalues: maxBackpackUpgradeCount (copy), t2 (copy)
    if p25 < 0 or maxBackpackUpgradeCount <= p25 then
        return nil
    end

    local v91 = t2[math.floor(p25 / 10) + 1]

    return if v91 ~= 0 then v91 else nil
end

local t23 = {
    [t1.AquariumCrate] = true,
    [t1.ServerLuck] = true,
    [t1.BackpackCapacity] = true
}

local function isProductTypeGiftable(p26) -- line: 1146
    -- upvalues: t23 (copy)
    return t23[p26] == nil
end

local function getPurchasePromptProductId(p27, p28) -- line: 1160
    -- upvalues: t1 (copy)
    if p27.storeProductType == t1.Gamepass then
        if p28 then
            return p27.devProductId
        end

        return p27.gamepassProductId
    end

    local v92 = p28 and p27.giftOnlyProductId ~= nil

    if v92 then
        local giftOnlyProductId = p27.giftOnlyProductId

        if giftOnlyProductId == nil then
            giftOnlyProductId = 0
        end

        v92 = giftOnlyProductId ~= 0
    end

    if v92 then
        return p27.giftOnlyProductId
    end

    return p27.storeProductId
end

local function isGiftOnlyProductId(p29, p30) -- line: 1184
    -- upvalues: t1 (copy)
    if p29.storeProductType == t1.Gamepass then
        return p29.devProductId == p30
    end

    return p29.giftOnlyProductId ~= nil and p29.giftOnlyProductId == p30
end

local v93

local function isPurchaseIdReimbursement(p31) -- line: 1191
    -- upvalues: v93 (ref)
    return string.match(p31, v93) ~= nil
end

v93 = "reimbursement"

return {
    getBackpackUpgradeRobuxPrice = getBackpackUpgradeRobuxPrice,
    getStoreGamepassConfigurations = getStoreGamepassConfigurations,
    getServerLuckProductIdForTier = getServerLuckProductIdForTier,
    getMountFishStoreProductId = getMountFishStoreProductId,
    getProductConfigurationByProductId = getProductConfigurationByProductId,
    isNonCatalogStoreProductId = isNonCatalogStoreProductId,
    getAllStorePriceTargets = getAllStorePriceTargets,
    getTrainingWeightProductId = getTrainingWeightProductId,
    getPlaytimeWheelExtraSpinProductId = getPlaytimeWheelExtraSpinProductId,
    getSkipRebirthProductId = getSkipRebirthProductId,
    getRebirthSkipRobuxPrice = getRebirthSkipRobuxPrice,
    getSkipAquariumUpgradeProductId = getSkipAquariumUpgradeProductId,
    getFishingRodProductId = getFishingRodProductId,
    getFishingRodSkinProductId = getFishingRodSkinProductId,
    getPowerBoostProductIds = getPowerBoostProductIds,
    getTimeSkipConfigs = getTimeSkipConfigs,
    getMoneyPackConfigs = getMoneyPackConfigs,
    getRerollProductId = getRerollProductId,
    getBaitAuraSlotProductId = getBaitAuraSlotProductId,
    getBackpackUpgradeProductId = getBackpackUpgradeProductId,
    isProductTypeGiftable = isProductTypeGiftable,
    getPurchasePromptProductId = getPurchasePromptProductId,
    isGiftOnlyProductId = isGiftOnlyProductId,
    isPurchaseIdReimbursement = isPurchaseIdReimbursement,
    isPendingPurchaseConfirmedFailed = function(p32) -- isPendingPurchaseConfirmedFailed | line: 1215
        -- upvalues: Workspace (copy)
        return Workspace:GetServerTimeNow() - p32 > 90
    end,
    robuxIconPrefix = "",
    StoreProductType = t1,
    vipGamepassProductId = 1883602582,
    vipDevProductId = 3611088337,
    fishLuckGamepassProductId = 1883500540,
    fishLuckDevProductId = 3611088749,
    mutationLuckGamepassProductId = 1882726559,
    mutationLuckDevProductId = 3611088771,
    cashGamepassProductId = 1883674522,
    cashDevProductId = 3611088391,
    powerTrainingGamepassProductId = 1883902538,
    powerTrainingDevProductId = 3611088363,
    extraAquariumFishGamepassProductId = 1893520389,
    extraAquariumFishDevProductId = 3611088799,
    extraAquariumFishGamepassPrice = 79,
    backpackCapacity149ProductId = 3611900150,
    backpackCapacity224ProductId = 3611900241,
    backpackCapacity299ProductId = 3611900286,
    backpackCapacity374ProductId = 3611900323,
    backpackCapacity449ProductId = 3611900375,
    backpackCapacityProductIds = t2,
    backpackCapacityRobuxPrices = t3,
    serverLuck2xProductId = 3611087294,
    serverLuck4xProductId = 3611087397,
    offlineEarningsMultiplierProductId = 3604936492,
    instantCaptureProductId = 3605343777,
    instantCaptureFrostwyrmProductId = 3608909353,
    instantCaptureUncThuluProductId = 3611323012,
    starterPackProductId = 3605342526,
    pufferfishBarbellProductId = 3605426341,
    anchorBarbellProductId = 3605426371,
    shipwreckBarbellProductId = 3605426442,
    cardsBarbellProductId = 3605426466,
    krakenBarbellProductId = 3605426746,
    poseidonBarbellProductId = 3605426807,
    diamondBarbellProductId = 3605426869,
    blackholeBarbellProductId = 3605426899,
    judgementBarbellProductId = 3605426914,
    primalBarbellProductId = 3606652013,
    uwuBarbellProductId = 3611410880,
    scifiBarbellProductId = 3711099798,
    bambooRodProductId = 0,
    goldRodProductId = 3605425111,
    anchorRodProductId = 3605425149,
    bassRodProductId = 3605425634,
    tridentRodProductId = 3605425668,
    bloodthornRodProductId = 3605425709,
    lavaCrystalRodProductId = 3605425749,
    angelRodProductId = 3605425769,
    cosmicRodProductId = 3605425793,
    excaliburRodProductId = 3605425816,
    primalRodProductId = 3606651887,
    uwuRodProductId = 3611410930,
    saberRodProductId = 3711099671,
    magmaRodSkinProductId = 3708828617,
    thunderchordRodSkinProductId = 3708828726,
    playtimeWheelOneSpinProductId = 3605428399,
    playtimeWheelFiveSpinsProductId = 3605428428,
    skipRebirth1ProductId = 3606318315,
    skipRebirth2ProductId = 3606318406,
    skipRebirth3ProductId = 3606318462,
    skipRebirth4ProductId = 3606318491,
    skipRebirth5ProductId = 3606318509,
    skipRebirth6ProductId = 3606318569,
    skipRebirth7ProductId = 3606318581,
    skipRebirth8ProductId = 3606319663,
    skipRebirth9ProductId = 3606710265,
    skipRebirth10ProductId = 3611420382,
    skipRebirth11ProductId = 3711115621,
    skipAquariumUpgradeTier1ProductId = 3606300104,
    skipAquariumUpgradeTier2ProductId = 3606300137,
    skipAquariumUpgradeTier3ProductId = 3606300159,
    skipAquariumUpgradeTier4ProductId = 3606300209,
    powerBoost100ProductId = 3606496171,
    powerBoost200ProductId = 3606496209,
    powerBoost300ProductId = 3606496236,
    powerBoost400ProductId = 3606496269,
    powerBoost500ProductId = 3606496306,
    rerollProductId = 3607628963,
    reroll5ProductId = 3607629488,
    reroll10ProductId = 3607629697,
    rerollGiftOnlyProductId = 3611265349,
    reroll5GiftOnlyProductId = 3611265373,
    reroll10GiftOnlyProductId = 3611265395,
    rerollRobuxPrice = baitAuraRollRobuxPrice,
    baitAuraSlot2ProductId = 3607711687,
    baitAuraSlot3ProductId = 3607711715,
    baitAuraSlotRobuxPrices = t4,
    powerBoostPrices = t5,
    moneyPack40kProductId = 3605367452,
    moneyPack220kProductId = 3605367488,
    moneyPack445kProductId = 3605367512,
    moneyPack40kGiftOnlyProductId = 3611265468,
    moneyPack220kGiftOnlyProductId = 3611265442,
    moneyPack445kGiftOnlyProductId = 3611265422,
    timeSkip5MinProductId = 3605367827,
    timeSkip30MinProductId = 3605367866,
    starterPackBundleName = "StarterPack",
    bossAutokillBundleName = "BossAutokill",
    bossAutokillProductId = 3612017485,
    bossAutokillGiftProductId = 3612017517,
    bossAutokillPrice = 5999,
    volcanicAquariumSkinProductId = 3606489756,
    volcanicAquariumSkinGiftOnlyProductId = 3611265495,
    wSwordfishMountGiftOnlyProductId = 3611265063,
    cookedWhaleMountGiftOnlyProductId = 3611265003,
    rebirthSkipRobuxPrices = t19,
    reimbursementPurchaseIdPrefix = v93,
    purchaseFinishMaxRetries = 20,
    purchaseFinishRetryDelaySeconds = 3
}
