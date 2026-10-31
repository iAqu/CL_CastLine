local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HalloweenDailyRewardsData = require(ReplicatedFirst.Data.HalloweenDailyRewardsData)

local HalloweenDailyRewardsDataHelper = {}

function HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): HalloweenDailyRewardsData.HalloweenDailyRewardConfig
    local rewardData = HalloweenDailyRewardsData["Halloween_Daily_Reward_" .. dayIndex]
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function HalloweenDailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function HalloweenDailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function HalloweenDailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function HalloweenDailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function HalloweenDailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = HalloweenDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HalloweenDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return HalloweenDailyRewardsDataHelper