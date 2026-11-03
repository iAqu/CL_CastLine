-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	for v1, v2 in script:GetDescendants() do
		if v2:IsA("ModuleScript") then
			local v3 = require(v2)
			if typeof(v3) == "table" and v3._init then
				v3:_init()
			end
		end
	end
end