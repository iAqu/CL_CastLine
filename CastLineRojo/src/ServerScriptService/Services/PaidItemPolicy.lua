local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local Policy = {}
local cache = {}
local pending = {}

function Policy.GetCached(player)
	local entry = cache[player]
	return if entry and entry.Expires > os.clock() then entry.Value else nil
end

function Policy.Get(player)
	if not player or player.Parent ~= Players then
		return nil
	end
	local cached = Policy.GetCached(player)
	if cached then
		return cached
	end
	local waiters = pending[player]
	if waiters then
		table.insert(waiters, coroutine.running())
		local value = coroutine.yield()
		return if player.Parent == Players then value else nil
	end
	waiters = {}
	pending[player] = waiters
	local ok, value = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, player)
	if ok and type(value) == "table" and player.Parent == Players then
		cache[player] = { Value = value, Expires = os.clock() + 60 }
	else
		cache[player], value = nil, nil
	end
	pending[player] = nil
	for _, waiter in ipairs(waiters) do
		task.defer(waiter, value)
	end
	return value
end

function Policy.CanPurchase(buyer, recipient, unavailableMessage: string?)
	local buyerPolicy = Policy.Get(buyer)
	local recipientPolicy = if buyer == recipient then buyerPolicy else Policy.Get(recipient)
	if not buyerPolicy or not recipientPolicy then
		return false, "Purchase availability could not be checked. Please try again.", true
	end
	if buyerPolicy.ArePaidRandomItemsRestricted ~= false or recipientPolicy.ArePaidRandomItemsRestricted ~= false then
		return false, unavailableMessage or "Paid eggs are unavailable for this player."
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
	cache[player] = nil
end)
Players.PlayerAdded:Connect(function(player)
	task.defer(Policy.Get, player)
end)
for _, player in Players:GetPlayers() do
	task.defer(Policy.Get, player)
end
return Policy
