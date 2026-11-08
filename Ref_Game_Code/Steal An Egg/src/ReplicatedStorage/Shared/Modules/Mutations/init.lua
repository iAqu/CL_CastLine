-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Catalog = require(script.Catalog)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local Types = require(script.Types)
local t = require(ReplicatedStorage.Packages.t)
local Visuals = require(script.Visuals)
local t1 = {}
local t2 = {}
local t3 = {}
local n1 = 0

for v2, v3 in Catalog do
    assert(v2 == v3.Id, (("Mutations | Catalog key \"%*\" does not match its Id \"%*\""):format(v2, v3.Id)))

    if Constants.IS_STUDIO then
        local v6, v7 = Types.MutationSpec(v3)

        assert(v6, (("Mutations | \"%*\" does not match the MutationSpec schema: %*"):format(v2, v7)))
    end

    t1[v2] = true
    t2[v2] = v2
    n1 += v3.RollWeight
    table.insert(t3, table.freeze({
        v2,
        v3.RollWeight
    }))
end

local v10 = math.max(0, 100 - n1)

if Constants.IS_STUDIO then
    assert(v10 > 0, (("Mutations | Roll weights total %*, which leaves no room for \"None\""):format(n1)))
end

table.insert(t3, table.freeze({
    "None",
    v10
}))
table.freeze(t1)
table.freeze(t2)
table.freeze(t3)

local t6 = {
    NO_MUTATION = "None",
    TOTAL_ROLL_WEIGHT = 100,
    IdSet = t1
}

function t6.All() -- line: 72
    -- upvalues: Catalog (copy)
    return Catalog
end

function t6.Ids() -- line: 76
    -- upvalues: t2 (copy)
    return t2
end

function t6.IsKnown(p1) -- line: 80
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.string)(p1)

    return t1[p1] == true
end

function t6.Get(p2) -- line: 87
    -- upvalues: Catalog (copy), v1 (copy)
    local v13 = Catalog[p2]

    if v13 then
        return v13
    end

    v1:AtWarning():Log((("Mutations.Get | Unknown mutation \"%*\""):format((tostring(p2)))))

    return nil
end

function t6.LabelOf(p3) -- line: 99
    -- upvalues: Catalog (copy), t (copy)
    t.strict(t.string)(p3)

    local v14 = Catalog[p3]

    if v14 then
        return v14.Label
    end

    return p3
end

function t6.RollTable() -- line: 107
    -- upvalues: Catalog (copy)
    local t7 = {}
    local n2 = 0

    for v15, v16 in Catalog do
        n2 += v16.RollWeight
        table.insert(t7, {
            v15,
            v16.RollWeight
        })
    end

    table.insert(t7, {
        "None",
        (math.max(0, 100 - n2))
    })

    return t7
end

function t6.RollChanceOf(p4) -- line: 121
    -- upvalues: Catalog (copy)
    local v18 = Catalog[p4]

    if not v18 or v18.RollWeight <= 0 then
        return 0
    end

    return v18.RollWeight / 100
end

function t6.Sanitize(p5, p6) -- line: 133
    -- upvalues: t1 (copy)
    local t10 = {}
    local t11 = {}

    local function include(p7) -- line: 137
        -- upvalues: t10 (copy), t11 (copy), t1 (copy)
        if typeof(p7) ~= "string" or t11[p7] or not t1[p7] then
            return
        end

        t11[p7] = true
        table.insert(t10, p7)
    end

    if typeof(p6) == "string" and not t11[p6] and t1[p6] then
        t11[p6] = true
        table.insert(t10, p6)
    end

    if typeof(p5) == "table" then
        for _, v19 in ipairs(p5) do
            if typeof(v19) == "string" and not t11[v19] and t1[v19] then
                t11[v19] = true
                table.insert(t10, v19)
            end
        end
    end

    return t10
end

function t6.EggModelName(p8, p9) -- line: 157
    -- upvalues: Catalog (copy), t6 (copy)
    for _, v20 in t6.Sanitize(p8, p9) do
        local v21 = Catalog[v20]

        if v21 and v21.EggModelName then
            return v21.EggModelName
        end
    end

    return nil
end

function t6.EggDisplayName(p10, p11) -- line: 169
    -- upvalues: Catalog (copy), t6 (copy)
    for _, v22 in t6.Sanitize(p10, p11) do
        local v23 = Catalog[v22]

        if v23 and v23.EggDisplayName then
            return v23.EggDisplayName
        end
    end

    return nil
end

function t6.EggIcon(p12, p13) -- line: 181
    -- upvalues: Catalog (copy), t6 (copy)
    for _, v24 in t6.Sanitize(p12, p13) do
        local v25 = Catalog[v24]

        if v25 and v25.EggIcon then
            return v25.EggIcon
        end
    end

    return nil
end

function t6.EarningsFor(p14) -- line: 194
    -- upvalues: Catalog (copy), v1 (copy)
    local n3 = 1

    for _, v26 in p14 do
        local v27 = Catalog[v26]

        if v27 then
            n3 += math.max(0, v27.EarningsScalar - 1)
        else
            v1:AtError():Log((("Mutations.EarningsFor | Unknown mutation \"%*\""):format((tostring(v26)))))
        end
    end

    return (math.max(1, n3))
end

function t6.RarityFactorFor(p15, p16) -- line: 211
    -- upvalues: t6 (copy)
    local n4 = 1

    for _, v29 in t6.Sanitize(p15, p16) do
        local v30 = t6.RollChanceOf(v29)

        if v30 > 0 then
            n4 *= 1 / v30
        end
    end

    return n4
end

function t6.ApplyTo(p17, p18, p19) -- line: 225
    -- upvalues: Catalog (copy), t (copy), Visuals (copy)
    t.strict(t.Instance)(p17)
    t.strict(t.string)(p18)
    t.strict(t.optional(t.number))(p19)

    local v33 = assert(Catalog[p18], (("Mutations.ApplyTo | Unknown mutation \"%*\""):format(p18)))
    local v34 = Visuals.GetFXPart(p17)

    if not v34 then
        return
    end

    local v35 = Visuals.ShouldApplyMetalCombo(p17, p18)
    local v36 = if p19 == nil then nil else Random.new(Visuals.SeedFor(p19, p18))

    Visuals.WithVisualRandom(v36, function() -- line: 243
        -- upvalues: p17 (copy), p19 (copy), v33 (copy), v34 (copy), v35 (copy), Visuals (copy)
        v33:Apply(p17, v34)

        if v35 then
            local v37 = assert(p19, "A Golden and Silver combination requires a visual seed")

            Visuals.ApplyMetalCombo(p17, v37)
        end
    end)
end

function t6.ClearFrom(p20, p21) -- line: 254
    -- upvalues: Catalog (copy), t (copy), Visuals (copy)
    t.strict(t.Instance)(p20)
    t.strict(t.string)(p21)

    local v40 = assert(Catalog[p21], (("Mutations.ClearFrom | Unknown mutation \"%*\""):format(p21)))
    local v41 = Visuals.GetFXPart(p20)

    if v41 then
        v40:Clear(p20, v41)
    end
end

function t6.ClearAllFrom(p22) -- line: 268
    -- upvalues: Catalog (copy), t (copy), Visuals (copy)
    t.strict(t.Instance)(p22)

    local v42 = Visuals.GetFXPart(p22)

    if v42 then
        for _, v43 in Catalog do
            task.spawn(function() -- line: 278
                -- upvalues: p22 (copy), v42 (copy), v43 (copy)
                v43:Clear(p22, v42)
            end)
        end
    end
end

return t6
