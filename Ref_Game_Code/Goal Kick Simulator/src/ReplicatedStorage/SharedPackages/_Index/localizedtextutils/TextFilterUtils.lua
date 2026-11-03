-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:32
-- Luau version 6, Types version 3
-- Time taken: 0.004783 seconds

local TextService_upvr = game:GetService("TextService")
local var2_upvr = require(script.Parent.loader).load(script)("Promise")
local module_upvr = {}
function module_upvr.promiseNonChatStringForBroadcast(arg1, arg2, arg3) -- Line 33
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var4
	if type(arg1) ~= "string" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad text")
	if type(arg2) ~= "number" then
		var4 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var4 = true
	assert(var4, "Bad fromUserId")
	if typeof(arg3) ~= "EnumItem" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad textFilterContext")
	var4 = module_upvr
	var4 = module_upvr.getNonChatStringForBroadcastAsync
	do
		return var4._promiseTextResult(var4, arg1, arg2, arg3)
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
local Chat_upvr = game:GetService("Chat")
function module_upvr.promiseLegacyChatFilter(arg1, arg2) -- Line 54
	--[[ Upvalues[2]:
		[1]: var2_upvr (readonly)
		[2]: Chat_upvr (readonly)
	]]
	local var7 = false
	if typeof(arg1) == "Instance" then
		var7 = arg1:IsA("Player")
	end
	assert(var7, "Bad playerFrom")
	if type(arg2) ~= "string" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad text")
	var7 = var2_upvr
	function var7(arg1_2, arg2_2) -- Line 58
		--[[ Upvalues[3]:
			[1]: Chat_upvr (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		local var8_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 60
			--[[ Upvalues[4]:
				[1]: var8_upvw (read and write)
				[2]: Chat_upvr (copied, readonly)
				[3]: arg2 (copied, readonly)
				[4]: arg1 (copied, readonly)
			]]
			var8_upvw = Chat_upvr:FilterStringForBroadcast(arg2, arg1)
		end)
		if not pcall_result1 then
			return arg2_2(pcall_result2)
		end
		if type(var8_upvw) ~= "string" then
			return arg2_2("Not a string")
		end
		return arg1_2(var8_upvw)
	end
	return var7.spawn(var7)
end
function module_upvr.promiseNonChatStringForUserAsync(arg1, arg2, arg3, arg4) -- Line 84
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 26 start (CF ANALYSIS FAILED)
	local var12
	if type(arg1) ~= "string" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad text")
	if type(arg2) ~= "number" then
		var12 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 26 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 29 start (CF ANALYSIS FAILED)
	var12 = true
	assert(var12, "Bad fromUserId")
	if type(arg3) ~= "number" then
		var12 = false
		-- KONSTANTWARNING: GOTO [39] #30
	end
	-- KONSTANTERROR: [23] 18. Error Block 29 end (CF ANALYSIS FAILED)
end
function module_upvr.getNonChatStringForBroadcastAsync(arg1, arg2, arg3) -- Line 106
	--[[ Upvalues[1]:
		[1]: TextService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 24 start (CF ANALYSIS FAILED)
	local var13
	if type(arg1) ~= "string" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad text")
	if type(arg2) ~= "number" then
		var13 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 24 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 26 start (CF ANALYSIS FAILED)
	var13 = true
	assert(var13, "Bad fromUserId")
	if typeof(arg3) ~= "EnumItem" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad textFilterContext")
	local var14_upvw
	var13 = pcall
	local function var15() -- Line 112
		--[[ Upvalues[5]:
			[1]: TextService_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: var14_upvw (read and write)
		]]
		local any_FilterStringAsync_result1 = TextService_upvr:FilterStringAsync(arg1, arg2, arg3)
		if not any_FilterStringAsync_result1 then
			error("No TextFilterResult")
		end
		var14_upvw = any_FilterStringAsync_result1:GetNonChatStringForBroadcastAsync()
	end
	var13 = var13(var15)
	local var13_result1, var13_result2 = var13(var15)
	if not var13_result1 then
		return false, var13_result2
	end
	do
		return var14_upvw
	end
	-- KONSTANTERROR: [23] 18. Error Block 26 end (CF ANALYSIS FAILED)
end
function module_upvr.getNonChatStringForUserAsync(arg1, arg2, arg3, arg4) -- Line 137
	--[[ Upvalues[1]:
		[1]: TextService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 30 start (CF ANALYSIS FAILED)
	local var19
	if type(arg1) ~= "string" then
		var19 = false
	else
		var19 = true
	end
	assert(var19, "Bad text")
	if type(arg2) ~= "number" then
		var19 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 30 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 33 start (CF ANALYSIS FAILED)
	var19 = true
	assert(var19, "Bad fromUserId")
	if type(arg3) ~= "number" then
		var19 = false
		-- KONSTANTWARNING: GOTO [39] #30
	end
	-- KONSTANTERROR: [23] 18. Error Block 33 end (CF ANALYSIS FAILED)
end
function module_upvr._promiseTextResult(arg1, ...) -- Line 160
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	local args_list_upvr = {...}
	return var2_upvr.spawn(function(arg1_3, arg2) -- Line 163
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: args_list_upvr (readonly)
		]]
		local arg1_result1, arg1_result2 = arg1(unpack(args_list_upvr))
		if not arg1_result1 then
			return arg2(arg1_result2 or "Pcall failed")
		end
		if type(arg1_result1) ~= "string" then
			return arg2("Bad text result")
		end
		arg1_3(arg1_result1)
	end)
end
function module_upvr.hasNonFilteredText(arg1) -- Line 183
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var24
	if type(arg1) ~= "string" then
		var24 = false
	else
		var24 = true
	end
	assert(var24, "Bad text")
	var24 = string.find(arg1, "[^#%s]")
	if var24 == nil then
	else
	end
	return true
end
return module_upvr