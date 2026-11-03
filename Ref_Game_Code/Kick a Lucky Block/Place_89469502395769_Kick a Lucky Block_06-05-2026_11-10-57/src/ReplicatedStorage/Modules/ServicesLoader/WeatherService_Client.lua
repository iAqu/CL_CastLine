-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local WeatherController = require(ReplicatedStorage.Modules.ControllerLoader.WeatherController)
local v1 = Network.CreateRemote("WeatherUpdate")
local v2 = Network.CreateRemote("AddedWeather")
local v3 = Network.CreateRemote("RemovedWeather")
local t = {
	Events = {},
	WeatherAdded = Signal.new(),
	WeatherRemoved = Signal.new()
}
function OnWeatherUpdate(p1) --[[ OnWeatherUpdate | Line: 22 | Upvalues: t (copy), WeatherController (copy) ]]
	t.Events = p1
	for k, v in pairs(p1) do
		if v < workspace:GetServerTimeNow() then
			t.Events[k] = nil
		end
		WeatherController:LoadWeather(k, v)
		t.WeatherAdded:Fire(k, v)
	end
end
function OnWeatherRemoved(p1) --[[ OnWeatherRemoved | Line: 35 | Upvalues: t (copy), WeatherController (copy) ]]
	t.Events[p1] = nil
	WeatherController:UnloadWeather(p1)
	t.WeatherRemoved:Fire(p1)
end
function OnWeatherAdded(p1, p2) --[[ OnWeatherAdded | Line: 41 | Upvalues: t (copy), WeatherController (copy) ]]
	if p1 then
		t.Events[p1] = p2
		WeatherController:LoadWeather(p1, p2, true)
		t.WeatherAdded:Fire(p1, p2)
	end
end
function t._init(p1) --[[ _init | Line: 53 | Upvalues: Network (copy), v1 (copy), v3 (copy), v2 (copy) ]]
	Network.OnClientEvent(v1):Connect(OnWeatherUpdate)
	Network.OnClientEvent(v3):Connect(OnWeatherRemoved)
	Network.OnClientEvent(v2):Connect(OnWeatherAdded)
end
return t