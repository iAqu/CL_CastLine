-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local v1 = table.create(80, 0)
local v2 = table.create(80, 0)
local t1 = {
    1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221,
    3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580,
    3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
    2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895,
    666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037,
    2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
    430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779,
    1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298,
    3391569614, 3515267271, 3940187606, 4118630271, 116418474, 174292421, 289380356, 460393269,
    685471733, 852142971, 1017036298, 1126000580, 1288033470, 1501505948, 1607167915, 1816402316
}
local t2 = {
    3609767458, 602891725, 3964484399, 2173295548, 4081628472, 3053834265, 2937671579, 3664609560,
    2734883394, 1164996542, 1323610764, 3590304994, 4068182383, 991336113, 633803317, 3479774868,
    2666613458, 944711139, 2341262773, 2007800933, 1495990901, 1856431235, 3175218132, 2198950837,
    3999719339, 766784016, 2566594879, 3203337956, 1034457026, 2466948901, 3758326383, 168717936,
    1188179964, 1546045734, 1522805485, 2643833823, 2343527390, 1014477480, 1206759142, 344077627,
    1290863460, 3158454273, 3505952657, 106217008, 3606008344, 1432725776, 1467031594, 851169720,
    3100823752, 1363258195, 3750685593, 3785050280, 3318307427, 3812723403, 2003034995, 3602036899,
    1575990012, 1125592928, 2716904306, 442776044, 593698344, 3733110249, 2999351573, 3815920427,
    3928383900, 566280711, 3454069534, 4000239992, 1914138554, 2731055270, 3203993006, 320620315,
    587496836, 1086792851, 365543100, 2618297676, 3409855158, 4234509866, 987167468, 1246189591
}

function lil_sig0(p1, p2) -- line: 76
    return bit32.bxor(bit32.rshift(p1, 1), bit32.lshift(p2, 31), bit32.rshift(p1, 8), bit32.lshift(p2, 24), (bit32.rshift(p1, 7))), (bit32.bxor(bit32.rshift(p2, 1), bit32.lshift(p1, 31), bit32.rshift(p2, 8), bit32.lshift(p1, 24), bit32.rshift(p2, 7), (bit32.lshift(p1, 25))))
end

function lil_sig1(p3, p4) -- line: 98
    return bit32.bxor(bit32.rshift(p3, 19), bit32.lshift(p4, 13), bit32.lshift(p3, 3), bit32.rshift(p4, 29), (bit32.rshift(p3, 6))), (bit32.bxor(bit32.rshift(p4, 19), bit32.lshift(p3, 13), bit32.lshift(p4, 3), bit32.rshift(p3, 29), bit32.rshift(p4, 6), (bit32.lshift(p3, 26))))
end

function big_sig0(p5, p6) -- line: 119
    return bit32.bxor(bit32.rshift(p5, 28), bit32.lshift(p6, 4), bit32.lshift(p5, 30), bit32.rshift(p6, 2), bit32.lshift(p5, 25), (bit32.rshift(p6, 7))), (bit32.bxor(bit32.rshift(p6, 28), bit32.lshift(p5, 4), bit32.lshift(p6, 30), bit32.rshift(p5, 2), bit32.lshift(p6, 25), (bit32.rshift(p5, 7))))
end

function big_sig1(p7, p8) -- line: 137
    return bit32.bxor(bit32.rshift(p7, 14), bit32.lshift(p8, 18), bit32.rshift(p7, 18), bit32.lshift(p8, 14), bit32.lshift(p7, 23), (bit32.rshift(p8, 9))), (bit32.bxor(bit32.rshift(p8, 14), bit32.lshift(p7, 18), bit32.rshift(p8, 18), bit32.lshift(p7, 14), bit32.lshift(p8, 23), (bit32.rshift(p7, 9))))
end

