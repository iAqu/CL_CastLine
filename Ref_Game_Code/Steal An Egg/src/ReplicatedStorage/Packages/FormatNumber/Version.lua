-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function version_tostring(p1) -- line: 35
    return string.format("%d.%d", p1.Major, p1.Minor)
end

local function version_lt(p2, p3) -- line: 39
    if p2.Major == p3.Major then
        return p2.Minor < p3.Minor
    end

    return p2.Major < p3.Major
end

local function version_eq(p4, p5) -- line: 43
    if p4.Major == p5.Major then
        return p4.Minor == p5.Minor
    end

    return false
end

local function double_to_int32(p6) -- line: 47
    if math.clamp(tonumber(p6) or 0, -2147483648, 2147483647) ~= p6 then
        return UDim.new(nil, p6).Offset
    end

    if p6 <= -1 then
        return (math.ceil(p6))
    end

    if p6 >= 1 then
        return (math.floor(p6))
    end

    return 0
end

function t1.new(p7, p8) -- line: 61
    -- upvalues: version_tostring (copy), version_lt (copy), version_eq (copy)
    local v2 = newproxy(true)
    local mt = getmetatable(v2)

    mt.__index = {
        Major = if math.clamp(tonumber(p7) or 0, -2147483648, 2147483647) ~= p7 then UDim.new(nil, p7).Offset
            elseif p7 <= -1 then math.ceil(p7)
            elseif p7 >= 1 then math.floor(p7)
            else 0,
        Minor = if math.clamp(tonumber(p8) or 0, -2147483648, 2147483647) ~= p8 then UDim.new(nil, p8).Offset
            elseif p8 <= -1 then math.ceil(p8)
            elseif p8 >= 1 then math.floor(p8)
            else 0
    }
    mt.__metatable = "The metatable is locked"
    mt.__tostring = version_tostring
    mt.__lt = version_lt
    mt.__eq = version_eq
    table.freeze(mt)

    return v2
end

t1.current = t1.new(31, 1)

return table.freeze(t1)
