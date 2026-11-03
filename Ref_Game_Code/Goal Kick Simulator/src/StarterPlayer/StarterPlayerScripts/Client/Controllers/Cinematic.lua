-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:43
-- Luau version 6, Types version 3
-- Time taken: 0.005563 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
workspace.CameraTweens.Parent = nil
local any_new_result1_upvr = Util_upvr.Maid.new()
local module = {}
local CurrentCamera_upvr = Util_upvr.CurrentCamera
local function _(arg1, arg2, arg3) -- Line 16, Named "lerp"
	return arg1 + (arg2 - arg1) * arg3
end
local function _(arg1, arg2, arg3, arg4) -- Line 20, Named "quadBezier"
	local var5 = arg2 + (arg3 - arg2) * arg1
	return var5 + (arg3 + (arg4 - arg3) * arg1 - var5) * arg1
end
local function DefaultInterpolate_upvr(arg1) -- Line 29, Named "DefaultInterpolate"
	return math.sin(arg1 * math.pi / 2)
end
local module_2_upvr = {}
local function GetInterpolateFunction_upvr(arg1, arg2, arg3) -- Line 32, Named "GetInterpolateFunction"
	--[[ Upvalues[2]:
		[1]: module_2_upvr (readonly)
		[2]: DefaultInterpolate_upvr (readonly)
	]]
	local unpack_result1_upvr_2, unpack_result2_upvr_2, unpack_result3_upvr = unpack(arg1)
	local unpack_result1_upvr, unpack_result2_upvr, unpack_result3_upvr_2 = unpack(arg2)
	if not unpack_result1_upvr_2 or not unpack_result1_upvr then return end
	local formatted = string.format("%s_%s_%s_%s_%s_%s_%s", tostring(arg3) or 'D', tostring(unpack_result1_upvr_2) or "NA", tostring(unpack_result2_upvr_2) or "NA", tostring(unpack_result3_upvr) or "NA", tostring(unpack_result1_upvr) or "NA", tostring(unpack_result2_upvr) or "NA", tostring(unpack_result3_upvr_2) or "NA")
	if module_2_upvr[formatted] then
		return module_2_upvr[formatted]
	end
	local var14_upvr = arg3
	if not var14_upvr then
		var14_upvr = DefaultInterpolate_upvr
	end
	module_2_upvr[formatted] = function(arg1_2) -- Line 42
		--[[ Upvalues[7]:
			[1]: var14_upvr (readonly)
			[2]: unpack_result1_upvr_2 (readonly)
			[3]: unpack_result2_upvr_2 (readonly)
			[4]: unpack_result3_upvr (readonly)
			[5]: unpack_result1_upvr (readonly)
			[6]: unpack_result2_upvr (readonly)
			[7]: unpack_result3_upvr_2 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var14_result1 = var14_upvr(arg1_2)
		local var17
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var17 = var20 + (var19 + (unpack_result3_upvr - var19) * var14_result1 - var20) * var14_result1
			local var20 = var18 + (var19 - var18) * var14_result1
			local var19 = unpack_result2_upvr_2
			local var18 = unpack_result1_upvr_2
			return var17
		end
		if not unpack_result1_upvr_2 or not unpack_result2_upvr_2 or not unpack_result3_upvr or not INLINED() then
			local function INLINED_2() -- Internal function, doesn't exist in bytecode
				var17 = unpack_result1_upvr_2:lerp(unpack_result2_upvr_2, var14_result1)
				return var17
			end
			if not unpack_result1_upvr_2 or not unpack_result2_upvr_2 or not INLINED_2() then
				var17 = unpack_result1_upvr_2
			end
		end
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			local var23 = var21 + (var22 - var21) * var14_result1
			local var22 = unpack_result2_upvr
			local var21 = unpack_result1_upvr
			return var23 + (var22 + (unpack_result3_upvr_2 - var22) * var14_result1 - var23) * var14_result1
		end
		if not unpack_result1_upvr or not unpack_result2_upvr or not unpack_result3_upvr_2 or not INLINED_3() then
			if not unpack_result1_upvr or not unpack_result2_upvr or not unpack_result1_upvr:lerp(unpack_result2_upvr, var14_result1) then
			end
		end
		return CFrame.new(var17, unpack_result1_upvr)
	end
	return module_2_upvr[formatted]
end
local tbl_3_upvr = {
	Interpolate = function(arg1, arg2, arg3, arg4) -- Line 51, Named "Interpolate"
		--[[ Upvalues[4]:
			[1]: GetInterpolateFunction_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (readonly)
			[4]: CurrentCamera_upvr (readonly)
		]]
		local GetInterpolateFunction_result1_upvr = GetInterpolateFunction_upvr(arg2, arg3, arg4.EasingFunction)
		any_new_result1_upvr.Interpolate = Util_upvr.Thread.LoopFor(arg4.Duration or 1, function(arg1_3) -- Line 53
			--[[ Upvalues[2]:
				[1]: CurrentCamera_upvr (copied, readonly)
				[2]: GetInterpolateFunction_result1_upvr (readonly)
			]]
			CurrentCamera_upvr.CFrame = GetInterpolateFunction_result1_upvr(arg1_3)
		end)
		if arg4.RemoveAtEnd then
			task.spawn(function() -- Line 57
				--[[ Upvalues[2]:
					[1]: any_new_result1_upvr (copied, readonly)
					[2]: arg4 (readonly)
				]]
				any_new_result1_upvr.Interpolate.Ended:Wait()
				if arg4.RemoveAtEnd then
					task.wait(arg4.RemoveAtEnd)
				end
				any_new_result1_upvr.Interpolate = nil
			end)
		end
		return any_new_result1_upvr.Interpolate
	end;
	Play = function(arg1, arg2, ...) -- Line 65, Named "Play"
		--[[ Upvalues[4]:
			[1]: CurrentCamera_upvr (readonly)
			[2]: GetInterpolateFunction_upvr (readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: Util_upvr (readonly)
		]]
		local SOME = arg1.Environment:FindFirstChild(arg2.Name)
		if not SOME then
			warn("CameraTween not found", arg2.Name)
			return
		end
		local tbl_2 = {SOME.Position:FindFirstChild("Start"), SOME.Position:FindFirstChild("Input"), SOME.Position:FindFirstChild("End")}
		local tbl = {SOME.Focus:FindFirstChild("Start"), SOME.Focus:FindFirstChild("Input"), SOME.Focus:FindFirstChild("End")}
		for i, v in pairs(tbl_2) do
			if typeof(v) == "Instance" then
				tbl_2[i] = v.Position
			end
		end
		for i_2_upvr, v_2 in pairs(tbl) do
			if typeof(v_2) == "Instance" then
				tbl[i_2_upvr] = v_2.Position
			end
		end
		if arg2.TweenToStart then
			i_2_upvr = tbl_2
			v_2 = tbl
			i_2_upvr = GetInterpolateFunction_upvr(i_2_upvr, v_2, arg2.EasingFunction)
			v_2 = 0
			i_2_upvr = i_2_upvr(v_2)
			v_2 = any_new_result1_upvr
			local CFrame_upvr_2 = CurrentCamera_upvr.CFrame
			v_2.Interpolate = Util_upvr.Thread.LoopFor(arg2.TweenToStart, function(arg1_4) -- Line 86
				--[[ Upvalues[3]:
					[1]: CurrentCamera_upvr (copied, readonly)
					[2]: CFrame_upvr_2 (readonly)
					[3]: i_2_upvr (readonly)
				]]
				CurrentCamera_upvr.CFrame = CFrame_upvr_2:Lerp(i_2_upvr, arg1_4)
			end)
			v_2 = any_new_result1_upvr.Interpolate.Ended:Wait
			v_2()
		end
		CFrame_upvr_2 = arg1:Interpolate(tbl_2, tbl, arg2, ...)
		return CFrame_upvr_2
	end;
	TweenToDefault = function(arg1, arg2) -- Line 93, Named "TweenToDefault"
		--[[ Upvalues[3]:
			[1]: CurrentCamera_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (readonly)
		]]
		if arg1.DefaultStep then
			local CFrame_upvr = CurrentCamera_upvr.CFrame
			any_new_result1_upvr.Interpolate = Util_upvr.Thread.LoopFor(arg2 or 1, function(arg1_5, arg2_2) -- Line 97
				--[[ Upvalues[3]:
					[1]: CurrentCamera_upvr (copied, readonly)
					[2]: CFrame_upvr (readonly)
					[3]: arg1 (readonly)
				]]
				CurrentCamera_upvr.CFrame = CFrame_upvr:Lerp(arg1.DefaultStep(arg2_2), arg1_5)
			end)
			any_new_result1_upvr.Interpolate.Ended:Wait()
			any_new_result1_upvr.Interpolate = nil
		end
	end;
	Reset = function(arg1) -- Line 104, Named "Reset"
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		arg1.DefaultStep = nil
		any_new_result1_upvr.Interpolate = nil
		any_new_result1_upvr.DefaultStep = nil
	end;
	SetDefault = function(arg1, arg2) -- Line 109, Named "SetDefault"
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: Util_upvr (readonly)
			[3]: CurrentCamera_upvr (readonly)
		]]
		arg1.DefaultStep = arg2
		any_new_result1_upvr.DefaultStep = Util_upvr.RunService.RenderStepped:Connect(function(arg1_6) -- Line 111
			--[[ Upvalues[3]:
				[1]: any_new_result1_upvr (copied, readonly)
				[2]: CurrentCamera_upvr (copied, readonly)
				[3]: arg2 (readonly)
			]]
			if any_new_result1_upvr.Interpolate then
			else
				CurrentCamera_upvr.CFrame = arg2(arg1_6)
			end
		end)
	end;
}
tbl_3_upvr.__index = tbl_3_upvr
function module.new(arg1) -- Line 119
	--[[ Upvalues[1]:
		[1]: tbl_3_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, tbl_3_upvr)
	setmetatable_result1.Environment = arg1
	arg1.Parent = nil
	return setmetatable_result1
end
Util_upvr.Cinematic = module
return module