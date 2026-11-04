-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:02
-- Luau version 6, Types version 3
-- Time taken: 0.017758 seconds

local Debris_upvr = game:GetService("Debris")
local RunService_upvr = game:GetService("RunService")
local module_upvr = {
	Lerp = function(arg1, arg2, arg3) -- Line 7, Named "Lerp"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var4
		if typeof(arg1) ~= "Vector3" then
			local Position_19 = arg1.Position
		end
		if typeof(var4) ~= "Vector3" then
			var4 = var4.Position
		end
		return Position_19 + (var4 - Position_19) * arg3
	end;
	GetFrameByDistance = function(arg1, arg2, arg3) -- Line 21, Named "GetFrameByDistance"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var6
		if typeof(arg1) ~= "Vector3" then
			var6 = var6.Position
		end
		if typeof(arg2) ~= "Vector3" then
		end
		if not arg3 then
		else
		end
		return math.round((var6 - arg2.Position).Magnitude * 2 / (1 + 1))
	end;
	GetMotionTime = function(arg1, arg2) -- Line 44, Named "GetMotionTime"
		return 0 + task.wait(1 / arg2) * arg1
	end;
	GetMiddlePosition = function(arg1, arg2, arg3, arg4) -- Line 52, Named "GetMiddlePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var8
		if typeof(arg1) ~= "Vector3" then
			var8 = var8.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position_7 = arg2.Position
		end
		if not arg3 then
		end
		if not arg4 then
		end
		local var10 = (var8 - Position_7) * 0.5
		local var11 = var8 - var10
		return var11 + ((CFrame.new(var11, Position_7) * CFrame.Angles(0, 0, math.rad(0))).UpVector) * (var10.Magnitude * 1)
	end;
	Get2MiddlePosition = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 85, Named "Get2MiddlePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var12
		if typeof(arg1) ~= "Vector3" then
			var12 = var12.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position_18 = arg2.Position
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
		local function GetResultPosition(arg1_2, arg2_2, arg3_2, arg4_2, arg5_2) -- Line 123
			local var14 = arg1_2 - (arg1_2 - arg2_2) * arg5_2
			return var14 + (CFrame.new(var14, arg2_2) * CFrame.Angles(0, 0, math.rad(arg3_2))).UpVector * arg4_2
		end
		local var15 = var12
		local var16 = Position_18
		local var17 = var15 - (var15 - var16) * 0.5
		local var18 = var12
		local var19 = Position_18
		local var20 = var18 - (var18 - var19) * 0.5
		return var17 + (CFrame.new(var17, var16) * CFrame.Angles(0, 0, math.rad(0))).UpVector * 1, var20 + (CFrame.new(var20, var19) * CFrame.Angles(0, 0, math.rad(0))).UpVector * 1
	end;
	Get2SquarePosition = function(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 146, Named "Get2SquarePosition"
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var21
		if typeof(arg1) ~= "Vector3" then
			var21 = var21.Position
		end
		if typeof(arg2) ~= "Vector3" then
			local Position = arg2.Position
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
		local function _(arg1_3, arg2_3, arg3_3, arg4_3, arg5_3) -- Line 176, Named "GetResultPosition"
			local var24 = (arg1_3 - arg2_3) * arg5_3
			local var25 = arg1_3 - var24
			return var25 + ((CFrame.new(var25, arg2_3) * CFrame.Angles(0, 0, math.rad(arg3_3))).UpVector) * (var24.Magnitude * arg4_3)
		end
		local var26 = var21
		local var27 = Position
		local var28 = (var26 - var27) * 0.2
		local var29 = var26 - var28
		local var30 = var21
		local var31 = Position
		local var32 = (var30 - var31) * 0.8
		local var33 = var30 - var32
		return var29 + ((CFrame.new(var29, var27) * CFrame.Angles(0, 0, math.rad(0))).UpVector) * (var28.Magnitude * (1 + 1)), var33 + ((CFrame.new(var33, var31) * CFrame.Angles(0, 0, math.rad(0))).UpVector) * (var32.Magnitude * (1 + 1))
	end;
}
function module_upvr.LinearBezierCurves(arg1, arg2, arg3, arg4, arg5) -- Line 200
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
	local Position_26_upvw = arg5.Position
	local var40_upvw
	var40_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_4) -- Line 215
		--[[ Upvalues[9]:
			[1]: var36_upvw (read and write)
			[2]: var37_upvw (read and write)
			[3]: var38_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var34_upvw (read and write)
			[7]: Position_26_upvw (read and write)
			[8]: arg3 (readonly)
			[9]: var40_upvw (read and write)
		]]
		var36_upvw += arg1_4
		if var36_upvw < var37_upvw * var38_upvr then
		else
			if var37_upvw * var38_upvr <= var36_upvw then
				var37_upvw += 1
				arg3.Position = module_upvr.Lerp(var34_upvw, Position_26_upvw, var37_upvw / arg1)
			end
			if arg1 <= var37_upvw then
				var40_upvw:Disconnect()
				var40_upvw = nil
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurves(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 256
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
	local Position_4_upvw = arg5.Position
	local Position_13_upvw = arg6.Position
	local var48_upvw
	var48_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_5) -- Line 275
		--[[ Upvalues[11]:
			[1]: var43_upvw (read and write)
			[2]: var44_upvw (read and write)
			[3]: var45_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var41_upvw (read and write)
			[7]: Position_4_upvw (read and write)
			[8]: Position_13_upvw (read and write)
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
				arg3:PivotTo(arg3:GetPivot().Rotation + module_upvr.Lerp(module_upvr.Lerp(var41_upvw, Position_4_upvw, var50), module_upvr.Lerp(Position_4_upvw, Position_13_upvw, var50), var50))
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
function module_upvr.QuadraticBezierCurvesObjectGoal(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 308
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
	local Position_8_upvw = arg6:GetPivot().Position
	local Position_24_upvw = arg5.Position
	local var58_upvw
	var58_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_6) -- Line 325
		--[[ Upvalues[13]:
			[1]: var53_upvw (read and write)
			[2]: var54_upvw (read and write)
			[3]: var55_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: Position_8_upvw (read and write)
			[6]: arg6 (readonly)
			[7]: arg7 (readonly)
			[8]: module_upvr (copied, readonly)
			[9]: var51_upvw (read and write)
			[10]: Position_24_upvw (read and write)
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
				Position_8_upvw = arg6:GetPivot().Position + arg7
				arg3:PivotTo(arg3:GetPivot().Rotation + module_upvr.Lerp(module_upvr.Lerp(var51_upvw, Position_24_upvw, var59), module_upvr.Lerp(Position_24_upvw, Position_8_upvw, var59), var59))
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
function module_upvr.CubicBezierCurves(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 360
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
	local Position_upvw_2 = arg5.Position
	local Position_22_upvw = arg6.Position
	local Position_3_upvw = arg7.Position
	local var68_upvw
	var68_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_7) -- Line 382
		--[[ Upvalues[11]:
			[1]: var62_upvw (read and write)
			[2]: var63_upvw (read and write)
			[3]: var64_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var60_upvw (read and write)
			[7]: Position_upvw_2 (read and write)
			[8]: Position_22_upvw (read and write)
			[9]: Position_3_upvw (read and write)
			[10]: arg3 (readonly)
			[11]: var68_upvw (read and write)
		]]
		var62_upvw += arg1_7
		if var62_upvw < var63_upvw * var64_upvr then
		else
			if var63_upvw * var64_upvr <= var62_upvw then
				var63_upvw += 1
				local var69 = var63_upvw / arg1
				local any_Lerp_result1 = module_upvr.Lerp(Position_upvw_2, Position_22_upvw, var69)
				arg3.Position = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var60_upvw, Position_upvw_2, var69), any_Lerp_result1, var69), module_upvr.Lerp(any_Lerp_result1, module_upvr.Lerp(Position_22_upvw, Position_3_upvw, var69), var69), var69)
			end
			if arg1 <= var63_upvw then
				var68_upvw:Disconnect()
				var68_upvw = nil
			end
		end
	end)
