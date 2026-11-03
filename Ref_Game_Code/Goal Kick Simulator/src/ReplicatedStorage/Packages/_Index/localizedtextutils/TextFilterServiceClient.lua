-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:42
-- Luau version 6, Types version 3
-- Time taken: 0.004533 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("TextFilterServiceConstants")
local module = {
	ServiceName = "TextFilterServiceClient";
	PromiseNonChatStringForUser = function(arg1, arg2, arg3) -- Line 16, Named "PromiseNonChatStringForUser"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (readonly)
		]]
		local var5
		if type(arg2) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad text")
		if type(arg3) ~= "number" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad fromUserId")
		return arg1:_promiseInvokeRemoteFunction(var1_result1_upvr.REQUEST_NON_CHAT_STRING_FOR_USER, arg2, arg3)
	end;
	PromiseNonChatStringForBroadcast = function(arg1, arg2, arg3) -- Line 26, Named "PromiseNonChatStringForBroadcast"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (readonly)
		]]
		local var6
		if type(arg2) ~= "string" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad text")
		if type(arg3) ~= "number" then
			var6 = false
		else
			var6 = true
		end
		assert(var6, "Bad fromUserId")
		return arg1:_promiseInvokeRemoteFunction(var1_result1_upvr.REQUEST_NON_CHAT_STRING_FOR_BROADCAST, arg2, arg3)
	end;
	PromisePreviewNonChatStringForBroadcast = function(arg1, arg2) -- Line 36, Named "PromisePreviewNonChatStringForBroadcast"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (readonly)
		]]
		local var7
		if type(arg2) ~= "string" then
			var7 = false
		else
			var7 = true
		end
		assert(var7, "Bad text")
		return arg1:_promiseInvokeRemoteFunction(var1_result1_upvr.REQUEST_PREVIEW_NON_CHAT_STRING_FOR_BROADCAST, arg2)
	end;
}
local RunService_upvr = game:GetService("RunService")
function module._promiseInvokeRemoteFunction(arg1, arg2, arg3, ...) -- Line 44
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var9
	if type(arg2) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad request")
	if type(arg3) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad text")
	var9 = ...
	var9 = RunService_upvr:IsRunning()
	if not var9 then
		var9 = arg1:_fakeTestFilter(arg3)
		return var9
	end
	var9 = arg1:_promiseRemoteFunction()
	local packed_upvr = table.pack(var9)
	var9 = var9:Then(function(arg1_2) -- Line 55
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
			[4]: packed_upvr (readonly)
		]]
		return var1_result1_upvr_2.spawn(function(arg1_3, arg2_2) -- Line 56
			--[[ Upvalues[4]:
				[1]: arg1_2 (readonly)
				[2]: arg2 (copied, readonly)
				[3]: arg3 (copied, readonly)
				[4]: packed_upvr (copied, readonly)
			]]
			local var21_upvw
			local var22_upvw
			local pcall_result1, pcall_result2 = pcall(function() -- Line 58
				--[[ Upvalues[6]:
					[1]: var21_upvw (read and write)
					[2]: var22_upvw (read and write)
					[3]: arg1_2 (copied, readonly)
					[4]: arg2 (copied, readonly)
					[5]: arg3 (copied, readonly)
					[6]: packed_upvr (copied, readonly)
				]]
				local any_InvokeServer_result1_2, any_InvokeServer_result2 = arg1_2:InvokeServer(arg2, arg3, table.unpack(packed_upvr, 1, packed_upvr.n))
				var21_upvw = any_InvokeServer_result1_2
				var22_upvw = any_InvokeServer_result2
			end)
			if not pcall_result1 then
				return arg2_2(pcall_result2)
			end
			if not var21_upvw then
				return arg2_2(var22_upvw or "Failed to get a valid result from server")
			end
			if type(var22_upvw) ~= "string" then
				local var28 = pcall_result2
				if not var28 then
					var28 = var22_upvw
					if not var28 then
						var28 = "Failed to get string result from server"
					end
				end
				return arg2_2(var28)
			end
			return arg1_3(var22_upvw)
		end)
	end)
	return var9
end
local var1_result1_upvr_3 = any_load_result1("PromiseGetRemoteFunction")
function module._promiseRemoteFunction(arg1) -- Line 79
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	if arg1._remoteFunctionPromise then
		return arg1._remoteFunctionPromise
	end
	arg1._remoteFunctionPromise = var1_result1_upvr_3(var1_result1_upvr.REMOTE_FUNCTION_NAME)
	return arg1._remoteFunctionPromise
end
function module._fakeTestFilter(arg1, arg2) -- Line 88
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any_gsub_result1_upvw = arg2:gsub("[fF][uU][cC][kK]", "####")
	return var1_result1_upvr_2.spawn(function(arg1_4, arg2_3) -- Line 91
		--[[ Upvalues[1]:
			[1]: any_gsub_result1_upvw (read and write)
		]]
		task.delay(0.5, function() -- Line 93
			--[[ Upvalues[2]:
				[1]: arg1_4 (readonly)
				[2]: any_gsub_result1_upvw (copied, read and write)
			]]
			arg1_4(any_gsub_result1_upvw)
		end)
	end)
end
return module