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

export type ConditionConfig = {
	DisplayName: string,
	LayoutOrder: number,
	ChanceWeight: number,
	ValueMult: number,
}

local RARITIES = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythical",
	"Secret",
}

local ITEM_LUCK_MAX_INFLUENCE = 0.70
local ITEM_LUCK_HALF_SATURATION = 0.5
local CONDITION_LUCK_MAX_INFLUENCE = 0.70
local CONDITION_LUCK_HALF_SATURATION = 0.05

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
	return table.clone(RARITIES)
end

function ItemRollUtil.GetRarityRank(rarity: string): number
	for index, value in ipairs(RARITIES) do
		if value == rarity then
			return index
		end
	end
	return math.huge
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
	for _, item in pairs(itemsData) do
		if item.Rarity == rarity and ItemRollUtil.IsAllowedInZone(item, zoneId) and isModelAvailable(item) then
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
	for _, rarity in ipairs(RARITIES) do
		local candidates = ItemRollUtil.GetCandidates(itemsData, rarity, zoneId, isModelAvailable)
		local weight = getWeight(zoneData["Chance_" .. rarity])
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

function ItemRollUtil.RollCondition(
	conditionsData: { [string]: ConditionConfig },
	luck: number?,
	random: Random?
): (string?, ConditionConfig?)
	local conditionLuck = tonumber(luck) or 0
	if conditionLuck ~= conditionLuck or conditionLuck <= 0 then
		conditionLuck = 0
	end
	local influence = if conditionLuck == math.huge
		then CONDITION_LUCK_MAX_INFLUENCE
		else CONDITION_LUCK_MAX_INFLUENCE
			* conditionLuck
			/ (conditionLuck + CONDITION_LUCK_HALF_SATURATION)
	local ordered = {}
	for conditionId, condition in pairs(conditionsData) do
		table.insert(ordered, { id = conditionId, config = condition })
	end
	table.sort(ordered, function(left, right)
		if left.config.LayoutOrder ~= right.config.LayoutOrder then
			return left.config.LayoutOrder < right.config.LayoutOrder
		end
		return left.id < right.id
	end)

	local totalBaseWeight = 0
	local validConditionCount = 0
	for _, condition in ipairs(ordered) do
		local weight = getWeight(condition.config.ChanceWeight)
		if weight > 0 then
			totalBaseWeight += weight
			validConditionCount += 1
		end
	end
	if validConditionCount == 0 then
		return nil, nil
	end

	local averageWeight = totalBaseWeight / validConditionCount
	local entries = {}
	for _, condition in ipairs(ordered) do
		local baseWeight = getWeight(condition.config.ChanceWeight)
		if baseWeight > 0 then
			local weight = baseWeight + (averageWeight - baseWeight) * influence
			table.insert(entries, { value = condition, weight = weight })
		end
	end
	local selected = chooseWeighted(entries, random)
	if not selected then
		return nil, nil
	end
	return selected.id, selected.config
end

return ItemRollUtil
