-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:43
-- Luau version 6, Types version 3
-- Time taken: 0.001614 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "CancelToken";
}
module_upvr.__index = module_upvr
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("Signal")
function module_upvr.new(arg1) -- Line 21
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local var5 = module_upvr
	local setmetatable_result1_upvr = setmetatable({}, var5)
	if type(arg1) ~= "function" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad executor")
	setmetatable_result1_upvr.PromiseCancelled = var1_result1_upvr_2.new()
	setmetatable_result1_upvr.Cancelled = var1_result1_upvr.new()
	setmetatable_result1_upvr.PromiseCancelled:Then(function() -- Line 30
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Cancelled:Fire()
		setmetatable_result1_upvr.Cancelled:Destroy()
	end)
	arg1(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr:_cancel()
	end)
	return setmetatable_result1_upvr
end
local function var9_upvr() -- Line 42
end
function module_upvr.fromMaid(arg1) -- Line 50
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var9_upvr (readonly)
	]]
	local any_new_result1_upvr = module_upvr.new(var9_upvr)
	local any_GiveTask_result1_upvr = arg1:GiveTask(function() -- Line 53
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:_cancel()
	end)
	any_new_result1_upvr.PromiseCancelled:Then(function() -- Line 57
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_GiveTask_result1_upvr (readonly)
		]]
		arg1[any_GiveTask_result1_upvr] = nil
	end)
	return any_new_result1_upvr
end
function module_upvr.ErrorIfCancelled(arg1) -- Line 67
	if not arg1.PromiseCancelled:IsPending() then
		error("[CancelToken.ErrorIfCancelled] - Cancelled")
	end
end
function module_upvr.IsCancelled(arg1) -- Line 77
	return arg1.PromiseCancelled:IsFulfilled()
end
function module_upvr._cancel(arg1) -- Line 81
	arg1.PromiseCancelled:Resolve()
end
return module_upvr