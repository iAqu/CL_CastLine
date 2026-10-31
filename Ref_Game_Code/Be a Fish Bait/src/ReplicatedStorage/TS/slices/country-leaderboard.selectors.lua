-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectCountryLeaderboard = function(p1) -- selectCountryLeaderboard | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return if p1 ~= nil then p2.countryLeaderboard[p1] else nil
        end
    end
}
