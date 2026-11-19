local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local EventFishConfig = require(ReplicatedStorage.Modules.EventFishConfig)
local EventFishService = require(ServerScriptService.Services.EventFishService)

return function(_context)
	local fish = EventFishService:StartEvent()
	if not fish then
		return "No Event fish has a valid model; the event was not started."
	end
	return string.format(
		"Started Event fish: %s (%s) for %d seconds in this server.",
		fish.DisplayName, fish.FishID, EventFishConfig.Duration
	)
end
