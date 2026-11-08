-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    [0] = { 1, 2, 4, 8, 16 },
    [2] = { 8, 16 },
    [3] = { 1, 2, 4, 8 },
    [4] = { 8, 16 },
    [6] = { 8, 16 }
}

local function read(p1, p2) -- line: 11
    -- upvalues: t1 (copy)
    assert(p2.length == 13, "IHDR data must be 13 bytes")

    local offset = p2.offset
    local v3 = bit32.byteswap((buffer.readu32(p1, offset)))
    local v6 = bit32.byteswap((buffer.readu32(p1, offset + 4)))
    local v8 = buffer.readu8(p1, offset + 8)
    local v10 = buffer.readu8(p1, offset + 9)
    local v12 = buffer.readu8(p1, offset + 10)
    local v14 = buffer.readu8(p1, offset + 11)
    local v16 = buffer.readu8(p1, offset + 12)

    assert(v3 > 0 and v3 <= 2147483648 and v6 > 0 and v6 <= 2147483648, "invalid dimensions")
    assert(v12 == 0, "invalid compression method")
    assert(v14 == 0, "invalid filter method")
    assert(v16 == 0 or v16 == 1, "invalid interlace method")

    local v21 = t1[v10]

    assert(v21 ~= nil, "invalid color type")
    assert(table.find(v21, v8) ~= nil, "invalid bit depth")

    return {
        width = v3,
        height = v6,
        bitDepth = v8,
        colorType = v10,
        interlaced = v16 == 1
    }
end

return read
