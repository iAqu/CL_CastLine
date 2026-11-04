-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:41
-- Luau version 6, Types version 3
-- Time taken: 0.025492 seconds

local module_upvr = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local TweenService_upvr = game:GetService("TweenService")
local RunService_upvr = game:GetService("RunService")
local Debris_2_upvr = game:GetService("Debris")
local ObjectPoolUtil_upvr = require(ReplicatedStorage_upvr.Tool.ObjectPoolUtil)
function module_upvr.Slow_Destroy_Instance(arg1, arg2) -- Line 16
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: Debris_2_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	module_upvr.Stop_All_Emit(arg1)
	local descendants_3 = arg1:GetDescendants()
	table.insert(descendants_3, arg1)
	local var32 = arg2 or 0.25
	if not arg2 then
		for _, v in pairs(descendants_3) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
				var32 = math.max(var32, v.Lifetime.Max)
			elseif v:IsA("Trail") then
				v.Enabled = false
				var32 = math.max(var32, v.Lifetime)
			end
		end
	end
	for i_2, v_2 in pairs(descendants_3) do
		if v_2:IsA("Light") then
			TweenService_upvr:Create(v_2, TweenInfo.new(var32), {
				Brightness = 0;
			}):Play()
		elseif v_2:IsA("Sound") then
			TweenService_upvr:Create(v_2, TweenInfo.new(var32), {
				Volume = 0;
			}):Play()
		elseif v_2:IsA("Beam") then
			TweenService_upvr:Create(v_2, TweenInfo.new(var32), {
				Width0 = 0;
				Width1 = 0;
			}):Play()
		elseif v_2:IsA("ImageLabel") then
			TweenService_upvr:Create(v_2, TweenInfo.new(var32), {
				ImageTransparency = 1;
			}):Play()
		elseif v_2:IsA("Decal") then
			TweenService_upvr:Create(v_2, TweenInfo.new(var32), {
				Transparency = 1;
			}):Play()
		elseif v_2:IsA("ParticleEmitter") then
			v_2.Enabled = false
		elseif v_2:IsA("Trail") then
			v_2.Enabled = false
			for _, v_14 in pairs(v_2.Transparency.Keypoints) do
				table.insert({}, NumberSequenceKeypoint.new(v_14.Time, 1, 0))
				local var48
			end
			module_upvr.Beam_Object_Fade(v_2, var32, NumberSequence.new(var48), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		end
	end
	if arg1:IsA("BasePart") then
		i_2 = TweenInfo.new
		v_2 = var32
		i_2 = i_2(v_2)
		v_2 = {}
		v_2.Transparency = 1
		TweenService_upvr:Create(arg1, i_2, v_2):Play()
	end
	Debris_2_upvr:AddItem(arg1, var32 + 0.5)
end
function module_upvr.Slow_Disapear_Instance(arg1, arg2) -- Line 100
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	module_upvr.Stop_All_Emit(arg1)
	local descendants = arg1:GetDescendants()
	table.insert(descendants, arg1)
	local var74 = arg2 or 0.25
	if not arg2 then
		for _, v_3 in pairs(descendants) do
			if v_3:IsA("ParticleEmitter") then
				v_3.Enabled = false
				var74 = math.max(var74, v_3.Lifetime.Max)
			elseif v_3:IsA("Trail") then
				v_3.Enabled = false
				var74 = math.max(var74, v_3.Lifetime)
			end
		end
	end
	for i_4, v_4 in pairs(descendants) do
		if v_4:IsA("Light") then
			TweenService_upvr:Create(v_4, TweenInfo.new(var74), {
				Brightness = 0;
			}):Play()
		elseif v_4:IsA("Sound") then
			TweenService_upvr:Create(v_4, TweenInfo.new(var74), {
				Volume = 0;
			}):Play()
		elseif v_4:IsA("Beam") then
			TweenService_upvr:Create(v_4, TweenInfo.new(var74), {
				Width0 = 0;
				Width1 = 0;
			}):Play()
		elseif v_4:IsA("ImageLabel") then
			TweenService_upvr:Create(v_4, TweenInfo.new(var74), {
				ImageTransparency = 1;
			}):Play()
		elseif v_4:IsA("Decal") then
			TweenService_upvr:Create(v_4, TweenInfo.new(var74), {
				Transparency = 1;
			}):Play()
		elseif v_4:IsA("ParticleEmitter") then
			v_4.Enabled = false
		elseif v_4:IsA("Trail") then
			for _, v_15 in pairs(v_4.Transparency.Keypoints) do
				table.insert({}, NumberSequenceKeypoint.new(v_15.Time, 1, 0))
				local var90
			end
			module_upvr.Beam_Object_Fade(v_4, var74, NumberSequence.new(var90), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		end
	end
	if arg1:IsA("BasePart") then
		i_4 = TweenInfo.new
		v_4 = var74
		i_4 = i_4(v_4)
		v_4 = {}
		v_4.Transparency = 1
		TweenService_upvr:Create(arg1, i_4, v_4):Play()
	end
end
function module_upvr.GetInstance_From_Pool(arg1) -- Line 182
	--[[ Upvalues[1]:
		[1]: ObjectPoolUtil_upvr (readonly)
	]]
	return ObjectPoolUtil_upvr.Get_Object_From_Pool(arg1)
end
function module_upvr.BackPool_Instance(arg1) -- Line 189
	--[[ Upvalues[1]:
		[1]: ObjectPoolUtil_upvr (readonly)
	]]
	ObjectPoolUtil_upvr.Back_Object_To_Pool(arg1)
end
function module_upvr.Number_Filtrate(arg1, arg2) -- Line 197
	if arg1 % arg2 == 0 then
		return true, arg1 + 1
	end
	return false, arg1 + 1
end
function module_upvr.Scale_Particle(arg1, arg2) -- Line 207
	local var99
	if math.abs(arg2 - 1) < 0.01 then
	else
		if type(var99) ~= "table" then
			var99 = {var99}
		end
		for _, v_16 in pairs(var99) do
			local tbl_3 = {}
			for _, v_17 in pairs(v_16.Size.Keypoints) do
				table.insert(tbl_3, NumberSequenceKeypoint.new(v_17.Time, v_17.Value * arg2, v_17.Envelope * arg2))
			end
			v_16.Size = NumberSequence.new(tbl_3)
			v_16.Drag *= arg2
			v_16.VelocityInheritance *= arg2
			v_16.Speed = NumberRange.new(v_16.Speed.Min * arg2, v_16.Speed.Max * arg2)
			v_16.Acceleration = Vector3.new(v_16.Acceleration.X * arg2, v_16.Acceleration.Y * arg2, v_16.Acceleration.Z * arg2)
		end
	end
end
function module_upvr.Scale_Particle_Size(arg1, arg2) -- Line 231
	local var116
	if math.abs(arg2 - 1) < 0.01 then
	else
		if type(var116) ~= "table" then
			var116 = {var116}
		end
		for _, v_18 in pairs(var116) do
			local tbl_4 = {}
			for _, v_19 in pairs(v_18.Size.Keypoints) do
				table.insert(tbl_4, NumberSequenceKeypoint.new(v_19.Time, v_19.Value * arg2, v_19.Envelope * arg2))
			end
			v_18.Size = NumberSequence.new(tbl_4)
		end
	end
end
function module_upvr.Emit_Particles_Children(arg1, arg2) -- Line 250
	if arg1:IsA("ParticleEmitter") then
		if arg2 then
			arg1.Enabled = false
		end
		task.spawn(function() -- Line 257
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1:GetAttribute("EmitDelay") then
				task.wait(arg1:GetAttribute("EmitDelay"))
				arg1:Emit(arg1:GetAttribute("EmitCount"))
			else
				arg1:Emit(arg1:GetAttribute("EmitCount"))
			end
		end)
	end
	for _, v_5_upvr in pairs(arg1:GetChildren()) do
		if v_5_upvr:IsA("ParticleEmitter") then
			if arg2 then
				v_5_upvr.Enabled = false
			end
			task.spawn(function() -- Line 274
				--[[ Upvalues[1]:
					[1]: v_5_upvr (readonly)
				]]
				if v_5_upvr:GetAttribute("EmitDelay") then
					task.wait(v_5_upvr:GetAttribute("EmitDelay"))
					v_5_upvr:Emit(v_5_upvr:GetAttribute("EmitCount"))
				else
					v_5_upvr:Emit(v_5_upvr:GetAttribute("EmitCount"))
				end
			end)
		end
	end
end
function module_upvr.Emit_Particles_GetDescendants(arg1, arg2) -- Line 289
	if arg1:IsA("ParticleEmitter") then
		if arg2 then
			arg1.Enabled = false
		end
		task.spawn(function() -- Line 296
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			if arg1:GetAttribute("EmitDelay") then
				task.wait(arg1:GetAttribute("EmitDelay"))
				arg1:Emit(arg1:GetAttribute("EmitCount"))
			else
				arg1:Emit(arg1:GetAttribute("EmitCount"))
			end
		end)
	end
	for _, v_6_upvr in pairs(arg1:GetDescendants()) do
		if v_6_upvr:IsA("ParticleEmitter") then
			if arg2 then
				v_6_upvr.Enabled = false
			end
			task.spawn(function() -- Line 313
				--[[ Upvalues[1]:
					[1]: v_6_upvr (readonly)
				]]
				if v_6_upvr:GetAttribute("EmitDelay") then
					task.wait(v_6_upvr:GetAttribute("EmitDelay"))
					v_6_upvr:Emit(v_6_upvr:GetAttribute("EmitCount"))
				else
					v_6_upvr:Emit(v_6_upvr:GetAttribute("EmitCount"))
				end
			end)
		end
	end
end
function module_upvr.Stop_All_Particles(arg1) -- Line 328
	local descendants_2 = arg1:GetDescendants()
	table.insert(descendants_2, arg1)
	for _, v_7 in pairs(descendants_2) do
		if v_7:IsA("ParticleEmitter") then
			v_7.Enabled = false
		end
	end
end
function module_upvr.Start_All_Particles(arg1) -- Line 342
	local descendants_5 = arg1:GetDescendants()
	table.insert(descendants_5, arg1)
	for _, v_8 in pairs(descendants_5) do
		if v_8:IsA("ParticleEmitter") then
			v_8.Enabled = true
		end
	end
end
function module_upvr.Start_Emit(arg1, arg2) -- Line 356
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then
			local const_number = 100
		end
		arg1.Enabled = false
		if not arg1:FindFirstChild("AutoEmit") then
			local BoolValue_upvw = Instance.new("BoolValue", arg1)
			BoolValue_upvw.Name = "AutoEmit"
			BoolValue_upvw.Value = false
		end
		if BoolValue_upvw.Value == true then return end
		BoolValue_upvw.Value = true
		local var153_upvr = math.max(arg1.Rate, 1) * const_number
		local var155_upvw = 0
		local var156_upvw = 0
		local var157_upvw
		local var158_upvr = const_number / var153_upvr
		var157_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_2) -- Line 391
			--[[ Upvalues[7]:
				[1]: var155_upvw (read and write)
				[2]: var156_upvw (read and write)
				[3]: var153_upvr (readonly)
				[4]: arg1 (readonly)
				[5]: BoolValue_upvw (read and write)
				[6]: var157_upvw (read and write)
				[7]: var158_upvr (readonly)
			]]
			var155_upvw += arg1_2
			if var153_upvr <= var156_upvw or not arg1 or not BoolValue_upvw.Value then
				var157_upvw:Disconnect()
				var157_upvw = nil
			elseif var156_upvw * var158_upvr <= var155_upvw then
				local ceiled = math.ceil((var155_upvw - var156_upvw * var158_upvr) / var158_upvr)
				var156_upvw += ceiled
				arg1:Emit(ceiled)
			end
		end)
	end
