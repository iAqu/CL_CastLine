-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:07
-- Luau version 6, Types version 3
-- Time taken: 0.037653 seconds

local Debris_upvr = game:GetService("Debris")
local RunService_upvr = game:GetService("RunService")
local CustomCurve_upvr = require(game.ReplicatedStorage.Tool.CustomCurve)
local module_upvr = {
	Lerp = function(arg1, arg2, arg3) -- Line 11, Named "Lerp"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var5
		if typeof(arg1) ~= "Vector3" then
			local Position_34 = arg1.Position
		end
		if typeof(var5) ~= "Vector3" then
			var5 = var5.Position
		end
		return Position_34 + (var5 - Position_34) * arg3
	end;
	GetFrameByDistance = function(arg1, arg2, arg3) -- Line 25, Named "GetFrameByDistance"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var7
		if typeof(arg1) ~= "Vector3" then
			var7 = var7.Position
		end
		if typeof(arg2) ~= "Vector3" then
		end
		if not arg3 then
		else
		end
		return math.round((var7 - arg2.Position).Magnitude * 2 / (1 + 1))
	end;
	GetMotionTime = function(arg1, arg2) -- Line 48, Named "GetMotionTime"
		return 0 + task.wait(1 / arg2) * arg1
	end;
	GetMiddlePosition = function(arg1, arg2, arg3, arg4, arg5) -- Line 56, Named "GetMiddlePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var9
		if typeof(arg1) ~= "Vector3" then
			var9 = var9.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position_8 = arg2.Position
		end
		if not arg3 then
		end
		if not arg5 then
		end
		if not arg4 then
		end
		local var11 = var9 - (var9 - Position_8) * 0.5
		return var11 + (CFrame.new(var11, Position_8) * CFrame.Angles(0, 0, math.rad(0))).UpVector * 1
	end;
	Get2MiddlePosition = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 93, Named "Get2MiddlePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var12
		if typeof(arg1) ~= "Vector3" then
			var12 = var12.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position = arg2.Position
		end
		if not arg3 then
		end
		if not arg6 then
		end
		if not arg4 then
		end
		if not arg7 then
		end
		if not arg5 then
		end
		if not arg8 then
		end
		local function GetResultPosition(arg1_2, arg2_2, arg3_2, arg4_2, arg5_2) -- Line 131
			local var14 = arg1_2 - (arg1_2 - arg2_2) * arg5_2
			return var14 + (CFrame.new(var14, arg2_2) * CFrame.Angles(0, 0, math.rad(arg3_2))).UpVector * arg4_2
		end
		local var15 = var12
		local var16 = Position
		local var17 = var15 - (var15 - var16) * 0.5
		local var18 = var12
		local var19 = Position
		local var20 = var18 - (var18 - var19) * 0.5
		return var17 + (CFrame.new(var17, var16) * CFrame.Angles(0, 0, math.rad(0))).UpVector * 1, var20 + (CFrame.new(var20, var19) * CFrame.Angles(0, 0, math.rad(0))).UpVector * 1
	end;
	Get2SquarePosition = function(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 154, Named "Get2SquarePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var21
		if typeof(arg1) ~= "Vector3" then
			var21 = var21.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position_10 = arg2.Position
		end
		if not arg3 then
		end
		if not arg5 then
		end
		if not arg4 then
		else
		end
		if not arg6 then
		else
		end
		local function _(arg1_3, arg2_3, arg3_3, arg4_3, arg5_3) -- Line 184, Named "GetResultPosition"
			local var24 = (arg1_3 - arg2_3) * arg5_3
			local var25 = arg1_3 - var24
			return var25 + ((CFrame.new(var25, arg2_3) * CFrame.Angles(0, 0, math.rad(arg3_3))).UpVector) * (var24.Magnitude * arg4_3)
		end
		local var26 = var21
		local var27 = Position_10
		local var28 = (var26 - var27) * 0.2
		local var29 = var26 - var28
		local var30 = var21
		local var31 = Position_10
		local var32 = (var30 - var31) * 0.8
		local var33 = var30 - var32
		return var29 + ((CFrame.new(var29, var27) * CFrame.Angles(0, 0, math.rad(0))).UpVector) * (var28.Magnitude * (1 + 1)), var33 + ((CFrame.new(var33, var31) * CFrame.Angles(0, 0, math.rad(0))).UpVector) * (var32.Magnitude * (1 + 1))
	end;
}
function module_upvr.LinearBezierCurves(arg1, arg2, arg3, arg4, arg5) -- Line 208
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var34_upvw
	if typeof(arg4) ~= "Vector3" then
		var34_upvw = var34_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var36_upvw = 0
	local var37_upvw = 0
	local var38_upvr = 1 / arg2
	local Position_7_upvw = arg5.Position
	local var40_upvw
	var40_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_4) -- Line 223
		--[[ Upvalues[9]:
			[1]: var36_upvw (read and write)
			[2]: var37_upvw (read and write)
			[3]: var38_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var34_upvw (read and write)
			[7]: Position_7_upvw (read and write)
			[8]: arg3 (readonly)
			[9]: var40_upvw (read and write)
		]]
		var36_upvw += arg1_4
		if var36_upvw < var37_upvw * var38_upvr then
		else
			if var37_upvw * var38_upvr <= var36_upvw then
				var37_upvw += 1
				arg3.Position = module_upvr.Lerp(var34_upvw, Position_7_upvw, var37_upvw / arg1)
			end
			if arg1 <= var37_upvw then
				var40_upvw:Disconnect()
				var40_upvw = nil
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurves(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 264
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var41_upvw
	if typeof(arg4) ~= "Vector3" then
		var41_upvw = var41_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var43_upvw = 0
	local var44_upvw = 0
	local var45_upvr = 1 / arg2
	local Position_13_upvw = arg5.Position
	local Position_upvw_7 = arg6.Position
	local var48_upvw
	var48_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_5) -- Line 283
		--[[ Upvalues[11]:
			[1]: var43_upvw (read and write)
			[2]: var44_upvw (read and write)
			[3]: var45_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var41_upvw (read and write)
			[7]: Position_13_upvw (read and write)
			[8]: Position_upvw_7 (read and write)
			[9]: arg3 (readonly)
			[10]: var48_upvw (read and write)
			[11]: arg7 (readonly)
		]]
		var43_upvw += arg1_5
		if var43_upvw < var44_upvw * var45_upvr then
		else
			if var44_upvw * var45_upvr <= var43_upvw then
				var44_upvw = var43_upvw / var45_upvr
				local var50 = var44_upvw / arg1
				arg3:PivotTo(arg3:GetPivot().Rotation + module_upvr.Lerp(module_upvr.Lerp(var41_upvw, Position_13_upvw, var50), module_upvr.Lerp(Position_13_upvw, Position_upvw_7, var50), var50))
			end
			if arg1 <= var44_upvw then
				var48_upvw:Disconnect()
				var48_upvw = nil
				if arg7 then
					arg7()
				end
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesObjectGoal(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 316
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var51_upvw
	if typeof(arg4) ~= "Vector3" then
		var51_upvw = var51_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var53_upvw = 0
	local var54_upvw = 0
	local var55_upvr = 1 / arg2
	local Position_18_upvw = arg6:GetPivot().Position
	local Position_36_upvw = arg5.Position
	local var58_upvw
	var58_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_6) -- Line 333
		--[[ Upvalues[13]:
			[1]: var53_upvw (read and write)
			[2]: var54_upvw (read and write)
			[3]: var55_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: Position_18_upvw (read and write)
			[6]: arg6 (readonly)
			[7]: arg7 (readonly)
			[8]: module_upvr (copied, readonly)
			[9]: var51_upvw (read and write)
			[10]: Position_36_upvw (read and write)
			[11]: arg3 (readonly)
			[12]: var58_upvw (read and write)
			[13]: arg8 (readonly)
		]]
		var53_upvw += arg1_6
		if var53_upvw < var54_upvw * var55_upvr then
		else
			if var54_upvw * var55_upvr <= var53_upvw then
				var54_upvw = var53_upvw / var55_upvr
				local var59 = var54_upvw / arg1
				Position_18_upvw = arg6:GetPivot().Position + arg7
				arg3:PivotTo(arg3:GetPivot().Rotation + module_upvr.Lerp(module_upvr.Lerp(var51_upvw, Position_36_upvw, var59), module_upvr.Lerp(Position_36_upvw, Position_18_upvw, var59), var59))
			end
			if arg1 <= var54_upvw or not arg6 then
				var58_upvw:Disconnect()
				var58_upvw = nil
				if arg8 then
					arg8()
				end
			end
		end
	end)
