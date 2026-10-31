local ReplicatedFirst = game:GetService("ReplicatedFirst")
local OnlineRewardsData = require(ReplicatedFirst.Data.OnlineRewardsData)

local OnlineRewardsDataHelper = {}

function OnlineRewardsDataHelper.GetRewardDataByRebirth(rebirth: number): OnlineRewardsData.OnlineRewardConfig
    rebirth = 0
    local rewardData = OnlineRewardsData["OL_Reward_" .. rebirth]
    if not rewardData then warn("OnlineRewardsData not found for rebirth: " .. rebirth) return nil end
    return rewardData
end

function OnlineRewardsDataHelper.GetItemTypeByRebirth(rebirth: number, index: number): string
    rebirth = 0
    local rewardData = OnlineRewardsDataHelper.GetRewardDataByRebirth(rebirth)
    if not rewardData then warn("OnlineRewardsData not found for rebirth: " .. rebirth) return nil end

    return rewardData["Type_" .. index]
end

function OnlineRewardsDataHelper.GetItemIdByRebirth(rebirth: number, index: number): string
    rebirth = 0
    local rewardData = OnlineRewardsDataHelper.GetRewardDataByRebirth(rebirth)
    if not rewardData then warn("OnlineRewardsData not found for rebirth: " .. rebirth) return nil end

    return rewardData["Id_" .. index]
end

-- if item type is "Pet", Count means pet evolution
function OnlineRewardsDataHelper.GetItemCountByRebirth(rebirth: number, index: number): string
    rebirth = 0
    local rewardData = OnlineRewardsDataHelper.GetRewardDataByRebirth(rebirth)
    if not rewardData then warn("OnlineRewardsData not found for rebirth: " .. rebirth) return nil end

    return rewardData["Count_" .. index]
end

return OnlineRewardsDataHelper