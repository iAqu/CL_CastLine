-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Types)

local chunks = require(script.chunks)
local crc32 = require(script.crc32)
local zlib = require(script.zlib)
local t1 = {
    [0] = 1,
    [2] = 3,
    [3] = 1,
    [4] = 2,
    [6] = 4
}
local t2 = {
    0, 0, 4, 0, 2, 0, 1
}
local t3 = {
    0, 4, 0, 2, 0, 1, 0
}
local t4 = {
    8, 8, 8, 4, 4, 2, 2
}
local t5 = {
    8, 8, 4, 4, 2, 2, 1
}

return {
    decode = function(p1, p2) -- decode | line: 38
        -- upvalues: chunks (copy), crc32 (copy), zlib (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
        local v1 = buffer.len(p1)

        assert(v1 >= 8, "not a PNG")
        assert(buffer.readstring(p1, 0, 8) == "\137PNG\r\n\026\n", "not a PNG")

        local v4 = table.create(3)
        local v5 = p2 ~= nil and p2.allowIncorrectCRC == true
        local n1 = 8
        local v6

        while true do
            local v8 = bit32.byteswap((buffer.readu32(p1, n1)))
            local v9 = buffer.readstring(p1, n1 + 4, 4)

            assert(string.match(v9, "%a%a%a%a"), (("invalid chunk type %*"):format(v9)))

            local v12 = n1 + 8

            v6 = v12 + v8 + 4
            assert(v6 <= v1, (("EOF while reading %* chunk"):format(v9)))

            local v17 = bit32.byteswap((buffer.readu32(p1, v6 - 4)))
            local v18 = crc32(p1, n1 + 4, v6 - 5)

            assert(v5 or v17 == v18, (("incorrect checksum in %*"):format(v9)))
            table.insert(v4, {
                type = v9,
                offset = v12,
                length = v8
            })

            if v1 <= v6 then
                break
            end

            n1 = v6
        end

        assert(v6 == v1, "trailing data in file")

        for _, v22 in v4 do
            local type = v22.type

            if bit32.extract(string.byte(type, 1, 1), 5) == 0 and type ~= "IHDR" and type ~= "IDAT" and type ~= "PLTE" and type ~= "IEND" then
                error((("unhandled critical chunk %*"):format(type)))
            end
        end

        local v24 = v4[1]

        assert(v24.type == "IHDR", "first chunk must be IHDR")

        for i = 2, #v4 do
            assert(v4[i].type ~= "IHDR", "multiple IHDR chunks are not allowed")
        end

        local v27 = chunks.IHDR(p1, v24)
        local n2 = -1
        local n3 = -1
        local n4 = 0

        for v28, v29 in v4 do
            if v29.type == "IDAT" then
                if n3 < 0 then
                    n3 = v28
                else
                    assert(v28 == n2 + 1, "multiple IDAT chunks must be consecutive")
                end

                n2 = v28
                n4 += v29.length
            end
        end

        assert(n3 > 0, "no IDAT chunks")
        assert(n4 > 0, "no image data in IDAT chunks")

        local n5 = -1
        local v33

        for v34, v35 in v4 do
            if v35.type == "PLTE" then
                assert(not v33, "multiple PLTE chunks are not allowed")
                assert(v34 < n3, "PLTE not allowed after IDAT chunks")
                assert(v27.colorType ~= 0 and v27.colorType ~= 4, "PLTE not allowed for color type")
                n5 = v34
                v33 = chunks.PLTE(p1, v35, v27)
            end
        end

        if v27.colorType == 3 then
            assert(v33 ~= nil, "color type requires a PLTE chunk")
        end

        local v40

        for v41, v42 in v4 do
            if v42.type == "tRNS" then
                assert(v40 == nil, "multiple tRNS chunks are not allowed")
                assert(v41 < n3, "tRNS not allowed after IDAT chunks")
                assert(not v33 or n5 < v41, "tRNS must be after PLTE")
                assert(v27.colorType ~= 4 and v27.colorType ~= 6, "tRNS not allowed for color type")
                v40 = chunks.tRNS(p1, v42, v27, v33)
            end
        end

        local v47 = v4[#v4]

        assert(v47.type == "IEND", "final chunk must be IEND")
        assert(v47.length == 0, "IEND chunk must be empty")

        for i = 2, #v4 - 1 do
            assert(v4[i].type ~= "IEND", "multiple IEND chunks are not allowed")
        end

        local v51 = buffer.create(n4)
        local n6 = 0

        for _, v52 in v4 do
            if v52.type == "IDAT" then
                buffer.copy(v51, n6, p1, v52.offset, v52.length)
                n6 += v52.length
            end
        end

        local width, height, bitDepth, colorType = v27.width, v27.height, v27.bitDepth, v27.colorType
        local v53 = t1[colorType]
        local v54

        if v27.interlaced then
            v54 = 0

            for i = 1, 7 do
                local v56 = math.ceil((width - t3[i]) / t5[i])
                local v58 = math.ceil((height - t2[i]) / t4[i])

                if v56 > 0 and v58 > 0 then
                    v54 += v58 * (math.ceil(v56 * v53 * bitDepth / 8) + 1)
                end
            end
        else
            v54 = height * (math.ceil(width * v53 * bitDepth / 8) + 1)
        end

        local colors = if v33 then v33.colors else nil
        local v61 = if colorType ~= 3 and bitDepth < 8 then 255 / (2 ^ bitDepth - 1) else nil
        local v63 = math.ceil(v53 * bitDepth / 8)
        local v64 = 2 ^ bitDepth - 1
        local n7 = 0
        local v65 = buffer.create(v54)

        assert(zlib.inflate(v51, v65) == v54, "decompressed data size mismatch")

        local v67 = buffer.create(width * height * 4)
        local v68, v69, v70, v71

        if v40 then
            v70 = v40.gray
            v69 = v40.red
            v71 = v40.green
            v68 = v40.blue
        else
            v70 = -1
            v69 = -1
            v71 = -1
            v68 = -1
        end

        local function pass(p3, p4, p5, p6) -- line: 190
            -- upvalues: width (copy), height (copy), bitDepth (copy), colorType (copy), v53 (copy), colors (copy), v61 (copy), v63 (copy), v64 (copy), n7 (ref), v65 (copy), v67 (copy), v68 (ref), v69 (ref), v70 (ref), v71 (ref)
            local v73 = math.ceil((width - p3) / p5)
            local v72 = math.ceil((height - p4) / p6)

            if v73 < 1 or v72 < 1 then
                return
            end

            local v74 = math.ceil(v73 * v53 * bitDepth / 8)
            local v75 = n7
            local v76 = v75
            local v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87

            for i = 1, v72 do
                local v89 = buffer.readu8(v65, n7)

                n7 += 1

                if v89 ~= 0 and (v89 ~= 2 or i ~= 1) then
                    if v89 == 1 then
                        for j = 1, v74 do
                            if j <= v63 then
                                v86 = 0
                            else
                                v77 = n7 - v63
                                v86 = buffer.readu8(v65, v77)
                            end

                            v80 = n7
                            v77 = buffer.readu8(v65, v80) + v86
                            v87 = bit32.band(v77, 255)
                            v79 = n7
                            buffer.writeu8(v65, v79, v87)
                            n7 += 1
                        end
                    elseif v89 == 2 then
                        for _ = 1, v74 do
                            v77 = n7 - v74 - 1
                            v86 = buffer.readu8(v65, v77)
                            v80 = n7
                            v77 = buffer.readu8(v65, v80) + v86
                            v87 = bit32.band(v77, 255)
                            v79 = n7
                            buffer.writeu8(v65, v79, v87)
                            n7 += 1
                        end
                    elseif v89 == 3 then
                        for k = 1, v74 do
                            if k <= v63 then
                                v86 = 0
                            else
                                v77 = n7 - v63
                                v86 = buffer.readu8(v65, v77)
                            end

                            if i == 1 then
                                v87 = 0
                            else
                                v78 = n7 - v74 - 1
                                v87 = buffer.readu8(v65, v78)
                            end

                            v81 = n7
                            v79 = buffer.readu8(v65, v81)
                            v81 = v86 + v87
                            v78 = v79 + bit32.rshift(v81, 1)
                            v77 = bit32.band(v78, 255)
                            v80 = n7
                            buffer.writeu8(v65, v80, v77)
                            n7 += 1
                        end
                    elseif v89 == 4 then
                        for n = 1, v74 do
                            if n <= v63 then
                                v81 = 0
                            else
                                v77 = n7 - v63
                                v81 = buffer.readu8(v65, v77)
                            end

                            if i == 1 then
                                v87 = 0
                            else
                                v78 = n7 - v74 - 1
                                v87 = buffer.readu8(v65, v78)
                            end

                            if n <= v63 or i == 1 then
                                v77 = 0
                            else
                                v79 = n7 - v74 - v63 - 1
                                v77 = buffer.readu8(v65, v79)
                            end

                            v79 = v87 - v77
                            v78 = math.abs(v79)
                            v80 = v81 - v77
                            v79 = math.abs(v80)
                            v80 = math.abs(v81 + v87 - v77 * 2)

                            if not (v78 <= v79 and v78 <= v80) then
                                v81 = if v79 <= v80 then v87 else v77
                            end

                            v85 = n7
                            v84 = buffer.readu8(v65, v85) + v81
                            v82 = bit32.band(v84, 255)
                            v83 = n7
                            buffer.writeu8(v65, v83, v82)
                            n7 += 1
                        end
                    else
                        error("invalid row filter")
                    end
                else
                    n7 += v74
                end
            end

            local n8 = 8

            local function readValue() -- line: 249
                -- upvalues: v76 (ref), n8 (ref), bitDepth (copy), v65 (copy)
                local v92 = buffer.readu8(v65, v76)
                local v93 = bitDepth < 8
                local v94, v95, v96

                if v93 then
                    v94 = bit32.extract(v92, n8 - bitDepth, bitDepth)
                    n8 -= bitDepth
                    v95 = n8 == 0
                else
                    if bitDepth == 8 then
                        v76 += 1

                        return v92
                    end

                    v96 = bit32.bor(bit32.lshift(v92, 8), (buffer.readu8(v65, v76 + 1)))
                    v76 += 2
                end

                if v93 and not v95 or not v93 then
                    if not v93 then
                        v94 = v96
                    end

                    return v94
                end

                n8 = 8
                v76 += 1

                return v94
            end

            local n9 = 8

            for i = 1, v72 do
                v75 = v76 + 1
                v76 = v75

                if n8 < 8 then
                    n8 = 8
                    v75 = v76 + 1
                    v76 = v75
                    n9 = 8
                end

                for j = 1, v73 do
                    local v101, v102, v103, v104, v105, v106, v107, v108

                    if colorType == 0 then
                        local v110 = buffer.readu8(v65, v76)
                        local v111, v112

                        if bitDepth < 8 then
                            v82 = n8 - bitDepth
                            v110 = bit32.extract(v110, v82, bitDepth)
                            v111 = n8 - bitDepth
                            n8 = v111

                            if n8 == 0 then
                                n8 = 8
                                v112 = v76 + 1
                                v76 = v112
                                v111 = 8
                            else
                                v112 = v75
                            end
                        else
                            v111 = n9

                            if bitDepth == 8 then
                                v112 = v76 + 1
                            else
                                v81 = bit32.lshift(v110, 8)
                                v83 = v76 + 1
                                v82 = buffer.readu8(v65, v83)
                                v110 = bit32.bor(v81, v82)
                                v112 = v76 + 2
                            end

                            v76 = v112
                        end

                        v108 = v110
                        v106 = if v110 == v70 then 0 else v64
                        v102 = v110
                        v103 = v111
                        v104 = v112
                        v105 = v110
                    elseif colorType == 2 then
                        local v114 = buffer.readu8(v65, v76)
                        local v115, v116

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v114 = bit32.extract(v114, v81, bitDepth)
                            v115 = n8 - bitDepth
                            n8 = v115

                            if n8 == 0 then
                                n8 = 8
                                v116 = v76 + 1
                                v76 = v116
                                v115 = 8
                            else
                                v116 = v75
                            end
                        else
                            v115 = n9

                            if bitDepth == 8 then
                                v116 = v76 + 1
                            else
                                v80 = bit32.lshift(v114, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v114 = bit32.bor(v80, v81)
                                v116 = v76 + 2
                            end

                            v76 = v116
                        end

                        v108 = v114
                        v102 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v102 = bit32.extract(v102, v81, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            else
                                v104 = v116
                            end
                        else
                            v103 = v115

                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v106 = bit32.lshift(v102, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v102 = bit32.bor(v106, v81)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end

                        v105 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v105 = bit32.extract(v105, v81, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            end
                        else
                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v106 = bit32.lshift(v105, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v105 = bit32.bor(v106, v81)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end

                        v106 = if v114 == v69 and v102 == v71 and v105 == v68 then 0 else v64
                    elseif colorType == 3 then
                        local v120 = buffer.readu8(v65, v76)
                        local v121, v122

                        if bitDepth < 8 then
                            v101 = n8 - bitDepth
                            v120 = bit32.extract(v120, v101, bitDepth)
                            v121 = n8 - bitDepth
                            n8 = v121

                            if n8 == 0 then
                                n8 = 8
                                v122 = v76 + 1
                                v76 = v122
                                v121 = 8
                            else
                                v122 = v75
                            end
                        else
                            v121 = n9

                            if bitDepth == 8 then
                                v122 = v76 + 1
                            else
                                v83 = bit32.lshift(v120, 8)
                                v107 = v76 + 1
                                v101 = buffer.readu8(v65, v107)
                                v120 = bit32.bor(v83, v101)
                                v122 = v76 + 2
                            end

                            v76 = v122
                        end

                        v102 = colors[v120 + 1]
                        v104, v103, v108, v102, v105, v106 = v122, v121, v102.r, v102.g, v102.b, v102.a
                    elseif colorType == 4 then
                        local v124 = buffer.readu8(v65, v76)
                        local v125, v126

                        if bitDepth < 8 then
                            v82 = n8 - bitDepth
                            v124 = bit32.extract(v124, v82, bitDepth)
                            v125 = n8 - bitDepth
                            n8 = v125

                            if n8 == 0 then
                                n8 = 8
                                v126 = v76 + 1
                                v76 = v126
                                v125 = 8
                            else
                                v126 = v75
                            end
                        else
                            v125 = n9

                            if bitDepth == 8 then
                                v126 = v76 + 1
                            else
                                v81 = bit32.lshift(v124, 8)
                                v83 = v76 + 1
                                v82 = buffer.readu8(v65, v83)
                                v124 = bit32.bor(v81, v82)
                                v126 = v76 + 2
                            end

                            v76 = v126
                        end

                        v105 = v124
                        v106 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v82 = n8 - bitDepth
                            v106 = bit32.extract(v106, v82, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            else
                                v104 = v126
                            end
                        else
                            v103 = v125

                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v81 = bit32.lshift(v106, 8)
                                v83 = v76 + 1
                                v82 = buffer.readu8(v65, v83)
                                v106 = bit32.bor(v81, v82)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end

                        v108 = v124
                        v102 = v124
                    elseif colorType == 6 then
                        local v129 = buffer.readu8(v65, v76)
                        local v130, v131

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v129 = bit32.extract(v129, v81, bitDepth)
                            v130 = n8 - bitDepth
                            n8 = v130

                            if n8 == 0 then
                                n8 = 8
                                v131 = v76 + 1
                                v76 = v131
                                v130 = 8
                            else
                                v131 = v75
                            end
                        else
                            v130 = n9

                            if bitDepth == 8 then
                                v131 = v76 + 1
                            else
                                v80 = bit32.lshift(v129, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v129 = bit32.bor(v80, v81)
                                v131 = v76 + 2
                            end

                            v76 = v131
                        end

                        v108 = v129
                        v102 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v102 = bit32.extract(v102, v81, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            else
                                v104 = v131
                            end
                        else
                            v103 = v130

                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v106 = bit32.lshift(v102, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v102 = bit32.bor(v106, v81)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end

                        v105 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v105 = bit32.extract(v105, v81, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            end
                        else
                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v106 = bit32.lshift(v105, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v105 = bit32.bor(v106, v81)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end

                        v106 = buffer.readu8(v65, v76)

                        if bitDepth < 8 then
                            v81 = n8 - bitDepth
                            v106 = bit32.extract(v106, v81, bitDepth)
                            v103 = n8 - bitDepth
                            n8 = v103

                            if n8 == 0 then
                                n8 = 8
                                v104 = v76 + 1
                                v76 = v104
                                v103 = 8
                            end
                        else
                            if bitDepth == 8 then
                                v104 = v76 + 1
                            else
                                v106 = bit32.lshift(v106, 8)
                                v84 = v76 + 1
                                v81 = buffer.readu8(v65, v84)
                                v106 = bit32.bor(v106, v81)
                                v104 = v76 + 2
                            end

                            v76 = v104
                        end
                    else
                        v103 = n9
                        v104 = v75
                    end

                    n9 = v103
                    v79 = p4 + (i - 1) * p6
                    v80 = p3 + (j - 1) * p5
                    v81 = (v79 * width + v80) * 4

                    if v61 then
                        v84 = v108 * v61
                        v86 = math.round(v84)
                        v84 = v102 * v61
                        v87 = math.round(v84)
                        v84 = v105 * v61
                        v77 = math.round(v84)
                        v84 = v106 * v61
                        v78 = math.round(v84)
                    elseif bitDepth == 16 then
                        v86 = bit32.rshift(v108, 8)
                        v87 = bit32.rshift(v102, 8)
                        v77 = bit32.rshift(v105, 8)
                        v78 = bit32.rshift(v106, 8)
                    else
                        v78 = v106
                        v86 = v108
                        v87 = v102
                        v77 = v105
                    end

                    v85 = bit32.lshift(v78, 24)
                    buffer.writeu32(v67, v81, (bit32.bor(v85, bit32.lshift(v77, 16), bit32.lshift(v87, 8), v86)))
                    v75 = v104
                end
            end
        end

        if not v27.interlaced then
            pass(0, 0, 1, 1)

            return {
                width = width,
                height = height,
                pixels = v67,
                readPixel = function(p9, p10) -- readPixel | line: 336
                    -- upvalues: width (copy), height (copy), v67 (copy)
                    assert(p9 >= 1 and p9 <= width and p10 >= 1 and p10 <= height, "pixel out of range")

                    local v137 = ((p10 - 1) * width + p9 - 1) * 4

                    return buffer.readu8(v67, v137), buffer.readu8(v67, v137 + 1), buffer.readu8(v67, v137 + 2), (buffer.readu8(v67, v137 + 3))
                end
            }
        end

        for i = 1, 7 do
            pass(t3[i], t2[i], t5[i], t4[i])
        end

        return {
            width = width,
            height = height,
            pixels = v67,
            readPixel = function(p9, p10) -- readPixel | line: 336
                -- upvalues: width (copy), height (copy), v67 (copy)
                assert(p9 >= 1 and p9 <= width and p10 >= 1 and p10 <= height, "pixel out of range")

                local v137 = ((p10 - 1) * width + p9 - 1) * 4

                return buffer.readu8(v67, v137), buffer.readu8(v67, v137 + 1), buffer.readu8(v67, v137 + 2), (buffer.readu8(v67, v137 + 3))
            end
        }
    end,
    encode = function(p11, p12) -- encode | line: 354
        -- upvalues: crc32 (copy), zlib (copy)
        local width, height = p12.width, p12.height
        local v144 = buffer.len(p11)
        local v145 = width * height * 4

        assert(v144 == v145, (("expected %* bytes, got %* bytes"):format(v145, v144)))

        local v148 = width * 4 + 1
        local v149 = buffer.create(height * v148)

        for i = 0, height - 1 do
            local v150 = i * width * 4
            local v151 = i * v148

            buffer.writeu8(v149, v151, 0)
            buffer.copy(v149, v151 + 1, p11, v150, width * 4)
        end

        local v152, v153 = zlib.deflate(v149)
        local v154 = 33 + (8 + v153 + 4) + 12
        local v155 = buffer.create(v154)

        buffer.writestring(v155, 0, "\137PNG\r\n\026\n")
        buffer.writeu32(v155, 8, (bit32.byteswap(13)))
        buffer.writestring(v155, 12, "IHDR")
        buffer.writeu32(v155, 16, (bit32.byteswap(width)))
        buffer.writeu32(v155, 20, (bit32.byteswap(height)))
        buffer.writeu8(v155, 24, 8)
        buffer.writeu8(v155, 25, 6)
        buffer.writeu8(v155, 26, 0)
        buffer.writeu8(v155, 27, 0)
        buffer.writeu8(v155, 28, 0)
        buffer.writeu32(v155, 29, (bit32.byteswap((crc32(v155, 12, 28)))))
        buffer.writeu32(v155, 33, (bit32.byteswap(v153)))
        buffer.writestring(v155, 37, "IDAT")
        buffer.copy(v155, 41, v152, 0, v153)

        local v162 = 41 + v153

        buffer.writeu32(v155, v162, (bit32.byteswap((crc32(v155, 37, v162 - 1)))))
        buffer.writeu32(v155, v162 + 4, 0)
        buffer.writestring(v155, v162 + 8, "IEND")
        buffer.writeu32(v155, v162 + 12, 2187346606)

        return v155
    end
}