end
function module_upvr.CubicBezierCurves(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 368
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var60_upvw
	if typeof(arg4) ~= "Vector3" then
		var60_upvw = var60_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if typeof(arg7) ~= "Vector3" then
	end
	local var62_upvw = 0
	local var63_upvw = 0
	local var64_upvr = 1 / arg2
	local Position_9_upvw = arg5.Position
	local Position_31_upvw = arg6.Position
	local Position_11_upvw = arg7.Position
	local var68_upvw
	var68_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_7) -- Line 390
		--[[ Upvalues[11]:
			[1]: var62_upvw (read and write)
			[2]: var63_upvw (read and write)
			[3]: var64_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var60_upvw (read and write)
			[7]: Position_9_upvw (read and write)
			[8]: Position_31_upvw (read and write)
			[9]: Position_11_upvw (read and write)
			[10]: arg3 (readonly)
			[11]: var68_upvw (read and write)
		]]
		var62_upvw += arg1_7
		if var62_upvw < var63_upvw * var64_upvr then
		else
			if var63_upvw * var64_upvr <= var62_upvw then
				var63_upvw += 1
				local var69 = var63_upvw / arg1
				local any_Lerp_result1_5 = module_upvr.Lerp(Position_9_upvw, Position_31_upvw, var69)
				arg3.Position = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var60_upvw, Position_9_upvw, var69), any_Lerp_result1_5, var69), module_upvr.Lerp(any_Lerp_result1_5, module_upvr.Lerp(Position_31_upvw, Position_11_upvw, var69), var69), var69)
			end
			if arg1 <= var63_upvw then
				var68_upvw:Disconnect()
				var68_upvw = nil
			end
		end
	end)
