local ServerScriptService = game:GetService("ServerScriptService")

local EggService = require(ServerScriptService.Services.EggService)

return function(_context, player: Player, eggId: string, amount: number?)
	local count = if amount == nil then 1 else amount
	if
		type(count) ~= "number"
		or count ~= count
		or math.abs(count) == math.huge
		or count < 1
		or count ~= math.floor(count)
	then
		return "Amount must be a finite positive whole number"
	end

	for index = 1, count do
		local uuid, grantError = EggService:GiveEgg(player, eggId)
		if not uuid then
			return string.format(
				"Gave %d/%d %s to %s: %s",
				index - 1, count, eggId, player.Name, grantError or "Egg grant failed"
			)
		end
	end

	return string.format("Gave %d %s to %s", count, eggId, player.Name)
end
