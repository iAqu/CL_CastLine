-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    MAX_LEVEL = 11
}
local t2 = {
    0, 10, 500, 5000, 50000, 5E+05, 1E+07, 2.5E+08,
    6E+09, 1.5E+11, 4E+12
}
local t3 = {
    1, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12
}

function t1.Slots(p1) -- line: 18
    -- upvalues: t1 (copy), t3 (copy)
    return t3[math.clamp(p1 or 1, 1, t1.MAX_LEVEL)]
end

function t1.UpgradeCost(p2) -- line: 23
    -- upvalues: t1 (copy), t2 (copy)
    p2 = p2 or 1

    return if not (t1.MAX_LEVEL <= p2) then t2[p2 + 1] else nil
end

return t1