end
function module_upvr.LinearBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 444
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_7_upvr = Instance.new("Vector3Value")
	Vector3Value_7_upvr.Parent = arg3
	Vector3Value_7_upvr.Value = Vector3.new(0, 0, 0)
	local var72_upvw
	if typeof(arg4) ~= "Vector3" then
		var72_upvw = var72_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var74_upvw = 0
	local var75_upvw = 0
	local var76_upvr = 1 / arg2
	local Position_23_upvw = arg5.Position
	local var78_upvw
	var78_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_8) -- Line 462
		--[[ Upvalues[12]:
			[1]: var74_upvw (read and write)
			[2]: var75_upvw (read and write)
			[3]: var76_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: Vector3Value_7_upvr (readonly)
			[6]: module_upvr (copied, readonly)
			[7]: var72_upvw (read and write)
			[8]: Position_23_upvw (read and write)
			[9]: arg3 (readonly)
			[10]: arg6 (readonly)
			[11]: var78_upvw (read and write)
			[12]: Debris_upvr (copied, readonly)
		]]
		var74_upvw += arg1_8
		if var74_upvw < var75_upvw * var76_upvr then
		else
			if var75_upvw * var76_upvr <= var74_upvw then
				var75_upvw += 1
				Vector3Value_7_upvr.Value = module_upvr.Lerp(var72_upvw, Position_23_upvw, var75_upvw / arg1)
				arg3.CFrame = CFrame.lookAt(arg3.Position, Vector3Value_7_upvr.Value, Vector3.new(0, 1, 0)) * arg6
				arg3.Position = Vector3Value_7_upvr.Value
			end
			if arg1 <= var75_upvw then
				var78_upvw:Disconnect()
				var78_upvw = nil
				Debris_upvr:AddItem(Vector3Value_7_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11) -- Line 493
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: CustomCurve_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_6_upvr = Instance.new("Vector3Value")
	Vector3Value_6_upvr.Parent = arg3
	Vector3Value_6_upvr.Value = Vector3.new(0, 0, 0)
	local var80_upvw
	if typeof(arg4) ~= "Vector3" then
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if not var80_upvw then
		var80_upvw = Enum.EasingStyle.Linear
	end
	if not arg9 then
	end
	if not arg10 then
	end
	if not arg11 then
	end
	local var82_upvw = 0
	local var83_upvw = 0
	local var84_upvr = 1 / arg2
	local In_upvw_2 = Enum.EasingDirection.In
	local const_number_upvw_2 = 0
	local const_number_upvw = 1
	local Position_4_upvw = arg4.Position
	local Position_29_upvw = arg5.Position
	local Position_22_upvw = arg6.Position
	local var91_upvw
	var91_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_9) -- Line 530
		--[[ Upvalues[18]:
			[1]: var82_upvw (read and write)
			[2]: var83_upvw (read and write)
			[3]: var84_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: CustomCurve_upvr (copied, readonly)
			[6]: var80_upvw (read and write)
			[7]: In_upvw_2 (read and write)
			[8]: const_number_upvw_2 (read and write)
			[9]: const_number_upvw (read and write)
			[10]: module_upvr (copied, readonly)
			[11]: Position_4_upvw (read and write)
			[12]: Position_29_upvw (read and write)
			[13]: Position_22_upvw (read and write)
			[14]: Vector3Value_6_upvr (readonly)
			[15]: arg3 (readonly)
			[16]: arg7 (readonly)
			[17]: var91_upvw (read and write)
			[18]: Debris_upvr (copied, readonly)
		]]
		var82_upvw += arg1_9
		if var82_upvw < var83_upvw * var84_upvr then
		else
			if var83_upvw * var84_upvr <= var82_upvw then
				var83_upvw += 1
				local any_GetCustomEasingValue_result1_3 = CustomCurve_upvr.GetCustomEasingValue(var83_upvw / arg1, var80_upvw, In_upvw_2, const_number_upvw_2, const_number_upvw)
				local any_Lerp_result1_10 = module_upvr.Lerp(Position_4_upvw, Position_29_upvw, any_GetCustomEasingValue_result1_3)
				local any_Lerp_result1 = module_upvr.Lerp(Position_29_upvw, Position_22_upvw, any_GetCustomEasingValue_result1_3)
				Vector3Value_6_upvr.Value = module_upvr.Lerp(any_Lerp_result1_10, any_Lerp_result1, any_GetCustomEasingValue_result1_3)
				arg3:PivotTo(CFrame.lookAt(Vector3Value_6_upvr.Value, module_upvr.Lerp(any_Lerp_result1_10, any_Lerp_result1, any_GetCustomEasingValue_result1_3 + 1 / arg1), Vector3.new(0, 1, 0)).Rotation + Vector3Value_6_upvr.Value)
			end
			if arg1 < var83_upvw then
				if arg7 then
					arg7()
				end
				var91_upvw:Disconnect()
				var91_upvw = nil
				Debris_upvr:AddItem(Vector3Value_6_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesLookAtAimObject(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 572
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_9_upvr = Instance.new("Vector3Value")
	Vector3Value_9_upvr.Parent = arg3
	Vector3Value_9_upvr.Value = Vector3.new(0, 0, 0)
	local var96_upvw
	if typeof(arg4) ~= "Vector3" then
		var96_upvw = var96_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var98_upvw = 0
	local var99_upvw = 0
	local var100_upvr = 1 / arg2
	local Position_12_upvw = arg5.Position
	local var102_upvw
	var102_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_10) -- Line 591
		--[[ Upvalues[14]:
			[1]: var98_upvw (read and write)
			[2]: var99_upvw (read and write)
			[3]: var100_upvr (readonly)
			[4]: arg6 (readonly)
			[5]: arg1 (readonly)
			[6]: arg9 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: var96_upvw (read and write)
			[9]: Position_12_upvw (read and write)
			[10]: Vector3Value_9_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: arg8 (readonly)
			[13]: var102_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var98_upvw += arg1_10
		if var98_upvw < var99_upvw * var100_upvr then
		else
			if var99_upvw * var100_upvr <= var98_upvw and arg6 then
				var99_upvw += 1
				local var103 = var99_upvw / arg1
				local any_Lerp_result1_2 = module_upvr.Lerp(var96_upvw, Position_12_upvw, var103)
				local any_Lerp_result1_4 = module_upvr.Lerp(Position_12_upvw, arg6.Position + arg9, var103)
				Vector3Value_9_upvr.Value = module_upvr.Lerp(any_Lerp_result1_2, any_Lerp_result1_4, var103)
				arg3:PivotTo(CFrame.lookAt(Vector3Value_9_upvr.Value, module_upvr.Lerp(any_Lerp_result1_2, any_Lerp_result1_4, var103 + 1 / arg1), Vector3.new(0, 1, 0)).Rotation + Vector3Value_9_upvr.Value)
			end
			if arg1 < var99_upvw or not arg6 then
				if arg8 then
					arg8()
				end
				var102_upvw:Disconnect()
				var102_upvw = nil
				Debris_upvr:AddItem(Vector3Value_9_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesLookAtRotate(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 633
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_17_upvr = Instance.new("Vector3Value")
	Vector3Value_17_upvr.Parent = arg3
	Vector3Value_17_upvr.Value = Vector3.new(0, 0, 0)
	local var107_upvw
	if typeof(arg4) ~= "Vector3" then
		var107_upvw = var107_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var109_upvw = 0
	local var110_upvw = 0
	local var111_upvr = 1 / arg2
	local Position_6_upvw = arg5.Position
	local Position_15_upvw = arg6.Position
	local var114_upvw
	var114_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_11) -- Line 655
		--[[ Upvalues[14]:
			[1]: var109_upvw (read and write)
			[2]: var110_upvw (read and write)
			[3]: var111_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var107_upvw (read and write)
			[7]: Position_6_upvw (read and write)
			[8]: Position_15_upvw (read and write)
			[9]: Vector3Value_17_upvr (readonly)
			[10]: arg9 (readonly)
			[11]: arg3 (readonly)
			[12]: arg8 (readonly)
			[13]: var114_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var109_upvw += arg1_11
		if var109_upvw < var110_upvw * var111_upvr then
		else
			if var110_upvw * var111_upvr <= var109_upvw then
				var110_upvw += 1
				local var115 = var110_upvw / arg1
				local any_Lerp_result1_6 = module_upvr.Lerp(var107_upvw, Position_6_upvw, var115)
				local any_Lerp_result1_3 = module_upvr.Lerp(Position_6_upvw, Position_15_upvw, var115)
				Vector3Value_17_upvr.Value = module_upvr.Lerp(any_Lerp_result1_6, any_Lerp_result1_3, var115)
				arg3:PivotTo((CFrame.lookAt(Vector3Value_17_upvr.Value, module_upvr.Lerp(any_Lerp_result1_6, any_Lerp_result1_3, var115 + 1 / arg1), Vector3.new(0, 1, 0)).Rotation + Vector3Value_17_upvr.Value) * CFrame.Angles(math.rad(arg9.X * var109_upvw), math.rad(arg9.Y * var109_upvw), math.rad(arg9.Z * var109_upvw)))
			end
			if arg1 < var110_upvw then
				if arg8 then
					arg8()
				end
				var114_upvw:Disconnect()
				var114_upvw = nil
				Debris_upvr:AddItem(Vector3Value_17_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesLookAtRotateAimObject(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Line 697
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_3_upvr = Instance.new("Vector3Value")
	Vector3Value_3_upvr.Parent = arg3
	Vector3Value_3_upvr.Value = Vector3.new(0, 0, 0)
	local var119_upvw
	if typeof(arg4) ~= "Vector3" then
		var119_upvw = var119_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var121_upvw = 0
	local var122_upvw = 0
	local var123_upvr = 1 / arg2
	local Position_upvw_4 = arg5.Position
	local var125_upvw
	var125_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_12) -- Line 717
		--[[ Upvalues[15]:
			[1]: var121_upvw (read and write)
			[2]: var122_upvw (read and write)
			[3]: var123_upvr (readonly)
			[4]: arg6 (readonly)
			[5]: arg1 (readonly)
			[6]: arg10 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: var119_upvw (read and write)
			[9]: Position_upvw_4 (read and write)
			[10]: Vector3Value_3_upvr (readonly)
			[11]: arg9 (readonly)
			[12]: arg3 (readonly)
			[13]: arg8 (readonly)
			[14]: var125_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
		]]
		var121_upvw += arg1_12
		if var121_upvw < var122_upvw * var123_upvr then
		else
			if var122_upvw * var123_upvr <= var121_upvw and arg6 then
				var122_upvw += 1
				local var126 = var122_upvw / arg1
				local any_Lerp_result1_9 = module_upvr.Lerp(var119_upvw, Position_upvw_4, var126)
				local any_Lerp_result1_7 = module_upvr.Lerp(Position_upvw_4, arg6.Position + arg10, var126)
				Vector3Value_3_upvr.Value = module_upvr.Lerp(any_Lerp_result1_9, any_Lerp_result1_7, var126)
				arg3:PivotTo((CFrame.lookAt(Vector3Value_3_upvr.Value, module_upvr.Lerp(any_Lerp_result1_9, any_Lerp_result1_7, var126 + 1 / arg1), Vector3.new(0, 1, 0)).Rotation + Vector3Value_3_upvr.Value) * CFrame.Angles(math.rad(arg9.X * var121_upvw), math.rad(arg9.Y * var121_upvw), math.rad(arg9.Z * var121_upvw)))
			end
			if arg1 < var122_upvw or not arg6 then
				if arg8 then
					arg8()
				end
				var125_upvw:Disconnect()
				var125_upvw = nil
				Debris_upvr:AddItem(Vector3Value_3_upvr, task.wait())
			end
		end
	end)
end
local function EntiretyScale_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 761, Named "EntiretyScale"
	if not arg1:FindFirstChild("OriSize") then
		local Vector3Value = Instance.new("Vector3Value", arg1)
		Vector3Value.Name = "OriSize"
		Vector3Value.Value = arg1.Size
	end
	arg1.Size = (Vector3Value.Value) * ((1 - (arg5 - arg2.Position).Magnitude / (arg5 - arg4).Magnitude) * arg3)
end
function module_upvr.QuadraticBezierCurvesScaleChangeLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 777
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: EntiretyScale_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_8_upvr = Instance.new("Vector3Value")
	Vector3Value_8_upvr.Parent = arg3
	Vector3Value_8_upvr.Value = Vector3.new(0, 0, 0)
	local var131_upvw
	if typeof(arg4) ~= "Vector3" then
		var131_upvw = var131_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var133_upvw = 0
	local var134_upvw = 0
	local var135_upvr = 1 / arg2
	local Position_28_upvw = arg5.Position
	local Position_30_upvw = arg6.Position
	local var138_upvw
	var138_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_13) -- Line 799
		--[[ Upvalues[15]:
			[1]: var133_upvw (read and write)
			[2]: var134_upvw (read and write)
			[3]: var135_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var131_upvw (read and write)
			[7]: Position_28_upvw (read and write)
			[8]: Position_30_upvw (read and write)
			[9]: Vector3Value_8_upvr (readonly)
			[10]: arg3 (readonly)
			[11]: EntiretyScale_upvr (copied, readonly)
			[12]: arg7 (readonly)
			[13]: arg8 (readonly)
			[14]: var138_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
		]]
		var133_upvw += arg1_13
		if var133_upvw < var134_upvw * var135_upvr then
		else
			if var134_upvw * var135_upvr <= var133_upvw then
				var134_upvw += 1
				local var141 = var134_upvw / arg1
				Vector3Value_8_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var131_upvw, Position_28_upvw, var141), module_upvr.Lerp(Position_28_upvw, Position_30_upvw, var141), var141)
				for _, v in pairs(arg3:GetDescendants()) do
					if v:IsA("BasePart") then
						if v:GetAttribute("Scale") then
							EntiretyScale_upvr(v, arg3, v:GetAttribute("Scale"), var131_upvw, Position_30_upvw)
						end
					end
				end
				arg3.CFrame = CFrame.lookAt(arg3.CFrame.Position, Vector3Value_8_upvr.Value, arg3.CFrame.UpVector) * arg7
				arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_8_upvr.Value
			end
			if arg1 < var134_upvw then
				if arg8 then
					arg8()
				end
				var138_upvw:Disconnect()
				var138_upvw = nil
				Debris_upvr:AddItem(Vector3Value_8_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesFrontLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 847
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_18_upvr = Instance.new("Vector3Value")
	Vector3Value_18_upvr.Parent = arg3
	Vector3Value_18_upvr.Value = Vector3.new(0, 0, 0)
	local var146_upvw
	if typeof(arg4) ~= "Vector3" then
		var146_upvw = var146_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var148_upvw = 0
	local var149_upvw = 0
	local var150_upvr = 1 / arg2
	local Position_upvw_3 = arg5.Position
	local Position_3_upvw = arg6.Position
	local var153_upvw
	var153_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_14) -- Line 869
		--[[ Upvalues[14]:
			[1]: var148_upvw (read and write)
			[2]: var149_upvw (read and write)
			[3]: var150_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var146_upvw (read and write)
			[7]: Position_upvw_3 (read and write)
			[8]: Position_3_upvw (read and write)
			[9]: Vector3Value_18_upvr (readonly)
			[10]: arg3 (readonly)
			[11]: arg7 (readonly)
			[12]: arg8 (readonly)
			[13]: var153_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var148_upvw += arg1_14
		if var148_upvw < var149_upvw * var150_upvr then
		else
			if var149_upvw * var150_upvr <= var148_upvw then
				var149_upvw += 1
				local var154 = var149_upvw / arg1
				Vector3Value_18_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var146_upvw, Position_upvw_3, var154), module_upvr.Lerp(Position_upvw_3, Position_3_upvw, var154), var154)
				arg3:PivotTo(CFrame.lookAt(arg3:GetPivot().Position, Vector3Value_18_upvr.Value, Vector3.new(0, 1, 0)) * arg7)
				arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_18_upvr.Value)
			end
			if arg1 < var149_upvw then
				if arg8 then
					arg8()
				end
				var153_upvw:Disconnect()
				var153_upvw = nil
				Debris_upvr:AddItem(Vector3Value_18_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesRotate(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13) -- Line 906
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: CustomCurve_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_2_upvr = Instance.new("Vector3Value")
	Vector3Value_2_upvr.Parent = arg3
	Vector3Value_2_upvr.Value = Vector3.new(0, 0, 0)
	local var156_upvw
	if not arg12 then
	end
	if not arg13 then
	end
	if not arg11 then
	end
	if not var156_upvw then
		var156_upvw = Enum.EasingStyle.Linear
	end
	if typeof(arg4) ~= "Vector3" then
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if not arg9 then
	end
	local var158_upvw = 0
	local var159_upvw = 0
	local var160_upvr = 1 / arg2
	local In_upvw = Enum.EasingDirection.In
	local const_number_upvw_4 = 0
	local const_number_upvw_5 = 1
	local Position_2_upvw = arg4.Position
	local Position_20_upvw = arg5.Position
	local Position_35_upvw = arg6.Position
	local const_vector_upvw = Vector3.new(0, 0, 0)
	local var168_upvw
	var168_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_15) -- Line 946
		--[[ Upvalues[20]:
			[1]: var158_upvw (read and write)
			[2]: var159_upvw (read and write)
			[3]: var160_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: CustomCurve_upvr (copied, readonly)
			[6]: var156_upvw (read and write)
			[7]: In_upvw (read and write)
			[8]: const_number_upvw_4 (read and write)
			[9]: const_number_upvw_5 (read and write)
			[10]: module_upvr (copied, readonly)
			[11]: Position_2_upvw (read and write)
			[12]: Position_20_upvw (read and write)
			[13]: Position_35_upvw (read and write)
			[14]: Vector3Value_2_upvr (readonly)
			[15]: arg3 (readonly)
			[16]: const_vector_upvw (read and write)
			[17]: arg7 (readonly)
			[18]: var168_upvw (read and write)
			[19]: Debris_upvr (copied, readonly)
			[20]: arg8 (readonly)
		]]
		var158_upvw += arg1_15
		if var158_upvw < var159_upvw * var160_upvr then
		else
			if var159_upvw * var160_upvr <= var158_upvw then
				var159_upvw += 1
				local any_GetCustomEasingValue_result1 = CustomCurve_upvr.GetCustomEasingValue(var159_upvw / arg1, var156_upvw, In_upvw, const_number_upvw_4, const_number_upvw_5)
				Vector3Value_2_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(Position_2_upvw, Position_20_upvw, any_GetCustomEasingValue_result1), module_upvr.Lerp(Position_20_upvw, Position_35_upvw, any_GetCustomEasingValue_result1), any_GetCustomEasingValue_result1)
				arg3:PivotTo((arg3:GetPivot().Rotation + Vector3Value_2_upvr.Value) * CFrame.Angles(math.rad(const_vector_upvw.X * arg1_15), math.rad(const_vector_upvw.Y * arg1_15), math.rad(const_vector_upvw.Z * arg1_15)) * arg7)
			end
			if arg1 < var159_upvw then
				var168_upvw:Disconnect()
				var168_upvw = nil
				Debris_upvr:AddItem(Vector3Value_2_upvr, task.wait())
				if arg8 then
					arg8()
				end
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesRotateAimObject(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Line 985
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_4_upvr = Instance.new("Vector3Value")
	Vector3Value_4_upvr.Parent = arg3
	Vector3Value_4_upvr.Value = Vector3.new(0, 0, 0)
	local var172_upvw
	if typeof(arg4) ~= "Vector3" then
		var172_upvw = var172_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if not arg9 then
	end
	local var174_upvw = 0
	local var175_upvw = 0
	local var176_upvr = 1 / arg2
	local Position_17_upvw = arg5.Position
	local const_number_upvw_3 = 3600
	local var179_upvw
	var179_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_16) -- Line 1008
		--[[ Upvalues[16]:
			[1]: var174_upvw (read and write)
			[2]: var175_upvw (read and write)
			[3]: var176_upvr (readonly)
			[4]: arg6 (readonly)
			[5]: arg1 (readonly)
			[6]: arg10 (readonly)
			[7]: module_upvr (copied, readonly)
			[8]: var172_upvw (read and write)
			[9]: Position_17_upvw (read and write)
			[10]: Vector3Value_4_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: const_number_upvw_3 (read and write)
			[13]: arg7 (readonly)
			[14]: var179_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
			[16]: arg8 (readonly)
		]]
		var174_upvw += arg1_16
		if var174_upvw < var175_upvw * var176_upvr then
		else
			if var175_upvw * var176_upvr <= var174_upvw and arg6 then
				var175_upvw += 1
				local var180 = var175_upvw / arg1
				local var181 = arg6.Position + arg10
				local any_Lerp_result1_13 = module_upvr.Lerp(Position_17_upvw, var181, var180)
				Vector3Value_4_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var172_upvw, Position_17_upvw, var180), any_Lerp_result1_13, var180)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_4_upvr.Value)
					arg3:PivotTo(arg3:GetPivot() * CFrame.Angles(math.rad(const_number_upvw_3 * arg1_16), 0, 0) * arg7)
				end
				if arg3:IsA("BasePart") then
					arg3:PivotTo(CFrame.lookAt(Vector3Value_4_upvr.Value, (any_Lerp_result1_13 + Vector3Value_4_upvr.Value) / 2, (Position_17_upvw - (var181 + var172_upvw) / 2).Unit))
					arg3:PivotTo((arg3:GetPivot().Rotation + Vector3Value_4_upvr.Value) * CFrame.Angles(math.rad(const_number_upvw_3 * var174_upvw), 0, 0) * arg7)
				end
			end
			if arg1 < var175_upvw or not arg6 then
				var179_upvw:Disconnect()
				var179_upvw = nil
				Debris_upvr:AddItem(Vector3Value_4_upvr, task.wait())
				if arg8 then
					arg8()
				end
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesFollow(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 1058
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_16_upvr = Instance.new("Vector3Value")
	Vector3Value_16_upvr.Parent = arg3
	Vector3Value_16_upvr.Value = Vector3.new(0, 0, 0)
	local var184_upvw
	if typeof(arg4) ~= "Vector3" then
		var184_upvw = var184_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if typeof(arg7) ~= "Vector3" then
	end
	local var186_upvw = 0
	local var187_upvw = 0
	local var188_upvw
	local var189_upvr = 1 / arg2
	local Position_32_upvw = arg5.Position
	local Position_upvw_5 = arg6.Position
	local Position_14_upvw = arg7.Position
	var188_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_17) -- Line 1085
		--[[ Upvalues[15]:
			[1]: var186_upvw (read and write)
			[2]: var187_upvw (read and write)
			[3]: arg1 (readonly)
			[4]: arg9 (readonly)
			[5]: var188_upvw (read and write)
			[6]: Debris_upvr (copied, readonly)
			[7]: Vector3Value_16_upvr (readonly)
			[8]: var189_upvr (readonly)
			[9]: module_upvr (copied, readonly)
			[10]: var184_upvw (read and write)
			[11]: Position_32_upvw (read and write)
			[12]: Position_upvw_5 (read and write)
			[13]: Position_14_upvw (read and write)
			[14]: arg3 (readonly)
			[15]: arg8 (readonly)
		]]
		var186_upvw += arg1_17
		if arg1 <= var187_upvw or not arg9 then
			var188_upvw:Disconnect()
			var188_upvw = nil
			Debris_upvr:AddItem(Vector3Value_16_upvr, task.wait())
		end
		if var186_upvw < var187_upvw * var189_upvr then
		elseif var187_upvw * var189_upvr <= var186_upvw then
			var187_upvw += 1
			local var193 = var187_upvw / arg1
			local any_Lerp_result1_11 = module_upvr.Lerp(Position_32_upvw, Position_upvw_5, var193)
			Vector3Value_16_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var184_upvw, Position_32_upvw, var193), any_Lerp_result1_11, var193), module_upvr.Lerp(any_Lerp_result1_11, module_upvr.Lerp(Position_upvw_5, Position_14_upvw, var193), var193), var193)
			arg3.CFrame = CFrame.lookAt(Vector3Value_16_upvr.Value + arg9.Position - arg8, Vector3Value_16_upvr.Value, Vector3.new(0, 1, 0))
		end
	end)
