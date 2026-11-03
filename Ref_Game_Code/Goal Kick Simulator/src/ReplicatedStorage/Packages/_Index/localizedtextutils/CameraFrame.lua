-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:25
-- Luau version 6, Types version 3
-- Time taken: 0.004866 seconds

local var1_upvr = require(script.Parent.loader).load(script)("QFrame")
local module_upvr = {
	ClassName = "CameraFrame";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2) -- Line 20
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var4 = arg1
	if not var4 then
		var4 = var1_upvr.new()
	end
	setmetatable_result1.QFrame = var4
	setmetatable_result1.FieldOfView = arg2 or 0
	return setmetatable_result1
end
function module_upvr.isCameraFrame(arg1) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var5
	if getmetatable(arg1) ~= module_upvr then
		var5 = false
	else
		var5 = true
	end
	return var5
end
function module_upvr.__index(arg1, arg2) -- Line 63
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		local any_toCFrame_result1 = var1_upvr.toCFrame(arg1.QFrame)
		if not any_toCFrame_result1 then
			any_toCFrame_result1 = warn("[CameraFrame] - NaN")
		end
		return any_toCFrame_result1
	end
	if arg2 == "Position" then
		local any_toPosition_result1 = var1_upvr.toPosition(arg1.QFrame)
		if not any_toPosition_result1 then
			any_toPosition_result1 = warn("[CameraFrame] - NaN")
		end
		return any_toPosition_result1
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("'%s' is not a valid index of CameraState":format(tostring(arg2)))
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 75
	--[[ Upvalues[1]:
		[1]: var1_upvr (readonly)
	]]
	if arg2 == "CFrame" then
		if typeof(arg3) ~= "CFrame" then
		else
		end
		assert(true, "Bad value")
		local any_fromCFrameClosestTo_result1 = var1_upvr.fromCFrameClosestTo(arg3, arg1.QFrame)
		assert(any_fromCFrameClosestTo_result1, "Failed to convert")
		rawset(arg1, "QFrame", any_fromCFrameClosestTo_result1)
		do
			return
		end
		local var9
	end
	if arg2 == "Position" then
		if typeof(arg3) ~= "Vector3" then
			var9 = false
		else
			var9 = true
		end
		assert(var9, "Bad value")
		local QFrame = arg1.QFrame
		var9 = rawset
		var9(arg1, "QFrame", var1_upvr.new(arg3.x, arg3.y, arg3.z, QFrame.W, QFrame.X, QFrame.Y, QFrame.Z))
	else
		if arg2 == "FieldOfView" or arg2 == "QFrame" then
			var9 = arg1
			rawset(var9, arg2, arg3)
			return
		end
		error("'%s' is not a valid index of CameraState":format(tostring(arg2)))
	end
end
function module_upvr.__add(arg1, arg2) -- Line 101
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_isCameraFrame_result1 = module_upvr.isCameraFrame(arg1)
	if any_isCameraFrame_result1 then
		any_isCameraFrame_result1 = module_upvr.isCameraFrame(arg2)
	end
	assert(any_isCameraFrame_result1, "CameraFrame + non-CameraFrame attempted")
	return module_upvr.new(arg1.QFrame + arg2.QFrame, arg1.FieldOfView + arg2.FieldOfView)
end
function module_upvr.__sub(arg1, arg2) -- Line 114
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_isCameraFrame_result1_2 = module_upvr.isCameraFrame(arg1)
	if any_isCameraFrame_result1_2 then
		any_isCameraFrame_result1_2 = module_upvr.isCameraFrame(arg2)
	end
	assert(any_isCameraFrame_result1_2, "CameraFrame - non-CameraFrame attempted")
	return module_upvr.new(arg1.QFrame - arg2.QFrame, arg1.FieldOfView - arg2.FieldOfView)
end
function module_upvr.__unm(arg1) -- Line 126
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.new(-arg1.QFrame, -arg1.FieldOfView)
end
function module_upvr.__mul(arg1, arg2) -- Line 136
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if type(arg1) == "number" and module_upvr.isCameraFrame(arg2) then
		return module_upvr.new(arg1 * arg2.QFrame, arg1 * arg2.FieldOfView)
	end
	if module_upvr.isCameraFrame(arg2) and type(arg2) == "number" then
		return module_upvr.new(arg1.QFrame * arg2, arg1.FieldOfView * arg2)
	end
	if module_upvr.isCameraFrame(arg1) and module_upvr.isCameraFrame(arg2) then
		return module_upvr.new(arg1.QFrame * arg2.QFrame, arg1.FieldOfView * arg2.FieldOfView)
	end
	error("CameraFrame * non-CameraFrame attempted")
end
function module_upvr.__div(arg1, arg2) -- Line 154
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.isCameraFrame(arg1) and type(arg2) == "number" then
		return module_upvr.new(arg1.QFrame / arg2, arg1.FieldOfView / arg2)
	end
	error("CameraFrame * non-CameraFrame attempted")
end
function module_upvr.__pow(arg1, arg2) -- Line 168
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr.isCameraFrame(arg1) and type(arg2) == "number" then
		return module_upvr.new(arg1.QFrame ^ arg2, arg1.FieldOfView ^ arg2)
	end
	error("CameraFrame ^ non-CameraFrame attempted")
end
function module_upvr.__eq(arg1, arg2) -- Line 182
	local var13 = false
	if arg1.QFrame == arg2.QFrame then
		if arg1.FieldOfView ~= arg2.FieldOfView then
			var13 = false
		else
			var13 = true
		end
	end
	return var13
end
return module_upvr