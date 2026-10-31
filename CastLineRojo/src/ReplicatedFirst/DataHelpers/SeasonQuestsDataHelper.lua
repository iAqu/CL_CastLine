local ReplicatedFirst = game:GetService("ReplicatedFirst")
local SeasonQuestsData = require(ReplicatedFirst.Data.SeasonQuestsData)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Modules.Constants)


local SeasonQuestsDataHelper= {}

function SeasonQuestsDataHelper.GetAllData()
    return SeasonQuestsData
end

function SeasonQuestsDataHelper.GetData(QuestId: string)
    return SeasonQuestsData[QuestId]
end

function SeasonQuestsDataHelper.GetType(QuestId: string): string
    local seasonQuestData = SeasonQuestsData[QuestId]
    if not seasonQuestData then warn("Quest not found: ", QuestId) return end
    return seasonQuestData.Type
end

function SeasonQuestsDataHelper.GetLayoutOrder(QuestId: string): number
    local seasonQuestData = SeasonQuestsData[QuestId]
    if not seasonQuestData then warn("Quest not found: ", QuestId) return end
    return seasonQuestData.LayoutOrder
end

function SeasonQuestsDataHelper.GetDescription(QuestId: string): string
    local seasonQuestData = SeasonQuestsData[QuestId]
    if not seasonQuestData then warn("Quest not found: ", QuestId) return end
    return seasonQuestData.Description
end

function SeasonQuestsDataHelper.GetRewardXp(QuestId: string): number
    local seasonQuestData = SeasonQuestsData[QuestId]
    if not seasonQuestData then warn("Quest not found: ", QuestId) return end
    return seasonQuestData.RewardXp
end

function SeasonQuestsDataHelper.GetRequirementValue(QuestId: string): string
    local seasonQuestData = SeasonQuestsData[QuestId]
    if not seasonQuestData then  warn("Quest not found: ", QuestId) return end
    return seasonQuestData.RequirementValue
end

function SeasonQuestsDataHelper.GetDailyQuestsData()
    local dailyQuestsData = {}
    for _, seasonQuestData in pairs(SeasonQuestsData) do
        if seasonQuestData.Type == "Daily" then
            table.insert(dailyQuestsData, seasonQuestData)
        end
    end
    return dailyQuestsData
end

function SeasonQuestsDataHelper.GetWeekQuestsData()
    local weekQuestsData = {}
    for _, seasonQuestData in pairs(SeasonQuestsData) do
        if seasonQuestData.Type == "Weekly" then
            table.insert(weekQuestsData, seasonQuestData)
        end
    end
    return weekQuestsData
end

return SeasonQuestsDataHelper