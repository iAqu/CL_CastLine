-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    "\226\128\168",
    "\226\128\169",
    " ",
    " ",
    "　",
    " ",
    "\r\n",
    "\t",
    "\n",
    "\011",
    "\012",
    "\r",
    " "
}
local t2 = {
    "\226\128\168",
    "\226\128\169",
    "\r\n",
    "\r",
    "\n"
}

local function MAKE_LOOKUP(p1) -- line: 67
    local t3 = {}

    for _, v1 in ipairs(p1) do
        t3[v1] = true
    end

    return t3
end

local t4 = {}

for _, v2 in ipairs(t1) do
    t4[v2] = true
end

local t5 = {}

for _, v3 in ipairs(t2) do
    t5[v3] = true
end

local t6 = {
    ["0"] = "\000",
    ["'"] = "'",
    ["\""] = "\"",
    ["\\"] = "\\",
    b = "\008",
    f = "\012",
    n = "\n",
    r = "\r",
    t = "\t",
    v = "\011"
}

local function Q(p2) -- line: 91
    return (string.format("%q", p2):gsub("\r", "\\r"):gsub("\n", "\\n"))
end

local function formatError(p3, p4) -- line: 97
    return string.format("%s at line %d col %d", p3, p4[1], p4[2])
end

local function advanceNewline(p5, p6) -- line: 103
    -- upvalues: t5 (copy)
    if not t5[p5] then
        return false
    end

    p6[1] += 1
    p6[2] = 1

    return true
end

