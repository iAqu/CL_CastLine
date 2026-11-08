-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function mult(p1, p2) -- line: 37
    return bit32.band(p1, 65535) * p2 + bit32.lshift(bit32.band(bit32.rshift(p1, 16) * p2, 65535), 16)
end

local function xxhash32(p3, p4) -- line: 50
    local v4 = if p4 == nil then 0 else bit32.bor(p4, 0)
    local v5 = #p3
    local v6, v7, v8

    if v5 >= 16 then
        local v9 = v4 + 2654435761 + 2246822519
        local v10 = v4 + 2246822519
        local v11 = v4 - 2654435761
        local v12 = v5 - 16

        v7 = 1
        v6 = 1

        for _ = 0, v12, 16 do
            local v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29 = string.byte(p3, v6, v6 + 15)
            local v33 = bit32.bor(bit32.lshift(v17, 24), bit32.lshift(v16, 16), bit32.lshift(v15, 8), v14)
            local v38 = bit32.lrotate(v9 + (bit32.band(v33, 65535) * 2246822519 + bit32.lshift(bit32.band(bit32.rshift(v33, 16) * 2246822519, 65535), 16)), 13)

            v9 = bit32.band(v38, 65535) * 2654435761 + bit32.lshift(bit32.band(bit32.rshift(v38, 16) * 2654435761, 65535), 16)

            local v45 = bit32.bor(bit32.lshift(v21, 24), bit32.lshift(v20, 16), bit32.lshift(v19, 8), v18)
            local v50 = bit32.lrotate(v10 + (bit32.band(v45, 65535) * 2246822519 + bit32.lshift(bit32.band(bit32.rshift(v45, 16) * 2246822519, 65535), 16)), 13)

            v10 = bit32.band(v50, 65535) * 2654435761 + bit32.lshift(bit32.band(bit32.rshift(v50, 16) * 2654435761, 65535), 16)

            local v57 = bit32.bor(bit32.lshift(v25, 24), bit32.lshift(v24, 16), bit32.lshift(v23, 8), v22)
            local v62 = bit32.lrotate(v4 + (bit32.band(v57, 65535) * 2246822519 + bit32.lshift(bit32.band(bit32.rshift(v57, 16) * 2246822519, 65535), 16)), 13)

            v4 = bit32.band(v62, 65535) * 2654435761 + bit32.lshift(bit32.band(bit32.rshift(v62, 16) * 2654435761, 65535), 16)

            local v69 = bit32.bor(bit32.lshift(v29, 24), bit32.lshift(v28, 16), bit32.lshift(v27, 8), v26)
            local v74 = bit32.lrotate(v11 + (bit32.band(v69, 65535) * 2246822519 + bit32.lshift(bit32.band(bit32.rshift(v69, 16) * 2246822519, 65535), 16)), 13)

            v11 = bit32.band(v74, 65535) * 2654435761 + bit32.lshift(bit32.band(bit32.rshift(v74, 16) * 2654435761, 65535), 16)
            v7 += 4
            v6 += 16
        end

        v8 = bit32.lrotate(v9, 1) + bit32.lrotate(v10, 7) + bit32.lrotate(v4, 12) + bit32.lrotate(v11, 18)
    else
        v7 = 1
        v6 = 1
        v8 = bit32.bor(v4 + 374761393, 0)
    end

    local v80 = bit32.bor(v8 + v5, 0)

    for _ = v7, v5 // 4 do
        local v82, v83, v84, v85 = string.byte(p3, v6, v6 + 3)
        local v89 = bit32.bor(bit32.lshift(v85, 24), bit32.lshift(v84, 16), bit32.lshift(v83, 8), v82)
        local v94 = bit32.lrotate(v80 + (bit32.band(v89, 65535) * 3266489917 + bit32.lshift(bit32.band(bit32.rshift(v89, 16) * 3266489917, 65535), 16)), 17)

        v80 = bit32.band(v94, 65535) * 668265263 + bit32.lshift(bit32.band(bit32.rshift(v94, 16) * 668265263, 65535), 16)
        v7 += 1
        v6 += 4
    end

    for i = -(v5 % 4), -1 do
        local v98 = string.byte(p3, i)
        local v103 = bit32.lrotate(v80 + (bit32.band(v98, 65535) * 374761393 + bit32.lshift(bit32.band(bit32.rshift(v98, 16) * 374761393, 65535), 16)), 11)

        v80 = bit32.band(v103, 65535) * 2654435761 + bit32.lshift(bit32.band(bit32.rshift(v103, 16) * 2654435761, 65535), 16)
    end

    local v108 = bit32.bxor(v80, (bit32.rshift(v80, 15)))
    local v112 = bit32.band(v108, 65535) * 2246822519 + bit32.lshift(bit32.band(bit32.rshift(v108, 16) * 2246822519, 65535), 16)
    local v114 = bit32.bxor(v112, (bit32.rshift(v112, 13)))
    local v118 = bit32.band(v114, 65535) * 3266489917 + bit32.lshift(bit32.band(bit32.rshift(v114, 16) * 3266489917, 65535), 16)

    return (bit32.bxor(v118, (bit32.rshift(v118, 16))))
end

return xxhash32
