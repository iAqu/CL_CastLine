local RarityConfig = require(script.Parent.RarityConfig)

local ItemStatUtil = {}

export type ItemConfig = {
	DefaultPrice: number,
	DefaultWeight: number,
	ModelDefaultScale: number?,
	MinWeight: number,
	MaxWeight: number,
	Rarity: string,
	SpecialLuckMult: number,
}

ItemStatUtil.RARITY_LUCK = {}
for _, entry in ipairs(RarityConfig.List) do
	ItemStatUtil.RARITY_LUCK[entry.Name] = entry.Luck
end
ItemStatUtil.RARITY_LUCK.Mythical = ItemStatUtil.RARITY_LUCK.Mythic

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

local SIZE_TITLES = { "Big", "Large", "Huge", "Colossal", "Gigantic", "Titanic", "Monstrous", "Cosmic", "Infinite" }

function ItemStatUtil.GetSizeTitle(item: ItemConfig, actualWeight: number?): string?
	local weight, defaultWeight = tonumber(actualWeight), tonumber(item.DefaultWeight)
	if not weight or not defaultWeight
		or weight ~= weight or defaultWeight ~= defaultWeight
		or weight == math.huge or defaultWeight == math.huge
		or defaultWeight <= 0 or weight <= defaultWeight
	then
		return nil
	end
	local size = getWeightRatio(item, weight) ^ (1 / 3)
	if size <= 1.0001 then
		return nil
	end
	local level = math.max(1, math.floor(math.log(size) / math.log(1.5) + 0.5))
	return SIZE_TITLES[math.min(level, #SIZE_TITLES)]
end

function ItemStatUtil.GetWeightValueMultiplier(item: ItemConfig, actualWeight: number?): number
	local weight = tonumber(actualWeight)
	local defaultWeight = tonumber(item.DefaultWeight)
	if not weight or not defaultWeight or defaultWeight <= 0 or weight < 0
		or weight ~= weight or defaultWeight ~= defaultWeight
		or weight == math.huge or defaultWeight == math.huge
	then
		return 1
	end
	return (weight / defaultWeight) ^ 0.6
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
			* ItemStatUtil.GetWeightValueMultiplier(item, actualWeight)
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

	local rarityLuck = ItemStatUtil.RARITY_LUCK[RarityConfig.Normalize(item.Rarity)] or ItemStatUtil.RARITY_LUCK.Common
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

local MAX_FISH_LENGTH = 50
-- A 45-stud plot must leave at least one stud of travel on either side of center.
local MAX_FISH_RADIUS = 45 / 2 - 1
local modelBounds = setmetatable({}, { __mode = "k" })

function ItemStatUtil.GetModelBounds(template: Model)
	local cached = modelBounds[template]
	if cached then
		return cached
	end

	local bounds, size = template:GetBoundingBox()
	local body = template.PrimaryPart
	local offset = (if body then body.CFrame else template:GetPivot()):ToObjectSpace(bounds)
	local radius, framingRadius, bottom = 0, 0, math.huge
	local minimum = Vector3.new(math.huge, math.huge, math.huge)
	local maximum = Vector3.new(-math.huge, -math.huge, -math.huge)
	for x = -1, 1, 2 do
		for y = -1, 1, 2 do
			for z = -1, 1, 2 do
				local corner = offset:PointToWorldSpace(size * Vector3.new(x, y, z) * 0.5)
				radius = math.max(radius, Vector2.new(corner.X, corner.Z).Magnitude)
				framingRadius = math.max(framingRadius, corner.Magnitude)
				bottom = math.min(bottom, corner.Y)
				minimum = Vector3.new(math.min(minimum.X, corner.X), math.min(minimum.Y, corner.Y), math.min(minimum.Z, corner.Z))
				maximum = Vector3.new(math.max(maximum.X, corner.X), math.max(maximum.Y, corner.Y), math.max(maximum.Z, corner.Z))
			end
		end
	end
	local animatedRadius = template:GetAttribute("PresentationRadius")
	animatedRadius = if typeof(animatedRadius) == "number" then animatedRadius else 0
	local metrics = {
		longest = math.max(size.X, size.Y, size.Z),
		radius = math.max(radius, animatedRadius),
		framingRadius = math.max(framingRadius, animatedRadius),
		bottom = bottom,
		minimum = minimum,
		maximum = maximum,
	}
	modelBounds[template] = metrics
	return metrics
end

function ItemStatUtil.GetScaleRatio(item: ItemConfig, actualWeight: number, template: Model): (number, number)
	local metrics = ItemStatUtil.GetModelBounds(template)
	local cap = math.min(MAX_FISH_LENGTH / math.max(metrics.longest, 0.01), MAX_FISH_RADIUS / math.max(metrics.radius, 0.01))
	local weightRatio = getWeightRatio(item, actualWeight)
	local ratio = if weightRatio > 0 then weightRatio ^ (1 / 3) else 1
	return math.min(getPositiveMultiplier(item.ModelDefaultScale) * ratio, cap), cap
end

function ItemStatUtil.ScaleModel(model: Model, item: ItemConfig, actualWeight: number, template: Model)
	local ratio = ItemStatUtil.GetScaleRatio(item, actualWeight, template)
	model:ScaleTo(template:GetScale() * ratio)
end

return ItemStatUtil
