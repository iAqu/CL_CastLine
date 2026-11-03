-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:22
-- Luau version 6, Types version 3
-- Time taken: 0.001942 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "FadingCamera";
}
local var1_result1_upvr = any_load_result1("Spring")
function module_upvr.new(arg1) -- Line 17
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.Spring = var1_result1_upvr.new(0)
	local var5 = arg1
	if not var5 then
		var5 = error("No camera")
	end
	setmetatable_result1.Camera = var5
	setmetatable_result1.Damper = 1
	setmetatable_result1.Speed = 15
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 29
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 33
	if arg2 == "Damper" then
		arg1.Spring.Damper = arg3
	else
		if arg2 == "value" then
			arg1.Spring.Value = arg3
			return
		end
		if arg2 == "Speed" then
			arg1.Spring.Speed = arg3
			return
		end
		if arg2 == "Target" then
			arg1.Spring.Target = arg3
			return
		end
		if arg2 == "Spring" or arg2 == "Camera" then
			rawset(arg1, arg2, arg3)
			return
		end
		error(arg2.." is not a valid member of fading camera")
	end
end
function module_upvr.__index(arg1, arg2) -- Line 55
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local CameraState = arg1.Camera.CameraState
		if not CameraState then
			CameraState = arg1.Camera
		end
		return CameraState * arg1.Spring.Value
	end
	if arg2 == "Damper" then
		return arg1.Spring.Damper
	end
	if arg2 == "value" then
		return arg1.Spring.Value
	end
	if arg2 == "Speed" then
		return arg1.Spring.Speed
	end
	if arg2 == "Target" then
		return arg1.Spring.Target
	end
	if arg2 == "Velocity" then
		return arg1.Spring.Velocity
	end
	if arg2 == "HasReachedTarget" then
		local var8 = false
		if math.abs(arg1.Value - arg1.Target) < 0.0001 then
			if math.abs(arg1.Velocity) >= 0.0001 then
				var8 = false
			else
				var8 = true
			end
		end
		return var8
	end
	return module_upvr[arg2]
end
return module_upvr