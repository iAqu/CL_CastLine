-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local function read(p1, p2, p3) -- line: 3
    assert(p2.length % 3 == 0, "malformed PLTE chunk")

    local v2 = p2.length / 3

    assert(v2 > 0, "no entries in PLTE")
    assert(v2 <= 256, "too many entries in PLTE")
    assert(v2 <= 2 ^ p3.bitDepth, "too many entries in PLTE for bit depth")

    local v6 = table.create(v2)
    local v7 = p2.offset

    for i = 1, v2 do
        v6[i] = {
            a = 255,
            r = buffer.readu8(p1, v7),
            g = buffer.readu8(p1, v7 + 1),
            b = buffer.readu8(p1, v7 + 2)
        }
        v7 += 3
    end

    return {
        colors = v6
    }
end

return read
