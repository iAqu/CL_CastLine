-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GamepassBenefits = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GamepassBenefits
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gamepasses = require(ReplicatedStorage.Data.Gamepasses)

require(ReplicatedStorage.Shared.Types.Monetization)

local Marketplace = require(ReplicatedStorage.Shared.Utils.Marketplace)
local Products = require(ReplicatedStorage.Data.Products)
local Price = Marketplace.Price
local t = require(ReplicatedStorage.Packages.t)
local X2Money, X2Growth, Lucky = Gamepasses.Directory.X2Money, Gamepasses.Directory.X2Growth, Gamepasses.Directory.Lucky
local v1 = table.freeze({
    [X2Money.Name] = true
})
local v2 = table.freeze({
    [Lucky.Name] = true
})
local v3 = table.freeze({
    [X2Money.Name] = true,
    [Lucky.Name] = true
})
local v4 = t.strict(t.number)
local v5 = t.strict(t.instanceIsA("Player"))
local v6 = t.strict(t.string)
local t1 = {
    PROFILES = table.freeze({
        NON_SPENDER = "NonSpender",
        AVATAR_VALUE_ONLY = "AvatarValueOnly",
        SPENT_ROBUX = "SpentRobux"
    })
}

local function wholeRobux(p1) -- line: 52
    if typeof(p1) ~= "number" then
        return 0
    end

    return (math.max(math.floor(p1), 0))
end

local function countedAttribute(p2, p3) -- line: 56
    -- upvalues: v5 (copy)
    v5(p2)

    local Attribute = p2:GetAttribute(p3)

    if typeof(Attribute) ~= "number" then
        Attribute = nil
    end

    if typeof(Attribute) ~= "number" then
        return 0
    end

    return (math.max(math.floor(Attribute), 0))
end

local function switchedAttribute(p4, p5) -- line: 64
    -- upvalues: v5 (copy), v6 (copy)
    v5(p4)
    v6(p5)

    return p4:GetAttribute(p5) == true
end

local function passHeld(p6, p7) -- line: 71
    if typeof(p6) == "table" then
        return p6[p7] == true
    end

    return false
end

local function productHeld(p8, p9) -- line: 75
    if typeof(p8) == "table" then
        return p8[tostring(p9)] == true
    end

    return false
end

function t1.NormalizeRobuxSpend(p10) -- line: 79
    if typeof(p10) ~= "number" then
        return 0
    end

    return (math.max(math.floor(p10), 0))
end

function t1.ProductPrice(p11) -- line: 83
    -- upvalues: Price (copy), v4 (copy)
    v4(p11)

    local v10 = Price(p11, Enum.InfoType.Product)

    if v10 == nil or typeof(v10) ~= "number" then
        return 0
    end

    return (math.max(math.floor(v10), 0))
end

function t1.GamepassPrice(p12) -- line: 91
    -- upvalues: Price (copy), v4 (copy)
    v4(p12)

    local v12 = Price(p12, Enum.InfoType.GamePass)

    if v12 == nil or typeof(v12) ~= "number" then
        return 0
    end

    return (math.max(math.floor(v12), 0))
end

function t1.MarketplacePrice(p13, p14) -- line: 99
    -- upvalues: Marketplace (copy), v4 (copy)
    v4(p13)

    local v14 = Marketplace.Current(p13, p14)

    if typeof(v14) ~= "table" then
        return 0
    end

    local PriceInRobux = v14.PriceInRobux

    if typeof(PriceInRobux) ~= "number" then
        return 0
    end

    return (math.max(math.floor(PriceInRobux), 0))
end

function t1.AvatarAssetPrice(p15) -- line: 107
    -- upvalues: t1 (copy)
    return t1.MarketplacePrice(p15, Enum.InfoType.Asset)
end

function t1.AvatarBundlePrice(p16) -- line: 111
    -- upvalues: t1 (copy)
    return t1.MarketplacePrice(p16, Enum.InfoType.Bundle)
end

function t1.HasX2Money(p17) -- line: 115
    -- upvalues: X2Money (copy)
    local Name = X2Money.Name

    if typeof(p17) == "table" then
        return p17[Name] == true
    end

    return false