end
function module_upvr.LinearBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 436
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_8_upvr = Instance.new("Vector3Value")
	Vector3Value_8_upvr.Parent = arg3
	Vector3Value_8_upvr.Value = Vector3.new(0, 0, 0)
	local var72_upvw
	if typeof(arg4) ~= "Vector3" then
		var72_upvw = var72_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	local var74_upvw = 0
	local var75_upvw = 0
	local var76_upvr = 1 / arg2
	local Position_14_upvw = arg5.Position
	local var78_upvw
	var78_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_8) -- Line 454
		--[[ Upvalues[12]:
			[1]: var74_upvw (read and write)
			[2]: var75_upvw (read and write)
			[3]: var76_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: Vector3Value_8_upvr (readonly)
			[6]: module_upvr (copied, readonly)
			[7]: var72_upvw (read and write)
			[8]: Position_14_upvw (read and write)
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
				Vector3Value_8_upvr.Value = module_upvr.Lerp(var72_upvw, Position_14_upvw, var75_upvw / arg1)
				arg3.CFrame = CFrame.lookAt(arg3.Position, Vector3Value_8_upvr.Value, Vector3.new(0, 1, 0)) * arg6
				arg3.Position = Vector3Value_8_upvr.Value
			end
			if arg1 <= var75_upvw then
				var78_upvw:Disconnect()
				var78_upvw = nil
				Debris_upvr:AddItem(Vector3Value_8_upvr, task.wait())
			end
		end
	end)
end
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.QuadraticBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Line 485
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_5_upvr = Instance.new("Vector3Value")
	Vector3Value_5_upvr.Parent = arg3
	Vector3Value_5_upvr.Value = Vector3.new(0, 0, 0)
	local var81_upvw
	if typeof(arg4) ~= "Vector3" then
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if not var81_upvw then
		var81_upvw = Enum.EasingStyle.Linear
	end
	if not arg10 then
	end
	local var83_upvw = 0
	local var84_upvw = 0
	local var85_upvr = 1 / arg2
	local In_upvw = Enum.EasingDirection.In
	local Position_10_upvw = arg4.Position
	local Position_25_upvw = arg5.Position
	local Position_20_upvw = arg6.Position
	local var90_upvw
	var90_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_9) -- Line 515
		--[[ Upvalues[17]:
			[1]: var83_upvw (read and write)
			[2]: var84_upvw (read and write)
			[3]: var85_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: TweenService_upvr (copied, readonly)
			[6]: var81_upvw (read and write)
			[7]: In_upvw (read and write)
			[8]: module_upvr (copied, readonly)
			[9]: Position_10_upvw (read and write)
			[10]: Position_25_upvw (read and write)
			[11]: Position_20_upvw (read and write)
			[12]: Vector3Value_5_upvr (readonly)
			[13]: arg3 (readonly)
			[14]: arg7 (readonly)
			[15]: arg8 (readonly)
			[16]: var90_upvw (read and write)
			[17]: Debris_upvr (copied, readonly)
		]]
		var83_upvw += arg1_9
		if var83_upvw < var84_upvw * var85_upvr then
		else
			if var84_upvw * var85_upvr <= var83_upvw then
				var84_upvw += 1
				local any_GetValue_result1 = TweenService_upvr:GetValue(var84_upvw / arg1, var81_upvw, In_upvw)
				Vector3Value_5_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(Position_10_upvw, Position_25_upvw, any_GetValue_result1), module_upvr.Lerp(Position_25_upvw, Position_20_upvw, any_GetValue_result1), any_GetValue_result1)
				arg3.CFrame = CFrame.lookAt(arg3.CFrame.Position, Vector3Value_5_upvr.Value, arg3.CFrame.UpVector) * arg7
				arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_5_upvr.Value
			end
			if arg1 < var84_upvw then
				if arg8 then
					arg8()
				end
				var90_upvw:Disconnect()
				var90_upvw = nil
				Debris_upvr:AddItem(Vector3Value_5_upvr, task.wait())
			end
		end
	end)
