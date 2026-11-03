-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ToggleAllTrails = function(p1, p2) --[[ ToggleAllTrails | Line: 4 ]]
		for i, v in ipairs(p1:GetDescendants()) do
			if v:IsA("Trail") then
				v.Enabled = p2
			end
		end
	end,
	GetMaxLifetime = function(p1) --[[ GetMaxLifetime | Line: 13 ]]
		local v1 = 0
		for i, v in ipairs(p1:GetDescendants()) do
			if v:IsA("Trail") then
				v1 = math.max(v1, v.Lifetime)
				continue
			end
			if v:IsA("ParticleEmitter") then
				v1 = math.max(v1, v.Lifetime.Max)
			end
		end
		return v1
	end
}