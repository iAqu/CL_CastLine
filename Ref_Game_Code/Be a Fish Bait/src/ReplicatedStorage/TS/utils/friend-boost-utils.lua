-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    gemLuckBonusPerFriend = 5,
    getFriendBoostMultiplier = function(p1) -- getFriendBoostMultiplier | line: 14
        if p1 <= 0 then
            return 1
        end

        return 1 + 0.05 * p1
    end
}
