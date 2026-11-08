-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local function readU16(p1, p2, p3) -- line: 3
    return (bit32.extract(bit32.bor(bit32.lshift(buffer.readu8(p1, p2), 8), (buffer.readu8(p1, p2 + 1))), 0, p3))
end

local function read(p4, p5, p6, p7) -- line: 11
    local v6, v7, v8, v9

    if p6.colorType == 0 then
        assert(p5.length == 2, "invalid tRNS length for color type")

        local offset = p5.offset
        local bitDepth = p6.bitDepth

        v6 = bit32.extract(bit32.bor(bit32.lshift(buffer.readu8(p4, offset), 8), (buffer.readu8(p4, offset + 1))), 0, bitDepth)
        v7 = -1
        v8 = -1
        v9 = -1
    elseif p6.colorType == 2 then
        assert(p5.length == 6, "invalid tRNS length for color type")

        local offset = p5.offset
        local bitDepth = p6.bitDepth

        v7 = bit32.extract(bit32.bor(bit32.lshift(buffer.readu8(p4, offset), 8), (buffer.readu8(p4, offset + 1))), 0, bitDepth)

        local v22 = p5.offset + 2
        local bitDepth2 = p6.bitDepth

        v8 = bit32.extract(bit32.bor(bit32.lshift(buffer.readu8(p4, v22), 8), (buffer.readu8(p4, v22 + 1))), 0, bitDepth2)

        local v28 = p5.offset + 4
        local bitDepth3 = p6.bitDepth

        v6 = -1
        v9 = bit32.extract(bit32.bor(bit32.lshift(buffer.readu8(p4, v28), 8), (buffer.readu8(p4, v28 + 1))), 0, bitDepth3)
    else
        local length = p5.length

        assert(p7, "tRNS requires PLTE for color type")

        local v34 = length <= #p7.colors

        v6 = -1
        v7 = -1
        v8 = -1
        v9 = -1
        assert(v34, "tRNS specified too many PLTE alphas")

        for i = 1, length do
            local v35 = p7.colors[i]
            local v36 = p5.offset + i - 1

            v6 = -1
            v7 = -1
            v8 = -1
            v9 = -1
            v35.a = buffer.readu8(p4, v36)
        end
    end

    return {
        gray = v6,
        red = v7,
        green = v8,
        blue = v9
    }
end

return read
