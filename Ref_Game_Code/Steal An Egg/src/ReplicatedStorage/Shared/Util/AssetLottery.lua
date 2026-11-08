-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lottery = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Lottery
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)
local Assets = require(ReplicatedStorage.Data.Assets)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Log = require(ReplicatedStorage.Packages.Log)
local DrawWeighted, RollWeighted = require(ReplicatedStorage.Shared.Utils.Numeric).DrawWeighted, require(ReplicatedStorage.Shared.Utils.Numeric).RollWeighted
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local AssetRollScaleWeights = require(script.Parent.AssetRollScaleWeights)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.intersection(t.numberMin(0), t.numberMaxExclusive(1e999))
local NO_MUTATION = Mutations.NO_MUTATION
local v3 = Random.new()
local v4 = Random.new()
local v5 = t.strict(v1)
local v6 = t.strict(v2)
local v7 = t.strict(t.number)
local v8 = t.strict(t.table)
local t1 = {}
local Warning = Log.new():LimitUnderLevel("Warning")
local t2 = {}
local t3 = {}
local v9 = {}
local v10 = ""

local function refreshRollTables() -- line: 54
    -- upvalues: Assets (copy), Mutations (copy), Rarity (copy), AssetRollScaleWeights (copy), t2 (copy), t3 (copy), v9 (ref), v10 (ref)
    table.clear(t2)

    for _, v11 in ipairs(AssetRollScaleWeights) do
        table.insert(t2, {
            {
                v11.low,
                v11.high
            },
            v11.weight
        })
    end

    table.clear(t3)
    v10 = ""

    for v12, v13 in pairs(Assets.Directory) do
        if v10 == "" then
            v10 = v12
        end

        local DropWeight = v13.DropWeight

        if DropWeight > 0 and not v13.DontRoll and v13.Rarity ~= Rarity.Rarities.Eternal then
            table.insert(t3, {
                v12,
                DropWeight
            })
        end
    end

    assert(#t3 > 0, "Asset catalog yielded nothing rollable")
    v9 = Mutations.RollTable()
end

refreshRollTables()
require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 86
    -- upvalues: refreshRollTables (copy)
    task.defer(refreshRollTables)
end)

local v15 = Mutations.All()

local function shiftedTowardsFlat(p1, p2) -- line: 94
    -- upvalues: Lottery (copy), TableUtil (copy), Warning (copy)
    if p2 <= 0 then
        return TableUtil.Copy(p1, true)
    end

    local v16 = p2 / 100
    local v17 = v16 / (v16 + 1) * Lottery.SHIFT_DAMPING
    local n1 = 1e999
    local n2 = 0

    for _, v18 in ipairs(p1) do
        local v19 = v18[2]

        if v19 < n1 then
            n1 = v19
        end

        n2 += v19
    end

    local t6 = {}
    local n3 = 0

    for _, v20 in ipairs(p1) do
        local v21 = v20[2]
        local v22 = v21 - (v21 - n1) * v17

        table.insert(t6, {
            v20[1],
            v22
        })
        n3 += v22
    end

    local v23 = if n3 == 0 then 1 else n2 / n3

    for _, v24 in ipairs(t6) do
        v24[2] *= v23
    end

    Warning:AtTrace():Log((("weight shift luck=%* pull=%* norm=%*"):format(p2, v17, v23)))

    return t6
end

local function amplifyMutations(p3, p4) -- line: 138
    -- upvalues: NO_MUTATION (copy)
    local t8 = {}

    for _, v25 in ipairs(p3) do
        local v26 = v25[1]
        local v27 = v25[2]

        if v26 ~= NO_MUTATION then
            v27 *= p4
        end

        table.insert(t8, {
            v26,
            v27
        })
    end

    return t8
end

