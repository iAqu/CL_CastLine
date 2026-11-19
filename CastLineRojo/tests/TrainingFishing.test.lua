local new = require("./helpers/FishingHarness")
local Progress = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingProgress.lua")):read("*a")))()
local h = new()
for _, fish in pairs(h.fishes) do
	fish.DefaultWeight = 12
end
h.maxCatchWeight = 10
h.begin("NONE")
local first = h.cast()
local fish = h.fishes[first.fishId]
assert(first.weight == Progress.CalculateFishWeight(12, 10) and first.maxCatchWeight == 10)
h.maxCatchWeight = 40
h.sample = 0.99
h.now = first.retryAt + 0.1
local second = h.client:NextRound(h.player, h.token, first.round)
assert(second.ok and second.fishId == first.fishId, "Training must not reroll the catch in this session")
assert(second.weight == Progress.CalculateFishWeight(fish.DefaultWeight, 40))
assert(second.weight <= 40, "Use the current training cap without changing its growth formula")
h.round = second
local result = h.hook()
assert(result.ok and result.weight == second.weight)
assert(h.lastOptions.Weight == second.weight, "Shadow weight, hook response and granted weight must agree")