end
function module_upvr.Stop_Emit(arg1) -- Line 417
	if not arg1 then
	else
		local AutoEmit = arg1:FindFirstChild("AutoEmit")
		if AutoEmit then
			AutoEmit.Value = false
		end
	end
end
function module_upvr.Start_All_Emit(arg1, arg2) -- Line 431
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		local descendants_9 = arg1:GetDescendants()
		table.insert(descendants_9, arg1)
		for _, v_20 in pairs(descendants_9) do
			if v_20:IsA("ParticleEmitter") then
				module_upvr.Start_Emit(v_20, arg2)
			end
		end
	end
end
function module_upvr.Stop_All_Emit(arg1) -- Line 450
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		local descendants_7 = arg1:GetDescendants()
		table.insert(descendants_7, arg1)
		for _, v_21 in pairs(descendants_7) do
			if v_21:IsA("ParticleEmitter") then
				module_upvr.Stop_Emit(v_21)
			end
		end
	end
end
function module_upvr.BasePart_Size_Tween(arg1, arg2, arg3, arg4, arg5) -- Line 470
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local tbl = {}
	tbl.Size = arg3
	local any_Create_result1_upvw = TweenService_upvr:Create(arg1, TweenInfo.new(arg2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), tbl)
	any_Create_result1_upvw.Completed:Connect(function() -- Line 479
		--[[ Upvalues[1]:
			[1]: any_Create_result1_upvw (read and write)
		]]
		any_Create_result1_upvw:Destroy()
		any_Create_result1_upvw = nil
	end)
	any_Create_result1_upvw:Play()
