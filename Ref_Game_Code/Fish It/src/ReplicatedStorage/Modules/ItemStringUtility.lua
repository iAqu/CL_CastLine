-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	GetItemName = function(p1, p2) --[[ GetItemName | Line: 4 ]]
		local Metadata = p1.Metadata
		local v1 = if Metadata then Metadata.Weight else Metadata
		local v2 = p2.Data.Name or (p2.Name or "")
		if Metadata and Metadata.Shiny then
			v2 = "Shiny " .. v2
		end
		if v1 and (p2.Weight and p2.Weight.Big.Min < v1) then
			v2 = "Big " .. v2
		end
		return v2
	end
}