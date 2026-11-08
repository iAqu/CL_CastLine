-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local band, lshift, rshift, lrotate = bit32.band, bit32.lshift, bit32.rshift, bit32.lrotate
local bxor, bor, len, readu32 = bit32.bxor, bit32.bor, buffer.len, buffer.readu32
local readu8, readu16, fromstring = buffer.readu8, buffer.readu16, buffer.fromstring

function mul32(p1, p2) -- line: 28
    -- upvalues: band (copy), lshift (copy), rshift (copy)
    return band(p1, 65535) * p2 + lshift(band(rshift(p1, 16) * p2, 65535), 16)
end

function DigestBufferUnsafe(p3, p4, p5, p6) -- line: 32
    -- upvalues: band (copy), lshift (copy), rshift (copy), lrotate (copy), bxor (copy), bor (copy), readu32 (copy), readu8 (copy), readu16 (copy)
    local v4 = 0

    if p6 ~= nil then
        assert(bor(p6, 0) == p6)
        v4 = p6
    end

    local v6 = p4 + p5 - 3
    local v7 = p4

    while v7 < v6 do
        local v8 = readu32(p3, v7)
        local v10 = lrotate(mul32(v8, 3432918353), 15)

        v4 = lshift(lrotate(bxor(v4, (mul32(v10, 461845907))), 13) * 5, 0) + 3864292196
        v7 += 4
    end

    local v14 = band(p5, 3)

    if v14 > 0 then
        local v15 = if v14 == 3 then readu8(p3, v7) + lshift(readu16(p3, v7 + 1), 8) elseif v14 == 2 then readu16(p3, v7) else readu8(p3, v7)
        local v20 = lrotate(mul32(v15, 3432918353), 15)

        v4 = bxor(v4, (mul32(v20, 461845907)))
    end

    local v22 = bxor(v4, p5)
    local v24 = bxor(v22, (rshift(v22, 16)))
    local v25 = mul32(v24, 2246822507)
    local v27 = bxor(v25, (rshift(v25, 13)))
    local v28 = mul32(v27, 3266489909)

    return (bxor(v28, (rshift(v28, 16))))
end

function DigestBufferCustom(p7, p8, p9, p10) -- line: 80
    -- upvalues: len (copy)
    assert(type(p7) == "buffer")
    assert(type(p8) == "number" and p8 >= 0 and p8 <= len(p7))
    assert(type(p9) == "number" and p9 >= 0 and p9 <= len(p7) - p8)

    return DigestBufferUnsafe(p7, p8, p9, p10)
end

function DigestBuffer(p11, p12) -- line: 87
    -- upvalues: len (copy)
    return DigestBufferUnsafe(p11, 0, len(p11), p12)
end

function Digest(p13, p14) -- line: 91
    -- upvalues: len (copy), fromstring (copy)
    local v33 = fromstring(p13)

    return DigestBufferUnsafe(v33, 0, len(v33), p14)
end

local t1 = {
    DigestBufferCustom = DigestBufferCustom,
    DigestBuffer = DigestBuffer,
    Digest = Digest
}

table.freeze(t1)

return t1