local function getNewline(p7, p8) -- line: 115
    -- upvalues: t2 (copy), t5 (copy)
    for _, v4 in ipairs(t2) do
        if p7:sub(1, #v4) == v4 and t5[v4] then
            p8[1] += 1
            p8[2] = 1

            return v4
        end
    end

    return nil
end

local function getWhitespace(p9, p10) -- line: 127
    -- upvalues: t1 (copy), t5 (copy)
    if #p9 == 0 then
        return nil
    end

    for _, v5 in ipairs(t1) do
        if p9:sub(1, #v5) == v5 then
            p10[2] += #v5

            if t5[v5] then
                p10[1] += 1
                p10[2] = 1
            end

            return v5
        end
    end

    return nil
end

local function stripWhitespace(p11, p12) -- line: 145
    -- upvalues: getWhitespace (copy)
    while true do
        local v7 = getWhitespace(p11, p12)

        if v7 == nil then
            break
        end

        p11 = p11:sub(#v7 + 1)
    end

    return p11
end

local function stripInlineComments(p13, p14) -- line: 162
    -- upvalues: getNewline (copy)
    local v9

    while true do
        if #p13 == 0 then
            return p13
        end

        v9 = getNewline(p13, p14)

        if v9 then
            break
        end

        p13 = p13:sub(2)
        p14[2] += 1
    end

    return (p13:sub(#v9 + 1))
end

local function stripBlockComments(p15, p16) -- line: 186
    -- upvalues: formatError (copy), getNewline (copy)
    while true do
        if #p15 > 0 then
            if p15:sub(1, 2) == "*/" then
                break
            end

            local v11 = getNewline(p15, p16)

            if v11 then
                p15 = p15:sub(#v11 + 1)
            else
                p16[2] += 1
                p15 = p15:sub(2)
            end

            continue
        end

        error(formatError("missing multiline comment close tag", p16))

        return ""
    end

    p16[2] += 2

    return p15:sub(3)
end

local function codepointToutf8(p17) -- line: 210
    if p17 <= 127 then
        return (string.char(p17))
    end

    if p17 <= 2047 then
        return (string.char(math.floor(p17 / 64) + 192, p17 % 64 + 128))
    end

    if p17 <= 65535 then
        return (string.char(math.floor(p17 / 4096) + 224, math.floor(p17 % 4096 / 64) + 128, p17 % 64 + 128))
    end

    if not (p17 <= 1114111) then
        return nil, string.format("invalid unicode codepoint '%x'", p17)
    end

    return (string.char(math.floor(p17 / 262144) + 240, math.floor(p17 % 262144 / 4096) + 128, math.floor(p17 % 4096 / 64) + 128, p17 % 64 + 128))
end

local function parseUnicodeImpl(p18, p19) -- line: 232
    -- upvalues: formatError (copy)
    local v27 = p18:match("^\\u(%x%x%x%x)")

    if not v27 then
        error(formatError("invalid unicode hex escape sequence", p19))
    end

    local v28 = tonumber(v27, 16)

    if not v28 then
        error(formatError("invalid unicode hex escape sequence", p19))
    end

    p19[2] += 6

    return v28, p18:sub(7)
end

local function getSurrogatePair(p20, p21) -- line: 249
    return (p21 - 55296) * 1024 + (p20 - 56320) + 65536
end

local function parseUnicode(p22, p23) -- line: 255
    -- upvalues: formatError (copy), codepointToutf8 (copy), parseUnicodeImpl (copy)
    local v29 = p23[1]
    local v30 = p23[2]
    local v31, v32 = parseUnicodeImpl(p22, p23)

    if v31 >= 55296 and v31 < 56320 then
        local v33

        v33, v32 = parseUnicodeImpl(v32, p23)

        if v33 and v33 >= 56320 and v33 <= 57343 then
            v31 = (v31 - 55296) * 1024 + (v33 - 56320) + 65536
        end
    end

    local v34, v35 = codepointToutf8(v31)

    if not v34 then
        error(formatError(assert(v35), { v29, v30 }))
    end

    return v34, v32
end

local function parseStringImpl(p24, p25, p26, p27) -- line: 285
    -- upvalues: t6 (copy), formatError (copy), getNewline (copy), parseUnicode (copy)
    local t7 = {}
    local v36 = p24

    while not p25(v36) do
        local v37 = v36:sub(1, 1)

        if v37 == "\\" then
            local v38 = v36:sub(2, 2)

            p27[2] += 1

            if t6[v38] then
                p27[2] += 1

                if p26 then
                    error(formatError("escape sequence not allowed", p27))
                end

                t7[#t7 + 1] = t6[v38]
                v36 = v36:sub(3)
            elseif v38 == "u" then
                local v39

                v39, v36 = parseUnicode(v36, p27)
                t7[#t7 + 1] = v39
            elseif v38 == "x" then
                if p26 then
                    error(formatError("hex escape sequence not allowed", p27))
                end

                p27[2] += 2

                local v41 = tonumber(v36:sub(2, 3), 16)

                if not v41 then
                    error(formatError("invalid hex escape sequence", p27))
                end

                t7[#t7 + 1] = string.char(v41)
                p27[2] += 2
                v36 = v36:sub(5)
            else
                if p26 then
                    error(formatError("invalid escape sequence", p27))
                end

                local v42 = getNewline(v36:sub(2), p27)

                v36 = v36:sub(if v42 then #v42 + 2 else 2)
            end
        elseif v37:byte(1, 1) < 32 then
            error(formatError("control character found", p27))
        else
            t7[#t7 + 1] = v37
            v36 = v36:sub(2)
            p27[2] += 1
        end
    end

    return table.concat(t7), v36
end

local function parseString(p28, p29) -- line: 364
    -- upvalues: parseStringImpl (copy)
    local v43 = p28:sub(1, 1)

    local function stopCriterion(p30) -- line: 369
        -- upvalues: v43 (copy)
        return p30:sub(1, 1) == v43
    end

    local v44, v45 = parseStringImpl(p28:sub(2), stopCriterion, false, p29)

    p29[2] += 1

    return v44, v45:sub(2)
end

local function parseNumber(p31, p32) -- line: 382
    -- upvalues: formatError (copy), getWhitespace (copy)
    local v46 = p31:sub(1, 1)
    local v47 = p32[1]
    local v48 = p32[2]
    local v49, v50

    if v46 == "+" then
        v49 = p31:sub(2)
        p32[2] += 1
        v50 = 1
    elseif v46 == "-" then
        v49 = p31:sub(2)
        p32[2] += 1
        v50 = -1
    else
        v49 = p31
        v50 = 1
    end

    if v49:sub(1, 3) == "NaN" then
        p32[2] += 3

        return (0/0), v49:sub(4)
    end

    if v49:find("Infinity", 1, true) == 1 then
        p32[2] += 8

        return 1e999 * v50, v49:sub(9)
    end

    local n1 = 0
    local v51 = v49

    while not getWhitespace(v51, p32) do
        local v52 = v51:sub(1, 1)

        if v52 == "" or v52 == "," or v52 == "]" or v52 == "}" then
            break
        end

        n1 += 1
        v51 = v51:sub(2)
        p32[2] += 1
    end

    local v53 = v49:sub(1, n1)
    local v54 = if v53:sub(1, 1) ~= "0" or not v53:sub(2):find("^%d+$") then tonumber(v53) else nil

    if v54 == nil then
        error(formatError("invalid number sequence " .. string.format("%q", v53):gsub("\r", "\\r"):gsub("\n", "\\n"), { v47, v48 }))
    end

    p32[2] += n1

    return v54 * v50, v49:sub(n1 + 1)
end

local function parseNull(p33, p34, p35) -- line: 449
    -- upvalues: formatError (copy)
    if p33:sub(1, 4) ~= "null" then
        error(formatError("invalid null literal", p34))
    end

    p34[2] += 1

    return p35, p33:sub(5)
end

local function parseBoolean(p36, p37) -- line: 460
    -- upvalues: formatError (copy)
    if p36:sub(1, 4) == "true" then
        p37[2] += 4

        return true, p36:sub(5)
    end

    if p36:sub(1, 5) == "false" then
        p37[2] += 5

        return false, p36:sub(6)
    end

    error(formatError("invalid boolean literal", p37))
end

local function stripComments(p38, p39) -- line: 474
    -- upvalues: stripInlineComments (copy), stripBlockComments (copy)
    local v55 = p38:sub(1, 2)

    if v55 == "//" then
        p39[2] += 2

        return (stripInlineComments(p38:sub(3), p39))
    end

    if v55 ~= "/*" then
        return p38
    end

    p39[2] += 2

    return stripBlockComments(p38:sub(3), p39)
end

local function stripWhitespaceAndComments(p40, p41) -- line: 489
    -- upvalues: stripWhitespace (copy), stripComments (copy)
    while true do
        local v58 = stripComments(stripWhitespace(p40, p41), p41)

        if v58 == p40 then
            break
        end

        p40 = v58
    end

    return p40
end

local v59

local function parseArray(p42, p43, p44) -- line: 514
    -- upvalues: formatError (copy), stripWhitespaceAndComments (copy), v59 (ref)
    local v60 = p42:sub(2)

    p43[2] += 1

    local t8 = {}

    while true do
        local v61 = stripWhitespaceAndComments(v60, p43)

        if v61:sub(1, 1) == "]" then
            p43[2] += 1
            v60 = v61:sub(2)
            break
        end

        local v62, v63 = v59(v61, p43, p44)
        local v64 = stripWhitespaceAndComments(v63, p43)

        t8[#t8 + 1] = v62

        local v65 = v64:sub(1, 1)

        v60 = v64:sub(2)

        if v65 == "]" then
            p43[2] += 1
            break
        end

        if v65 ~= "," then
            error(formatError("expected comma got " .. string.format("%q", v65):gsub("\r", "\\r"):gsub("\n", "\\n"), p43))
        end

        p43[2] += 1
    end

    return t8, v60
end

local function testIdentifier(p45) -- line: 556
    local v66 = p45:byte(1, 1)

    if v66 >= 48 and v66 <= 57 then
        return false
    end

    for i = 1, #p45 do
        local v67 = p45:byte(i, i)

        if v67 < 36
            or v67 >= 37 and v67 <= 47
            or v67 >= 58 and v67 <= 64
            or v67 >= 91 and v67 <= 94
            or v67 == 96
            or v67 >= 123 and v67 <= 128 then
            return false
        end
    end

    return true
end

local function stopIdentifier(p46) -- line: 593
    -- upvalues: getWhitespace (copy)
    if p46:sub(1, 1) == ":" then
        return true
    end

    return getWhitespace(p46, { 0, 0 }) ~= nil
end

local function parseIdentifier(p47, p48) -- line: 599
    -- upvalues: formatError (copy), parseStringImpl (copy), parseString (copy), testIdentifier (copy), stopIdentifier (copy)
    local v68 = p47:sub(1, 1)
    local v69, v70

    if v68 == "'" or v68 == "\"" then
        v69, v70 = parseString(p47, p48)
    else
        local v71 = p48[1]
        local v72 = p48[2]

        v69, v70 = parseStringImpl(p47, stopIdentifier, true, p48)

        if not testIdentifier(v69) then
            error(formatError("invalid identifier " .. string.format("%q", v69):gsub("\r", "\\r"):gsub("\n", "\\n"), { v71, v72 }))
        end
    end

    return v69, v70
end

local function parseObject(p49, p50, p51) -- line: 624
    -- upvalues: formatError (copy), stripWhitespaceAndComments (copy), v59 (ref), parseIdentifier (copy)
    p50[2] += 1

    local t9 = {}
    local v73 = p49:sub(2)

    while true do
        local v74 = stripWhitespaceAndComments(v73, p50)

        if v74:sub(1, 1) == "}" then
            p50[2] += 1
            v73 = v74:sub(2)
            break
        end

        local v75, v76 = parseIdentifier(v74, p50)
        local v77 = stripWhitespaceAndComments(v76, p50)

        if v77:sub(1, 1) ~= ":" then
            local _error = error
            local v78 = v77:sub(1, 1)

            _error(formatError("expected colon after identifier, got " .. string.format("%q", v78):gsub("\r", "\\r"):gsub("\n", "\\n"), p50))
        end

        p50[2] += 1

        local v80 = stripWhitespaceAndComments(v77:sub(2), p50)
        local v81, v82 = v59(v80, p50, p51)
        local v83 = stripWhitespaceAndComments(v82, p50)

        t9[v75] = v81

        local v84 = v83:sub(1, 1)

        v73 = v83:sub(2)

        if v84 == "}" then
            p50[2] += 1
            break
        end

        if v84 ~= "," then
            error(formatError("expected comma got " .. string.format("%q", v84):gsub("\r", "\\r"):gsub("\n", "\\n"), p50))
        end

        p50[2] += 1
    end

    return t9, v73
end

local t10 = {
    ["-"] = parseNumber,
    ["+"] = parseNumber,
    ["."] = parseNumber,
    ["0"] = parseNumber,
    ["1"] = parseNumber,
    ["2"] = parseNumber,
    ["3"] = parseNumber,
    ["4"] = parseNumber,
    ["5"] = parseNumber,
    ["6"] = parseNumber,
    ["7"] = parseNumber,
    ["8"] = parseNumber,
    ["9"] = parseNumber,
    N = parseNumber,
    I = parseNumber,
    n = parseNull,
    t = parseBoolean,
    f = parseBoolean,
    ["'"] = parseString,
    ["\""] = parseString,
    ["["] = parseArray,
    ["{"] = parseObject,
    [""] = function(_, p53) -- catchEOF | line: 684
        -- upvalues: formatError (copy)
        error(formatError("unexpected eof", p53))
    end
}

v59 = function(p54, p55, p56) -- line: 718
    -- upvalues: formatError (copy), stripWhitespaceAndComments (copy), t10 (copy)
    local v85 = stripWhitespaceAndComments(p54, p55)
    local v86 = v85:sub(1, 1)
    local v87 = t10[v86]

    if not v87 then
        error(formatError("invalid value literal " .. string.format("%q", v86):gsub("\r", "\\r"):gsub("\n", "\\n"), p55))
    end

    return v87(v85, p55, p56)
end

local t11 = {
    Null = newproxy(false),
    Decode = function(p57, p58) -- Decode | line: 747
        -- upvalues: formatError (copy), stripWhitespaceAndComments (copy), v59 (ref)
        local t12 = {
            1, 1
        }
        local v88 = stripWhitespaceAndComments(p57, t12)
        local v89, v90 = v59(v88, t12, p58)

        if #stripWhitespaceAndComments(v90, t12) > 0 then
            error(formatError("trailing garbage", t12))
        end

        return v89
    end
}

return table.freeze(t11)
