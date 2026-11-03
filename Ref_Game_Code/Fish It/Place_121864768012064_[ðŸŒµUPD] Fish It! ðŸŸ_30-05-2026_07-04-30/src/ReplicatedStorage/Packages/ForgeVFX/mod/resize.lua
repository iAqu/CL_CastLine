-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require("./utility")
local t = {
	apply = function(p1, p2) --[[ apply | Line: 5 | Upvalues: v1 (copy) ]]
		if p1:IsA("ParticleEmitter") then
			p1.Size = v1.scaleNumberSequence(p1.Size, p2)
			p1.Speed = NumberRange.new(p1.Speed.Min * p2, p1.Speed.Max * p2)
			p1.Acceleration = p1.Acceleration * p2
			return
		end
		if p1:IsA("Beam") then
			v1.scaleAttribute(p1, p2, "Width0_Start")
			v1.scaleAttribute(p1, p2, "Width1_Start")
			v1.scaleAttribute(p1, p2, "Width0_End")
			v1.scaleAttribute(p1, p2, "Width1_End")
			v1.scaleAttribute(p1, p2, "CurveSize0_Start")
			v1.scaleAttribute(p1, p2, "CurveSize1_Start")
			v1.scaleAttribute(p1, p2, "CurveSize0_End")
			v1.scaleAttribute(p1, p2, "CurveSize1_End")
			v1.scaleAttribute(p1, p2, "Length_Scale_Start")
			v1.scaleAttribute(p1, p2, "Length_Scale_End")
			p1.Width0 = p1.Width0 * p2
			p1.Width1 = p1.Width1 * p2
			p1.CurveSize0 = p1.CurveSize0 * p2
			p1.CurveSize1 = p1.CurveSize1 * p2
			v1.scaleAttachmentDistance(p1.Attachment0, p1.Attachment1, p2)
			return
		end
		if p1:IsA("Trail") then
			v1.scaleAttachmentDistance(p1.Attachment0, p1.Attachment1, p2)
			return
		end
		if p1:IsA("Sound") then
			p1.RollOffMinDistance = p1.RollOffMinDistance * p2
			p1.RollOffMaxDistance = p1.RollOffMaxDistance * p2
			v1.scaleAttribute(p1, p2, "RollOff_Start")
			v1.scaleAttribute(p1, p2, "RollOff_End")
			return
		end
		if p1:IsA("Model") then
			if not v1.isMeshVFX(p1) then
				v1.scaleAttribute(p1, p2, "Scale_Start")
				v1.scaleAttribute(p1, p2, "Scale_End")
				return
			end
			local Start = p1:FindFirstChild("Start")
			local End = p1:FindFirstChild("End")
			if not (Start and End) then
				return
			end
			Start.Size = Start.Size * p2
			End.Size = End.Size * p2
			local SpecialMesh = Start:FindFirstChildOfClass("SpecialMesh")
			local SpecialMesh_2 = End:FindFirstChildOfClass("SpecialMesh")
			if SpecialMesh and SpecialMesh_2 then
				SpecialMesh.Scale = SpecialMesh.Scale * p2
				SpecialMesh_2.Scale = SpecialMesh_2.Scale * p2
			end
		else
			if p1:IsA("Attachment") and p1:HasTag(v1.LIGHTNING_TAG) then
				v1.scaleAttribute(p1, p2, "OffsetScale")
				v1.scaleAttribute(p1, p2, "Width_Start")
				v1.scaleAttribute(p1, p2, "Width_End")
				return
			end
			if p1:IsA("BasePart") and (p1.Parent and v1.findFirstClassWithTag(p1.Parent, "Attachment", v1.SHOCKWAVE_TAG)) then
				v1.scaleAttribute(p1, p2, "Radius")
				v1.scaleAttribute(p1, p2, "Length")
				v1.scaleAttribute(p1, p2, "MinSize")
				v1.scaleAttribute(p1, p2, "MaxSize")
				if p1:GetAttribute("LinearMagnitude") then
					p1.Size = p1.Size * p2
					v1.scaleAttribute(p1, p2, "LinearMagnitude")
					v1.scaleAttribute(p1, p2, "AngularMagnitude")
				end
			else
				if not (p1:IsA("RayValue") and p1:HasTag(v1.SCREENSHAKE_TAG)) then
					return
				end
				v1.scaleAttribute(p1, p2, "Falloff")
			end
		end
	end
}
function t.batch(p1, ...) --[[ batch | Line: 85 | Upvalues: t (copy) ]]
	for v1, v2 in { ... } do
		t.apply(v2, p1)
		for v3, v4 in v2:GetDescendants() do
			t.apply(v4, p1)
		end
	end
end
return t