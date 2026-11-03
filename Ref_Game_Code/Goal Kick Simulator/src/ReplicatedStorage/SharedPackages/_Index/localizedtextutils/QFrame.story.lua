-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:33
-- Luau version 6, Types version 3
-- Time taken: 0.002666 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("CameraStoryUtils")
local any_load_result1_result1_upvr = any_load_result1("QFrame")
local any_load_result1_result1_upvr_3 = any_load_result1("CubicSplineUtils")
return function(arg1) -- Line 12
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_result1_upvr_2.new()
	local CFrame_upvr = workspace.CurrentCamera.CFrame
	local any_fromCFrameClosestTo_result1_upvr = any_load_result1_result1_upvr.fromCFrameClosestTo(CFrame.new(CFrame_upvr.Position + CFrame_upvr.lookVector * 25 - 20 * CFrame_upvr.RightVector), any_load_result1_result1_upvr.new())
	local any_getInterpolationFactory_result1 = var1_result1_upvr.getInterpolationFactory(any_new_result1_upvr, var1_result1_upvr.setupViewportFrame(any_new_result1_upvr, arg1), -1, 2, 8, function(arg1_2) -- Line 23
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.toCFrame(arg1_2)
	end)
	local function getFinish_upvr(arg1_3) -- Line 27, Named "getFinish"
		--[[ Upvalues[2]:
			[1]: CFrame_upvr (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.fromCFrameClosestTo(CFrame.new(CFrame_upvr.Position + CFrame_upvr.lookVector * 25 + 20 * CFrame_upvr.RightVector) * CFrame.Angles(1.0471975511965976, 2.0943951023931953, 0) * CFrame.Angles(0, math.pi * arg1_3 / 3, 0), any_load_result1_result1_upvr.new())
	end
	any_getInterpolationFactory_result1(function(arg1_4) -- Line 36
		--[[ Upvalues[1]:
			[1]: getFinish_upvr (readonly)
		]]
		return getFinish_upvr(arg1_4)
	end, Color3.new(1, 0.5, 0.5))
	any_getInterpolationFactory_result1(function(arg1_5) -- Line 40
		--[[ Upvalues[1]:
			[1]: any_fromCFrameClosestTo_result1_upvr (readonly)
		]]
		return any_fromCFrameClosestTo_result1_upvr
	end, Color3.new(0.5, 1, 0.5))
	any_getInterpolationFactory_result1(function(arg1_6) -- Line 48
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: any_fromCFrameClosestTo_result1_upvr (readonly)
			[3]: getFinish_upvr (readonly)
		]]
		return any_load_result1_result1_upvr.fromCFrameClosestTo(any_load_result1_result1_upvr.toCFrame(any_fromCFrameClosestTo_result1_upvr):Lerp(any_load_result1_result1_upvr.toCFrame(getFinish_upvr(arg1_6)), arg1_6), any_load_result1_result1_upvr.new())
	end, Color3.new(0.75, 0.75, 0.75), "CFrame:Lerp()")
	local function _(arg1_7, arg2, arg3) -- Line 52, Named "slerp"
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
		]]
		local var15 = arg2 * arg1_7 ^ -1
		if var15.W < 0 then
			var15 = any_load_result1_result1_upvr.new(var15.x, var15.y, var15.z, -var15.W, -var15.X, -var15.Y, -var15.Z)
		end
		return var15 ^ arg3 * arg1_7
	end
	any_getInterpolationFactory_result1(function(arg1_8) -- Line 61
		--[[ Upvalues[3]:
			[1]: any_fromCFrameClosestTo_result1_upvr (readonly)
			[2]: getFinish_upvr (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
		]]
		local var17 = any_fromCFrameClosestTo_result1_upvr
		local var18 = getFinish_upvr(arg1_8) * var17 ^ -1
		if var18.W < 0 then
			var18 = any_load_result1_result1_upvr.new(var18.x, var18.y, var18.z, -var18.W, -var18.X, -var18.Y, -var18.Z)
		end
		return var18 ^ arg1_8 * var17
	end, Color3.new(0.5, 0.5, 1), "Quaternion Slerp")
	any_getInterpolationFactory_result1(function(arg1_9) -- Line 66
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_fromCFrameClosestTo_result1_upvr (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: getFinish_upvr (readonly)
		]]
		local any_newSplineNode_result1_2 = any_load_result1_result1_upvr_3.newSplineNode(0, any_fromCFrameClosestTo_result1_upvr, any_load_result1_result1_upvr.new())
		local any_newSplineNode_result1 = any_load_result1_result1_upvr_3.newSplineNode(1, getFinish_upvr(arg1_9), any_load_result1_result1_upvr.new())
		if arg1_9 <= any_newSplineNode_result1_2.t then
			return any_newSplineNode_result1_2.p
		end
		if any_newSplineNode_result1.t <= arg1_9 then
			return any_newSplineNode_result1.p
		end
		return any_load_result1_result1_upvr_3.tweenSplineNodes(any_newSplineNode_result1_2, any_newSplineNode_result1, arg1_9).p
	end, Color3.new(0.5, 1, 1), "Cubic Spline")
	return function() -- Line 80
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end