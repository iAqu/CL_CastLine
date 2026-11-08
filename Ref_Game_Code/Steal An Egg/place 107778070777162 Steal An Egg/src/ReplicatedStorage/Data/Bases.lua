-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}
local t2 = {
    1000, 1E+06, 7.5E+07, 5E+08, 1E+09, 5E+10, 5E+11, 1E+12,
    2.5E+13, 1E+14, 5E+14, 5E+15
}

local function getBaseModelIfServer(p1) -- line: 43
    -- upvalues: ServerStorage (copy), Constants (copy), t (copy)
    t.strict(t.string)(p1)

    return if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main[p1] else nil
end

local t3 = {}
local t4 = {
    MaxAssets = 7,
    Cost = 0
}

t.strict(t.string)("1")
t4.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["1"] else nil
t3[0] = t4

local t5 = {
    MaxAssets = 7
}

t.strict(t.string)("1")
t5.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["1"] else nil
t5.Cost = t2[1]
t3[1] = t5

local t6 = {
    MaxAssets = 9
}

t.strict(t.string)("2")
t6.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["2"] else nil
t6.Cost = t2[2]
t3[2] = t6

local t7 = {
    MaxAssets = 10
}

t.strict(t.string)("3")
t7.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["3"] else nil
t7.Cost = t2[3]
t3[3] = t7

local t8 = {
    MaxAssets = 11
}

t.strict(t.string)("4")
t8.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["4"] else nil
t8.Cost = t2[4]
t3[4] = t8

local t9 = {
    MaxAssets = 12
}

t.strict(t.string)("5")
t9.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["5"] else nil
t9.Cost = t2[5]
t3[5] = t9

local t10 = {
    MaxAssets = 13
}

t.strict(t.string)("6")
t10.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["6"] else nil
t10.Cost = t2[6]
t3[6] = t10

local t11 = {
    MaxAssets = 14
}

t.strict(t.string)("7")
t11.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["7"] else nil
t11.Cost = t2[7]
t3[7] = t11

local t12 = {
    MaxAssets = 15
}

t.strict(t.string)("8")
t12.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["8"] else nil
t12.Cost = t2[8]
t3[8] = t12

local t13 = {
    MaxAssets = 16
}

t.strict(t.string)("9")
t13.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["9"] else nil
t13.Cost = t2[9]
t3[9] = t13

local t14 = {
    MaxAssets = 17
}

t.strict(t.string)("10")
t14.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["10"] else nil
t14.Cost = t2[10]
t3[10] = t14

local t15 = {
    MaxAssets = 18
}

t.strict(t.string)("11")
t15.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["11"] else nil
t15.Cost = t2[11]
t3[11] = t15

local t16 = {
    MaxAssets = 19
}

t.strict(t.string)("12")
t16.Model = if Constants.IS_SERVER then ServerStorage.Assets.Models.Bases.Main["12"] else nil
t16.Cost = t2[12]
t3[12] = t16
t1.BASES = t3
t1.SKINS = {}
t1.MIN_ASSET_EQUIP_CAPACITY = t1.BASES[0].MaxAssets
t1.MAX_ASSET_EQUIP_CAPACITY = t1.BASES[#t1.BASES].MaxAssets

function t1.GetMaxBaseLevel() -- line: 127
    -- upvalues: t1 (copy)
    local n1 = 0

    for v1 in pairs(t1.BASES) do
        if n1 < v1 then
            n1 = v1
        end
    end

    return n1
end

function t1.GetBaseConfigFor(p2, p3) -- line: 139
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.number)(p2)
    t.strict(t.optional(t.string))(p3)

    local v3 = math.max(0, (math.floor(p2)))
    local v4

    for v5 in pairs(t1.BASES) do
        if v5 <= v3 and (not v4 or v4 < v5) then
            v4 = v5
        end
    end

    if v4 and p3 then
        return t1.BASES[v4], t1.SKINS[p3]
    end

    return if v4 then t1.BASES[v4] else nil
end

function t1.GetAssetEquipCapacity(p4) -- line: 166
    -- upvalues: t1 (copy)
    local v6 = t1.GetBaseConfigFor(p4 or 0)

    return v6 and v6.MaxAssets or t1.MIN_ASSET_EQUIP_CAPACITY
end

if Constants.IS_STUDIO then
    assert(#t2 >= #t1.BASES, "Not enough costs for the number of bases")

    for v8, v9 in pairs(t1.BASES) do
        assert(v9.Cost == t2[v8] or v8 == 0 and v9.Cost == 0, (("Cost for base index %* does not match expected cost from COSTS table"):format(v8)))

        if Constants.IS_SERVER then
            local Model = v9.Model

            assert(typeof(Model) == "Instance" and Model:IsA("Model"), (("Model for base index %* is not a valid Model instance"):format(v8)))
            assert(Model.PrimaryPart and Model.PrimaryPart.Name == "CenterPoint", (("Model for base index %* must have a PrimaryPart named \"CenterPoint\""):format(v8)))

            local ToUpdate = Model:FindFirstChild("ToUpdate")
            local Model2 = ToUpdate

            if ToUpdate then
                Model2 = ToUpdate:IsA("Model")

                if Model2 then
                    Model2 = ToUpdate.PrimaryPart

                    if Model2 then
                        Model2 = ToUpdate.PrimaryPart.Name == "CenterPoint" and ToUpdate:FindFirstChild("PetArea")
                    end
                end
            end

            assert(Model2, (("Model for base index %* must have a child Model named \"ToUpdate\" with a PrimaryPart named \"CenterPoint\""):format(v8)))
        end

        assert(typeof(v9.MaxAssets) == "number" and v9.MaxAssets == t1.GetAssetEquipCapacity(v8), (("MaxAssets for base index %* must match asset equip capacity"):format(v8)))
    end
end

if Constants.IS_STUDIO and Constants.IS_SERVER then
    for v19, v20 in pairs(t1.SKINS) do
        assert(typeof(v20.FirstFloor) == "Instance" and v20.FirstFloor:IsA("Model"), (("Model for base skin index %* is not a valid Model instance"):format(v19)))
    end
end

local t17 = {}

for v23, v24 in t1.BASES do
    t17[v23] = v24.MaxAssets
end

t1.BASES = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Bases", t1.BASES, {
    Cost = true,
    MaxAssets = true
}, true, function(p5) -- line: 232
    -- upvalues: t17 (copy)
    for v25, v26 in p5 do
        assert(v26.MaxAssets % 1 == 0 and v26.MaxAssets >= 1 and v26.MaxAssets <= t17[v25])
    end
end)

local function refreshCapacityLimits() -- line: 243
    -- upvalues: t1 (copy)
    t1.MIN_ASSET_EQUIP_CAPACITY = t1.BASES[0].MaxAssets
    t1.MAX_ASSET_EQUIP_CAPACITY = t1.BASES[t1.GetMaxBaseLevel()].MaxAssets
end

t1.MIN_ASSET_EQUIP_CAPACITY = t1.BASES[0].MaxAssets
t1.MAX_ASSET_EQUIP_CAPACITY = t1.BASES[t1.GetMaxBaseLevel()].MaxAssets
require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(refreshCapacityLimits)

return t1
