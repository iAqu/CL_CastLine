-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("./utility")
local t = {
	apply = function(p1, p2, p3) --[[ apply | Line: 5 | Upvalues: v1 (copy) ]]
		if p1:IsA("ParticleEmitter") then
			v1.scaleAttribute(p1, p3, "EmitDelay")
			v1.scaleAttribute(p1, p3, "EmitDuration")
			v1.scaleAttribute(p1, p3, "TimeScale_Duration")
			p1.Speed = NumberRange.new(p1.Speed.Min * p2, p1.Speed.Max * p2)
			p1.RotSpeed = NumberRange.new(p1.RotSpeed.Min * p2, p1.RotSpeed.Max * p2)
			p1.Lifetime = NumberRange.new(p1.Lifetime.Min / p2, p1.Lifetime.Max / p2)
			p1.Acceleration = p1.Acceleration * p2 ^ 2
			p1.Drag = p1.Drag * p2
			p1.Rate = p1.Rate * p2
			return
		end
		if p1:IsA("Beam") then
			v1.scaleAttribute(p1, p3, "EmitDelay")
			v1.scaleAttribute(p1, p3, "EmitDuration")
			v1.scaleAttribute(p1, p3, "EffectDuration")
			v1.scaleAttribute(p1, p3, "Speed_Duration")
			v1.scaleAttribute(p1, p3, "Duration")
			p1.TextureSpeed = p1.TextureSpeed * p2
			return
		end
		if p1:IsA("Trail") then
			p1.Lifetime = p1.Lifetime * p3
			return
		end
		if p1:IsA("Sound") then
			v1.scaleAttribute(p1, p3, "EmitDelay")
			v1.scaleAttribute(p1, p3, "EmitDuration")
			v1.scaleAttribute(p1, p3, "EmitInterval")
			v1.scaleAttribute(p1, p3, "RepeatInterval")
			v1.scaleAttribute(p1, p3, "FadeOutTime")
			v1.scaleAttribute(p1, p3, "Volume_Duration")
			v1.scaleAttribute(p1, p3, "Speed_Duration")
			v1.scaleAttribute(p1, p3, "RollOff_Duration")
			return
		end
		if p1:IsA("Model") then
			if v1.isMeshVFX(p1) then
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "DestroyDelay")
				v1.scaleAttribute(p1, p3, "EmitDuration")
				v1.scaleAttribute(p1, p3, "EffectDuration")
				v1.scaleAttribute(p1, p3, "Speed_Duration")
				v1.scaleAttribute(p1, p3, "Duration")
				v1.scaleAttribute(p1, p2, "Rate")
				v1.scaleAttribute(p1, p2, "Part_RotSpeed_Start")
				v1.scaleAttribute(p1, p2, "Part_RotSpeed_End")
			else
				v1.scaleAttribute(p1, p2, "SpinRotation")
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "ResetDelay")
				v1.scaleAttribute(p1, p3, "SpinDuration")
				v1.scaleAttribute(p1, p3, "Scale_Duration")
				v1.scaleAttribute(p1, p3, "SpinSpeed_Duration")
			end
		else
			if p1:IsA("Attachment") and p1:HasTag(v1.BEZIER_TAG) then
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "DestroyDelay")
				v1.scaleAttribute(p1, p3, "EmitDuration")
				v1.scaleAttribute(p1, p3, "Duration")
				v1.scaleAttribute(p1, p3, "Speed_Duration")
				v1.scaleAttribute(p1, p2, "ProjectileSpeed")
				v1.scaleAttribute(p1, p3, "ProjectileLifetime")
				v1.scaleAttribute(p1, p2, "Rate")
				v1.scaleAttribute(p1, p2, "Part_RotSpeed_Start")
				v1.scaleAttribute(p1, p2, "Part_RotSpeed_End")
				return
			end
			if p1:IsA("Attachment") and p1:HasTag(v1.LIGHTNING_TAG) then
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "DestroyDelay")
				v1.scaleAttribute(p1, p3, "EmitDuration")
				v1.scaleAttribute(p1, p3, "Duration")
				v1.scaleAttribute(p1, p3, "Speed_Duration")
				v1.scaleAttribute(p1, p3, "Color_Duration")
				v1.scaleAttribute(p1, p3, "Fill_Color_Duration")
				v1.scaleAttribute(p1, p3, "Fade_In_Duration")
				v1.scaleAttribute(p1, p3, "Fade_Out_Duration")
				v1.scaleAttribute(p1, p3, "Dissipate_Duration")
				v1.scaleAttribute(p1, p2, "ProjectileSpeed")
				v1.scaleAttribute(p1, p3, "ProjectileLifetime")
				v1.scaleAttribute(p1, p2, "Rate")
				v1.scaleAttribute(p1, p2, "RefreshRate")
				return
			end
			if p1:IsA("BasePart") and (p1.Parent and v1.findFirstClassWithTag(p1.Parent, "Attachment", v1.SHOCKWAVE_TAG)) then
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "Size_Duration")
				v1.scaleAttribute(p1, p3, "Transparency_Duration")
				v1.scaleAttribute(p1, p3, "Lifetime")
				v1.scaleAttribute(p1, p3, "Duration")
				v1.scaleAttribute(p1, p2, "Rate_Start")
				v1.scaleAttribute(p1, p2, "Rate_End")
				return
			end
			if p1:IsA("RayValue") and p1:HasTag(v1.SCREENSHAKE_TAG) then
				v1.scaleAttribute(p1, p3, "EmitDelay")
				v1.scaleAttribute(p1, p3, "EmitDuration")
				v1.scaleAttribute(p1, p3, "Scale_Duration")
				return
			end
			if not p1:IsA("RayValue") then
				return
			end
			v1.scaleAttribute(p1, p3, "Duration")
			v1.scaleAttribute(p1, p3, "Speed_Duration")
			v1.scaleAttribute(p1, p3, "EmitDelay")
		end
	end
}
function t.batch(p1, ...) --[[ batch | Line: 112 | Upvalues: t (copy) ]]
	local v1 = 1 / p1
	for v2, v3 in { ... } do
		t.apply(v3, p1, v1)
		for v4, v5 in v3:GetDescendants() do
			t.apply(v5, p1, v1)
		end
	end
end
return t