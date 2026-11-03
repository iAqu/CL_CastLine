-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:31
-- Luau version 6, Types version 3
-- Time taken: 0.003011 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "CameraStack"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new() -- Line 16
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._stack = {}
	setmetatable_result1._disabledSet = {}
	return setmetatable_result1
end
local HttpService_upvr = game:GetService("HttpService")
function setmetatable_result1_2_upvr.PushDisable(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	assert(arg1._stack, "Not initialized")
	local any_GenerateGUID_result1_upvr = HttpService_upvr:GenerateGUID(false)
	arg1._disabledSet[any_GenerateGUID_result1_upvr] = true
	return function() -- Line 35
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_GenerateGUID_result1_upvr (readonly)
		]]
		arg1._disabledSet[any_GenerateGUID_result1_upvr] = nil
	end
end
function setmetatable_result1_2_upvr.PrintCameraStack(arg1) -- Line 43
	assert(arg1._stack, "Stack is not initialized yet")
	for _, v in pairs(arg1._stack) do
		local var15
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var15 = v.ClassName
			return var15
		end
		if type(v) ~= "table" or not INLINED() then
			var15 = tostring(v)
		end
		print(tostring(var15))
	end
end
function setmetatable_result1_2_upvr.GetTopCamera(arg1) -- Line 55
	assert(arg1._stack, "Not initialized")
	return arg1._stack[#arg1._stack]
end
function setmetatable_result1_2_upvr.GetTopState(arg1) -- Line 65
	assert(arg1._stack, "Stack is not initialized yet")
	if next(arg1._disabledSet) then
	else
		if 10 < #arg1._stack then
			warn("[CameraStack] - Stack is bigger than 10 in CameraStack (%d)":format(#arg1._stack))
		end
		local var16 = arg1._stack[#arg1._stack]
		if type(var16) == "table" then
			local var17 = var16.CameraState or var16
			if var17 then
				return var17
			end
			warn("[CameraStack] - No top state!")
			return nil
		end
		if var16 ~= nil then
			warn("[CameraStack] - Bad type on top of stack")
			return nil
		end
	end
end
local any_load_result1_result1_upvr = any_load_result1("CustomCameraEffect")
function setmetatable_result1_2_upvr.GetNewStateBelow(arg1) -- Line 97
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	assert(arg1._stack, "Stack is not initialized yet")
	local var19_upvw
	return any_load_result1_result1_upvr.new(function() -- Line 102
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var19_upvw (read and write)
		]]
		local any_GetIndex_result1_2 = arg1:GetIndex(var19_upvw)
		if any_GetIndex_result1_2 then
			local var22 = arg1._stack[any_GetIndex_result1_2 - 1]
			if var22 then
				return var22.CameraState or var22
			end
			warn("[CameraStack] - Could not get state below, found current state. Returning default.")
			return arg1._stack[1].CameraState
		end
		warn("[CameraStack] - Could not get state from %q, returning default":format(tostring(var19_upvw)))
		return arg1._stack[1].CameraState
	end), function(arg1_2) -- Line 116
		--[[ Upvalues[1]:
			[1]: var19_upvw (read and write)
		]]
		var19_upvw = arg1_2
	end
end
function setmetatable_result1_2_upvr.GetIndex(arg1, arg2) -- Line 127
	assert(arg1._stack, "Stack is not initialized yet")
	for i_2, v_2 in pairs(arg1._stack) do
		if v_2 == arg2 then
			return i_2
		end
	end
end
function setmetatable_result1_2_upvr.GetStack(arg1) -- Line 146
	assert(arg1._stack, "Not initialized")
	return arg1._stack
end
function setmetatable_result1_2_upvr.Remove(arg1, arg2) -- Line 156
	assert(arg1._stack, "Stack is not initialized yet")
	local any_GetIndex_result1 = arg1:GetIndex(arg2)
	if any_GetIndex_result1 then
		table.remove(arg1._stack, any_GetIndex_result1)
	end
end
function setmetatable_result1_2_upvr.Add(arg1, arg2) -- Line 170
	assert(arg1._stack, "Stack is not initialized yet")
	table.insert(arg1._stack, arg2)
	return function() -- Line 175
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1:Remove(arg2)
	end
end
return setmetatable_result1_2_upvr