function processBlocks(p9, p10, p11, p12, p13) -- line: 157
    -- upvalues: v1 (copy), v2 (copy), t1 (copy), t2 (copy)
    local v53 = p9[1]
    local v54 = p9[2]
    local v55 = p9[3]
    local v56 = p9[4]
    local v57 = p9[5]
    local v58 = p9[6]
    local v59 = p9[7]
    local v60 = p9[8]
    local v61 = p10[1]
    local v62 = p10[2]
    local v63 = p10[3]
    local v64 = p10[4]
    local v65 = p10[5]
    local v66 = p10[6]
    local v67 = p10[7]
    local v68 = p10[8]

    for i = p12, p13, 128 do
        local v69 = i

        for j = 1, 16 do
            local v71, v72, v73, v74, v75, v76, v77, v78 = string.byte(p11, v69, v69 + 7)

            v1[j] = bit32.bor(bit32.lshift(v71, 24), bit32.lshift(v72, 16), bit32.lshift(v73, 8), v74)
            v2[j] = bit32.bor(bit32.lshift(v75, 24), bit32.lshift(v76, 16), bit32.lshift(v77, 8), v78)
            v69 += 8
        end

        for k = 17, 80 do
            local v85, v86 = lil_sig0(v1[k - 15], v2[k - 15])
            local v87, v88 = lil_sig1(v1[k - 2], v2[k - 2])
            local v89 = v2[k - 16] + v86 + v2[k - 7] + v88

            v2[k] = bit32.bor(v89, 0)
            v1[k] = v1[k - 16] + v85 + v1[k - 7] + v87 + v89 // 4294967296
        end

        local v90 = v53
        local v91 = v54
        local v92 = v55
        local v93 = v56
        local v94 = v57
        local v95 = v58
        local v96 = v59
        local v97 = v60
        local v98 = v61
        local v99 = v62
        local v100 = v63
        local v101 = v64
        local v102 = v65
        local v103 = v66
        local v104 = v67
        local v105 = v68

        for n = 1, 80 do
            local v106, v107 = big_sig0(v90, v98)
            local v108, v109 = big_sig1(v94, v102)
            local v114 = v105 + v109 + bit32.bor(bit32.band(v102, v103), bit32.band(-1 - v102, v104), 0) + t2[n] + v2[n]
            local v119 = v97 + v108 + bit32.bor(bit32.band(v94, v95), bit32.band(-1 - v94, v96), 0) + t1[n] + v1[n] + v114 // 4294967296
            local v120 = bit32.bor(v114, 0)
            local v123 = v107 + bit32.band(v100, v99) + bit32.band(v98, (bit32.bxor(v100, v99)))
            local v126 = v106 + bit32.band(v92, v91) + bit32.band(v90, (bit32.bxor(v92, v91)))
            local v127 = v120 + v101
            local v128 = v119 + v93 + v127 // 4294967296
            local v129 = bit32.bor(v127, 0)
            local v130 = v120 + v123

            v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100, v101, v102, v103, v104, v105 = v119 + v126 + v130 // 4294967296, v90, v91, v92, v128, v94, v95, v96, bit32.bor(v130, 0), v98, v99, v100, v129, v102, v103, v104
        end

        local v131 = v61 + v98

        v53 = bit32.bor(v53 + v90 + v131 // 4294967296, 0)
        v61 = bit32.bor(v131, 0)

        local v133 = v62 + v99

        v54 = bit32.bor(v54 + v91 + v133 // 4294967296, 0)
        v62 = bit32.bor(v133, 0)

        local v135 = v63 + v100

        v55 = bit32.bor(v55 + v92 + v135 // 4294967296, 0)
        v63 = bit32.bor(v135, 0)

        local v137 = v64 + v101

        v56 = bit32.bor(v56 + v93 + v137 // 4294967296, 0)
        v64 = bit32.bor(v137, 0)

        local v139 = v65 + v102

        v57 = bit32.bor(v57 + v94 + v139 // 4294967296, 0)
        v65 = bit32.bor(v139, 0)

        local v141 = v66 + v103

        v58 = bit32.bor(v58 + v95 + v141 // 4294967296, 0)
        v66 = bit32.bor(v141, 0)

        local v143 = v67 + v104

        v59 = bit32.bor(v59 + v96 + v143 // 4294967296, 0)
        v67 = bit32.bor(v143, 0)

        local v145 = v68 + v105

        v60 = bit32.bor(v60 + v97 + v145 // 4294967296, 0)
        v68 = bit32.bor(v145, 0)
    end

    p9[1] = v53
    p10[1] = v61
    p9[2] = v54
    p10[2] = v62
    p9[3] = v55
    p10[3] = v63
    p9[4] = v56
    p10[4] = v64
    p9[5] = v57
    p10[5] = v65
    p9[6] = v58
    p10[6] = v66
    p9[7] = v59
    p10[7] = v67
    p9[8] = v60
    p10[8] = v68
end

function sha384(p14) -- line: 291
    local t3 = {
        3418070365, 1654270250, 2438529370, 355462360, 1731405415, 2394180231, 3675008525, 1203062813
    }
    local t4 = {
        3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428
    }
    local v147 = #p14

    if v147 > 1125899906842624 then
        error("cannot calculate the SHA-384 hash of a string longer than 2^50 bytes", 2)
    end

    local v148 = v147 % 128

    if v147 >= 128 then
        processBlocks(t3, t4, p14, 1, v147 - v148)
    end

    local v150 = bit32.band(v148 + 64, 4294963200)
    local t5 = {
        if v148 == 0 then "" else string.sub(p14, -v148),
        "\128",
        string.rep("\000", (v150 - v148 - 17) % 128),
        string.pack(">L", v147 * 8 / 4294967296),
        string.pack(">L", (bit32.bor(v147 * 8)))
    }
    local v156 = table.concat(t5)

    processBlocks(t3, t4, v156, 1, #v156)

    local v157 = buffer.create(48)

    for i = 1, 6 do
        local v159 = bit32.byteswap(t3[i])

        buffer.writeu32(v157, (i - 1) * 8, v159)

        local v161 = bit32.byteswap(t4[i])

        buffer.writeu32(v157, (i - 1) * 8 + 4, v161)
    end

    return v157
end

local t6 = {
    Name = "SHA-384",
    BlockSize = 128,
    OutputSize = 48,
    Digest = function(p15) -- Digest | line: 341
        return buffer.tostring(sha384(p15))
    end,
    DigestBuffer = function(p16) -- DigestBuffer | line: 344
        return sha384(buffer.tostring(p16))
    end,
    DigestToBuffer = sha384
}

table.freeze(t6)

return t6
