-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1

local function getChinaStandardTimeUnixTimestamp(p1, p2, p3, p4, p5, p6) -- line: 6
    local v2 = if p5 == nil then 0 else p5
    local v3 = if p6 == nil then 0 else p6

    return DateTime.fromUniversalTime(p1, p2, p3, p4, v2, v3).UnixTimestamp - 28800
end

local v4 = DateTime.fromUniversalTime(2026, 9, 3, 19, 0, 0).UnixTimestamp - 28800
local v5 = DateTime.fromUniversalTime(2026, 9, 4, 16, 0, 0).UnixTimestamp - 28800

return {
    debugDoubleRewardsEventDurationSeconds = 300,
    debugDoubleRewardsEventEndTimestampAttribute = "DebugDoubleRewardsEventEndTimestamp",
    doubleRewardsEventCashMultiplier = 2,
    doubleRewardsEventPowerMultiplier = 2,
    startDebugDoubleRewardsEvent = function(p7) -- startDebugDoubleRewardsEvent | line: 22
        -- upvalues: v1 (ref)
        v1 = p7 + 300

        return v1
    end,
    isDoubleRewardsEventActive = function(p8) -- isDoubleRewardsEventActive | line: 26
        -- upvalues: v1 (ref), v4 (copy), v5 (copy)
        local v6 = v4 <= p8 and p8 < v5
        local v7 = v1 ~= nil and p8 < v1

        return v6 or v7
    end,
    doubleRewardsEventStartTimestamp = v4,
    doubleRewardsEventEndTimestamp = v5
}
