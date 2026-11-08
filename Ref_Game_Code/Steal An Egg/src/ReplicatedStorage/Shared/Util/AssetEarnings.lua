-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Earnings = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Earnings
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local MonetizationEntitlements = require(ReplicatedStorage.Shared.Util.MonetizationEntitlements)

require(ReplicatedStorage.Shared.Types.Monetization)

local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local PlayerEarningsBoost = require(ReplicatedStorage.Shared.Util.PlayerEarningsBoost)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.strict(v1)
local t1 = {}

local function scalePayoutFactor(p1) -- line: 32
    -- upvalues: Earnings (copy), v2 (copy)
    v2(p1)
    assert(p1 > 0, "Payout factor is undefined for a non-positive asset scale")

    if p1 <= Earnings.TAPER_KNEE_SCALE then
        return p1 ^ Earnings.STEEP_SCALE_POWER
    end

    return Earnings.TAPER_KNEE_SCALE ^ Earnings.STEEP_SCALE_POWER * (p1 / Earnings.TAPER_KNEE_SCALE) ^ Earnings.TAPERED_SCALE_POWER
end

local function catalogEarningRate(p2) -- line: 45
    -- upvalues: Assets (copy)
    local v4 = Assets.Directory[p2.Category]

    if not v4 then
        return 0
    end

    return tonumber(v4.EarningRate) or 0
end

local function entitledRate(p3, p4, p5) -- line: 51
    -- upvalues: Earnings (copy), Assets (copy), AssetItem (copy), MonetizationEntitlements (copy), Mutations (copy), v2 (copy)
    assert(AssetItem.AssetItemData(p3))

    local v5 = Assets.Directory[p3.Category]
    local v6 = v5 and tonumber(v5.EarningRate) or 0
    local Scale = p3.Scale

    v2(Scale)
    assert(Scale > 0, "Payout factor is undefined for a non-positive asset scale")

    local v8 = v6 * (if Scale <= Earnings.TAPER_KNEE_SCALE then Scale ^ Earnings.STEEP_SCALE_POWER else Earnings.TAPER_KNEE_SCALE ^ Earnings.STEEP_SCALE_POWER * (Scale / Earnings.TAPER_KNEE_SCALE) ^ Earnings.TAPERED_SCALE_POWER)
    local v9 = Mutations.EarningsFor(p3.Mutations)
    local v10 = 1 + MonetizationEntitlements.AssetMoneyAdditiveBonus(p4, p5)

    return (math.max(math.round(v8 * v9 * v10), Earnings.MINIMUM_RATE))
end

function t1.RatePerSecond(p6, p7, p8) -- line: 69
    -- upvalues: AssetItem (copy), entitledRate (copy)
    assert(AssetItem.AssetItemData(p6))

    return (entitledRate(p6, p7, p8))
end

function t1.LiveRatePerSecond(p9, p10, p11, p12) -- line: 80
    -- upvalues: AdminBoosts (copy), PlayerEarningsBoost (copy), entitledRate (copy)
    return (math.round(entitledRate(p9, p10, p11) * AdminBoosts.ReadMultiplier(AdminBoosts.EARNINGS) * PlayerEarningsBoost.GetMultiplier(p12)))
end

function t1.MutationOnlyRatePerSecond(p13) -- line: 95
    -- upvalues: AssetItem (copy), entitledRate (copy)
    assert(AssetItem.AssetItemData(p13))

    return (entitledRate(p13))
end

function t1.CatalogRatePerSecond(p14) -- line: 101
    -- upvalues: Earnings (copy), Assets (copy), AssetItem (copy), v2 (copy)
    assert(AssetItem.AssetItemData(p14))

    local v14 = Assets.Directory[p14.Category]
    local v15 = v14 and tonumber(v14.EarningRate) or 0
    local Scale = p14.Scale

    v2(Scale)
    assert(Scale > 0, "Payout factor is undefined for a non-positive asset scale")

    return v15 * (if Scale <= Earnings.TAPER_KNEE_SCALE then Scale ^ Earnings.STEEP_SCALE_POWER else Earnings.TAPER_KNEE_SCALE ^ Earnings.STEEP_SCALE_POWER * (Scale / Earnings.TAPER_KNEE_SCALE) ^ Earnings.TAPERED_SCALE_POWER)
end

return t1
