-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local OpeningVFX = game:GetService("ReplicatedStorage").Objects.VFX.OpeningVFX
return function(p1) --[[ Line: 7 | Upvalues: OpeningVFX (copy) ]]
	local PrimaryPart = p1.PrimaryPart
	if PrimaryPart then
		if not PrimaryPart:FindFirstChildWhichIsA("ParticleEmitter") then
			for i, v in ipairs(OpeningVFX:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v:Clone().Parent = PrimaryPart
				end
			end
		end
		for i, v in ipairs(PrimaryPart:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(v:GetAttribute("EmitCount") or 1)
			end
		end
	else
		warn("no this thing")
	end
end