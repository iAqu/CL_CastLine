-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    offlineFactor = 0.05,
    maxOfflineSeconds = 43200
}

return {
    calculateOfflineEarnings = function(p1, p2) -- calculateOfflineEarnings | line: 13
        -- upvalues: t1 (copy)
        return (math.floor(p1 * math.min(p2, t1.maxOfflineSeconds) * t1.offlineFactor))
    end,
    offlineEarningsConfig = t1
}
