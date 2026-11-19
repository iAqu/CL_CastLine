local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventFishConfig = require(ReplicatedStorage.Modules.EventFishConfig)

return {
	Name = "startEventFish",
	Aliases = { "sef" },
	Description = string.format("Start a random Event fish window for %d seconds in this server", EventFishConfig.Duration),
	Group = "Admin",
	Args = {},
}
