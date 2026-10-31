local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HareDailyRewardsData = require(ReplicatedFirst.Data.HareDailyRewardsData)

local HareDailyRewardsDataHelper = {}

function HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): HareDailyRewardsData.HareDailyRewardConfig
    local rewardData = HareDailyRewardsData["Hare_Daily_Reward_" .. dayIndex]
    if not rewardData then warn("HareDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function HareDailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HareDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function HareDailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HareDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function HareDailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("HareDailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function HareDailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function HareDailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = HareDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return HareDailyRewardsDataHelper