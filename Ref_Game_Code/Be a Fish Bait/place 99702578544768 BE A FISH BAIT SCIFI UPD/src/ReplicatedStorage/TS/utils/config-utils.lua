-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function getShouldAutoPromptDailyReward(p1) -- line: 25
    if type(p1) == "boolean" then
        return p1
    end

    return true
end

local function getBossFightEasy(p2) -- line: 32
    if type(p2) == "boolean" then
        return p2
    end

    return false
end

local function getHoldSkillCheckEnabled(p3) -- line: 39
    if type(p3) == "boolean" then
        return p3
    end

    return true
end

local function getHighScoreShown(p4) -- line: 46
    if type(p4) == "boolean" then
        return p4
    end

    return true
end

local function getAquariumUpgradeTimeGateEnabled(p5) -- line: 53
    if type(p5) == "boolean" then
        return p5
    end

    return true
end

local t1 = {
    AEasy = true,
    AHard = true,
    BEasy = true,
    BHard = true
}

return {
    shouldAutoPromptDailyRewardConfigKey = "should_auto_prompt_daily_reward",
    bossFightEasyConfigKey = "boss_fight_easy",
    holdSkillCheckEnabledConfigKey = "hold_skill_check_enabled",
    highScoreShownConfigKey = "high_score_shown",
    aquariumUpgradeTimeGateEnabledConfigKey = "aquarium_upgrade_time_gate_enabled",
    rareFishExperimentConfigKey = "rare_fish_experiment",
    bossAutokillEnabledConfigKey = "boss_autokill_enabled",
    useMemoryStoreForLbConfigKey = "use_memory_store_for_lb",
    celebrationPlaceIdConfigKey = "celebration_place_id",
    mainGamePlaceIdConfigKey = "main_game_place_id",
    defaultShouldAutoPromptDailyReward = true,
    defaultBossFightEasy = false,
    defaultHoldSkillCheckEnabled = true,
    defaultHighScoreShown = true,
    defaultAquariumUpgradeTimeGateEnabled = true,
    defaultUseMemoryStoreForLb = false,
    defaultCelebrationPlaceId = -1,
    defaultMainGamePlaceId = -1,
    defaultIsCelebrationPlace = false,
    defaultRareFishExperiment = "AHard",
    defaultBossAutokillEnabled = true,
    getShouldAutoPromptDailyReward = getShouldAutoPromptDailyReward,
    getBossFightEasy = getBossFightEasy,
    getHoldSkillCheckEnabled = getHoldSkillCheckEnabled,
    getHighScoreShown = getHighScoreShown,
    getAquariumUpgradeTimeGateEnabled = getAquariumUpgradeTimeGateEnabled,
    getRareFishExperiment = function(p6) -- getRareFishExperiment | line: 66
        -- upvalues: t1 (copy)
        if type(p6) == "string" and t1[p6] ~= nil then
            return p6
        end

        return "AHard"
    end,
    getBossAutokillEnabled = function(p7) -- getBossAutokillEnabled | line: 78
        if type(p7) == "boolean" then
            return p7
        end

        return true
    end,
    getUseMemoryStoreForLb = function(p8) -- getUseMemoryStoreForLb | line: 82
        if type(p8) == "boolean" then
            return p8
        end

        return false
    end,
    getCelebrationPlaceId = function(p9) -- getCelebrationPlaceId | line: 89
        if type(p9) == "number" then
            return p9
        end

        return -1
    end,
    getMainGamePlaceId = function(p10) -- getMainGamePlaceId | line: 96
        if type(p10) == "number" then
            return p10
        end

        return -1
    end
}
