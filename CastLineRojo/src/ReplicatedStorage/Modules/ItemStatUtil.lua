local ItemStatUtil = {}

export type ItemConfig = {
	DefaultPrice: number,
	DefaultWeight: number,
	MinWeight: number,
	MaxWeight: number,
	Rarity: string,
	SpecialLuckMult: number,
}

ItemStatUtil.RARITY_LUCK = {
	Common = 1,
	Uncommon = 1.6,
	Rare = 2.6,
	Epic = 4.2,
	Legendary = 7,
	Mythical = 12,
	Secret = 20,
}

local ITEM_LUCK_BASE = 0.00045
local ITEM_LUCK_MIN_WEIGHT = 1
local ITEM_LUCK_MAX_WEIGHT = 500

local function getPositiveMultiplier(value: unknown): number
	local multiplier = tonumber(value)
	if not multiplier or multiplier ~= multiplier or multiplier <= 0 or multiplier == math.huge then
		return 1
	end
	return multiplier
end

local function getWeightRatio(item: ItemConfig, actualWeight: number): number
	local defaultWeight = tonumber(item.DefaultWeight) or 0
	if defaultWeight <= 0 then
		return 1
	end
	return math.max(0, actualWeight) / defaultWeight
end

function ItemStatUtil.RollWeight(item: ItemConfig, random: Random?): number
	local minWeight = tonumber(item.MinWeight) or tonumber(item.DefaultWeight) or 0
	local maxWeight = tonumber(item.MaxWeight) or minWeight
	if minWeight > maxWeight then
		minWeight, maxWeight = maxWeight, minWeight
	end
	local rawWeight = (random or Random.new()):NextNumber(minWeight, maxWeight)
	return math.round(rawWeight * 10) / 10
end

function ItemStatUtil.CalculatePrice(
	item: ItemConfig,
	actualWeight: number,
	conditionValueMult: number?,
	mutationPriceRate: number?
): number
	local conditionMultiplier = math.max(0, tonumber(conditionValueMult) or 1)
	local mutationMultiplier = math.max(0, tonumber(mutationPriceRate) or 1)
	return math.round(
		(tonumber(item.DefaultPrice) or 0)
			* getWeightRatio(item, actualWeight)
			* conditionMultiplier
			* mutationMultiplier
	)
end

function ItemStatUtil.CalculateLuck(item: ItemConfig, actualWeight: number, conditionLuckMult: number?): number
	local weight = tonumber(actualWeight) or ITEM_LUCK_MIN_WEIGHT
	if weight ~= weight then
		weight = ITEM_LUCK_MIN_WEIGHT
	end
	weight = math.clamp(weight, ITEM_LUCK_MIN_WEIGHT, ITEM_LUCK_MAX_WEIGHT)

	local rarityLuck = ItemStatUtil.RARITY_LUCK[item.Rarity] or ItemStatUtil.RARITY_LUCK.Common
	return rarityLuck
		* math.sqrt(weight)
		* getPositiveMultiplier(conditionLuckMult)
		* ITEM_LUCK_BASE
		* getPositiveMultiplier(item.SpecialLuckMult)
end

function ItemStatUtil.FormatLuckPercent(luck: number?): string
	local value = tonumber(luck) or 0
	if value ~= value or value < 0 then
		value = 0
	end
	local percent = value * 100
	if percent == 0 then
		return "+0%"
	end
	if percent < 1 then
		return string.format("+%.2f%%", percent)
	end
	if percent < 10 then
		return string.format("+%.1f%%", percent)
	end
	return string.format("+%.0f%%", percent)
end

function ItemStatUtil.CalculateMaxHealth(
	_item: ItemConfig,
	actualWeight: number,
	zoneRecommendedPower: number
): number
	return math.round(
		math.max(0, tonumber(zoneRecommendedPower) or 0)
			* math.sqrt(math.max(0, tonumber(actualWeight) or 0))
	)
end

function ItemStatUtil.GetScaleRatio(item: ItemConfig, actualWeight: number): number
	local weightRatio = getWeightRatio(item, actualWeight)
	return 1 + (weightRatio - 1) * 0.7
end

function ItemStatUtil.ScaleModel(model: Model, item: ItemConfig, actualWeight: number, templateScale: number?)
	local ratio = ItemStatUtil.GetScaleRatio(item, actualWeight)
	if ratio > 0 then
		local baseScale = if templateScale and templateScale > 0 then templateScale else model:GetScale()
		model:ScaleTo(baseScale * ratio)
	end
end

return ItemStatUtil
