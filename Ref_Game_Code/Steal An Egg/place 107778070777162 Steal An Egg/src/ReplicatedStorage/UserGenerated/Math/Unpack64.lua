-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function Unpack64(p1) -- line: 20
    if p1 < 0 then
        local v1 = -1 - p1

        return bit32.bnot(v1 // 4294967296), (bit32.bnot(v1))
    end

    return bit32.bor(p1 // 4294967296, 0), (bit32.bor(p1, 0))
end

return Unpack64
