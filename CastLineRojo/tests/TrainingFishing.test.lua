local new = require("./helpers/FishingHarness")
local Progress = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingProgress.lua")):read("*a")))()
local h = new()
for _, fish in pairs(h.fishes) do
	fish.DefaultWeight = 12
	fish.DisplayChance = 50
end
h.maxCatchWeight = 10
h.begin("NONE")
local first = h.cast()
local fish = h.fishes[first.fishId]
assert(first.weight == Progress.CalculateFishWeight(12, 10) and first.maxCatchWeight == 10)
h.maxCatchWeight = 40
h.now = first.retryAt + 0.1
local second = h.client:NextRound(h.player, h.token, first.round)
assert(second.ok and second.fishId == first.fishId, "A new round can roll the same fish")
assert(second.weight == Progress.CalculateFishWeight(fish.DefaultWeight, 40))
assert(second.weight <= 40, "Use the current training cap without changing its growth formula")
h.round = second
local result = h.hook()
assert(result.ok and result.weight == second.weight)
assert(h.lastOptions.Weight == second.weight, "Shadow weight, hook response and granted weight must agree")
assert(result.catchChanceDenominator == 78, "Use two training weight steps and round the final denominator")

for _, case in {
	{ sample = 0.99, cap = 10, expected = 50 },
	{ sample = 0.05, cap = 40, mutation = "Golden", expected = 313 },
	{ sample = 0.12, cap = 40, mutation = "Diamond", expected = 625 },
	{ sample = 0.16, cap = 40, mutation = "Rainbow", expected = 1250 },
} do
	h.cancel()
	h.sample, h.maxCatchWeight = case.sample, case.cap
	h.begin("NONE")
	local round = h.cast()
	assert(round.catchChanceDenominator == nil, "Only reveal the denominator after a successful hook")
	local caught = h.hook()
	assert(caught.ok and caught.mutationId == case.mutation)
	assert(caught.catchChanceDenominator == case.expected)
end

local onboarding = require("../src/ReplicatedStorage/Modules/FishingOnboarding")
local items = require("../src/ReplicatedFirst/Data/TrainingData")
local levels = require("../src/ReplicatedFirst/Data/TrainingLevelsData")
local rods = require("../src/ReplicatedFirst/Data/RodsData")
local config = require("../src/ReplicatedStorage/Modules/TrainingConfig")
local player = { UserId = 42, SetAttribute = function() end }
local character = {
	FindFirstChild = function() return {} end,
	FindFirstChildOfClass = function(_, class)
		return if class == "Humanoid" then { Health = 100 } else nil
	end,
}
player.Character = character
local plot = {
	GetAttribute = function() return player.UserId end,
	FindFirstChild = function() return {} end,
}
local recorded = {}
local services = {
	ReplicatedFirst = { Data = { TrainingData = items, TrainingLevelsData = levels, RodsData = rods } },
	ReplicatedStorage = {
		Packages = { Knit = {
			CreateService = function(service) return service end,
			CreateSignal = function() return {} end,
			GetService = function(name)
				if name == "PlotSlotService" then
					return { GetPlayerPlot = function() return plot end }
				end
				return { IsActive = function() return false end }
			end,
		} },
		Modules = {
			TrainingProgress = Progress,
			FishingOnboarding = onboarding,
			TrainingConfig = config,
			TrainingSpotUtil = { Contains = function() return true end },
			TrainingCharacterLock = { Release = function() end },
			RodInventory = { GetEquippedId = function(data) return data.EquippedRodId end },
		},
	},
}
local env = setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(module) return module end,
	script = { Parent = { OnboardingAnalyticsService = {
		Step = function(_, _, step) table.insert(recorded, step) end,
		Growth = function() end,
	} } },
}, { __index = getfenv() })
local trainingSource = assert(io.open("src/ServerScriptService/Services/TrainingService.lua")):read("*a")
local service = assert(load(trainingSource, "TrainingService", "t", env))()
local data = { FishingOnboarding = { Stage = "Train" }, EquippedRodId = "Rod_101" }
local state = {
	training = Progress.Ensure(data, items, levels), data = data, active = true, allowed = true,
	character = character, plot = plot, elapsed = 0,
}
service._state = function() return state end
service._syncDisplay = function() end
service._publish = function() end
for _ = 1, levels["1"].XpToNextLevel do
	service:_step(player, config.RepInterval)
end
assert(state.training.Level == 2 and data.FishingOnboarding.Stage == "Train")
assert(#recorded == 1 and recorded[1] == "TrainingStarted")
for _ = 1, levels["2"].XpToNextLevel do
	service:_step(player, config.RepInterval)
end
assert(state.training.Level == 3 and data.FishingOnboarding.Stage == "StopTraining")
assert(#recorded == 2 and recorded[2] == "TrainingGoalReached")
service:_step(player, config.RepInterval)
service:Stop(player, true)
assert(#recorded == 3 and recorded[3] == "TrainingEnded" and data.FishingOnboarding.Stage == "RodReward")
