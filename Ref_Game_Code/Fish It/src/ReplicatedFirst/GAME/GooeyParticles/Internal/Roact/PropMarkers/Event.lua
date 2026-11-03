-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Type = require(script.Parent.Parent.Type)
local t = {}
local t2 = {
	__tostring = function(p1) --[[ __tostring | Line: 21 ]]
		return ("RoactHostEvent(%s)"):format(p1.name)
	end
}
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 27 | Upvalues: Type (copy), t2 (copy), t (copy) ]]
		local t3 = {
			[Type] = Type.HostEvent,
			name = p2
		}
		setmetatable(t3, t2)
		t[p2] = t3
		return t3
	end
})
return t