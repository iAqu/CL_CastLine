-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local Util = require(script.Parent.Parent.Shared.Util)
local t = {}
for k, v in pairs(EntitiesData.LuckyBlocks) do
	if v.Model then
		table.insert(t, k)
	end
end
local v1 = Util.MakeFuzzyFinder(t)
local t2 = {
	Transform = function(p1) --[[ Transform | Line: 17 | Upvalues: v1 (copy) ]]
		local t = {}
		for k, v in pairs(v1(p1)) do
			t[k] = v
		end
		return t
	end,
	Validate = function(p1) --[[ Validate | Line: 25 ]]
		return #p1 > 0, "No valid event found."
	end,
	Autocomplete = function(p1) --[[ Autocomplete | Line: 29 | Upvalues: Util (copy) ]]
		return Util.GetNames(p1)
	end,
	Parse = function(p1) --[[ Parse | Line: 33 ]]
		return p1[1]
	end
}
local _ = {
	Transform = t2.Transform,
	Validate = t2.Validate,
	Autocomplete = t2.Autocomplete,
	Parse = function(p1) --[[ Parse | Line: 43 ]]
		return p1[1]
	end
}
return function(p1) --[[ Line: 48 | Upvalues: t2 (copy) ]]
	p1:RegisterType("luckyblock", t2)
end