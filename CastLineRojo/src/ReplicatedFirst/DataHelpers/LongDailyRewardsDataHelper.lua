local ReplicatedFirst = game:GetService("ReplicatedFirst")
local LongDailyRewardsData = require(ReplicatedFirst.Data.LongDailyRewardsData)

local LongDailyRewardsDataHelper = {}

function LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): LongDailyRewardsData.LongDailyRewardConfig
    local rewardData = LongDailyRewardsData["Long_Daily_Reward_" .. dayIndex]
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function LongDailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function LongDailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function LongDailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function LongDailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function LongDailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = LongDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return LongDailyRewardsDataHelper