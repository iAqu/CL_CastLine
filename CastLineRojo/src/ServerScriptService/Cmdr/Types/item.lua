local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ItemsData = require(ReplicatedFirst.Data.ItemsData)

local function getOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(ItemsData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftItem = ItemsData[left]
		local rightItem = ItemsData[right]
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
