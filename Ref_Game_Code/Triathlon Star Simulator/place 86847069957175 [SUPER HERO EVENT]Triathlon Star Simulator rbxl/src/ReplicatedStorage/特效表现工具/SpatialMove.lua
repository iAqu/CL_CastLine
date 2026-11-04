-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:55
-- Luau version 6, Types version 3
-- Time taken: 0.014686 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService_upvr = game:GetService("RunService")
local TweenService_upvr = game:GetService("TweenService")
local RayCast_upvr = require(ReplicatedStorage["特效表现工具"].RayCast)
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
local _ = {Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
function module.DashRay(arg1, arg2, arg3) -- Line 21
	--[[ Upvalues[1]:
		[1]: RayCast_upvr (readonly)
	]]
	local any_GetPivot_result1 = arg1:GetPivot()
	local var9 = arg3 + 2
	local any_RayToAhead_result1 = RayCast_upvr.RayToAhead(any_GetPivot_result1, var9)
	local var11 = any_GetPivot_result1 + Vector3.new(0, 2, 0)
	local any_RayToAhead_result1_4 = RayCast_upvr.RayToAhead(var11, var9)
	local var13 = any_GetPivot_result1 - Vector3.new(0, 2, 0)
	local any_RayToAhead_result1_3 = RayCast_upvr.RayToAhead(var13, var9)
	local var15
	if any_RayToAhead_result1 and (any_RayToAhead_result1.Position - any_GetPivot_result1.Position).Magnitude < var15 then
		var15 = (any_RayToAhead_result1.Position - any_GetPivot_result1.Position).Magnitude
	end
	if any_RayToAhead_result1_4 and (any_RayToAhead_result1_4.Position - var11.Position).Magnitude < var15 then
		var15 = (any_RayToAhead_result1_4.Position - var11.Position).Magnitude
	end
	if any_RayToAhead_result1_3 and (any_RayToAhead_result1_3.Position - var13.Position).Magnitude < var15 then
		var15 = (any_RayToAhead_result1_3.Position - var13.Position).Magnitude
	end
	return any_GetPivot_result1 + var15 * arg2
end
function module.DashMove(arg1, arg2, arg3) -- Line 70
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: RayCast_upvr (readonly)
	]]
	if not arg1:FindFirstChildOfClass("Humanoid") then
	else
		local HumanoidRootPart_upvr = arg1:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart_upvr then return end
		local CFrame_upvw = HumanoidRootPart_upvr.CFrame
		for _, v in pairs(workspace:GetChildren()) do
			if v:IsA("Folder") then
				table.insert({}, v)
			end
		end
		local var24_upvw = 0
		local var25_upvw
		var25_upvw = RunService_upvr.Stepped:Connect(function(arg1_2, arg2_2) -- Line 127
			--[[ Upvalues[8]:
				[1]: var24_upvw (read and write)
				[2]: CFrame_upvw (read and write)
				[3]: arg3 (readonly)
				[4]: RayCast_upvr (copied, readonly)
				[5]: arg2 (readonly)
				[6]: HumanoidRootPart_upvr (readonly)
				[7]: var25_upvw (read and write)
				[8]: arg1 (readonly)
			]]
			var24_upvw += arg2_2
			local LookVector = CFrame_upvw.LookVector
			local Position = CFrame_upvw.Position
			local any_RayToAhead_result1_2 = RayCast_upvr.RayToAhead(CFrame.lookAt(Position - 5 * LookVector, Position + (LookVector) * (arg3 * arg2_2)), 6)
			local var29
			if arg2 <= var24_upvw or not HumanoidRootPart_upvr then
				var25_upvw:Disconnect()
				var25_upvw = nil
			else
				if any_RayToAhead_result1_2 then
					local var30 = (any_RayToAhead_result1_2.Position - Position).Magnitude - 1
					if var30 <= 0 then return end
					var29 = var30
				end
				arg1:PivotTo(HumanoidRootPart_upvr.CFrame + HumanoidRootPart_upvr.CFrame.LookVector * var29)
				CFrame_upvw = HumanoidRootPart_upvr.CFrame
			end
		end)
	end
