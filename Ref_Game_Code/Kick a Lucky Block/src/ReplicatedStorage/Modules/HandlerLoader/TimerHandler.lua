-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeatherService_Client = require(ReplicatedStorage.Modules.ServicesLoader.WeatherService_Client)
local WeatherData = require(ReplicatedStorage.Shared.Data.WeatherData)
local DisplayedTimerController = require(ReplicatedStorage.Modules.ControllerLoader.DisplayedTimerController)
local t = {}
function RemoveEvent(p1) --[[ RemoveEvent | Line: 16 | Upvalues: DisplayedTimerController (copy) ]]
	DisplayedTimerController:RemoveTimer(p1)
end
function AddEvent(p1, p2) --[[ AddEvent | Line: 20 | Upvalues: WeatherData (copy), DisplayedTimerController (copy) ]]
	local v1 = WeatherData:GetWeatherModule(p1)
	if v1 and v1.Info then
		DisplayedTimerController:AddTimer({
			Name = v1.Info.Title or p1,
			Description = v1.Info.Description or "",
			EndTime = p2,
			ImageId = v1.Info.Image
		})
	end
end
function t._init(p1) --[[ _init | Line: 42 | Upvalues: WeatherService_Client (copy) ]]
	for k, v in pairs(WeatherService_Client.Events) do
		AddEvent(k, v)
	end
	WeatherService_Client.WeatherAdded:Connect(AddEvent)
	WeatherService_Client.WeatherRemoved:Connect(RemoveEvent)
end
return t