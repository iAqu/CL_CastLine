local Progress = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingProgress.lua")):read("*a")))()
local Items = assert(loadstring(assert(io.open("src/ReplicatedFirst/Data/TrainingData.lua")):read("*a")))()
local Levels = assert(loadstring(assert(io.open("src/ReplicatedFirst/Data/TrainingLevelsData.lua")):read("*a")))()
local Fishes = assert(loadstring(assert(io.open("src/ReplicatedFirst/Data/FishesData.lua")):read("*a")))()
assert(Progress.GetMaxLevel(Levels) == 1500)
for level = 1, 1500 do
	local row = Progress.GetLevel(Levels, level)
	assert(row.Level == level and row.MaxCatchWeight == 10 * level)
	local expectedXp = if level == 1500 then 0 else math.floor(5 + 0.006 * (level - 1) ^ 2.1 + 0.5)
	assert(row.XpToNextLevel == expectedXp)
end
local data = {}
local t = Progress.Ensure(data, Items, Levels)
assert(t.Level == 1 and t.Xp == 0 and t.TrainingID == "Training_101")
assert(Progress.Advance(t, 12, Levels) == 2 and t.Level == 3 and t.Xp == 2, "Carry XP through multiple levels")
t.Level, t.Xp = 1, 12
Progress.Ensure(data, Items, Levels)
assert(t.Level == 3 and t.Xp == 2, "Apply the new thresholds to saved XP")
t.Level, t.Xp = 1499, 0
assert(Progress.Advance(t, 1e9, Levels) == 1 and t.Level == 1500 and t.Xp == 0)
Progress.Advance(t, 1e9, Levels)
assert(t.Level == 1500 and t.Xp == 0, "Do not accumulate XP at MAX")
t.Level, t.Xp, t.TrainingID = 0 / 0, math.huge, "Missing"
Progress.Ensure(data, Items, Levels)
assert(t.Level == 1 and t.Xp == 0 and t.TrainingID == "Training_101")
assert(Progress.GetNextEquipment(Items, "Training_101").TrainingID == "Training_102")
assert(Progress.GetNextEquipment(Items, "Training_112") == nil)
assert(Progress.GetMultiplier({ GamePasses = { DoubleTrain = true } }) == 2)
assert(Progress.GetMultiplier({ GamePasses = {} }) == 1)
t.ResumeActive, t.LastActiveAt = true, 1000
assert(Progress.CanResume(t, 1120, 120))
assert(not Progress.CanResume(t, 1121, 120))
assert(not Progress.CanResume(t, 999, 120))
t.ResumeActive = false
assert(not Progress.CanResume(t, 1001, 120))
local step = 1.2 ^ 3
assert(math.abs(Progress.CalculateFishWeight(1, 10) - step ^ 4) < 1e-9)
assert(Progress.CalculateFishWeight(1, step) == step)
assert(Progress.CalculateFishWeight(1, step - 1e-8) == 1)
assert(Progress.CalculateFishWeight(60, 10) == 60, "Keep an overweight fish at its base weight")
assert(Progress.CalculateFishWeight(10, 10) == 10)
assert(not pcall(Progress.CalculateFishWeight, 1, math.huge))
assert(not pcall(Progress.CalculateFishWeight, 0, 10))
for _, level in pairs(Levels) do
	for _, base in ipairs({ 0.5, 1, 5.4, 11, 57, 61 }) do
		local weight = Progress.CalculateFishWeight(base, level.MaxCatchWeight)
		if base > level.MaxCatchWeight then
			assert(weight == base)
		else
			assert(weight >= base and weight <= level.MaxCatchWeight)
			assert(weight * step > level.MaxCatchWeight, "Use the last full growth step")
		end
	end
end

for _, fish in pairs(Fishes) do
	if fish.Rarity == "Common" then
		local base = fish.DefaultWeight
		for level = 1, 3 do
			local cap = Levels[tostring(level)].MaxCatchWeight
			local weight = Progress.CalculateFishWeight(base, cap)
			assert((weight > base) == (base * step <= cap))
		end
	end
end
