-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Fusion = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Fusion
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.strict(t.boolean)
local v3 = t.strict(v1)
local v4 = t.strict(t.optional(t.string))
local v5 = t.strict(t.string)
local v6 = t.strict(t.table)
local t1 = {}

local function averageOf(p1) -- line: 32
    -- upvalues: Fusion (copy), v3 (copy), v6 (copy)
    v6(p1)
    assert(#p1 == Fusion.INPUT_COUNT, (("A fuse consumes exactly %* pets"):format(Fusion.INPUT_COUNT)))

    local n1 = 0

    for _, v9 in ipairs(p1) do
        v3(v9)
        assert(v9 > 0, "Every fuse input needs a positive scale")
        n1 += v9
    end

    return n1 / Fusion.INPUT_COUNT
end

local function refusalFor(p2, p3, p4, p5) -- line: 51
    -- upvalues: Assets (copy)
    if p5 ~= nil and p2.CreatorTemporary == true ~= p5 then
        if p5 then
            return "This fuse only takes temporary creator pets"
        end

        return "Temporary creator pets cannot be fused with permanent ones"
    end

    local v11 = Assets.Directory[p2.Category]

    if v11 == nil or v11.CannotFuse == true then
        return "That pet cannot be fused"
    end

    if p2.IsFavorite == true then
        return "Favorite pets cannot be fused"
    end

    if p4 == (p2.InFuse == true) then
        return if p3 ~= nil and p2.Category ~= p3 then "All pets must be the same category" else nil
    end

    if p4 then
        return "That pet is not in this fuse machine"
    end

    return "That pet is already in a fuse machine"
end

function t1.MayEnterFuse(p6, p7, p8, p9, p10) -- line: 92
    -- upvalues: AssetItem (copy), v2 (copy), v4 (copy), v5 (copy), refusalFor (copy)
    v5(p6)
    assert(AssetItem.SerializedAssetItemData(p7))
    v4(p8)
    v2(p9)

    local v12 = refusalFor(p7, p8, p9, p10)

    return v12 == nil, v12
end

function t1.MayEnterRift(p11, p12) -- line: 109
    -- upvalues: Assets (copy), AssetItem (copy), v5 (copy)
    v5(p11)
    assert(AssetItem.SerializedAssetItemData(p12))

    if Assets.Directory[p12.Category] == nil then
        return false, "That pet cannot be offered"
    end

    if p12.IsFavorite == true then
        return false, "Favorite pets cannot be offered"
    end

    if p12.InFuse == true then
        return false, "That pet is in a fuse machine"
    end

    return true, nil
end

function t1.BandWeightBias(p13, p14, p15) -- line: 133
    -- upvalues: Fusion (copy), v3 (copy), averageOf (copy)
    v3(p14)
    v3(p15)
    assert(p14 > 0, "A scale band cannot start at or below zero")
    assert(p14 <= p15, "A scale band cannot end below where it starts")

    return (math.exp(math.log((averageOf(p13))) / 0.6931471805599453 * (math.log((p14 + p15) / 2) / 0.6931471805599453) * Fusion.BIAS_STRENGTH))
end

function t1.DrawFusedScale(p16, p17) -- line: 145
    -- upvalues: EggRecords (copy), t1 (copy), averageOf (copy)
    averageOf(p16)

    return EggRecords.DrawAssetScale(p17, function(p18, p19) -- line: 148
        -- upvalues: p16 (copy), t1 (copy)
        return t1.BandWeightBias(p16, p18, p19)
    end)
end

function t1.PriceFor(p20) -- line: 153
    -- upvalues: Fusion (copy), AssetEarnings (copy), AssetItem (copy)
    assert(AssetItem.AssetItemDataArray(p20))
    assert(#p20 == Fusion.INPUT_COUNT, (("Pricing a fuse needs exactly %* pets"):format(Fusion.INPUT_COUNT)))

    local v21 = Fusion.PRICED_MINUTES_OF_INCOME * 60
    local n2 = 0
    local n3 = 0

    for _, v22 in ipairs(p20) do
        n2 += AssetEarnings.RatePerSecond(v22) * v21
        n3 = math.max(n3, #v22.Mutations)
    end

    local v24 = if n3 == 1 then Fusion.ONE_MUTATION_SURCHARGE elseif n3 >= 2 then Fusion.MANY_MUTATION_SURCHARGE else 1

    return (math.floor(math.floor(n2) * v24))
end

return t1
