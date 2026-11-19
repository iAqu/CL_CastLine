local Config = require(script.Parent.FishingConfig)
local PetFeatureConfig = require(script.Parent.PetFeatureConfig)

local FishingRoll = {}

function FishingRoll.GetCastLuckMultiplier(progress: number?): number
	return if progress == nil then 1 else 0.1 + 0.9 * math.clamp(progress, 0, 1)
end

function FishingRoll.GetLuck(rod, bait, distance: number, castLuckMultiplier: number?): number
	return (1 + distance / Config.DistanceLuckScale)
		* (1 + rod.LuckBoost)
		* (1 + (if bait then bait.LuckBoost else 0))
		* (castLuckMultiplier or 1)
end

-- Compatibility helpers deliberately ignore display-only luck.
function FishingRoll.GetLuckRollCount(_luck: number): number
	return 1
end

local function getMaxWeight(maxWeight: number): number
	return if Config.RodWeightLimitEnabled then maxWeight else math.huge
end

function FishingRoll.RollWeight(defaultWeight: number, maxWeight: number, random: Random): number
	maxWeight = getMaxWeight(maxWeight)
	local size = 1
	for step = 1, 40 do
		local nextSize = size * 1.5
		local chance = math.min(20 + (step - 1) * 5, 40) / 100
		if defaultWeight * nextSize ^ 3 > maxWeight or random:NextNumber() >= chance then
			break
		end
		size = nextSize
	end
	return defaultWeight * size ^ 3
end

function FishingRoll.RollWeightLucky(defaultWeight: number, maxWeight: number, _luck: number, random: Random): number
	return FishingRoll.RollWeight(defaultWeight, maxWeight, random)
end

function FishingRoll.Choose(pool, _luck: number, random: Random)
	local total = 0
	for _, entry in ipairs(pool) do
		total += entry.weight
	end
	if total <= 0 then
		return nil
	end
	local sample = random:NextNumber() * total
	for _, entry in ipairs(pool) do
		sample -= entry.weight
		if sample < 0 then
			return entry.fish
		end
	end
	return pool[#pool].fish
end

function FishingRoll.GetEggPool(eggs, maxWeight, hasModel)
	maxWeight = getMaxWeight(maxWeight)
	local pool = {}
	for _, egg in pairs(eggs) do
		if (egg.RollWeight or 0) > 0 and (egg.DefaultWeight or math.huge) <= maxWeight and hasModel(egg.Model) then
			table.insert(pool, { fish = egg, weight = egg.RollWeight })
		end
	end
	table.sort(pool, function(a, b)
		return a.fish.EggId < b.fish.EggId
	end)
	return pool
end

function FishingRoll.ChooseCatch(fishPool, eggPool, baseLuck, petMultiplier, random)
	-- Category selection is independent of display-only luck.
	local categoryRoll = random:NextNumber()
	if PetFeatureConfig.Enabled and categoryRoll < Config.EggCatchChance then
		return "Egg", FishingRoll.Choose(eggPool, baseLuck, random)
	end
	return "Fish", FishingRoll.Choose(fishPool, baseLuck * petMultiplier, random)
end

function FishingRoll.BuildMutationRanges(mutations)
	local sorted = {}
	for _, mutation in pairs(mutations) do
		if typeof(mutation.Chance) == "number" and mutation.Chance >= 0 and mutation.Chance <= 1 then
			table.insert(sorted, mutation)
		else
			warn("FishingRoll: invalid Chance for mutation", mutation.MutationId)
		end
	end
	table.sort(sorted, function(a, b)
		if a.Index == b.Index then
			return a.MutationId < b.MutationId
		end
		return a.Index < b.Index
	end)

	local ranges = {}
	local total = 0
	for _, mutation in ipairs(sorted) do
		total += mutation.Chance
		-- Keep configured decimal boundaries stable when adding floating-point chances.
		local upperBound = math.round(total * 1e12) / 1e12
		if upperBound > 1 then
			warn("FishingRoll: total mutation Chance exceeds 1")
			return {}
		end
		table.insert(
			ranges,
			{ mutationId = mutation.MutationId, upperBound = upperBound, priceRate = mutation.PriceRate }
		)
	end
	return ranges
end

function FishingRoll.RollMutation(ranges, random: Random): string?
	local sample = random:NextNumber()
	for _, range in ipairs(ranges) do
		if sample < range.upperBound then
			return range.mutationId
		end
	end
	return nil
end

function FishingRoll.RollMutationLucky(ranges, _luck: number, random: Random): string?
	return FishingRoll.RollMutation(ranges, random)
end

return FishingRoll
