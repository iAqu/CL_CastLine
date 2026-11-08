-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = utf8.char(8734)
local t1 = {
    b = 9,
    k = 3,
    m = 6,
    q = 15,
    t = 12
}
local t2 = {}

local function groupThousands(p1) -- line: 18
    local t3 = {}
    local v2 = #p1

    while v2 > 0 do
        local v4 = math.max(v2 - 2, 1)

        table.insert(t3, 1, (string.sub(p1, v4, v2)))
        v2 = v4 - 1
    end

    return table.concat(t3, ",")
end

function t2.AddCommas(p2) -- line: 33
    -- upvalues: v1 (copy), groupThousands (copy)
    assert(type(p2) == "number", "amount must be a number")

    if p2 ~= p2 then
        return "NaN"
    end

    local v8 = math.round((math.abs(p2)))
    local v9 = if v8 == 1e999 then v1 else groupThousands(string.format("%.0f", v8))

    if not (p2 < 0 and v8 > 0) then
        return v9
    end

    return "-" .. v9
end

function t2.Parse(p3) -- line: 49
    -- upvalues: t1 (copy)
    assert(type(p3) == "string", "text must be a string")

    local v11 = string.gsub(string.lower(p3), "[^%w%.%+%-]", "")

    for v12, v13 in t1 do
        local v14 = string.match(v11, "^(.+)" .. v12 .. "$")

        if v14 then
            local v15 = tonumber(v14)

            return if v15 then v15 * 10 ^ v13 else nil
        end
    end

    return (tonumber(v11))
end

return table.freeze(t2)
