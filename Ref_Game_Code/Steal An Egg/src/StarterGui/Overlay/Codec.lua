-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    VERSION = 2,
    PREVIEW_PAYLOAD = "D200000000000000",
    getIsUserId = function(p1) -- getIsUserId | line: 18
        if type(p1) == "number" and p1 > 0 and p1 <= 9007199254740991 then
            return p1 % 1 == 0
        end

        return false
    end
}

function t1.createUserIdPayload(p2) -- line: 25
    -- upvalues: t1 (copy)
    assert(t1.getIsUserId(p2), "Expected a positive, exact Roblox UserId")

    local v3 = math.floor(p2 / 4294967296)
    local v4 = p2 % 4294967296

    return string.format("D2%06X%08X", v3, v4)
end

function t1.getIsPayload(p3) -- line: 35
    if type(p3) ~= "string" or #p3 ~= 16 or not string.match(p3, "^%x+$") then
        return false
    end

    local v6 = tonumber(string.sub(p3, 3), 16)

    if string.upper((string.sub(p3, 1, 2))) == "D2" and v6 ~= nil and v6 >= 0 then
        return v6 <= 9007199254740991
    end

    return false
end

function t1.getCrc16(p4) -- line: 50
    -- upvalues: t1 (copy)
    assert(t1.getIsPayload(p4), "Expected a 16-digit hexadecimal payload")

    local n1 = 65535

    for i = 1, #p4, 2 do
        n1 = bit32.bxor(n1, (bit32.lshift(assert((tonumber(string.sub(p4, i, i + 1), 16))), 8)))

        for _ = 1, 8 do
            n1 = bit32.band(if bit32.band(n1, 32768) == 0 then bit32.lshift(n1, 1) else bit32.bxor(bit32.lshift(n1, 1), 4129), 65535)
        end
    end

    return n1
end

function t1.encode(p5) -- line: 71
    -- upvalues: t1 (copy)
    local v16 = bit32.bxor(t1.getCrc16(p5), 42405)
    local v17 = string.upper(p5) .. string.format("%04X", v16)
    local v18 = table.create(169, 0)
    local n2 = 0

    local function appendSymbol(p6) -- line: 78
        -- upvalues: v18 (copy), n2 (ref)
        v18[(n2 * 73 + 19) % 169 + 1] = p6
        n2 += 1
    end

    for i = 1, #v17 do
        local v22 = assert((tonumber(string.sub(v17, i, i), 16)))
        local v23 = bit32.extract(v22, 3)
        local v24 = bit32.extract(v22, 2)
        local v25 = bit32.extract(v22, 1)
        local v26 = bit32.extract(v22, 0)
        local v27 = bit32.bxor(v23, v24, v26)

        v18[(n2 * 73 + 19) % 169 + 1] = v27
        n2 += 1

        local v28 = bit32.bxor(v23, v25, v26)

        v18[(n2 * 73 + 19) % 169 + 1] = v28
        n2 += 1
        v18[(n2 * 73 + 19) % 169 + 1] = v23
        n2 += 1

        local v29 = bit32.bxor(v24, v25, v26)

        v18[(n2 * 73 + 19) % 169 + 1] = v29
        n2 += 1
        v18[(n2 * 73 + 19) % 169 + 1] = v24
        n2 += 1
        v18[(n2 * 73 + 19) % 169 + 1] = v25
        n2 += 1
        v18[(n2 * 73 + 19) % 169 + 1] = v26
        n2 += 1
    end

    for i = 0, 28 do
        local v30 = i / 3
        local v31 = (i * 7 + math.floor(v30)) % 2

        v18[(n2 * 73 + 19) % 169 + 1] = v31
        n2 += 1
    end

    return v18
end

function t1.getPair(p7) -- line: 105
    local v32 = p7 + 1

    local function nextNumber() -- line: 107
        -- upvalues: v32 (ref)
        v32 = (v32 * 25173 + 13849) % 65536

        return v32
    end

    v32 = (v32 * 25173 + 13849) % 65536

    local v33 = (v32 / 65535 - 0.5) * 0.24

    v32 = (v32 * 25173 + 13849) % 65536

    local v34 = (v32 / 65535 - 0.5) * 0.24

    v32 = (v32 * 25173 + 13849) % 65536

    local v35 = v32 % 2 == 1
    local v36 = (p7 % 13 + 0.5 + v33) / 13
    local v38 = (math.floor(p7 / 13) + 0.5 + v34) / 13
    local v40 = if v35 then 0 else 0.016923076923076923
    local v39 = if v35 then 0.016923076923076923 else 0

    return {
        ax = v36 - v40,
        ay = v38 - v39,
        bx = v36 + v40,
        by = v38 + v39
    }
end

return table.freeze(t1)