end
local function EntiretyScale_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 554, Named "EntiretyScale"
	if not arg1:FindFirstChild("OriSize") then
		local Vector3Value = Instance.new("Vector3Value", arg1)
		Vector3Value.Name = "OriSize"
		Vector3Value.Value = arg1.Size
	end
	arg1.Size = (Vector3Value.Value) * ((1 - (arg5 - arg2.Position).Magnitude / (arg5 - arg4).Magnitude) * arg3)
end
function module_upvr.QuadraticBezierCurvesScaleChangeLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 570
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: EntiretyScale_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_3_upvr = Instance.new("Vector3Value")
	Vector3Value_3_upvr.Parent = arg3
	Vector3Value_3_upvr.Value = Vector3.new(0, 0, 0)
	local var94_upvw
	if typeof(arg4) ~= "Vector3" then
		var94_upvw = var94_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var96_upvw = 0
	local var97_upvw = 0
	local var98_upvr = 1 / arg2
	local Position_23_upvw = arg5.Position
	local Position_upvw_3 = arg6.Position
	local var101_upvw
	var101_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_10) -- Line 592
		--[[ Upvalues[15]:
			[1]: var96_upvw (read and write)
			[2]: var97_upvw (read and write)
			[3]: var98_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var94_upvw (read and write)
			[7]: Position_23_upvw (read and write)
			[8]: Position_upvw_3 (read and write)
			[9]: Vector3Value_3_upvr (readonly)
			[10]: arg3 (readonly)
			[11]: EntiretyScale_upvr (copied, readonly)
			[12]: arg7 (readonly)
			[13]: arg8 (readonly)
			[14]: var101_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
		]]
		var96_upvw += arg1_10
		if var96_upvw < var97_upvw * var98_upvr then
		else
			if var97_upvw * var98_upvr <= var96_upvw then
				var97_upvw += 1
				local var104 = var97_upvw / arg1
				Vector3Value_3_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var94_upvw, Position_23_upvw, var104), module_upvr.Lerp(Position_23_upvw, Position_upvw_3, var104), var104)
				for _, v in pairs(arg3:GetDescendants()) do
					if v:IsA("BasePart") then
						if v:GetAttribute("Scale") then
							EntiretyScale_upvr(v, arg3, v:GetAttribute("Scale"), var94_upvw, Position_upvw_3)
						end
					end
				end
				arg3.CFrame = CFrame.lookAt(arg3.CFrame.Position, Vector3Value_3_upvr.Value, arg3.CFrame.UpVector) * arg7
				arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_3_upvr.Value
			end
			if arg1 < var97_upvw then
				if arg8 then
					arg8()
				end
				var101_upvw:Disconnect()
				var101_upvw = nil
				Debris_upvr:AddItem(Vector3Value_3_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesFrontLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 640
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_6_upvr = Instance.new("Vector3Value")
	Vector3Value_6_upvr.Parent = arg3
	Vector3Value_6_upvr.Value = Vector3.new(0, 0, 0)
	local var109_upvw
	if typeof(arg4) ~= "Vector3" then
		var109_upvw = var109_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var111_upvw = 0
	local var112_upvw = 0
	local var113_upvr = 1 / arg2
	local Position_12_upvw = arg5.Position
	local Position_21_upvw = arg6.Position
	local var116_upvw
	var116_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_11) -- Line 662
		--[[ Upvalues[14]:
			[1]: var111_upvw (read and write)
			[2]: var112_upvw (read and write)
			[3]: var113_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var109_upvw (read and write)
			[7]: Position_12_upvw (read and write)
			[8]: Position_21_upvw (read and write)
			[9]: Vector3Value_6_upvr (readonly)
			[10]: arg3 (readonly)
			[11]: arg7 (readonly)
			[12]: arg8 (readonly)
			[13]: var116_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var111_upvw += arg1_11
		if var111_upvw < var112_upvw * var113_upvr then
		else
			if var112_upvw * var113_upvr <= var111_upvw then
				var112_upvw += 1
				local var117 = var112_upvw / arg1
				Vector3Value_6_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var109_upvw, Position_12_upvw, var117), module_upvr.Lerp(Position_12_upvw, Position_21_upvw, var117), var117)
				arg3:PivotTo(CFrame.lookAt(arg3:GetPivot().Position, Vector3Value_6_upvr.Value, Vector3.new(0, 1, 0)) * arg7)
				arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_6_upvr.Value)
			end
			if arg1 < var112_upvw then
				if arg8 then
					arg8()
				end
				var116_upvw:Disconnect()
				var116_upvw = nil
				Debris_upvr:AddItem(Vector3Value_6_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesRotate(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 699
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_4_upvr = Instance.new("Vector3Value")
	Vector3Value_4_upvr.Parent = arg3
	Vector3Value_4_upvr.Value = Vector3.new(0, 0, 0)
	local var119_upvw
	if typeof(arg4) ~= "Vector3" then
		var119_upvw = var119_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if not arg9 then
	end
	local var121_upvw = 0
	local var122_upvw = 0
	local var123_upvr = 1 / arg2
	local Position_2_upvw = arg5.Position
	local Position_11_upvw = arg6.Position
	local var126_upvw = 3600
	local var127_upvw
	var127_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_12) -- Line 725
		--[[ Upvalues[14]:
			[1]: var121_upvw (read and write)
			[2]: var122_upvw (read and write)
			[3]: var123_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var119_upvw (read and write)
			[7]: Position_2_upvw (read and write)
			[8]: Position_11_upvw (read and write)
			[9]: Vector3Value_4_upvr (readonly)
			[10]: arg3 (readonly)
			[11]: var126_upvw (read and write)
			[12]: var127_upvw (read and write)
			[13]: Debris_upvr (copied, readonly)
			[14]: arg8 (readonly)
		]]
		var121_upvw += arg1_12
		if var121_upvw < var122_upvw * var123_upvr then
		else
			if var122_upvw * var123_upvr <= var121_upvw then
				var122_upvw += 1
				local var129 = var122_upvw / arg1
				Vector3Value_4_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var119_upvw, Position_2_upvw, var129), module_upvr.Lerp(Position_2_upvw, Position_11_upvw, var129), var129)
				if arg3:IsA("Model") then
					arg3:PivotTo(arg3:GetPivot().Rotation + Vector3Value_4_upvr.Value)
					arg3:PivotTo(arg3:GetPivot() * CFrame.Angles(math.rad(var126_upvw * arg1_12), 0, 0))
				end
				if arg3:IsA("BasePart") then
					arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_4_upvr.Value
					arg3.CFrame *= CFrame.Angles(math.rad(var126_upvw * arg1_12), 0, 0)
				end
			end
			if arg1 < var122_upvw then
				var127_upvw:Disconnect()
				var127_upvw = nil
				Debris_upvr:AddItem(Vector3Value_4_upvr, task.wait())
				if arg8 then
					arg8()
				end
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesFollow(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 771
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_9_upvr = Instance.new("Vector3Value")
	Vector3Value_9_upvr.Parent = arg3
	Vector3Value_9_upvr.Value = Vector3.new(0, 0, 0)
	local var131_upvw
	if typeof(arg4) ~= "Vector3" then
		var131_upvw = var131_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if typeof(arg7) ~= "Vector3" then
	end
	local var133_upvw = 0
	local var134_upvw = 0
	local var135_upvw
	local var136_upvr = 1 / arg2
	local Position_17_upvw = arg5.Position
	local Position_upvw = arg6.Position
	local Position_16_upvw = arg7.Position
	var135_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_13) -- Line 798
		--[[ Upvalues[15]:
			[1]: var133_upvw (read and write)
			[2]: var134_upvw (read and write)
			[3]: arg1 (readonly)
			[4]: arg9 (readonly)
			[5]: var135_upvw (read and write)
			[6]: Debris_upvr (copied, readonly)
			[7]: Vector3Value_9_upvr (readonly)
			[8]: var136_upvr (readonly)
			[9]: module_upvr (copied, readonly)
			[10]: var131_upvw (read and write)
			[11]: Position_17_upvw (read and write)
			[12]: Position_upvw (read and write)
			[13]: Position_16_upvw (read and write)
			[14]: arg3 (readonly)
			[15]: arg8 (readonly)
		]]
		var133_upvw += arg1_13
		if arg1 <= var134_upvw or not arg9 then
			var135_upvw:Disconnect()
			var135_upvw = nil
			Debris_upvr:AddItem(Vector3Value_9_upvr, task.wait())
		end
		if var133_upvw < var134_upvw * var136_upvr then
		elseif var134_upvw * var136_upvr <= var133_upvw then
			var134_upvw += 1
			local var140 = var134_upvw / arg1
			local any_Lerp_result1_3 = module_upvr.Lerp(Position_17_upvw, Position_upvw, var140)
			Vector3Value_9_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var131_upvw, Position_17_upvw, var140), any_Lerp_result1_3, var140), module_upvr.Lerp(any_Lerp_result1_3, module_upvr.Lerp(Position_upvw, Position_16_upvw, var140), var140), var140)
			arg3.CFrame = CFrame.lookAt(Vector3Value_9_upvr.Value + arg9.Position - arg8, Vector3Value_9_upvr.Value, Vector3.new(0, 1, 0))
		end
	end)
