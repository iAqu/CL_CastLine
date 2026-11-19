local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local Policy = {}
local cache = {}

function Policy.Get(player)
	if not player or player.Parent ~= Players then
		return nil
	end
	local entry = cache[player.UserId]
	if entry and entry.Expires > os.clock() then
		return entry.Value
	end
	local ok, value = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, player)
	if not ok or type(value) ~= "table" then
		return nil
	end
	cache[player.UserId] = { Value = value, Expires = os.clock() + 60 }
	return value
end

function Policy.CanPurchase(buyer, recipient)
	local buyerPolicy = Policy.Get(buyer)
	local recipientPolicy = if buyer == recipient then buyerPolicy else Policy.Get(recipient)
	if not buyerPolicy or not recipientPolicy then
		return false, "Purchase availability could not be checked. Please try again."
	end
	if buyerPolicy.ArePaidRandomItemsRestricted ~= false or recipientPolicy.ArePaidRandomItemsRestricted ~= false then
		return false, "Paid eggs are unavailable for this player."
	end
	if
		buyer ~= recipient
		and (buyerPolicy.IsPaidItemTradingAllowed ~= true or recipientPolicy.IsPaidItemTradingAllowed ~= true)
	then
		return false, "Paid gifts are unavailable for this player."
	end
	return true
end

function Policy.CanTransfer(sender, recipient)
	if sender == recipient then
		return true
	end
	local a, b = Policy.Get(sender), Policy.Get(recipient)
	return a ~= nil and b ~= nil and a.IsPaidItemTradingAllowed == true and b.IsPaidItemTradingAllowed == true
end

Players.PlayerRemoving:Connect(function(player)
	cache[player.UserId] = nil
end)
return Policy
