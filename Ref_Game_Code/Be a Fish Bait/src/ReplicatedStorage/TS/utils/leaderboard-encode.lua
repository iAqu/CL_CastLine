-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    encodeLeaderboardValue = function(p1) -- encodeLeaderboardValue | line: 21
        if p1 <= 0 then
            return 0
        end

        local v2 = math.floor((math.log10(p1)))
        local v4 = math.floor(p1 / 10 ^ v2 / 10 * 1E+13)

        return v2 * 1E+13 + v4
    end,
    decodeLeaderboardValue = function(p2) -- decodeLeaderboardValue | line: 36
        if p2 <= 0 then
            return 0
        end

        local v6 = math.floor(p2 / 1E+13)

        return (p2 - v6 * 1E+13) / 1E+13 * 10 * 10 ^ v6
    end
}
