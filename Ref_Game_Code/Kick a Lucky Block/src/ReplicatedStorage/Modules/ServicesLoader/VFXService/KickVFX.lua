-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local KickVFX = game:GetService("ReplicatedStorage").Objects.VFX.KickVFX
return function(p1) --[[ Line: 7 | Upvalues: KickVFX (copy) ]]
	local RightFoot = p1:FindFirstChild("RightFoot")
	if RightFoot then
		local RightFootAttachment = RightFoot:FindFirstChild("RightFootAttachment")
		if RightFootAttachment then
			if not RightFootAttachment:FindFirstChildWhichIsA("ParticleEmitter") then
				for i, v in ipairs(KickVFX:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Clone().Parent = RightFootAttachment
					end
				end
			end
			for i, v in ipairs(RightFootAttachment:GetChildren()) do
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