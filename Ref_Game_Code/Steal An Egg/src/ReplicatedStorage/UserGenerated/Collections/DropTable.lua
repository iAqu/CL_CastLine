-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = require(ReplicatedStorage.UserGenerated.Randoms.ISAAC).Unique()
local v2 = Asserts.Table({
    Weight = Asserts.FinitePositive,
    Value = Asserts.Any
})
local v3 = Asserts.Table({
    Weight = Asserts.FinitePositive,
    Chance = Asserts.Range(0, 1),
    Value = Asserts.Any
})
local t1 = {}

local function Search(p1, p2) -- line: 74
    local v4 = 1
    local v5 = #p1

    while v4 < v5 do
        local v6 = v4 + (v5 - v4) // 2

        if p2 < p1[v6] then
            v5 = v6
        else
            v4 = v6 + 1
        end
    end

    return v4
end

function t1.Next(p3) -- line: 88
    -- upvalues: v1 (copy), Search (copy)
    local v7 = v1:NextDouble()
    local v8 = Search(p3.Uppers, p3.TotalWeight * v7)
    local v9 = p3.Entries[v8]

    return v9.Value, v9
end

function t1.Pick(p4, p5) -- line: 100
    -- upvalues: Search (copy)
    assert(p5 >= 0 and p5 <= 1)

    local v11 = Search(p4.Uppers, p4.TotalWeight * p5)
    local v12 = p4.Entries[v11]

    return v12.Value, v12
end

local v13 = table.freeze({
    __index = table.freeze(t1)
})

local function CompareOrderedEntry(p6, p7) -- line: 113
    if p6.Weight == p7.Weight then
        return p6.Index < p7.Index
    end

    return p6.Weight < p7.Weight
end

local function new(p8) -- line: 121
    -- upvalues: Asserts (copy), v2 (copy), v13 (copy), CompareOrderedEntry (copy)
    Asserts.Array(v2)(p8)

    local v14 = #p8

    assert(v14 > 0)

    local t2 = {}

    for v16, v17 in ipairs(p8) do
        table.insert(t2, {
            Index = v16,
            Weight = v17.Weight
        })
    end

    table.sort(t2, CompareOrderedEntry)

    local v18 = table.create(v14, 0)
    local t4 = {}
    local n1 = 0

    for v19, v20 in ipairs(t2) do
        local v21 = p8[v20.Index]
        local Weight = v21.Weight

        n1 += Weight
        v18[v19] = n1
        table.insert(t4, {
            Chance = 0,
            Weight = Weight,
            Value = v21.Value
        })
    end

    table.freeze(v18)

    for _, v22 in ipairs(t4) do
        v22.Chance = v22.Weight / n1
        table.freeze(v22)
    end

    table.freeze(t4)

    local v23 = setmetatable({
        TotalWeight = n1,
        Entries = t4,
        Uppers = v18
    }, v13)

    table.freeze(v23)

    return v23
end

local function IsA(p9) -- line: 172
    -- upvalues: v13 (copy)
    if type(p9) == "table" then
        return getmetatable(p9) == v13
    end

    return false
end

local function Assert(p10) -- line: 176
    -- upvalues: v13 (copy)
    if type(p10) ~= "table" then
        error("table", 2)
    end

    if getmetatable(p10) ~= v13 then
        error("DropTable", 2)
    end

    return p10
end

local t7 = {}

function t7.Add(p11, p12, p13) -- line: 209
    -- upvalues: Asserts (copy)
    Asserts.FinitePositive(p12)
    p11.AssertValue(p13)
    table.insert(p11.Entries, {
        Weight = p12,
        Value = p13
    })

    return p11
end

function t7.Build(p14) -- line: 219
    -- upvalues: new (copy)
    return (new(p14.Entries))
end

local v24 = table.freeze({
    __index = table.freeze(t7)
})

local function Builder(p15) -- line: 225
    -- upvalues: Asserts (copy), v24 (copy)
    Asserts.Function(p15)

    local v25 = setmetatable({
        AssertValue = p15,
        Entries = {}
    }, v24)

    table.freeze(v25)

    return v25
end

local function IsABuilder(p16) -- line: 236
    -- upvalues: v24 (copy)
    if type(p16) == "table" then
        return getmetatable(p16) == v24
    end

    return false
end

local t10 = {
    new = new,
    IsA = IsA,
    Assert = Assert,
    AssertEntry = v3,
    Builder = Builder,
    IsABuilder = IsABuilder,
    AssertBuilder = function(p17) -- AssertBuilder | line: 240
        -- upvalues: v24 (copy)
        if type(p17) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p17) ~= v24 then
            error("table", 2)
        end

        return p17
    end,
    AssertBuilderEntry = v2
}

return table.freeze(t10)
