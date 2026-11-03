-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:10
-- Luau version 6, Types version 3
-- Time taken: 0.001155 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "XZPlaneLockCamera";
}
function module_upvr.new(arg1) -- Line 15
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var4 = arg1
	if not var4 then
		var4 = error("No camera")
	end
	setmetatable_result1._camera = var4
	return setmetatable_result1
end
local var1_result1_upvr_3 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 23
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	return var1_result1_upvr_3.new(arg1, arg2)
end
local var1_result1_upvr = any_load_result1("getRotationInXZPlane")
local var1_result1_upvr_2 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 27
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local CameraState = arg1._camera.CameraState
		if not CameraState then
			CameraState = arg1._camera
		end
		local any_new_result1 = var1_result1_upvr_2.new()
		any_new_result1.CFrame = var1_result1_upvr(CameraState.CFrame)
		any_new_result1.FieldOfView = CameraState.FieldOfView
		return any_new_result1
	end
	return module_upvr[arg2]
end
return module_upvr