-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ oneChild | Line: 8 ]]
	if not p1 then
		return nil
	end
	local v1, v2 = next(p1)
	if not v2 then
		return nil
	end
	if not next(p1, v1) then
		return v2
	end
	error("Expected at most child, had more than one child.", 2)
end