end
function module_upvr.CubicBezierCurvesLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 837
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_7_upvr = Instance.new("Vector3Value")
	Vector3Value_7_upvr.Parent = arg3
	Vector3Value_7_upvr.Value = Vector3.new(0, 0, 0)
	local var143_upvw
	if typeof(arg4) ~= "Vector3" then
		var143_upvw = var143_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	if typeof(arg7) ~= "Vector3" then
	end
	local var145_upvw = 0
	local var146_upvw = 0
	local var147_upvr = 1 / arg2
	local Position_15_upvw = arg5.Position
	local Position_9_upvw = arg6.Position
	local Position_5_upvw = arg7.Position
	local var151_upvw
	var151_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_14) -- Line 865
		--[[ Upvalues[14]:
			[1]: var145_upvw (read and write)
			[2]: var146_upvw (read and write)
			[3]: var147_upvr (readonly)
			[4]: arg1 (readonly)
			[5]: module_upvr (copied, readonly)
			[6]: var143_upvw (read and write)
			[7]: Position_15_upvw (read and write)
			[8]: Position_9_upvw (read and write)
			[9]: Position_5_upvw (read and write)
			[10]: Vector3Value_7_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: arg8 (readonly)
			[13]: var151_upvw (read and write)
			[14]: Debris_upvr (copied, readonly)
		]]
		var145_upvw += arg1_14
		if var145_upvw < var146_upvw * var147_upvr then
		else
			if var146_upvw * var147_upvr <= var145_upvw then
				var146_upvw += 1
				local var152 = var146_upvw / arg1
				local any_Lerp_result1_2 = module_upvr.Lerp(Position_15_upvw, Position_9_upvw, var152)
				Vector3Value_7_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(module_upvr.Lerp(var143_upvw, Position_15_upvw, var152), any_Lerp_result1_2, var152), module_upvr.Lerp(any_Lerp_result1_2, module_upvr.Lerp(Position_9_upvw, Position_5_upvw, var152), var152), var152)
				arg3.CFrame = CFrame.lookAt(arg3.Position, Vector3Value_7_upvr.Value, Vector3.new(0, 1, 0)) * arg8
				arg3.Position = Vector3Value_7_upvr.Value
			end
			if arg1 < var146_upvw then
				var151_upvw:Disconnect()
				var151_upvw = nil
				Debris_upvr:AddItem(Vector3Value_7_upvr, task.wait())
			end
		end
	end)
