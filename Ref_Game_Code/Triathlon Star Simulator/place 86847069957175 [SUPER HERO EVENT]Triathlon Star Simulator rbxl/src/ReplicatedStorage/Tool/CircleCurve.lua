-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:35
-- Luau version 6, Types version 3
-- Time taken: 0.002001 seconds

local module = {}
local RunService_upvr = game:GetService("RunService")
local function TwoDimensionTrans_upvr(arg1, arg2, arg3, arg4) -- Line 8, Named "TwoDimensionTrans"
	local var3 = arg1 - arg2
	local radians = math.rad(arg3)
	if arg4 then
		return Vector3.new(var3.X * math.cos(radians) + var3.Z * math.sin(radians), var3.Y, -var3.X * math.sin(radians) + var3.Z * math.cos(radians))
	end
	return Vector3.new(var3.X * math.cos(radians) - var3.Z * math.sin(radians), var3.Y, var3.X * math.sin(radians) + var3.Z * math.cos(radians))
end
function module.CircleCurveMove(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 27
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: TwoDimensionTrans_upvr (readonly)
	]]
	if not arg3 then
	else
		if not arg4 then return end
		if not arg5 then
		end
		local var6_upvw = 0
		local var7_upvw = 0
		local var8_upvr = 1 / arg1
		local const_number_upvw_2 = 1
		local var10_upvw
		var10_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_2) -- Line 47
			--[[ Upvalues[10]:
				[1]: var6_upvw (read and write)
				[2]: var7_upvw (read and write)
				[3]: var8_upvr (readonly)
				[4]: const_number_upvw_2 (read and write)
				[5]: arg2 (readonly)
				[6]: arg3 (readonly)
				[7]: TwoDimensionTrans_upvr (copied, readonly)
				[8]: arg4 (readonly)
				[9]: var10_upvw (read and write)
				[10]: arg6 (readonly)
			]]
			var6_upvw += arg1_2
			if var6_upvw < var7_upvw * var8_upvr then
			else
				if var7_upvw * var8_upvr <= var6_upvw then
					var7_upvw += 1
					arg3:PivotTo(arg3:GetPivot().Rotation + TwoDimensionTrans_upvr(arg3:GetPivot().Position, arg4, 360 * const_number_upvw_2 / arg2, true) + arg4)
				end
				if arg2 < var7_upvw or not arg3 then
					var10_upvw:Disconnect()
					var10_upvw = nil
					if arg6 then
						arg6()
					end
				end
			end
		end)
	end
end
function module.CircleCurveMoveLookAtCamera(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 85
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: TwoDimensionTrans_upvr (readonly)
	]]
	if not arg3 then
	else
		if not arg4 then return end
		if not arg5 then
		end
		local var12_upvw = 0
		local var13_upvw = 0
		local var14_upvr = 1 / arg1
		local const_number_upvw = 1
		local var16_upvw
		var16_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_3) -- Line 105
			--[[ Upvalues[10]:
				[1]: var12_upvw (read and write)
				[2]: var13_upvw (read and write)
				[3]: var14_upvr (readonly)
				[4]: const_number_upvw (read and write)
				[5]: arg2 (readonly)
				[6]: arg3 (readonly)
				[7]: TwoDimensionTrans_upvr (copied, readonly)
				[8]: arg4 (readonly)
				[9]: var16_upvw (read and write)
				[10]: arg6 (readonly)
			]]
			var12_upvw += arg1_3
			if var12_upvw < var13_upvw * var14_upvr then
			else
				if var13_upvw * var14_upvr <= var12_upvw then
					var13_upvw += 1
					arg3:PivotTo(CFrame.lookAt(TwoDimensionTrans_upvr(arg3:GetPivot().Position, arg4, 360 * const_number_upvw / arg2, true) + arg4, workspace.CurrentCamera.CFrame.Position, Vector3.new(0, 1, 0)))
				end
				if arg2 < var13_upvw or not arg3 then
					var16_upvw:Disconnect()
					var16_upvw = nil
					if arg6 then
						arg6()
					end
				end
			end
		end)
	end
end
return module