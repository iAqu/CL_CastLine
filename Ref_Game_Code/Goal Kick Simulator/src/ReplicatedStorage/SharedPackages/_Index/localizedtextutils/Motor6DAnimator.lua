-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:46
-- Luau version 6, Types version 3
-- Time taken: 0.003016 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "Motor6DAnimator"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_4 = any_load_result1("StepUtils")
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr.new(arg1) -- Line 19
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: RunService_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1._stack = {}
	local any_bindToSignal_result1, any_bindToSignal_result2 = any_load_result1_result1_upvr_4.bindToSignal(RunService_upvr.Stepped, setmetatable_result1._updateStepped)
	setmetatable_result1._startAnimation = any_bindToSignal_result1
	setmetatable_result1._maid._stopAnimate = any_bindToSignal_result2
	setmetatable_result1:_startAnimation()
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("Symbol")
local any_load_result1_result1_upvr_5 = any_load_result1("Maid")
function setmetatable_result1_upvr.Push(arg1, arg2) -- Line 30
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
	]]
	assert(arg2, "No transformer")
	local any_named_result1_upvr = any_load_result1_result1_upvr.named("transformer")
	local any_new_result1 = any_load_result1_result1_upvr_5.new()
	any_new_result1:GiveTask(arg2.Finished:Connect(function() -- Line 37
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
		]]
		arg1._maid[any_named_result1_upvr] = nil
	end))
	any_new_result1:GiveTask(function() -- Line 41
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		local table_find_result1 = table.find(arg1._stack, arg2)
		if table_find_result1 then
			table.remove(arg1._stack, table_find_result1)
		end
		arg1:_startAnimation()
	end)
	if 10 < #arg1._stack then
		warn("[Motor6DAnimator] - Motor stack overflow (%d)":format(#arg1._stack))
	end
	arg1._maid[any_named_result1_upvr] = any_new_result1
	table.insert(arg1._stack, arg2)
	arg1:_startAnimation()
	return function() -- Line 58
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_named_result1_upvr (readonly)
		]]
		arg1._maid[any_named_result1_upvr] = nil
	end
end
function setmetatable_result1_upvr._getTransformResult(arg1, arg2, arg3) -- Line 63
	return arg2:Transform(function() -- Line 64
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
		]]
		local table_find_result1_2 = table.find(arg1._stack, arg2)
		if not table_find_result1_2 then
			warn("[Motor6DAnimator] - Item is not in stack")
			return arg3
		end
		local var19 = table_find_result1_2 - 1
		if arg1._stack[var19] then
			local any__getTransformResult_result1_2 = arg1:_getTransformResult(arg1._stack[var19], arg3)
			if any__getTransformResult_result1_2 then
				return any__getTransformResult_result1_2
			end
			return arg3
		end
		return arg3
	end)
end
local any_load_result1_result1_upvr_3 = any_load_result1("CFrameUtils")
function setmetatable_result1_upvr._updateStepped(arg1) -- Line 85
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	debug.profilebegin("motor6danimator")
	local var22 = arg1._stack[#arg1._stack]
	local Transform = arg1._obj.Transform
	local var24 = Transform
	if arg1._lastSetTransform then
		local var25 = not any_load_result1_result1_upvr_3.areClose(arg1._lastSetTransform, Transform, 0.001)
		if var25 or not arg1._previousTransform then
			arg1._previousTransform = Transform
		end
		if not var25 then
			var24 = arg1._previousTransform
			-- KONSTANTWARNING: GOTO [39] #28
		end
	else
		arg1._previousTransform = Transform
	end
	if not var22 then
		arg1:_resetTransform(var24)
		debug.profileend()
		return false
	end
	local any__getTransformResult_result1 = arg1:_getTransformResult(var22, var24)
	if any__getTransformResult_result1 then
		arg1._lastSetTransform = any__getTransformResult_result1
		arg1._obj.Transform = any__getTransformResult_result1
		debug.profileend()
		return true
	end
	arg1:_resetTransform(var24)
	debug.profileend()
	return true
end
function setmetatable_result1_upvr._resetTransform(arg1, arg2) -- Line 126
	arg1._obj.Transform = arg2
	arg1._lastSetTransform = nil
	arg1._previousTransform = nil
end
return setmetatable_result1_upvr