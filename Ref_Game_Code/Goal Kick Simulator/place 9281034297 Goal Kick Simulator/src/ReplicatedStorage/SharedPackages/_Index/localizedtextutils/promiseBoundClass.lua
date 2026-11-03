-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:29
-- Luau version 6, Types version 3
-- Time taken: 0.001536 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("Maid")
return function(arg1, arg2, arg3) -- Line 20
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local var5_upvr
	if type(arg1) ~= "table" then
		var5_upvr = false
	else
		var5_upvr = true
	end
	assert(var5_upvr, "'binder' must be table")
	if typeof(arg2) ~= "Instance" then
		var5_upvr = false
	else
		var5_upvr = true
	end
	assert(var5_upvr, "'inst' must be instance")
	local any_Get_result1 = arg1:Get(arg2)
	if any_Get_result1 then
		var5_upvr = var1_result1_upvr_2.resolved(any_Get_result1)
		return var5_upvr
	end
	var5_upvr = var1_result1_upvr.new()
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	if arg3 then
		arg3:ErrorIfCancelled()
		var5_upvr:GivePromise(arg3.PromiseCancelled):Then(function() -- Line 34
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr:Reject()
		end)
	end
	var5_upvr:GiveTask(arg1:ObserveInstance(arg2, function(arg1_2) -- Line 39
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		if arg1_2 then
			any_new_result1_upvr:Resolve(arg1_2)
		end
	end))
	task.delay(5, function() -- Line 45
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		if any_new_result1_upvr:IsPending() then
			warn("[promiseBoundClass] - Infinite yield possible on %q for binder %q\n":format(arg2:GetFullName(), arg1:GetTag()))
		end
	end)
	any_new_result1_upvr:Finally(function() -- Line 52
		--[[ Upvalues[1]:
			[1]: var5_upvr (readonly)
		]]
		var5_upvr:Destroy()
	end)
	return any_new_result1_upvr
end