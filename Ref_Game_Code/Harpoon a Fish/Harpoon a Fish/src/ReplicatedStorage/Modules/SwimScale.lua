-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    SPEED_EXP = 0.43
}

function t1.speed(p1) -- line: 13
    -- upvalues: t1 (copy)
    return (p1 or 1) ^ t1.SPEED_EXP
end

function t1.beat(p2) -- line: 18
    -- upvalues: t1 (copy)
    return (p2 or 1) ^ (t1.SPEED_EXP - 1)
end

return t1