end
function module_upvr.CubicBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 1124
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_10_upvr = Instance.new("Vector3Value")
	Vector3Value_10_upvr.Parent = arg3
	Vector3Value_10_upvr.Value = Vector3.new(0, 0, 0)
	local var196_upvw
	if typeof(arg4) ~= "Vector3" then
		var196_upvw = var196_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if typeof(arg7) ~= "Vector3" then
	end
	local var198_upvw = 0
	local var199_upvw = 0
	local var200_upvr = 1 / arg2
	local Position_25_upvw = arg5.Position
	local Position_upvw_6 = arg6.Position
	local Position_26_upvw = arg7.Position
	local var204_upvw
	var204_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_18) -- Line 1152
		--[[ Upvalues[14]:
			[1]: var198_upvw (read and write)
			[2]: var199_upvw (read and write)
			[3]: var200_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var196_upvw (read and write)
			[7]: Position_25_upvw (read and write)
			[8]: Position_upvw_6 (read and write)
			[9]: Position_26_upvw (read and write)
			[10]: Vector3Value_10_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: arg8 (readonly)
			[13]: var204_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var198_upvw += arg1_18
		if var198_upvw < var199_upvw * var200_upvr then
		else
			if var199_upvw * var200_upvr <= var198_upvw then
				var199_upvw += 1
				local var205 = var199_upvw / arg1
				local any_Lerp_result1_12 = module_upvr.Lerp(Position_25_upvw, Position_upvw_6, var205)
				Vector3Value_10_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var196_upvw, Position_25_upvw, var205), any_Lerp_result1_12, var205), module_upvr.Lerp(any_Lerp_result1_12, module_upvr.Lerp(Position_upvw_6, Position_26_upvw, var205), var205), var205)
				arg3.CFrame = CFrame.lookAt(arg3.Position, Vector3Value_10_upvr.Value, Vector3.new(0, 1, 0)) * arg8
				arg3.Position = Vector3Value_10_upvr.Value
			end
			if arg1 < var199_upvw then
				var204_upvw:Disconnect()
				var204_upvw = nil
				Debris_upvr:AddItem(Vector3Value_10_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesCameraLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 1219
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_14_upvr = Instance.new("Vector3Value")
	Vector3Value_14_upvr.Parent = arg3
	Vector3Value_14_upvr.Value = Vector3.new(0, 0, 0)
	local var208_upvw
	if typeof(arg4) ~= "Vector3" then
		var208_upvw = var208_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var210_upvw = 0
	local var211_upvw = 0
	local var212_upvr = 1 / arg2
	local Position_27_upvw = arg5.Position
	local Position_upvw_2 = arg6.Position
	local var215_upvw
	var215_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_19) -- Line 1241
		--[[ Upvalues[15]:
			[1]: var210_upvw (read and write)
			[2]: var211_upvw (read and write)
			[3]: var212_upvr (readonly)
			[4]: arg8 (readonly)
			[5]: arg1 (readonly)
			[6]: module_upvr (copied, readonly)
			[7]: var208_upvw (read and write)
			[8]: Position_27_upvw (read and write)
			[9]: Position_upvw_2 (read and write)
			[10]: Vector3Value_14_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: arg7 (readonly)
			[13]: arg9 (readonly)
			[14]: var215_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
		]]
		var210_upvw += arg1_19
		if var210_upvw < var211_upvw * var212_upvr then
		else
			if var211_upvw * var212_upvr <= var210_upvw and arg8 then
				var211_upvw += 1
				local var216 = var211_upvw / arg1
				Vector3Value_14_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var208_upvw, Position_27_upvw, var216), module_upvr.Lerp(Position_27_upvw, Position_upvw_2, var216), var216)
				arg3.CFrame = CFrame.lookAt(arg3.CFrame.Position, arg8.Position, Vector3.new(0, 1, 0)) * arg7
				arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_14_upvr.Value
			end
			if arg1 < var211_upvw or not arg8 then
				if arg9 then
					arg9()
				end
				var215_upvw:Disconnect()
				var215_upvw = nil
				Debris_upvr:AddItem(Vector3Value_14_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.LineCurvesRotate(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 1278
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_15_upvr = Instance.new("Vector3Value")
	Vector3Value_15_upvr.Parent = arg3
	Vector3Value_15_upvr.Value = Vector3.new(0, 0, 0)
	local var218_upvw
	if typeof(arg4) ~= "Vector3" then
		var218_upvw = var218_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if not arg6 then
	end
	local var220_upvw = 0
	local var221_upvw = 0
	local var222_upvr = 1 / arg2
	local Position_33_upvw = arg5.Position
	local var224_upvw = 3600
	local var225_upvw
	var225_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_20) -- Line 1301
		--[[ Upvalues[13]:
			[1]: var220_upvw (read and write)
			[2]: var221_upvw (read and write)
			[3]: var222_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var218_upvw (read and write)
			[7]: Position_33_upvw (read and write)
			[8]: Vector3Value_15_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var224_upvw (read and write)
			[11]: var225_upvw (read and write)
			[12]: Debris_upvr (copied, readonly)
			[13]: arg7 (readonly)
		]]
		var220_upvw += arg1_20
		if var220_upvw < var221_upvw * var222_upvr then
		else
			if var221_upvw * var222_upvr <= var220_upvw then
				var221_upvw += 1
				Vector3Value_15_upvr.Value = module_upvr.Lerp(var218_upvw, Position_33_upvw, var221_upvw / arg1)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_15_upvr.Value)
					arg3:PivotTo(arg3:GetPivot() * CFrame.Angles(math.rad(var224_upvw * arg1_20), 0, 0))
				end
				if arg3:IsA("BasePart") then
					arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_15_upvr.Value
					arg3.CFrame *= CFrame.Angles(math.rad(var224_upvw * arg1_20), 0, 0)
				end
			end
			if arg1 < var221_upvw then
				var225_upvw:Disconnect()
				var225_upvw = nil
				Debris_upvr:AddItem(Vector3Value_15_upvr, task.wait())
				if arg7 then
					arg7()
				end
			end
		end
	end)
