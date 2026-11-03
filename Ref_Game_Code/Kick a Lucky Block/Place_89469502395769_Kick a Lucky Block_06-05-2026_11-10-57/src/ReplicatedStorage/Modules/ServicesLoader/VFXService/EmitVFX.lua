-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
function EmitParticle(p1) --[[ EmitParticle | Line: 1 ]]
	local v1 = p1:GetAttribute("EmitDuration")
	local v2 = p1:GetAttribute("EmitCount")
	if v1 and (typeof(v1) == "number" and v1 > 0) then
		p1.Enabled = true
		task.delay(v1, function() --[[ Line: 7 | Upvalues: p1 (copy) ]]
			p1.Enabled = false
		end)
	else
		p1:Emit(v2 or 1)
	end
end
return function(p1, p2) --[[ Line: 15 ]]
	if p1 and p2 then
		local v1 = p2:Clone()
		v1.Parent = p1
		if v1:IsA("BasePart") then
			v1.Anchored = false
			local Weld = Instance.new("Weld")
			Weld.Part0 = p1
			Weld.Part1 = v1
			Weld.Parent = v1
		end
		if v1:IsA("ParticleEmitter") then
			v1:Emit(v1:Emit(v1:GetAttribute("EmitCount") or 1))
		end
		for i, v in ipairs(v1:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				if v:GetAttribute("EmitDelay") then
					task.delay(v:GetAttribute("EmitDelay"), EmitParticle, v)
				end
				EmitParticle(v)
			end
		end
		game.Debris:AddItem(v1, 2)
	end
end