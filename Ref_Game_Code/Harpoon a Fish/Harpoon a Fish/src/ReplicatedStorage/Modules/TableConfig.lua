-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    MAX_LEVEL = 18,
    BITES_PER_SECOND = 3.5,
    FAT_PER_BITE = {
        2, 5, 12, 30, 80, 100, 200, 500,
        1000, 2000, 4000, 8000, 16000, 32000, 64000, 256000,
        1024000, 4096000
    }
}

function t1.FatPerBite(p1) -- line: 25
    -- upvalues: t1 (copy)
    local v4 = math.clamp(math.floor(p1 or 1), 1, #t1.FAT_PER_BITE)

    return t1.FAT_PER_BITE[v4]
end

local t2 = {
    0, 100, 2500, 7700, 23700, 73100, 225000, 4340000,
    83700000, 3.84E+09, 1.76E+11, 1.49E+12, 1.25E+13, 3.26E+13, 8.49E+13, 3.34E+15,
    2.22E+16, 1.11E+17
}

function t1.UpgradeCost(p2) -- line: 41
    -- upvalues: t1 (copy), t2 (copy)
    p2 = p2 or 1

    return if not (t1.MAX_LEVEL <= p2) then t2[p2 + 1] else nil
end

return t1
