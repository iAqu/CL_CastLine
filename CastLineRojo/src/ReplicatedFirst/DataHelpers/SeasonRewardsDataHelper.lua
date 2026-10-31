local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SeasonRewardsData = require(ReplicatedFirst.Data.SeasonRewardsData)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)

local Template = require(ReplicatedStorage.PlayerData.Template)

local SeasonRewardsDataHelper= {}

function SeasonRewardsDataHelper.GetAllData()
    return SeasonRewardsData
end

function SeasonRewardsDataHelper.GetData(RewardId: string)
    return SeasonRewardsData[RewardId]
end

function SeasonRewardsDataHelper.GetRequirementXp(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.RequirementXp
end

function SeasonRewardsDataHelper.GetRequirementXpByLevel(level: number): string
    for _, seasonRewardData in pairs(SeasonRewardsData) do
        if seasonRewardData.Level == level then
            return seasonRewardData.RequirementXp
        end
    end
end

function SeasonRewardsDataHelper.GetFreeRewardItemId(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.FreeRewardItemId
end

function SeasonRewardsDataHelper.GetFreeRewardCount(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.FreeRewardCount
end

function SeasonRewardsDataHelper.GetPremiumRewardItemId(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.PremiumRewardItemId
end

function SeasonRewardsDataHelper.GetPremiumRewardCount(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.PremiumRewardCount
end

function SeasonRewardsDataHelper.GetLevel(RewardId: string): number
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.Level
end

function SeasonRewardsDataHelper.GetFreeRewardName(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.FreeRewardName
end

function SeasonRewardsDataHelper.GetPremiumRewardName(RewardId: string): string
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.PremiumRewardName
end

function SeasonRewardsDataHelper.GetFreeRewardIconId(RewardId: string): number
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.FreeRewardIconId
end

function SeasonRewardsDataHelper.GetPremiumRewardIconId(RewardId: string): number
    local seasonRewardData = SeasonRewardsData[RewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", RewardId) return end
    return seasonRewardData.PremiumRewardIconId
end

function SeasonRewardsDataHelper.IsUnlocked(playerData:  Template.PlayerData, rewardId: string): boolean
    if not playerData then warn("playerData is nil") return end
    local seasonRewardData = SeasonRewardsData[rewardId]
    if not seasonRewardData then  warn("SeasonRewardsData not found: ", rewardId) return end
    return playerData.SeasonXp >= seasonRewardData.RequirementXp
end

function SeasonRewardsDataHelper.GetMaxLevel(): number
    local maxLevel = 0
    for _, seasonRewardData in pairs(SeasonRewardsData) do
        if seasonRewardData.Level > maxLevel then
            maxLevel = seasonRewardData.Level
        end
    end
    return maxLevel
end

function SeasonRewardsDataHelper.GetLevelByXp(xp: number): number
    local seasonRewardsDataSortList = {}
    for _, seasonRewardData in pairs(SeasonRewardsData) do
        table.insert(seasonRewardsDataSortList, {
            RewardId = seasonRewardData.RewardId,
            RequirementXp = seasonRewardData.RequirementXp,
            Level = seasonRewardData.Level,
        })
    end
    table.sort(seasonRewardsDataSortList, function(a, b)
        -- return a.RequirementXp < b.RequirementXp
        return a.RequirementXp > b.RequirementXp
    end)

    LogHelper.Print("seasonRewardsDataSortList", seasonRewardsDataSortList)
    local level = 0
    for _, seasonRewardData in ipairs(seasonRewardsDataSortList) do
        if xp >= seasonRewardData.RequirementXp then
            level = seasonRewardData.Level
            break
        end
    end
    level = level <= 0 and 0 or level
    level = level >= SeasonRewardsDataHelper.GetMaxLevel() and SeasonRewardsDataHelper.GetMaxLevel() or level
    return level
end

function SeasonRewardsDataHelper.GetLevelXp(level: number): number
    if level <= 0 then return 0 end

    for _, seasonRewardData in pairs(SeasonRewardsData) do
        if seasonRewardData.Level == level then
            return seasonRewardData.RequirementXp
        end
    end
end

return SeasonRewardsDataHelper