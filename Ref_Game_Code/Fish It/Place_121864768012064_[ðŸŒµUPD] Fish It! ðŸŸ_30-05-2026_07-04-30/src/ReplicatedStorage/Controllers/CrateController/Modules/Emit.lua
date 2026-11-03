-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2, ...) --[[ Line: 1 ]]
	local t = {}
	local v1 = 0
	local function resolveParent(p1) --[[ resolveParent | Line: 5 ]]
		if p1:IsA("Attachment") then
			return p1.Parent
		else
			return p1
		end
	end
	local function handleEmitter(p1, p22, p3) --[[ handleEmitter | Line: 12 | Upvalues: p2 (copy), v1 (ref), t (copy) ]]
		local v12
		if p3 then
			local v2 = p1:Clone()
			v2.Parent = p22
			v12 = v2
		else
			v12 = p1
		end
		if v12:IsA("ParticleEmitter") then
			v12.Enabled = false
		end
		if p2 then
			p2(v12)
		end
		local v3 = v12:GetAttribute("EmitCount") or v12.Rate
		v1 = math.max(v1, (v12:GetAttribute("EmitDelay") or 0) + v12.Lifetime.Max)
		table.insert(t, v12)
		if not v12:IsA("ParticleEmitter") then
			return
		end
		v12:Emit(v3)
	end
	for i, v in ipairs(table.pack(...)) do
		if v:IsA("ParticleEmitter") then
			handleEmitter(v, p1, true)
			continue
		end
		if v:IsA("Attachment") or v:IsA("BasePart") then
			local v2 = if p1:IsA("Attachment") then p1.Parent else p1
			local v3 = v:Clone()
			v3.Parent = v2
			for i2, v4 in ipairs(v3:GetDescendants()) do
				if v4:IsA("ParticleEmitter") then
					handleEmitter(v4, v4.Parent, false)
				end
			end
		end
	end
	return t, v1
end