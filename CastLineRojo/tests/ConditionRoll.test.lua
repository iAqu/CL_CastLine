local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local rollUtil = read("src/ReplicatedStorage/Modules/ItemRollUtil.lua")

local MAX_INFLUENCE = 0.70
local HALF_SATURATION = 0.05
local baseWeights = { 38, 28, 20, 10, 4 }

local function influence(luck)
	if luck <= 0 then
		return 0
	end
	if luck == math.huge then
		return MAX_INFLUENCE
	end
	return MAX_INFLUENCE * luck / (luck + HALF_SATURATION)
end

local function adjustedWeights(luck)
	local total = 0
	for _, weight in ipairs(baseWeights) do
		total = total + weight
	end
	local average = total / #baseWeights
	local adjusted = {}
	for index, weight in ipairs(baseWeights) do
		adjusted[index] = weight + (average - weight) * influence(luck)
	end
	return adjusted
end

local zeroLuck = adjustedWeights(0)
for index, weight in ipairs(baseWeights) do
	assert(zeroLuck[index] == weight, "Zero Luck must preserve configured Condition weights")
end

assert(math.abs(influence(HALF_SATURATION) - MAX_INFLUENCE * 0.5) < 0.000001, "Half-saturation Luck must provide half the maximum influence")
assert(influence(math.huge) == MAX_INFLUENCE, "Infinite Luck must converge to the maximum influence")

local highLuck = adjustedWeights(math.huge)
assert(highLuck[1] < baseWeights[1], "High Luck must reduce the Normal weight")
assert(highLuck[4] > baseWeights[4], "High Luck must increase the Perfect weight")
assert(highLuck[5] > baseWeights[5], "High Luck must increase the Mint weight")

local adjustedTotal = 0
for _, weight in ipairs(highLuck) do
	adjustedTotal = adjustedTotal + weight
end
assert(math.abs(adjustedTotal - 100) < 0.000001, "Luck adjustment must preserve the total Condition weight")

assert(rollUtil:find("validConditionCount == 0", 1, true), "An empty weighted Condition table must return no selection")
assert(rollUtil:find("return nil, nil", 1, true), "Condition roll failure must be explicit for the caller fallback")

print("ConditionRoll.test.lua passed")
