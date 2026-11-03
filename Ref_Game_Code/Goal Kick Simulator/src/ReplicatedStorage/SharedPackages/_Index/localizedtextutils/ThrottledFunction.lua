-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:42
-- Luau version 6, Types version 3
-- Time taken: 0.003119 seconds

local module_upvr = {
	ClassName = "ThrottledFunction";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3) -- Line 10
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._nextCallTimeStamp = 0
	local var3 = arg1
	if not var3 then
		var3 = error("No timeoutInSeconds")
	end
	setmetatable_result1._timeout = var3
	var3 = arg2
	local var4 = var3
	if not var4 then
		var4 = error("No func")
	end
	setmetatable_result1._func = var4
	setmetatable_result1._trailingValue = nil
	setmetatable_result1._callLeading = true
	setmetatable_result1._callTrailing = true
	setmetatable_result1:_configureOrError(arg3)
	return setmetatable_result1
end
function module_upvr.Call(arg1, ...) -- Line 27
	if arg1._trailingValue then
		arg1._trailingValue = table.pack(...)
	else
		if arg1._nextCallTimeStamp <= tick() then
			if arg1._callLeading or arg1._callLeadingFirstTime then
				arg1._callLeadingFirstTime = false
				arg1._nextCallTimeStamp = tick() + arg1._timeout
				arg1._func(...)
			else
				if arg1._callTrailing then
					arg1._trailingValue = table.pack(...)
					task.delay(arg1._timeout, function() -- Line 40
						--[[ Upvalues[1]:
							[1]: arg1 (readonly)
						]]
						if arg1.Destroy then
							arg1:_dispatch()
						end
					end)
					return
				end
				error("[ThrottledFunction.Cleanup] - Trailing and leading are both disabled")
			end
		end
		if arg1._callLeading or arg1._callTrailing or arg1._callLeadingFirstTime then
			arg1._callLeadingFirstTime = false
			arg1._trailingValue = table.pack(...)
			task.delay(arg1._nextCallTimeStamp - tick(), function() -- Line 54
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				if arg1.Destroy then
					arg1:_dispatch()
				end
			end)
		end
	end
end
function module_upvr._dispatch(arg1) -- Line 62
	arg1._nextCallTimeStamp = tick() + arg1._timeout
	local _trailingValue = arg1._trailingValue
	if _trailingValue then
		arg1._trailingValue = nil
		arg1._func(unpack(_trailingValue, 1, _trailingValue.n))
	end
end
function module_upvr._configureOrError(arg1, arg2) -- Line 73
	if arg2 == nil then
	else
		if type(arg2) ~= "table" then
		else
		end
		assert(true, "Bad throttleConfig")
		local pairs_result1, pairs_result2, pairs_result3 = pairs(arg2)
		for i, v in pairs_result1, pairs_result2, pairs_result3 do
			local var15
			if type(v) ~= "boolean" then
				var15 = false
			else
				var15 = true
			end
			assert(var15, "Bad throttleConfig entry")
			if i == "leading" then
				arg1._callLeading = v
			elseif i == "trailing" then
				arg1._callTrailing = v
			elseif i == "leadingFirstTimeOnly" then
				arg1._callLeadingFirstTime = v
			else
				var15 = "Bad key %q in config":format(tostring(i))
				error(var15)
			end
		end
		pairs_result2 = arg1._callLeading
		local var16 = pairs_result2
		if not var16 then
			var16 = arg1._callTrailing
		end
		assert(var16, "Cannot configure both leading and trailing disabled")
	end
end
function module_upvr.Destroy(arg1) -- Line 97
	arg1._trailingValue = nil
	arg1._func = nil
	setmetatable(arg1, nil)
end
return module_upvr