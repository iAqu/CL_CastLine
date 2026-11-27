-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    ROWS = {
        GreenlandHydra = {
            base = 33,
            step = 11,
            from = 6,
            upgraded = {
                {
                    mutation = "Molten",
                    base = 125
                },
                {
                    mutation = "Shadow",
                    base = 300
                },
                {
                    mutation = "Rainbow",
                    base = 666
                }
            }
        },
        GhostMegalodon = {
            base = 250,
            step = 37.5,
            from = 4,
            clock = { 1800, 3600, 10800, 86400, 172800, 259200, 345600, 432000 }
        },
        Fatty = {
            item = true
        },
        Jormungandr = {
            base = 300,
            step = 50,
            from = 4,
            single = true,
            clock = { 1800, 3600, 10800, 86400, 172800, 259200, 345600, 432000 }
        },
        PumpkinGuppy = {
            base = 20,
            step = 2.5,
            from = 1,
            single = true
        },
        TurkeyFish = {
            base = 100,
            step = 0,
            from = 9,
            single = true
        },
        IdeaFish = {
            base = 500,
            step = 0,
            from = 9,
            single = true
        },
        Hydrax = {
            base = 400,
            step = 50,
            from = 8,
            clock = { 1800, 3600, 10800, 86400, 172800, 259200, 345600, 432000 }
        },
        Tricerosaurus = {
            base = 200,
            step = 25,
            from = 8,
            clock = { 1800, 3600, 10800, 86400, 172800, 259200, 345600, 432000 }
        },
        WishboneWyrm = {
            base = 400,
            step = 50,
            from = 8,
            clock = { 1800, 3600, 10800, 86400, 172800, 259200, 345600, 432000 }
        }
    }
}

function t1.Of(p1) -- line: 57
    -- upvalues: t1 (copy)
    local v1 = p1 and t1.ROWS[p1.name]

    if not v1 then
        return nil
    end

    if v1.item then
        return (math.floor(p1.boost or 0))
    end

    local base = v1.base

    for _, v3 in ipairs(v1.upgraded or {}) do
        if p1.mutation == v3.mutation then
            base = v3.base
        end
    end

    return (math.floor(base + v1.step * math.max(0, (p1.stage or v1.from) - v1.from)))
end

function t1.Counted(p2) -- line: 70
    -- upvalues: t1 (copy)
    local t2 = {}
    local t3 = {}

    for _, v6 in ipairs(p2 or {}) do
        local v7 = t1.Of(v6)

        if v7 then
            if t1.ROWS[v6.name].single then
                local v8 = t3[v6.name]

                if v8 then
                    if t1.Of(v8) < v7 then
                        t2[v8] = nil
                        t3[v6.name] = v6
                        t2[v6] = true
                    end
                else
                    t3[v6.name] = v6
                    t2[v6] = true
                end
            else
                t2[v6] = true
            end
        end
    end

    return t2
end

t1.COPY = {
    Mimefish = 1,
    Rainbowborous = 10,
    Jestershark = 2,
    Jesterwraith = 2,
    AbyssalFlameLeviathan = 1,
    MummifiedMosasaur = 3,
    AbominatedMaw = 1.5,
    Fossilshark = 2,
    Dreadsaber = 5,
    BonedMosasaur = 2.5,
    PecanPike = 2.5,
    FeastedLeviathan = 1.5
}

function t1.CopyMul(p3) -- line: 113
    -- upvalues: t1 (copy)
    return p3 ~= nil and t1.COPY[p3.name] or 0
end

function t1.Copies(p4) -- line: 116
    -- upvalues: t1 (copy)
    return p4 ~= nil and t1.COPY[p4.name] ~= nil
end

t1.EAT = {
    MrHotdog = 10
}

function t1.EatMul(p5) -- line: 124
    -- upvalues: t1 (copy)
    return p5 and t1.EAT[p5.name] or nil
end

function t1.At(p6, p7, p8) -- line: 129
    -- upvalues: t1 (copy)
    return t1.Of({
        name = p6,
        stage = p7,
        mutation = p8
    })
end

return t1
