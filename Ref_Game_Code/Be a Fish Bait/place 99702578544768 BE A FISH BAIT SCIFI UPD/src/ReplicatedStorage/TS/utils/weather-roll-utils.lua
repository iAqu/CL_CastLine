-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function cursorKey(p1, p2, p3) -- line: 13
    return (("%*|%*|%*|%*|%*"):format(p1, p2.minMinutesBeforeRoll, p2.baseChancePerMinute, p2.chanceIncreasePerMinutePastThreshold, p3))
end

local function chanceForMinutePastThreshold(p4, p5) -- line: 16
    return (math.min(1, p4.baseChancePerMinute + p4.chanceIncreasePerMinutePastThreshold * p5))
end

local function currentRollChance(p6, p7) -- line: 22
    local v3 = math.floor(p7 / 60) - p6.minMinutesBeforeRoll

    if v3 < 0 then
        return p6.baseChancePerMinute
    end

    return (math.min(1, p6.baseChancePerMinute + p6.chanceIncreasePerMinutePastThreshold * v3))
end

local function slotRollHits(p8, p9) -- line: 32
    if p9 <= 0 then
        return false
    end

    if p9 >= 1 then
        return true
    end

    return Random.new(p8):NextNumber() <= p9
end

return {
    deluluScheduleEpoch = 1704067200,
    chanceForMinutePastThreshold = chanceForMinutePastThreshold,
    currentRollChance = currentRollChance,
    computeRollScheduleState = function(p10, p11, p12, p13, p14) -- computeRollScheduleState | line: 49
        -- upvalues: t1 (copy)
        local v5 = p12 * 60
        local v6 = p11.minMinutesBeforeRoll * 60
        local v7 = ("%*|%*|%*|%*|%*"):format(p10, p11.minMinutesBeforeRoll, p11.baseChancePerMinute, p11.chanceIncreasePerMinutePastThreshold, p12)
        local v8 = t1[v7]

        if v8 == nil or not (v8 <= p13) then
            v8 = 1704067200
        end

        while true do
            local v9 = v8 + v6

            if p13 < v9 then
                break
            end

            local v11 = math.floor(v9 / 60)
            local v13 = math.floor(p13 / 60)
            local v14 = v11
            local v15 = false
            local v16

            while true do
                if v15 then
                    v14 += 1
                else
                    v15 = true
                end

                if v14 <= v13 then
                    local v17 = v14 - v11
                    local v19 = math.min(1, p11.baseChancePerMinute + p11.chanceIncreasePerMinutePastThreshold * v17)
                    local v20 = not (v19 <= 0) and (v19 >= 1 or Random.new(v14):NextNumber() <= v19)
                    local v21

                    if v20 then
                        local v22 = v14 * 60
                        local v23 = v22 + v5

                        v21 = if p14 ~= nil then p14(v22, v23) else p14
                    end

                    if not v20 or v21 then
                        continue
                    end

                    v16 = v14
                else
                    v16 = nil
                end

                break
            end

            if v16 == nil then
                t1[v7] = v8

                return {
                    isActive = false,
                    lastEndedAt = v8
                }
            end

            local v24 = v16 * 60 + v5

            if p13 < v24 then
                t1[v7] = v8

                return {
                    isActive = true,
                    lastEndedAt = v8,
                    activeEndTimestamp = v24
                }
            end

            v8 = v24
        end

        t1[v7] = v8

        return {
            isActive = false,
            lastEndedAt = v8
        }
    end
}
