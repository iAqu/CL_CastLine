-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    NAME = "Mimic",
    BOOST = 20,
    STEP = 10,
    WEIGHT = 70,
    SCALE = 2
}

function t1.Boost(p1) -- line: 17
    -- upvalues: t1 (copy)
    return t1.BOOST + t1.STEP * ((p1 or 1) - 1)
end

return t1
