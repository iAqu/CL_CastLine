-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    preLogoutBuffDurationSeconds = 300,
    preLogoutMoneyMultiplier = 2,
    preLogoutMutationLuckMultiplier = 2,
    preLogoutPowerMultiplier = 2,
    getPreLogoutDayKey = function(p1) -- getPreLogoutDayKey | line: 6
        local v1 = (if p1 == nil then DateTime.now() else p1):ToUniversalTime()

        return (("%*-%*-%*"):format(v1.Year, v1.Month, v1.Day))
    end,
    pickPreLogoutBuffKind = function(p2) -- pickPreLogoutBuffKind | line: 13
        local v2 = (if p2 == nil then DateTime.now() else p2):ToUniversalTime().Day % 3

        if v2 == 0 then
            return "mutationLuck"
        end

        if v2 == 1 then
            return "power"
        end

        return "money"
    end,
    isPreLogoutBuffActive = function(p3, p4, p5) -- isPreLogoutBuffActive | line: 27
        local v3 = if p3 == nil then p3 else p3[p5]

        return v3 ~= nil and p4 < v3.buffExpiresAt
    end,
    getActivePreLogoutMoneyMultiplier = function(p6, p7) -- getActivePreLogoutMoneyMultiplier | line: 38
        local v4 = if p6 == nil then p6 else p6.money

        if v4 ~= nil and p7 < v4.buffExpiresAt then
            return 2
        end

        return 1
    end,
    getActivePreLogoutMutationLuckMultiplier = function(p8, p9) -- getActivePreLogoutMutationLuckMultiplier | line: 41
        local v5 = if p8 == nil then p8 else p8.mutationLuck

        if v5 ~= nil and p9 < v5.buffExpiresAt then
            return 2
        end

        return 1
    end,
    getActivePreLogoutPowerMultiplier = function(p10, p11) -- getActivePreLogoutPowerMultiplier | line: 44
        local v6 = if p10 == nil then p10 else p10.power

        if v6 ~= nil and p11 < v6.buffExpiresAt then
            return 2
        end

        return 1
    end
}
