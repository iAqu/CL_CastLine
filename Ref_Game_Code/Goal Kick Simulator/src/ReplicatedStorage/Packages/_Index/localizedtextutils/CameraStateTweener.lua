-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:22
-- Luau version 6, Types version 3
-- Time taken: 0.003287 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "CameraStateTweener";
}
module_upvr.__index = module_upvr
local any_load_result1_result1_upvr_2 = any_load_result1("ServiceBag")
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("CameraStackService")
local any_load_result1_result1_upvr_3 = any_load_result1("FadeBetweenCamera3")
function module_upvr.new(arg1, arg2, arg3) -- Line 28
	--[[ Upvalues[5]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	assert(any_load_result1_result1_upvr_2.isServiceBag(arg1), "No serviceBag")
	assert(arg2, "No cameraEffect")
	setmetatable_result1_upvr._maid = var1_result1_upvr.new()
	setmetatable_result1_upvr._cameraStackService = arg1:GetService(any_load_result1_result1_upvr)
	local any_GetNewStateBelow_result1, any_GetNewStateBelow_result2 = setmetatable_result1_upvr._cameraStackService:GetNewStateBelow()
	setmetatable_result1_upvr._cameraEffect = arg2
	setmetatable_result1_upvr._cameraBelow = any_GetNewStateBelow_result1
	setmetatable_result1_upvr._fadeBetween = any_load_result1_result1_upvr_3.new(any_GetNewStateBelow_result1, arg2)
	any_GetNewStateBelow_result2(setmetatable_result1_upvr._fadeBetween)
	setmetatable_result1_upvr._cameraStackService:Add(setmetatable_result1_upvr._fadeBetween)
	setmetatable_result1_upvr._fadeBetween.Speed = arg3 or 20
	setmetatable_result1_upvr._fadeBetween.Target = 0
	setmetatable_result1_upvr._fadeBetween.Value = 0
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 50
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._cameraStackService:Remove(setmetatable_result1_upvr._fadeBetween)
	end)
	return setmetatable_result1_upvr
end
function module_upvr.GetPercentVisible(arg1) -- Line 61
	return arg1._fadeBetween.Value
end
function module_upvr.Show(arg1, arg2) -- Line 69
	arg1:SetTarget(1, arg2)
end
function module_upvr.Hide(arg1, arg2) -- Line 77
	arg1:SetTarget(0, arg2)
end
function module_upvr.IsFinishedHiding(arg1) -- Line 85
	local HasReachedTarget = arg1._fadeBetween.HasReachedTarget
	if HasReachedTarget then
		if arg1._fadeBetween.Target ~= 0 then
			HasReachedTarget = false
		else
			HasReachedTarget = true
		end
	end
	return HasReachedTarget
end
function module_upvr.Finish(arg1, arg2, arg3) -- Line 95
	arg1:Hide(arg2)
	if arg1._fadeBetween.HasReachedTarget then
		arg3()
	else
		task.spawn(function() -- Line 101
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg3 (readonly)
			]]
			while not arg1._fadeBetween.HasReachedTarget do
				task.wait(0.05)
			end
			arg3()
		end)
	end
end
function module_upvr.GetCameraEffect(arg1) -- Line 114
	return arg1._cameraEffect
end
function module_upvr.GetCameraBelow(arg1) -- Line 122
	return arg1._cameraBelow
end
function module_upvr.SetTarget(arg1, arg2, arg3) -- Line 132
	local var13 = arg2
	if not var13 then
		var13 = error("No target")
	end
	arg1._fadeBetween.Target = var13
	if arg3 then
		arg1._fadeBetween.Value = arg1._fadeBetween.Target
		arg1._fadeBetween.Velocity = 0
	end
	return arg1
end
function module_upvr.SetSpeed(arg1, arg2) -- Line 146
	arg1._fadeBetween.Speed = arg2
	return arg1
end
function module_upvr.SetVisible(arg1, arg2, arg3) -- Line 157
	if arg2 then
		arg1:Show(arg3)
	else
		arg1:Hide(arg3)
	end
end
function module_upvr.GetFader(arg1) -- Line 169
	return arg1._fadeBetween
end
function module_upvr.Destroy(arg1) -- Line 176
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr