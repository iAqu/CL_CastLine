-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:34
-- Luau version 6, Types version 3
-- Time taken: 0.001915 seconds

local module_upvr = {
	ClassName = "Maid";
}
function module_upvr.new() -- Line 35
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return setmetatable({
		_tasks = {};
	}, module_upvr)
end
function module_upvr.__index(arg1, arg2) -- Line 45
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	return arg1._tasks[arg2]
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 62
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 4. Error Block 2 start (CF ANALYSIS FAILED)
	error("'%s' is reserved":format(tostring(arg2)), 2)
	-- KONSTANTERROR: [4] 4. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 14. Error Block 3 start (CF ANALYSIS FAILED)
	local _tasks = arg1._tasks
	_tasks[arg2] = arg3
	-- KONSTANTERROR: [17] 14. Error Block 3 end (CF ANALYSIS FAILED)
end
function module_upvr.GiveTask(arg1, arg2) -- Line 93
	assert(arg2, "Task cannot be false or nil")
	local var4 = #arg1._tasks + 1
	arg1[var4] = arg2
	return var4
end
function module_upvr.GiveTasks(arg1, arg2) -- Line 102
	for _, v in pairs(arg2) do
		arg1:GiveTask(v)
	end
end
function module_upvr.GivePromise(arg1, arg2) -- Line 108
	if not arg2:IsPending() then
		return arg2
	end
	local any_resolved_result1 = arg2.resolved(arg2)
	local any_GiveTask_result1_upvr = arg1:GiveTask(any_resolved_result1)
	any_resolved_result1:Finally(function() -- Line 117
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_GiveTask_result1_upvr (readonly)
		]]
		arg1[any_GiveTask_result1_upvr] = nil
	end)
	return any_resolved_result1
end
function module_upvr.DoCleaning(arg1) -- Line 127
	arg1:Destroy()
end
function module_upvr.Destroy(arg1) -- Line 131
	-- KONSTANTERROR: [99] 72. Error Block 23 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [101.1]
	local next_result1, next_result2 = next(nil)
	-- KONSTANTERROR: [99] 72. Error Block 23 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 33 start (CF ANALYSIS FAILED)
	for _, _ in next_result1, next_result2, next_result1 do
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [105.7]
		if nil == "RBXScriptConnection" then
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 33 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [21] 16. Error Block 31 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	-- KONSTANTERROR: [21] 16. Error Block 31 end (CF ANALYSIS FAILED)
end
return module_upvr