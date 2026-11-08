-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function StableExp10(p1, p2) -- line: 25
    assert(type(p1) == "number")
    assert(type(p2) == "number")

    if p2 == 0 then
        return p1
    end

    return tonumber((("%*e%*"):format(string.format("%f", p1), p2))) or p1 * 10 ^ p2
end

return StableExp10
