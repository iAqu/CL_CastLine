local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local formatMain = { NumberFormatter = { with = function()
	return { Format = function(_, value) return tostring(value) end }
end } }
local numberEnv = setmetatable({
	game = { GetService = function() return { Libs = { FormatNumber = { Main = formatMain, Simple = {} } } } end },
	require = function(value) return value end,
}, { __index = getfenv() })
local NumberUtil = assert(load(read("src/ReplicatedStorage/Modules/NumberUtil.lua"), "NumberUtil", "t", numberEnv))()

local function signal()
	return { Fire = function(self, ...)
		self.count = (self.count or 0) + 1
		self.last = { ... }
	end }
end
local profile = { Data = {
	IndexDiscoveryLog = { Fish_A = true, RemovedFish = true, Fish_B = false },
	IndexRewardClaimLog = {}, Wins = 0,
} }
local player = {}
local awards = 0
local profiles = {
	GetProfile = function() return profile end,
	AdjustWins = function(_, recipient, amount, totalWins)
		assert(recipient == player and totalWins == false)
		awards += 1
		profile.Data.Wins += amount
		return true
	end,
}
local knit = {
	CreateService = function(service) return service end,
	CreateSignal = signal,
	GetService = function() error("Index must not refresh or depend on player luck") end,
}
local services = {
	ReplicatedStorage = { Packages = { Knit = knit }, Modules = {
		NumberUtil = NumberUtil,
		FishInventoryData = { Fish_A = { DefaultPrice = 51 }, Fish_B = { DefaultPrice = 100 } },
	} },
	ServerScriptService = { Services = { PlayerDataService = profiles } },
}
local env = setmetatable({
	game = { GetService = function(_, name) return assert(services[name], name) end },
	require = function(value) return value end,
}, { __index = getfenv() })
local index = assert(load(read("src/ServerScriptService/Services/IndexService.lua"), "IndexService", "t", env))()
local state = index:GetState(player)
assert(state.CollectionProgress.CollectedCount == 1 and state.CollectionProgress.TotalCount == 2,
	"Only current fish discovered with true values count")
assert(state.DiscoveryLuck == nil and state.RewardProgress == nil and index.GetDiscoveryLuck == nil,
	"Index must no longer expose luck milestones")
state.DiscoveryLog.Fish_A = false
assert(profile.Data.IndexDiscoveryLog.Fish_A, "Remote state must not alias stored logs")
assert(not index:DiscoverItem(player, "Unknown"))
assert(not index:DiscoverItem(player, "Fish_A"))
assert(index.Client.IndexDiscovered.count == nil, "Repeated and invalid discoveries must not emit")
assert(not index:ClaimReward(player, "Unknown").IsSuccess)
assert(not index:ClaimReward(player, "Fish_B").IsSuccess)
assert(awards == 0, "Unknown and undiscovered rewards must never pay out")
local reward = index:ClaimReward(player, "Fish_A")
assert(reward.IsSuccess and reward.Reward == 26, "Reward must round half the default price")
assert(reward.ResultText == "Claimed $26!")
assert(profile.Data.IndexRewardClaimLog.Fish_A and profile.Data.Wins == 26)
assert(not index:ClaimReward(player, "Fish_A").IsSuccess)
assert(awards == 1 and index.Client.IndexRewardClaimed.count == 1, "Reward pays and emits exactly once")
assert(index:DiscoverItem(player, "Fish_B"))
local event = index.Client.IndexDiscovered.last
assert(event[1] == player and event[2] == "Fish_B")
assert(event[3].CollectedCount == 2 and event[3].TotalCount == 2, "Discovery broadcasts total progress")
assert(not index:DiscoverItem(player, "Fish_B"))
assert(index.Client.IndexDiscovered.count == 1)
assert(index:ClaimReward(player, "Fish_B").Reward == 50)
assert(profile.Data.Wins == 76 and awards == 2)
local saved = profile
profile = { Data = { Wins = 0 } }
assert(index:GetCollectionProgress(player).CollectedCount == 0)
assert(index:DiscoverItem(player, "Fish_A"), "Legacy missing discovery log must initialize")
assert(index:ClaimReward(player, "Fish_A").IsSuccess, "Legacy missing claim log must initialize")
profile = nil
assert(index:GetState(player) == nil and index:GetCollectionProgress(player) == nil)
assert(not index:DiscoverItem(player, "Fish_A"))
assert(not index:ClaimReward(player, "Fish_A").IsSuccess)
profile = saved
for _, case in ipairs({
	{ price = 1_997, amount = 999, text = "Claimed $999!" },
	{ price = 1_999, amount = 1_000, text = "Claimed $1K!" },
	{ price = 2_477, amount = 1_239, text = "Claimed $1.23K!" },
	{ price = 1_999_997, amount = 999_999, text = "Claimed $999.99K!" },
	{ price = 1_999_999, amount = 1_000_000, text = "Claimed $1M!" },
	{ price = 2_469_135, amount = 1_234_568, text = "Claimed $1.23M!" },
	{ price = 1_999_999_999, amount = 1_000_000_000, text = "Claimed $1B!" },
}) do
	services.ReplicatedStorage.Modules.FishInventoryData.Fish_A.DefaultPrice = case.price
	profile.Data.IndexRewardClaimLog.Fish_A = nil
	local balance = profile.Data.Wins
	local result = index:ClaimReward(player, "Fish_A")
	assert(result.IsSuccess and result.ResultText == case.text)
	assert(result.Reward == case.amount and profile.Data.Wins - balance == case.amount,
		"Compact notification must not truncate the reward or payout")
	assert(index.Client.IndexRewardClaimed.last[3] == case.amount, "Reward events must keep the full amount")
	assert(not index:ClaimReward(player, "Fish_A").IsSuccess)
	assert(profile.Data.Wins == balance + case.amount, "Duplicate claims must still pay only once")
end
print("IndexRewards.test.lua passed")