end
function module.DashMoveByDis(arg1, arg2, arg3, arg4, arg5) -- Line 168
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local var32_upvw = 0
	local Linear_upvw = Enum.EasingStyle.Linear
	local In_upvw_5 = Enum.EasingDirection.In
	local var35_upvw
	local LookVector_2_upvw = arg1:GetPivot().LookVector
	local Y_upvr = arg1:GetPivot().Y
	var35_upvw = RunService_upvr.Stepped:Connect(function(arg1_3, arg2_3) -- Line 183
		--[[ Upvalues[12]:
			[1]: arg1 (readonly)
			[2]: var32_upvw (read and write)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: TweenService_upvr (copied, readonly)
			[6]: Linear_upvw (read and write)
			[7]: In_upvw_5 (read and write)
			[8]: RayCast_upvr (copied, readonly)
			[9]: var35_upvw (read and write)
			[10]: LookVector_2_upvw (read and write)
			[11]: VisibleMgr_upvr (copied, readonly)
			[12]: Y_upvr (readonly)
		]]
		local any_GetPivot_result1_5 = arg1:GetPivot()
		var32_upvw += arg2_3
		local var39 = arg3 * TweenService_upvr:GetValue(math.clamp(var32_upvw / arg2, 0, 1), Linear_upvw, In_upvw_5) - arg3 * TweenService_upvr:GetValue(math.clamp(var32_upvw / arg2, 0, 1), Linear_upvw, In_upvw_5)
		local var40 = var39 + 2
		local var41
		if RayCast_upvr.RayToAhead(any_GetPivot_result1_5, var40) and not var41 then
			var41 = true
		end
		if RayCast_upvr.RayToAhead(any_GetPivot_result1_5 + Vector3.new(0, 2, 0), var40) and not var41 then
			var41 = true
		end
		if RayCast_upvr.RayToAhead(any_GetPivot_result1_5 - Vector3.new(0, 2, 0), var40) and not var41 then
			var41 = true
		end
		if not arg1 or arg2 <= var32_upvw or var41 then
			var35_upvw:Disconnect()
			var35_upvw = nil
		else
			local var42 = any_GetPivot_result1_5 + LookVector_2_upvw * var39
			VisibleMgr_upvr.SpeedDown(arg1)
			arg1:PivotTo(var42.Rotation + Vector3.new(var42.X, Y_upvr, var42.Z))
			LookVector_2_upvw = arg1:GetPivot().LookVector
		end
	end)
end
function module.DashMoveByDisRayAll(arg1, arg2, arg3, arg4, arg5) -- Line 254
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local var44_upvw = 0
	local Linear_upvw_5 = Enum.EasingStyle.Linear
	local In_upvw_2 = Enum.EasingDirection.In
	local var47_upvw
	local LookVector_upvw = arg1:GetPivot().LookVector
	local Y_upvr_3 = arg1:GetPivot().Y
	var47_upvw = RunService_upvr.Stepped:Connect(function(arg1_4, arg2_4) -- Line 269
		--[[ Upvalues[12]:
			[1]: arg1 (readonly)
			[2]: var44_upvw (read and write)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: TweenService_upvr (copied, readonly)
			[6]: Linear_upvw_5 (read and write)
			[7]: In_upvw_2 (read and write)
			[8]: RayCast_upvr (copied, readonly)
			[9]: var47_upvw (read and write)
			[10]: LookVector_upvw (read and write)
			[11]: VisibleMgr_upvr (copied, readonly)
			[12]: Y_upvr_3 (readonly)
		]]
		local any_GetPivot_result1_4 = arg1:GetPivot()
		var44_upvw += arg2_4
		local var51 = arg3 * TweenService_upvr:GetValue(math.clamp(var44_upvw / arg2, 0, 1), Linear_upvw_5, In_upvw_2) - arg3 * TweenService_upvr:GetValue(math.clamp(var44_upvw / arg2, 0, 1), Linear_upvw_5, In_upvw_2)
		local var52 = var51 + 1
		local var53 = any_GetPivot_result1_4 + Vector3.new(0, 2, 0)
		local var54 = any_GetPivot_result1_4 - Vector3.new(0, 2, 0)
		local var55
		if RayCast_upvr.RayToAll(any_GetPivot_result1_4, any_GetPivot_result1_4.LookVector, var52) and not var55 then
			var55 = true
		end
		if RayCast_upvr.RayToAll(var53, var53.LookVector, var52) and not var55 then
			var55 = true
		end
		if RayCast_upvr.RayToAll(var54, var54.LookVector, var52) and not var55 then
			var55 = true
		end
		if not arg1 or arg2 <= var44_upvw or var55 then
			var47_upvw:Disconnect()
			var47_upvw = nil
		else
			local var56 = any_GetPivot_result1_4 + LookVector_upvw * var51
			VisibleMgr_upvr.SpeedDown(arg1)
			arg1:PivotTo(var56.Rotation + Vector3.new(var56.X, Y_upvr_3, var56.Z))
			LookVector_upvw = arg1:GetPivot().LookVector
		end
	end)
