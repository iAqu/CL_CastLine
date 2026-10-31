local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ValentineDailyRewardsData = require(ReplicatedFirst.Data.ValentineDailyRewardsData)

local ValentineDailyRewardsDataHelper = {}

function ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): ValentineDailyRewardsData.ValentineDailyRewardConfig
    local rewardData = ValentineDailyRewardsData["Valentine_Daily_Reward_" .. dayIndex]
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function ValentineDailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function ValentineDailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function ValentineDailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function ValentineDailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function ValentineDailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = ValentineDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return ValentineDailyRewardsDataHelper