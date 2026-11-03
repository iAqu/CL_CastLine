-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 2 ]]
	if not p1 or typeof(p1) ~= "table" then
		return false
	end
	if typeof(p1.equals) == "function" then
		return true
	else
		return false
	end
end