-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SellRewards = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).SellRewards
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetGender = require(ReplicatedStorage.Shared.Util.AssetGender)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local AssetPalette = require(ReplicatedStorage.Shared.Util.AssetPalette)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.string)
local t1 = {}

local function catalogEntry(p1) -- line: 31
    -- upvalues: Assets (copy)
    return Assets.Directory[p1]
end

local function isNamedMutation(p2) -- line: 35
    if typeof(p2) ~= "string" or p2 == "" then
        return false
    end

    return p2 ~= "None"
end

local function settled(p3) -- line: 45
    -- upvalues: AssetGender (copy), AssetPalette (copy)
    local t2 = {}

    for _, v2 in ipairs(p3.Mutations) do
        if typeof(v2) == "string" and v2 ~= "" and v2 ~= "None" then
            table.insert(t2, v2)
        end
    end

    local v3 = AssetPalette.SettleFields(p3.Category, p3.EyeColor, p3.ColorSeed, p3.ColorIndex)
    local v4 = if AssetGender.Settle(p3.Category, p3.Gender) == "Male" then "Male" else "Female"
    local t3 = {
        Category = p3.Category,
        Mutations = t2
    }
    local BaseMutation = p3.BaseMutation

    t3.BaseMutation = if typeof(BaseMutation) == "string" and BaseMutation ~= "" and BaseMutation ~= "None" then p3.BaseMutation else t2[1]
    t3.Scale = p3.Scale
    t3.Gender = v4
    t3.EyeColor = v3.EyeColor
    t3.ColorSeed = v3.ColorSeed
    t3.ColorIndex = v3.ColorIndex
    t3.IsFavorite = p3.IsFavorite
    t3.GeneratedMoney = p3.GeneratedMoney
    t3.LastTick = p3.LastTick
    t3.PendingEggName = p3.PendingEggName
    t3.Claimed = p3.Claimed
    t3.LuckyBlockUnlockTimestamp = p3.LuckyBlockUnlockTimestamp
    t3.LuckyBlockUnlockDuration = p3.LuckyBlockUnlockDuration
    t3.LuckyBlockInstantUnlock = p3.LuckyBlockInstantUnlock
    t3.InFuse = p3.InFuse or false
    t3.Rideable = p3.Rideable
    t3.SpecialLuckyBlockColumn = p3.SpecialLuckyBlockColumn
    t3.SpecialLuckyBlockCapturedAt = p3.SpecialLuckyBlockCapturedAt
    t3.Personality = p3.Personality
    t3.HasBeenFirstPlaced = p3.HasBeenFirstPlaced
    t3.IsStolenDNA = p3.IsStolenDNA
    t3.CreatorTemporary = p3.CreatorTemporary

    return t3
end

function t1.Encode(p4) -- line: 94
    -- upvalues: settled (copy)
    return (settled(p4))
end

function t1.Decode(p5) -- line: 98
    -- upvalues: settled (copy)
    return (settled(p5))
end

function t1.WeightKg(p6) -- line: 102
    -- upvalues: SellRewards (copy), Assets (copy), AssetItem (copy)
    assert(AssetItem.AssetItemData(p6))

    local Category = p6.Category

    return Assets.Directory[Category].ModelWeight * math.max(p6.Scale, 0) ^ SellRewards.WEIGHT_SCALE_POWER
end

function t1.WeightLabel(p7) -- line: 110
    -- upvalues: AddCommas (copy), t1 (copy)
    return (("%*Kg"):format((AddCommas((math.max(math.round(t1.WeightKg(p7) * 100) / 100, 0))))))
end

function t1.SalePrice(p8) -- line: 117
    -- upvalues: SellRewards (copy), AssetEarnings (copy), AssetItem (copy)
    assert(AssetItem.AssetItemData(p8))

    return AssetEarnings.RatePerSecond(p8) * SellRewards.SALE_SECONDS_OF_INCOME
end

function t1.IndexMoneyReward(p9) -- line: 123
    -- upvalues: SellRewards (copy), AssetEarnings (copy), Personalities (copy)
    local t4 = {
        Scale = 1,
        HasBeenFirstPlaced = true,
        Category = p9,
        Mutations = {},
        Personality = Personalities.Personalities.Normal
    }

    return (math.round(AssetEarnings.MutationOnlyRatePerSecond(t4) * SellRewards.INDEX_REWARD_SECONDS))
end

function t1.IndexSpeedReward(p10) -- line: 137
    -- upvalues: Assets (copy)
    return Assets.Directory[p10].IndexSpeedReward
end

function t1.RarityRankForCategory(p11) -- line: 142
    -- upvalues: Assets (copy), v1 (copy)
    v1(p11)

    local v8 = Assets.Directory[p11]

    assert(v8 ~= nil, (("Asset catalog has no entry named %*"):format(p11)))

    return v8.Rarity.Rank
end

function t1.ProfileIncomePerSecond(p12, p13, p14) -- line: 154
    -- upvalues: AssetEarnings (copy), settled (copy)
    local Inventory, EquippedAssets = p13.Inventory, p13.EquippedAssets

    if typeof(Inventory) ~= "table" or typeof(EquippedAssets) ~= "table" then
        return 0
    end

    local Gamepasses2 = if typeof(p13.Gamepasses) == "table" then p13.Gamepasses else nil
    local Products2 = if typeof(p13.Products) == "table" then p13.Products else nil
    local n1 = 0

    for _, v11 in ipairs(EquippedAssets) do
        local v12 = Inventory[v11]

        if typeof(v12) == "table" then
            local v13 = settled(v12)

            n1 += math.max(if p14 then AssetEarnings.RatePerSecond(v13, Gamepasses2, Products2) else AssetEarnings.LiveRatePerSecond(v13, Gamepasses2, Products2, p12), 0)
        end
    end

    return n1
end

return t1
