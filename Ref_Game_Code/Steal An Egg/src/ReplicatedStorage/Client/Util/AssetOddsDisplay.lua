-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.strict(t.table)
local v3 = t.strict(v1)
local t1 = {}

local function skeletonFor(p1) -- line: 33
    if p1 < 1000 then
        return "."
    end

    local v5 = p1 / 1000 ^ math.floor(math.log10(p1) / 3)

    if v5 < 10 then
        return ".##"
    end

    if v5 < 100 then
        return ".#"
    end

    return "."
end

local function compactOdds(p2) -- line: 46
    -- upvalues: Simple (copy)
    local v6 = math.max(1, p2)
    local v8 = 10 ^ (math.floor((math.log10(v6))) - 3 + 1)
    local v10 = math.floor(v6 / v8) * v8
    local lower = string.lower
    local FormatCompact = Simple.FormatCompact
    local v11

    if v10 < 1000 then
        v11 = "."
    else
        local v13 = v10 / 1000 ^ math.floor(math.log10(v10) / 3)

        v11 = if v13 < 10 then ".##" elseif v13 < 100 then ".#" else "."
    end

    return lower(FormatCompact(v10, v11))
end

function t1.Resolve(p3, p4) -- line: 54
    -- upvalues: Mutations (copy), v2 (copy)
    v2(p3)

    local VisualOdds = p3.VisualOdds

    if typeof(VisualOdds) ~= "number" or not (VisualOdds > 0) then
        local DropWeight = p3.DropWeight

        VisualOdds = if typeof(DropWeight) == "number" and DropWeight > 0 then 1 / DropWeight else nil
    end

    if VisualOdds == nil or p4 == nil then
        return VisualOdds
    end

    return VisualOdds * Mutations.RarityFactorFor(p4.Mutations, p4.BaseMutation)
end

function t1.Describe(p5, p6, p7) -- line: 75
    -- upvalues: Simple (copy), v2 (copy), t1 (copy)
    v2(p5)

    local v14 = t1.Resolve(p5, p7)

    if v14 == nil then
        return "1/?"
    end

    local v15 = if p6 then "1 in " else "1/"
    local v16 = math.max(1, v14)
    local v18 = 10 ^ (math.floor((math.log10(v16))) - 3 + 1)
    local v20 = math.floor(v16 / v18) * v18
    local lower = string.lower
    local FormatCompact = Simple.FormatCompact
    local v21

    if v20 < 1000 then
        v21 = "."
    else
        local v23 = v20 / 1000 ^ math.floor(math.log10(v20) / 3)

        v21 = if v23 < 10 then ".##" elseif v23 < 100 then ".#" else "."
    end

    return (("%*%*"):format(v15, (lower(FormatCompact(v20, v21)))))
end

function t1.DescribeItem(p8, p9, p10) -- line: 90
    -- upvalues: AssetItem (copy), t1 (copy)
    assert(AssetItem.AssetItemData(p9))

    local t2 = {
        Mutations = p9.Mutations,
        BaseMutation = p9.BaseMutation
    }

    return t1.Describe(p8, p10, t2)
end

function t1.Compact(p11) -- line: 97
    -- upvalues: v3 (copy), compactOdds (copy)
    v3(p11)

    return compactOdds(p11)
end

return t1
