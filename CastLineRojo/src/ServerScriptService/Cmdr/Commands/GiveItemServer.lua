local ServerScriptService = game:GetService("ServerScriptService")

local ItemGrantUtil = require(ServerScriptService.Services.ItemGrantUtil)

local function normalizeAmount(amount: number?): (number?, string?)
	local normalized = math.floor(tonumber(amount) or 1)
	if normalized < 1 then
		return nil, "Amount must be a positive whole number"
	end
	return normalized
end

return function(_context, player: Player, itemId: string, amount: number?)
	local count, amountError = normalizeAmount(amount)
	if not count then
		return amountError
	end

	for _ = 1, count do
		local _, grantError = ItemGrantUtil.Grant(player, itemId, { CountTowardTotalWeight = true })
		if grantError then
			return string.format("Gave %d/%d %s: %s", _ - 1, count, itemId, grantError)
		end
	end

	return string.format("Gave %d %s to %s", count, itemId, player.Name)
end
