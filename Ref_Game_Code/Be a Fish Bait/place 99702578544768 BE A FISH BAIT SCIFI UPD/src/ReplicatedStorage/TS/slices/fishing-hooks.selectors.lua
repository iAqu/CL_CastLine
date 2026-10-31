-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectLocalPlayerHook = function(p1) -- selectLocalPlayerHook | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            for _, v1 in p2.fishingHooks do
                if v1.casterUserId == p1 then
                    return v1
                end
            end

            return nil
        end
    end,
    selectLocalPlayerNibbleFish = function(p3) -- selectLocalPlayerNibbleFish | line: 12
        return function(p4) -- line: 13
            -- upvalues: p3 (copy)
            for _, v2 in p4.fishingHooks do
                if v2.casterUserId == p3 then
                    return v2.nibbleFish
                end
            end

            return nil
        end
    end,
    selectLocalPlayerHookZone = function(p5) -- selectLocalPlayerHookZone | line: 22
        return function(p6) -- line: 23
            -- upvalues: p5 (copy)
            for _, v3 in p6.fishingHooks do
                if v3.casterUserId == p5 then
                    return v3.zone
                end
            end

            return nil
        end
    end,
    selectLocalPlayerNibbleExpireTimestamp = function(p7) -- selectLocalPlayerNibbleExpireTimestamp | line: 32
        return function(p8) -- line: 33
            -- upvalues: p7 (copy)
            for _, v4 in p8.fishingHooks do
                if v4.casterUserId == p7 then
                    return v4.nibbleExpireTimeStamp
                end
            end

            return 0
        end
    end,
    selectLocalPlayerBonusComboCount = function(p9) -- selectLocalPlayerBonusComboCount | line: 42
        return function(p10) -- line: 43
            -- upvalues: p9 (copy)
            for _, v5 in p10.fishingHooks do
                if v5.casterUserId == p9 then
                    return v5.bonusWaveComboCount
                end
            end

            return 0
        end
    end,
    selectLocalPlayerCaughtFishName = function(p11) -- selectLocalPlayerCaughtFishName | line: 52
        return function(p12) -- line: 53
            -- upvalues: p11 (copy)
            for _, v6 in p12.fishingHooks do
                if v6.casterUserId == p11 then
                    return v6.caughtFishName
                end
            end

            return nil
        end
    end,
    selectLocalPlayerApexCaught = function(p13) -- selectLocalPlayerApexCaught | line: 62
        return function(p14) -- line: 63
            -- upvalues: p13 (copy)
            for _, v7 in p14.fishingHooks do
                if v7.casterUserId == p13 then
                    return v7.apexCaught
                end
            end

            return false
        end
    end,
    selectLocalPlayerBonusFishInPool = function(p15) -- selectLocalPlayerBonusFishInPool | line: 72
        return function(p16) -- line: 73
            -- upvalues: p15 (copy)
            for _, v8 in p16.fishingHooks do
                if v8.casterUserId == p15 then
                    return v8.waveInjectedBonusFishId ~= nil
                end
            end

            return false
        end
    end
}