end
local function _() -- Line 340, Named "IsPressDir"
	local Character = game.Players.LocalPlayer.Character
	if Character then
		local class_Humanoid_2 = Character:FindFirstChildOfClass("Humanoid")
		if class_Humanoid_2 and class_Humanoid_2.MoveDirection ~= Vector3.new(0, 0, 0) then
			return true
		end
	end
	return false
end
local InsMgr_upvr = require(ReplicatedStorage.Tool.InsMgr)
local function GetFlyDir_upvr() -- Line 369, Named "GetFlyDir"
	--[[ Upvalues[1]:
		[1]: InsMgr_upvr (readonly)
	]]
	local LocalPlayer = game.Players.LocalPlayer
	local any_GetIns_result1_3 = InsMgr_upvr.GetIns("FrontValue", "NumberValue", LocalPlayer)
	local any_GetIns_result1 = InsMgr_upvr.GetIns("LeftValue", "NumberValue", LocalPlayer)
	local any_GetIns_result1_2 = InsMgr_upvr.GetIns("RightValue", "NumberValue", LocalPlayer)
	local any_GetIns_result1_4 = InsMgr_upvr.GetIns("BackValue", "NumberValue", LocalPlayer)
	local var67
	if any_GetIns_result1_3.Value == 1 and any_GetIns_result1_4.Value == 0 then
		var67 = 1
	elseif any_GetIns_result1_3.Value == 0 and any_GetIns_result1_4.Value == 1 then
		var67 = -1
	end
	local var68
	if any_GetIns_result1.Value == 1 and any_GetIns_result1_2.Value == 0 then
		var68 = 1
	elseif any_GetIns_result1.Value == 0 and any_GetIns_result1_2.Value == 1 then
		var68 = -1
	end
	if var67 == 1 and var68 == 0 then
		return workspace.CurrentCamera.CFrame.LookVector
	end
	if var67 == 1 and var68 == 1 then
		return workspace.CurrentCamera.CFrame:ToWorldSpace(CFrame.Angles(0, 0.7853981633974483, 0)).LookVector
	end
	if var67 == 1 and var68 == -1 then
		return workspace.CurrentCamera.CFrame:ToWorldSpace(CFrame.Angles(0, -0.7853981633974483, 0)).LookVector
	end
	if var67 == -1 and var68 == 0 then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return -workspace.CurrentCamera.CFrame.LookVector
	end
	if var67 == -1 and var68 == 1 then
		return -workspace.CurrentCamera.CFrame:ToWorldSpace(CFrame.Angles(0, 0.7853981633974483, 0)).LookVector
	end
	if var67 == -1 and var68 == -1 then
		return -workspace.CurrentCamera.CFrame:ToWorldSpace(CFrame.Angles(0, -0.7853981633974483, 0)).LookVector
	end
	if var67 == 0 and var68 == 1 then
		do
			return workspace.CurrentCamera.CFrame:ToWorldSpace(CFrame.Angles(0, (math.pi/2), 0)).LookVector
		end
		local var69
	end
	if var67 == 0 and var68 == -1 then
	end
	return nil
