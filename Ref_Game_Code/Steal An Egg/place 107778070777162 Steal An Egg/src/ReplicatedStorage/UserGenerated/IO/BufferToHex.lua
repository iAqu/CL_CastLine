-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function BufferToHex(p1) -- line: 20
    local v1 = buffer.len(p1)
    local v2 = buffer.create(v1 * 2)

    for i = 0, v1 - 1 do
        local v3 = buffer.readu8(p1, i)
        local v4 = bit32.rshift(v3, 4)
        local v5 = bit32.band(v3, 15)
        local v6 = if v4 < 10 then v4 + 48 else v4 + 87

        buffer.writeu8(v2, i * 2 + 0, v6)

        local v7 = if v5 < 10 then v5 + 48 else v5 + 87

        buffer.writeu8(v2, i * 2 + 1, v7)
    end

    return buffer.tostring(v2)
end

return BufferToHex
