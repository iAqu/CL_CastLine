-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:39
-- Luau version 6, Types version 3
-- Time taken: 0.001974 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "ZoomedCamera";
	_maxZoom = 100;
	_minZoom = 0.5;
	_zoom = 10;
}
function module_upvr.new() -- Line 29
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return setmetatable({}, module_upvr)
end
local var1_result1_upvr = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 35
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.new(arg1, arg2)
end
function module_upvr.ZoomIn(arg1, arg2, arg3, arg4) -- Line 39
	if arg3 or arg4 then
		arg1.Zoom -= math.clamp(arg2, arg3 or (-math.huge), arg4 or math.huge)
	else
		arg1.Zoom -= arg2
	end
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 47
	if arg2 == "Zoom" or arg2 == "TargetZoom" then
		arg1._zoom = math.clamp(arg3, arg1.MinZoom, arg1.MaxZoom)
		do
			return
		end
		local var4
	end
	if arg2 == "MaxZoom" then
		if arg1.MinZoom >= arg3 then
			var4 = false
		else
			var4 = true
		end
		assert(var4, "MaxZoom can't be less than MinZoom")
		arg1._maxZoom = arg3
		arg1.Zoom = arg1.Zoom
	else
		if arg2 == "MinZoom" then
			if arg3 >= arg1.MaxZoom then
				var4 = false
			else
				var4 = true
			end
			assert(var4, "MinZoom can't be greater than MinZoom")
			arg1._minZoom = arg3
			arg1.Zoom = arg1.Zoom
			return
		end
		rawset(arg1, arg2, arg3)
	end
end
local any_load_result1_result1_upvr = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 65
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = any_load_result1_result1_upvr.new()
		any_new_result1.Position = Vector3.new(0, 0, arg1.Zoom)
		return any_new_result1
	end
	if arg2 == "Zoom" or arg2 == "TargetZoom" then
		return arg1._zoom
	end
	if arg2 == "MaxZoom" then
		return arg1._maxZoom
	end
	if arg2 == "MinZoom" then
		return arg1._minZoom
	end
	return module_upvr[arg2]
end
return module_upvr