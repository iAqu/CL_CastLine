-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function Mix(p1, p2, p3) -- line: 20
    local v1 = bit32.bor(p1, 0)
    local v2 = bit32.bor(p2, 0)
    local v3 = bit32.bor(p3, 0)
    local v6 = bit32.bxor(v1 - v2 - v3, (bit32.rshift(v3, 13)))
    local v9 = bit32.bxor(v2 - v3 - v6, (bit32.lshift(v6, 8)))
    local v12 = bit32.bxor(v3 - v6 - v9, (bit32.rshift(v9, 13)))
    local v15 = bit32.bxor(v6 - v9 - v12, (bit32.rshift(v12, 12)))
    local v18 = bit32.bxor(v9 - v12 - v15, (bit32.lshift(v15, 16)))
    local v21 = bit32.bxor(v12 - v15 - v18, (bit32.rshift(v18, 5)))
    local v24 = bit32.bxor(v15 - v18 - v21, (bit32.rshift(v21, 3)))
    local v27 = bit32.bxor(v18 - v21 - v24, (bit32.lshift(v24, 10)))

    return (bit32.bxor(v21 - v24 - v27, (bit32.rshift(v27, 15))))
end

local function Unpack64(p4) -- line: 52
    if p4 < 0 then
        local v30 = -1 - p4

        return bit32.bnot(v30 // 4294967296), (bit32.bnot(v30))
    end

    return bit32.bor(p4 // 4294967296, 0), (bit32.bor(p4, 0))
end

local function DoubleFromInt64(p5, p6) -- line: 60
    -- upvalues: Mix (copy)
    local v33, v34

    if p5 < 0 then
        local v35 = -1 - p5

        v34 = bit32.bnot(v35 // 4294967296)
        v33 = bit32.bnot(v35)
    else
        v34 = bit32.bor(p5 // 4294967296, 0)
        v33 = bit32.bor(p5, 0)
    end

    return Mix(v33, v34, p6) / 4294967296
end

local function ParseUUID(p7) -- line: 65
    return tonumber(string.sub(p7, 1, 8), 16), tonumber(string.sub(p7, 10, 13) .. string.sub(p7, 15, 18), 16), tonumber(string.sub(p7, 20, 23) .. string.sub(p7, 25, 28), 16), (tonumber(string.sub(p7, 29, 36), 16))
end

local function DoubleFromUUID(p8, p9) -- line: 71
    -- upvalues: Mix (copy)
    local v46 = tonumber(string.sub(p8, 1, 8), 16)
    local v48 = tonumber(string.sub(p8, 10, 13) .. string.sub(p8, 15, 18), 16)
    local v50 = tonumber(string.sub(p8, 20, 23) .. string.sub(p8, 25, 28), 16)
    local v52 = tonumber(string.sub(p8, 29, 36), 16)

    return Mix(Mix(v46, v48, 2197175160), Mix(v50, v52, 2821953579), p9) / 4294967296
end

local function IntegerFromUUID(p10, p11, p12, p13) -- line: 76
    -- upvalues: Mix (copy)
    local v53 = p13 - p12 + 1
    local v55 = tonumber(string.sub(p10, 1, 8), 16)
    local v57 = tonumber(string.sub(p10, 10, 13) .. string.sub(p10, 15, 18), 16)
    local v59 = tonumber(string.sub(p10, 20, 23) .. string.sub(p10, 25, 28), 16)
    local v61 = tonumber(string.sub(p10, 29, 36), 16)

    return (math.floor(p12 + v53 * (Mix(Mix(v55, v57, 2197175160), Mix(v59, v61, 2821953579), p11) / 4294967296)))
end

return table.freeze({
    Mix = Mix,
    DoubleFromInt64 = DoubleFromInt64,
    DoubleFromUUID = DoubleFromUUID,
    IntegerFromUUID = IntegerFromUUID
})