end
local function GetMoveDir_upvr(arg1) -- Line 418, Named "GetMoveDir"
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local class_Humanoid_5 = arg1:FindFirstChildOfClass("Humanoid")
	local var78
	if class_Humanoid_5 then
		local var79 = false
		var78 = RunService_upvr:IsClient()
		if var78 then
			var78 = game.Players.LocalPlayer:FindFirstChild("AutoFight")
			if var78 and var78.Value == 1 then
				var79 = true
			end
		end
		var78 = 2
		local Character_2 = game.Players.LocalPlayer.Character
		if Character_2 then
			local class_Humanoid_6 = Character_2:FindFirstChildOfClass("Humanoid")
			if class_Humanoid_6 and class_Humanoid_6.MoveDirection ~= Vector3.new(0, 0, 0) then
				-- KONSTANTWARNING: GOTO [50] #36
			end
		end
		if false or var79 then
			var78 = 1
		end
		if class_Humanoid_5.MoveDirection == Vector3.new(0, 0, 0) then
		end
		if var78 == 2 then
		end
		return workspace.CurrentCamera.CFrame.LookVector
	end
	return nil
end
local function _(arg1) -- Line 452, Named "GetMoveDir_Car"
	local var82
	if arg1:FindFirstChildOfClass("Humanoid") then
		var82 = arg1:GetPivot().LookVector
		var82 = workspace.CurrentCamera.CFrame.LookVector
		return var82
	end
	return var82
end
function module.DashMoveSpByDis(arg1, arg2, arg3, arg4, arg5) -- Line 474
	--[[ Upvalues[5]:
		[1]: RunService_upvr (readonly)
		[2]: GetMoveDir_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: RayCast_upvr (readonly)
		[5]: VisibleMgr_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local var84_upvw
	local var85_upvw = 0
	local Linear_upvw_2 = Enum.EasingStyle.Linear
	local In_upvw_3 = Enum.EasingDirection.In
	local any_GetPivot_result1_7_upvr = arg1:GetPivot()
	local Y_upvr_2 = arg1:GetPivot().Y
	var84_upvw = RunService_upvr.Stepped:Connect(function(arg1_5, arg2_5) -- Line 489
		--[[ Upvalues[13]:
			[1]: arg1 (readonly)
			[2]: GetMoveDir_upvr (copied, readonly)
			[3]: var84_upvw (read and write)
			[4]: var85_upvw (read and write)
			[5]: arg2 (readonly)
			[6]: arg3 (readonly)
			[7]: TweenService_upvr (copied, readonly)
			[8]: Linear_upvw_2 (read and write)
			[9]: In_upvw_3 (read and write)
			[10]: RayCast_upvr (copied, readonly)
			[11]: any_GetPivot_result1_7_upvr (readonly)
			[12]: VisibleMgr_upvr (copied, readonly)
			[13]: Y_upvr_2 (readonly)
		]]
		local any_GetPivot_result1_3 = arg1:GetPivot()
		local GetMoveDir_upvr_result1 = GetMoveDir_upvr(arg1)
		if not GetMoveDir_upvr_result1 then
			var84_upvw:Disconnect()
			var84_upvw = nil
		else
			var85_upvw += arg2_5
			local var92 = arg3 * TweenService_upvr:GetValue(math.clamp(var85_upvw / arg2, 0, 1), Linear_upvw_2, In_upvw_3) - arg3 * TweenService_upvr:GetValue(math.clamp(var85_upvw / arg2, 0, 1), Linear_upvw_2, In_upvw_3)
			local var93 = var92 + 1
			local var94
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_3, var93) and not var94 then
				var94 = true
			end
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_3 + Vector3.new(0, 2, 0), var93) and not var94 then
				var94 = true
			end
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_3 - Vector3.new(0, 2, 0), var93) and not var94 then
				var94 = true
			end
			if not arg1 or arg2 <= var85_upvw or var94 then
				var84_upvw:Disconnect()
				var84_upvw = nil
				return
			end
			if arg3 < (any_GetPivot_result1_7_upvr.Position - any_GetPivot_result1_3.Position).Magnitude then
				var84_upvw:Disconnect()
				var84_upvw = nil
				return
			end
			local var95 = any_GetPivot_result1_3 + GetMoveDir_upvr_result1 * var92
			VisibleMgr_upvr.SpeedDown(arg1)
			arg1:PivotTo(CFrame.lookAt(Vector3.new(var95.X, Y_upvr_2, var95.Z), Vector3.new(var95.X, Y_upvr_2, var95.Z) + Vector3.new(GetMoveDir_upvr_result1.X, 0, GetMoveDir_upvr_result1.Z)))
		end
	end)
