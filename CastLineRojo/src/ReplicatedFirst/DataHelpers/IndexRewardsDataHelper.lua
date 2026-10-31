export type IndexRewardConfig = {
	RewardID: string,
	RequiredCount: number,
	LuckIncrease: number,
}

export type RewardProgress = {
	CollectedCount: number,
	TotalCount: number,
	UnlockedLuck: number,
	TierCollected: number,
	TierRequired: number,
	NextLuckIncrease: number,
	IsMax: boolean,
}

local IndexRewardsDataHelper = {}

local function normalizeCount(value: unknown): number
	return math.max(0, math.floor(tonumber(value) or 0))
end

function IndexRewardsDataHelper.GetOrderedRewards(rewardsData: { [string]: IndexRewardConfig }): { IndexRewardConfig }
	local orderedRewards = {}
	for _, reward in pairs(rewardsData) do
		table.insert(orderedRewards, reward)
	end
	table.sort(orderedRewards, function(left, right)
		if left.RequiredCount ~= right.RequiredCount then
			return left.RequiredCount < right.RequiredCount
		end
		return left.RewardID < right.RewardID
	end)
	return orderedRewards
end

function IndexRewardsDataHelper.GetProgress(
	rewardsData: { [string]: IndexRewardConfig },
	collectedCount: number,
	totalCount: number
): RewardProgress
	local collected = normalizeCount(collectedCount)
	local total = normalizeCount(totalCount)
	local orderedRewards = IndexRewardsDataHelper.GetOrderedRewards(rewardsData)
	local unlockedLuck = 0
	local previousRequiredCount = 0

	for _, reward in ipairs(orderedRewards) do
		if collected < reward.RequiredCount then
			local tierRequired = reward.RequiredCount - previousRequiredCount
			return {
				CollectedCount = collected,
				TotalCount = total,
				UnlockedLuck = unlockedLuck,
				TierCollected = math.clamp(collected - previousRequiredCount, 0, tierRequired),
				TierRequired = tierRequired,
				NextLuckIncrease = reward.LuckIncrease,
				IsMax = false,
			}
		end
		unlockedLuck += reward.LuckIncrease
		previousRequiredCount = reward.RequiredCount
	end

	local lastRequiredCount = previousRequiredCount
	local previousTierCount = if #orderedRewards > 1 then orderedRewards[#orderedRewards - 1].RequiredCount else 0
	local finalTierRequired = math.max(0, lastRequiredCount - previousTierCount)
	return {
		CollectedCount = collected,
		TotalCount = total,
		UnlockedLuck = unlockedLuck,
		TierCollected = finalTierRequired,
		TierRequired = finalTierRequired,
		NextLuckIncrease = 0,
		IsMax = true,
	}
end

return IndexRewardsDataHelper
