local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local indexService = read("src/ServerScriptService/Services/IndexService.lua")
local indexGuiController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/IndexGuiController.lua")

assert(indexService:find("IndexRewardsData", 1, true), "IndexService must use the configured milestone data")
assert(indexService:find("IndexRewardsDataHelper", 1, true), "IndexService must use the shared reward calculation")
assert(
	indexService:find("function IndexService:GetRewardProgress", 1, true),
	"IndexService must expose authoritative reward progress internally"
)
assert(
	indexService:find("RewardProgress = self:GetRewardProgress(player)", 1, true),
	"Initial Index state must include reward progress"
)
assert(
	indexService:find("IndexDiscovered:Fire(player, itemId, rewardProgress)", 1, true),
	"Discovery events must include fresh reward progress"
)
assert(not indexService:find("DISCOVERY_LUCK_TIERS", 1, true), "Legacy percentage-based Luck tiers must be removed")

assert(indexGuiController:find('WaitForChild("BottomFrame_New")', 1, true), "Index UI must bind the new reward frame")
assert(
	indexGuiController:find('WaitForChild("CollectLabel")', 1, true),
	"Index UI must bind the overall collection label"
)
assert(indexGuiController:find('"Collect: %d / %d "', 1, true), "Overall progress must use the new CollectLabel format")
assert(
	indexGuiController:find('"Collect %d/%d Items for +%d%% Luck"', 1, true),
	"Tier progress must use the new ProgressLabel format"
)
assert(
	indexGuiController:find('"Max Index Luck: +%d%% Luck"', 1, true),
	"Completed milestones must show the configured maximum Luck"
)
assert(
	indexGuiController:find("math.clamp(progress.TierCollected / progress.TierRequired, 0, 1)", 1, true),
	"Reward bar progress must be clamped within its current tier"
)
assert(
	indexGuiController:find("rewardProgress = state.RewardProgress", 1, true),
	"Initial UI must use authoritative reward progress"
)
assert(
	indexGuiController:find("rewardProgress = updatedRewardProgress", 1, true),
	"Discovery events must refresh authoritative reward progress"
)
assert(
	not indexGuiController:find("DISCOVERY_LUCK_TIERS", 1, true),
	"Client must not duplicate milestone configuration"
)
assert(
	not indexGuiController:find("CurrentPercentLabel", 1, true),
	"New reward UI must not update the legacy percentage label"
)

print("IndexRewardsIntegration.test.lua passed")
