-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local t1 = {
    3614090360, 3905402710, 606105819, 3250441966, 4118548399, 1200080426, 2821735955, 4249261313,
    1770035416, 2336552879, 4294925233, 2304563134, 1804603682, 4254626195, 2792965006, 1236535329,
    4129170786, 3225465664, 643717713, 3921069994, 3593408605, 38016083, 3634488961, 3889429448,
    568446438, 3275163606, 4107603335, 1163531501, 2850285829, 4243563512, 1735328473, 2368359562,
    4294588738, 2272392833, 1839030562, 4259657740, 2763975236, 1272893353, 4139469664, 3200236656,
    681279174, 3936430074, 3572445317, 76029189, 3654602809, 3873151461, 530742520, 3299628645,
    4096336452, 1126891415, 2878612391, 4237533241, 1700485571, 2399980690, 4293915773, 2240044497,
    1873313359, 4264355552, 2734768916, 1309151649, 4149444226, 3174756917, 718787259, 3951481745
}
local t2 = {
    7, 12, 17, 22, 7, 12, 17, 22,
    7, 12, 17, 22, 7, 12, 17, 22,
    5, 9, 14, 20, 5, 9, 14, 20,
    5, 9, 14, 20, 5, 9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23,
    4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21,
    6, 10, 15, 21, 6, 10, 15, 21
}
local v1 = table.create(64, 0)

function processBlocks(p1, p2, p3, p4) -- line: 66
    -- upvalues: t1 (copy), t2 (copy), v1 (copy)
    local v2 = p1[1]
    local v3 = p1[2]
    local v4 = p1[3]
    local v5 = p1[4]

    for i = p3, p4, 64 do
        local v6 = i

        for j = 1, 16 do
            local v8, v9, v10, v11 = string.byte(p2, v6, v6 + 3)

            v1[j] = bit32.bor(bit32.lshift(v11, 24), bit32.lshift(v10, 16), bit32.lshift(v9, 8), v8)
            v6 += 4
        end

        local v15 = v2
        local v16 = v3
        local v17 = v4
        local v18 = v5

        for k = 0, 15 do
            v15, v16, v17, v18 = v18, v16 + bit32.lrotate(v15 + bit32.bxor(v18, (bit32.band(v16, (bit32.bxor(v17, v18))))) + t1[k + 1] + v1[k + 1], t2[k + 1]), v16, v17
        end

        for n = 16, 31 do
            v15, v16, v17, v18 = v18, v16 + bit32.lrotate(v15 + bit32.bxor(v17, (bit32.band(v18, (bit32.bxor(v16, v17))))) + t1[n + 1] + v1[(n * 5 + 1) % 16 + 1], t2[n + 1]), v16, v17
        end

        for n2 = 32, 47 do
            v15, v16, v17, v18 = v18, v16 + bit32.lrotate(v15 + bit32.bxor(v16, v17, v18) + t1[n2 + 1] + v1[(n2 * 3 + 5) % 16 + 1], t2[n2 + 1]), v16, v17
        end

        for n3 = 48, 63 do
            v15, v16, v17, v18 = v18, v16 + bit32.lrotate(v15 + bit32.bxor(v17, (bit32.bor(v16, (bit32.bnot(v18))))) + t1[n3 + 1] + v1[n3 * 7 % 16 + 1], t2[n3 + 1]), v16, v17
        end

        v2 = bit32.bor(v15 + v2)
        v3 = bit32.bor(v16 + v3)
        v4 = bit32.bor(v17 + v4)
        v5 = bit32.bor(v18 + v5)
    end

    p1[1] = v2
    p1[2] = v3
    p1[3] = v4
    p1[4] = v5
end

function md5(p5) -- line: 141
    local t3 = {
        1732584193, 4023233417, 2562383102, 271733878
    }
    local v37 = #p5
    local v38 = v37 % 64

    if v37 >= 64 then
        processBlocks(t3, p5, 1, v37 - v38)
    end

    local v40 = bit32.band(v38 + 32, 4294967232)
    local t4 = {
        if v38 == 0 then "" else string.sub(p5, -v38),
        "\128",
        string.rep("\000", (v40 - v38 - 9) % 64),
        string.pack("<L", v37 * 8)
    }
    local v43 = table.concat(t4)

    processBlocks(t3, v43, 1, #v43)

    local v44 = buffer.create(16)

    buffer.writeu32(v44, 0, t3[1])
    buffer.writeu32(v44, 4, t3[2])
    buffer.writeu32(v44, 8, t3[3])
    buffer.writeu32(v44, 12, t3[4])

    return v44
end

local t5 = {
    Name = "MD5",
    BlockSize = 64,
    OutputSize = 16,
    Digest = function(p6) -- Digest | line: 180
        return buffer.tostring(md5(p6))
    end,
    DigestBuffer = function(p7) -- DigestBuffer | line: 183
        return md5(buffer.tostring(p7))
    end,
    DigestToBuffer = md5
}

table.freeze(t5)

return t5
