-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 5 ]]
	if table.isfrozen(p1) then
		return p1
	else
		return table.freeze(p1)
	end
end