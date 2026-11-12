local ServerScriptService = game:GetService("ServerScriptService")

local PetService = require(ServerScriptService.Services.PetService)

return function(_context, player: Player, petId: string, amount: number?)
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
		local pet, grantError = PetService:GivePet(player, petId)
		if not pet then
			return string.format(
				"Gave %d/%d %s to %s: %s",
				index - 1, count, petId, player.Name, grantError or "Pet grant failed"
			)
		end
	end

	return string.format("Gave %d %s to %s", count, petId, player.Name)
end
