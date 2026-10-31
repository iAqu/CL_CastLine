local ReplicatedFirst = game:GetService("ReplicatedFirst")

local MutationsData = require(ReplicatedFirst.Data.MutationsData)

local MutationDataUtil = {}

local function finiteNumber(value: unknown): number?
	local numberValue = tonumber(value)
	if not numberValue
		or numberValue ~= numberValue
		or numberValue == math.huge
		or numberValue == -math.huge
	then
		return nil
	end
	return numberValue
end

function MutationDataUtil.NormalizeMutationId(value: unknown): string?
	if typeof(value) ~= "string" or value == "" or value == "nil" or not MutationsData[value] then
		return nil
	end
	return value
end

function MutationDataUtil.GetConfig(value: unknown)
	local mutationId = MutationDataUtil.NormalizeMutationId(value)
	return mutationId and MutationsData[mutationId] or nil
end

function MutationDataUtil.GetPriceRate(value: unknown): number
	local config = MutationDataUtil.GetConfig(value)
	return math.max(0, finiteNumber(config and config.PriceRate) or 1)
end

function MutationDataUtil.GetEarnCashRate(value: unknown): number
	local config = MutationDataUtil.GetConfig(value)
	return math.max(0, finiteNumber(config and config.EarnCashRate) or 1)
end

function MutationDataUtil.GetLabelColor(value: unknown): Color3
	local config = MutationDataUtil.GetConfig(value)
	local labelColor = config and config.LabelColor
	if typeof(labelColor) ~= "string" then
		return Color3.new(1, 1, 1)
	end
	local red, green, blue = labelColor:match("^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$")
	if not red or not green or not blue then
		return Color3.new(1, 1, 1)
	end
	return Color3.fromRGB(
		math.clamp(tonumber(red) or 255, 0, 255),
		math.clamp(tonumber(green) or 255, 0, 255),
		math.clamp(tonumber(blue) or 255, 0, 255)
	)
end

return MutationDataUtil
