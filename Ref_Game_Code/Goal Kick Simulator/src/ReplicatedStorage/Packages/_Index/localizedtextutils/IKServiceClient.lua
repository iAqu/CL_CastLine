-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:52
-- Luau version 6, Types version 3
-- Time taken: 0.003727 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1_upvr("IKRigUtils")
local module = {
	ServiceName = "IKServiceClient";
}
local var1_result1_upvr = any_load_result1_upvr("Maid")
function module.Init(arg1, arg2) -- Line 41
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._maid = var1_result1_upvr.new()
	arg1._lookAround = false
	arg1._serviceBag:GetService(any_load_result1_upvr("CameraStackService"))
	arg1._serviceBag:GetService(any_load_result1_upvr("Motor6DServiceClient"))
	arg1._ikBinders = arg1._serviceBag:GetService(any_load_result1_upvr("IKBindersClient"))
end
local RunService_upvr = game:GetService("RunService")
function module.Start(arg1) -- Line 60
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	assert(arg1._serviceBag, "Not initialized")
	arg1._maid:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 63
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_updateStepped()
	end))
end
function module.GetRig(arg1, arg2) -- Line 73
	assert(arg1._serviceBag, "Not initialized")
	local var7 = false
	if typeof(arg2) == "Instance" then
		var7 = arg2:IsA("Humanoid")
	end
	assert(var7, "Bad humanoid")
	return arg1._ikBinders.IKRig:Get(arg2)
end
function module.PromiseRig(arg1, arg2) -- Line 85
	assert(arg1._serviceBag, "Not initialized")
	local var8 = false
	if typeof(arg2) == "Instance" then
		var8 = arg2:IsA("Humanoid")
	end
	assert(var8, "Bad humanoid")
	return arg1._ikBinders.IKRig:Promise(arg2)
end
function module.SetAimPosition(arg1, arg2, arg3) -- Line 110
	assert(arg1._serviceBag, "Not initialized")
	if arg2 ~= arg2 then
		warn("[IKServiceClient.SetAimPosition] - position is NaN")
	else
		local any_GetLocalAimer_result1 = arg1:GetLocalAimer()
		if not any_GetLocalAimer_result1 then return end
		any_GetLocalAimer_result1:SetAimPosition(arg2, arg3)
	end
end
function module.SetLookAround(arg1, arg2) -- Line 137
	assert(arg1._serviceBag, "Not initialized")
	arg1._lookAround = arg2
end
function module.GetLocalAimer(arg1) -- Line 148
	assert(arg1._serviceBag, "Not initialized")
	local any_GetLocalPlayerRig_result1 = arg1:GetLocalPlayerRig()
	if not any_GetLocalPlayerRig_result1 then
		return nil
	end
	return any_GetLocalPlayerRig_result1:GetLocalPlayerAimer()
end
local Players_upvr = game:GetService("Players")
function module.GetLocalPlayerRig(arg1) -- Line 164
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: Players_upvr (readonly)
	]]
	assert(arg1._serviceBag, "Not initialized")
	assert(arg1._ikBinders.IKRig, "Not initialize")
	return var1_result1_upvr_2.getPlayerIKRig(arg1._ikBinders.IKRig, Players_upvr.LocalPlayer)
end
local Workspace_upvr = game:GetService("Workspace")
function module._updateStepped(arg1) -- Line 171
	--[[ Upvalues[2]:
		[1]: Workspace_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	debug.profilebegin("IKUpdate")
	local any_GetLocalAimer_result1_2 = arg1:GetLocalAimer()
	if any_GetLocalAimer_result1_2 then
		any_GetLocalAimer_result1_2:SetLookAround(arg1._lookAround)
		any_GetLocalAimer_result1_2:UpdateStepped()
	end
	for _, v in pairs(arg1._ikBinders.IKRig:GetAll()) do
		debug.profilebegin("RigUpdate")
		local any_GetPositionOrNil_result1 = v:GetPositionOrNil()
		if any_GetPositionOrNil_result1 then
			if var1_result1_upvr_2.getTimeBeforeNextUpdate((Workspace_upvr.CurrentCamera.CFrame.p - any_GetPositionOrNil_result1).Magnitude) <= tick() - v:GetLastUpdateTime() then
				v:Update()
			else
				v:UpdateTransformOnly()
			end
		end
		debug.profileend()
	end
	debug.profileend()
end
function module.Destroy(arg1) -- Line 205
	arg1._maid:DoCleaning()
end
return module