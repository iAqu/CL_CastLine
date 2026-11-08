-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function hash(p1, p2, p3) -- line: 45
    return (bit32.band(p1, 262143) * 262144 + bit32.band(p3, 262143)) * 131072 + bit32.band(p2, 131071)
end

local function quantize(p4, p5) -- line: 49
    return p4.X // p5, p4.Y // p5, p4.Z // p5
end

local function key(p6, p7) -- line: 53
    local v1 = p6.X // p7
    local v2 = p6.Y // p7
    local v3 = p6.Z // p7

    return (bit32.band(v1, 262143) * 262144 + bit32.band(v3, 262143)) * 131072 + bit32.band(v2, 131071)
end

local t1 = {}
local v4 = table.freeze({
    __index = t1
})

function t1.Insert(p8, p9, p10) -- line: 63
    assert(typeof(p9) == "Vector3")

    local Epsilon = p8.Epsilon
    local v6 = p9.X // Epsilon
    local v7 = p9.Y // Epsilon
    local v8 = p9.Z // Epsilon
    local v9 = (bit32.band(v6, 262143) * 262144 + bit32.band(v8, 262143)) * 131072 + bit32.band(v7, 131071)
    local t2 = {
        Pos = p9,
        Value = p10
    }
    local Table = p8.Table

    if not Table[v9] then
        Table[v9] = {}
    end

    table.insert(Table[v9], t2)
end

function t1.Remove(p11, p12, p13) -- line: 75
    assert(typeof(p12) == "Vector3")

    local Epsilon = p11.Epsilon
    local v12 = p12.X // Epsilon
    local v13 = p12.Y // Epsilon
    local v14 = p12.Z // Epsilon
    local v15 = (bit32.band(v12, 262143) * 262144 + bit32.band(v14, 262143)) * 131072 + bit32.band(v13, 131071)
    local v16 = p11.Table[v15]

    if not v16 then
        return
    end

    for i = #v16, 1, -1 do
        if v16[i].Value == p13 then
            table.remove(v16, i)
        end
    end

    if #v16 == 0 then
        p11.Table[v15] = nil
    end
end

function t1.Collect(p14, p15, p16) -- line: 94
    assert(typeof(p15) == "Vector3")
    assert(p16 == nil or type(p16) == "number" and p16 > 0 and math.floor(p16) == p16)

    local Epsilon = p14.Epsilon
    local v19 = p15.X // Epsilon
    local v20 = p15.Y // Epsilon
    local v21 = p15.Z // Epsilon
    local Table = p14.Table

    p16 = p16 or 1

    local t3 = {}
    local v23 = -p16
    local n1 = 0

    for i = v23, p16 do
        for j = -p16, p16 do
            for k = -p16, p16 do
                local v24 = v19 + i
                local v25 = v20 + j
                local v26 = v21 + k
                local v27 = Table[(bit32.band(v24, 262143) * 262144 + bit32.band(v26, 262143)) * 131072 + bit32.band(v25, 131071)]

                if v27 then
                    local v28 = n1

                    for _, v29 in ipairs(v27) do
                        v28 += 1
                        n1 = v28
                        t3[v28] = v29.Value
                    end
                end
            end
        end
    end

    t3.n = n1

    return t3
end

function t1.Query(p17, p18, p19) -- line: 122
    assert(typeof(p18) == "Vector3")
    assert(p19 == nil or type(p19) == "number" and p19 > 0 and math.floor(p19) == p19)

    local Epsilon = p17.Epsilon
    local v32 = p18.X // Epsilon
    local v33 = p18.Y // Epsilon
    local v34 = p18.Z // Epsilon
    local Table = p17.Table

    p19 = p19 or 1

    local v36 = -p19
    local Value, v37

    for i = v36, p19 do
        for j = -p19, p19 do
            for k = -p19, p19 do
                local v38 = v32 + i
                local v39 = v33 + j
                local v40 = v34 + k
                local v41 = Table[(bit32.band(v38, 262143) * 262144 + bit32.band(v40, 262143)) * 131072 + bit32.band(v39, 131071)]

                if v41 then
                    for _, v43 in ipairs(v41) do
                        local Magnitude = (v43.Pos - p18).Magnitude

                        if not v37 or Magnitude < v37 then
                            v37 = Magnitude
                            Value = v43.Value
                        end
                    end
                end
            end
        end
    end

    return Value
end

table.freeze(t1)

local t4 = {
    new = function(p20, _) -- new | line: 156
        -- upvalues: v4 (copy)
        assert(p20 == nil or type(p20) == "number" and p20 > 0)

        return (setmetatable({
            Table = {},
            Epsilon = p20 or 10
        }, v4))
    end
}

return table.freeze(t4)
