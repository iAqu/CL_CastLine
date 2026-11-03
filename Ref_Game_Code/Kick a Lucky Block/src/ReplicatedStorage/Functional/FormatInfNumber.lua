-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	if p1 then
		if typeof(p1) == "table" and (p1.first and p1.second) then
			p1 = p1:GetSuffix(true)
		end
		if typeof(p1) ~= "string" then
			p1 = tostring(p1)
		end
		local v3 = p1:find("%.")
		if v3 then
			local v4 = p1:find("%a") or #p1 + 1
			local v5 = p1:sub(1, v3 - 1)
			local v6 = p1:sub(v3 + 1, v3 + 1)
			local v7 = p1:sub(v4 - 1 + 1)
			if v6 == "0" or v6 == "" then
				return v5 .. v7
			else
				return v5 .. "." .. v6 .. v7
			end
		else
			return p1
		end
	else
		return ""
	end
end