-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local StadiumVFX = game:GetService("ReplicatedStorage").Objects.VFX.StadiumVFX
return function(p1) --[[ Line: 5 | Upvalues: StadiumVFX (copy) ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")
		if RootAttachment then
			if RootAttachment:FindFirstChildWhichIsA("ParticleEmitter") then
				for i, v in ipairs(RootAttachment:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = true
					end
				end
			else
				for i, v in ipairs(StadiumVFX:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						local v1 = v:Clone()
						v1.Enabled = true
						v1.Parent = RootAttachment
					end
				end
			end
		else
			warn("no this thing")
		end
	else
		warn("no this thing")
	end
end