end

function t1.HasX2Growth(p18) -- line: 119
    -- upvalues: X2Growth (copy)
    local Name = X2Growth.Name

    if typeof(p18) == "table" then
        return p18[Name] == true
    end

    return false
end

function t1.HasLucky(p19) -- line: 123
    -- upvalues: Lucky (copy)
    local Name = Lucky.Name

    if typeof(p19) == "table" then
        return p19[Name] == true
    end

    return false
end

function t1.HasVipProduct(_) -- line: 129
    return false
end

function t1.PlayerHasX2Money(p21) -- line: 133
    -- upvalues: v5 (copy), v6 (copy)
    v5(p21)
    v6("MonetizationX2MoneyGamepassOwned")

    return p21:GetAttribute("MonetizationX2MoneyGamepassOwned") == true
end

function t1.PlayerHasLucky(p22) -- line: 137
    -- upvalues: v5 (copy), v6 (copy)
    v5(p22)
    v6("MonetizationLuckyGamepassOwned")

    return p22:GetAttribute("MonetizationLuckyGamepassOwned") == true
end

function t1.PlayerHasVipProduct(_) -- line: 141
    return false
end

function t1.SumOwnedRobuxSpend(p24, p25, p26) -- line: 145
    -- upvalues: Gamepasses (copy), Products (copy), t1 (copy)
    local n1 = 0

    if typeof(p24) == "table" then
        for _, v16 in pairs(Gamepasses.Directory) do
            if not (p26 and p26[("Pass:%*"):format(v16.Name)]) then
                local Name = v16.Name

                n1 += if typeof(p24) == "table" and p24[Name] == true then t1.GamepassPrice(v16.ProductId) else 0
            end
        end
    end

    if typeof(p25) == "table" then
        for _, v18 in pairs(Products.Directory) do
            if not (p26 and p26[("Product:%*"):format(v18.ProductId)]) then
                local ProductId = v18.ProductId

                n1 += if typeof(p25) == "table" and p25[tostring(ProductId)] == true then t1.ProductPrice(v18.ProductId) else 0
            end
        end
    end

    return n1
end

function t1.EffectiveRobuxSpend(p27, p28, p29, p30) -- line: 179
    -- upvalues: t1 (copy)
    local v19 = if typeof(p29) == "number" then math.max(math.floor(p29), 0) else 0

    if v19 > 0 then
        return v19
    end

    return (t1.SumOwnedRobuxSpend(p27, p28, p30))
end

function t1.IsSpender(p31) -- line: 192
    return (if typeof(p31) == "number" then math.max(math.floor(p31), 0) else 0) > 0
end

function t1.PlayerRobuxSpend(p32) -- line: 196
    -- upvalues: v5 (copy)
    v5(p32)

    local MonetizationRobuxSpentTotal = p32:GetAttribute("MonetizationRobuxSpentTotal")

    if typeof(MonetizationRobuxSpentTotal) ~= "number" then
        MonetizationRobuxSpentTotal = nil
    end

    if typeof(MonetizationRobuxSpentTotal) ~= "number" then
        return 0
    end

    return (math.max(math.floor(MonetizationRobuxSpentTotal), 0))
end

function t1.IsPlayerSpender(p33) -- line: 200
    -- upvalues: t1 (copy)
    return t1.PlayerRobuxSpend(p33) > 0
end

function t1.PlayerAvatarValue(p34) -- line: 204
    -- upvalues: v5 (copy)
    v5(p34)

    local MonetizationAvatarMarketplaceValue = p34:GetAttribute("MonetizationAvatarMarketplaceValue")

    if typeof(MonetizationAvatarMarketplaceValue) ~= "number" then
        MonetizationAvatarMarketplaceValue = nil
    end

    if typeof(MonetizationAvatarMarketplaceValue) ~= "number" then
        return 0
    end

    return (math.max(math.floor(MonetizationAvatarMarketplaceValue), 0))
end

