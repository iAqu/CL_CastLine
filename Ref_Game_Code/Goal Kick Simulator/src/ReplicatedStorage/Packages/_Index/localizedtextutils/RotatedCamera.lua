-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:06
-- Luau version 6, Types version 3
-- Time taken: 0.002494 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "RotatedCamera";
	_maxY = 1.3962634015954636;
	_minY = -1.3962634015954636;
	_angleXZ = 0;
	_angleY = 0;
}
function module_upvr.new() -- Line 28
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return setmetatable({}, module_upvr)
end
local var1_result1_upvr_2 = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 34
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.new(arg1, arg2)
end
function module_upvr.RotateXY(arg1, arg2) -- Line 41
	arg1.AngleX += arg2.x
	arg1.AngleY += arg2.y
end
local var1_result1_upvr = any_load_result1("getRotationInXZPlane")
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 46
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		local var1_result1_upvr_result1 = var1_result1_upvr(arg3)
		arg1.AngleXZ = math.atan2(var1_result1_upvr_result1.lookVector.x, var1_result1_upvr_result1.lookVector.z) + math.pi
		arg1.AngleY = math.asin(var1_result1_upvr_result1:toObjectSpace(arg3).lookVector.y)
	else
		if arg2 == "AngleY" then
			arg1._angleY = math.clamp(arg3, arg1.MinY, arg1.MaxY)
			return
		end
		if arg2 == "AngleX" or arg2 == "AngleXZ" then
			arg1._angleXZ = arg3
			do
				return
			end
			local var6
		end
		if arg2 == "MaxY" then
			if arg1.MinY > arg3 then
				var6 = false
			else
				var6 = true
			end
			assert(var6, "MaxY must be greater than MinY")
			arg1._maxY = arg3
			arg1.AngleY = arg1.AngleY
			return
		end
		if arg2 == "MinY" then
			if arg3 > arg1.MaxY then
				var6 = false
			else
				var6 = true
			end
			assert(var6, "MinY must be less than MaxY")
			arg1._minY = arg3
			arg1.AngleY = arg1.AngleY
			return
		end
		if module_upvr[arg2] ~= nil then
			rawset(arg1, arg2, arg3)
			return
		end
		error(arg2.." is not a valid member or RotatedCamera")
	end
end
local var1_result1_upvr_3 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 78
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = var1_result1_upvr_3.new()
		any_new_result1.CFrame = arg1.CFrame
		return any_new_result1
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
	if arg2 == "AngleX" or arg2 == "AngleXZ" then
		return arg1._angleXZ
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