end
function module_upvr.LineCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 1346
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_11_upvr = Instance.new("Vector3Value")
	Vector3Value_11_upvr.Parent = arg3
	Vector3Value_11_upvr.Value = Vector3.new(0, 0, 0)
	local var227_upvw
	if typeof(arg4) ~= "Vector3" then
		var227_upvw = var227_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var229_upvw = 0
	local var230_upvw = 0
	local var231_upvr = 1 / arg2
	local Position_24_upvw = arg5.Position
	local var233_upvw
	var233_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_21) -- Line 1364
		--[[ Upvalues[12]:
			[1]: var229_upvw (read and write)
			[2]: var230_upvw (read and write)
			[3]: var231_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var227_upvw (read and write)
			[7]: Position_24_upvw (read and write)
			[8]: Vector3Value_11_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var233_upvw (read and write)
			[11]: Debris_upvr (copied, readonly)
			[12]: arg6 (readonly)
		]]
		var229_upvw += arg1_21
		if var229_upvw < var230_upvw * var231_upvr then
		else
			if var230_upvw * var231_upvr <= var229_upvw then
				var230_upvw += 1
				Vector3Value_11_upvr.Value = module_upvr.Lerp(var227_upvw, Position_24_upvw, var230_upvw / arg1)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_11_upvr.Value)
					arg3:PivotTo(arg3:GetPivot())
				end
				if arg3:IsA("BasePart") then
					arg3:PivotTo(CFrame.lookAt(arg3:GetPivot().Position, Vector3Value_11_upvr.Value).Rotation + Vector3Value_11_upvr.Value)
				end
			end
			if arg1 < var230_upvw then
				var233_upvw:Disconnect()
				var233_upvw = nil
				Debris_upvr:AddItem(Vector3Value_11_upvr, task.wait())
				if arg6 then
					arg6()
				end
			end
		end
	end)
