local Config = require(script.Parent.FishingConfig)
local RarityConfig = require(script.Parent.RarityConfig)

local FishingRoll = {}

function FishingRoll.GetLuck(rod, bait, distance: number, waited: number): number
	local progress = math.clamp(waited / Config.WaitLuckRampSeconds, 0, 1)
	return (1 + distance / Config.DistanceLuckScale)
		* (1 + rod.LuckBoost)
		* (1 + (if bait then bait.LuckBoost else 0))
		* Config.WaitLuckMaxMultiplier ^ progress
end

function FishingRoll.GetPool(fishes, areaId: string, bait, hasModel)
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
		if not rarity or not table.find(fish.Areas, areaId) or fish.RollWeight <= 0 then
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

function FishingRoll.Choose(pool, luck: number, random: Random)
	local total = 0
	local cumulative = {}
	for index, entry in ipairs(pool) do
		total += entry.weight * luck ^ entry.fish.LuckExponent
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

return FishingRoll
