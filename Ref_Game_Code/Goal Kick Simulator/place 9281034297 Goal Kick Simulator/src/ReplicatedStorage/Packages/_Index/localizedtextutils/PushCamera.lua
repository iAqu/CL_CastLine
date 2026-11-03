-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:10
-- Luau version 6, Types version 3
-- Time taken: 0.003615 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "PushCamera";
	_maxY = 1.3962634015954636;
	_minY = -1.3962634015954636;
	_angleXZ0 = 0;
	_angleY = 0;
	FadeBackTime = 0.5;
	DefaultAngleXZ0 = 0;
	_lastUpdateTime = -1;
	PushBackAfter = 0.5;
}
function module_upvr.new() -- Line 32
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return setmetatable({}, module_upvr)
end
local any_load_result1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 38
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.RotateXY(arg1, arg2) -- Line 45
	arg1.AngleX += arg2.x
	arg1.AngleY += arg2.y
end
function module_upvr.StopRotateBack(arg1) -- Line 54
	arg1.CFrame = arg1.CFrame
end
function module_upvr.Reset(arg1) -- Line 61
	arg1.LastUpdateTime = 0
end
local var1_result1_upvr = any_load_result1("getRotationInXZPlane")
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 65
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		local var1_result1_upvr_result1 = var1_result1_upvr(arg3)
		arg1.AngleXZ = math.atan2(var1_result1_upvr_result1.lookVector.x, var1_result1_upvr_result1.lookVector.z) + math.pi
		arg1.AngleY = math.asin(var1_result1_upvr_result1:toObjectSpace(arg3).lookVector.y)
	else
		if arg2 == "DefaultCFrame" then
			local var1_result1_upvr_result1_2 = var1_result1_upvr(arg3)
			arg1.DefaultAngleXZ0 = math.atan2(var1_result1_upvr_result1_2.lookVector.x, var1_result1_upvr_result1_2.lookVector.z) + math.pi
			arg1.AngleY = math.asin(var1_result1_upvr_result1_2:toObjectSpace(arg3).lookVector.y)
			return
		end
		if arg2 == "AngleY" then
			arg1._angleY = math.clamp(arg3, arg1.MinY, arg1.MaxY)
			return
		end
		if arg2 == "AngleX" or arg2 == "AngleXZ" then
			arg1.LastUpdateTime = tick()
			arg1._angleXZ0 = arg3
			do
				return
			end
			local var7
		end
		if arg2 == "MaxY" then
			if arg1.MinY >= arg3 then
				var7 = false
			else
				var7 = true
			end
			assert(var7, "MaxY must be greater than MinY")
			arg1._maxY = arg3
			arg1.AngleY = arg1.AngleY
			return
		end
		if arg2 == "MinY" then
			if arg3 >= arg1.MinY then
				var7 = false
			else
				var7 = true
			end
			assert(var7, "MinY must be less than MeeeaxY")
			arg1._maxY = arg3
			arg1.AngleY = arg1.AngleY
			return
		end
		if arg2 == "LastUpdateTime" then
			arg1._lastUpdateTime = arg3
			return
		end
		if module_upvr[arg2] ~= nil then
			rawset(arg1, arg2, arg3)
			return
		end
		error(arg2.." is not a valid member or PushCamera")
	end
end
local any_load_result1_result1_upvr = any_load_result1("CameraState")
local any_load_result1_result1_upvr_3 = any_load_result1("Math")
function module_upvr.__index(arg1, arg2) -- Line 106
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = any_load_result1_result1_upvr.new()
		any_new_result1.CFrame = arg1.CFrame
		return any_new_result1
	end
	if arg2 == "LastUpdateTime" then
		return arg1._lastUpdateTime
	end
	if arg2 == "LookVector" then
		return arg1.Rotation.lookVector
	end
	if arg2 == "CFrame" then
		return CFrame.Angles(0, arg1.AngleXZ, 0) * CFrame.Angles(arg1.AngleY, 0, 0)
	end
	if arg2 == "AngleY" then
		return arg1._angleY
	end
	if arg2 == "PushBackDelta" then
		return tick() - arg1.LastUpdateTime - arg1.PushBackAfter
	end
	if arg2 == "PercentFaded" then
		return math.clamp(arg1.PushBackDelta / arg1.FadeBackTime, 0, 1)
	end
	if arg2 == "PercentFadedCurved" then
		return arg1.PercentFaded ^ 2
	end
	if arg2 == "AngleX" or arg2 == "AngleXZ" then
		return any_load_result1_result1_upvr_3.lerp(arg1._angleXZ0, arg1.DefaultAngleXZ0, arg1.PercentFadedCurved)
	end
	if arg2 == "MaxY" then
		return arg1._maxY
	end
	if arg2 == "MinY" then
		return arg1._minY
	end
	return module_upvr[arg2]
end
return module_upvr