end
local InsMgr_upvr = require(ReplicatedStorage_upvr.Tool.InsMgr)
function module_upvr.Scale_Model(arg1, arg2) -- Line 486
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	if not arg2 then
		return arg1
	end
	for _, v_9 in pairs(arg1:GetDescendants()) do
		if v_9:IsA("BasePart") then
			local OriSize_2 = v_9:FindFirstChild("OriSize")
			if not OriSize_2 then
				OriSize_2 = InsMgr_upvr.GetIns("OriSize", "Vector3Value", v_9)
				OriSize_2.Value = v_9.Size
			end
			v_9.Size = OriSize_2.Value * arg2
		end
		if v_9:IsA("SpecialMesh") and v_9.MeshType == Enum.MeshType.FileMesh then
			local OriSize_3 = v_9:FindFirstChild("OriSize")
			if not OriSize_3 then
				OriSize_3 = InsMgr_upvr.GetIns("OriSize", "Vector3Value", v_9)
				OriSize_3.Value = v_9.Scale
			end
			v_9.Scale = OriSize_3.Value * arg2
		end
		if v_9:IsA("Motor6D") then
			local OriC1_2 = v_9:FindFirstChild("OriC1")
			if not OriC1_2 then
				OriC1_2 = InsMgr_upvr.GetIns("OriC1", "CFrameValue", v_9)
				OriC1_2.Value = v_9.C1
			end
			local OriC0 = v_9:FindFirstChild("OriC0")
			if not OriC0 then
				OriC0 = InsMgr_upvr.GetIns("OriC0", "CFrameValue", v_9)
				OriC0.Value = v_9.C0
			end
			v_9.C0 = OriC0.Value.Rotation + OriC0.Value.Position * arg2
			v_9.C1 = OriC1_2.Value.Rotation + OriC1_2.Value.Position * arg2
		end
		if v_9:IsA("Weld") then
			local OriC1 = v_9:FindFirstChild("OriC1")
			if not OriC1 then
				OriC1 = InsMgr_upvr.GetIns("OriC1", "CFrameValue", v_9)
				OriC1.Value = v_9.C1
			end
			local OriC0_2 = v_9:FindFirstChild("OriC0")
			if not OriC0_2 then
				OriC0_2 = InsMgr_upvr.GetIns("OriC0", "CFrameValue", v_9)
				OriC0_2.Value = v_9.C0
			end
			v_9.C0 = OriC0_2.Value.Rotation + OriC0_2.Value.Position * arg2
			v_9.C1 = OriC1.Value.Rotation + OriC1.Value.Position * arg2
		end
		if v_9:IsA("Attachment") then
			local OriPos_2 = v_9:FindFirstChild("OriPos")
			if not OriPos_2 then
				OriPos_2 = InsMgr_upvr.GetIns("OriPos", "Vector3Value", v_9)
				OriPos_2.Value = v_9.CFrame.Position
			end
			v_9.Position = OriPos_2.Value * arg2
		end
		if not v_9:IsA("WeldConstraint") then
		end
	end
	arg1:SetAttribute("Scale", arg2)
	return arg1
