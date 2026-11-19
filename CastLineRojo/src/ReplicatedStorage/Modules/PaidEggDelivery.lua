-- Profile-only delivery state. The grant callback commits each slot beside its item.
local Delivery = {}

function Delivery.Ensure(data)
	if type(data.PaidEgg) ~= "table" then
		data.PaidEgg = { Intent = false, Receipts = {}, Results = {}, Purchases = {}, Revision = 0 }
	end
	return data.PaidEgg
end

function Delivery.Result(order, discoveries)
	local newFish = {}
	local seen = {}
	for index, reward in ipairs(order.Rewards) do
		newFish[index] = discoveries ~= nil and not discoveries[reward.ItemId] and not seen[reward.ItemId]
		seen[reward.ItemId] = true
	end
	return {
		OrderId = order.OrderId,
		PurchaseId = order.PurchaseId,
		ProductId = order.ProductId,
		SenderUserId = order.BuyerUserId,
		SenderName = order.SenderName,
		Rewards = order.Rewards,
		NewFish = newFish,
		CreatedAt = order.CreatedAt,
	}
end

function Delivery.Apply(data, order, grantBatch, result)
	local state = Delivery.Ensure(data)
	local receipt = state.Receipts[order.OrderId]
	if receipt and receipt.Complete then
		return true, false
	end
	receipt = receipt or { Slots = {}, Complete = false }
	local missing = {}
	for index, reward in ipairs(order.Rewards) do
		local slot = tostring(index)
		if not receipt.Slots[slot] then
			table.insert(missing, reward)
		end
	end
	local committed = false
	local function commit()
		for index in ipairs(order.Rewards) do
			receipt.Slots[tostring(index)] = true
		end
		receipt.Complete = true
		state.Receipts[order.OrderId] = receipt
		state.Results[order.OrderId] = result or Delivery.Result(order)
		committed = true
	end
	if #missing == 0 then
		commit()
		return true, true
	end
	local ok, granted, message = pcall(grantBatch, missing, commit)
	if not committed then
		return false, false, if ok then message or tostring(granted) else tostring(granted)
	end
	return true, true
end

function Delivery.Pending(data)
	local results = {}
	for _, result in pairs(Delivery.Ensure(data).Results) do
		table.insert(results, result)
	end
	table.sort(results, function(a, b)
		if a.CreatedAt == b.CreatedAt then
			return a.OrderId < b.OrderId
		end
		return a.CreatedAt < b.CreatedAt
	end)
	return results
end

function Delivery.Acknowledge(data, orderId)
	local state = Delivery.Ensure(data)
	if type(orderId) ~= "string" or not state.Receipts[orderId] or not state.Receipts[orderId].Complete then
		return false
	end
	state.Results[orderId] = nil
	return true
end

return Delivery
