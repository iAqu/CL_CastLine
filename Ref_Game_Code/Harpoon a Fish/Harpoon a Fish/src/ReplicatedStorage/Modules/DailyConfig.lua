-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DAYS = {
        {
            key = "Wood",
            count = 5
        },
        {
            mimic = true
        },
        {
            egg = "MassiveEgg"
        },
        {
            key = "Diamond",
            count = 5
        },
        {
            egg = "HellEgg"
        },
        {
            key = "Secret",
            count = 3
        },
        {
            egg = "VoidEgg"
        }
    },
    LATER = {
        {
            key = "Ruby",
            count = 5
        },
        {
            key = "Ruby",
            count = 5
        },
        {
            key = "Ruby",
            count = 5
        },
        {
            key = "Secret",
            count = 1
        },
        {
            key = "Ruby",
            count = 5
        },
        {
            key = "Ruby",
            count = 5
        },
        {
            egg = "VoidEgg"
        }
    }
}

function t1.Day(p1, p2) -- line: 32
    -- upvalues: t1 (copy)
    return (p2 or 1) > 1 and t1.LATER[p1] or t1.DAYS[p1]
end

function t1.Position(p3) -- line: 37
    -- upvalues: t1 (copy)
    local v3 = math.max(0, (math.floor(p3 or 0)))

    return math.floor(v3 / #t1.DAYS) + 1, v3 % #t1.DAYS
end

t1.GAP = 86400

return t1
