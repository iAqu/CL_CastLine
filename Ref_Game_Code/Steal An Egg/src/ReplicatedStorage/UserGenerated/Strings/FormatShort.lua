-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "k",
    "m",
    "b",
    "t",
    "q",
    "Qt",
    "Sx",
    "Sp",
    "o",
    "n",
    "d",
    "u",
    "Du",
    "Tr"
}

local function FormatAbbreviated(p1, p2, p3) -- line: 38
    -- upvalues: t1 (copy)
    assert(type(p1) == "number")
    assert(p2 == nil or type(p2) == "number")
    assert(p3 == nil or type(p3) == "number")

    if p1 ~= p1 then
        return "NaN"
    end

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 == (-1e999) then
        return "-Infinity"
    end

    p2 = p2 or 3
    p3 = p3 or 0

    local v9 = math.max(math.abs(p1), (math.pow(10, -#t1 * 3)))
    local v13 = 10 ^ (math.min(math.ceil((math.log10(v9))), #t1 * 3 + p2) - p3 - p2)
    local v15 = math.round(v9 / v13) * v13
    local v20 = math.min(math.floor(math.log10((math.max(v15, 1))) / 3), #t1)
    local v21 = v15 * math.sign(p1) / 10 ^ (v20 * 3)
    local v22 = string.format("%f", v21):gsub("%.?0+$", "")

    if v20 >= 1 then
        return v22 .. t1[v20]
    end

    return v22
end

return FormatAbbreviated
