-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectPlayerFishingState = function(p1) -- selectPlayerFishingState | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            return p2.fishingState[p1]
        end
    end,
    selectPlayerIsFishing = function(p3) -- selectPlayerIsFishing | line: 9
        return function(p4) -- line: 10
            -- upvalues: p3 (copy)
            local v1 = p4.fishingState[p3]

            if v1 ~= nil then
                v1 = v1.fishingState
            end

            return v1 ~= nil
        end
    end,
    selectPlayerCastParams = function(p5) -- selectPlayerCastParams | line: 20
        return function(p6) -- line: 21
            -- upvalues: p5 (copy)
            local v2 = p6.fishingState[p5]

            if v2 ~= nil then
                v2 = v2.castParams
            end

            return v2
        end
    end,
    selectPlayerFishingCaughtFishName = function(p7) -- selectPlayerFishingCaughtFishName | line: 31
        return function(p8) -- line: 32
            -- upvalues: p7 (copy)
            local v3 = p8.fishingState[p7]

            if v3 ~= nil then
                v3 = v3.caughtFishName
            end

            return v3
        end
    end,
    selectPlayerFishingCaughtFishMutations = function(p9) -- selectPlayerFishingCaughtFishMutations | line: 42
        return function(p10) -- line: 43
            -- upvalues: p9 (copy)
            local v4 = p10.fishingState[p9]

            if v4 ~= nil then
                v4 = v4.caughtFishMutations
            end

            if v4 == nil then
                v4 = {}
            end

            return v4
        end
    end
}
