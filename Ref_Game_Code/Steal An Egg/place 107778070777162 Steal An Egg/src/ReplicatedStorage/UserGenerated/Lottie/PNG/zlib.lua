-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 13, 15, 17, 19, 23, 27, 31,
    35, 43, 51, 59, 67, 83, 99, 115,
    131, 163, 195, 227, 258
}
local t2 = {
    1, 1, 1, 1, 2, 2, 2, 2,
    3, 3, 3, 3, 4, 4, 4, 4,
    5, 5, 5, 5, 0
}
local t3 = {
    1, 2, 3, 4, 5, 7, 9, 13,
    17, 25, 33, 49, 65, 97, 129, 193,
    257, 385, 513, 769, 1025, 1537, 2049, 3073,
    4097, 6145, 8193, 12289, 16385, 24577
}
local t4 = {
    0, 0, 0, 1, 1, 2, 2, 3,
    3, 4, 4, 5, 5, 6, 6, 7,
    7, 8, 8, 9, 9, 10, 10, 11,
    11, 12, 12, 13, 13
}
local t5 = {
    16, 17, 18, 0, 8, 7, 9, 6,
    10, 5, 11, 4, 12, 3, 13, 2,
    14, 1, 15
}
local t6 = {
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    8, 8, 8, 8, 8, 8, 8, 8,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 9, 9,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    7, 7, 7, 7, 7, 7, 7, 7,
    8, 8, 8, 8, 8, 8, 8, 8
}

local function createHuffmanTable(p1) -- line: 56
    local v1 = table.create(15, 0)

    v1[0] = 0

    for _, v2 in p1 do
        if v2 > 0 then
            v1[v2] = (v1[v2] or 0) + 1
        end
    end

    local v3 = table.create(15)
    local n1 = 1

    for i = 1, 15 do
        n1 = bit32.lshift(n1 + v1[i - 1], 1)
        v3[i] = n1
    end

    local t7 = {}
    local t8 = {}
    local t9 = {}

    for v5, v6 in p1 do
        if v6 > 0 then
            t7[v3[v6]] = v5 - 1
            t8[v5 - 1] = bit32.extract(v3[v6], 0, v6)
            t9[v5 - 1] = v6
            v3[v6] += 1
        end
    end

    return t7, t8, t9
end

local t10 = {}
local t11 = {}
local t12 = {}

for i = 3, 258 do
    local v9 = #t1
    local v10

    for j = v9, 1, -1 do
        if t1[j] <= i then
            v10 = j
            break
        end
    end

    t10[i] = 256 + v10
    t11[i] = i - t1[v10]
    t12[i] = t2[v10 - 8] or 0
end

local t13 = {}

for i = 1, 1024 do
    local v11 = #t3
    local v12

    for j = v11, 1, -1 do
        if t3[j] <= i then
            v12 = j
            break
        end
    end

    t13[i] = v12
end

local v13, v14, v15 = createHuffmanTable(t6)
local v16, v17, v18 = createHuffmanTable(table.create(32, 5))

local function getStoreSize(p2) -- line: 118
    return math.ceil(p2 / 32768) * 5 + p2
end

local function getDistIdx(p3) -- line: 122
    -- upvalues: t13 (copy)
    if p3 < 1025 then
        return t13[p3]
    end

    if p3 < 1537 then
        return 21
    end

    if p3 < 2049 then
        return 22
    end

    if p3 < 3073 then
        return 23
    end

    if p3 < 4097 then
        return 24
    end

    if p3 < 6145 then
        return 25
    end

    if p3 < 8193 then
        return 26
    end

    if p3 < 12289 then
        return 27
    end

    if p3 < 16385 then
        return 28
    end

    if p3 < 24577 then
        return 29
    end

    return 30
end

local function adler32(p4, p5, p6) -- line: 139
    local v20 = p5 + p6 - 1
    local n2 = 1
    local n3 = 0
    local n4 = 0

    for i = p5, v20 do
        n2 += buffer.readu8(p4, i)
        n3 += n2
        n4 += 1

        if n4 == 8400000 then
            n2 %= 65521
            n3 %= 65521
            n4 = 0
        end
    end

    return (bit32.bor(bit32.lshift(n3 % 65521, 16), n2 % 65521))
