-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:57
-- Luau version 6, Types version 3
-- Time taken: 0.004781 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "SmoothRotatedCamera";
	_maxY = 1.3962634015954636;
	_minY = -1.3962634015954636;
	_zoomGiveY = 0.08726646259971647;
}
local any_load_result1_result1_upvr_2 = any_load_result1("Spring")
function module_upvr.new() -- Line 24
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.SpringX = any_load_result1_result1_upvr_2.new(0)
	setmetatable_result1.SpringY = any_load_result1_result1_upvr_2.new(0)
	setmetatable_result1.Speed = 15
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 34
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.new(arg1, arg2)
end
function module_upvr.RotateXY(arg1, arg2) -- Line 41
	arg1.AngleX += arg2.x
	arg1.AngleY += arg2.y
	arg1.TargetAngleX = arg1.AngleX
	arg1.TargetAngleY = arg1.AngleY
end
local any_load_result1_result1_upvr_3 = any_load_result1("getRotationInXZPlane")
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 48
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		local any_load_result1_result1_upvr_3_result1 = any_load_result1_result1_upvr_3(arg3)
		arg1.AngleXZ = math.atan2(any_load_result1_result1_upvr_3_result1.lookVector.x, any_load_result1_result1_upvr_3_result1.lookVector.z) + math.pi
		arg1.AngleY = math.asin(any_load_result1_result1_upvr_3_result1:toObjectSpace(arg3).lookVector.y)
	else
		if arg2 == "TargetCFrame" then
			local var6_result1 = any_load_result1_result1_upvr_3(arg3)
			arg1.TargetAngleXZ = math.atan2(var6_result1.lookVector.x, var6_result1.lookVector.z) + math.pi
			arg1.TargetAngleY = math.asin(var6_result1:toObjectSpace(arg3).lookVector.y)
			return
		end
		if arg2 == "AngleY" then
			arg1.SpringY.Value = arg3
			return
		end
		if arg2 == "AngleX" or arg2 == "AngleXZ" then
			arg1.SpringX.Value = arg3
			return
		end
		if arg2 == "TargetAngleY" then
			arg1.SpringY.Target = arg3
			return
		end
		if arg2 == "TargetAngleX" or arg2 == "TargetAngleXZ" then
			arg1.SpringX.Target = arg3
			do
				return
			end
			local var9
		end
		if arg2 == "MaxY" then
			if arg1.MinY > arg3 then
				var9 = false
			else
				var9 = true
			end
			assert(var9, "MaxY must be greater than MinY")
			arg1._maxY = arg3
			return
		end
		if arg2 == "MinY" then
			if arg3 > arg1.MaxY then
				var9 = false
			else
				var9 = true
			end
			assert(var9, "MinY must be less than MaxY")
			arg1._minY = arg3
			return
		end
		if arg2 == "SpeedAngleX" or arg2 == "SpeedAngleXZ" then
			arg1.SpringX.Speed = arg3
			return
		end
		if arg2 == "SpeedAngleY" then
			arg1.SpringY.Speed = arg3
			return
		end
		if arg2 == "Speed" then
			arg1.SpeedAngleX = arg3
			arg1.SpeedAngleY = arg3
			return
		end
		if arg2 == "ZoomGiveY" then
			arg1._zoomGiveY = arg3
			return
		end
		if module_upvr[arg2] ~= nil or arg2 == "SpringX" or arg2 == "SpringY" then
			rawset(arg1, arg2, arg3)
			return
		end
		error(arg2.." is not a valid member or SmoothRotatedCamera")
	end
end
function module_upvr.SnapIntoBounds(arg1) -- Line 91
	arg1.TargetAngleY = math.clamp(arg1.TargetAngleY, arg1.MinY, arg1.MaxY)
end
function module_upvr.GetPastBounds(arg1, arg2) -- Line 95
	if arg2 < arg1.MinY then
		return arg2 - arg1.MinY
	end
	if arg1.MaxY < arg2 then
		return arg2 - arg1.MaxY
	end
	return 0
end
local any_load_result1_result1_upvr_4 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 105
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = any_load_result1_result1_upvr_4.new()
		any_new_result1.CFrame = arg1.CFrame
		return any_new_result1
	end
	if arg2 == "LookVector" then
		return arg1.Rotation.lookVector
	end
	if arg2 == "CFrame" then
		return CFrame.Angles(0, arg1.RenderAngleXZ, 0) * CFrame.Angles(arg1.RenderAngleY, 0, 0)
	end
	if arg2 == "TargetCFrame" then
		return CFrame.Angles(0, arg1.TargetAngleXZ, 0) * CFrame.Angles(arg1.TargetAngleY, 0, 0)
	end
	if arg2 == "RenderAngleY" then
		local AngleY = arg1.AngleY
		local any_GetPastBounds_result1 = arg1:GetPastBounds(AngleY)
		local var14 = 1 - 0.25 ^ math.abs(math.abs(any_GetPastBounds_result1) / arg1.ZoomGiveY)
		if any_GetPastBounds_result1 < 0 then
			return arg1.MinY - arg1.ZoomGiveY * var14
		end
		if 0 < any_GetPastBounds_result1 then
			return arg1.MaxY + arg1.ZoomGiveY * var14
		end
		return AngleY
	end
	if arg2 == "RenderAngleX" or arg2 == "RenderAngleXZ" then
		return arg1.AngleX
	end
	if arg2 == "AngleY" then
		return arg1.SpringY.Value
	end
	if arg2 == "AngleX" or arg2 == "AngleXZ" then
		return arg1.SpringX.Value
	end
	if arg2 == "TargetAngleY" then
		return arg1.SpringY.Target
	end
	if arg2 == "TargetAngleX" or arg2 == "TargetAngleXZ" then
		return arg1.SpringX.Target
	end
	if arg2 == "SpeedAngleY" then
		return arg1.SpringX.Speed
	end
	if arg2 == "MaxY" then
		return arg1._maxY
	end
	if arg2 == "MinY" then
		return arg1._minY
	end
	if arg2 == "ZoomGiveY" then
		return arg1._zoomGiveY
	end
	return module_upvr[arg2]
end
return module_upvr