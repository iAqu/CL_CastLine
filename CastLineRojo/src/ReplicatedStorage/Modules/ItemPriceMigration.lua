
local FishInventoryData = require(script.Parent.FishInventoryData)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local MutationDataUtil = require(script.Parent.MutationDataUtil)

-- Price is a cache of the current formula, including for fish already placed on a plot.
return function(data)
	if typeof(data.Items) ~= "table" then
		return
	end
	for _, record in pairs(data.Items) do
		if typeof(record) ~= "table" then
			continue
		end
		local item = FishInventoryData[record.ItemId]
		local weight = tonumber(record.Weight)
		if item and weight and weight > 0 and weight < math.huge then
			record.Price = ItemStatUtil.CalculatePrice(item, weight, MutationDataUtil.GetPriceRate(record.MutationId))
		end
	end
end
