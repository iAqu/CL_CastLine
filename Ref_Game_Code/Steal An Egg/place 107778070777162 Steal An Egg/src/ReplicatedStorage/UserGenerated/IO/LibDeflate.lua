-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local byte, char, find, gsub = string.byte, string.char, string.find, string.gsub
local sub, concat, sort = string.sub, table.concat, table.sort
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local t9 = {}
local t11 = {
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 13, 15, 17, 19, 23, 27, 31,
    35, 43, 51, 59, 67, 83, 99, 115,
    131, 163, 195, 227, 258
}
local t12 = {
    0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 2, 2, 2, 2,
    3, 3, 3, 3, 4, 4, 4, 4,
    5, 5, 5, 5, 0
}
local t13 = {
    [0] = 1,
    2, 3, 4, 5, 7, 9, 13, 17,
    25, 33, 49, 65, 97, 129, 193, 257,
    385, 513, 769, 1025, 1537, 2049, 3073, 4097,
    6145, 8193, 12289, 16385, 24577
}
local t14 = {
    [0] = 0,
    0, 0, 0, 1, 1, 2, 2, 3,
    3, 4, 4, 5, 5, 6, 6, 7,
    7, 8, 8, 9, 9, 10, 10, 11,
    11, 12, 12, 13, 13
}
local t15 = {
    16, 17, 18, 0, 8, 7, 9, 6,
    10, 5, 11, 4, 12, 3, 13, 2,
    14, 1, 15
}
local v1 = {}
local v2 = {}
local t16 = {}
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}

for i = 0, 255 do
    t3[i] = char(i)
end

local n1 = 1

for i = 0, 32 do
    t2[i] = n1
    n1 *= 2
end

local v7, v8

for i = 1, 9 do
    t4[i] = {}
    v8 = t2[i + 1] - 1

    for j = 0, v8 do
        local n2 = 0

        v7 = j

        for _ = 1, i do
            n2 = n2 - n2 % 2 + (if n2 % 2 == 1 or v7 % 2 == 1 then 1 else 0)
            v7 = (v7 - v7 % 2) / 2
            n2 *= 2
        end

        t4[i][j] = (n2 - n2 % 2) / 2
    end
end

n1 = 18

local n3 = 16
local n4 = 265

v8 = 1

local v9, v10, v11, v12

for i = 3, 258 do
    if i <= 10 then
        t5[i] = i + 254
        t7[i] = 0
    elseif i == 258 then
        t5[i] = 285
        t7[i] = 0
    else
        if n1 < i then
            v9 = n1 + n3
            v10 = n3 * 2
            v11 = n4 + 4
            v12 = v8 + 1
        else
            v12 = v8
            v9 = n1
            v10 = n3
            v11 = n4
        end

        v8 = v12
        v7 = i - v9 - 1 + v10 / 2
        t5[i] = (v7 - v7 % (v10 / 8)) / (v10 / 8) + v11
        t7[i] = v12
        t6[i] = v7 % (v10 / 8)
        n1 = v9
        n3 = v10
        n4 = v11
    end
end

local t8 = {
    0, 1
}

v9 = 3
v10 = 4
v11 = 2
v12 = 0

local t10 = {
    0, 0
}

for i = 3, 256 do
    if v10 < i then
        v9 *= 2
        v10 *= 2
        v11 += 2
        v12 += 1
    end

    v7 = if not (i <= v9) or not v11 then v11 + 1 else v11
    t8[i] = v7
    v7 = if v12 < 0 then 0 else v12
    t10[i] = v7

    if v10 >= 8 then
        t9[i] = (i - v10 / 2 - 1) % (v10 / 4)
    end
end

function t1.Adler32(_, p2) -- line: 444
    -- upvalues: byte (copy)
    if type(p2) ~= "string" then
        error(("Usage: LibDeflate:Adler32(str): 'str' - string expected got '%s'."):format((type(p2))), 2)
    end

    local v13 = #p2
    local n5 = 1
    local n6 = 1
    local n7 = 0

    while n5 <= v13 - 15 do
        local v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30 = byte(p2, n5, n5 + 15)

        n7 = (n7 + n6 * 16 + v15 * 16 + 15 * v16 + 14 * v17 + 13 * v18 + 12 * v19 + 11 * v20 + 10 * v21 + 9 * v22 + 8 * v23 + 7 * v24 + 6 * v25 + 5 * v26 + 4 * v27 + 3 * v28 + 2 * v29 + v30) % 65521
        n6 = (n6 + v15 + v16 + v17 + v18 + v19 + v20 + v21 + v22 + v23 + v24 + v25 + v26 + v27 + v28 + v29 + v30) % 65521
        n5 += 16
    end

    while n5 <= v13 do
        n6 = (n6 + byte(p2, n5, n5)) % 65521
        n7 = (n7 + n6) % 65521
        n5 += 1
    end

    return (n7 * 65536 + n6) % 4294967296
end

local function IsEqualAdler32(p3, p4) -- line: 502
    return p3 % 4294967296 == p4 % 4294967296
end

