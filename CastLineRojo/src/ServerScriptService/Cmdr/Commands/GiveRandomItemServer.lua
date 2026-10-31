local ServerScriptService = game:GetService("ServerScriptService")

local ItemGrantUtil = require(ServerScriptService.Services.ItemGrantUtil)

local function normalizeAmount(amount: number?): (number?, string?)
	local normalized = math.floor(tonumber(amount) or 1)
	if normalized < 1 then
		return nil, "Amount must be a positive whole number"
	end
	return normalized
end

return function(_context, player: Player, amount: number?)
	local count, amountError = normalizeAmount(amount)
	if not count then
		return amountError
	end

	local itemIds = ItemGrantUtil.GetOrderedItemIds()
	if #itemIds == 0 then
		return "No configured items are available"
	end

	local random = Random.new()
	local grantedCounts = {}
	for index = 1, count do
		local itemId = itemIds[random:NextInteger(1, #itemIds)]
		local _, grantError = ItemGrantUtil.Grant(player, itemId, {
			Random = random,
			CountTowardTotalWeight = true,
		})
		if grantError then
			return string.format("Gave %d/%d random items: %s", index - 1, count, grantError)
		end
		grantedCounts[itemId] = (grantedCounts[itemId] or 0) + 1
	end

	local summary = {}
	for _, itemId in ipairs(itemIds) do
		local granted = grantedCounts[itemId]
		if granted then
			table.insert(summary, string.format("%s x%d", itemId, granted))
		end
	end
	return string.format("Gave %d random items to %s: %s", count, player.Name, table.concat(summary, ", "))
end
