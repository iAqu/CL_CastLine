-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:19
-- Luau version 6, Types version 3
-- Time taken: 0.002693 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "FadeBetweenCamera";
}
local any_load_result1_result1_upvr_3 = any_load_result1("Spring")
function module_upvr.new(arg1, arg2) -- Line 22
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	local tbl = {
		_spring = any_load_result1_result1_upvr_3.new(0);
	}
	local var5 = arg1
	if not var5 then
		var5 = error("No cameraA")
	end
	tbl.CameraA = var5
	var5 = arg2
	local var6 = var5
	if not var6 then
		var6 = error("No cameraB")
	end
	tbl.CameraB = var6
	local setmetatable_result1 = setmetatable(tbl, module_upvr)
	setmetatable_result1.Damper = 1
	setmetatable_result1.Speed = 15
	return setmetatable_result1
end
local any_load_result1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 35
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 39
	if arg2 == "Damper" then
		arg1._spring.Damper = arg3
	else
		if arg2 == "Value" then
			arg1._spring.Value = arg3
			return
		end
		if arg2 == "Speed" then
			arg1._spring.Speed = arg3
			return
		end
		if arg2 == "Target" then
			arg1._spring.Target = arg3
			return
		end
		if arg2 == "Velocity" then
			arg1._spring.Velocity = arg3
			return
		end
		if arg2 == "CameraA" or arg2 == "CameraB" then
			rawset(arg1, arg2, arg3)
			return
		end
		error("%q is not a valid member of FadeBetweenCamera":format(tostring(arg2)))
	end
end
local any_load_result1_result1_upvr_4 = any_load_result1("SpringUtils")
local any_load_result1_result1_upvr = any_load_result1("CubicSplineUtils")
local var1_result1_upvr = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 63
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_animating_result1, any_animating_result2 = any_load_result1_result1_upvr_4.animating(arg1._spring)
		if any_animating_result2 <= 0 then
			return arg1.CameraStateA
		end
		if 1 <= any_animating_result2 then
			return arg1.CameraStateB
		end
		local CameraStateA = arg1.CameraStateA
		local CameraStateB = arg1.CameraStateB
		local any_tweenSplineNodes_result1 = any_load_result1_result1_upvr.tweenSplineNodes(any_load_result1_result1_upvr.newSplineNode(0, CameraStateA.CameraFrame, CameraStateA.CameraFrameDerivative), any_load_result1_result1_upvr.newSplineNode(1, CameraStateB.CameraFrame, CameraStateB.CameraFrameDerivative), any_animating_result2)
		return var1_result1_upvr.new(any_tweenSplineNodes_result1.p, any_tweenSplineNodes_result1.v)
	end
	if arg2 == "CameraStateA" then
		any_animating_result1 = arg1.CameraA.CameraState
		local var17 = any_animating_result1
		if not var17 then
			var17 = arg1.CameraA
		end
		return var17
	end
	if arg2 == "CameraStateB" then
		var17 = arg1.CameraB.CameraState
		local var18 = var17
		if not var18 then
			var18 = arg1.CameraB
		end
		return var18
	end
	if arg2 == "Damper" then
		return arg1._spring.Damper
	end
	if arg2 == "Value" then
		local any_animating_result1_2, any_animating_result2_2 = any_load_result1_result1_upvr_4.animating(arg1._spring)
		return any_animating_result2_2
	end
	if arg2 == "Speed" then
		return arg1._spring.Speed
	end
	if arg2 == "Target" then
		return arg1._spring.Target
	end
	if arg2 == "Velocity" then
		if any_load_result1_result1_upvr_4.animating(arg1._spring) then
			return arg1._spring.Velocity
		end
		return Vector3.new(0, 0, 0)
	end
	if arg2 == "HasReachedTarget" then
		return not any_load_result1_result1_upvr_4.animating(arg1._spring)
	end
	if arg2 == "Spring" then
		return arg1._spring
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q is not a valid member of FadeBetweenCamera":format(tostring(arg2)))
end
return module_upvr