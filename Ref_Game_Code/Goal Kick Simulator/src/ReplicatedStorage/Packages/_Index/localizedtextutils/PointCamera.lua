-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:07
-- Luau version 6, Types version 3
-- Time taken: 0.001295 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "PointCamera";
}
function module_upvr.new(arg1, arg2) -- Line 20
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var4 = arg1
	if not var4 then
		var4 = error("Must have originCamera")
	end
	setmetatable_result1.OriginCamera = var4
	var4 = arg2
	local var5 = var4
	if not var5 then
		var5 = error("Must have focusCamera")
	end
	setmetatable_result1.FocusCamera = var5
	return setmetatable_result1
end
local var1_result1_upvr = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 29
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 33
	if arg2 == "OriginCamera" or arg2 == "FocusCamera" then
		rawset(arg1, arg2, arg3)
	else
		error(arg2.." is not a valid member of PointCamera")
	end
end
local var1_result1_upvr_2 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 41
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local Origin = arg1.Origin
		local Focus = arg1.Focus
		local any_new_result1 = var1_result1_upvr_2.new()
		any_new_result1.FieldOfView = Origin.FieldOfView + Focus.FieldOfView
		any_new_result1.CFrame = CFrame.new(Origin.Position, Focus.Position)
		return any_new_result1
	end
	if arg2 == "Focus" then
		return arg1.FocusCamera.CameraState
	end
	if arg2 == "Origin" then
		return arg1.OriginCamera.CameraState
	end
	return module_upvr[arg2]
end
return module_upvr