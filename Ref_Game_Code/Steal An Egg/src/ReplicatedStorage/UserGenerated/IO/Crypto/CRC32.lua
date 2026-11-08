-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

for i = 0, 255 do
    local v1 = i

    for _ = 1, 8 do
        v1 = if bit32.band(v1, 1) == 0 then bit32.rshift(v1, 1) else bit32.bxor(bit32.rshift(v1, 1), 3988292384)
    end

    t1[i + 1] = v1
end

local t2 = {
    Init = function() -- Init | line: 44
        return 4294967295
    end
}

function t2.Update(p1, p2, p3, p4) -- line: 48
    -- upvalues: t1 (copy)
    p3 = p3 or 1

    local v4 = p3 + (p4 or string.len(p2)) - 1
    local v5 = p1

    for i = p3, v4 do
        local v6 = string.byte(p2, i)

        v5 = bit32.bxor(bit32.rshift(v5, 8), t1[bit32.band(bit32.bxor(v5, v6), 255) + 1])
    end

    return v5
end

function t2.UpdateBuffer(p5, p6, p7, p8) -- line: 59
    -- upvalues: t1 (copy)
    p7 = p7 or 0

    local v11 = p7 + (p8 or buffer.len(p6)) - 1
    local v12 = p5

    for i = p7, v11 do
        local v13 = buffer.readu8(p6, i)

        v12 = bit32.bxor(bit32.rshift(v12, 8), t1[bit32.band(bit32.bxor(v12, v13), 255) + 1])
    end

    return v12
end

function t2.Finish(p9) -- line: 70
    return (bit32.bnot(p9))
end

function t2.Digest(p10, p11, p12) -- line: 74
    -- upvalues: t2 (copy)
    local v17 = t2.Init()
    local v18 = t2.Update(v17, p10, p11, p12)

    return t2.Finish(v18)
end

function t2.DigestBuffer(p13, p14, p15) -- line: 80
    -- upvalues: t2 (copy)
    local v19 = t2.Init()
    local v20 = t2.UpdateBuffer(v19, p13, p14, p15)

    return t2.Finish(v20)
end

return table.freeze(t2)
