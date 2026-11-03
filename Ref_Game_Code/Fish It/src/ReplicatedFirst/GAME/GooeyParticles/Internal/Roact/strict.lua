-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ strict | Line: 2 ]]
	local v2 = p2 or tostring(p1)
	local t = {
		__index = function(p1, p2) --[[ __index | Line: 6 | Upvalues: v2 (ref) ]]
			error(("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), v2), 2)
		end,
		__newindex = function(p1, p2, p3) --[[ __newindex | Line: 12 | Upvalues: v2 (ref) ]]
			error(("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), v2), 2)
		end
	}
	return setmetatable(p1, t)
end