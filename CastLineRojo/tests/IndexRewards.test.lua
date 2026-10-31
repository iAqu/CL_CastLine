local IndexRewardsData = require("../src/ReplicatedFirst/Data/IndexRewardsData")
local IndexRewardsDataHelper = require("../src/ReplicatedFirst/DataHelpers/IndexRewardsDataHelper")

local progress = IndexRewardsDataHelper.GetProgress(IndexRewardsData, 20, 89)

assert(progress.CollectedCount == 20, "Overall collected count must be preserved")
assert(progress.TotalCount == 89, "Overall item count must be preserved")
assert(math.abs(progress.UnlockedLuck - 0.1) < 0.000001, "The first milestone must add 10 percent Luck")
assert(progress.TierCollected == 0, "Completing a milestone must reset progress toward the next milestone")
assert(progress.TierRequired == 20, "The second milestone must require another 20 items")
assert(math.abs(progress.NextLuckIncrease - 0.1) < 0.000001, "The next milestone must advertise 10 percent Luck")
assert(progress.IsMax == false, "Twenty discoveries must not complete every configured milestone")

local orderedRewards = IndexRewardsDataHelper.GetOrderedRewards(IndexRewardsData)
for index, requiredCount in ipairs({ 20, 40, 60, 80, 100 }) do
	assert(orderedRewards[index].RequiredCount == requiredCount, "Rewards must be ordered by RequiredCount")
	assert(orderedRewards[index].RewardID == "Reward_" .. index, "Equal ordering must be stable by RewardID")
end

local cases = {
	{ count = 0, luck = 0, tierCollected = 0, tierRequired = 20, isMax = false },
	{ count = 19, luck = 0, tierCollected = 19, tierRequired = 20, isMax = false },
	{ count = 39, luck = 0.1, tierCollected = 19, tierRequired = 20, isMax = false },
	{ count = 40, luck = 0.2, tierCollected = 0, tierRequired = 20, isMax = false },
	{ count = 79, luck = 0.3, tierCollected = 19, tierRequired = 20, isMax = false },
	{ count = 80, luck = 0.4, tierCollected = 0, tierRequired = 20, isMax = false },
	{ count = 89, luck = 0.4, tierCollected = 9, tierRequired = 20, isMax = false },
	{ count = 99, luck = 0.4, tierCollected = 19, tierRequired = 20, isMax = false },
	{ count = 100, luck = 0.5, tierCollected = 20, tierRequired = 20, isMax = true },
	{ count = 101, luck = 0.5, tierCollected = 20, tierRequired = 20, isMax = true },
}

for _, case in ipairs(cases) do
	local result = IndexRewardsDataHelper.GetProgress(IndexRewardsData, case.count, 89)
	assert(math.abs(result.UnlockedLuck - case.luck) < 0.000001, "Unlocked Luck must match configured milestones")
	assert(result.TierCollected == case.tierCollected, "Tier progress must be relative to the previous milestone")
	assert(result.TierRequired == case.tierRequired, "Every configured milestone segment must require 20 items")
	assert(result.IsMax == case.isMax, "Max state must begin at the final configured milestone")
end

local currentContentProgress = IndexRewardsDataHelper.GetProgress(IndexRewardsData, 89, 89)
assert(
	currentContentProgress.CollectedCount == 89 and currentContentProgress.TotalCount == 89,
	"Current content must display 89 / 89 overall"
)
assert(
	currentContentProgress.TierCollected == 9 and currentContentProgress.TierRequired == 20,
	"The fixed 100 milestone must remain 9 / 20 at 89 discoveries"
)
assert(currentContentProgress.IsMax == false, "Current content completion must not unlock the fixed 100 milestone")

print("IndexRewards.test.lua passed")