end

return {
    inflate = function(p7, p8) -- inflate | line: 156
        -- upvalues: t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), createHuffmanTable (copy), v13 (copy), v16 (copy), adler32 (copy)
        local v24 = buffer.readu8(p7, 0)
        local v25 = buffer.readu8(p7, 1)

        assert(bit32.extract(v24, 0, 4) == 8, "invalid zlib comp method")
        assert(bit32.extract(v24, 4, 4) <= 7, "invalid zlib window size")
        assert(bit32.extract(v25, 5, 1) == 0, "preset dictionary is not allowed")

        local v27 = bit32.lshift(v24, 8)
        local v26 = bit32.bor(v27, v25) % 31 == 0

        assert(v26, "zlib header sum mismatch")

        local n5 = 2
        local n6 = 0

        local function readBit() -- line: 167
            -- upvalues: p7 (copy), n5 (ref), n6 (ref)
            local v31 = bit32.extract(buffer.readu8(p7, n5), n6)

            n6 += 1

            if n6 == 8 then
                n6 = 0
                n5 += 1
            end

            return v31
        end

        local function readBits(p9) -- line: 177
            -- upvalues: p7 (copy), n5 (ref), n6 (ref)
            local v32 = buffer.readbits(p7, n5 * 8 + n6, p9)

            n6 += p9

            local v33 = n5

            n5 = v33 + bit32.rshift(n6, 3)
            n6 = bit32.band(n6, 7)

            return v32
        end

        local function readHuffmanTable(p10) -- line: 185
            -- upvalues: p7 (copy), n5 (ref), n6 (ref)
            local v39 = bit32.extract(buffer.readu8(p7, n5), n6)

            n6 += 1

            if n6 == 8 then
                n6 = 0
                n5 += 1
            end

            local v40 = 2 + v39

            while not p10[v40] do
                local v41 = 2 * v40
                local v45 = bit32.extract(buffer.readu8(p7, n5), n6)

                n6 += 1

                if n6 == 8 then
                    n6 = 0
                    n5 += 1
                end

                v40 = v41 + v45
            end

            return p10[v40]
        end

        local n7 = 0
        local v46, v47, v48

        repeat
            v46 = buffer.readu8(p7, n5)
            v27 = bit32.extract(v46, n6)
            n6 += 1

            if n6 == 8 then
                n6 = 0
                n5 += 1
            end

            v46 = buffer.readbits(p7, n5 * 8 + n6, 2)
            n6 += 2
            v47 = bit32.rshift(n6, 3)

            local v52 = n5 + v47

            n5 = v52
            n6 = bit32.band(n6, 7)

            local v54 = v46 ~= 3

            assert(v54, "reserved btype")

            if v46 == 0 then
                if n6 > 0 then
                    n5 += 1
                    n6 = 0
                end

                v47 = buffer.readu16(p7, n5)
                v48 = bit32.bxor(v47, (buffer.readu16(p7, n5 + 2))) == 65535
                assert(v48, "len ~= nlen")
                n5 += 4
                buffer.copy(p8, n7, p7, n5, v47)
                n7 += v47
                n5 += v47
            else
                v47 = v13
                v54 = v16

                local v58, v59, v60, v61, v62, v63, v64, v65

                if v46 == 2 then
                    v58 = buffer.readbits(p7, n5 * 8 + n6, 5)
                    n6 += 5
                    v59 = bit32.rshift(n6, 3)
                    n5 += v59
                    n6 = bit32.band(n6, 7)
                    v48 = v58 + 257
                    v59 = buffer.readbits(p7, n5 * 8 + n6, 5)
                    n6 += 5
                    v61 = bit32.rshift(n6, 3)
                    n5 += v61
                    n6 = bit32.band(n6, 7)
                    v58 = v59 + 1
                    v61 = buffer.readbits(p7, n5 * 8 + n6, 4)
                    n6 += 4
                    v60 = bit32.rshift(n6, 3)
                    v52 = n5 + v60
                    n5 = v52
                    n6 = bit32.band(n6, 7)
                    v59 = v61 + 4
                    v61 = table.create(19, 0)

                    local v72, v73

                    for i = 1, v59 do
                        v62 = t5[i] + 1
                        v72 = buffer.readbits(p7, n5 * 8 + n6, 3)
                        n6 += 3
                        v73 = bit32.rshift(n6, 3)
                        v52 = n5 + v73
                        n5 = v52
                        n6 = bit32.band(n6, 7)
                        v61[v62] = v72
                    end

                    v60 = createHuffmanTable(v61)
                    v61 = table.create(v48)
                    v63 = nil

                    repeat
                        v73 = buffer.readu8(p7, n5)
                        v72 = bit32.extract(v73, n6)
                        n6 += 1

                        if n6 == 8 then
                            n6 = 0
                            v52 = n5 + 1
                            n5 = v52
                        end

                        v64 = 2 + v72

                        while not v60[v64] do
                            v62 = 2 * v64
                            v73 = buffer.readu8(p7, n5)
                            v72 = bit32.extract(v73, n6)
                            n6 += 1

                            if n6 == 8 then
                                n6 = 0
                                v52 = n5 + 1
                                n5 = v52
                            end

                            v64 = v62 + v72
                        end

                        v65 = v60[v64]

                        if v65 <= 15 then
                            v63 = v65
                            v64 = 1
                        elseif v65 == 16 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 2)
                            n6 += 2
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v64 = v62 + 3
                        elseif v65 == 17 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 3)
                            n6 += 3
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v63 = 0
                            v64 = v62 + 3
                        elseif v65 == 18 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 7)
                            n6 += 7
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v63 = 0
                            v64 = v62 + 11
                        else
                            v64 = 1
                        end

                        for _ = 1, v64 do
                            table.insert(v61, v63)
                        end
                    until v48 <= #v61

                    v47 = createHuffmanTable(v61)
                    v63 = table.create(v58)
                    v65 = nil

                    repeat
                        v72 = buffer.readu8(p7, n5)
                        v62 = bit32.extract(v72, n6)
                        n6 += 1

                        if n6 == 8 then
                            n6 = 0
                            v52 = n5 + 1
                            n5 = v52
                        end

                        v48 = 2 + v62

                        while not v60[v48] do
                            v64 = 2 * v48
                            v72 = buffer.readu8(p7, n5)
                            v62 = bit32.extract(v72, n6)
                            n6 += 1

                            if n6 == 8 then
                                n6 = 0
                                v52 = n5 + 1
                                n5 = v52
                            end

                            v48 = v64 + v62
                        end

                        v61 = v60[v48]

                        if v61 <= 15 then
                            v65 = v61
                            v64 = 1
                        elseif v61 == 16 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 2)
                            n6 += 2
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v64 = v62 + 3
                        elseif v61 == 17 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 3)
                            n6 += 3
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v65 = 0
                            v64 = v62 + 3
                        elseif v61 == 18 then
                            v62 = buffer.readbits(p7, n5 * 8 + n6, 7)
                            n6 += 7
                            v72 = bit32.rshift(n6, 3)
                            v52 = n5 + v72
                            n5 = v52
                            n6 = bit32.band(n6, 7)
                            v65 = 0
                            v64 = v62 + 11
                        else
                            v64 = 1
                        end

                        for _ = 1, v64 do
                            table.insert(v63, v65)
                        end
                    until v58 <= #v63

                    v54 = createHuffmanTable(v63)
                end

                while true do
                    v65 = buffer.readu8(p7, n5)
                    v60 = bit32.extract(v65, n6)
                    v26 = n6 + 1
                    n6 = v26

                    if n6 == 8 then
                        n6 = 0
                        v52 = n5 + 1
                        n5 = v52
                        v26 = 0
                    end

                    v59 = 2 + v60

                    while not v47[v59] do
                        v61 = 2 * v59
                        v65 = buffer.readu8(p7, n5)
                        v60 = bit32.extract(v65, n6)
                        v26 = n6 + 1
                        n6 = v26

                        if n6 == 8 then
                            n6 = 0
                            v52 = n5 + 1
                            n5 = v52
                            v26 = 0
                        end

                        v59 = v61 + v60
                    end

                    v48 = v47[v59]

                    local v100, v101

                    if v48 < 256 then
                        buffer.writeu8(p8, n7, v48)
                        v101 = v52

                        local v102 = v26

                        v100 = n7 + 1
                    elseif v48 > 256 then
                        local v103 = t1[v48 - 256]
                        local v104

                        if v48 > 268 then
                            v61 = t2[v48 - 264]
                            v60 = buffer.readbits(p7, n5 * 8 + n6, v61)
                            n6 += v61
                            v63 = bit32.rshift(n6, 3)
                            v104 = n5 + v63
                            n5 = v104
                            n6 = bit32.band(n6, 7)
                            v103 += v60
                        else
                            v104 = v52

                            if v48 > 264 then
                                v61 = buffer.readu8(p7, n5)
                                v59 = bit32.extract(v61, n6)
                                n6 += 1

                                if n6 == 8 then
                                    n6 = 0
                                    v104 = n5 + 1
                                    n5 = v104
                                end

                                v103 += v59
                            end
                        end

                        v62 = buffer.readu8(p7, n5)
                        v64 = bit32.extract(v62, n6)

                        local v111 = n6 + 1

                        n6 = v111

                        if n6 == 8 then
                            n6 = 0
                            v101 = n5 + 1
                            n5 = v101
                            v111 = 0
                        else
                            v101 = v104
                        end

                        v60 = 2 + v64

                        while not v54[v60] do
                            v65 = 2 * v60
                            v62 = buffer.readu8(p7, n5)
                            v64 = bit32.extract(v62, n6)
                            v111 = n6 + 1
                            n6 = v111

                            if n6 == 8 then
                                n6 = 0
                                v101 = n5 + 1
                                n5 = v101
                                v111 = 0
                            end

                            v60 = v65 + v64
                        end

                        v59 = v54[v60]
                        v61 = t3[v59 + 1]

                        local v114, v115, v116

                        if v59 > 5 then
                            v65 = t4[v59]
                            v64 = buffer.readbits(p7, n5 * 8 + n6, v65)
                            n6 += v65
                            v115 = bit32.rshift(n6, 3)
                            v114 = n5 + v115
                            n5 = v114
                            v115 = bit32.band(n6, 7)
                            n6 = v115
                            v116 = v61 + v64
                        elseif v59 > 3 then
                            v65 = buffer.readu8(p7, n5)

                            local v121 = bit32.extract(v65, n6)
                            local v122 = n6 + 1

                            n6 = v122

                            local v123 = v101

                            if n6 == 8 then
                                n6 = 0
                                v123 = n5 + 1
                                n5 = v123
                                v122 = 0
                            end

                            v114 = v123
                            v115 = v122
                            v116 = v61 + v121
                        else
                            v116 = v61
                            v114 = v101
                            v115 = v111
                        end

                        if v103 <= v116 then
                            buffer.copy(p8, n7, p8, n7 - v116, v103)
                            v101 = v114
                            v111 = v115
                            v100 = n7 + v103
                        else
                            v100 = n7
                            v58 = v103
                            v61 = v116

                            repeat
                                v60 = math.min(v58, v61)
                                buffer.copy(p8, v100, p8, v100 - v61, v60)
                                v100 += v60
                                v58 -= v60
                                v61 += v60
                                v101 = v114
                            until v58 == 0
                        end
                    else
                        v100 = n7
                        v101 = v52
                    end

                    if v48 == 256 then
                        n7 = v100
                        break
                    end

                    n7 = v100
                    v52 = v101
                end
            end
        until v27 == 1

        if n6 > 0 then
            n6 = 0
            n5 += 1
        end

        assert(adler32(p8, 0, buffer.len(p8)) == bit32.byteswap((buffer.readu32(p7, n5))), "adler-32 checksum mismatch")

        return n7
    end,
    deflate = function(p11) -- deflate | line: 322
        -- upvalues: t3 (copy), t4 (copy), t10 (copy), t11 (copy), t12 (copy), v14 (copy), v15 (copy), v17 (copy), v18 (copy), getDistIdx (copy), adler32 (copy)
        local v125 = buffer.len(p11)
        local v127 = buffer.create(math.ceil(v125 / 32768) * 5 + v125 + 6)

        buffer.writeu16(v127, 0, 24184)

        local n8 = 2
        local n9 = 0

        local function writeBits(p12, p13) -- line: 333
            -- upvalues: v127 (copy), n8 (ref), n9 (ref)
            buffer.writebits(v127, n8 * 8 + n9, p13, p12)
            n9 += p13

            local v128 = n8

            n8 = v128 + bit32.rshift(n9, 3)
            n9 = bit32.band(n9, 7)
        end

        local function writeHuffmanBits(p14, p15) -- line: 341
            -- upvalues: v127 (copy), n8 (ref), n9 (ref)
            local v135 = bit32.bor(bit32.band(bit32.rshift(p14, 1), 1431655765), (bit32.band(bit32.lshift(p14, 1), 2863311530)))
            local v140 = bit32.bor(bit32.band(bit32.rshift(v135, 2), 858993459), (bit32.band(bit32.lshift(v135, 2), 3435973836)))
            local v145 = bit32.bor(bit32.band(bit32.rshift(v140, 4), 252645135), (bit32.band(bit32.lshift(v140, 4), 4042322160)))
            local v150 = bit32.bor(bit32.band(bit32.rshift(v145, 8), 16711935), (bit32.band(bit32.lshift(v145, 8), 4278255360)))
            local v157 = bit32.band(bit32.rshift(bit32.bor(bit32.rshift(v150, 16), (bit32.lshift(v150, 16))), 32 - p15), bit32.lshift(1, p15) - 1)

            buffer.writebits(v127, n8 * 8 + n9, p15, v157)
            n9 += p15

            local v158 = n8

            n8 = v158 + bit32.rshift(n9, 3)
            n9 = bit32.band(n9, 7)
        end

        local function writeLitOrLen(p16) -- line: 351
            -- upvalues: writeHuffmanBits (copy), v14 (copy), v15 (copy)
            writeHuffmanBits(v14[p16], v15[p16])
        end

        local function writeBackRef(p17, p18) -- line: 355
            -- upvalues: v127 (copy), n8 (ref), n9 (ref), writeHuffmanBits (copy), t3 (copy), t4 (copy), t10 (copy), t11 (copy), t12 (copy), v14 (copy), v15 (copy), v17 (copy), v18 (copy), getDistIdx (copy)
            local v161 = t10[p18]

            writeHuffmanBits(v14[v161], v15[v161])

            if p18 > 10 then
                local v162 = t11[p18]
                local v163 = t12[p18]

                buffer.writebits(v127, n8 * 8 + n9, v163, v162)
                n9 += v163

                local v164 = n8

                n8 = v164 + bit32.rshift(n9, 3)
                n9 = bit32.band(n9, 7)
            end

            local v167 = getDistIdx(p17)

            writeHuffmanBits(v17[v167 - 1], v18[v167 - 1])

            if not (v167 > 3) then
                return
            end

            local v168 = p17 - t3[v167]
            local v169 = t4[v167 - 1]

            buffer.writebits(v127, n8 * 8 + n9, v169, v168)
            n9 += v169

            local v170 = n8

            n8 = v170 + bit32.rshift(n9, 3)
            n9 = bit32.band(n9, 7)
        end

        local function getLitOrLenSize(p19) -- line: 367
            -- upvalues: v15 (copy)
            return v15[p19]
        end

        local function getBackRefSize(p20, p21) -- line: 371
            -- upvalues: t4 (copy), t10 (copy), t12 (copy), v15 (copy), v18 (copy), getDistIdx (copy)
            local v173 = getDistIdx(p20)

            return v15[t10[p21]] + t12[p21] + v18[v173 - 1] + (t4[v173 - 1] or 0)
        end

        local t14 = {}
        local t15 = {}
        local t16 = {}
        local n10 = 0

        local function insertNode(p22, p23) -- line: 384
            -- upvalues: t14 (copy), t15 (copy), n10 (ref)
            n10 += 1
            t14[n10] = p22
            t15[n10] = p23

            return n10
        end

        local function clearTables() -- line: 391
            -- upvalues: t14 (copy), t15 (copy), t16 (copy), n10 (ref)
            table.clear(t14)
            table.clear(t15)
            table.clear(t16)
            n10 = 0
        end

        for i = 0, v125 - 1, 32768 do
            local v175 = math.min(v125, i + 32768)
            local t17 = {}
            local n11 = 0
            local v176 = i

            while v176 < v175 - 3 do
                local v178 = bit32.band(buffer.readu32(p11, v176), 16777215)
                local v179 = t16[v178] or 0

                n10 += 1
                t14[n10] = v176
                t15[n10] = v179

                local v180 = n10

                t16[v178] = v180

                local v181 = 0
                local v182 = -1
                local v183 = 0
                local v184 = t15[v180]

                while v184 and (t14[v184] or (-1e999)) >= v176 - 32510 and v183 < 12 and v181 < 96 do
                    local v185 = t14[v184]
                    local v187 = math.min(v175, v176 + 258) > v176 + v181 and buffer.readu8(p11, v185 + v181) ~= buffer.readu8(p11, v176 + v181)
                    local n12 = 3

                    while not v187 and n12 < 258 and v176 + n12 < v175 and buffer.readu8(p11, v185 + n12) == buffer.readu8(p11, v176 + n12) do
                        n12 += 1
                    end

                    if v181 < n12 then
                        if n12 >= 258 then
                            v181 = n12
                            v182 = v185
                            break
                        end

                        v182 = v185
                        v181 = n12
                    end

                    v184 = t15[v184]
                    v183 += 1
                end

                if v181 == 0 then
                    local v194 = buffer.readu8(p11, v176)

                    n11 += v15[v194]
                    table.insert(t17, (vector.create(0, v194)))
                    v176 += 1
                else
                    local v197 = getDistIdx(v176 - v182)

                    n11 += v15[t10[v181]] + t12[v181] + v18[v197 - 1] + (t4[v197 - 1] or 0)
                    table.insert(t17, (vector.create(1, v176 - v182, v181)))

                    for j = v176 + 1, math.min(v176 + v181 - 1, v175 - 4) do
                        local v205 = bit32.band(buffer.readu32(p11, j), 16777215)
                        local v206 = t16[v205] or 0

                        n10 += 1
                        t14[n10] = j
                        t15[n10] = v206
                        t16[v205] = n10
                    end

                    v176 += v181
                end
            end

            while v176 < v175 do
                local v207 = buffer.readu8(p11, v176)

                n11 += v15[v207]
                table.insert(t17, (vector.create(0, v207)))
                v176 += 1
            end

            local v209 = n11 + v15[256]

            table.insert(t17, (vector.create(0, 256, 0)))

            if v175 == v125 then
                buffer.writebits(v127, n8 * 8 + n9, 1, 1)
                n9 += 1

                local v211 = bit32.rshift(n9, 3)

                n8 += v211
            else
                buffer.writebits(v127, n8 * 8 + n9, 1, 0)
                n9 += 1

                local v214 = bit32.rshift(n9, 3)

                n8 += v214
            end

            n9 = bit32.band(n9, 7)

            local v216 = v175 - i

            if math.ceil(v209 / 8) + 1 < math.ceil(v216 / 32768) * 5 + v216 then
                buffer.writebits(v127, n8 * 8 + n9, 2, 1)
                n9 += 2

                local v221 = bit32.rshift(n9, 3)

                n8 += v221
                n9 = bit32.band(n9, 7)

                for _, v223 in t17 do
                    if v223.x == 0 then
                        local y = v223.y

                        writeHuffmanBits(v14[y], v15[y])
                    else
                        writeBackRef(v223.y, v223.z)
                    end
                end
            else
                buffer.writebits(v127, n8 * 8 + n9, 2, 0)
                n9 += 2

                local v225 = bit32.rshift(n9, 3)

                n8 += v225
                n9 = bit32.band(n9, 7)

                if n9 > 0 then
                    n8 += 1
                    n9 = 0
                end

                buffer.writeu16(v127, n8, v216)
                buffer.writeu16(v127, n8 + 2, (bit32.bxor(65535, v216)))
                buffer.copy(v127, n8 + 4, p11, i, v216)

                local v230 = v216 + 4

                n8 += v230
            end

            if n10 > 50000 then
                table.clear(t14)
                table.clear(t15)
                table.clear(t16)
                n10 = 0
            end
        end

        if n9 > 0 then
            n8 += 1
        end

        local v232 = bit32.byteswap((adler32(p11, 0, buffer.len(p11))))

        buffer.writeu32(v127, n8, v232)

        return v127, n8 + 4
    end
}
