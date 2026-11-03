-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent.Parent.Shared.Util)
game:GetService("Players")
local t = {
	Transform = function(p1) --[[ Transform | Line: 5 ]]
		return p1
	end,
	Validate = function(p1) --[[ Validate | Line: 9 ]]
		return true, p1
	end,
	Autocomplete = function(p1) --[[ Autocomplete | Line: 13 ]]
		local t = {}
		for i, v in ipairs({ "Crates", "Parts" }) do
			if v:lower():sub(1, #p1) == p1:lower() then
				table.insert(t, v)
			end
		end
		return t
	end
}
return function(p1) --[[ Line: 28 | Upvalues: t (copy) ]]
	p1:RegisterType("shops", t)
end