-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function foldByte(p1, p2) -- line: 9
    local v1 = bit32.bxor(p1, p2)

    for _ = 1, 8 do
        local v2 = bit32.band(v1, 1)

        v1 = bit32.rshift(v1, 1)

        if v2 == 1 then
            v1 = bit32.bxor(v1, 3988292384)
        end
    end

    return v1
end

function t1.CRC32(p3) -- line: 21
    -- upvalues: foldByte (copy)
    local v3 = buffer.fromstring(p3)
    local v4 = buffer.len(v3) - 1
    local n1 = 4294967295

    for i = 0, v4 do
        n1 = foldByte(n1, (buffer.readu8(v3, i)))
    end

    return (bit32.bnot(n1))
end

function t1.PathSeed(...) -- line: 30
    -- upvalues: t1 (copy)
    local v5 = table.pack(...)

    for i = 1, v5.n do
        v5[i] = tostring(v5[i])
    end

    return t1.CRC32(table.concat(v5, "/", 1, v5.n))
end

return table.freeze(t1)
