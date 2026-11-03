-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Debris")
local VFX = ReplicatedStorage:WaitForChild("VFX")
local function emitContainer(p1) --[[ emitContainer | Line: 12 ]]
	local v1 = 0
	for v2, v3 in p1:GetDescendants() do
		if v3:IsA("ParticleEmitter") then
			local v4 = v3:GetAttribute("EmitDelay") or 0
			local v5 = v3:GetAttribute("EmitCount")
			if not v5 then
				v5 = tonumber(v3.Name) or 0
			end
			local v7 = v3:GetAttribute("EmitDuration") or 0
			local v8 = math.max(v1, v4 + v7)
			task.delay(v4, function() --[[ Line: 29 | Upvalues: v3 (copy), v5 (copy), v7 (copy) ]]
				if not (v3 and v3.Parent) then
					return
				end
				v3.Enabled = false
				v3:Emit(v5)
				if not (v7 > 0) then
					return
				end
				task.defer(function() --[[ Line: 35 | Upvalues: v3 (ref), v7 (ref) ]]
					if not (v3 and v3.Parent) then
						return
					end
					task.delay(v7, function() --[[ Line: 37 | Upvalues: v3 (ref) ]]
						if not (v3 and v3.Parent) then
							return
						end
						v3:Destroy()
					end)
				end)
			end)
			v1 = v8
		end
	end
	return v1
end
local function emitParticles(p1) --[[ emitParticles | Line: 64 | Upvalues: VFX (copy), emitContainer (copy) ]]
	local particleName = p1.particleName
	local position = p1.position
	local v1 = p1.parent or workspace
	local v2 = VFX:FindFirstChild(particleName)
	if not v2 then
		warn((("Particle \"%*\" not found in VFX"):format(particleName)))
		return nil
	end
	local v3 = v2:Clone()
	v3.Parent = v1
	if v3:IsA("BasePart") then
		v3.CFrame = CFrame.new(position)
	elseif v3:IsA("Model") then
		if v3.PrimaryPart then
			v3:PivotTo(CFrame.new(position))
		else
			local BasePart = v3:FindFirstChildOfClass("BasePart")
			if BasePart then
				BasePart.CFrame = CFrame.new(position)
			end
		end
	end
	task.delay(emitContainer(v3) + 2, function() --[[ Line: 95 | Upvalues: v3 (copy) ]]
		if not (v3 and v3.Parent) then
			return
		end
		v3:Destroy()
	end)
	return v3
end
return {
	emitParticles = emitParticles,
	emitParticlesAt = function(p1, p2, p3) --[[ emitParticlesAt | Line: 113 | Upvalues: emitParticles (copy) ]]
		return emitParticles({
			particleName = p1,
			position = p2,
			parent = p3
		})
	end,
	emitContainer = emitContainer
}