-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getDayKey = function(p1) -- getDayKey | line: 3
        local v1 = DateTime.fromUnixTimestamp(p1):ToUniversalTime()

        return (("%*-%*-%*"):format(v1.Year, v1.Month, v1.Day))
    end,
    getTimeToAddToPlaytime = function(p2, p3, p4) -- getTimeToAddToPlaytime | line: 7
        local v2 = p4 < p3
        local v3 = p2 - p3
        local v4 = p2 - p4

        if v2 then
            return v3
        end

        return v4
    end
}