end
function module_upvr.Scale_Model_Tween(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 605
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	task.spawn(function() -- Line 607
		--[[ Upvalues[9]:
			[1]: arg1 (readonly)
			[2]: RunService_upvr (copied, readonly)
			[3]: arg2 (readonly)
			[4]: TweenService_upvr (copied, readonly)
			[5]: arg4 (readonly)
			[6]: arg5 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: arg3 (readonly)
			[9]: arg6 (readonly)
		]]
		local var192
		if arg1:IsA("Model") then
			var192 = arg1:GetPivot()
		end
		if not arg1:GetAttribute("Scale") then
			arg1:SetAttribute("Scale", 1)
		end
		local Scale_2 = arg1:GetAttribute("Scale")
		local const_number_4 = 0
		while const_number_4 < 1 do
			module_upvr.Scale_Model(arg1, TweenService_upvr:GetValue(math.min(const_number_4 + RunService_upvr.Heartbeat:Wait() / arg2, 1), arg4, arg5) * (arg3 - Scale_2) + Scale_2)
			if not arg6 then
				arg1:PivotTo(var192)
			end
		end
	end)
end
function module_upvr.Set_Scale_Model(arg1, arg2) -- Line 639
	if arg1:IsA("Model") then
		local ModelScale = arg1:GetAttribute("ModelScale")
		if not ModelScale then
			arg1:SetAttribute("ModelScale", arg1:GetScale())
			ModelScale = arg1:GetScale()
		end
		arg1:SetAttribute("Scale", arg2)
		arg1:ScaleTo(ModelScale * arg2)
	end
end
function module_upvr.Set_Scale_Model_Tween(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 656
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	task.spawn(function() -- Line 658
		--[[ Upvalues[9]:
			[1]: arg4 (read and write)
			[2]: arg5 (read and write)
			[3]: arg1 (readonly)
			[4]: RunService_upvr (copied, readonly)
			[5]: arg2 (readonly)
			[6]: TweenService_upvr (copied, readonly)
			[7]: module_upvr (copied, readonly)
			[8]: arg3 (readonly)
			[9]: arg6 (readonly)
		]]
		if not arg4 then
			arg4 = Enum.EasingStyle.Linear
		end
		if not arg5 then
			arg5 = Enum.EasingDirection.In
		end
		if arg1:IsA("Model") then
		end
		if not arg1:GetAttribute("ModelScale") then
			arg1:SetAttribute("ModelScale", arg1:GetScale())
		end
		if not arg1:GetAttribute("Scale") then
			arg1:SetAttribute("Scale", 1)
		end
		local Scale_3 = arg1:GetAttribute("Scale")
		local const_number_3 = 0
		while const_number_3 < 1 do
			module_upvr.Set_Scale_Model(arg1, Scale_3 + (arg3 - Scale_3) * TweenService_upvr:GetValue(math.min(const_number_3 + RunService_upvr.Heartbeat:Wait() / arg2, 1), arg4, arg5))
			if not arg6 then
				arg1:PivotTo(arg1:GetPivot())
			end
		end
	end)
end
function module_upvr.Set_Scale_Basepart(arg1, arg2, arg3) -- Line 709
	if arg1:IsA("BasePart") then
		local OriSize = arg1:GetAttribute("OriSize")
		if not OriSize then
			arg1:SetAttribute("OriSize", arg1.Size)
			OriSize = arg1.Size
		end
		arg1:SetAttribute("Scale", arg2)
		arg1.Size = OriSize * arg2
		if arg3 then
			for _, v_10 in pairs(arg1:GetChildren()) do
				if v_10:IsA("Attachment") then
					local OriPos = v_10:GetAttribute("OriPos")
					if not OriPos then
						v_10:SetAttribute("OriPos", v_10.CFrame.Position)
						OriPos = v_10.CFrame.Position
					end
					v_10.CFrame = v_10.CFrame.Rotation + OriPos * arg2
				end
			end
		end
	end
end
function module_upvr.Set_Scale_Basepart_Tween(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 746
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	task.spawn(function() -- Line 748
		--[[ Upvalues[10]:
			[1]: arg1 (readonly)
			[2]: RunService_upvr (copied, readonly)
			[3]: arg2 (readonly)
			[4]: TweenService_upvr (copied, readonly)
			[5]: arg4 (readonly)
			[6]: arg5 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: arg3 (readonly)
			[9]: arg7 (readonly)
			[10]: arg6 (readonly)
		]]
		if not arg1:GetAttribute("OriSize") then
			arg1:SetAttribute("OriSize", arg1.Size)
		end
		if not arg1:GetAttribute("Scale") then
			arg1:SetAttribute("Scale", 1)
		end
		local Scale = arg1:GetAttribute("Scale")
		local const_number_2 = 0
		while const_number_2 < 1 do
			module_upvr.Set_Scale_Basepart(arg1, TweenService_upvr:GetValue(math.min(const_number_2 + RunService_upvr.Heartbeat:Wait() / arg2, 1), arg4, arg5) * (arg3 - Scale) + Scale, arg7)
			if not arg6 then
				arg1:PivotTo(arg1:GetPivot())
			end
		end
	end)
end
function module_upvr.Model_Transparency_Tween(arg1, arg2, arg3, arg4, arg5) -- Line 780
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then
		end
		if not arg4 then
		end
		if not arg5 then
		end
		local descendants_6 = arg1:GetDescendants()
		table.insert(descendants_6, arg1)
		for _, v_22 in pairs(descendants_6) do
			if v_22:IsA("BasePart") then
				local tbl_2 = {}
				tbl_2.Transparency = arg3
				TweenService_upvr:Create(v_22, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), tbl_2):Play()
			end
		end
	end
end
function module_upvr.Set_CFrame_Model_Tween(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 812
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	task.spawn(function() -- Line 814
		--[[ Upvalues[8]:
			[1]: arg1 (readonly)
			[2]: RunService_upvr (copied, readonly)
			[3]: arg2 (readonly)
			[4]: TweenService_upvr (copied, readonly)
			[5]: arg4 (readonly)
			[6]: arg5 (readonly)
			[7]: arg3 (readonly)
			[8]: arg6 (readonly)
		]]
		local any_GetPivot_result1 = arg1:GetPivot()
		local const_number_5 = 0
		while const_number_5 < 1 do
			arg1:PivotTo(any_GetPivot_result1:Lerp(arg3, math.min(const_number_5 + RunService_upvr.Heartbeat:Wait() / arg2, 1)))
			if not arg6 then
				arg1:PivotTo(any_GetPivot_result1)
			end
		end
	end)
end
function module_upvr.Weld(arg1, arg2) -- Line 837
	if not arg1 or not arg2 then
	else
		local WeldConstraint = Instance.new("WeldConstraint", arg2)
		WeldConstraint.Part0 = arg2
		WeldConstraint.Part1 = arg1
	end
end
function module_upvr.Unweld(arg1) -- Line 849
	--[[ Upvalues[1]:
		[1]: Debris_2_upvr (readonly)
	]]
	if not arg1 then
	else
		local class_WeldConstraint = arg1:FindFirstChildOfClass("WeldConstraint")
		if class_WeldConstraint then
			class_WeldConstraint.Enabled = false
			Debris_2_upvr:AddItem(class_WeldConstraint, 0)
		end
	end
end
function module_upvr.Control_Heartbeat(arg1, arg2) -- Line 864
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg2 then
	else
		local var230_upvw = 0
		local var231_upvw
		var231_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_3) -- Line 872
			--[[ Upvalues[4]:
				[1]: arg2 (readonly)
				[2]: var230_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: var231_upvw (read and write)
			]]
			if arg1 < var230_upvw or not arg2(var230_upvw) then
				var231_upvw:Disconnect()
				var231_upvw = nil
			else
				var230_upvw += arg1_3
			end
		end)
	end
end
function module_upvr.Control_Model_CFrame(arg1, arg2) -- Line 888
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then return end
		if not arg1:FindFirstChild("ModelControl") then
			local BoolValue_2 = Instance.new("BoolValue", arg1)
			BoolValue_2.Name = "ModelControl"
			BoolValue_2.Value = false
		end
		if BoolValue_2.Value then return end
		BoolValue_2.Value = true
		local var234_upvw = 0
		local var235_upvw
		var235_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_4) -- Line 913
			--[[ Upvalues[4]:
				[1]: arg2 (readonly)
				[2]: var234_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: var235_upvw (read and write)
			]]
			local arg2_result1_2 = arg2(var234_upvw)
			local ModelControl_4 = arg1:FindFirstChild("ModelControl")
			if not arg1 or not arg2_result1_2 or not ModelControl_4 or not ModelControl_4.Value then
				var235_upvw:Disconnect()
				var235_upvw = nil
				if ModelControl_4 then
					ModelControl_4.Value = false
				end
			else
				arg1:PivotTo(arg2_result1_2)
				var234_upvw += arg1_4
			end
		end)
	end
