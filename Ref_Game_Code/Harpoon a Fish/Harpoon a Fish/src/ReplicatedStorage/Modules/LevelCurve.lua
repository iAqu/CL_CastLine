-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    CAP = 1000
}

function t1.Need(p1) -- line: 19
    -- upvalues: t1 (copy)
    return (math.min(5 + 5 * p1, t1.CAP))
end

function t1.Total(p2, p3) -- line: 25
    -- upvalues: t1 (copy)
    local v4 = math.max(0, math.floor(p2 or 1) - 1)
    local v7 = math.min(v4, (math.floor((t1.CAP - 5) / 5)))

    return v7 * 5 + v7 * 5 * (v7 + 1) / 2 + (v4 - v7) * t1.CAP + (p3 or 0)
end

t1.CATCH = {
    Common = 5,
    Uncommon = 10,
    Rare = 20,
    Epic = 40,
    Legendary = 80,
    Mythic = 150,
    Exotic = 250,
    Secret = 500,
    Celestial = 500,
    Apex = 1000,
    Unknown = 500
}
t1.NEW = 20
t1.BIGGEST = 5
t1.MUTATION = {
    Silver = 1.25,
    Gold = 1.5,
    Molten = 2,
    Radioactive = 2.5,
    Admin = 2.75,
    Shadow = 3,
    Ghost = 3.5,
    Electric = 4,
    Thanksgiving = 4,
    Voidstorm = 4.5,
    Meteorite = 4.5,
    PinkMoon = 4.6,
    Fossilized = 4.6,
    Hallowed = 4.75,
    Rainbow = 5
}

return t1
