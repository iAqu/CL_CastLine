-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DAY_SECONDS = 86400,
    List = {
        {
            kind = "cash",
            mins = 5,
            min = 1000
        },
        {
            kind = "lucky",
            n = 3
        },
        {
            kind = "potion",
            n = 1
        },
        {
            kind = "cash",
            mins = 15,
            min = 3000
        },
        {
            kind = "lucky",
            n = 5
        },
        {
            kind = "potion",
            n = 2
        },
        {
            kind = "egg",
            key = "CosmicEgg",
            n = 1
        }
    }
}

function t1.Today(p1) -- line: 15
    -- upvalues: t1 (copy)
    return (math.floor((p1 or os.time()) / t1.DAY_SECONDS))
end

function t1.SecondsLeft(p2) -- line: 19
    -- upvalues: t1 (copy)
    p2 = p2 or os.time()

    return t1.DAY_SECONDS - p2 % t1.DAY_SECONDS
end

function t1.State(p3, p4) -- line: 24
    -- upvalues: t1 (copy)
    local v3 = type(p3) == "table" and tonumber(p3.last) or 0
    local v4 = type(p3) == "table" and tonumber(p3.streak) or 0
    local v5 = #t1.List

    if v4 >= 1 and v4 <= v5 and v3 == p4 then
        return v4, false
    end

    if v4 >= 1 and v4 <= v5 and v3 == p4 - 1 then
        return v4 % v5 + 1, true
    end

    return 1, true
end

function t1.Cash(p5, p6) -- line: 37
    return (math.max(p5.min or 0, (math.floor((p6 or 0) * 60 * (p5.mins or 0)))))
end

return t1
