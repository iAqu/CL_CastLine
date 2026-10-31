-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "config-utils")
local defaultAquariumUpgradeTimeGateEnabled, defaultBossAutokillEnabled, defaultBossFightEasy, defaultHighScoreShown = v1.defaultAquariumUpgradeTimeGateEnabled, v1.defaultBossAutokillEnabled, v1.defaultBossFightEasy, v1.defaultHighScoreShown
local defaultHoldSkillCheckEnabled, defaultIsCelebrationPlace, defaultRareFishExperiment, defaultShouldAutoPromptDailyReward = v1.defaultHoldSkillCheckEnabled, v1.defaultIsCelebrationPlace, v1.defaultRareFishExperiment, v1.defaultShouldAutoPromptDailyReward
local v3 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 16
        -- upvalues: defaultAquariumUpgradeTimeGateEnabled (copy), defaultBossAutokillEnabled (copy), defaultBossFightEasy (copy), defaultHighScoreShown (copy), defaultHoldSkillCheckEnabled (copy), defaultIsCelebrationPlace (copy), defaultRareFishExperiment (copy), defaultShouldAutoPromptDailyReward (copy)
        p1[p2.userId] = {
            aquariumUpgradeTimeGateEnabled = defaultAquariumUpgradeTimeGateEnabled,
            bossAutokillEnabled = defaultBossAutokillEnabled,
            bossFightEasy = defaultBossFightEasy,
            holdSkillCheckEnabled = defaultHoldSkillCheckEnabled,
            isCelebrationPlace = defaultIsCelebrationPlace,
            shouldAutoPromptDailyReward = defaultShouldAutoPromptDailyReward,
            highScoreShown = defaultHighScoreShown,
            rareFishExperiment = defaultRareFishExperiment
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 31
        p3[p4.userId] = nil
    end),
    playerConfigSnapshotUpdated = produceWrapper(function(p5, p6) -- line: 36
        if p5[p6.userId] == nil then
            return nil
        end

        local userId = p6.userId
        local v2 = table.clone(p6.data)

        setmetatable(v2, nil)
        p5[userId] = v2
    end)
})

v3:getActions()

return {
    playerConfigSnapshotSlice = v3
}
