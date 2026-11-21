local RarityConfig = require(script.Parent.RarityConfig)
local WeightFormat = require(script.Parent.WeightFormat)

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

local function getRawScaleRatio(defaultWeight: number?, actualWeight: number, modelDefaultScale: number?): number
	local baseWeight = tonumber(defaultWeight) or 0
	local weightRatio = if baseWeight <= 0 then 1 else math.max(0, actualWeight) / baseWeight
	local weightScale = if weightRatio > 0 then weightRatio ^ (1 / 3) else 1
	return getPositiveMultiplier(modelDefaultScale) * weightScale
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

local SIZE_TIERS = {
	{ name = "Big", minScale = 3.6 },
	{ name = "Large", minScale = 5.2 },
	{ name = "Huge", minScale = 6.6 },
	{ name = "Colossal", minScale = 7.7 },
	{ name = "Gigantic", minScale = 8.7 },
	{ name = "Titanic", minScale = 9.5 },
	{ name = "Monstrous", minScale = 10.4 },
	{ name = "Cosmic", minScale = 11.2 },
	{ name = "Infinite", minScale = 12 },
}

type FishWeightConfig = { DefaultWeight: number?, ModelDefaultScale: number? }

local function positiveWeight(value: unknown): number?
	local weight = tonumber(value)
	return if weight and weight > 0 and weight < math.huge then weight else nil
end

function ItemStatUtil.GetSizeTitle(item: FishWeightConfig, actualWeight: number?): string?
	local weight, defaultWeight = positiveWeight(actualWeight), positiveWeight(item.DefaultWeight)
	if not weight or not defaultWeight then
		return nil
	end
	local rawScale = getRawScaleRatio(defaultWeight, weight, item.ModelDefaultScale)
	for index = #SIZE_TIERS, 1, -1 do
		local tier = SIZE_TIERS[index]
		if rawScale >= tier.minScale then
			return tier.name
		end
	end
	return nil
end

function ItemStatUtil.FormatFishWeight(item: FishWeightConfig, actualWeight: number?): string?
	local weight = positiveWeight(actualWeight)
	if not weight then
		return nil
	end
	local weightText = WeightFormat.FormatKg(weight)
	local sizeTitle = ItemStatUtil.GetSizeTitle(item, weight)
	return if sizeTitle then sizeTitle .. " · " .. weightText else weightText
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
	mutationPriceRate: number?
): number
	local mutationMultiplier = math.max(0, tonumber(mutationPriceRate) or 1)
	return math.round(
		(tonumber(item.DefaultPrice) or 0)
			* ItemStatUtil.GetWeightValueMultiplier(item, actualWeight)
			* mutationMultiplier
	)
end

function ItemStatUtil.CalculateLuck(item: ItemConfig, actualWeight: number): number
	local weight = tonumber(actualWeight) or ITEM_LUCK_MIN_WEIGHT
	if weight ~= weight then
		weight = ITEM_LUCK_MIN_WEIGHT
	end
	weight = math.clamp(weight, ITEM_LUCK_MIN_WEIGHT, ITEM_LUCK_MAX_WEIGHT)

	local rarityLuck = ItemStatUtil.RARITY_LUCK[RarityConfig.Normalize(item.Rarity)] or ItemStatUtil.RARITY_LUCK.Common
	return rarityLuck
		* math.sqrt(weight)
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

local FISH_LENGTH_SOFT_CAP = 80
local FISH_LENGTH_CURVE = 0.3
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

function ItemStatUtil.CompressScaleRatio(template: Model, rawRatio: number): number
	local longest = ItemStatUtil.GetModelBounds(template).longest
	local rawLength = longest * rawRatio
	if rawLength <= FISH_LENGTH_SOFT_CAP then
		return rawRatio
	end

	local length = FISH_LENGTH_SOFT_CAP * (1 + FISH_LENGTH_CURVE * math.log(rawLength / FISH_LENGTH_SOFT_CAP))
	return length / longest
end

function ItemStatUtil.GetScaleRatio(item: ItemConfig, actualWeight: number, template: Model): (number, number)
	local rawRatio = getRawScaleRatio(item.DefaultWeight, actualWeight, item.ModelDefaultScale)
	return ItemStatUtil.CompressScaleRatio(template, rawRatio), rawRatio
end

function ItemStatUtil.ScaleModel(model: Model, item: ItemConfig, actualWeight: number, template: Model)
	local ratio = ItemStatUtil.GetScaleRatio(item, actualWeight, template)
	model:ScaleTo(template:GetScale() * ratio)
end

return ItemStatUtil
