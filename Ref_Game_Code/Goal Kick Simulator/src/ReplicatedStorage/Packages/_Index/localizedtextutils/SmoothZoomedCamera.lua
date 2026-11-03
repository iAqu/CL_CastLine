-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:59
-- Luau version 6, Types version 3
-- Time taken: 0.002667 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "SmoothZoomedCamera";
	_maxZoom = 100;
	_minZoom = 0.5;
	BounceAtEnd = true;
}
local var1_result1_upvr = any_load_result1("Spring")
function module_upvr.new() -- Line 21
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.Spring = var1_result1_upvr.new(0)
	setmetatable_result1.Speed = 15
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("SummedCamera")
function module_upvr.__add(arg1, arg2) -- Line 30
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.new(arg1, arg2)
end
function module_upvr.ZoomIn(arg1, arg2, arg3, arg4) -- Line 34
	if arg3 or arg4 then
		arg1.Zoom -= math.clamp(arg2, arg3 or (-math.huge), arg4 or math.huge)
	else
		arg1.Zoom -= arg2
	end
end
function module_upvr.Impulse(arg1, arg2) -- Line 42
	arg1.Spring:Impulse(arg2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 46
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 2. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [2] 2. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 3. Error Block 33 start (CF ANALYSIS FAILED)
	arg1.Spring.Target = math.clamp(arg3, arg1.MinZoom, arg1.MaxZoom)
	-- KONSTANTERROR: [4] 3. Error Block 33 end (CF ANALYSIS FAILED)
end
local var1_result1_upvr_2 = any_load_result1("CameraState")
function module_upvr.__index(arg1, arg2) -- Line 81
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg2 == "CameraState" then
		local any_new_result1 = var1_result1_upvr_2.new()
		any_new_result1.Position = Vector3.new(0, 0, arg1.Zoom)
		return any_new_result1
	end
	if arg2 == "Zoom" or arg2 == "value" then
		return arg1.Spring.Value
	end
	if arg2 == "TargetPercentZoom" then
		return (arg1.Target - arg1.MinZoom) / arg1.Range
	end
	if arg2 == "PercentZoom" then
		return (arg1.Zoom - arg1.MinZoom) / arg1.Range
	end
	if arg2 == "MaxZoom" then
		return arg1._maxZoom
	end
	if arg2 == "MinZoom" then
		return arg1._minZoom
	end
	if arg2 == "Range" then
		return arg1.MaxZoom - arg1.MinZoom
	end
	if arg2 == "Damper" then
		return arg1.Spring.Damper
	end
	if arg2 == "Speed" then
		return arg1.Spring.Speed
	end
	if arg2 == "Target" or arg2 == "TargetZoom" then
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