-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:03
-- Luau version 6, Types version 3
-- Time taken: 0.002353 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "ImpulseCamera";
}
local any_load_result1_result1_upvr = any_load_result1("Spring")
function module_upvr.new() -- Line 17
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({
		_spring = any_load_result1_result1_upvr.new(Vector3.new(0, 0, 0));
	}, module_upvr)
	setmetatable_result1._spring.Damper = 0.5
	setmetatable_result1._spring.Speed = 20
	return setmetatable_result1
end
function module_upvr.Impulse(arg1, arg2) -- Line 32
	local var6
	if typeof(arg2) ~= "Vector3" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad velocity")
	arg1._spring:Impulse(arg2)
end
local any_load_result1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 42
	if arg2 == "Damper" then
		if type(arg3) ~= "number" then
		else
		end
		assert(true, "Bad value")
		arg1._spring.Damper = arg3
		do
			return
		end
		local var8
	end
	if arg2 == "Speed" then
		if type(arg3) ~= "number" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "Bad value")
		arg1._spring.Speed = arg3
	else
		error("%q is not a valid member of impulse camera":format(tostring(arg2)))
	end
end
local any_load_result1_result1_upvr_3 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 60
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = any_load_result1_result1_upvr_3.new()
		local Value = arg1._spring.Value
		any_new_result1.CFrame = CFrame.Angles(0, Value.y, 0) * CFrame.Angles(Value.x, 0, 0) * CFrame.Angles(0, 0, Value.z)
		return any_new_result1
	end
	if arg2 == "Damper" then
		return arg1._spring.Damper
	end
	if arg2 == "Speed" then
		return arg1._spring.Speed
	end
	if arg2 == "Spring" then
		return arg1._spring
	end
	return module_upvr[arg2]
end
return module_upvr