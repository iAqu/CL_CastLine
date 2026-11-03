local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local rollUtil = read("src/ReplicatedStorage/Modules/ItemRollUtil.lua")
local playerLuckUtil = read("src/ReplicatedStorage/Modules/PlayerLuckUtil.lua")

local function influence(luck)
	if luck <= 0 then
		return 0
	end
	return 0.70 * luck / (luck + 0.5)
end

local function adjusted(baseWeight, averageWeight, luck)
	return baseWeight + (averageWeight - baseWeight) * influence(luck)
end

assert(adjusted(1, 37, 0) == 1, "Zero Luck must preserve RollChance")
assert(adjusted(1, 37, 0.5) > adjusted(1, 37, 0.05), "Low RollChance must increase monotonically with Luck")
assert(adjusted(100, 37, 0.5) < adjusted(100, 37, 0.05), "High RollChance must decrease as Luck flattens weights")
assert(math.abs(influence(1000000) - 0.70) < 0.000001, "Luck influence must saturate at 70 percent")
assert(adjusted(10, 10, 100) == 10, "Equal RollChance values must remain unchanged")

assert(rollUtil:find("if baseWeight > 0 then", 1, true), "Zero RollChance candidates must be excluded")
assert(rollUtil:find("RollItemInRarity", 1, true), "Item selection must happen inside a resolved rarity")
assert(playerLuckUtil:find("playerData.PlotPlacements", 1, true), "Placed items must be the passive Item Luck source")
assert(playerLuckUtil:find("condition.LuckMult", 1, true), "Placed Item Luck must preserve Condition multipliers")
assert(playerLuckUtil:find("+ getNonNegativeNumber(discoveryLuck)", 1, true), "Discovery Luck must be additive")
assert(playerLuckUtil:find("baseLuck * getPositiveMultiplier(gamePassMultiplier)", 1, true), "GamePass Luck must multiply the combined base")

print("ItemLuckRoll.test.lua passed")
