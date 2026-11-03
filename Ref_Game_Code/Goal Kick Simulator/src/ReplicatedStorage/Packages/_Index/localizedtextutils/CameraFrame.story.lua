-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:28
-- Luau version 6, Types version 3
-- Time taken: 0.002262 seconds

local any_load_result1 = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("CameraStoryUtils")
local any_load_result1_result1_upvr = any_load_result1("CameraFrame")
local any_load_result1_result1_upvr_3 = any_load_result1("QFrame")
local any_load_result1_result1_upvr_4 = any_load_result1("CubicSplineUtils")
return function(arg1) -- Line 13
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local any_new_result1_upvr = any_load_result1_result1_upvr_2.new()
	local CFrame = workspace.CurrentCamera.CFrame
	local any_new_result1_upvr_2 = any_load_result1_result1_upvr.new(any_load_result1_result1_upvr_3.fromCFrameClosestTo(CFrame.new(CFrame.Position + CFrame.lookVector * 25 - 20 * CFrame.RightVector), any_load_result1_result1_upvr_3.new()), 70)
	local any_new_result1_upvr_3 = any_load_result1_result1_upvr.new(any_load_result1_result1_upvr_3.fromCFrameClosestTo(CFrame.new(CFrame.Position + CFrame.lookVector * 30 + 20 * CFrame.RightVector) * CFrame.Angles(1.0471975511965976, 2.0943951023931953, 0), any_load_result1_result1_upvr_3.new()), 70)
	local any_getInterpolationFactory_result1 = var1_result1_upvr.getInterpolationFactory(any_new_result1_upvr, var1_result1_upvr.setupViewportFrame(any_new_result1_upvr, arg1), -0.1, 1.1, 4, function(arg1_2) -- Line 27
		return arg1_2.CFrame
	end)
	any_getInterpolationFactory_result1(function(arg1_3) -- Line 31
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_3 (readonly)
		]]
		return any_new_result1_upvr_3
	end, Color3.new(1, 0.5, 0.5))
	any_getInterpolationFactory_result1(function(arg1_4) -- Line 35
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		return any_new_result1_upvr_2
	end, Color3.new(0.5, 1, 0.5))
	any_getInterpolationFactory_result1(function(arg1_5) -- Line 39
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: any_new_result1_upvr_2 (readonly)
			[3]: any_new_result1_upvr_3 (readonly)
		]]
		return any_load_result1_result1_upvr.new((1 - arg1_5) * any_new_result1_upvr_2.QFrame + arg1_5 * any_new_result1_upvr_3.QFrame, any_new_result1_upvr_2.FieldOfView + (any_new_result1_upvr_3.FieldOfView - any_new_result1_upvr_2.FieldOfView) * arg1_5)
	end, Color3.new(0.25, 0.25, 0.25), "Linear", Vector2.new(80, 0))
	any_getInterpolationFactory_result1(function(arg1_6) -- Line 43
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr_3 (readonly)
			[2]: any_new_result1_upvr_2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.new((any_new_result1_upvr_3.QFrame * any_new_result1_upvr_2.QFrame ^ -1) ^ arg1_6 * any_new_result1_upvr_2.QFrame, any_new_result1_upvr_2.FieldOfView + (any_new_result1_upvr_3.FieldOfView - any_new_result1_upvr_2.FieldOfView) * arg1_6)
	end, Color3.new(0.5, 0.5, 1), "Quaternion", Vector2.new(0, -80))
	any_getInterpolationFactory_result1(function(arg1_7) -- Line 48
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_4 (copied, readonly)
			[2]: any_new_result1_upvr_2 (readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: any_new_result1_upvr_3 (readonly)
		]]
		local any_newSplineNode_result1 = any_load_result1_result1_upvr_4.newSplineNode(0, any_new_result1_upvr_2, any_load_result1_result1_upvr.new())
		local any_newSplineNode_result1_2 = any_load_result1_result1_upvr_4.newSplineNode(1, any_new_result1_upvr_3, any_load_result1_result1_upvr.new())
		if arg1_7 <= any_newSplineNode_result1.t then
			return any_newSplineNode_result1.p
		end
		if any_newSplineNode_result1_2.t <= arg1_7 then
			return any_newSplineNode_result1_2.p
		end
		return any_load_result1_result1_upvr_4.tweenSplineNodes(any_newSplineNode_result1, any_newSplineNode_result1_2, arg1_7).p
	end, Color3.new(0.5, 1, 1), "Cubic spline", Vector2.new(0, 40))
	return function() -- Line 61
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end
end