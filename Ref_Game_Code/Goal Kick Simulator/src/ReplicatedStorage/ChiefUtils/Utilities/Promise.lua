-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:39
-- Luau version 6, Types version 3
-- Time taken: 0.010649 seconds

local var1_upvw
local module_upvr = {
	ClassName = "Promise";
}
module_upvr.__index = module_upvr
function module_upvr.isPromise(arg1) -- Line 21
	local var3 = false
	if type(arg1) == "table" then
		if arg1.ClassName ~= "Promise" then
			var3 = false
		else
			var3 = true
		end
	end
	return var3
end
function module_upvr.new(arg1) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local tbl = {
		_pendingExecuteList = {};
		_unconsumedException = true;
	}
	local call_stack = debug.traceback()
	if not call_stack then
		call_stack = ""
	end
	tbl._source = call_stack
	local setmetatable_result1 = setmetatable(tbl, module_upvr)
	if type(arg1) == "function" then
		arg1(setmetatable_result1:_getResolveReject())
	end
	return setmetatable_result1
end
function module_upvr.spawn(arg1) -- Line 53
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_new_result1_7 = module_upvr.new()
	task.spawn(arg1, any_new_result1_7:_getResolveReject())
	return any_new_result1_7
end
function module_upvr.defer(arg1) -- Line 66
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_new_result1_6 = module_upvr.new()
	task.defer(arg1, any_new_result1_6:_getResolveReject())
	return any_new_result1_6
