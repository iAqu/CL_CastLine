-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Util = require(script.Parent.Parent.Shared.Util)
local t = {
	Validate = function(p1) --[[ Validate | Line: 4 ]]
		if p1:match("^https?://.+$") then
			return true
		else
			return false, "URLs must begin with http:// or https://"
		end
	end,
	Parse = function(p1) --[[ Parse | Line: 12 ]]
		return p1
	end
}
return function(p1) --[[ Line: 17 | Upvalues: t (copy), Util (copy) ]]
	p1:RegisterType("url", t)
	p1:RegisterType("urls", Util.MakeListableType(t))
end