end
function module_upvr.LineCurves(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 1409
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_13_upvr = Instance.new("Vector3Value")
	Vector3Value_13_upvr.Parent = arg3
	Vector3Value_13_upvr.Value = Vector3.new(0, 0, 0)
	local var235_upvw
	if typeof(arg4) ~= "Vector3" then
		var235_upvw = var235_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var237_upvw = 0
	local var238_upvw = 0
	local var239_upvr = 1 / arg2
	local Position_upvw = arg5.Position
	local var241_upvw
	var241_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_22) -- Line 1427
		--[[ Upvalues[12]:
			[1]: var237_upvw (read and write)
			[2]: var238_upvw (read and write)
			[3]: var239_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var235_upvw (read and write)
			[7]: Position_upvw (read and write)
			[8]: Vector3Value_13_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var241_upvw (read and write)
			[11]: Debris_upvr (copied, readonly)
			[12]: arg6 (readonly)
		]]
		var237_upvw += arg1_22
		if var237_upvw < var238_upvw * var239_upvr then
		else
			if var238_upvw * var239_upvr <= var237_upvw then
				var238_upvw += 1
				Vector3Value_13_upvr.Value = module_upvr.Lerp(var235_upvw, Position_upvw, var238_upvw / arg1)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_13_upvr.Value)
				end
				if arg3:IsA("BasePart") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_13_upvr.Value)
				end
			end
			if arg1 < var238_upvw then
				var241_upvw:Disconnect()
				var241_upvw = nil
				Debris_upvr:AddItem(Vector3Value_13_upvr, task.wait())
				if arg6 then
					arg6()
				end
			end
		end
	end)
