-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeatherData = require(ReplicatedStorage.Shared.Data.WeatherData)
local Util = require(script.Parent.Parent.Shared.Util)
local v1 = Util.MakeFuzzyFinder(WeatherData.ValidEvents)
local t = {
	Transform = function(p1) --[[ Transform | Line: 11 | Upvalues: v1 (copy) ]]
		local t = {}
		for k, v in pairs(v1(p1)) do
			t[k] = v
		end
		return t
	end,
	Validate = function(p1) --[[ Validate | Line: 19 ]]
		return #p1 > 0, "No valid event found."
	end,
	Autocomplete = function(p1) --[[ Autocomplete | Line: 23 | Upvalues: Util (copy) ]]
		return Util.GetNames(p1)
	end,
	Parse = function(p1) --[[ Parse | Line: 27 ]]
		return p1[1]
	end
}
local _ = {
	Transform = t.Transform,
	Validate = t.Validate,
	Autocomplete = t.Autocomplete,
	Parse = function(p1) --[[ Parse | Line: 37 ]]
		return p1[1]
	end
}
return function(p1) --[[ Line: 42 | Upvalues: t (copy) ]]
	p1:RegisterType("weatherEvent", t)
end