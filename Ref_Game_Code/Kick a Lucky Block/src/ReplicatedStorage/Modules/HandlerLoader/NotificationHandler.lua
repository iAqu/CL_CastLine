-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local NotificationController = require(ReplicatedStorage.Modules.ControllerLoader.NotificationController)
local t = {}
function SpeedConnections() --[[ SpeedConnections | Line: 11 | Upvalues: SpeedServiceClient (copy), NotificationController (copy) ]]
	if not SpeedServiceClient.DidInit then
		SpeedServiceClient.LevelChanged:Wait()
	end
	local Level = SpeedServiceClient.Level
	SpeedServiceClient.LevelChanged:Connect(function(p1) --[[ Line: 17 | Upvalues: Level (ref), NotificationController (ref) ]]
		local v1 = p1 - Level
		Level = p1
		if not (v1 <= 0) then
			NotificationController:Create("Speed", v1)
		end
	end)
end
function t._init(p1) --[[ _init | Line: 31 ]]
	task.spawn(SpeedConnections)
end
return t