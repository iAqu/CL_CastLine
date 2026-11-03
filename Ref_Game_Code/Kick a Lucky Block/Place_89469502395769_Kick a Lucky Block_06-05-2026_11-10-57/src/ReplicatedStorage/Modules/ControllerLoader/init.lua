-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	for i, v in ipairs(script:GetChildren()) do
		if v:IsA("ModuleScript") then
			local v1 = require(v)
			if v1._init then
				v1:_init()
			end
		end
	end
end