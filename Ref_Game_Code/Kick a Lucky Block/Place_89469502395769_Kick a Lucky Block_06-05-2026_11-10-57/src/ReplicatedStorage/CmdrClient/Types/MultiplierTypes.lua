-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Util = require(script.Parent.Parent.Shared.Util)
local v1 = Util.MakeFuzzyFinder({ "weight_speed", "weight_power", "kick_speed", "kick_power", "run_speed", "cash" })
local t = {
	Transform = function(p1) --[[ Transform | Line: 8 | Upvalues: v1 (copy) ]]
		local t = {}
		for k, v in pairs(v1(p1)) do
			t[k] = v
		end
		return t
	end,
	Validate = function(p1) --[[ Validate | Line: 16 ]]
		return #p1 > 0, "No valid event found."
	end,
	Autocomplete = function(p1) --[[ Autocomplete | Line: 20 | Upvalues: Util (copy) ]]
		return Util.GetNames(p1)
	end,
	Parse = function(p1) --[[ Parse | Line: 24 ]]
		return p1[1]
	end
}
local _ = {
	Transform = t.Transform,
	Validate = t.Validate,
	Autocomplete = t.Autocomplete,
	Parse = function(p1) --[[ Parse | Line: 34 ]]
		return p1[1]
	end
}
return function(p1) --[[ Line: 39 | Upvalues: t (copy) ]]
	p1:RegisterType("multiplier", t)
end