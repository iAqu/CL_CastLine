local ServerScriptService = game:GetService("ServerScriptService")
local EventFishService = require(ServerScriptService.Services.EventFishService)

return function(_context)
	local fish = EventFishService:StartEvent()
	if not fish then
		return "No Event fish has a valid model; the event was not started."
	end
	return string.format("Started Event fish: %s (%s) for 30 seconds in this server.", fish.DisplayName, fish.FishID)
end