local function entriesAtRarity(p5, p6) -- line: 152
    -- upvalues: Assets (copy)
    local v28 = Assets.ByRarity[p6]

    assert(v28 ~= nil, (("%*: no assets indexed under rarity %*"):format(p5, p6)))

    local t10 = {}

    for v31, v32 in pairs(v28) do
        local DropWeight = v32.DropWeight

        if typeof(DropWeight) == "number" and DropWeight > 0 then
            table.insert(t10, {
                v31,
                DropWeight
            })
        end
    end

    assert(#t10 > 0, (("%*: rarity %* has no asset with a drop weight"):format(p5, p6)))

    return t10
end

local function usableWeight(p7) -- line: 174
    if typeof(p7) ~= "number" then
        return false
    end

    if p7 > 0 and p7 == p7 then
        return p7 ~= 1e999
    end

    return false
end

local function tokenOf(p8) -- line: 182
    if typeof(p8[1]) == "string" then
        return p8[1]
    end

    return ""
end

local function rarestFirst(p9) -- line: 188
    local t12 = {}

    for _, v36 in ipairs(p9) do
        table.insert(t12, v36)
    end

    table.sort(t12, function(p10, p11) -- line: 195
        local v37 = p10[2]
        local v38 = typeof(v37) == "number" and v37 > 0 and v37 == v37 and v37 ~= 1e999
        local v39 = p11[2]

        if v38 ~= (typeof(v39) == "number" and v39 > 0 and v39 == v39 and v39 ~= 1e999) then
            return v38
        end

        if v38 then
            local v40 = p10[2]
            local v41 = p11[2]

            if v40 ~= v41 then
                return v40 < v41
            end

            return (if typeof(p10[1]) == "string" then p10[1] else "") < (if typeof(p11[1]) == "string" then p11[1] else "")
        end

        return (if typeof(p10[1]) == "string" then p10[1] else "") < (if typeof(p11[1]) == "string" then p11[1] else "")
    end)

    return t12
end

local function usableWeightSum(p12) -- line: 220
    local n4 = 0

    for _, v48 in ipairs(p12) do
        local v49 = v48[2]

        if typeof(v49) == "number" and v49 > 0 and v49 == v49 and v49 ~= 1e999 then
            n4 += v48[2]
        end
    end

    return n4
end

local function cumulativeChance(p13, p14) -- line: 232
    -- upvalues: v5 (copy), v6 (copy)
    v5(p13)
    v6(p14)

    if p14 <= 1 then
        return p13
    end

    return 1 - (1 - p13) ^ p14
end

local function drawLuckyToken(p15, p16, p17) -- line: 243
    -- upvalues: v7 (copy), v8 (copy), rarestFirst (copy), usableWeightSum (copy)
    v8(p15)
    v7(p16)
    assert(p17 == nil or typeof(p17) == "Random", "A token draw needs a Random or nil")

    local v51 = rarestFirst(p15)
    local v52 = usableWeightSum(v51)

    if v52 <= 0 then
        return nil
    end

    local v53 = (1 - (1 - (p17 or Random.new()):NextNumber()) ^ (1 / math.max(p16, 1))) * v52
    local v54

    for _, v55 in ipairs(v51) do
        if typeof(v55[1]) == "string" then
            local v57 = v55[2]

            if typeof(v57) == "number" and v57 > 0 and v57 == v57 and v57 ~= 1e999 then
                v54 = v55[1]
                v53 -= v55[2]

                if v53 <= 0 then
                    return v54
                end
            end
        end
    end

    return v54
end

local function bandCeiling(p18) -- line: 282
    local v58 = p18[1]

    if typeof(v58) == "table" then
        v58 = v58[#v58]
    end

    return if typeof(v58) == "number" then v58 else nil
end

function t1.RollCountFor(p19, p20) -- line: 294
    return (math.max(math.max(1 + (if typeof(p19) == "number" then p19 else 0) / 100, 0) + ((if typeof(p20) == "number" then math.max(p20, 1) else 1) - 1), 1))
end

function t1.TokenChances(p21, p22) -- line: 304
    -- upvalues: v5 (copy), v6 (copy), v7 (copy), v8 (copy), rarestFirst (copy), usableWeightSum (copy)
    v8(p21)
    v7(p22)

    local v61 = rarestFirst(p21)
    local v62 = usableWeightSum(v61)

    if v62 <= 0 then
        return {}
    end

    local v63 = math.max(p22, 1)
    local t13 = {}
    local n5 = 0

    for _, v64 in ipairs(v61) do
        if typeof(v64[1]) == "string" then
            local v66 = v64[2]

            if typeof(v66) == "number" and v66 > 0 and v66 == v66 and v66 ~= 1e999 then
                local v67 = v64[1]
                local v68 = n5 / v62

                n5 += v64[2]

                local v69 = n5 / v62

                v5(v69)
                v6(v63)

                if not (v63 <= 1) then
                    v69 = 1 - (1 - v69) ^ v63
                end

                v5(v68)
                v6(v63)

                if not (v63 <= 1) then
                    v68 = 1 - (1 - v68) ^ v63
                end

                local v70 = v69 - v68

                if v70 > 0 then
                    t13[v67] = (t13[v67] or 0) + v70
                end
            end
        end
    end

    return t13
end

function t1.DrawCategory(_, p24, p25) -- line: 339
    -- upvalues: v4 (copy), t1 (copy), Warning (copy), t3 (copy), v10 (ref), drawLuckyToken (copy)
    local v72 = drawLuckyToken(t3, t1.RollCountFor(p24 or 0), p25 or v4)

    if typeof(v72) == "string" and v72 ~= "" then
        return v72
    end

    Warning:AtError():Log((("category draw came back empty, substituting %*"):format(v10)))

    return v10
end

function t1.DrawCategoryForRarity(p26, p27, p28) -- line: 352
    -- upvalues: RollWeighted (copy), entriesAtRarity (copy)
    local v73 = RollWeighted(entriesAtRarity(p26, p27), p28)

    assert(typeof(v73) == "string" and v73 ~= "", (("%*: rarity %* produced no asset name"):format(p26, p27)))

    return v73
end

function t1.DrawCategoryFromRarityTable(p29, p30, p31) -- line: 367
    -- upvalues: RollWeighted (copy), t1 (copy)
    local v76 = RollWeighted(p30, p31)

    assert(typeof(v76) == "string" and v76 ~= "", (("%*: rarity table produced no rarity token"):format(p29)))

    return t1.DrawCategoryForRarity(p29, v76, p31)
end

function t1.DrawCategoryFromTable(p32, p33, p34, p35) -- line: 382
    -- upvalues: Assets (copy), RollWeighted (copy), v5 (copy), drawLuckyToken (copy)
    v5(p34)
    assert(p34 >= 1, "A category draw needs at least one roll")

    local v80 = if p34 > 1 then drawLuckyToken(p33, p34, p35) else RollWeighted(p33, p35)

    assert(typeof(v80) == "string" and v80 ~= "", (("%*: drop table produced no name"):format(p32)))
    assert(Assets.AssetNameExists(v80), (("%*: drop table named %*, which is not in the catalog"):format(p32, v80)))

    return v80
end

function t1.DrawMutations(_, p37, p38, p39) -- line: 405
    -- upvalues: Lottery (copy), AdminBoosts (copy), RollWeighted (copy), NO_MUTATION (copy), v3 (copy), Warning (copy), v9 (ref), v15 (copy), shiftedTowardsFlat (copy), amplifyMutations (copy)
    p38 = p38 or v3

    local v86 = shiftedTowardsFlat(v9, p37 or 0)

    if p39 ~= nil and p39 > 1 then
        v86 = amplifyMutations(v86, p39)
    end

    Warning:AtInfo():Log((("mutation draw, follow-up odds %*"):format(Lottery.SECOND_MUTATION_ODDS)))

    local t14 = {}
    local v87 = RollWeighted(v86, p38)

    if typeof(v87) == "string" and v87 ~= NO_MUTATION then
        table.insert(t14, v87)
    end

    local v88 = Lottery.SECOND_MUTATION_ODDS * AdminBoosts.ReadMultiplier(AdminBoosts.VIDEO_LUCK)

    if #t14 > 0 and p38:NextNumber() < v88 then
        local v89 = RollWeighted(v86, p38)

        if typeof(v89) == "string" and v89 ~= NO_MUTATION and not table.find(t14, v89) then
            table.insert(t14, v89)
        end
    end

    table.sort(t14, function(p40, p41) -- line: 441
        -- upvalues: v15 (copy)
        return v15[p40].RollWeight < v15[p41].RollWeight
    end)

    return t14
end

function t1.DrawScale(_, p43, p44, p45) -- line: 451
    -- upvalues: Lottery (copy), Constants (copy), DrawWeighted (copy), AssetRollScaleWeights (copy), v3 (copy), Warning (copy), t2 (copy), shiftedTowardsFlat (copy)
    local v90 = shiftedTowardsFlat(t2, p43 or 0)
    local t15 = {}

    if p44 and p45 then
        local t16 = {}
        local t17 = {}

        for v91, v92 in ipairs(v90) do
            local v93 = v92[1]

            if typeof(v93) == "table" then
                v93 = v93[#v93]
            end

            if typeof(v93) ~= "number" then
                v93 = nil
            end

            if v93 ~= nil then
                if p44 <= v93 * p45 then
                    table.insert(t16, v92)
                    table.insert(t17, v91)
                end
            else
                local v94 = ("scale band %* has no numeric ceiling"):format(v91)

                if Constants.IS_STUDIO then
                    error(v94)
                else
                    Warning:AtWarning():Log(v94)
                end
            end
        end

        if #t16 == 0 then
            return p44 / p45, #AssetRollScaleWeights
        end

        local v95 = if v3:NextInteger(1, Lottery.UPGRADE_BAND_ODDS) ~= 1 or not (#t16 > 1) then 1 else 2
        local v96 = if v95 == 1 then 1 else #t16

        v90 = {}

        for i = v95, v96 do
            table.insert(v90, t16[i])
            table.insert(t15, t17[i])
        end
    end

    local v99 = DrawWeighted(v90)
    local Value, v100

    if v99 then
        Value = v99.Value
        v100 = v99.Index
    else
        v100 = 0
    end

    if Value then
        local v101

        if typeof(Value) == "table" then
            if not p44 or not p45 then
                v101 = Value[1]

                local v102 = Value[2]

                if v102 ~= nil then
                    v101 = v3:NextNumber(v101, v102)
                end
            else
                local v103 = Value[#Value]

                v101 = if v103 * p45 <= p44 then p44 / p45 else v3:NextNumber(p44 / p45, v103)
            end
        else
            v101 = Value
        end

        local v104 = if t15 then t15[v100] else nil

        if t15 and v104 then
            v100 = v104
        end

        if typeof(v101) ~= "number" then
            v101 = 1
        end

        return v101, v100
    end

    Warning:AtError():Log("scale draw came back empty, substituting 1x")

    return 1, 1
end

return t1
