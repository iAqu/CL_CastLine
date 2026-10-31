-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local getExclusiveFishConfigByFishName = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName

return {
    getExclusiveBossConditionalRollChance = function(p1, p2, p3, p4, p5) -- getExclusiveBossConditionalRollChance | line: 13
        -- upvalues: getExclusiveFishConfigByFishName (copy)
        local v1 = getExclusiveFishConfigByFishName(p1)

        if (if v1 == nil then v1 else v1.baseEncounterChance) == nil then
            return nil
        end

        if p3 <= 0 or p4 <= 0 or p5 <= 0 then
            return 0
        end

        local v2 = v1.requiredWeather ~= nil and p2[v1.requiredWeather] ~= nil and v1.weatherEncounterChance ~= nil
        local v3 = v1.baseEncounterChance / p5 / p4
        local maxBuffedCatchChance = v1.maxBuffedCatchChance

        if maxBuffedCatchChance == nil then
            maxBuffedCatchChance = v1.baseEncounterChance
        end

        local v4 = maxBuffedCatchChance / p5 / p3
        local weatherEncounterChance = v1.weatherEncounterChance

        if weatherEncounterChance ~= nil then
            maxBuffedCatchChance = weatherEncounterChance
        end

        local v5 = maxBuffedCatchChance / p3

        if not v2 then
            v5 = math.min(v3, v4)
        end

        return (math.clamp(v5, 0, 1))
    end
}
