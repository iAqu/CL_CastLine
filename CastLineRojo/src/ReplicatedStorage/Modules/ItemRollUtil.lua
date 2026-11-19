local RarityConfig = require(script.Parent.RarityConfig)

local ItemRollUtil = {}

export type ItemConfig = {
	ItemID: string,
	LayoutOrder: number,
	Rarity: string,
	Model: string,
	RollChance: number,
	DefaultPrice: number,
	DefaultWeight: number,
	MinWeight: number,
	MaxWeight: number,
	ZoneLimited: string,
}

local ITEM_LUCK_MAX_INFLUENCE = 0.70
local ITEM_LUCK_HALF_SATURATION = 0.5

local function getWeight(value: unknown): number
	return math.max(0, tonumber(value) or 0)
end

local function chooseWeighted<T>(entries: { { value: T, weight: number } }, random: Random?): T?
	local total = 0
	for _, entry in ipairs(entries) do
		total += entry.weight
	end
	if total <= 0 then
		return nil
	end

	local roll = (random or Random.new()):NextNumber(0, total)
	local current = 0
	for _, entry in ipairs(entries) do
		current += entry.weight
		if roll < current then
			return entry.value
		end
	end
	return entries[#entries].value
end

function ItemRollUtil.GetRarities(): { string }
	local rarities = {}
	for _, entry in ipairs(RarityConfig.List) do
		table.insert(rarities, entry.Name)
	end
	return rarities
end

function ItemRollUtil.GetRarityRank(rarity: string): number
	local entry = RarityConfig.ByName[RarityConfig.Normalize(rarity)]
	return if entry then entry.Index else math.huge
end

function ItemRollUtil.IsAllowedInZone(item: ItemConfig, zoneId: string): boolean
	return item.ZoneLimited == nil or item.ZoneLimited == "" or item.ZoneLimited == "nil" or item.ZoneLimited == zoneId
end

function ItemRollUtil.GetCandidates(
	itemsData: { [string]: ItemConfig },
	rarity: string,
	zoneId: string,
	isModelAvailable: (item: ItemConfig) -> boolean
): { ItemConfig }
	local candidates = {}
	local normalizedRarity = RarityConfig.Normalize(rarity)
	for _, item in pairs(itemsData) do
		if RarityConfig.Normalize(item.Rarity) == normalizedRarity
			and ItemRollUtil.IsAllowedInZone(item, zoneId) and isModelAvailable(item) then
			table.insert(candidates, item)
		end
	end
	table.sort(candidates, function(left, right)
		if left.LayoutOrder ~= right.LayoutOrder then
			return left.LayoutOrder < right.LayoutOrder
		end
		return left.ItemID < right.ItemID
	end)
	return candidates
end

function ItemRollUtil.GetItemLuckInfluence(luck: number?): number
	local itemLuck = tonumber(luck) or 0
	if itemLuck ~= itemLuck or itemLuck <= 0 then
		return 0
	end
	if itemLuck == math.huge then
		return ITEM_LUCK_MAX_INFLUENCE
	end
	return ITEM_LUCK_MAX_INFLUENCE * itemLuck / (itemLuck + ITEM_LUCK_HALF_SATURATION)
end

function ItemRollUtil.GetLuckAdjustedWeight(baseWeight: number, averageWeight: number, luck: number?): number
	local influence = ItemRollUtil.GetItemLuckInfluence(luck)
	return baseWeight + (averageWeight - baseWeight) * influence
end

function ItemRollUtil.RollRarity(
	itemsData: { [string]: ItemConfig },
	zoneData: { [string]: unknown },
	zoneId: string,
	isModelAvailable: (item: ItemConfig) -> boolean,
	random: Random?
): string?
	local rarityEntries = {}
	for _, entry in ipairs(RarityConfig.List) do
		local rarity = entry.Name
		local candidates = ItemRollUtil.GetCandidates(itemsData, rarity, zoneId, isModelAvailable)
		local configuredWeight = zoneData["Chance_" .. rarity]
		if rarity == "Mythic" and configuredWeight == nil then
			configuredWeight = zoneData.Chance_Mythical
		end
		local weight = getWeight(configuredWeight)
		local hasRollableCandidate = false
		for _, item in ipairs(candidates) do
			if getWeight(item.RollChance) > 0 then
				hasRollableCandidate = true
				break
			end
		end
		if hasRollableCandidate and weight > 0 then
			table.insert(rarityEntries, { value = rarity, weight = weight })
		end
	end
	return chooseWeighted(rarityEntries, random)
end

function ItemRollUtil.RollItemInRarity(
	itemsData: { [string]: ItemConfig },
	rarity: string,
	zoneId: string,
	isModelAvailable: (item: ItemConfig) -> boolean,
	luck: number?,
	random: Random?
): ItemConfig?
	local candidates = ItemRollUtil.GetCandidates(itemsData, rarity, zoneId, isModelAvailable)
	local totalBaseWeight = 0
	local validCandidateCount = 0
	for _, item in ipairs(candidates) do
		local baseWeight = getWeight(item.RollChance)
		if baseWeight > 0 then
			totalBaseWeight += baseWeight
			validCandidateCount += 1
		end
	end
	if validCandidateCount == 0 then
		return nil
	end

	local averageWeight = totalBaseWeight / validCandidateCount
	local itemEntries = {}
	for _, item in ipairs(candidates) do
		local baseWeight = getWeight(item.RollChance)
		if baseWeight > 0 then
			local weight = ItemRollUtil.GetLuckAdjustedWeight(baseWeight, averageWeight, luck)
			table.insert(itemEntries, { value = item, weight = weight })
		end
	end
	return chooseWeighted(itemEntries, random)
end

return ItemRollUtil
