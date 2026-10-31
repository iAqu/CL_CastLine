local ReplicatedFirst = game:GetService("ReplicatedFirst")
local AchievementsData = require(ReplicatedFirst.Data.AchievementsData)

local AchievementsDataHelper= {}

local ROMAN_NUMERALS = {"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"}

AchievementsDataHelper.ACHIEVEMENT_TYPE = {
    WINS = "Wins",
    PLAY_TIME = "Playtime",
    REBIRTH = "Rebirth",
}

function AchievementsDataHelper.GetAllData()
    return AchievementsData
end

function AchievementsDataHelper.GetData(achievementId: string)
    return AchievementsData[achievementId]
end

function AchievementsDataHelper.GetDisplayName(achievementId: string): string
    local rank = AchievementsDataHelper.GetAchievementRank(achievementId)
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.DisplayName  .. " " .. ROMAN_NUMERALS[rank]
end

function AchievementsDataHelper.GetLayoutOrder(achievementId: string): number
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.LayoutOrder
end

function AchievementsDataHelper.GetProfitDescription(achievementId: string): string
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.ProfitDescription
end

function AchievementsDataHelper.GetProfitValue(achievementId: string): number
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.ProfitValue
end

-- function AchievementsDataHelper.GetRequirementType(achievementId: string): string
--     local achievementData = AchievementsData[achievementId]
--     if not achievementData then  warn("Achievement not found: ", achievementData) return end
--     return achievementData.RequirementType
-- end

function AchievementsDataHelper.GetRequirementDescription(achievementId: string): string
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.RequirementDescription
end

function AchievementsDataHelper.GetRequirementValue(achievementId: string): number
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.RequirementValue 
end

function AchievementsDataHelper.GetImageId(achievementId: string): string
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.ImageId
end

function AchievementsDataHelper.GetAchievementType(achievementId: string): string
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.AchievementType
end

function AchievementsDataHelper.GetAchievementRank(achievementId: string): number
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.Rank
end

function AchievementsDataHelper.GetChievementTypes(): table
    local achievementType = {}
    for _, achievementData in pairs(AchievementsData) do
        if not table.find(achievementType, achievementData.AchievementType) then
            table.insert(achievementType, achievementData.AchievementType)
        end
    end
    return achievementType
end

function AchievementsDataHelper.GetAchievementMaxRank(achievementType: string): number
    local maxRank = 0
    for _, achievementData in pairs(AchievementsData) do
        if achievementData.AchievementType == achievementType then
            maxRank = maxRank + 1
        end
    end
    return maxRank
end

function AchievementsDataHelper.GetAchievementRarity(achievementId: string): string
    local achievementData = AchievementsData[achievementId]
    if not achievementData then  warn("Achievement not found: ", achievementData) return end
    return achievementData.Rarity
end

function AchievementsDataHelper.GetAchievementIdByRank(achievementType: string, rank: number): string
    return "Achieve_" .. achievementType .. "_" .. rank
end

function AchievementsDataHelper.GetTotalProfitValueByRank(achievementId: string): number
    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    local rank = AchievementsDataHelper.GetAchievementRank(achievementId)
    local profitValue = 0
    for _, achievementData in pairs(AchievementsData) do
        if achievementData.AchievementType == achievementType then
            if achievementData.Rank <= rank then
                profitValue += achievementData.ProfitValue
            end
        end
    end
    return profitValue
end

function AchievementsDataHelper.GetProgressValueByType(playerData, achievementType: string)
    if not playerData then warn("PlayerData not found"); return 0 end

    local progressValue = 0
    if achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.WINS then
        progressValue = playerData.TotalWins
    elseif achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.PLAY_TIME then
        progressValue = playerData.PlayTime
    elseif achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.REBIRTH then
        progressValue = playerData.Rebirths
    else
        warn("Achievement type not found: ", achievementType)
    end
    return progressValue
end

function AchievementsDataHelper.GetBoostValue(playerData, achievementType: string): number
    if not playerData then warn("PlayerData not found") return 0 end

    -- local progressValue = AchievementsDataHelper.GetProgressValueByType(playerData, achievementType)
    local playerAchievementRank = playerData.AchievementRanks[achievementType] or 0
    local boostValue = 0
    for _, achievementData in pairs(AchievementsData) do
       if achievementData.AchievementType == achievementType then
            if achievementData.Rank <= playerAchievementRank then
                boostValue += achievementData.ProfitValue
            end
        end
    end

    local finalBoostValue = math.max(boostValue/100, 0)
    -- warn("Achievement boost: " .. achievementType .. " " .. finalBoostValue)
    return finalBoostValue
end

return AchievementsDataHelper
