local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)

local function getOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(FishInventoryData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftItem = FishInventoryData[left]
		local rightItem = FishInventoryData[right]
		if leftItem.LayoutOrder ~= rightItem.LayoutOrder then
			return leftItem.LayoutOrder < rightItem.LayoutOrder
		end
		return left < right
	end)
	return itemIds
end

return function(registry)
	registry:RegisterType("item", registry.Cmdr.Util.MakeEnumType("item", getOrderedItemIds()))
end
