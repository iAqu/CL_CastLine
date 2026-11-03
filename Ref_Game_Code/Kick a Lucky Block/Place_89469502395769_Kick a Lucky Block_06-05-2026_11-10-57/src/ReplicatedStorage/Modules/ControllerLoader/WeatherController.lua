-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeatherData = require(ReplicatedStorage.Shared.Data.WeatherData)
return {
	LoadWeather = function(p1, p2, p3, p4) --[[ LoadWeather | Line: 12 | Upvalues: WeatherData (copy) ]]
		local v1 = WeatherData:GetWeatherModule(p2)
		if v1 then
			v1:Initialize(p3, p4)
		end
	end,
	UnloadWeather = function(p1, p2) --[[ UnloadWeather | Line: 19 | Upvalues: WeatherData (copy) ]]
		local v1 = WeatherData:GetWeatherModule(p2)
		if v1 then
			v1:Destroy()
		end
	end
}