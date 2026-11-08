-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local t1 = {
    1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221,
    3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580,
    3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
    2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895,
    666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037,
    2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
    430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779,
    1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298
}
local v1 = table.create(64, 0)

function processBlocks(p1, p2, p3, p4) -- line: 49
    -- upvalues: t1 (copy), v1 (copy)
    local v2 = p1[1]
    local v3 = p1[2]
    local v4 = p1[3]
    local v5 = p1[4]
    local v6 = p1[5]
    local v7 = p1[6]
    local v8 = p1[7]
    local v9 = p1[8]

    for i = p3, p4, 64 do
        local v10 = i

        for j = 1, 16 do
            local v12, v13, v14, v15 = string.byte(p2, v10, v10 + 3)

            v1[j] = bit32.bor(bit32.lshift(v12, 24), bit32.lshift(v13, 16), bit32.lshift(v14, 8), v15)
            v10 += 4
        end

        for k = 17, 64 do
            local v19 = v1[k - 2]
            local v20 = v1[k - 15]

            v1[k] = bit32.bxor(bit32.rrotate(v19, 17), bit32.rrotate(v19, 19), (bit32.rshift(v19, 10))) + v1[k - 7] + bit32.bxor(bit32.rrotate(v20, 7), bit32.rrotate(v20, 18), (bit32.rshift(v20, 3))) + v1[k - 16]
        end

        local v28 = v2
        local v29 = v3
        local v30 = v4
        local v31 = v5
        local v32 = v6
        local v33 = v7
        local v34 = v8
        local v35 = v9

        for n = 1, 64 do
            local v41 = v35 + bit32.bxor(bit32.rrotate(v32, 6), bit32.rrotate(v32, 11), (bit32.rrotate(v32, 25))) + bit32.band(v32, v33) + bit32.band(bit32.bnot(v32), v34) + t1[n] + v1[n]
            local v48 = bit32.band(v30, v29) + bit32.band(v28, (bit32.bxor(v30, v29))) + bit32.bxor(bit32.rrotate(v28, 2), bit32.rrotate(v28, 13), (bit32.rrotate(v28, 22)))
            local v49 = v31 + v41

            v28, v29, v30, v31, v32, v33, v34, v35 = v41 + v48, v28, v29, v30, v49, v32, v33, v34
        end

        v2 = bit32.bor(v28 + v2, 0)
        v3 = bit32.bor(v29 + v3, 0)
        v4 = bit32.bor(v30 + v4, 0)
        v5 = bit32.bor(v31 + v5, 0)
        v6 = bit32.bor(v32 + v6, 0)
        v7 = bit32.bor(v33 + v7, 0)
        v8 = bit32.bor(v34 + v8, 0)
        v9 = bit32.bor(v35 + v9, 0)
    end

    p1[1] = v2
    p1[2] = v3
    p1[3] = v4
    p1[4] = v5
    p1[5] = v6
    p1[6] = v7
    p1[7] = v8
    p1[8] = v9
end

function sha224(p5) -- line: 128
    local t2 = {
        3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428
    }
    local v58 = #p5
    local v59 = v58 % 64

    if v58 >= 64 then
        processBlocks(t2, p5, 1, v58 - v59)
    end

    local v61 = bit32.band(v59 + 32, 4294967232)
    local t3 = {
        if v59 == 0 then "" else string.sub(p5, -v59),
        "\128",
        string.rep("\000", (v61 - v59 - 9) % 64),
        string.pack(">L", v58 * 8)
    }
    local v64 = table.concat(t3)

    processBlocks(t2, v64, 1, #v64)

    local v65 = buffer.create(28)

    buffer.writeu32(v65, 0, (bit32.byteswap(t2[1])))
    buffer.writeu32(v65, 4, (bit32.byteswap(t2[2])))
    buffer.writeu32(v65, 8, (bit32.byteswap(t2[3])))
    buffer.writeu32(v65, 12, (bit32.byteswap(t2[4])))
    buffer.writeu32(v65, 16, (bit32.byteswap(t2[5])))
    buffer.writeu32(v65, 20, (bit32.byteswap(t2[6])))
    buffer.writeu32(v65, 24, (bit32.byteswap(t2[7])))

    return v65
end

local t4 = {
    Name = "SHA-224",
    BlockSize = 64,
    OutputSize = 28,
    Digest = function(p6) -- Digest | line: 171
        return buffer.tostring(sha224(p6))
    end,
    DigestBuffer = function(p7) -- DigestBuffer | line: 174
        return sha224(buffer.tostring(p7))
    end,
    DigestToBuffer = sha224
}

table.freeze(t4)

return t4
