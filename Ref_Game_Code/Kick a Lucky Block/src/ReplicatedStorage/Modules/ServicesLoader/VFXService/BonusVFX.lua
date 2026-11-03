-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local BonusVFX = game:GetService("ReplicatedStorage").Objects.VFX.BonusVFX
return function(p1) --[[ Line: 7 | Upvalues: BonusVFX (copy) ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")
		if RootAttachment then
			if not RootAttachment:FindFirstChildWhichIsA("ParticleEmitter") then
				for i, v in ipairs(BonusVFX:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Clone().Parent = RootAttachment
					end
				end
			end
			for i, v in ipairs(RootAttachment:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v:Emit(v:GetAttribute("EmitCount") or 1)
				end
			end
		else
			warn("no this thing")
		end
	else
		warn("no this thing")
	end
end