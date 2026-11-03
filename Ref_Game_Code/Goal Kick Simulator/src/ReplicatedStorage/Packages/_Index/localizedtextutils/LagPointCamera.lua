-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:20
-- Luau version 6, Types version 3
-- Time taken: 0.002944 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "LagPointCamera";
	_FocusCamera = nil;
	_OriginCamera = nil;
}
local any_load_result1_result1_upvr_2 = any_load_result1("Spring")
function module_upvr.new(arg1, arg2) -- Line 24
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.FocusSpring = any_load_result1_result1_upvr_2.new(Vector3.new())
	local var5 = arg1
	if not var5 then
		var5 = error("Must have originCamera")
	end
	setmetatable_result1.OriginCamera = var5
	var5 = arg2
	local var6 = var5
	if not var6 then
		var6 = error("Must have focusCamera")
	end
	setmetatable_result1.FocusCamera = var6
	setmetatable_result1.Speed = 10
	return setmetatable_result1
end
local any_load_result1_result1_upvr_3 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 35
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 39
	if arg2 == "FocusCamera" then
		rawset(arg1, '_'..arg2, arg3)
		arg1.FocusSpring.Target = arg1.FocusCamera.CameraState.Position
		arg1.FocusSpring.Position = arg1.FocusSpring.Target
		arg1.FocusSpring.Velocity = Vector3.new(0, 0, 0)
	else
		if arg2 == "OriginCamera" then
			rawset(arg1, '_'..arg2, arg3)
			return
		end
		if arg2 == "LastFocusUpdate" or arg2 == "FocusSpring" then
			rawset(arg1, arg2, arg3)
			return
		end
		if arg2 == "Speed" or arg2 == "Damper" or arg2 == "Velocity" then
			arg1.FocusSpring[arg2] = arg3
			return
		end
		error(arg2.." is not a valid member of LagPointCamera")
	end
end
local any_load_result1_result1_upvr = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 56
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local Origin = arg1.Origin
		local any_new_result1 = any_load_result1_result1_upvr.new()
		any_new_result1.FieldOfView = Origin.FieldOfView + arg1.FocusCamera.CameraState.FieldOfView
		any_new_result1.CFrame = CFrame.new(Origin.Position, arg1.FocusPosition)
		do
			return any_new_result1
		end
		local var11
	end
	if arg2 == "FocusPosition" then
		var11 = nil
		if arg1.LastFocusUpdate then
			var11 = tick() - arg1.LastFocusUpdate
		end
		arg1.LastFocusUpdate = tick()
		arg1.FocusSpring.Target = arg1.FocusCamera.CameraState.Position
		if var11 then
			arg1.FocusSpring:TimeSkip(var11)
		end
		return arg1.FocusSpring.Position
	end
	if arg2 == "Speed" or arg2 == "Damper" or arg2 == "Velocity" then
		return arg1.FocusSpring[arg2]
	end
	if arg2 == "Origin" then
		return arg1.OriginCamera.CameraState
	end
	if arg2 == "FocusCamera" or arg2 == "OriginCamera" then
		if not rawget(arg1, '_'..arg2) then
		end
		return error("Internal error: index does not exist")
	end
	return module_upvr[arg2]
end
return module_upvr