-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    RUNG = 5,
    CASH_FLOOR = 1000,
    REWARDS = {
        {
            potion = "B1"
        },
        {
            cash = 5
        },
        {
            potion = "T1"
        },
        {
            potion = "B1"
        },
        {
            cash = 30
        },
        {
            potion = "T3"
        },
        {
            potion = "B3"
        },
        {
            egg = "MassiveEgg"
        }
    },
    LAST_BY_ZONE = {
        {
            potion = "T4"
        },
        {
            potion = "T4"
        }
    },
    BY_TAB = {
        [102] = {
            rung = 3,
            reward = {
                egg = "MassiveEgg"
            }
        }
    }
}

function t1.Cash(p1, p2) -- line: 41
    -- upvalues: t1 (copy)
    return (math.max(t1.CASH_FLOOR, (math.floor((p2 or 0) * 60 * p1.cash))))
end

function t1.Rungs(p3, p4) -- line: 46
    -- upvalues: t1 (copy)
    local v3 = p4 and t1.BY_TAB[p4]

    if v3 then
        local t2 = {}
        local v4 = p3

        while v3.rung <= v4 do
            t2[#t2 + 1] = {
                size = v3.rung,
                reward = v3.reward
            }
            v4 -= v3.rung
        end

        if v4 > 0 and #t2 > 0 then
            t2[#t2].size += v4
        end

        return t2
    end

    local t3 = {}
    local v5 = p3

    for v6, v7 in ipairs(t1.REWARDS) do
        if v5 <= 0 then
            break
        end

        local v8 = if v6 == #t1.REWARDS and v5 then v5 else math.min(t1.RUNG, v5)

        t3[#t3 + 1] = {
            size = v8,
            reward = v7
        }
        v5 -= v8
    end

    if #t3 > 0 then
        t3[#t3].reward = t1.LAST_BY_ZONE[p4] or t1.REWARDS[#t1.REWARDS]
    end

    return t3
end

function t1.Filled(p5, p6, p7) -- line: 72
    -- upvalues: t1 (copy)
    local n1 = 0
    local n2 = 0

    for _, v9 in ipairs(t1.Rungs(p5, p7)) do
        n2 += v9.size

        if p6 < n2 then
            break
        end

        n1 += 1
    end

    return n1
end

function t1.At(p8, p9, p10) -- line: 84
    -- upvalues: t1 (copy)
    local v10 = t1.Rungs(p8, p10)
    local n3 = 0

    for v11, v12 in ipairs(v10) do
        if p9 < n3 + v12.size then
            return v11, p9 - n3, v12.size, v10, false
        end

        n3 += v12.size
    end

    local v13 = v10[#v10]
    local v14 = #v10
    local size = v13 and v13.size or 0
    local size2 = v13 and v13.size or 0

    return v14, size, size2, v10, true
end

return t1
