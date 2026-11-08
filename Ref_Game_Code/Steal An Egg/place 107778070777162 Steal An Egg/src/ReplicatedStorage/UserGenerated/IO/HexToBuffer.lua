-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    [48] = 0,
    [49] = 1,
    [50] = 2,
    [51] = 3,
    [52] = 4,
    [53] = 5,
    [54] = 6,
    [55] = 7,
    [56] = 8,
    [57] = 9,
    [65] = 10,
    [66] = 11,
    [67] = 12,
    [68] = 13,
    [69] = 14,
    [70] = 15,
    [97] = 10,
    [98] = 11,
    [99] = 12,
    [100] = 13,
    [101] = 14,
    [102] = 15
}

local function HexToBuffer(p1) -- line: 45
    -- upvalues: t1 (copy)
    local v1 = #p1

    assert(v1 % 2 == 0, "hex length must be even")

    local v3 = buffer.create(v1 // 2)
    local n1 = 0

    for i = 1, v1, 2 do
        local v4, v5 = string.byte(p1, i, i + 1)
        local v6 = t1[v4]

        if not v6 then
            error((("invalid hex at %*"):format(i)))
        end

        local v7 = t1[v5]

        if not v7 then
            error((`invalid hex at { i + 1 }`))
        end

        buffer.writeu8(v3, n1, v6 * 16 + v7)
        n1 += 1
    end

    return v3
end

return HexToBuffer
