-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local freeze = table.freeze
return freeze((setmetatable({}, {
	__index = function() --[[ __index | Line: 2 ]]
		error("attempt to index on None symbol")
	end,
	__tostring = function() --[[ __tostring | Line: 5 ]]
		return "<None>"
	end
})))