end
function module_upvr.resolved(...) -- Line 80
	--[[ Upvalues[2]:
		[1]: var1_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	local arg_count_4 = select('#', ...)
	if arg_count_4 == 0 then
		return var1_upvw
	end
	if arg_count_4 == 1 then
		if module_upvr.isPromise(...) then
			local var13 = ...
			if not var13._pendingExecuteList then
				return var13
			end
		end
	end
	local any_new_result1_4 = module_upvr.new()
	any_new_result1_4:Resolve(...)
	return any_new_result1_4
end
local var15_upvw
function module_upvr.rejected(...) -- Line 104
	--[[ Upvalues[2]:
		[1]: var15_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	local arg_count_2 = select('#', ...)
	if arg_count_2 == 0 then
		return var15_upvw
	end
	local any_new_result1_5 = module_upvr.new()
	any_new_result1_5:_reject({...}, arg_count_2)
	return any_new_result1_5
end
function module_upvr.IsPending(arg1) -- Line 120
	local var19
	if arg1._pendingExecuteList == nil then
		var19 = false
	else
		var19 = true
	end
	return var19
end
function module_upvr.IsFulfilled(arg1) -- Line 128
	local var20
	if arg1._fulfilled == nil then
		var20 = false
	else
		var20 = true
	end
	return var20
end
function module_upvr.IsRejected(arg1) -- Line 136
	local var21
	if arg1._rejected == nil then
		var21 = false
	else
		var21 = true
	end
	return var21
end
function module_upvr.Wait(arg1) -- Line 146
	if arg1._fulfilled then
		return unpack(arg1._fulfilled, 1, arg1._valuesLength)
	end
	if arg1._rejected then
		return error(tostring(arg1._rejected[1]), 2)
	end
	local BindableEvent_upvr = Instance.new("BindableEvent")
	arg1:Then(function() -- Line 154
		--[[ Upvalues[1]:
			[1]: BindableEvent_upvr (readonly)
		]]
		BindableEvent_upvr:Fire()
	end, function() -- Line 156
		--[[ Upvalues[1]:
			[1]: BindableEvent_upvr (readonly)
		]]
		BindableEvent_upvr:Fire()
	end)
	BindableEvent_upvr.Event:Wait()
	BindableEvent_upvr:Destroy()
	if arg1._rejected then
		return error(tostring(arg1._rejected[1]), 2)
	end
	return unpack(arg1._fulfilled, 1, arg1._valuesLength)
end
function module_upvr.Yield(arg1) -- Line 178
	if arg1._fulfilled then
		return true, unpack(arg1._fulfilled, 1, arg1._valuesLength)
	end
	if arg1._rejected then
		return false, unpack(arg1._rejected, 1, arg1._valuesLength)
	end
	local BindableEvent_upvr_2 = Instance.new("BindableEvent")
	arg1:Then(function() -- Line 186
		--[[ Upvalues[1]:
			[1]: BindableEvent_upvr_2 (readonly)
		]]
		BindableEvent_upvr_2:Fire()
	end, function() -- Line 188
		--[[ Upvalues[1]:
			[1]: BindableEvent_upvr_2 (readonly)
		]]
		BindableEvent_upvr_2:Fire()
	end)
	BindableEvent_upvr_2.Event:Wait()
	BindableEvent_upvr_2:Destroy()
	if arg1._fulfilled then
		return true, unpack(arg1._fulfilled, 1, arg1._valuesLength)
	end
	if arg1._rejected then
		return false, unpack(arg1._rejected, 1, arg1._valuesLength)
	end
end
function module_upvr.Resolve(arg1, ...) -- Line 208
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if not arg1._pendingExecuteList then
	else
		local arg_count = select('#', ...)
		if arg_count == 0 then
			arg1:_fulfill({}, 0)
			return
		end
		if arg1 == ... then
			arg1:Reject("TypeError: Resolved to self")
			return
		end
		if module_upvr.isPromise(...) then
			if 1 < arg_count then
				warn("When resolving a promise, extra arguments are discarded! See:\n\n%s":format(arg1._source))
			end
			local var29 = ...
			if var29._pendingExecuteList then
				var29._unconsumedException = false
				var29._pendingExecuteList[#var29._pendingExecuteList + 1] = {function(...) -- Line 229
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					arg1:Resolve(...)
				end, function(...) -- Line 232
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					if arg1._pendingExecuteList then
						arg1:_reject({...}, select('#', ...))
					end
				end, nil}
			else
				if var29._rejected then
					var29._unconsumedException = false
					arg1:_reject(var29._rejected, var29._valuesLength)
					return
				end
				if var29._fulfilled then
					arg1:_fulfill(var29._fulfilled, var29._valuesLength)
					return
				end
				error("[Promise.Resolve] - Bad promise2 state")
			end
		end
		if type(...) == "function" then
			if 1 < arg_count then
				warn("When resolving a function, extra arguments are discarded! See:\n\n%s":format(arg1._source))
			end
			...(arg1:_getResolveReject())
			return
		end
		arg1:_fulfill({...}, arg_count)
	end
end
function module_upvr._fulfill(arg1, arg2, arg3) -- Line 271
	if not arg1._pendingExecuteList then
	else
		arg1._fulfilled = arg2
		arg1._valuesLength = arg3
		arg1._pendingExecuteList = nil
		for _, v in pairs(arg1._pendingExecuteList) do
			arg1:_executeThen(unpack(v))
		end
	end
end
function module_upvr.Reject(arg1, ...) -- Line 290
	arg1:_reject({...}, select('#', ...))
end
function module_upvr._reject(arg1, arg2, arg3) -- Line 294
	if not arg1._pendingExecuteList then
	else
		arg1._rejected = arg2
		arg1._valuesLength = arg3
		arg1._pendingExecuteList = nil
		for _, v_2 in pairs(arg1._pendingExecuteList) do
			arg1:_executeThen(unpack(v_2))
		end
		if arg1._unconsumedException and 0 < arg1._valuesLength then
			task.defer(function() -- Line 310
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				if arg1._unconsumedException then
					warn("[Promise] - Uncaught exception in promise\n\n%q\n\n%s":format(tostring(arg1._rejected[1]), arg1._source))
				end
			end)
		end
	end
end
function module_upvr.Then(arg1, arg2, arg3) -- Line 343
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if type(arg3) == "function" then
		arg1._unconsumedException = false
	end
	if arg1._pendingExecuteList then
		local any_new_result1 = module_upvr.new()
		local tbl_2 = {}
		tbl_2[1] = arg2
		tbl_2[2] = arg3
		tbl_2[3] = any_new_result1
		arg1._pendingExecuteList[#arg1._pendingExecuteList + 1] = tbl_2
		return any_new_result1
	end
	return arg1:_executeThen(arg2, arg3, nil)
end
function module_upvr.Tap(arg1, arg2, arg3) -- Line 365
	local any_Then_result1 = arg1:Then(arg2, arg3)
	if any_Then_result1 == arg1 then
		return any_Then_result1
	end
	if any_Then_result1._fulfilled then
		return arg1
	end
	if any_Then_result1._rejected then
		return arg1
	end
	if any_Then_result1._pendingExecuteList then
		local function returnSelf() -- Line 381
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			return arg1
		end
		return any_Then_result1:Then(returnSelf, returnSelf)
	end
	error("Bad result state")
end
function module_upvr.Finally(arg1, arg2) -- Line 396
	return arg1:Then(arg2, arg2)
end
function module_upvr.Catch(arg1, arg2) -- Line 405
	return arg1:Then(nil, arg2)
end
function module_upvr.Destroy(arg1) -- Line 412
	arg1:_reject({}, 0)
end
function module_upvr.GetResults(arg1) -- Line 424
	if arg1._rejected then
		return false, unpack(arg1._rejected, 1, arg1._valuesLength)
	end
	if arg1._fulfilled then
		return true, unpack(arg1._fulfilled, 1, arg1._valuesLength)
	end
	error("Still pending")
end
function module_upvr._getResolveReject(arg1) -- Line 434
	return function(...) -- Line 435
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:Resolve(...)
	end, function(...) -- Line 437
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_reject({...}, select('#', ...))
	end
end
function module_upvr._executeThen(arg1, arg2, arg3, arg4) -- Line 449
	--[[ Upvalues[2]:
		[1]: var1_upvw (read and write)
		[2]: module_upvr (readonly)
	]]
	if arg1._fulfilled then
		if type(arg2) == "function" then
			if arg4 then
				arg4:Resolve(arg2(unpack(arg1._fulfilled, 1, arg1._valuesLength)))
				return arg4
			end
			local packed = table.pack(arg2(unpack(arg1._fulfilled, 1, arg1._valuesLength)))
			if packed.n == 0 then
				return var1_upvw
			end
			if packed.n == 1 and module_upvr.isPromise(packed[1]) then
				return packed[1]
			end
			local any_new_result1_3 = module_upvr.new()
			any_new_result1_3:Resolve(table.unpack(packed, 1, packed.n))
			return any_new_result1_3
		end
		if arg4 then
			arg4:_fulfill(arg1._fulfilled, arg1._valuesLength)
			return arg4
		end
		return arg1
	end
	if arg1._rejected then
		if type(arg3) == "function" then
			if arg4 then
				arg4:Resolve(arg3(unpack(arg1._rejected, 1, arg1._valuesLength)))
				return arg4
			end
			local packed_2 = table.pack(arg3(unpack(arg1._rejected, 1, arg1._valuesLength)))
			if packed_2.n == 0 then
				return var1_upvw
			end
			if packed_2.n == 1 and module_upvr.isPromise(packed_2[1]) then
				return packed_2[1]
			end
			local any_new_result1_2 = module_upvr.new()
			any_new_result1_2:Resolve(table.unpack(packed_2, 1, packed_2.n))
			return any_new_result1_2
		end
		if arg4 then
			arg4:_reject(arg1._rejected, arg1._valuesLength)
			return arg4
		end
		return arg1
	end
	error("Internal error: still pending")
end
var1_upvw = module_upvr.new()
var1_upvw:_fulfill({}, 0)
var15_upvw = module_upvr.new()
var15_upvw:_reject({}, 0)
return module_upvr