-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	new = function(p1) --[[ new | Line: 1 ]]
		local CreateParticleHost = p1.CreateParticleHost
		local Emit = p1.Emit
		local Assets = p1.Assets
		local Debris = p1.Debris
		return {
			emitParticles = function(p1, p2, p3, p4, p5) --[[ emitParticles | Line: 7 | Upvalues: CreateParticleHost (copy), Emit (copy), Assets (copy), Debris (copy) ]]
				local v1, v2 = CreateParticleHost(p2)
				local v4 = Assets.Particles:WaitForChild(p1)
				local _, v5 = Emit(v2, function(p1) --[[ Line: 9 | Upvalues: p3 (copy), p5 (copy), p4 (copy) ]]
					p1.Lifetime = NumberRange.new(p1.Lifetime.Min * p3, p1.Lifetime.Max * p3)
					if p5 then
						p1.Color = ColorSequence.new(p5)
					end
					if not p4 then
						return
					end
					local v1 = p1:GetAttribute("EmitCount")
					p1:SetAttribute("EmitCount", (math.ceil(if type(v1) == "number" then v1 else p1.Rate)))
				end, table.unpack(v4:GetChildren()))
				Debris:AddItem(v1, v5)
				return v1, v5
			end
		}
	end
}