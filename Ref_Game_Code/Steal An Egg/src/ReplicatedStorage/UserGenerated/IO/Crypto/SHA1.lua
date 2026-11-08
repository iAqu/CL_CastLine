-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.IO.Crypto.Hash)

local v1 = table.create(80, 0)

function processBlocks(p1, p2, p3, p4) -- line: 37
    -- upvalues: v1 (copy)
    local v2 = p1[1]
    local v3 = p1[2]
    local v4 = p1[3]
    local v5 = p1[4]
    local v6 = p1[5]

    for i = p3, p4, 64 do
        local v7 = i

        for j = 1, 16 do
            local v9, v10, v11, v12 = string.byte(p2, v7, v7 + 3)

            v1[j] = bit32.bor(bit32.lshift(v9, 24), bit32.lshift(v10, 16), bit32.lshift(v11, 8), v12)
            v7 += 4
        end

        for k = 17, 80 do
            v1[k] = bit32.lrotate(bit32.bxor(v1[k - 3], v1[k - 8], v1[k - 14], v1[k - 16]), 1)
        end

        local v21 = v2
        local v22 = v3
        local v23 = v4
        local v24 = v5
        local v25 = v6

        for n = 1, 20 do
            v21, v22, v23, v24, v25 = bit32.lrotate(v21, 5) + bit32.band(v22, v23) + bit32.band(bit32.bnot(v22), v24) + v25 + 1518500249 + v1[n], v21, bit32.lrotate(v22, 30), v23, v24
        end

        for n2 = 21, 40 do
            v21, v22, v23, v24, v25 = bit32.lrotate(v21, 5) + bit32.bxor(v22, v23, v24) + v25 + 1859775393 + v1[n2], v21, bit32.lrotate(v22, 30), v23, v24
        end

        for n3 = 41, 60 do
            v21, v22, v23, v24, v25 = bit32.lrotate(v21, 5) + bit32.band(v24, v23) + bit32.band(v22, (bit32.bxor(v24, v23))) + v25 + 2400959708 + v1[n3], v21, bit32.lrotate(v22, 30), v23, v24
        end

        for n4 = 61, 80 do
            v21, v22, v23, v24, v25 = bit32.lrotate(v21, 5) + bit32.bxor(v22, v23, v24) + v25 + 3395469782 + v1[n4], v21, bit32.lrotate(v22, 30), v23, v24
        end

        v2 = bit32.bor(v21 + v2, 0)
        v3 = bit32.bor(v22 + v3, 0)
        v4 = bit32.bor(v23 + v4, 0)
        v5 = bit32.bor(v24 + v5, 0)
        v6 = bit32.bor(v25 + v6, 0)
    end

    p1[1] = v2
    p1[2] = v3
    p1[3] = v4
    p1[4] = v5
    p1[5] = v6
end

function sha1(p5) -- line: 112
    local t1 = {
        1732584193, 4023233417, 2562383102, 271733878, 3285377520
    }
    local v35 = #p5
    local v36 = v35 % 64

    if v35 >= 64 then
        processBlocks(t1, p5, 1, v35 - v36)
    end

    local v38 = bit32.band(v36 + 32, 4294967232)
    local t2 = {
        if v36 == 0 then "" else string.sub(p5, -v36),
        "\128",
        string.rep("\000", (v38 - v36 - 9) % 64),
        string.pack(">L", v35 * 8)
    }
    local v41 = table.concat(t2)

    processBlocks(t1, v41, 1, #v41)

    local v42 = buffer.create(20)

    buffer.writeu32(v42, 0, (bit32.byteswap(t1[1])))
    buffer.writeu32(v42, 4, (bit32.byteswap(t1[2])))
    buffer.writeu32(v42, 8, (bit32.byteswap(t1[3])))
    buffer.writeu32(v42, 12, (bit32.byteswap(t1[4])))
    buffer.writeu32(v42, 16, (bit32.byteswap(t1[5])))

    return v42
end

local t3 = {
    Name = "SHA-1",
    BlockSize = 64,
    OutputSize = 20,
    Digest = function(p6) -- Digest | line: 152
        return buffer.tostring(sha1(p6))
    end,
    DigestBuffer = function(p7) -- DigestBuffer | line: 155
        return sha1(buffer.tostring(p7))
    end,
    DigestToBuffer = sha1
}

table.freeze(t3)

return t3