end
function module_upvr.Uncontrol_Model_CFrame(arg1) -- Line 935
	if not arg1 then
	else
		local ModelControl_3 = arg1:FindFirstChild("ModelControl")
		if ModelControl_3 then
			ModelControl_3.Value = false
		end
	end
end
function module_upvr.Control_Model_CFrame_Standby(arg1, arg2) -- Line 948
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then return end
		if not arg1:FindFirstChild("ModelControl_Standby") then
			local BoolValue = Instance.new("BoolValue", arg1)
			BoolValue.Name = "ModelControl_Standby"
			BoolValue.Value = false
		end
		if BoolValue.Value then return end
		BoolValue.Value = true
		local var241_upvw = 0
		local var242_upvw
		var242_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_5) -- Line 973
			--[[ Upvalues[4]:
				[1]: arg2 (readonly)
				[2]: var241_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: var242_upvw (read and write)
			]]
			local arg2_result1_3 = arg2(var241_upvw)
			local ModelControl_Standby_2 = arg1:FindFirstChild("ModelControl_Standby")
			if not arg1 or not arg2_result1_3 or not ModelControl_Standby_2 or not ModelControl_Standby_2.Value then
				var242_upvw:Disconnect()
				var242_upvw = nil
				if ModelControl_Standby_2 then
					ModelControl_Standby_2.Value = false
				end
			else
				arg1:PivotTo(arg2_result1_3)
				var241_upvw += arg1_5
			end
		end)
	end
