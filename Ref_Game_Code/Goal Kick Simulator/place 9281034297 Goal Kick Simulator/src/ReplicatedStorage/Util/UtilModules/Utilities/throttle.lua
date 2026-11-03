-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:44
-- Luau version 6, Types version 3
-- Time taken: 0.000820 seconds

local ThrottledFunction_upvr = require(script.Parent.ThrottledFunction)
return function(arg1, arg2, arg3) -- Line 19, Named "throttle"
	--[[ Upvalues[1]:
		[1]: ThrottledFunction_upvr (readonly)
	]]
	local var3
	if type(arg1) ~= "number" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "timeoutInSeconds is not a number")
	if type(arg2) ~= "function" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "func is not a function")
	var3 = ThrottledFunction_upvr
	var3 = arg1
	local any_new_result1_upvr = var3.new(var3, arg2, arg3)
	function var3(...) -- Line 25
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Call(...)
	end
	return var3
end