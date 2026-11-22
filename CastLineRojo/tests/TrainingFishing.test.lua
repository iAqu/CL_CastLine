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
