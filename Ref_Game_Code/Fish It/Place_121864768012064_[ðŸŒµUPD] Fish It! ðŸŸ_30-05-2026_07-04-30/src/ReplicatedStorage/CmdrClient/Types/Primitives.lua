-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Util = require(script.Parent.Parent.Shared.Util)
local t = {
	Validate = function(p1) --[[ Validate | Line: 4 ]]
		return p1 ~= nil
	end,
	Parse = function(p1) --[[ Parse | Line: 8 ]]
		return tostring(p1)
	end
}
local t2 = {
	Transform = function(p1) --[[ Transform | Line: 14 ]]
		return tonumber(p1)
	end,
	Validate = function(p1) --[[ Validate | Line: 18 ]]
		return p1 ~= nil
	end,
	Parse = function(p1) --[[ Parse | Line: 22 ]]
		return p1
	end
}
local t3 = {
	Transform = function(p1) --[[ Transform | Line: 28 ]]
		return tonumber(p1)
	end,
	Validate = function(p1) --[[ Validate | Line: 32 ]]
		return if p1 == nil then false else p1 == math.floor(p1), "Only whole numbers are valid."
	end,
	Parse = function(p1) --[[ Parse | Line: 36 ]]
		return p1
	end
}
local v1 = Util.MakeDictionary({
	"true",
	"t",
	"yes",
	"y",
	"on",
	"enable",
	"enabled",
	"1",
	"+"
})
local v2 = Util.MakeDictionary({
	"false",
	"f",
	"no",
	"n",
	"off",
	"disable",
	"disabled",
	"0",
	"-"
})
local t4 = {
	Transform = function(p1) --[[ Transform | Line: 46 ]]
		return p1:lower()
	end,
	Validate = function(p1) --[[ Validate | Line: 50 | Upvalues: v1 (copy), v2 (copy) ]]
		return if v1[p1] == nil then v2[p1] ~= nil else true, "Please use true/yes/on or false/no/off."
	end,
	Parse = function(p1) --[[ Parse | Line: 54 | Upvalues: v1 (copy), v2 (copy) ]]
		if v1[p1] then
			return true
		end
		if v2[p1] then
			return false
		else
			return nil
		end
	end
}
return function(p1) --[[ Line: 66 | Upvalues: t (copy), t2 (copy), t3 (copy), t4 (ref), Util (copy) ]]
	p1:RegisterType("string", t)
	p1:RegisterType("number", t2)
	p1:RegisterType("integer", t3)
	p1:RegisterType("boolean", t4)
	p1:RegisterType("strings", Util.MakeListableType(t))
	p1:RegisterType("numbers", Util.MakeListableType(t2))
	p1:RegisterType("integers", Util.MakeListableType(t3))
	p1:RegisterType("booleans", Util.MakeListableType(t4))
end