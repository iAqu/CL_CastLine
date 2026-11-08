-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = buffer.create(64)
local v2 = buffer.create(256)

for i = 1, 64 do
    local v3 = i - 1
    local v4 = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)

    buffer.writeu8(v1, v3, v4)
    buffer.writeu8(v2, v4, v3)
end

function encode(p1, p2) -- line: 42
    -- upvalues: v1 (copy)
    p2 = p2 or buffer.len(p1)

    local v7 = math.ceil(p2 / 3)
    local v8 = v7 * 4
    local v9 = buffer.create(v8)

    for i = 1, v7 - 1 do
        local v10 = (i - 1) * 4
        local v12 = bit32.byteswap((buffer.readu32(p1, (i - 1) * 3)))
        local v13 = bit32.rshift(v12, 26)
        local v15 = bit32.band(bit32.rshift(v12, 20), 63)
        local v17 = bit32.band(bit32.rshift(v12, 14), 63)
        local v19 = bit32.band(bit32.rshift(v12, 8), 63)

        buffer.writeu8(v9, v10, (buffer.readu8(v1, v13)))

        local v21 = buffer.readu8(v1, v15)

        buffer.writeu8(v9, v10 + 1, v21)

        local v22 = buffer.readu8(v1, v17)

        buffer.writeu8(v9, v10 + 2, v22)

        local v23 = buffer.readu8(v1, v19)

        buffer.writeu8(v9, v10 + 3, v23)
    end

    local v24 = p2 % 3

    if v24 == 1 then
        local v26 = buffer.readu8(p1, p2 - 1)
        local v27 = bit32.rshift(v26, 2)
        local v29 = bit32.band(bit32.lshift(v26, 4), 63)

        buffer.writeu8(v9, v8 - 4, (buffer.readu8(v1, v27)))
        buffer.writeu8(v9, v8 - 3, (buffer.readu8(v1, v29)))
        buffer.writeu8(v9, v8 - 2, 61)
        buffer.writeu8(v9, v8 - 1, 61)
    elseif v24 == 2 then
        local v41 = bit32.bor(bit32.lshift(buffer.readu8(p1, p2 - 2), 8), (buffer.readu8(p1, p2 - 1)))
        local v42 = bit32.rshift(v41, 10)
        local v44 = bit32.band(bit32.rshift(v41, 4), 63)
        local v46 = bit32.band(bit32.lshift(v41, 2), 63)

        buffer.writeu8(v9, v8 - 4, (buffer.readu8(v1, v42)))
        buffer.writeu8(v9, v8 - 3, (buffer.readu8(v1, v44)))
        buffer.writeu8(v9, v8 - 2, (buffer.readu8(v1, v46)))
        buffer.writeu8(v9, v8 - 1, 61)
    elseif v24 == 0 and p2 ~= 0 then
        local v62 = bit32.bor(bit32.lshift(buffer.readu8(p1, p2 - 3), 16), bit32.lshift(buffer.readu8(p1, p2 - 2), 8), (buffer.readu8(p1, p2 - 1)))
        local v63 = bit32.rshift(v62, 18)
        local v65 = bit32.band(bit32.rshift(v62, 12), 63)
        local v67 = bit32.band(bit32.rshift(v62, 6), 63)
        local v68 = bit32.band(v62, 63)

        buffer.writeu8(v9, v8 - 4, (buffer.readu8(v1, v63)))
        buffer.writeu8(v9, v8 - 3, (buffer.readu8(v1, v65)))
        buffer.writeu8(v9, v8 - 2, (buffer.readu8(v1, v67)))
        buffer.writeu8(v9, v8 - 1, (buffer.readu8(v1, v68)))
    end

    return v9
end

function decode(p3) -- line: 113
    -- upvalues: v2 (copy)
    local v77 = buffer.len(p3)
    local v79 = math.ceil(v77 / 4)
    local v80

    if v77 == 0 then
        v80 = 0
    else
        local v82 = if buffer.readu8(p3, v77 - 1) == 61 then 0 + 1 else 0

        v80 = if buffer.readu8(p3, v77 - 2) == 61 then v82 + 1 else v82
    end

    local v84 = v79 * 3 - v80
    local v85 = buffer.create(v84)

    for i = 1, v79 - 1 do
        local v86 = (i - 1) * 4
        local v87 = (i - 1) * 3
        local v89 = buffer.readu8(v2, (buffer.readu8(p3, v86)))
        local v91 = buffer.readu8(v2, (buffer.readu8(p3, v86 + 1)))
        local v93 = buffer.readu8(v2, (buffer.readu8(p3, v86 + 2)))
        local v95 = buffer.readu8(v2, (buffer.readu8(p3, v86 + 3)))
        local v99 = bit32.bor(bit32.lshift(v89, 18), bit32.lshift(v91, 12), bit32.lshift(v93, 6), v95)
        local v100 = bit32.rshift(v99, 16)
        local v102 = bit32.band(bit32.rshift(v99, 8), 255)
        local v103 = bit32.band(v99, 255)

        buffer.writeu8(v85, v87, v100)
        buffer.writeu8(v85, v87 + 1, v102)
        buffer.writeu8(v85, v87 + 2, v103)
    end

    if v77 ~= 0 then
        local v104 = (v79 - 1) * 4
        local v105 = (v79 - 1) * 3
        local v107 = buffer.readu8(v2, (buffer.readu8(p3, v104)))
        local v110 = buffer.readu8(v2, (buffer.readu8(p3, v104 + 1)))
        local v113 = buffer.readu8(v2, (buffer.readu8(p3, v104 + 2)))
        local v116 = buffer.readu8(v2, (buffer.readu8(p3, v104 + 3)))
        local v120 = bit32.bor(bit32.lshift(v107, 18), bit32.lshift(v110, 12), bit32.lshift(v113, 6), v116)

        if v80 <= 2 then
            buffer.writeu8(v85, v105, (bit32.rshift(v120, 16)))

            if v80 <= 1 then
                local v123 = bit32.band(bit32.rshift(v120, 8), 255)

                buffer.writeu8(v85, v105 + 1, v123)

                if v80 == 0 then
                    local v125 = bit32.band(v120, 255)

                    buffer.writeu8(v85, v105 + 2, v125)
                end
            end
        end
    end

    return v85
end

function Encode(p4) -- line: 186
    return buffer.tostring(encode(buffer.fromstring(p4)))
end

function Decode(p5) -- line: 190
    return buffer.tostring(decode(buffer.fromstring(p5)))
end

return table.freeze({
    Encode = Encode,
    Decode = Decode,
    EncodeBuffer = encode,
    DecodeBuffer = decode
})
