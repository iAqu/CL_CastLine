-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:13
-- Luau version 6, Types version 3
-- Time taken: 0.002907 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local Workspace_upvr = game:GetService("Workspace")
local var1_result1_upvr = any_load_result1("CameraState")
local module_upvr = {
	ClassName = "DefaultCamera";
}
local HttpService_upvr = game:GetService("HttpService")
function module_upvr.new() -- Line 26
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: HttpService_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: Workspace_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._key = HttpService_upvr:GenerateGUID(false)
	setmetatable_result1._cameraState = var1_result1_upvr.new(Workspace_upvr.CurrentCamera)
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 35
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.OverrideGlobalFieldOfView(arg1, arg2) -- Line 43
	arg1._cameraState.FieldOfView = arg2
end
function module_upvr.OverrideCameraState(arg1, arg2) -- Line 47
	local var9 = arg2
	if not var9 then
		var9 = error("No CameraState")
	end
	arg1._cameraState = var9
end
function module_upvr.BindToRenderStep(arg1) -- Line 58
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: Workspace_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	RunService_upvr:BindToRenderStep("DefaultCamera_Preupdate"..arg1._key, Enum.RenderPriority.Camera.Value - 2, function() -- Line 59
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Workspace_upvr (copied, readonly)
		]]
		arg1._cameraState:Set(Workspace_upvr.CurrentCamera)
	end)
	RunService_upvr:BindToRenderStep("DefaultCamera_PostUpdate"..arg1._key, Enum.RenderPriority.Camera.Value + 2, function() -- Line 63
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: Workspace_upvr (copied, readonly)
		]]
		arg1._cameraState = var1_result1_upvr.new(Workspace_upvr.CurrentCamera)
	end)
	arg1._cameraState = var1_result1_upvr.new(Workspace_upvr.CurrentCamera)
end
function module_upvr.UnbindFromRenderStep(arg1) -- Line 73
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	RunService_upvr:UnbindFromRenderStep("DefaultCamera_Preupdate"..arg1._key)
	RunService_upvr:UnbindFromRenderStep("DefaultCamera_PostUpdate"..arg1._key)
end
function module_upvr.Destroy(arg1) -- Line 81
	arg1:UnbindFromRenderStep()
end
function module_upvr.__index(arg1, arg2) -- Line 91
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		return rawget(arg1, "_cameraState")
	end
	return module_upvr[arg2]
end
return module_upvr