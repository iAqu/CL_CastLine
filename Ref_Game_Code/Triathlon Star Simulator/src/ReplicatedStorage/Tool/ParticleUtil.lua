-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:08
-- Luau version 6, Types version 3
-- Time taken: 0.004964 seconds

local module = {}
local InsMgr_upvr = require(game:GetService("ReplicatedStorage").Tool.InsMgr)
function module.InitParticleAll(arg1, arg2) -- Line 9
	if not arg2 then
		local var7 = 1
	end
	if not arg1 then
	else
		for _, v_3 in pairs(arg1.Size.Keypoints) do
			table.insert({}, NumberSequenceKeypoint.new(v_3.Time, v_3.Value * var7, v_3.Envelope * var7))
			local var12
		end
		if next(var12) then
			arg1.Size = NumberSequence.new(var12)
		end
		arg1.Drag *= var7
		arg1.VelocityInheritance *= var7
		arg1.Speed = NumberRange.new(arg1.Speed.Min * var7, arg1.Speed.Max * var7)
		arg1.Acceleration *= var7
	end
end
function module.ReSizeParticle(arg1, arg2) -- Line 56
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg2 then
		local const_number = 1
	end
	if not arg1 then return end
	for _, v in pairs(arg1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local tbl_2 = {}
			for i_2, v_2 in pairs(v.Size.Keypoints) do
				local SOME = v:FindFirstChild("Time"..i_2)
				if not SOME then
					SOME = InsMgr_upvr.GetIns("Time"..i_2, "NumberValue", v)
					SOME.Value = v_2.Time
				end
				local SOME_5 = v:FindFirstChild("Value"..i_2)
				if not SOME_5 then
					SOME_5 = InsMgr_upvr.GetIns("Value"..i_2, "NumberValue", v)
					SOME_5.Value = v_2.Value
				end
				local SOME_6 = v:FindFirstChild("Envelope"..i_2)
				if not SOME_6 then
					SOME_6 = InsMgr_upvr.GetIns("Envelope"..i_2, "NumberValue", v)
					SOME_6.Value = v_2.Envelope
				end
				table.insert(tbl_2, NumberSequenceKeypoint.new(SOME.Value, SOME_5.Value * const_number, SOME_6.Value * const_number))
			end
			if next(tbl_2) then
				v.Size = NumberSequence.new(tbl_2)
			end
		end
	end
	return arg1
end
function module.ReSizeParticleAll(arg1, arg2) -- Line 113
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg2 then
		local var36 = 1
	end
	if not arg1 then
	else
		local tbl = {}
		for i_4, v_4 in pairs(arg1.Size.Keypoints) do
			local SOME_4 = arg1:FindFirstChild("Time"..i_4)
			if not SOME_4 then
				SOME_4 = InsMgr_upvr.GetIns("Time"..i_4, "NumberValue", arg1)
				SOME_4.Value = v_4.Time
			end
			local SOME_2 = arg1:FindFirstChild("Value"..i_4)
			if not SOME_2 then
				SOME_2 = InsMgr_upvr.GetIns("Value"..i_4, "NumberValue", arg1)
				SOME_2.Value = v_4.Value
			end
			local SOME_3 = arg1:FindFirstChild("Envelope"..i_4)
			if not SOME_3 then
				SOME_3 = InsMgr_upvr.GetIns("Envelope"..i_4, "NumberValue", arg1)
				SOME_3.Value = v_4.Envelope
			end
			table.insert(tbl, NumberSequenceKeypoint.new(SOME_4.Value, SOME_2.Value * var36, SOME_3.Value * var36))
		end
		if next(tbl) then
			arg1.Size = NumberSequence.new(tbl)
		end
		local OriDrag = arg1:FindFirstChild("OriDrag")
		if not OriDrag then
			i_4 = "NumberValue"
			v_4 = arg1
			OriDrag = InsMgr_upvr.GetIns("OriDrag", i_4, v_4)
			OriDrag.Value = arg1.Drag
		end
		if OriDrag then
			arg1.Drag = OriDrag.Value * var36
		end
		local OriVelocityInheritance = arg1:FindFirstChild("OriVelocityInheritance")
		if not OriVelocityInheritance then
			OriVelocityInheritance = InsMgr_upvr.GetIns("OriVelocityInheritance", "NumberValue", arg1)
			OriVelocityInheritance.Value = arg1.VelocityInheritance
		end
		if OriVelocityInheritance then
			arg1.VelocityInheritance = OriVelocityInheritance.Value * var36
		end
		local OriSpeed = arg1:FindFirstChild("OriSpeed")
		if not OriSpeed then
			OriSpeed = InsMgr_upvr.GetIns("OriSpeed", "Vector3Value", arg1)
			OriSpeed.Value = Vector3.new(arg1.Speed.Max, arg1.Speed.Min)
		end
		if OriSpeed then
			arg1.Speed = NumberRange.new(OriSpeed.Value.Y * var36, OriSpeed.Value.X * var36)
		end
		local OriAcceleration = arg1:FindFirstChild("OriAcceleration")
		if not OriAcceleration then
			OriAcceleration = InsMgr_upvr.GetIns("OriAcceleration", "Vector3Value", arg1)
			OriAcceleration.Value = arg1.Acceleration
		end
		if OriAcceleration then
			arg1.Acceleration = OriAcceleration.Value * var36
		end
	end
end
return module