function t1.CreateDictionary(p5, p6, p7, p8) -- line: 548
    -- upvalues: byte (copy)
    if type(p6) ~= "string" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'str' - string expected got '%s'."):format((type(p6))), 2)
    end

    if type(p7) ~= "number" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'strlen' - number expected got '%s'."):format((type(p7))), 2)
    end

    if type(p8) ~= "number" then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'adler32' - number expected got '%s'."):format((type(p8))), 2)
    end

    if p7 ~= #p6 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'strlen' does not match the actual length of 'str'. 'strlen': %u, '#str': %u . Please check if 'str' is modified unintentionally."):format(p7, #p6))
    end

    if p7 == 0 then
        error("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'str' - Empty string is not allowed.", 2)
    end

    if p7 > 32768 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'str' - string longer than 32768 bytes is not allowed. Got %d bytes."):format(p7), 2)
    end

    local v31 = p5:Adler32(p6)

    if p8 % 4294967296 ~= v31 % 4294967296 then
        error(("Usage: LibDeflate:CreateDictionary(str, strlen, adler32): 'adler32' does not match the actual adler32 of 'str'. 'adler32': %u, 'Adler32(str)': %u . Please check if 'str' is modified unintentionally."):format(p8, v31))
    end

    local t17 = {
        adler32 = p8,
        hash_tables = {},
        string_table = {},
        strlen = p7
    }
    local string_table, hash_tables = t17.string_table, t17.hash_tables

    string_table[1] = byte(p6, 1, 1)
    string_table[2] = byte(p6, 2, 2)

    if p7 >= 3 then
        local v32 = 1
        local v33 = string_table[1] * 256 + string_table[2]

        while v32 <= p7 - 2 - 3 do
            local v36, v37, v38, v39 = byte(p6, v32 + 2, v32 + 5)

            string_table[v32 + 2] = v36
            string_table[v32 + 3] = v37
            string_table[v32 + 4] = v38
            string_table[v32 + 5] = v39

            local v40 = (v33 * 256 + v36) % 16777216
            local v41 = hash_tables[v40]

            if not v41 then
                v41 = {}
                hash_tables[v40] = v41
            end

            v41[#v41 + 1] = v32 - p7

            local v42 = v32 + 1
            local v43 = (v40 * 256 + v37) % 16777216
            local v44 = hash_tables[v43]

            if not v44 then
                v44 = {}
                hash_tables[v43] = v44
            end

            v44[#v44 + 1] = v42 - p7

            local v45 = v42 + 1
            local v46 = (v43 * 256 + v38) % 16777216
            local v47 = hash_tables[v46]

            if not v47 then
                v47 = {}
                hash_tables[v46] = v47
            end

            v47[#v47 + 1] = v45 - p7

            local v48 = v45 + 1

            v33 = (v46 * 256 + v39) % 16777216

            local v49 = hash_tables[v33]

            if not v49 then
                v49 = {}
                hash_tables[v33] = v49
            end

            v49[#v49 + 1] = v48 - p7
            v32 = v48 + 1
        end

        while v32 <= p7 - 2 do
            local v51 = byte(p6, v32 + 2)

            string_table[v32 + 2] = v51
            v33 = (v33 * 256 + v51) % 16777216

            local v52 = hash_tables[v33]

            if not v52 then
                v52 = {}
                hash_tables[v33] = v52
            end

            v52[#v52 + 1] = v32 - p7
            v32 += 1
        end
    end

    return t17
end

local function IsValidDictionary(p9) -- line: 674
    if p9 == nil or type(p9) ~= "table" then
        return false, ("'dictionary' - table expected got '%s'."):format((type(p9)))
    end

    if type(p9.adler32) == "number" and type(p9.string_table) == "table" and type(p9.strlen) == "number" and not (p9.strlen <= 0) and not (p9.strlen > 32768) and p9.strlen == #p9.string_table and type(p9.hash_tables) == "table" then
        return true, ""
    end

    return false, ("'%s' - corrupted dictionary."):format((type(p9)))
end

local t18 = {
    [0] = { false, nil, 0, 0, 0 },
    [1] = { false, nil, 4, 8, 4 },
    [2] = { false, nil, 5, 18, 8 },
    [3] = { false, nil, 6, 32, 32 },
    [4] = { true, 4, 4, 16, 16 },
    [5] = { true, 8, 16, 32, 32 },
    [6] = { true, 8, 16, 128, 128 },
    [7] = { true, 8, 32, 128, 256 },
    [8] = { true, 32, 128, 258, 1024 },
    [9] = { true, 32, 258, 258, 4096 }
}

local function IsValidArguments(p10, p11, p12, p13, p14) -- line: 754
    -- upvalues: IsValidDictionary (copy), t18 (copy)
    if type(p10) ~= "string" then
        return false, ("'str' - string expected got '%s'."):format((type(p10)))
    end

    local v53, v54

    if p11 then
        v53, v54 = IsValidDictionary(p12)
    end

    if p11 and not v53 then
        return false, v54
    end

    if p13 then
        local v55 = type(p14)

        if v55 ~= "nil" and v55 ~= "table" then
            return false, ("'configs' - nil or table expected got '%s'."):format((type(p14)))
        end

        if v55 == "table" then
            assert(p14)

            for v56, v57 in pairs(p14) do
                if v56 ~= "level" and v56 ~= "strategy" then
                    return false, ("'configs' - unsupported table key in the configs: '%s'."):format(v56)
                end

                if v56 == "level" and not t18[v57] then
                    return false, ("'configs' - unsupported 'level': %s."):format((tostring(v57)))
                end

                if v56 == "strategy" and v57 ~= "fixed" and v57 ~= "huffman_only" and v57 ~= "dynamic" then
                    return false, ("'configs' - unsupported 'strategy': '%s'."):format((tostring(v57)))
                end
            end
        end
    end

    return true, ""
end

local function CreateWriter() -- line: 817
    -- upvalues: char (copy), concat (copy), t2 (copy), t3 (copy)
    local n8 = 0
    local t19 = {}

    t19[1] = 0

    local n9 = 0
    local n10 = 0
    local t20 = {}
    local t21 = {}

    return function(p15, p16) -- WriteBits | line: 830
        -- upvalues: n8 (ref), t19 (copy), n9 (ref), n10 (ref), t20 (ref), t2 (copy), t3 (copy)
        t19[1] += p15 * t2[n9]
        n9 += p16
        n10 += p16

        if not (n9 >= 32) then
            return
        end

        n8 += 1

        local t22 = t20
        local v58 = n8

        t22[v58] = t3[t19[1] % 256] .. t3[(t19[1] - t19[1] % 256) / 256 % 256] .. t3[(t19[1] - t19[1] % 65536) / 65536 % 256] .. t3[(t19[1] - t19[1] % 16777216) / 16777216 % 256]

        local v59 = t2[32 - n9 + p16]

        t19[1] = (p15 - p15 % v59) / v59
        n9 -= 32
    end, function(p17) -- WriteString | line: 850
        -- upvalues: n8 (ref), t19 (copy), n9 (ref), n10 (ref), t20 (ref), char (copy)
        local v60 = n9

        for _ = 1, v60, 8 do
            n8 += 1

            local t23 = t20
            local v61 = n8

            t23[v61] = char(t19[1] % 256)
            t19[1] = (t19[1] - t19[1] % 256) / 256
        end

        n9 = 0
        n8 += 1

        local t24 = t20

        t24[n8] = p17

        local v63 = n10

        n10 = v63 + #p17 * 8
    end, function(p18) -- FlushWriter | line: 869
        -- upvalues: n8 (ref), t19 (copy), n9 (ref), n10 (ref), t20 (ref), t21 (copy), concat (copy), t2 (copy), t3 (copy)
        if p18 == 3 then
            return n10, nil
        end

        if p18 == 1 or p18 == 2 then
            local v64 = (8 - n9 % 8) % 8

            if n9 > 0 then
                t19[1] = t19[1] - t2[n9] + t2[n9 + v64]

                local v65 = n9

                for _ = 1, v65, 8 do
                    n8 += 1

                    local t25 = t20
                    local v66 = n8

                    t25[v66] = t3[t19[1] % 256]
                    t19[1] = (t19[1] - t19[1] % 256) / 256
                end

                t19[1] = 0
                n9 = 0
            end

            if p18 == 2 then
                n10 += v64

                return n10, nil
            end
        end

        local v67 = concat(t20)

        t20 = {}
        n8 = 0
        t21[#t21 + 1] = v67

        if p18 == 0 then
            return n10, nil
        end

        return n10, concat(t21)
    end
end

local function MinHeapPush(p19, p20, p21) -- line: 922
    local v68 = p21 + 1

    p19[v68] = p20

    local v69 = p20[1]
    local v70 = (v68 - v68 % 2) / 2

    while v70 >= 1 and v69 < p19[v70][1] do
        local v71 = p19[v70]

        p19[v70] = p20
        p19[v68] = v71
        v68 = v70
        v70 = (v70 - v70 % 2) / 2
    end
end

local function MinHeapPop(p22, p23) -- line: 943
    local v72 = p22[1]
    local v73 = p22[p23]
    local v74 = v73[1]

    p22[1] = v73
    p22[p23] = v72

    local v75 = p23 - 1
    local v76 = 1 * 2
    local v77 = 1
    local v78 = v76 + 1

    while v76 <= v75 do
        local v79 = p22[v76]
        local v80, v81, v82, v83

        if v78 <= v75 and p22[v78][1] < v79[1] then
            local v84 = p22[v78]

            if v84[1] < v74 then
                p22[v78] = v73
                p22[v77] = v84
                v80 = v78 * 2
                v82 = v78
                v81 = v80 + 1
                v83 = false
            else
                v83 = true
            end
        elseif v79[1] < v74 then
            p22[v76] = v73
            p22[v77] = v79
            v80 = v76 * 2
            v81 = v80 + 1
            v82 = v76
            v83 = false
        else
            v83 = true
        end

        if v83 then
            break
        end

        v78 = v81
        v77 = v82
        v76 = v80
    end

    return v72
end

local function GetHuffmanCodeFromBitlen(p24, p25, p26, p27) -- line: 992
    -- upvalues: t4 (copy)
    local t26 = {}
    local t27 = {}
    local n11 = 0

    for i = 1, p27 do
        n11 = (n11 + (p24[i - 1] or 0)) * 2
        t26[i] = n11
    end

    for i = 0, p26 do
        local v85 = p25[i]

        if v85 then
            local v86 = t26[v85]

            t26[v85] = v86 + 1

            if v85 <= 9 then
                t27[i] = t4[v85][v86]
            else
                local n12 = 0

                for _ = 1, v85 do
                    local v87 = n12 - n12 % 2 + (if n12 % 2 == 1 or v86 % 2 == 1 then 1 else 0)

                    v86 = (v86 - v86 % 2) / 2
                    n12 = v87 * 2
                end

                t27[i] = (n12 - n12 % 2) / 2
            end
        end
    end

    return t27
end

local function SortByFirstThenSecond(p28, p29) -- line: 1034
    if p28[1] < p29[1] then
        return true
    end

    if p28[1] == p29[1] then
        return p28[2] < p29[2]
    end

    return false
end

local function GetHuffmanBitlenAndCode(p30, p31, p32) -- line: 1049
    -- upvalues: sort (copy), MinHeapPush (copy), MinHeapPop (copy), GetHuffmanCodeFromBitlen (copy), SortByFirstThenSecond (copy)
    local t28 = {}
    local t29 = {}
    local t30 = {}
    local t31 = {}
    local t32 = {}
    local n13 = 0

    for v88, v89 in pairs(p30) do
        n13 += 1
        t28[n13] = { v89, v88 }
    end

    if n13 == 0 then
        return {}, {}, -1
    end

    if n13 == 1 then
        local v90 = t28[1][2]

        t30[v90] = 1
        t31[v90] = 0

        return t30, t31, v90
    end

    sort(t28, SortByFirstThenSecond)

    for i = 1, n13 do
        t29[i] = t28[i]
    end

    while n13 > 1 do
        local v91 = MinHeapPop(t29, n13)
        local v92 = n13 - 1
        local v93 = MinHeapPop(t29, v92)
        local v94 = v92 - 1

        MinHeapPush(t29, {
            v91[1] + v93[1],
            -1,
            v91,
            v93
        }, v94)
        n13 = v94 + 1
    end

    local t34 = {
        t29[1],
        {},
        {},
        {}
    }

    t29[1][1] = 0

    local n14 = -1
    local n15 = 0
    local n16 = 1
    local n17 = 1

    while n17 <= n16 do
        local v95 = t34[n17]
        local v96 = v95[1]
        local v97 = v95[2]
        local v98 = v95[3]
        local v99 = v95[4]

        if v98 then
            n16 += 1
            t34[n16] = v98
            v98[1] = v96 + 1
        end

        if v99 then
            n16 += 1
            t34[n16] = v99
            v99[1] = v96 + 1
        end

        n17 += 1

        if p31 < v96 then
            n15 += 1
            v96 = p31
        end

        if v97 >= 0 then
            t30[v97] = v96
            n14 = n14 < v97 and v97 or n14
            t32[v96] = (t32[v96] or 0) + 1
        end
    end

    if n15 > 0 then
        repeat
            local v100 = p31 - 1

            while (t32[v100] or 0) == 0 do
                v100 -= 1
            end

            t32[v100] -= 1
            t32[v100 + 1] = (t32[v100 + 1] or 0) + 2
            t32[p31] -= 1
            n15 -= 2
        until n15 <= 0

        local n18 = 1

        for i = p31, 1, -1 do
            local v101 = t32[i] or 0

            while v101 > 0 do
                t30[t28[n18][2]] = i
                v101 -= 1
                n18 += 1
            end
        end
    end

    return t30, GetHuffmanCodeFromBitlen(t32, t30, p32, p31), n14
end

local function RunLengthEncodeHuffmanBitlen(p33, p34, p35, p36) -- line: 1187
    local t35 = {}
    local t36 = {}
    local t37 = {}
    local v102 = p34 + (if p36 < 0 then 0 else p36) + 1
    local v103 = v102 + 1
    local n19 = 0
    local n20 = 0
    local n21 = 0
    local v104

    for i = 0, v103 do
        local v105 = if i <= p34 then p33[i] or 0 elseif i <= v102 then p35[i - p34 - 1] or 0 else nil

        if v105 == v104 then
            n21 += 1

            if v105 ~= 0 and n21 == 6 then
                n19 += 1
                t35[n19] = 16
                n20 += 1
                t37[n20] = 3
                n21 = 0
                t36[16] = (t36[16] or 0) + 1
            elseif v105 == 0 and n21 == 138 then
                n19 += 1
                t35[n19] = 18
                n20 += 1
                t37[n20] = 127
                n21 = 0
                t36[18] = (t36[18] or 0) + 1
            end
        else
            local v106
            local v107 = n20

            if n21 == 1 then
                assert(v104)
                v106 = n19 + 1
                t35[v106] = v104
                t36[v104] = (t36[v104] or 0) + 1
            elseif n21 == 2 then
                assert(v104)

                local v108 = n19 + 1

                t35[v108] = v104
                v106 = v108 + 1
                t35[v106] = v104
                t36[v104] = (t36[v104] or 0) + 2
            elseif n21 >= 3 then
                v106 = n19 + 1

                local v109 = if v104 ~= 0 then 16 elseif n21 <= 10 then 17 else 18

                t35[v106] = v109
                t36[v109] = (t36[v109] or 0) + 1
                v107 = n20 + 1
                t37[v107] = n21 <= 10 and n21 - 3 or n21 - 11
            else
                v106 = n19
            end

            n20 = v107

            local v110 = if v105 then v105 == 0 else nil

            if not v105 or v110 then
                n19 = v106
                n21 = 1
            else
                n19 = v106 + 1
                t35[n19] = v105
                n21 = 0
                t36[v105] = (t36[v105] or 0) + 1
            end

            v104 = v105
        end
    end

    return t35, t37, t36
end

local function LoadStringToTable(p37, p38, p39, p40, p41) -- line: 1272
    -- upvalues: byte (copy)
    local v111 = p39 - p41

    while v111 <= p40 - 15 - p41 do
        local v112 = v111 + 1
        local v113 = v111 + 2
        local v114 = v111 + 3
        local v115 = v111 + 4
        local v116 = v111 + 5
        local v117 = v111 + 6
        local v118 = v111 + 7
        local v119 = v111 + 8
        local v120 = v111 + 9
        local v121 = v111 + 10
        local v122 = v111 + 11
        local v123 = v111 + 12
        local v124 = v111 + 13
        local v125 = v111 + 14
        local v126 = v111 + 15
        local v129, v130, v131, v132, v133, v134, v135, v136, v137, v138, v139, v140, v141, v142, v143, v144 = byte(p37, v111 + p41, v111 + 15 + p41)

        p38[v111] = v129
        p38[v112] = v130
        p38[v113] = v131
        p38[v114] = v132
        p38[v115] = v133
        p38[v116] = v134
        p38[v117] = v135
        p38[v118] = v136
        p38[v119] = v137
        p38[v120] = v138
        p38[v121] = v139
        p38[v122] = v140
        p38[v123] = v141
        p38[v124] = v142
        p38[v125] = v143
        p38[v126] = v144
        v111 += 16
    end

    while v111 <= p40 - p41 do
        p38[v111] = byte(p37, v111 + p41, v111 + p41)
        v111 += 1
    end

    return p38
end

local function GetBlockLZ77Result(p42, p43, p44, p45, p46, p47, p48) -- line: 1328
    -- upvalues: t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t18 (copy)
    local v147 = t18[p42]
    local v148 = v147[1]
    local v149 = v147[2]
    local v150 = v147[3]
    local v151 = v147[4]
    local v152 = v147[5]
    local v153 = if v148 or not v150 then 2147483646 else v150
    local v154 = v152 - v152 % 4 / 4
    local t38 = {}
    local t39 = {}
    local v155, v156, v157

    if p48 then
        local hash_tables, string_table, strlen = p48.hash_tables, p48.string_table, p48.strlen

        v155 = strlen
        assert(p45 == 1)

        if p45 <= p46 and strlen >= 2 then
            local v159 = string_table[strlen - 1] * 65536 + string_table[strlen] * 256 + p43[1]
            local v160 = p44[v159]

            if not v160 then
                v160 = {}
                p44[v159] = v160
            end

            v160[#v160 + 1] = -1
        end

        if p45 + 1 <= p46 and strlen >= 1 then
            local v161 = string_table[strlen] * 65536 + p43[1] * 256 + p43[2]
            local v162 = p44[v161]

            if not v162 then
                v162 = {}
                p44[v161] = v162
            end

            v162[#v162 + 1] = 0
        end

        v156 = hash_tables
        v157 = string_table
    else
        v156 = t38
        v157 = t39
        v155 = 0
    end

    local v163 = v155 + 3
    local v164 = (p43[p45 - p47] or 0) * 256 + (p43[p45 + 1 - p47] or 0)
    local t40 = {}
    local t41 = {}
    local t42 = {}
    local t43 = {}
    local t44 = {}
    local t45 = {}
    local v165 = p46 + (if v148 then 1 else 0)
    local n22 = 0
    local n23 = 0
    local n24 = 0
    local n25 = 0
    local v166 = false
    local n26 = 0
    local n27 = 0
    local v167 = p45

    while v167 <= v165 do
        local v168 = v167 - p47
        local v169 = p47 - 3

        v164 = (v164 * 256 + (p43[v168 + 2] or 0)) % 16777216

        local v170 = p44[v164]
        local v171, v172, v173

        if v170 then
            v172 = #v170
            v173 = v172
            v171 = v170
        else
            v171 = {}
            p44[v164] = v171

            if v156 then
                v170 = v156[v164]
                v172 = v170 and #v170 or 0
            else
                v172 = 0
                v170 = nil
            end

            v173 = 0
        end

        if v167 <= p46 then
            v171[v173 + 1] = v167
        end

        local v175, v176

        if v172 > 0 and v167 + 2 <= p46 then
            if not v148 or n26 < v150 then
                local v178 = if v148 and v149 <= n26 and v154 then v154 else v152
                local v179 = p46 - v167

                if v179 >= 257 then
                    v179 = 257
                end

                local v180 = v179 + v168
                local v181 = v168 + 3

                v175 = 0
                v176 = n27

                local v182 = v178

                while v172 >= 1 and v182 > 0 do
                    local v183 = v170[v172]

                    if v167 - v183 > 32768 then
                        break
                    end

                    if v183 < v167 then
                        local v184 = v181

                        if v183 >= -257 then
                            local v185 = v183 - v169

                            while v184 <= v180 and p43[v185] == p43[v184] do
                                v184 += 1
                                v185 += 1
                            end
                        else
                            local v186 = v163 + v183

                            while v184 <= v180 and v157[v186] == p43[v184] do
                                v184 += 1
                                v186 += 1
                            end
                        end

                        local v187 = v184 - v168

                        if v175 < v187 then
                            v175 = v187
                            v176 = v167 - v183
                        end

                        if v151 <= v175 then
                            break
                        end
                    end

                    local v188 = v172 - 1

                    v182 -= 1

                    local v189, v190

                    if v188 == 0 and v183 > 0 and v156 then
                        v190 = v156[v164]
                        v189 = v190 and #v190 or 0
                    else
                        v190 = v170
                        v189 = v188
                    end

                    v170 = v190
                    v172 = v189
                end
            else
                v175 = 0
                v176 = n27
            end
        else
            v175 = 0
            v176 = n27
        end

        if not v148 then
            n27 = v176
            n26 = v175
        end

        if (not v148 or v166) and (n26 > 3 or n26 == 3 and n27 < 4096) and v175 <= n26 then
            local v192 = t5[n26]
            local v193 = t7[n26]
            local v194, v195, v196

            if n27 <= 256 then
                v194 = t8[n27]
                v196 = t9[n27]
                v195 = t10[n27]
            else
                local n28 = 384

                v194 = 16
                v195 = 7

                local n29 = 512

                while true do
                    if n27 <= n28 then
                        v196 = (n27 - n29 / 2 - 1) % (n29 / 4)
                        break
                    end

                    if n27 <= n29 then
                        v196 = (n27 - n29 / 2 - 1) % (n29 / 4)
                        v194 += 1
                        break
                    end

                    v194 += 2
                    v195 += 1
                    n28 *= 2
                    n29 *= 2
                end
            end

            n22 += 1
            t40[n22] = v192
            t41[v192] = (t41[v192] or 0) + 1
            n23 += 1
            t42[n23] = v194
            t43[v194] = (t43[v194] or 0) + 1

            if v193 > 0 then
                local v197 = t6[n26]

                n24 += 1
                t44[n24] = v197
            end

            if v195 > 0 then
                n25 += 1
                t45[n25] = v196
            end

            for i = v167 + 1, v167 + n26 - (if v148 then 2 else 1) do
                v164 = (v164 * 256 + (p43[i - p47 + 2] or 0)) % 16777216

                if n26 <= v153 then
                    local v198 = p44[v164]

                    if not v198 then
                        v198 = {}
                        p44[v164] = v198
                    end

                    v198[#v198 + 1] = i
                end
            end

            v166 = false
            v167 = v167 + n26 - (if v148 then 1 else 0)
        else
            local v199, v200

            if v148 then
                if v166 then
                    v199 = v168 - 1 or v168
                    v200 = false
                else
                    v200 = true
                end
            else
                v199 = v168
                v200 = false
            end

            if v200 then
                v166 = true
            else
                local v201 = p43[v199]

                n22 += 1
                t40[n22] = v201
                t41[v201] = (t41[v201] or 0) + 1
            end

            v167 += 1
        end

        n27 = v176
        n26 = v175
    end

    t40[n22 + 1] = 256
    t41[256] = (t41[256] or 0) + 1

    return t40, t44, t41, t42, t45, t43
end

local function GetBlockDynamicHuffmanHeader(p49, p50) -- line: 1582
    -- upvalues: t15 (copy), GetHuffmanBitlenAndCode (copy), RunLengthEncodeHuffmanBitlen (copy)
    local v202, v203, v204 = GetHuffmanBitlenAndCode(p49, 15, 285)
    local v205, v206, v207 = GetHuffmanBitlenAndCode(p50, 15, 29)
    local v208, v209, v210 = RunLengthEncodeHuffmanBitlen(v202, v204, v205, v207)
    local v211, v212 = GetHuffmanBitlenAndCode(v210, 7, 18)
    local n30 = 0

    for i = 1, 19 do
        if (v211[t15[i]] or 0) ~= 0 then
            n30 = i
        end
    end

    local v213 = n30 - 4
    local v214 = v204 + 1 - 257
    local v215 = v207 + 1 - 1

    if v215 < 0 then
        v215 = 0
    end

    return v214, v215, v213, v211, v212, v208, v209, v202, v203, v205, v206
end

local function GetDynamicHuffmanBlockSize(p51, p52, p53, p54, p55, p56, p57) -- line: 1644
    -- upvalues: t12 (copy)
    local v216 = 17 + (p53 + 4) * 3

    for i = 1, #p55 do
        local v217 = p55[i]
        local v218 = v216 + p54[v217]

        v216 = if v217 >= 16 then v218 + (if v217 == 16 then 2 elseif v217 == 17 then 3 else 7) else v218
    end

    local n31 = 0

    for i = 1, #p51 do
        local v220 = p51[i]
        local v221 = v216 + p56[v220]
        local v222, v223

        if v220 > 256 then
            local v224 = n31 + 1
            local v225 = if v220 > 264 and v220 < 285 then v221 + t12[v220 - 256] else v221
            local v226 = p52[v224]

            v222 = v225 + p57[v226]
            v223 = v224

            if v226 > 3 then
                v222 += (v226 - v226 % 2) / 2 - 1
            end
        else
            v223 = n31
            v222 = v221
        end

        n31 = v223
        v216 = v222
    end

    return v216
end

local function CompressDynamicHuffmanBlock(p58, p59, p60, p61, p62, p63, p64, p65, p66, p67, p68, p69, p70, p71, p72, p73, p74) -- line: 1690
    -- upvalues: t12 (copy), t15 (copy)
    p58(p59 and 1 or 0, 1)
    p58(2, 2)
    p58(p64, 5)
    p58(p65, 5)
    p58(p66, 4)

    for i = 1, p66 + 4 do
        p58(p67[t15[i]] or 0, 3)
    end

    local n32 = 1

    for i = 1, #p69 do
        local v228 = p69[i]

        p58(p68[v228], p67[v228])

        if v228 >= 16 then
            p58(p70[n32], if v228 == 16 then 2 elseif v228 == 17 then 3 else 7)
            n32 += 1
        end
    end

    local n33 = 0
    local n34 = 0
    local n35 = 0

    for i = 1, #p60 do
        local v230 = p60[i]

        p58(p72[v230], p71[v230])

        local v232, v233
        local v231 = n35

        if v230 > 256 then
            local v234 = n33 + 1
            local v235 = n34

            if v230 > 264 and v230 < 285 then
                v235 = n34 + 1
                p58(p61[v235], t12[v230 - 256])
            end

            v233 = v235

            local v236 = p62[v234]

            p58(p74[v236], p73[v236])

            if v236 > 3 then
                v231 = n35 + 1
                p58(p63[v231], (v236 - v236 % 2) / 2 - 1)
            end

            v232 = v234
        else
            v232 = n33
            v233 = n34
        end

        n35 = v231
        n33 = v232
        n34 = v233
    end
end

local function GetFixedHuffmanBlockSize(p75, p76) -- line: 1771
    -- upvalues: t12 (copy), t16 (ref)
    local n36 = 3
    local n37 = 0

    for i = 1, #p75 do
        local v238 = p75[i]
        local v239 = n36 + t16[v238]
        local v240, v241

        if v238 > 256 then
            local v242 = n37 + 1
            local v243 = if v238 > 264 and v238 < 285 then v239 + t12[v238 - 256] else v239
            local v244 = p76[v242]

            v240 = v243 + 5
            v241 = v242

            if v244 > 3 then
                v240 += (v244 - v244 % 2) / 2 - 1
            end
        else
            v241 = n37
            v240 = v239
        end

        n37 = v241
        n36 = v240
    end

    return n36
end

local function CompressFixedHuffmanBlock(p77, p78, p79, p80, p81, p82) -- line: 1799
    -- upvalues: t12 (copy), v1 (ref), t16 (ref), v4 (ref)
    p77(p78 and 1 or 0, 1)
    p77(1, 2)

    local n38 = 0
    local n39 = 0
    local n40 = 0

    for i = 1, #p79 do
        local v246 = p79[i]

        p77(v1[v246], t16[v246])

        local v248, v249
        local v247 = n40

        if v246 > 256 then
            local v250 = n38 + 1
            local v251 = n39

            if v246 > 264 and v246 < 285 then
                v251 = n39 + 1
                p77(p80[v251], t12[v246 - 256])
            end

            v249 = v251

            local v252 = p81[v250]

            p77(v4[v252], 5)

            if v252 > 3 then
                v247 = n40 + 1
                p77(p82[v247], (v252 - v252 % 2) / 2 - 1)
            end

            v248 = v250
        else
            v248 = n38
            v249 = n39
        end

        n40 = v247
        n38 = v248
        n39 = v249
    end
end

local function GetStoreBlockSize(p83, p84, p85) -- line: 1847
    assert(p84 - p83 + 1 <= 65535)

    return 3 + (8 - (p85 + 3) % 8) % 8 + 32 + (p84 - p83 + 1) * 8
end

local function CompressStoreBlock(p86, p87, p88, p89, p90, p91, p92) -- line: 1861
    -- upvalues: t2 (copy)
    assert(p91 - p90 + 1 <= 65535)
    p86(p88 and 1 or 0, 1)
    p86(0, 2)

    local v255 = (8 - (p92 + 3) % 8) % 8

    if v255 > 0 then
        p86(t2[v255] - 1, v255)
    end

    local v256 = p91 - p90 + 1

    p86(v256, 16)
    p86(255 - v256 % 256 + (255 - (v256 - v256 % 256) / 256) * 256, 16)
    p87(p89:sub(p90, p91))
end

local function Deflate(p93, p94, p95, p96, p97, p98) -- line: 1899
    -- upvalues: LoadStringToTable (copy), GetBlockLZ77Result (copy), GetBlockDynamicHuffmanHeader (copy), GetDynamicHuffmanBlockSize (copy), CompressDynamicHuffmanBlock (copy), GetFixedHuffmanBlockSize (copy), CompressFixedHuffmanBlock (copy), CompressStoreBlock (copy)
    local t46 = {}
    local t47 = {}
    local v257 = p96(3)
    local v258 = #p97
    local v259, strategy

    if p93 then
        v259 = if p93.level then p93.level else nil

        if p93.strategy then
            strategy = p93.strategy
        end
    end

    if not v259 then
        v259 = if v258 < 2048 then 7 elseif v258 > 65536 then 3 else 5
    end

    local n41 = 0
    local n42 = 0
    local v261 = p98
    local v260

    while not v260 do
        local v262

        if n41 == 0 then
            n41 = 1
            n42 = 65535
            v262 = 0
        else
            n41 = n42 + 1
            n42 += 32768
            v262 = n41 - 32768 - 1
        end

        if v258 <= n42 then
            n42 = v258
            v260 = true
        else
            v260 = false
        end

        local v263 = {}
        local v264 = {}
        local v265 = {}
        local v266 = {}
        local v267 = {}
        local v268 = {}
        local v269 = {}
        local v270 = {}
        local v271 = {}
        local v272 = {}
        local v273 = {}
        local v274 = {}
        local v275, v276, v277, v278, v279

        if v259 ~= 0 then
            LoadStringToTable(p97, t46, n41, n42 + 3, v262)

            if n41 == 1 and v261 then
                local string_table, strlen = v261.string_table, v261.strlen

                for i = 0, if -strlen + 1 < -257 then -257 else -strlen + 1, -1 do
                    t46[i] = string_table[strlen + i]
                end
            end

            local v280, v281

            if strategy == "huffman_only" then
                v263 = {}
                LoadStringToTable(p97, v263, n41, n42, n41 - 1)
                v264 = {}
                v280 = {}
                v263[n42 - n41 + 2] = 256

                for i = 1, n42 - n41 + 2 do
                    local v282 = v263[i]

                    v280[v282] = (v280[v282] or 0) + 1
                end

                v265 = {}
                v266 = {}
                v281 = {}
            else
                v263, v264, v280, v265, v266, v281 = GetBlockLZ77Result(v259, t46, t47, n41, n42, v262, v261)
            end

            v275, v276, v277, v267, v268, v269, v270, v271, v272, v273, v274 = GetBlockDynamicHuffmanHeader(v280, v281)
            v279 = GetDynamicHuffmanBlockSize(v263, v265, v277, v267, v269, v271, v273)
            v278 = GetFixedHuffmanBlockSize(v263, v265)
        end

        assert(n42 - n41 + 1 <= 65535)

        local v284 = 3 + (8 - (v257 + 3) % 8) % 8 + 32 + (n42 - n41 + 1) * 8
        local v285 = if v278 and v278 < v284 then v278 else v284
        local v286 = if v279 and v279 < v285 then v279 else v285

        if v259 ~= 0 and (strategy == "fixed" or strategy == "dynamic" or v284 ~= v286) then
            if strategy ~= "dynamic" and (strategy == "fixed" or v278 == v286) then
                CompressFixedHuffmanBlock(p94, v260, v263, v264, v265, v266)
                v257 += assert(v278)
            elseif strategy == "dynamic" or v279 == v286 then
                CompressDynamicHuffmanBlock(p94, v260, v263, v264, v265, v266, v275, v276, v277, v267, v268, v269, v270, v271, v272, v273, v274)
                v257 += assert(v279)
            end
        else
            CompressStoreBlock(p94, p95, v260, p97, n41, n42, v257)
            v257 += v284
        end

        assert((if v260 then p96(3) else p96(0)) == v257)

        if not v260 then
            if v261 and n41 == 1 then
                local n43 = 0

                while t46[n43] do
                    t46[n43] = nil
                    n43 -= 1
                end
            end

            local v288 = n42 - 32767
            local n44 = 1

            for i = v288, n42 do
                t46[n44] = t46[i - v262]
                n44 += 1
            end

            v261 = nil

            for v289, v290 in pairs(t47) do
                local v291 = #v290

                if v291 > 0 and n42 + 1 - v290[1] > 32768 then
                    if v291 == 1 then
                        t47[v289] = nil
                    else
                        local t48 = {}
                        local n45 = 0

                        for j = 2, v291 do
                            local v292 = v290[j]

                            if n42 + 1 - v292 <= 32768 then
                                n45 += 1
                                t48[n45] = v292
                            end
                        end

                        t47[v289] = t48
                    end
                end
            end
        end
    end
end

local function CompressDeflateInternal(p99, p100, p101) -- line: 2123
    -- upvalues: CreateWriter (copy), Deflate (copy)
    local v293, v294, v295 = CreateWriter()

    Deflate(p101, v293, v294, v295, p99, p100)

    local v296, v297 = v295(1)

    assert(v297)

    return v297, (8 - v296 % 8) % 8
end

local function CompressZlibInternal(p102, p103, p104) -- line: 2134
    -- upvalues: t1 (copy), CreateWriter (copy), Deflate (copy)
    local v298, v299, v300 = CreateWriter()

    v298(120, 8)

    local v301 = if p103 then 1 else 0
    local v302 = 128 + v301 * 32

    v298(v302 + (31 - (30720 + v302) % 31), 8)

    if v301 == 1 then
        assert(p103)

        local adler32 = p103.adler32
        local v303 = adler32 % 256
        local v304 = (adler32 - v303) / 256
        local v305 = v304 % 256
        local v306 = (v304 - v305) / 256
        local v307 = v306 % 256

        v298((v306 - v307) / 256 % 256, 8)
        v298(v307, 8)
        v298(v305, 8)
        v298(v303, 8)
    end

    Deflate(p104, v298, v299, v300, p102, p103)
    v300(2)

    local v308 = t1:Adler32(p102)
    local v309 = v308 % 256
    local v310 = (v308 - v309) / 256
    local v311 = v310 % 256
    local v312 = (v310 - v311) / 256
    local v313 = v312 % 256

    v298((v312 - v313) / 256 % 256, 8)
    v298(v313, 8)
    v298(v311, 8)
    v298(v309, 8)

    local v314, v315 = v300(1)

    assert(v315)

    return v315, (8 - v314 % 8) % 8
end

function t1.CompressDeflate(_, p106, p107) -- line: 2205
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v316, v317 = IsValidArguments(p106, false, nil, true, p107)

    if not v316 then
        error("Usage: LibDeflate:CompressDeflate(str, configs): " .. v317, 2)
    end

    return CompressDeflateInternal(p106, nil, p107)
end

function t1.CompressDeflateWithDict(_, p109, p110, p111) -- line: 2229
    -- upvalues: IsValidArguments (copy), CompressDeflateInternal (copy)
    local v318, v319 = IsValidArguments(p109, true, p110, true, p111)

    if not v318 then
        error("Usage: LibDeflate:CompressDeflateWithDict" .. "(str, dictionary, configs): " .. v319, 2)
    end

    return CompressDeflateInternal(p109, p110, p111)
end

function t1.CompressZlib(_, p113, p114) -- line: 2247
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v320, v321 = IsValidArguments(p113, false, nil, true, p114)

    if not v320 then
        error("Usage: LibDeflate:CompressZlib(str, configs): " .. v321, 2)
    end

    return CompressZlibInternal(p113, nil, p114)
end

function t1.CompressZlibWithDict(_, p116, p117, p118) -- line: 2268
    -- upvalues: IsValidArguments (copy), CompressZlibInternal (copy)
    local v322, v323 = IsValidArguments(p116, true, p117, true, p118)

    if not v322 then
        error("Usage: LibDeflate:CompressZlibWithDict" .. "(str, dictionary, configs): " .. v323, 2)
    end

    return CompressZlibInternal(p116, p117, p118)
end

local function CreateReader(p119) -- line: 2296
    -- upvalues: byte (copy), char (copy), sub (copy), t2 (copy), t4 (copy)
    local v324 = #p119
    local n46 = 1
    local n47 = 0
    local n48 = 0

    return function(p120) -- ReadBits | line: 2309
        -- upvalues: p119 (copy), n46 (ref), n47 (ref), n48 (ref), byte (copy), t2 (copy)
        local v325 = t2[p120]

        if p120 <= n47 then
            local v326 = n48 % v325

            n48 = (n48 - v326) / v325
            n47 -= p120

            return v326
        end

        local v327 = t2[n47]
        local v328 = n46
        local v330, v331, v332, v333 = byte(p119, v328, n46 + 3)
        local v334 = n48

        n48 = v334 + ((v330 or 0) + (v331 or 0) * 256 + (v332 or 0) * 65536 + (v333 or 0) * 16777216) * v327
        n46 += 4
        n47 = n47 + 32 - p120

        local v335 = n48 % v325

        n48 = (n48 - v335) / v325

        return v335
    end, function(p121, p122, p123) -- ReadBytes | line: 2337
        -- upvalues: p119 (copy), v324 (copy), n46 (ref), n47 (ref), n48 (ref), char (copy), sub (copy)
        assert(n47 % 8 == 0)

        local v337 = n47 / 8 < p121 and n47 / 8 or p121
        local v338 = p123

        for _ = 1, v337 do
            local v339 = n48 % 256

            v338 += 1
            p122[v338] = char(v339)
            n48 = (n48 - v339) / 256
        end

        local v340 = n47

        n47 = v340 - v337 * 8

        local v341 = p121 - v337

        if (v324 - n46 - v341 + 1) * 8 + n47 < 0 then
            return -1
        end

        local v342 = n46

        for i = v342, n46 + v341 - 1 do
            v338 += 1
            p122[v338] = sub(p119, i, i)
        end

        n46 += v341

        return v338
    end, function(p124, p125, p126) -- Decode | line: 2372
        -- upvalues: p119 (copy), n46 (ref), n47 (ref), n48 (ref), byte (copy), t2 (copy), t4 (copy)
        local v343, v344, v345

        if p126 > 0 then
            if n47 < 15 and p119 then
                local v346 = t2[n47]
                local v347 = n46
                local v349, v350, v351, v352 = byte(p119, v347, n46 + 3)
                local v353 = n48

                n48 = v353 + ((v349 or 0) + (v350 or 0) * 256 + (v351 or 0) * 65536 + (v352 or 0) * 16777216) * v346
                n46 += 4
                n47 += 32
            end

            local v354 = t2[p126]

            n47 -= p126

            local v355 = n48 % v354

            n48 = (n48 - v355) / v354

            local v356 = t4[p126][v355]

            v343 = p124[p126]

            if v356 < v343 then
                return p125[v356]
            end

            v345 = v343 * 2
            v344 = v356 * 2
        else
            v344 = 0
            v345 = 0
            v343 = 0
        end

        for i = p126 + 1, 15 do
            local v357 = n48 % 2

            n48 = (n48 - v357) / 2
            n47 -= 1
            v344 = v357 == 1 and v344 + 1 - v344 % 2 or v344

            local v358 = p124[i] or 0
            local v359 = v344 - v345

            if v359 < v358 then
                return p125[v343 + v359]
            end

            v343 += v358
            v345 = (v345 + v358) * 2
            v344 *= 2
        end

        return -10
    end, function() -- ReaderBitlenLeft | line: 2431
        -- upvalues: v324 (copy), n46 (ref), n47 (ref)
        return (v324 - n46 + 1) * 8 + n47
    end, function() -- SkipToByteBoundary | line: 2435
        -- upvalues: n47 (ref), n48 (ref), t2 (copy)
        local v360 = n47 % 8
        local v361 = t2[v360]

        n47 -= v360

        local v362 = n48

        n48 = (v362 - n48 % v361) / v361
    end
end

local function CreateDecompressState(p127, p128) -- line: 2450
    -- upvalues: CreateReader (copy)
    local v363, v364, v365, v366, v367 = CreateReader(p127)

    return {
        buffer_size = 0,
        ReadBits = v363,
        ReadBytes = v364,
        Decode = v365,
        ReaderBitlenLeft = v366,
        SkipToByteBoundary = v367,
        buffer = {},
        result_buffer = {},
        dictionary = p128
    }
end

local function GetHuffmanForDecode(p129, p130, p131) -- line: 2475
    local t49 = {}
    local v368 = p131

    for i = 0, p130 do
        local v369 = p129[i] or 0

        if v369 > 0 and v369 < v368 and v369 then
            v368 = v369
        end

        t49[v369] = (t49[v369] or 0) + 1
    end

    if t49[0] == p130 + 1 then
        return 0, t49, {}, 0
    end

    local n49 = 1

    for i = 1, p131 do
        n49 = n49 * 2 - (t49[i] or 0)

        if n49 < 0 then
            return n49, {}, {}, 0
        end
    end

    local t50 = {
        0
    }

    for i = 1, p131 - 1 do
        t50[i + 1] = t50[i] + (t49[i] or 0)
    end

    local t51 = {}

    for i = 0, p130 do
        local v370 = p129[i] or 0

        if v370 ~= 0 then
            t51[t50[v370]] = i
            t50[v370] += 1
        end
    end

    return n49, t49, t51, v368
end

local function DecodeUntilEndOfBlock(p132, p133, p134, p135, p136, p137, p138) -- line: 2541
    -- upvalues: concat (copy), t3 (copy), t11 (copy), t12 (copy), t13 (copy), t14 (copy)
    local buffer, buffer_size, ReadBits, Decode = p132.buffer, p132.buffer_size, p132.ReadBits, p132.Decode
    local ReaderBitlenLeft, result_buffer, dictionary = p132.ReaderBitlenLeft, p132.result_buffer, p132.dictionary
    local t52 = {}
    local string_table, strlen, v371, v372, v374, strlen2, v375
    local v373 = buffer_size

    if not dictionary or buffer[0] then
        v375 = t52
        v374 = 1
    else
        string_table = dictionary.string_table
        strlen = dictionary.strlen
        v371 = -strlen + 1
        v372 = if -strlen + 1 < -257 then -257 else -strlen + 1
        v375 = string_table
        strlen2 = strlen
        v374 = v371

        for i = 0, v372, -1 do
            v374 = v371
            buffer[i] = t3[string_table[strlen + i]]
            v373 = buffer_size
            v375 = string_table
            strlen2 = strlen
        end
    end

    while true do
        local v376 = Decode(p133, p134, p135)

        if v376 < 0 or v376 > 285 then
            break
        end

        local v377, v378

        if v376 < 256 then
            v378 = v376
            v377 = v373 + 1
            buffer[v377] = t3[v376]
        elseif v376 > 256 then
            local v379 = v376 - 256
            local v380 = t11[v379]

            if v379 >= 8 then
                v380 = v380 + ReadBits(t12[v379]) or v380
            end

            v378 = Decode(p136, p137, p138)

            if v378 < 0 or v378 > 29 then
                return -10
            end

            local v381 = t13[v378]

            if v381 > 4 then
                v381 = v381 + ReadBits(t14[v378]) or v381
            end

            local v382 = v373 - v381 + 1

            if v382 < v374 then
                return -11
            end

            v377 = v373

            if v382 >= -257 then
                for _ = 1, v380 do
                    v377 += 1
                    buffer[v377] = buffer[v382]
                    v382 += 1
                end
            else
                local v383 = strlen2 + v382

                for _ = 1, v380 do
                    v377 += 1
                    buffer[v377] = t3[v375[v383]]
                    v383 += 1
                end
            end
        else
            v378 = v376
            v377 = v373
        end

        if ReaderBitlenLeft() < 0 then
            return 2
        end

        if v377 >= 65536 then
            result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768)

            for i = 32769, v377 do
                buffer[i - 32768] = buffer[i]
            end

            v373 = v377 - 32768
            buffer[v373 + 1] = nil
        else
            v373 = v377
        end

        if v378 == 256 then
            p132.buffer_size = v373

            return 0
        end
    end

    return -10
end

local function DecompressStoreBlock(p139) -- line: 2634
    -- upvalues: concat (copy)
    local buffer, buffer_size, ReadBits, ReadBytes = p139.buffer, p139.buffer_size, p139.ReadBits, p139.ReadBytes
    local ReaderBitlenLeft, SkipToByteBoundary, result_buffer = p139.ReaderBitlenLeft, p139.SkipToByteBoundary, p139.result_buffer

    SkipToByteBoundary()

    local v384 = ReadBits(16)

    if ReaderBitlenLeft() < 0 then
        return 2
    end

    local v385 = ReadBits(16)

    if ReaderBitlenLeft() < 0 then
        return 2
    end

    if v384 % 256 + v385 % 256 ~= 255 or (v384 - v384 % 256) / 256 + (v385 - v385 % 256) / 256 ~= 255 then
        return -2
    end

    local v386 = ReadBytes(v384, buffer, buffer_size)

    if v386 < 0 then
        return 2
    end

    if v386 >= 65536 then
        result_buffer[#result_buffer + 1] = concat(buffer, "", 1, 32768)

        for i = 32769, v386 do
            buffer[i - 32768] = buffer[i]
        end

        v386 -= 32768
        buffer[v386 + 1] = nil
    end

    p139.buffer_size = v386

    return 0
end

local function DecompressFixBlock(p140) -- line: 2683
    -- upvalues: v2 (ref), v3 (ref), v5 (ref), v6 (ref), DecodeUntilEndOfBlock (copy)
    return (DecodeUntilEndOfBlock(p140, v3, v2, 7, v6, v5, 5))
end

local function DecompressDynamicBlock(p141) -- line: 2698
    -- upvalues: t15 (copy), GetHuffmanForDecode (copy), DecodeUntilEndOfBlock (copy)
    local ReadBits, Decode = p141.ReadBits, p141.Decode
    local v387 = ReadBits(5) + 257
    local v388 = ReadBits(5) + 1
    local v389 = ReadBits(4) + 4

    if v387 > 286 or v388 > 30 then
        return -3
    end

    local t53 = {}

    for i = 1, v389 do
        t53[t15[i]] = ReadBits(3)
    end

    local v390, v391, v392, v393 = GetHuffmanForDecode(t53, 18, 7)

    if v390 ~= 0 then
        return -4
    end

    local t54 = {}
    local t55 = {}
    local n50 = 0

    while n50 < v387 + v388 do
        local v394 = Decode(v391, v392, v393)

        if v394 < 0 then
            return v394
        end

        if v394 < 16 then
            if n50 < v387 then
                t54[n50] = v394
            else
                t55[n50 - v387] = v394
            end

            n50 += 1
        else
            local v395, v396

            if v394 == 16 then
                if n50 == 0 then
                    return -5
                end

                v396 = if n50 - 1 < v387 then t54[n50 - 1] else t55[n50 - v387 - 1]
                v395 = 3 + ReadBits(2)
            else
                v395 = if v394 == 17 then 3 + ReadBits(3) else 11 + ReadBits(7)
                v396 = 0
            end

            if n50 + v395 > v387 + v388 then
                return -6
            end

            while v395 > 0 do
                v395 -= 1

                if n50 < v387 then
                    t54[n50] = v396
                else
                    t55[n50 - v387] = v396
                end

                n50 += 1
            end
        end
    end

    if (t54[256] or 0) == 0 then
        return -9
    end

    local v397, v398, v399, v400 = GetHuffmanForDecode(t54, v387 - 1, 15)

    if v397 ~= 0 and (v397 < 0 or v387 ~= (v398[0] or 0) + (v398[1] or 0)) then
        return -7
    end

    local v401, v402, v403, v404 = GetHuffmanForDecode(t55, v388 - 1, 15)

    if v401 ~= 0 and (v401 < 0 or v388 ~= (v402[0] or 0) + (v402[1] or 0)) then
        return -8
    end

    return (DecodeUntilEndOfBlock(p141, v398, v399, v400, v402, v403, v404))
end

local function Inflate(p142) -- line: 2818
    -- upvalues: concat (copy), v2 (ref), v3 (ref), v5 (ref), v6 (ref), DecodeUntilEndOfBlock (copy), DecompressStoreBlock (copy), DecompressDynamicBlock (copy)
    local ReadBits = p142.ReadBits
    local v405

    while true do
        if v405 then
            p142.result_buffer[#p142.result_buffer + 1] = concat(p142.buffer, "", 1, p142.buffer_size)

            return concat(p142.result_buffer), 0
        end

        v405 = ReadBits(1) == 1

        local v406 = ReadBits(2)
        local v407

        if v406 == 0 then
            v407 = DecompressStoreBlock(p142)
        elseif v406 == 1 then
            v407 = DecodeUntilEndOfBlock(p142, v3, v2, 7, v6, v5, 5)
        elseif v406 == 2 then
            v407 = DecompressDynamicBlock(p142)
        else
            break
        end

        if v407 ~= 0 then
            return nil, v407
        end
    end

    return nil, -1
end

local function DecompressDeflateInternal(p143, p144) -- line: 2847
    -- upvalues: CreateDecompressState (copy), Inflate (copy)
    local v408 = CreateDecompressState(p143, p144)
    local v409, v410 = Inflate(v408)

    if not v409 then
        return nil, v410
    end

    local v411 = v408.ReaderBitlenLeft()

    return v409, (v411 - v411 % 8) / 8
end

local function DecompressZlibInternal(p145, p146) -- line: 2861
    -- upvalues: t1 (copy), CreateDecompressState (copy), Inflate (copy)
    local v412 = CreateDecompressState(p145, p146)
    local ReadBits = v412.ReadBits
    local v413 = ReadBits(8)

    if v412.ReaderBitlenLeft() < 0 then
        return nil, 2
    end

    local v414 = v413 % 16
    local v415 = (v413 - v414) / 16

    if v414 ~= 8 then
        return nil, -12
    end

    if v415 > 7 then
        return nil, -13
    end

    local v416 = ReadBits(8)

    if v412.ReaderBitlenLeft() < 0 then
        return nil, 2
    end

    if (v413 * 256 + v416) % 31 ~= 0 then
        return nil, -14
    end

    local v417 = (v416 - v416 % 32) / 32 % 2
    local _ = (v416 - v416 % 64) / 64 % 4

    if v417 == 1 then
        if not p146 then
            return nil, -16
        end

        local v418 = ReadBits(8)
        local v419 = ReadBits(8)
        local v420 = ReadBits(8)
        local v421 = ReadBits(8)
        local v422 = v418 * 16777216 + v419 * 65536 + v420 * 256 + v421

        if v412.ReaderBitlenLeft() < 0 then
            return nil, 2
        end

        local adler32 = p146.adler32

        if v422 % 4294967296 ~= adler32 % 4294967296 then
            return nil, -17
        end
    end

    local v423, v424 = Inflate(v412)

    if not v423 then
        return nil, v424
    end

    v412.SkipToByteBoundary()

    local v425 = ReadBits(8)
    local v426 = ReadBits(8)
    local v427 = ReadBits(8)
    local v428 = ReadBits(8)

    if v412.ReaderBitlenLeft() < 0 then
        return nil, 2
    end

    local v429 = v425 * 16777216 + v426 * 65536 + v427 * 256 + v428
    local v430 = t1:Adler32(v423)

    if v429 % 4294967296 ~= v430 % 4294967296 then
        return nil, -15
    end

    local v431 = v412.ReaderBitlenLeft()

    return v423, (v431 - v431 % 8) / 8
end

function t1.DecompressDeflate(_, p148) -- line: 2943
    -- upvalues: DecompressDeflateInternal (copy)
    local v432, v433

    if type(p148) == "string" then
        v432 = true
        v433 = ""
    else
        v432 = false
        v433 = ("'str' - string expected got '%s'."):format((type(p148)))
    end

    if not v432 then
        error("Usage: LibDeflate:DecompressDeflate(str): " .. v433, 2)
    end

    return DecompressDeflateInternal(p148)
end

function t1.DecompressDeflateWithDict(_, p150, p151) -- line: 2969
    -- upvalues: IsValidDictionary (copy), DecompressDeflateInternal (copy)
    local v434, v435

    if type(p150) == "string" then
        local v436

        v436, v434 = IsValidDictionary(p151)

        if v436 then
            v435 = true
            v434 = ""
        else
            v435 = false
        end
    else
        v435 = false
        v434 = ("'str' - string expected got '%s'."):format((type(p150)))
    end

    if not v435 then
        error("Usage: LibDeflate:DecompressDeflateWithDict(str, dictionary): " .. v434, 2)
    end

    return DecompressDeflateInternal(p150, p151)
end

function t1.DecompressZlib(_, p153) -- line: 2990
    -- upvalues: DecompressZlibInternal (copy)
    local v437, v438

    if type(p153) == "string" then
        v437 = true
        v438 = ""
    else
        v437 = false
        v438 = ("'str' - string expected got '%s'."):format((type(p153)))
    end

    if not v437 then
        error("Usage: LibDeflate:DecompressZlib(str): " .. v438, 2)
    end

    return DecompressZlibInternal(p153)
end

function t1.DecompressZlibWithDict(_, p155, p156) -- line: 3016
    -- upvalues: IsValidDictionary (copy), DecompressZlibInternal (copy)
    local v439, v440

    if type(p155) == "string" then
        local v441

        v441, v439 = IsValidDictionary(p156)

        if v441 then
            v440 = true
            v439 = ""
        else
            v440 = false
        end
    else
        v440 = false
        v439 = ("'str' - string expected got '%s'."):format((type(p155)))
    end

    if not v440 then
        error("Usage: LibDeflate:DecompressZlibWithDict(str, dictionary): " .. v439, 2)
    end

    return DecompressZlibInternal(p155, p156)
end

t16 = {}

for i = 0, 143 do
    local t56 = t16

    t56[i] = 8
end

for i = 144, 255 do
    local t57 = t16

    t57[i] = 9
end

t16[256] = 7
t16[257] = 7
t16[258] = 7
t16[259] = 7
t16[260] = 7
t16[261] = 7
t16[262] = 7
t16[263] = 7
t16[264] = 7
t16[265] = 7
t16[266] = 7
t16[267] = 7
t16[268] = 7
t16[269] = 7
t16[270] = 7
t16[271] = 7
t16[272] = 7
t16[273] = 7
t16[274] = 7
t16[275] = 7
t16[276] = 7
t16[277] = 7
t16[278] = 7
t16[279] = 7
t16[280] = 8
t16[281] = 8
t16[282] = 8
t16[283] = 8
t16[284] = 8
t16[285] = 8
t16[286] = 8
t16[287] = 8

local t58 = {}

for i = 0, 31 do
    t58[i] = 5
end

local v442, v443, v444 = GetHuffmanForDecode(t16, 287, 9)

v3 = v443
v2 = v444
assert(v442 == 0)

local v446, v447

v442, v446, v447 = GetHuffmanForDecode(t58, 31, 5)
v6 = v446
v5 = v447
assert(v442 == 0)
v1 = GetHuffmanCodeFromBitlen(v3, t16, 287, 9)
v4 = GetHuffmanCodeFromBitlen(v6, t58, 31, 5)

local t59 = {
    ["\000"] = "%z",
    ["("] = "%(",
    [")"] = "%)",
    ["."] = "%.",
    ["%"] = "%%",
    ["+"] = "%+",
    ["-"] = "%-",
    ["*"] = "%*",
    ["?"] = "%?",
    ["["] = "%[",
    ["]"] = "%]",
    ["^"] = "%^",
    ["$"] = "%$"
}

local function escape_for_gsub(p157) -- line: 3084
    -- upvalues: t59 (copy)
    return (p157:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59))
end

function t1.CreateCodec(_, p159, p160, p161) -- line: 3129
    -- upvalues: byte (copy), find (copy), gsub (copy), sub (copy), concat (copy), t3 (copy), t59 (copy)
    if type(p159) ~= "string" or type(p160) ~= "string" or type(p161) ~= "string" then
        error("Usage: LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars): All arguments must be string.", 2)
    end

    if p160 == "" then
        return nil, "No escape characters supplied."
    end

    if #p159 < #p161 then
        return nil, "The number of reserved characters must be at least as many as the number of mapped chars."
    end

    if p159 == "" then
        return nil, "No characters to encode."
    end

    local v448 = p159 .. p160 .. p161
    local t60 = {}

    for i = 1, #v448 do
        local v449 = byte(v448, i, i)

        if t60[v449] then
            return nil, "There must be no duplicate characters in the concatenation of reserved_chars, escape_chars and map_chars."
        end

        t60[v449] = true
    end

    local t61 = {}
    local t62 = {}
    local t63 = {}
    local t64 = {}

    if #p161 > 0 then
        local t65 = {}
        local t66 = {}

        for i = 1, #p161 do
            local v450 = sub(p159, i, i)
            local v451 = sub(p161, i, i)

            t64[v450] = v451
            t63[#t63 + 1] = v450
            t66[v451] = v450
            t65[#t65 + 1] = v451
        end

        t61[#t61 + 1] = "([" .. concat(t65):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59) .. "])"
        t62[#t62 + 1] = t66
    end

    local v454 = sub(p160, 1, 1)
    local t67 = {}
    local t68 = {}
    local n51 = 1
    local n52 = 0

    for i = 1, #v448 do
        local v456 = sub(v448, i, i)

        if not t64[v456] then
            while true do
                local v457, v458, v459

                if n52 >= 256 then
                    n52 += 1

                    if n52 > 255 then
                        v457 = #t61 + 1
                        v458 = v454:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59)
                        v459 = concat(t67):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59)
                        t61[v457] = v458 .. "([" .. v459 .. "])"
                        t62[#t62 + 1] = t68
                        n51 += 1
                        v454 = sub(p160, n51, n51)
                        t67 = {}
                        t68 = {}

                        if not v454 or v454 == "" then
                            return nil, "Out of escape characters."
                        end

                        n52 = 0
                    end

                    continue
                end

                if t60[n52] then
                    n52 += 1

                    if n52 > 255 then
                        v457 = #t61 + 1
                        v458 = v454:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59)
                        v459 = concat(t67):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59)
                        t61[v457] = v458 .. "([" .. v459 .. "])"
                        t62[#t62 + 1] = t68
                        n51 += 1
                        v454 = sub(p160, n51, n51)
                        t67 = {}
                        t68 = {}

                        if not v454 or v454 == "" then
                            return nil, "Out of escape characters."
                        end

                        n52 = 0
                    end

                    continue
                end

                break
            end

            local v460 = t3[n52]

            t64[v456] = v454 .. v460
            t63[#t63 + 1] = v456
            t68[v460] = v456
            t67[#t67 + 1] = v460
            n52 += 1
        end

        if i == #v448 then
            t61[#t61 + 1] = v454:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59) .. "([" .. concat(t67):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59) .. "])"
            t62[#t62 + 1] = t68
        end
    end

    local v464 = "([" .. concat(t63):gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59) .. "])"
    local t69 = {}

    function t69.Encode(_, p163) -- line: 3243
        -- upvalues: t64 (copy), v464 (copy), gsub (copy)
        if type(p163) ~= "string" then
            error(("Usage: codec:Encode(str): 'str' - string expected got '%s'."):format((type(p163))), 2)
        end

        return (gsub(p163, v464, t64))
    end

    local v465 = #t61
    local v466 = "([" .. p159:gsub("([%z%(%)%.%%%+%-%*%?%[%]%^%$])", t59) .. "])"

    function t69.Decode(_, p165) -- line: 3254
        -- upvalues: t61 (copy), t62 (copy), v465 (copy), v466 (copy), find (copy), gsub (copy)
        if type(p165) ~= "string" then
            error(("Usage: codec:Decode(str): 'str' - string expected got '%s'."):format((type(p165))), 2)
        end

        if find(p165, v466) then
            return nil
        end

        local v467 = p165

        for i = 1, v465 do
            v467 = gsub(v467, t61[i], t62[i])
        end

        return v467
    end

    return t69, ""
end

t1.internals = {
    LoadStringToTable = LoadStringToTable,
    IsValidDictionary = IsValidDictionary,
    IsEqualAdler32 = IsEqualAdler32
}

return table.freeze(t1)
