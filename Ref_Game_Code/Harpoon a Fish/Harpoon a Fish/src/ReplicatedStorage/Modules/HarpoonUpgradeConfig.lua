-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    STEP = 0.0025,
    AMP_LEVELS = 200,
    ROLL_BASE = 1E+14,
    ROLL_GROWTH = 1.1,
    SLOT2 = 2.5E+17,
    FIRST = 1E+13,
    LAST = 1E+21,
    PERKS = {
        {
            key = "reel",
            name = "Slower Minigame",
            pct = 32,
            max = 40
        },
        {
            key = "size",
            name = "Size Bonus",
            pct = 32,
            max = 40
        },
        {
            key = "life",
            name = "Extra Life Chance",
            pct = 32,
            max = 40
        },
        {
            key = "double",
            name = "Double Catch Chance",
            pct = 2,
            max = 20,
            rare = true
        },
        {
            key = "instant",
            name = "Instant Catch Chance",
            pct = 2,
            max = 20,
            rare = true
        }
    }
}
local t2 = {}

for _, v1 in ipairs(t1.PERKS) do
    t2[v1.key] = v1
end

function t1.Perk(p1) -- line: 42
    -- upvalues: t2 (copy)
    return t2[p1]
end

local function ladder(p2, p3) -- line: 45
    -- upvalues: t1 (copy)
    return t1.FIRST * (t1.LAST / t1.FIRST) ^ ((p2 - 1) / math.max(1, p3 - 1))
end

function t1.AmpCost(p4) -- line: 48
    -- upvalues: t1 (copy)
    if t1.AMP_LEVELS <= p4 then
        return nil
    end

    local v5 = p4 + 1
    local AMP_LEVELS = t1.AMP_LEVELS

    return t1.FIRST * (t1.LAST / t1.FIRST) ^ ((v5 - 1) / math.max(1, AMP_LEVELS - 1))
end

function t1.PerkCost(p5, p6) -- line: 53
    -- upvalues: t1 (copy), t2 (copy)
    local v9 = t2[p5]

    if not v9 or v9.max <= p6 then
        return nil
    end

    local v10 = v9.max - 1

    return t1.FIRST * (t1.LAST / t1.FIRST) ^ ((p6 - 1) / math.max(1, v10 - 1))
end

function t1.RollCost(p7) -- line: 59
    -- upvalues: t1 (copy)
    return t1.ROLL_BASE * t1.ROLL_GROWTH ^ (p7 or 0)
end

function t1.Odds(p8) -- line: 62
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v14 in ipairs(t1.PERKS) do
        if v14.key ~= p8 then
            n1 += v14.pct
        end
    end

    local t3 = {}

    for _, v15 in ipairs(t1.PERKS) do
        t3[v15.key] = v15.key ~= p8 and v15.pct * 100 / n1 or 0
    end

    return t3
end

function t1.Roll(p9, p10) -- line: 70
    -- upvalues: t1 (copy)
    local v16 = t1.Odds(p10)
    local n2 = 0
    local key

    for _, v17 in ipairs(t1.PERKS) do
        if v16[v17.key] > 0 then
            n2 += v16[v17.key] / 100
            key = v17.key

            if p9 < n2 then
                return v17.key
            end
        end
    end

    return key
end

function t1.ChooseCost(p11, p12, p13) -- line: 84
    -- upvalues: t1 (copy), t2 (copy)
    local v18 = t2[p12] and t1.Odds(p13)[p12]
    local v19, v20

    if v18 and v18 > 0 then
        local v21 = t1.RollCost(p11) * 100 / v18

        if v21 then
            v19 = v21
            v20 = true
        else
            v20 = false
        end
    else
        v20 = false
    end

    if not v20 then
        v19 = nil
    end

    return v19
end

function t1.Value(p14) -- line: 90
    -- upvalues: t1 (copy)
    return (p14 or 0) * t1.STEP
end

return t1