end
function module_upvr.Uncontrol_Model_CFrame_Standby(arg1) -- Line 995
	if not arg1 then
	else
		local ModelControl_Standby = arg1:FindFirstChild("ModelControl_Standby")
		if ModelControl_Standby then
			ModelControl_Standby.Value = false
		end
	end
end
function module_upvr.Control_Attachment_CFrame(arg1, arg2) -- Line 1008
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then return end
		if not arg1:FindFirstChild("ModelControl") then
			local BoolValue_3 = Instance.new("BoolValue", arg1)
			BoolValue_3.Name = "ModelControl"
			BoolValue_3.Value = false
		end
		if BoolValue_3.Value then return end
		BoolValue_3.Value = true
		local var248_upvw = 0
		local var249_upvw
		var249_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_6) -- Line 1033
			--[[ Upvalues[4]:
				[1]: arg2 (readonly)
				[2]: var248_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: var249_upvw (read and write)
			]]
			local arg2_result1 = arg2(var248_upvw)
			local ModelControl_2 = arg1:FindFirstChild("ModelControl")
			if not arg1 or not arg2_result1 or not ModelControl_2 or not ModelControl_2.Value then
				var249_upvw:Disconnect()
				var249_upvw = nil
				if ModelControl_2 then
					ModelControl_2.Value = false
				end
			else
				arg1.WorldCFrame = arg2_result1
				var248_upvw += arg1_6
			end
		end)
	end
