-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local BindableEvent = Instance.new("BindableEvent")
local t1 = {}

t1.Changed = BindableEvent.Event

local t2 = {}
local v1 = FastFlags.Replicated("Game.Balance.Enabled", function(p1) -- line: 12
    assert(type(p1) == "boolean")

    return p1
end, true)

local function copy(p2) -- line: 18
    -- upvalues: copy (copy)
    if type(p2) ~= "table" then
        return p2
    end

    local t3 = {}

    for v3, v4 in p2 do
        t3[v3] = copy(v4)
    end

    return t3
end

local function storable(p3) -- line: 32
    -- upvalues: storable (copy)
    if type(p3) ~= "table" then
        return p3
    end

    local n1 = 0
    local v5 = true

    for v6 in p3 do
        n1 += 1

        if type(v6) ~= "number" or v6 % 1 ~= 0 or v6 < 1 then
            v5 = false
        end
    end

    local v7 = v5 and n1 == #p3
    local t4 = {}

    for v8, v9 in p3 do
        t4[if v7 then v8 else tostring(v8)] = storable(v9)
    end

    return t4
end

local function validate(p4, p5, p6) -- line: 58
    -- upvalues: validate (copy)
    assert(type(p4) == type(p5), p6 .. " has the wrong type")

    if type(p5) == "number" then
        assert(p4 == p4 and math.abs(p4) < 1e999, p6 .. " must be finite")
        assert(p5 < 0 or p4 >= 0, p6 .. " must be nonnegative")
    elseif type(p5) == "table" then
        for v16, v17 in p4 do
            local v18 = p5[v16] == nil and tonumber(v16) or v16

            assert(p5[v18] ~= nil, p6 .. " has an unknown key " .. tostring(v16))
            validate(v17, p5[v18], p6 .. "." .. tostring(v16))
        end
    elseif type(p5) == "string" then
        assert(p4 == p5, p6 .. " identifies content and cannot be renamed")
    end
end

local function selectFields(p7, p8) -- line: 76
    -- upvalues: selectFields (copy)
    if p8 == true then
        if type(p7) ~= "table" then
            return p7
        end

        local t5 = {}

        for v23, v24 in p7 do
            if type(v24) == "number" or type(v24) == "table" or type(v24) == "string" then
                t5[v23] = selectFields(v24, true)
            end
        end

        return t5
    end

    local t6 = {}

    for v25, v26 in p8 do
        if p7[v25] ~= nil then
            t6[v25] = selectFields(p7[v25], v26)
        end
    end

    return t6
end

local function cloneSelected(p9, p10) -- line: 104
    -- upvalues: cloneSelected (copy)
    local v27 = table.clone(p9)

    for v28, v29 in p10 do
        if type(v29) == "table" then
            v27[v28] = cloneSelected(p9[v28], v29)
        end
    end

    return v27
end

local function apply(p11, p12, p13) -- line: 116
    -- upvalues: apply (copy)
    for v30, v31 in p12 do
        local v32 = p13[v30]

        if v32 == nil then
            v32 = p13[tostring(v30)]
        end

        if type(v31) == "table" then
            apply(p11[v30], v31, v32 or {})
        else
            if v32 == nil then
                v32 = v31
            end

            p11[v30] = v32
        end
    end
end

function t1.Bind(p14, p15, p16, p17, p18) -- line: 132
    -- upvalues: FastFlags (copy), BindableEvent (copy), t2 (copy), v1 (copy), copy (copy), storable (copy), validate (copy), selectFields (copy), cloneSelected (copy), apply (copy)
    assert(t2[p14] == nil, "Duplicate balance key " .. p14)

    local v35 = {}

    if p17 then
        for v36, v37 in p15 do
            v35[v36] = selectFields(v37, p16)
        end
    else
        v35 = selectFields(p15, p16)
    end

    local v38 = cloneSelected(p15, v35)

    local function assertion(p19) -- line: 146
        -- upvalues: p14 (copy), p18 (copy), v35 (ref), copy (copy), validate (copy), apply (copy)
        validate(p19, v35, p14)

        if p18 then
            local v39 = copy(v35)

            apply(v39, v35, p19)
            p18(v39)
        end

        return p19
    end

    local v40 = FastFlags.Replicated(p14, assertion, (storable(v35)))

    t2[p14] = v40

    local function refresh() -- line: 163
        -- upvalues: p14 (copy), v35 (ref), v38 (copy), v40 (copy), BindableEvent (copy), v1 (copy), apply (copy)
        local v41 = v35

        apply(v38, v41, if v1:Get() then v40:Get() else {})
        BindableEvent:Fire(p14)
    end

    v40.Changed:Connect(refresh)
    v1.Changed:Connect(refresh)
    refresh()

    return v38
end

return table.freeze(t1)