function t1.PlayerHasAvatarValue(p35) -- line: 208
    -- upvalues: t1 (copy)
    return t1.PlayerAvatarValue(p35) > 0
end

function t1.SyncPlayerFlags(p36, p37, p38, p39, p40) -- line: 212
    -- upvalues: X2Money (copy), Lucky (copy), v5 (copy), t1 (copy)
    v5(p36)

    local Name = X2Money.Name

    p36:SetAttribute("MonetizationX2MoneyGamepassOwned", typeof(p37) == "table" and p37[Name] == true)

    local Name2 = Lucky.Name

    p36:SetAttribute("MonetizationLuckyGamepassOwned", typeof(p37) == "table" and p37[Name2] == true)
    p36:SetAttribute("MonetizationRobuxSpentTotal", t1.EffectiveRobuxSpend(p37, p38, p39, p40))
end

function t1.SyncPlayerAvatarValue(p41, p42) -- line: 229
    -- upvalues: v5 (copy)
    v5(p41)
    p41:SetAttribute("MonetizationAvatarMarketplaceValue", if typeof(p42) == "number" then math.max(math.floor(p42), 0) else 0)
end

function t1.ProfileFor(p43, p44) -- line: 235
    -- upvalues: t1 (copy)
    local PROFILES = t1.PROFILES

    if (if typeof(p44) == "number" then math.max(math.floor(p44), 0) else 0) > 0 then
        return PROFILES.SPENT_ROBUX
    end

    if (if typeof(p43) == "number" then math.max(math.floor(p43), 0) else 0) > 0 then
        return PROFILES.AVATAR_VALUE_ONLY
    end

    return PROFILES.NON_SPENDER
end

function t1.PlayerProfile(p45) -- line: 244
    -- upvalues: v5 (copy), t1 (copy)
    v5(p45)

    local v32 = t1.PlayerAvatarValue(p45)

    return t1.ProfileFor(v32, t1.PlayerRobuxSpend(p45))
end

function t1.PlayerMayTakeBackSteal(p46) -- line: 252
    -- upvalues: t1 (copy)
    return t1.PlayerProfile(p46) ~= t1.PROFILES.NON_SPENDER
end

function t1.AssetMoneyAdditiveBonus(p47, _) -- line: 256
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.HasX2Money(p47) then
        return GamepassBenefits.X2_MONEY_BONUS
    end

    return 0
end

function t1.PlayerAssetMoneyAdditiveBonus(p49) -- line: 260
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.PlayerHasX2Money(p49) then
        return GamepassBenefits.X2_MONEY_BONUS
    end

    return 0
end

function t1.GameplayBlockLuckPercent(p50) -- line: 264
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.HasLucky(p50) then
        return GamepassBenefits.LUCKY_BLOCK_LUCK_PERCENT
    end

    return 0
end

function t1.PlayerGameplayBlockLuckPercent(p51) -- line: 268
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.PlayerHasLucky(p51) then
        return GamepassBenefits.LUCKY_BLOCK_LUCK_PERCENT
    end

    return 0
end

function t1.FuseRarestWeightMultiplier(p52) -- line: 272
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.HasLucky(p52) then
        return GamepassBenefits.LUCKY_FUSE_WEIGHT_BOOST
    end

    return 1
end

function t1.PlayerFuseRarestWeightMultiplier(p53) -- line: 276
    -- upvalues: GamepassBenefits (copy), t1 (copy)
    if t1.PlayerHasLucky(p53) then
        return GamepassBenefits.LUCKY_FUSE_WEIGHT_BOOST
    end

    return 1
end

function t1.OwnedGamepassesForPlayer(p54) -- line: 280
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v5 (copy), t1 (copy)
    v5(p54)

    local v33 = t1.PlayerHasX2Money(p54)
    local v34 = t1.PlayerHasLucky(p54)

    if v33 and v34 then
        return v3
    end

    if v33 then
        return v1
    end

    return if v34 then v2 else nil
end

function t1.OwnedProductsForPlayer(p55) -- line: 293
    -- upvalues: v5 (copy)
    v5(p55)

    return nil
end

return t1
