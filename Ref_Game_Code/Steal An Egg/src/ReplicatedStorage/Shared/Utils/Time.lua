-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        seconds = 86400,
        symbol = "d"
    },
    {
        seconds = 3600,
        symbol = "h"
    },
    {
        seconds = 60,
        symbol = "m"
    },
    {
        seconds = 1,
        symbol = "s"
    }
}
local v1 = #t1
local v2 = utf8.char(8734)
local t2 = {}

local function wholeSeconds(p1) -- line: 18
    return if p1 == p1 and p1 ~= 1e999 then math.ceil((math.max(p1, 0))) else nil
end

local function nonFiniteText(p2) -- line: 25
    -- upvalues: v2 (copy)
    if p2 == p2 then
        return v2
    end

    return "NaN"
end

local function splitUnits(p3) -- line: 30
    -- upvalues: t1 (copy)
    local v4 = table.create(#t1)
    local v5 = p3

    for v6, v7 in t1 do
        v4[v6] = v5 // v7.seconds
        v5 %= v7.seconds
    end

    return v4
end

local function leadingUnit(p4) -- line: 41
    -- upvalues: t1 (copy), v1 (copy)
    for i = 1, v1 - 1 do
        if t1[i].seconds <= p4 then
            return i
        end
    end

    return v1
end

function t2.Timecode(p5) -- line: 54
    -- upvalues: t1 (copy), v1 (copy), v2 (copy)
    assert(type(p5) == "number", "seconds must be a number")

    local v9 = if p5 == p5 and p5 ~= 1e999 then math.ceil((math.max(p5, 0))) else nil

    if v9 == nil then
        if p5 == p5 then
            return v2
        end

        return "NaN"
    end

    local v11 = v1 - 1
    local v12 = false
    local v13

    for i = 1, v11 do
        if t1[i].seconds <= v9 then
            v13 = i
            v12 = true
            break
        end
    end

    if not v12 then
        v13 = v1
    end

    if v13 == v1 then
        return (("%*s"):format(v9))
    end

    local v14 = table.create(#t1)

    for v15, v16 in t1 do
        v14[v15] = v9 // v16.seconds
        v9 %= v16.seconds
    end

    local t3 = {
        (tostring(v14[v13]))
    }

    for i = v13 + 1, v1 do
        table.insert(t3, string.format("%02d", v14[i]))
    end

    return table.concat(t3, ":")
end

function t2.Elapsed(p6) -- line: 78
    -- upvalues: t1 (copy), v1 (copy), v2 (copy)
    assert(type(p6) == "number", "seconds must be a number")

    local v20 = if p6 == p6 and p6 ~= 1e999 then math.ceil((math.max(p6, 0))) else nil

    if v20 == nil then
        if p6 == p6 then
            return v2
        end

        return "NaN"
    end

    local v22 = table.create(#t1)
    local v23 = v20

    for v24, v25 in t1 do
        v22[v24] = v23 // v25.seconds
        v23 %= v25.seconds
    end

    local v26 = v1 - 1
    local v27 = false
    local v28

    for i = 1, v26 do
        if t1[i].seconds <= v20 then
            v28 = i
            v27 = true
            break
        end
    end

    if not v27 then
        v28 = v1
    end

    local v29 = ("%*%*"):format(v22[v28], t1[v28].symbol)
    local v30 = v28 + 1

    if v30 <= v1 and v22[v30] > 0 then
        v29 ..= (" %*%*"):format(v22[v30], t1[v30].symbol)
    end

    return v29
end

return table.freeze(t2)