end
function module.DashMoveSpByDis_Robot(arg1, arg2, arg3, arg4, arg5) -- Line 572
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local var97_upvw
	local var98_upvw = 0
	local Linear_upvw_3 = Enum.EasingStyle.Linear
	local In_upvw = Enum.EasingDirection.In
	local any_GetPivot_result1_upvr = arg1:GetPivot()
	local Y_upvr_4 = arg1:GetPivot().Y
	var97_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_6) -- Line 587
		--[[ Upvalues[12]:
			[1]: arg1 (readonly)
			[2]: var97_upvw (read and write)
			[3]: var98_upvw (read and write)
			[4]: arg2 (readonly)
			[5]: arg3 (readonly)
			[6]: TweenService_upvr (copied, readonly)
			[7]: Linear_upvw_3 (read and write)
			[8]: In_upvw (read and write)
			[9]: RayCast_upvr (copied, readonly)
			[10]: any_GetPivot_result1_upvr (readonly)
			[11]: VisibleMgr_upvr (copied, readonly)
			[12]: Y_upvr_4 (readonly)
		]]
		local any_GetPivot_result1_8 = arg1:GetPivot()
		local Unit = Vector3.new(any_GetPivot_result1_8.LookVector.X, 0, any_GetPivot_result1_8.LookVector.Z).Unit
		if not Unit then
			var97_upvw:Disconnect()
			var97_upvw = nil
		else
			var98_upvw += arg1_6
			local var105 = arg3 * TweenService_upvr:GetValue(math.clamp(var98_upvw / arg2, 0, 1), Linear_upvw_3, In_upvw) - arg3 * TweenService_upvr:GetValue(math.clamp(var98_upvw / arg2, 0, 1), Linear_upvw_3, In_upvw)
			local var106 = var105 + 1
			local var107
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_8, var106) and not var107 then
				var107 = true
			end
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_8 + Vector3.new(0, 2, 0), var106) and not var107 then
				var107 = true
			end
			if RayCast_upvr.RayToAhead(any_GetPivot_result1_8 - Vector3.new(0, 2, 0), var106) and not var107 then
				var107 = true
			end
			if not arg1 or arg2 <= var98_upvw or var107 then
				var97_upvw:Disconnect()
				var97_upvw = nil
				return
			end
			if arg3 < (any_GetPivot_result1_upvr.Position - any_GetPivot_result1_8.Position).Magnitude then
				var97_upvw:Disconnect()
				var97_upvw = nil
				return
			end
			local var108 = any_GetPivot_result1_8 + Unit * var105
			VisibleMgr_upvr.SpeedDown(arg1)
			arg1:PivotTo(CFrame.lookAt(Vector3.new(var108.X, Y_upvr_4, var108.Z), Vector3.new(var108.X, Y_upvr_4, var108.Z) + Vector3.new(Unit.X, 0, Unit.Z)))
		end
	end)
