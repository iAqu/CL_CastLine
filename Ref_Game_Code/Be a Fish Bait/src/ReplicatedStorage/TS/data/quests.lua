-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        category = "daily",
        questId = "daily-playtime-1",
        rewardAmount = 5,
        targetAmount = 1800,
        title = "Stay in game for 30 minutes",
        type = "playtimeInGame",
        icon = images.timeSkipIcon
    },
    {
        category = "daily",
        questId = "daily-minigame-play-1",
        rewardAmount = 10,
        subjectId = "ringToss",
        targetAmount = 5,
        title = "Play Ring Toss 5 times",
        type = "minigamePlayCount",
        icon = images.gearIcon
    },
    {
        category = "daily",
        questId = "daily-area-1",
        rewardAmount = 25,
        subjectId = "partyZone",
        targetAmount = 7200,
        title = "Stay in the Party Zone for 2 hours",
        type = "playtimeInArea",
        icon = images.eventIcon
    },
    {
        category = "daily",
        questId = "daily-score-1",
        rewardAmount = 25,
        subjectId = "balloonPop",
        targetAmount = 500,
        title = "Score 500 in Balloon Pop",
        type = "minigameScore",
        icon = images.crownIcon
    },
    {
        category = "daily",
        questId = "daily-npc-1",
        rewardAmount = 25,
        subjectId = "mayorFishington",
        targetAmount = 1,
        title = "Talk to Mayor Fishington",
        type = "npcTalk",
        icon = images.mailIcon
    },
    {
        category = "daily",
        questId = "daily-minigame-play-2",
        rewardAmount = 25,
        subjectId = "anyMinigame",
        targetAmount = 10,
        title = "Play any minigame 10 times",
        type = "minigamePlayCount",
        icon = images.gearIcon
    }
}
local t2 = {
    {
        category = "event",
        questId = "event-minigame-play-1",
        rewardAmount = 100,
        subjectId = "eventBoss",
        targetAmount = 3,
        title = "Defeat the Event Boss 3 times",
        type = "minigamePlayCount",
        icon = images.gearIcon
    },
    {
        category = "event",
        questId = "event-score-1",
        rewardAmount = 50,
        subjectId = "balloonPop",
        targetAmount = 1000,
        title = "Score 1000 in Balloon Pop",
        type = "minigameScore",
        icon = images.crownIcon
    },
    {
        category = "event",
        questId = "event-area-1",
        rewardAmount = 50,
        subjectId = "partyZone",
        targetAmount = 18000,
        title = "Stay in the Party Zone for 5 hours",
        type = "playtimeInArea",
        icon = images.eventIcon
    },
    {
        category = "event",
        questId = "event-npc-1",
        rewardAmount = 50,
        subjectId = "mayorFishington",
        targetAmount = 3,
        title = "Talk to Mayor Fishington 3 times",
        type = "npcTalk",
        icon = images.mailIcon
    }
}

return {
    getQuestDefinition = function(p1) -- getQuestDefinition | line: 95
        -- upvalues: t1 (copy), t2 (copy)
        local v1

        for v2, v3 in t1 do
            local _ = v2 - 1

            if v3.questId == p1 == true then
                v1 = v3
                break
            end

            v1 = nil
        end

        if v1 == nil then
            v1 = nil

            for v4, v5 in t2 do
                local _ = v4 - 1

                if v5.questId == p1 == true then
                    v1 = v5
                    break
                end

                v1 = nil
            end
        end

        return v1
    end,
    dailyQuests = t1,
    eventQuests = t2
}
