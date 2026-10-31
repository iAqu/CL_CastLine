local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ChristmasDailyRewardsData = require(ReplicatedFirst.Data.ChristmasDailyRewardsData)

local ChristmasDailyRewardsDataHelper = {}

function ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex: number): ChristmasDailyRewardsData.ChristmasDailyRewardConfig
    local rewardData = ChristmasDailyRewardsData["Christmas_Daily_Reward_" .. dayIndex]
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end
    return rewardData
end

function ChristmasDailyRewardsDataHelper.GetItemTypeByDayIndex(dayIndex: number): string
    local rewardData = ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Type
end

function ChristmasDailyRewardsDataHelper.GetItemIdByDayIndex(dayIndex: number): string
    local rewardData = ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.ItemId
end

function ChristmasDailyRewardsDataHelper.GetItemNameByDayIndex(dayIndex: number): string
    local rewardData = ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("DailyRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Name
end

-- if item type is "Pet", Count means pet evolution
function ChristmasDailyRewardsDataHelper.GetItemCountByDayIndex(dayIndex: number): string
    local rewardData = ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.Count
end

function ChristmasDailyRewardsDataHelper.GetIconIdByDayIndex(dayIndex: number): string
    local rewardData = ChristmasDailyRewardsDataHelper.GetRewardDataByDayIndex(dayIndex)
    if not rewardData then warn("OnlineRewardsData not found for dayIndex: " .. dayIndex) return nil end

    return rewardData.IconId
end

return ChristmasDailyRewardsDataHelper