end
function module_upvr.LineCurvesAimObject(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 1471
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local Vector3Value_12_upvr = Instance.new("Vector3Value")
	Vector3Value_12_upvr.Parent = arg3
	Vector3Value_12_upvr.Value = Vector3.new(0, 0, 0)
	local var243_upvw
	if typeof(arg4) ~= "Vector3" then
		var243_upvw = var243_upvw.Position
	end
	local var245_upvw = 0
	local var246_upvw = 0
	local var247_upvr = 1 / arg2
	local var248_upvw
	var248_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_23) -- Line 1487
		--[[ Upvalues[12]:
			[1]: var245_upvw (read and write)
			[2]: var246_upvw (read and write)
			[3]: var247_upvr (readonly)
			[4]: arg5 (readonly)
			[5]: arg1 (readonly)
			[6]: module_upvr (copied, readonly)
			[7]: var243_upvw (read and write)
			[8]: Vector3Value_12_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var248_upvw (read and write)
			[11]: Debris_upvr (copied, readonly)
			[12]: arg6 (readonly)
		]]
		var245_upvw += arg1_23
		if var245_upvw < var246_upvw * var247_upvr then
		else
			if var246_upvw * var247_upvr <= var245_upvw and arg5 then
				var246_upvw += 1
				Vector3Value_12_upvr.Value = module_upvr.Lerp(var243_upvw, arg5.Position, var246_upvw / arg1)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_12_upvr.Value)
					arg3:PivotTo(arg3:GetPivot())
				end
				if arg3:IsA("BasePart") then
					arg3:PivotTo(CFrame.lookAt(arg3:GetPivot().Position, Vector3Value_12_upvr.Value).Rotation + Vector3Value_12_upvr.Value)
				end
			end
			if arg1 < var246_upvw or not arg5 then
				var248_upvw:Disconnect()
				var248_upvw = nil
				Debris_upvr:AddItem(Vector3Value_12_upvr, task.wait())
				if arg6 then
					arg6()
				end
			end
		end
	end)
end
function module_upvr.WarpCurves(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 1532
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_5_upvr = Instance.new("Vector3Value")
	Vector3Value_5_upvr.Parent = arg3
	Vector3Value_5_upvr.Value = Vector3.new(0, 0, 0)
	local var250_upvw
	if typeof(arg4) ~= "Vector3" then
		var250_upvw = var250_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var252_upvw = 0
	local var253_upvw = 0
	local var254_upvr = 1 / arg2
	local Position_5_upvw = arg5.Position
	local var256_upvw
	var256_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_24) -- Line 1550
		--[[ Upvalues[12]:
			[1]: var252_upvw (read and write)
			[2]: var253_upvw (read and write)
			[3]: var254_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var250_upvw (read and write)
			[7]: Position_5_upvw (read and write)
			[8]: Vector3Value_5_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var256_upvw (read and write)
			[11]: Debris_upvr (copied, readonly)
			[12]: arg6 (readonly)
		]]
		var252_upvw += arg1_24
		if var252_upvw < var253_upvw * var254_upvr then
		else
			if var253_upvw * var254_upvr <= var252_upvw then
				var253_upvw += 1
				Vector3Value_5_upvr.Value = module_upvr.Lerp(var250_upvw, Position_5_upvw, var253_upvw / arg1)
				local var259 = 1 + math.random()
				local cframe_looking_at = CFrame.lookAt(Vector3.new(var259 * (1 - 2 * math.random()), var259 * (1 - 2 * math.random()), var259 * (1 - 2 * math.random())), Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()))
				if arg3:IsA("Model") then
					arg3:PivotTo((arg3:GetPivot().Rotation + Vector3Value_5_upvr.Value) * cframe_looking_at)
				end
				if arg3:IsA("BasePart") then
					arg3:PivotTo((arg3:GetPivot().Rotation + Vector3Value_5_upvr.Value) * cframe_looking_at)
				end
			end
			if arg1 < var253_upvw then
				var256_upvw:Disconnect()
				var256_upvw = nil
				Debris_upvr:AddItem(Vector3Value_5_upvr, task.wait())
				if arg6 then
					arg6()
				end
			end
		end
	end)