end
function module.DashMoveSpByDis_StopByTime(arg1, arg2, arg3, arg4, arg5) -- Line 656
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	if not arg4 then
	end
	if not arg5 then
	end
	local var110_upvw = 0
	local var111_upvw
	local var112_upvw = 0
	local Linear_upvw_4 = Enum.EasingStyle.Linear
	local In_upvw_4 = Enum.EasingDirection.In
	var111_upvw = RunService_upvr.Stepped:Connect(function(arg1_7, arg2_6) -- Line 672
		--[[ Upvalues[11]:
			[1]: var110_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: var111_upvw (read and write)
			[4]: var112_upvw (read and write)
			[5]: arg2 (readonly)
			[6]: arg3 (readonly)
			[7]: TweenService_upvr (copied, readonly)
			[8]: Linear_upvw_4 (read and write)
			[9]: In_upvw_4 (read and write)
			[10]: RayCast_upvr (copied, readonly)
			[11]: VisibleMgr_upvr (copied, readonly)
		]]
		var110_upvw += arg2_6
		local var116
		if arg1:FindFirstChildOfClass("Humanoid") then
			var116 = workspace.CurrentCamera.CFrame.LookVector
		else
			var116 = workspace.CurrentCamera.CFrame.LookVector
		end
		if not var116 then
			var111_upvw:Disconnect()
			var111_upvw = nil
		else
			var116 = Vector3.new(var116.X, 0, var116.Z).Unit
			var112_upvw += 0.02
			if RayCast_upvr.RayToLand(arg1:GetPivot().Position) then
			end
			if not arg1 or arg2 <= var110_upvw then
				var111_upvw:Disconnect()
				var111_upvw = nil
				return
			end
			VisibleMgr_upvr.SpeedDownY(arg1)
			local PrimaryPart = arg1.PrimaryPart
			PrimaryPart.AssemblyLinearVelocity += var116 * (arg3) * (0.02 / arg2) * 100
		end
	end)
end
function module.FlyMove_ByTime(arg1, arg2, arg3) -- Line 726
	--[[ Upvalues[4]:
		[1]: RayCast_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: GetFlyDir_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	local any_GetPivot_result1_6 = arg1:GetPivot()
	local var121
	local any_RayToDir_result1 = RayCast_upvr.RayToDir(any_GetPivot_result1_6, Vector3.new(0, -1, 0), 5)
	if any_RayToDir_result1 then
		var121 = any_RayToDir_result1.Position
	end
	if var121 then
		arg1:PivotTo(any_GetPivot_result1_6 + Vector3.new(0, var121.Y + 5, 0))
	end
	local var124_upvw = 0
	local var125_upvw
	var125_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_8) -- Line 750
		--[[ Upvalues[8]:
			[1]: var124_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: GetFlyDir_upvr (copied, readonly)
			[4]: arg2 (readonly)
			[5]: var125_upvw (read and write)
			[6]: arg3 (readonly)
			[7]: RayCast_upvr (copied, readonly)
			[8]: VisibleMgr_upvr (copied, readonly)
		]]
		var124_upvw += arg1_8
		local any_GetPivot_result1_2 = arg1:GetPivot()
		local class_Humanoid = arg1:FindFirstChildOfClass("Humanoid")
		local GetFlyDir_upvr_result1 = GetFlyDir_upvr()
		if not GetFlyDir_upvr_result1 then
		else
			if arg2 < var124_upvw or not class_Humanoid or class_Humanoid.Health <= 0 then
				var125_upvw:Disconnect()
				var125_upvw = nil
				return
			end
			local var129 = arg1_8 * arg3
			local var130 = any_GetPivot_result1_2.Position + var129 * GetFlyDir_upvr_result1
			local cframe = CFrame.new(var130, var130 + workspace.CurrentCamera.CFrame.LookVector)
			local var132 = var129 + 1
			local var133
			if RayCast_upvr.RayToAhead(cframe, var132) and not var133 then
				var133 = true
			end
			if RayCast_upvr.RayToAhead(cframe + Vector3.new(0, 2, 0), var132) and not var133 then
				var133 = true
			end
			if RayCast_upvr.RayToAhead(cframe - Vector3.new(0, 2, 0), var132) and not var133 then
				var133 = true
			end
			if var133 then return end
			VisibleMgr_upvr.SpeedDown(arg1)
			arg1:PivotTo(any_GetPivot_result1_2.Rotation:Lerp(cframe.Rotation, 0.05) + cframe.Position)
		end
	end)
end
return module