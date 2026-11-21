local WeightFormat = {}

function WeightFormat.FormatKg(weight: number?): string
	local value = tonumber(weight) or 0
	if math.abs(value) < 10 then
		return string.format("%.1f kg", math.round(value * 10) / 10)
	end
	return string.format("%.0f kg", math.round(value))
end

return WeightFormat
