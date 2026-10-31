-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "config-utils")
local defaultAquariumUpgradeTimeGateEnabled, defaultBossAutokillEnabled, defaultBossFightEasy, defaultHighScoreShown = v1.defaultAquariumUpgradeTimeGateEnabled, v1.defaultBossAutokillEnabled, v1.defaultBossFightEasy, v1.defaultHighScoreShown
local defaultHoldSkillCheckEnabled, defaultIsCelebrationPlace, defaultRareFishExperiment, defaultShouldAutoPromptDailyReward = v1.defaultHoldSkillCheckEnabled, v1.defaultIsCelebrationPlace, v1.defaultRareFishExperiment, v1.defaultShouldAutoPromptDailyReward

return {
    selectPlayerConfigSnapshot = function(p1) -- selectPlayerConfigSnapshot | line: 12
        return function(p2) -- line: 13
            -- upvalues: p1 (copy)
            return p2.playerConfigSnapshot[p1]
        end
    end,
    selectPlayerConfigSnapshotValue = function(p3, p4) -- selectPlayerConfigSnapshotValue | line: 19
        return function(p5) -- line: 20
            -- upvalues: p3 (copy), p4 (copy)
            local v2 = p5.playerConfigSnapshot[p4]

            if v2 ~= nil then
                v2 = v2[p3]
            end

            return v2
        end
    end,
    selectBossFightEasy = function(p6) -- selectBossFightEasy | line: 31
        -- upvalues: defaultBossFightEasy (copy)
        return function(p7) -- line: 32
            -- upvalues: p6 (copy), defaultBossFightEasy (copy)
            local v3 = p7.playerConfigSnapshot[p6]

            if v3 ~= nil then
                v3 = v3.bossFightEasy
            end

            if v3 == nil then
                v3 = defaultBossFightEasy
            end

            return v3
        end
    end,
    selectBossAutokillEnabled = function(p8) -- selectBossAutokillEnabled | line: 46
        -- upvalues: defaultBossAutokillEnabled (copy)
        return function(p9) -- line: 47
            -- upvalues: p8 (copy), defaultBossAutokillEnabled (copy)
            local v4 = p9.playerConfigSnapshot[p8]

            if v4 ~= nil then
                v4 = v4.bossAutokillEnabled
            end

            if v4 == nil then
                v4 = defaultBossAutokillEnabled
            end

            return v4
        end
    end,
    selectHoldSkillCheckEnabled = function(p10) -- selectHoldSkillCheckEnabled | line: 61
        -- upvalues: defaultHoldSkillCheckEnabled (copy)
        return function(p11) -- line: 62
            -- upvalues: p10 (copy), defaultHoldSkillCheckEnabled (copy)
            local v5 = p11.playerConfigSnapshot[p10]

            if v5 ~= nil then
                v5 = v5.holdSkillCheckEnabled
            end

            if v5 == nil then
                v5 = defaultHoldSkillCheckEnabled
            end

            return v5
        end
    end,
    selectShouldAutoPromptDailyReward = function(p12) -- selectShouldAutoPromptDailyReward | line: 76
        -- upvalues: defaultShouldAutoPromptDailyReward (copy)
        return function(p13) -- line: 77
            -- upvalues: p12 (copy), defaultShouldAutoPromptDailyReward (copy)
            local v6 = p13.playerConfigSnapshot[p12]

            if v6 ~= nil then
                v6 = v6.shouldAutoPromptDailyReward
            end

            if v6 == nil then
                v6 = defaultShouldAutoPromptDailyReward
            end

            return v6
        end
    end,
    selectHighScoreShown = function(p14) -- selectHighScoreShown | line: 91
        -- upvalues: defaultHighScoreShown (copy)
        return function(p15) -- line: 92
            -- upvalues: p14 (copy), defaultHighScoreShown (copy)
            local v7 = p15.playerConfigSnapshot[p14]

            if v7 ~= nil then
                v7 = v7.highScoreShown
            end

            if v7 == nil then
                v7 = defaultHighScoreShown
            end

            return v7
        end
    end,
    selectIsCelebrationPlace = function(p16) -- selectIsCelebrationPlace | line: 106
        -- upvalues: defaultIsCelebrationPlace (copy)
        return function(p17) -- line: 107
            -- upvalues: p16 (copy), defaultIsCelebrationPlace (copy)
            local v8 = p17.playerConfigSnapshot[p16]

            if v8 ~= nil then
                v8 = v8.isCelebrationPlace
            end

            if v8 == nil then
                v8 = defaultIsCelebrationPlace
            end

            return v8
        end
    end,
    selectAquariumUpgradeTimeGateEnabled = function(p18) -- selectAquariumUpgradeTimeGateEnabled | line: 121
        -- upvalues: defaultAquariumUpgradeTimeGateEnabled (copy)
        return function(p19) -- line: 122
            -- upvalues: p18 (copy), defaultAquariumUpgradeTimeGateEnabled (copy)
            local v9 = p19.playerConfigSnapshot[p18]

            if v9 ~= nil then
                v9 = v9.aquariumUpgradeTimeGateEnabled
            end

            if v9 == nil then
                v9 = defaultAquariumUpgradeTimeGateEnabled
            end

            return v9
        end
    end,
    selectRareFishExperiment = function(p20) -- selectRareFishExperiment | line: 136
        -- upvalues: defaultRareFishExperiment (copy)
        return function(p21) -- line: 137
            -- upvalues: p20 (copy), defaultRareFishExperiment (copy)
            local v10 = p21.playerConfigSnapshot[p20]

            if v10 ~= nil then
                v10 = v10.rareFishExperiment
            end

            if v10 == nil then
                v10 = defaultRareFishExperiment
            end

            return v10
        end
    end
}