end
function module_upvr.LineCurvesLookAtUpper(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 1598
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_upvr = Instance.new("Vector3Value")
	Vector3Value_upvr.Parent = arg3
	Vector3Value_upvr.Value = Vector3.new(0, 0, 0)
	local var262_upvw
	if typeof(arg4) ~= "Vector3" then
		var262_upvw = var262_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var264_upvw = 0
	local var265_upvw = 0
	local var266_upvr = 1 / arg2
	local Position_21_upvw = arg5.Position
	local var268_upvw
	var268_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_25) -- Line 1616
		--[[ Upvalues[12]:
			[1]: var264_upvw (read and write)
			[2]: var265_upvw (read and write)
			[3]: var266_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var262_upvw (read and write)
			[7]: Position_21_upvw (read and write)
			[8]: Vector3Value_upvr (readonly)
			[9]: arg3 (readonly)
			[10]: var268_upvw (read and write)
			[11]: Debris_upvr (copied, readonly)
			[12]: arg6 (readonly)
		]]
		var264_upvw += arg1_25
		if var264_upvw < var265_upvw * var266_upvr then
		else
			if var265_upvw * var266_upvr <= var264_upvw then
				var265_upvw += 1
				Vector3Value_upvr.Value = module_upvr.Lerp(var262_upvw, Position_21_upvw, var265_upvw / arg1)
				arg3:PivotTo(CFrame.lookAt(arg3:GetPivot().Position, Vector3Value_upvr.Value, Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()).Unit).Rotation + Vector3Value_upvr.Value)
			end
			if arg1 < var265_upvw then
				var268_upvw:Disconnect()
				var268_upvw = nil
				Debris_upvr:AddItem(Vector3Value_upvr, task.wait())
				if arg6 then
					arg6()
				end
			end
		end
	end)
end
local RayCast_upvr = require(game.ReplicatedStorage["特效表现工具"].RayCast)
function module_upvr.QuadraticBezierCurves_Kick(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 1655
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: RayCast_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var270_upvw
	if typeof(arg4) ~= "Vector3" then
		var270_upvw = var270_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var272_upvw = 0
	local var273_upvw = 0
	local var274_upvr = 1 / arg2
	local var275_upvw = false
	local Position_19_upvw = arg5.Position
	local Position_16_upvw = arg6.Position
	local var278_upvw
	local var279_upvw
	local var280_upvw
	var280_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_26) -- Line 1679
		--[[ Upvalues[16]:
			[1]: var272_upvw (read and write)
			[2]: arg7 (readonly)
			[3]: var273_upvw (read and write)
			[4]: var274_upvr (readonly)
			[5]: arg1 (readonly)
			[6]: var275_upvw (read and write)
			[7]: module_upvr (copied, readonly)
			[8]: var270_upvw (read and write)
			[9]: Position_19_upvw (read and write)
			[10]: Position_16_upvw (read and write)
			[11]: arg3 (readonly)
			[12]: RayCast_upvr (copied, readonly)
			[13]: var278_upvw (read and write)
			[14]: var279_upvw (read and write)
			[15]: arg8 (readonly)
			[16]: var280_upvw (read and write)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 52 start (CF ANALYSIS FAILED)
		var272_upvw += arg1_26
		if arg7 then
			arg7()
		end
		if var272_upvw < var273_upvw * var274_upvr then
		else
			if var273_upvw * var274_upvr <= var272_upvw and var273_upvw < arg1 and not var275_upvw then
				var273_upvw += 1
				local var281 = var273_upvw / arg1
				local any_Lerp_result1_8 = module_upvr.Lerp(module_upvr.Lerp(var270_upvw, Position_19_upvw, var281), module_upvr.Lerp(Position_19_upvw, Position_16_upvw, var281), var281)
				local any_GetPivot_result1 = arg3:GetPivot()
				if RayCast_upvr.RayToDir(CFrame.new(any_Lerp_result1_8), Vector3.new(0, -1, 0), 2) then
					var275_upvw = true
				end
				if RayCast_upvr.RayToDir(any_GetPivot_result1, (any_Lerp_result1_8 - any_GetPivot_result1.Position).Unit, 4) then
					var275_upvw = true
				end
				arg3:PivotTo(arg3:GetPivot().Rotation + any_Lerp_result1_8)
				if var275_upvw then
					local any_RayToDir_result1 = RayCast_upvr.RayToDir(any_GetPivot_result1, Vector3.new(0, -1, 0), 500)
					if any_RayToDir_result1 then
						var278_upvw = any_RayToDir_result1.Position + Vector3.new(0, 2, 0)
					end
					var279_upvw = any_GetPivot_result1
					-- KONSTANTWARNING: GOTO [226] #179
				end
				-- KONSTANTWARNING: GOTO [226] #179
			end
			-- KONSTANTERROR: [0] 1. Error Block 52 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [113] 97. Error Block 53 start (CF ANALYSIS FAILED)
			var273_upvw += 1
			if not var275_upvw then
				if arg3.PrimaryPart and arg3.PrimaryPart:GetAttribute("NetWorkOwner") and arg3.PrimaryPart:GetAttribute("NetWorkOwner") == game.Players.LocalPlayer.UserId then
					arg3:PivotTo(arg3:GetPivot())
					-- KONSTANTWARNING: GOTO [226] #179
				end
			elseif var279_upvw and var278_upvw and arg3.PrimaryPart and arg3.PrimaryPart:GetAttribute("NetWorkOwner") and arg3.PrimaryPart:GetAttribute("NetWorkOwner") == game.Players.LocalPlayer.UserId then
				arg3:PivotTo(var279_upvw:Lerp(var279_upvw.Rotation + var278_upvw, game.TweenService:GetValue(math.clamp((var273_upvw - arg1) / 50, 0, 1), Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)))
			end
			if arg1 + 60 < var273_upvw then
				if arg8 then
					arg8()
				end
				var280_upvw:Disconnect()
				var280_upvw = nil
			end
			-- KONSTANTERROR: [113] 97. Error Block 53 end (CF ANALYSIS FAILED)
		end
	end)
end
return module_upvr