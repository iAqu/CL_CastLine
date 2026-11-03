-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:55
-- Luau version 6, Types version 3
-- Time taken: 0.003644 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local Workspace_upvr = game:GetService("Workspace")
assert(RunService_upvr:IsClient(), "[CameraStackService] - Only require CameraStackService on client")
local module = {
	ServiceName = "CameraStackService";
}
local any_load_result1_result1_upvr = any_load_result1("ServiceBag")
local any_load_result1_result1_upvr_3 = any_load_result1("Maid")
local HttpService_upvr = game:GetService("HttpService")
local any_load_result1_result1_upvr_2 = any_load_result1("CameraStack")
local any_load_result1_result1_upvr_4 = any_load_result1("DefaultCamera")
local var1_result1_upvr = any_load_result1("ImpulseCamera")
function module.Init(arg1, arg2) -- Line 29
	--[[ Upvalues[8]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: HttpService_upvr (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
		[5]: any_load_result1_result1_upvr_4 (readonly)
		[6]: var1_result1_upvr (readonly)
		[7]: RunService_upvr (readonly)
		[8]: Workspace_upvr (readonly)
	]]
	assert(any_load_result1_result1_upvr.isServiceBag(arg2), "Not a valid service bag")
	arg1._maid = any_load_result1_result1_upvr_3.new()
	arg1._key = HttpService_upvr:GenerateGUID(false)
	arg1._cameraStack = any_load_result1_result1_upvr_2.new()
	arg1._rawDefaultCamera = any_load_result1_result1_upvr_4.new()
	arg1._maid:GiveTask(arg1._rawDefaultCamera)
	arg1._impulseCamera = var1_result1_upvr.new()
	arg1._defaultCamera = arg1._rawDefaultCamera + arg1._impulseCamera:SetMode("Relative")
	arg1:Add(arg1._defaultCamera)
	RunService_upvr:BindToRenderStep("CameraStackUpdateInternal"..arg1._key, Enum.RenderPriority.Camera.Value + 75, function() -- Line 47
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Workspace_upvr (copied, readonly)
		]]
		debug.profilebegin("camerastackservice")
		local any_GetTopState_result1 = arg1:GetTopState()
		if any_GetTopState_result1 then
			any_GetTopState_result1:Set(Workspace_upvr.CurrentCamera)
		end
		debug.profileend()
	end)
	arg1._maid:GiveTask(function() -- Line 58
		--[[ Upvalues[2]:
			[1]: RunService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		RunService_upvr:UnbindFromRenderStep("CameraStackUpdateInternal"..arg1._key)
	end)
end
function module.Start(arg1) -- Line 63
	--[[ Upvalues[1]:
		[1]: Workspace_upvr (readonly)
	]]
	arg1._started = true
	if arg1._doNotUseDefaultCamera then
		Workspace_upvr.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		Workspace_upvr.CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- Line 71
			--[[ Upvalues[1]:
				[1]: Workspace_upvr (copied, readonly)
			]]
			Workspace_upvr.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		end)
	else
		arg1._rawDefaultCamera:BindToRenderStep()
	end
end
function module.SetDoNotUseDefaultCamera(arg1, arg2) -- Line 83
	assert(not arg1._started, "Already started")
	arg1._doNotUseDefaultCamera = arg2
end
function module.PushDisable(arg1) -- Line 93
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:PushDisable()
end
function module.PrintCameraStack(arg1) -- Line 102
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:PrintCameraStack()
end
function module.GetDefaultCamera(arg1) -- Line 112
	assert(arg1._defaultCamera, "Not initialized")
	return arg1._defaultCamera
end
function module.GetImpulseCamera(arg1) -- Line 137
	assert(arg1._impulseCamera, "Not initialized")
	return arg1._impulseCamera
end
function module.GetRawDefaultCamera(arg1) -- Line 147
	assert(arg1._rawDefaultCamera, "Not initialized")
	return arg1._rawDefaultCamera
end
function module.GetTopCamera(arg1) -- Line 157
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetTopCamera()
end
function module.GetTopState(arg1) -- Line 167
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetTopState()
end
function module.GetNewStateBelow(arg1) -- Line 179
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetNewStateBelow()
end
function module.GetIndex(arg1, arg2) -- Line 191
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetIndex(arg2)
end
function module.GetRawStack(arg1) -- Line 206
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetRawStack()
end
function module.GetCameraStack(arg1) -- Line 217
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:GetStack()
end
function module.Remove(arg1, arg2) -- Line 227
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:Remove(arg2)
end
function module.Add(arg1, arg2) -- Line 237
	assert(arg1._cameraStack, "Not initialized")
	return arg1._cameraStack:Add(arg2)
end
function module.Destroy(arg1) -- Line 243
	arg1._maid:DoCleaning()
end
return module