-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:36
-- Luau version 6, Types version 3
-- Time taken: 0.001388 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "HeartbeatCamera";
	ProfileName = "HeartbeatCamera";
}
local var1_result1_upvr = any_load_result1("Maid")
local RunService_upvr = game:GetService("RunService")
function module_upvr.new(arg1) -- Line 20
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: RunService_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	local var6 = arg1
	if not var6 then
		var6 = error("No camera")
	end
	setmetatable_result1_upvr._camera = var6
	setmetatable_result1_upvr._maid = var1_result1_upvr.new()
	local CameraState_2 = setmetatable_result1_upvr._camera.CameraState
	if not CameraState_2 then
		CameraState_2 = error("Camera state returned null")
	end
	setmetatable_result1_upvr._currentStateCache = CameraState_2
	setmetatable_result1_upvr._maid:GiveTask(RunService_upvr.Heartbeat:Connect(function() -- Line 27
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		debug.profilebegin(setmetatable_result1_upvr.ProfileName)
		local CameraState = setmetatable_result1_upvr._camera.CameraState
		if not CameraState then
			CameraState = error("Camera state returned null")
		end
		setmetatable_result1_upvr._currentStateCache = CameraState
		debug.profileend()
	end))
	return setmetatable_result1_upvr
end
local any_load_result1_result1_upvr = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 36
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.new(arg1, arg2)
end
function module_upvr.ForceUpdateCache(arg1) -- Line 40
	arg1._currentStateCache = arg1._camera.CameraState
end
function module_upvr.__index(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		return arg1._currentStateCache
	end
	return module_upvr[arg2]
end
function module_upvr.Destroy(arg1) -- Line 58
	arg1._maid:DoCleaning()
end
return module_upvr