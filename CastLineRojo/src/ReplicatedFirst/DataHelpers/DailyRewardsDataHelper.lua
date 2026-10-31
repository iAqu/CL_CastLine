local ReplicatedFirst = game:GetService("ReplicatedFirst")
local DailyRewardsData = require(ReplicatedFirst.Data.DailyRewardsData)

local DailyRewardsDataHelper = {}

function DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): DailyRewardsData.DailyRewardConfig
    local rewardData = DailyRewardsData["Daily_Reward_" .. dayIndex]
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function DailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function DailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function DailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function DailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function DailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = DailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return DailyRewardsDataHelper