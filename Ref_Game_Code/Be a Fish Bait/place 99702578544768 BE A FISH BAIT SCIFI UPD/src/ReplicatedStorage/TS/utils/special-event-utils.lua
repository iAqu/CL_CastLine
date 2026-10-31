-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local specialEvents = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "special-events").specialEvents
local t1 = {}
local n1 = 0

for v1, v2 in specialEvents do
    table.insert(t1, {
        cooldown = v2.cooldown,
        cumulativeStart = n1,
        duration = v2.duration,
        kind = v1
    })
    n1 += v2.duration + v2.cooldown
end

local function v3(p1, p2) -- line: 26
    return p1 + p2.duration + p2.cooldown
end

local n2 = 0

for i = 1, #t1 do
    local v5 = t1[i]
    local _ = i - 1

    n2 = n2 + v5.duration + v5.cooldown
end

local function resolveActiveSpecialEventSegment(p3) -- line: 38
    -- upvalues: t1 (copy), n2 (ref)
    local v6 = p3 - p3 % n2
    local v7 = p3 - v6

    for _, v8 in t1 do
        if v8.cumulativeStart <= v7 and v7 < v8.cumulativeStart + v8.duration then
            local v9 = v6 + v8.cumulativeStart

            return {
                endTimestamp = v9 + v8.duration,
                kind = v8.kind,
                startTimestamp = v9
            }
        end
    end

    return nil
end

local function predictNextSpecialEventStart(p4, p5) -- line: 58
    -- upvalues: t1 (copy), n2 (ref)
    local v10

    for v11, v12 in t1 do
        local _ = v11 - 1

        if v12.kind == p4 == true then
            v10 = v12
            break
        end

        v10 = nil
    end

    local v13 = p5 - p5 % n2 + v10.cumulativeStart

    while v13 + v10.duration <= p5 do
        v13 += n2
    end

    return v13
end

local function getNextSpecialEventSlotStart(p6, p7, p8) -- line: 84
    -- upvalues: predictNextSpecialEventStart (copy)
    if p8 == nil or not (p6 < p8) then
        return (predictNextSpecialEventStart(p7, p6))
    end

    return p8
end

return {
    resolveActiveSpecialEventSegment = resolveActiveSpecialEventSegment,
    predictNextSpecialEventStart = predictNextSpecialEventStart,
    getNextSpecialEventSlotStart = getNextSpecialEventSlotStart,
    getSoonestUpcomingSpecialEvent = function(p9, p10) -- getSoonestUpcomingSpecialEvent | line: 96
        -- upvalues: specialEvents (copy), predictNextSpecialEventStart (copy)
        local t3

        for v14 in specialEvents do
            local v15 = if v14 == "PinataBoss" then p10 else nil

            if v15 == nil or not (p9 < v15) then
                v15 = predictNextSpecialEventStart(v14, p9)
            end

            if t3 == nil or v15 < t3.slotStart then
                t3 = {
                    kind = v14,
                    slotStart = v15
                }
            end
        end

        return t3
    end
}
