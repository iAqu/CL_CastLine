-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:41
-- Luau version 6, Types version 3
-- Time taken: 0.006346 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
local profilebegin_upvr = debug.profilebegin
local profileend_upvr = debug.profileend
local new_2_upvr = CFrame.new
local Angles_upvr = CFrame.Angles
local rad_upvr = math.rad
local zero_vector3_upvr = Vector3.new()
local CameraShakeInstance_upvr = require(script.CameraShakeInstance)
local CameraShakeState_upvr = CameraShakeInstance_upvr.CameraShakeState
module_upvr.CameraShakeInstance = CameraShakeInstance_upvr
module_upvr.Presets = require(script.CameraShakePresets)
function module_upvr.new(arg1, arg2) -- Line 82
	--[[ Upvalues[2]:
		[1]: zero_vector3_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local var10
	if type(arg1) ~= "number" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
	if type(arg2) ~= "function" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "Callback must be a function")
	var10 = {}
	var10._running = false
	var10._renderName = "CameraShaker"
	var10._renderPriority = arg1
	var10._posAddShake = zero_vector3_upvr
	var10._rotAddShake = zero_vector3_upvr
	var10._camShakeInstances = {}
	var10._removeInstances = {}
	var10._callback = arg2
	var10._playTime = 1
	var10._time = 0
	return setmetatable(var10, module_upvr)
end
function module_upvr.newFixed(arg1, arg2) -- Line 104
	--[[ Upvalues[2]:
		[1]: zero_vector3_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local var11
	if type(arg1) ~= "number" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
	if type(arg2) ~= "function" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Callback must be a function")
	var11 = {}
	var11._running = false
	var11._renderName = "CameraShaker"..tostring(math.ceil(tick() * 100))
	var11._renderPriority = arg1
	var11._posAddShake = zero_vector3_upvr
	var11._rotAddShake = zero_vector3_upvr
	var11._camShakeInstances = {}
	var11._removeInstances = {}
	var11._callback = arg2
	var11._playTime = 1
	var11._time = 0
	return setmetatable(var11, module_upvr)
end
function module_upvr.Start(arg1) -- Line 127
	--[[ Upvalues[2]:
		[1]: profilebegin_upvr (readonly)
		[2]: profileend_upvr (readonly)
	]]
	if arg1._running then
	else
		arg1._running = true
		local _callback_upvr = arg1._callback
		game:GetService("RunService"):BindToRenderStep(arg1._renderName, arg1._renderPriority, function(arg1_2) -- Line 131
			--[[ Upvalues[4]:
				[1]: profilebegin_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: profileend_upvr (copied, readonly)
				[4]: _callback_upvr (readonly)
			]]
			profilebegin_upvr("CameraShakerUpdate")
			profileend_upvr()
			_callback_upvr(arg1:Update(arg1_2))
		end)
	end
end
function module_upvr.StartFixed(arg1) -- Line 139
	--[[ Upvalues[2]:
		[1]: profilebegin_upvr (readonly)
		[2]: profileend_upvr (readonly)
	]]
	if arg1._running then
	else
		arg1._running = true
		local _callback_upvr_2 = arg1._callback
		game:GetService("RunService"):BindToRenderStep(arg1._renderName, arg1._renderPriority, function(arg1_3) -- Line 143
			--[[ Upvalues[4]:
				[1]: profilebegin_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: profileend_upvr (copied, readonly)
				[4]: _callback_upvr_2 (readonly)
			]]
			profilebegin_upvr("CameraShakerUpdate")
			local var16 = arg1
			var16._time += arg1_3
			local any_UpdateFixed_result1, any_UpdateFixed_result2 = arg1:UpdateFixed(arg1_3)
			profileend_upvr()
			_callback_upvr_2(any_UpdateFixed_result1)
			if any_UpdateFixed_result2 then
				arg1:Stop()
			end
		end)
	end
end
function module_upvr.Stop(arg1) -- Line 155
	if not arg1._running then
	else
		game:GetService("RunService"):UnbindFromRenderStep(arg1._renderName)
		arg1._running = false
	end
end
function module_upvr.StopSustained(arg1, arg2) -- Line 162
	for _, v in pairs(arg1._camShakeInstances) do
		if v.fadeOutDuration == 0 then
			local var26 = arg2
			if not var26 then
				var26 = v.fadeInDuration
			end
			v:StartFadeOut(var26)
		end
	end
end
function module_upvr.Update(arg1, arg2) -- Line 171
	--[[ Upvalues[5]:
		[1]: zero_vector3_upvr (readonly)
		[2]: CameraShakeState_upvr (readonly)
		[3]: new_2_upvr (readonly)
		[4]: Angles_upvr (readonly)
		[5]: rad_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local _camShakeInstances = arg1._camShakeInstances
	local var36
	for i_2 = 1, #_camShakeInstances do
		local var37 = _camShakeInstances[i_2]
		local any_GetState_result1_2 = var37:GetState()
		if any_GetState_result1_2 == CameraShakeState_upvr.Inactive and var37.DeleteOnInactive then
			arg1._removeInstances[#arg1._removeInstances + 1] = i_2
		elseif any_GetState_result1_2 ~= CameraShakeState_upvr.Inactive then
			local any_UpdateShake_result1 = var37:UpdateShake(arg2)
			var36 += any_UpdateShake_result1 * var37.PositionInfluence
			local var40 = zero_vector3_upvr + any_UpdateShake_result1 * var37.RotationInfluence
		end
	end
	for i_3 = #arg1._removeInstances, 1, -1 do
		table.remove(_camShakeInstances, arg1._removeInstances[i_3])
		arg1._removeInstances[i_3] = nil
	end
	return new_2_upvr(var36) * Angles_upvr(0, rad_upvr(var40.Y), 0) * Angles_upvr(rad_upvr(var40.X), 0, rad_upvr(var40.Z))
end
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.UpdateFixed(arg1, arg2) -- Line 207
	--[[ Upvalues[6]:
		[1]: zero_vector3_upvr (readonly)
		[2]: CameraShakeState_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: new_2_upvr (readonly)
		[5]: Angles_upvr (readonly)
		[6]: rad_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local _camShakeInstances_2 = arg1._camShakeInstances
	local var51
	for i_4 = 1, #_camShakeInstances_2 do
		local var52 = _camShakeInstances_2[i_4]
		local any_GetState_result1 = var52:GetState()
		if any_GetState_result1 == CameraShakeState_upvr.Inactive and var52.DeleteOnInactive then
			arg1._removeInstances[#arg1._removeInstances + 1] = i_4
		elseif any_GetState_result1 ~= CameraShakeState_upvr.Inactive then
			local var54 = var52.playTime or 1
			if var54 < arg1._time then
			end
			local clamped_2 = math.clamp(arg1._time / var54, 0, 1)
			local clamped = math.clamp((arg1._time - arg2) / var54, 0, 1)
			local var57 = (TweenService_upvr:GetValue(clamped_2, var52.EasingStyle, var52.EasingDirection) - TweenService_upvr:GetValue(clamped, var52.EasingStyle, var52.EasingDirection)) * var52.RotationInfluence
		end
	end
	for i_5 = #arg1._removeInstances, 1, -1 do
		table.remove(_camShakeInstances_2, arg1._removeInstances[i_5])
		arg1._removeInstances[i_5] = nil
	end
	return new_2_upvr(nil) * Angles_upvr(0, rad_upvr(var57.Y), 0) * Angles_upvr(rad_upvr(var57.X), 0, rad_upvr(var57.Z)), true
end
function module_upvr.Shake(arg1, arg2) -- Line 276
	local var58 = false
	if type(arg2) == "table" then
		var58 = arg2._camShakeInstance
	end
	assert(var58, "ShakeInstance must be of type CameraShakeInstance")
	arg1._camShakeInstances[#arg1._camShakeInstances + 1] = arg2
	return arg2
end
function module_upvr.ShakeSustain(arg1, arg2) -- Line 283
	local var59 = false
	if type(arg2) == "table" then
		var59 = arg2._camShakeInstance
	end
	assert(var59, "ShakeInstance must be of type CameraShakeInstance")
	arg1._camShakeInstances[#arg1._camShakeInstances + 1] = arg2
	arg2:StartFadeIn(arg2.fadeInDuration)
	return arg2
end
function module_upvr.ShakeOnce(arg1, arg2, arg3, arg4, arg5, arg6, arg7) -- Line 291
	--[[ Upvalues[1]:
		[1]: CameraShakeInstance_upvr (readonly)
	]]
	local any_new_result1_2 = CameraShakeInstance_upvr.new(arg2, arg3, arg4, arg5)
	local var61
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var61 = arg6
		return var61
	end
	if typeof(arg6) ~= "Vector3" or not INLINED() then
		var61 = Vector3.new(0.15000, 0.15000, 0.15000)
	end
	any_new_result1_2.PositionInfluence = var61
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var61 = arg7
		return var61
	end
	if typeof(arg7) ~= "Vector3" or not INLINED_2() then
		var61 = Vector3.new(1, 1, 1)
	end
	any_new_result1_2.RotationInfluence = var61
	var61 = arg1._camShakeInstances
	var61[#arg1._camShakeInstances + 1] = any_new_result1_2
	return any_new_result1_2
end
function module_upvr.StartShake(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 300
	--[[ Upvalues[1]:
		[1]: CameraShakeInstance_upvr (readonly)
	]]
	local any_new_result1 = CameraShakeInstance_upvr.new(arg2, arg3, arg4)
	local var63
	local function INLINED_3() -- Internal function, doesn't exist in bytecode
		var63 = arg5
		return var63
	end
	if typeof(arg5) ~= "Vector3" or not INLINED_3() then
		var63 = Vector3.new(0.15000, 0.15000, 0.15000)
	end
	any_new_result1.PositionInfluence = var63
	local function INLINED_4() -- Internal function, doesn't exist in bytecode
		var63 = arg6
		return var63
	end
	if typeof(arg6) ~= "Vector3" or not INLINED_4() then
		var63 = Vector3.new(1, 1, 1)
	end
	any_new_result1.RotationInfluence = var63
	var63 = any_new_result1:StartFadeIn
	var63(arg4)
	var63 = arg1._camShakeInstances
	var63[#arg1._camShakeInstances + 1] = any_new_result1
	return any_new_result1
end
return module_upvr