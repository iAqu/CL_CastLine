local Config = require(script.Parent.FishingConfig)
local PetFeatureConfig = require(script.Parent.PetFeatureConfig)
local RarityConfig = require(script.Parent.RarityConfig)

local FishingRoll = {}

function FishingRoll.GetCastLuckMultiplier(progress: number?): number
	return if progress == nil then 1 else 0.1 + 0.9 * math.clamp(progress, 0, 1)
end

function FishingRoll.GetLuck(rod, bait, distance: number, waited: number, castLuckMultiplier: number?): number
	local progress = math.clamp(waited / Config.WaitLuckRampSeconds, 0, 1)
	return (1 + distance / Config.DistanceLuckScale)
		* (1 + rod.LuckBoost)
		* (1 + (if bait then bait.LuckBoost else 0))
		* Config.WaitLuckMaxMultiplier ^ progress
		* (castLuckMultiplier or 1)
end

function FishingRoll.GetPool(fishes, maxWeight: number, bait, hasModel)
	local filter = bait and bait.FilterRarity
	local target
	if filter and filter ~= "" and filter ~= "nil" then
		target = RarityConfig.ByName[RarityConfig.Normalize(filter)]
		if not target then
			return {}
		end
	end

	local candidates = {}
	for _, fish in pairs(fishes) do
		local rarity = RarityConfig.ByName[RarityConfig.Normalize(fish.Rarity)]
		if fish.Rarity == "Event" or fish.DefaultWeight > maxWeight or not rarity or fish.RollWeight <= 0 then
			continue
		end
		local multiplier = 1
		if target then
			if rarity.Index < target.Index then
				multiplier = 0
			elseif rarity.Index == target.Index then
				multiplier = 1 - math.clamp(bait.FilterRatio, 0, 1)
			end
		end
		if multiplier > 0 and hasModel(fish.Model) then
			table.insert(candidates, { fish = fish, weight = fish.RollWeight * multiplier })
		end
	end
	table.sort(candidates, function(a, b)
		return a.fish.FishID < b.fish.FishID
	end)
	return candidates
end

function FishingRoll.RollWeight(defaultWeight: number, maxWeight: number, random: Random): number
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

function FishingRoll.Choose(pool, luck: number, random: Random)
	local total = 0
	local cumulative = {}
	for index, entry in ipairs(pool) do
		local exponent = entry.fish.LuckExponent
		if exponent == nil then
			exponent = math.max((entry.fish.LayoutOrder or 1) - 1, 0) * 0.05
		end
		total += entry.weight * luck ^ exponent
		cumulative[index] = total
	end
	if total <= 0 then
		return nil
	end
	local roll = random:NextNumber() * total
	for index, threshold in ipairs(cumulative) do
		if roll < threshold then
			return pool[index].fish
		end
	end
	return pool[#pool].fish
end

function FishingRoll.GetEggPool(eggs, maxWeight, hasModel)
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
	-- Category selection consumes one independent roll. Luck only affects the chosen pool.
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
		table.insert(ranges, { mutationId = mutation.MutationId, upperBound = upperBound })
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

return FishingRoll