end
function module_upvr.QuadraticBezierCurvesCameraLookAt(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 932
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Vector3Value_2_upvr = Instance.new("Vector3Value")
	Vector3Value_2_upvr.Parent = arg3
	Vector3Value_2_upvr.Value = Vector3.new(0, 0, 0)
	local var155_upvw
	if typeof(arg4) ~= "Vector3" then
		var155_upvw = var155_upvw.Position
	end
	if typeof(arg5) ~= "Vector3" then
	end
	if typeof(arg6) ~= "Vector3" then
	end
	local var157_upvw = 0
	local var158_upvw = 0
	local var159_upvr = 1 / arg2
	local Position_27_upvw = arg5.Position
	local Position_6_upvw = arg6.Position
	local var162_upvw
	var162_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_15) -- Line 954
		--[[ Upvalues[15]:
			[1]: var157_upvw (read and write)
			[2]: var158_upvw (read and write)
			[3]: var159_upvr (readonly)
			[4]: arg8 (readonly)
			[5]: arg1 (readonly)
			[6]: module_upvr (copied, readonly)
			[7]: var155_upvw (read and write)
			[8]: Position_27_upvw (read and write)
			[9]: Position_6_upvw (read and write)
			[10]: Vector3Value_2_upvr (readonly)
			[11]: arg3 (readonly)
			[12]: arg7 (readonly)
			[13]: arg9 (readonly)
			[14]: var162_upvw (read and write)
			[15]: Debris_upvr (copied, readonly)
		]]
		var157_upvw += arg1_15
		if var157_upvw < var158_upvw * var159_upvr then
		else
			if var158_upvw * var159_upvr <= var157_upvw and arg8 then
				var158_upvw += 1
				local var163 = var158_upvw / arg1
				Vector3Value_2_upvr.Value = module_upvr.Lerp(module_upvr.Lerp(var155_upvw, Position_27_upvw, var163), module_upvr.Lerp(Position_27_upvw, Position_6_upvw, var163), var163)
				arg3.CFrame = CFrame.lookAt(arg3.CFrame.Position, arg8.Position, Vector3.new(0, 1, 0)) * arg7
				arg3.CFrame = arg3.CFrame.Rotation + Vector3Value_2_upvr.Value
			end
			if arg1 < var158_upvw or not arg8 then
				if arg9 then
					arg9()
				end
				var162_upvw:Disconnect()
				var162_upvw = nil
				Debris_upvr:AddItem(Vector3Value_2_upvr, task.wait())
			end
		end
	end)
end
return module_upvr