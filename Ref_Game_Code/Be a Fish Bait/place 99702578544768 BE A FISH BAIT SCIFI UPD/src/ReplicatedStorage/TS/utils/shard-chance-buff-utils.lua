-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UnixTimestamp = DateTime.fromUniversalTime(2026, 8, 7, 23, 0, 0).UnixTimestamp

local function getCurrentShardChanceBuffWindowEnd(p1) -- line: 8
    -- upvalues: UnixTimestamp (copy)
    if p1 < UnixTimestamp then
        return 0
    end

    return UnixTimestamp + math.floor((p1 - UnixTimestamp) / 604800) * 604800 + 86400
end

return {
    shardChanceBuffMultiplier = 2,
    shardChanceBuffDurationSeconds = 86400,
    isShardChanceBuffActive = function(_) -- isShardChanceBuffActive | line: 17
        return false
    end,
    getActiveShardChanceMultiplier = function(_) -- getActiveShardChanceMultiplier | line: 22
        return 1
    end,
    getShardChanceBuffExpiresAt = function(_) -- getShardChanceBuffExpiresAt | line: 26
        return 0
    end
}
