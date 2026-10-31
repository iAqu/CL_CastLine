local WeightFormat = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)

function WeightFormat.FormatKg(weight: number?): string
	local value = tonumber(weight) or 0
	if math.abs(value) < 10 then
		return string.format("%.1fkg", math.round(value * 10) / 10)
	end
	return string.format("%dkg", math.round(value))
end

function WeightFormat.FormatKgCompact(weight: number?): string
	local value = tonumber(weight) or 0
	if math.abs(value) < 1_000 then
		return WeightFormat.FormatKg(value)
	end
	return NumberUtil.FormatNumberStartKWithDecimal(value, 1) .. "kg"
end

return WeightFormat