end
function module_upvr.Uncontrol_Attachment_CFrame(arg1) -- Line 1055
	if not arg1 then
	else
		local ModelControl = arg1:FindFirstChild("ModelControl")
		if ModelControl then
			ModelControl.Value = false
		end
	end
end
function module_upvr.Model_Fade(arg1, arg2) -- Line 1068
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg2 then
	end
	local descendants_4 = arg1:GetDescendants()
	table.insert(descendants_4, arg1)
	for _, v_11 in pairs(descendants_4) do
		if v_11:IsA("BasePart") then
			TweenService_upvr:Create(v_11, TweenInfo.new(0.1), {
				Transparency = 1;
			}):Play()
		end
	end
end
function module_upvr.Model_Fade_In(arg1, arg2, arg3, arg4, arg5) -- Line 1086
	--[[ Upvalues[1]:
		[1]: TweenService_upvr (readonly)
	]]
	if not arg2 then
	end
	if not arg3 then
	end
	if not arg4 then
	end
	local descendants_8 = arg1:GetDescendants()
	table.insert(descendants_8, arg1)
	for _, v_12 in pairs(descendants_8) do
		if v_12:IsA("BasePart") then
			TweenService_upvr:Create(v_12, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
				Transparency = arg5 or 0;
			}):Play()
		end
	end
end
function module_upvr.Beam_Object_Fade(arg1, arg2, arg3, arg4, arg5) -- Line 1114
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	task.spawn(function() -- Line 1116
		--[[ Upvalues[7]:
			[1]: arg2 (read and write)
			[2]: arg1 (readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: TweenService_upvr (copied, readonly)
			[5]: arg4 (readonly)
			[6]: arg5 (readonly)
			[7]: arg3 (readonly)
		]]
		if not arg2 then
			arg2 = 0.1
		end
		local Keypoints = arg1.Transparency.Keypoints
		local const_number_6 = 0
		while const_number_6 < 1 do
			for i_13, v_13 in pairs(arg3.Keypoints) do
				if Keypoints[i_13] then
					local Value = Keypoints[i_13].Value
					table.insert({}, NumberSequenceKeypoint.new(v_13.Time, Value + (v_13.Value - Value) * math.min(const_number_6 + RunService_upvr.Heartbeat:Wait() / arg2, 1), v_13.Envelope))
				end
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			arg1.Transparency = NumberSequence.new({})
		end
	end)
end
local VisibleMgr_upvr = require(ReplicatedStorage_upvr.Tool.VisibleMgr)
function module_upvr.Settle_Skill_Effect(arg1, arg2) -- Line 1152
	--[[ Upvalues[3]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		local clone_upvr = ReplicatedStorage_upvr.ModelRes.Effect["受击效果"]:Clone()
		clone_upvr.Parent = workspace
		VisibleMgr_upvr.AnchoredAll(clone_upvr)
		VisibleMgr_upvr.UnTransparencyAll(clone_upvr)
		VisibleMgr_upvr.UnQueryAll(clone_upvr)
		VisibleMgr_upvr.UnCollideAll(clone_upvr)
		VisibleMgr_upvr.UnTouchAll(clone_upvr)
		local Position = arg1:GetPivot().Position
		if arg2 then
			Position = arg2
		end
		clone_upvr:PivotTo(CFrame.new(Position))
		module_upvr.Emit_Particles_GetDescendants(clone_upvr, true)
		delay(2, function() -- Line 1177
			--[[ Upvalues[2]:
				[1]: module_upvr (copied, readonly)
				[2]: clone_upvr (readonly)
			]]
			module_upvr.Debris(clone_upvr, 0)
		end)
	end
end
function module_upvr.Settle_Skill_All_Effects(arg1, arg2, arg3) -- Line 1184
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then return end
		if not arg3 then
		end
		for i_23 = 1, arg2 do
			delay(0.1 * (i_23 - 1), function() -- Line 1199
				--[[ Upvalues[2]:
					[1]: module_upvr (copied, readonly)
					[2]: arg1 (readonly)
				]]
				module_upvr.Settle_Skill_Effect(arg1)
			end)
		end
	end
end
function module_upvr.Hit_Effect(arg1, arg2, arg3, arg4) -- Line 1209
	if not arg3 then
	end
	if not arg4 then
	end
end
function module_upvr.Debris(arg1, arg2) -- Line 1226
	--[[ Upvalues[1]:
		[1]: Debris_2_upvr (readonly)
	]]
	if not arg2 then
	end
	delay(0, function() -- Line 1232
		--[[ Upvalues[2]:
			[1]: Debris_2_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		Debris_2_upvr:AddItem(arg1, 0)
	end)
end
local SoundModule_upvr = require(ReplicatedStorage_upvr.Tool.SoundModule)
function module_upvr.PlaySound(arg1, arg2) -- Line 1239
	--[[ Upvalues[1]:
		[1]: SoundModule_upvr (readonly)
	]]
	if not arg2 or not arg2.SoundName then
	else
		SoundModule_upvr:PlaySoundLocal(arg2)
	end
end
function module_upvr.PlaySoundNormal(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 1250
end
function module_upvr.Move(arg1, arg2) -- Line 1254
	if arg1.Releaser == game.Players.LocalPlayer then
		local Caster_2 = arg1.Caster
		if Caster_2 then
			local class_Humanoid = Caster_2:FindFirstChildOfClass("Humanoid")
			if class_Humanoid and 0 < class_Humanoid.Health then
				Caster_2:PivotTo(arg2)
			end
		end
	end
end
return module_upvr