-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:47
-- Luau version 6, Types version 3
-- Time taken: 0.009240 seconds

local Promise_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Promise)
local DataStoreService_upvr = game:GetService("DataStoreService")
local module_upvr = {
	promiseDataStore = function(arg1, arg2) -- Line 22, Named "promiseDataStore"
		--[[ Upvalues[2]:
			[1]: Promise_upvr (readonly)
			[2]: DataStoreService_upvr (readonly)
		]]
		local var5
		if type(arg1) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad name")
		if type(arg2) ~= "string" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad scope")
		var5 = Promise_upvr
		function var5(arg1_2, arg2_2) -- Line 26
			--[[ Upvalues[3]:
				[1]: DataStoreService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local var6_upvw
			local pcall_result1_8, pcall_result2_7 = pcall(function() -- Line 28
				--[[ Upvalues[4]:
					[1]: var6_upvw (read and write)
					[2]: DataStoreService_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg2 (copied, readonly)
				]]
				var6_upvw = DataStoreService_upvr:GetDataStore(arg1, arg2)
			end)
			if not pcall_result1_8 then
				return arg2_2(pcall_result2_7)
			end
			return arg1_2(var6_upvw)
		end
		return var5.new(var5)
	end;
	promiseOrderedDataStore = function(arg1, arg2) -- Line 45, Named "promiseOrderedDataStore"
		--[[ Upvalues[2]:
			[1]: Promise_upvr (readonly)
			[2]: DataStoreService_upvr (readonly)
		]]
		local var11
		if type(arg1) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad name")
		if type(arg2) ~= "string" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad scope")
		var11 = Promise_upvr
		function var11(arg1_3, arg2_3) -- Line 49
			--[[ Upvalues[3]:
				[1]: DataStoreService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local var12_upvw
			local pcall_result1_5, pcall_result2_9 = pcall(function() -- Line 51
				--[[ Upvalues[4]:
					[1]: var12_upvw (read and write)
					[2]: DataStoreService_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg2 (copied, readonly)
				]]
				var12_upvw = DataStoreService_upvr:GetOrderedDataStore(arg1, arg2)
			end)
			if not pcall_result1_5 then
				return arg2_3(pcall_result2_9)
			end
			return arg1_3(var12_upvw)
		end
		return var11.new(var11)
	end;
	getAsync = function(arg1, arg2) -- Line 67, Named "getAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		local var17
		if typeof(arg1) ~= "Instance" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Bad robloxDataStore")
		if type(arg2) ~= "string" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Bad key")
		var17 = Promise_upvr
		function var17(arg1_4, arg2_4) -- Line 71
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			local var18_upvw
			local pcall_result1_9, pcall_result2_3 = pcall(function() -- Line 73
				--[[ Upvalues[3]:
					[1]: var18_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
				]]
				var18_upvw = arg1:GetAsync(arg2)
			end)
			if not pcall_result1_9 then
				return arg2_4(pcall_result2_3)
			end
			return arg1_4(var18_upvw)
		end
		return var17.spawn(var17)
	end;
	updateAsync = function(arg1, arg2, arg3) -- Line 91, Named "updateAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
		local var23
		if typeof(arg1) ~= "Instance" then
			var23 = false
		else
			var23 = true
		end
		assert(var23, "Bad robloxDataStore")
		if type(arg2) ~= "string" then
			var23 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
		var23 = true
		assert(var23, "Bad key")
		if type(arg3) ~= "function" then
			var23 = false
		else
			var23 = true
		end
		assert(var23, "Bad updateFunc")
		var23 = Promise_upvr
		function var23(arg1_5, arg2_5) -- Line 96
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: arg3 (readonly)
			]]
			local var24_upvw
			local pcall_result1_4, pcall_result2_4 = pcall(function() -- Line 98
				--[[ Upvalues[4]:
					[1]: var24_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
					[4]: arg3 (copied, readonly)
				]]
				var24_upvw = {arg1:UpdateAsync(arg2, arg3)}
			end)
			if not pcall_result1_4 then
				return arg2_5(pcall_result2_4)
			end
			if not var24_upvw then
				return arg2_5("No result loaded")
			end
			return arg1_5(unpack(var24_upvw))
		end
		do
			return var23.spawn(var23)
		end
		-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
	end;
	setAsync = function(arg1, arg2, arg3, arg4) -- Line 119, Named "setAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		local var30
		if typeof(arg1) ~= "Instance" then
			var30 = false
		else
			var30 = true
		end
		assert(var30, "Bad robloxDataStore")
		if type(arg2) ~= "string" then
			var30 = false
		else
			var30 = true
		end
		assert(var30, "Bad key")
		var30 = true
		if type(arg4) ~= "table" then
			if arg4 ~= nil then
				var30 = false
			else
				var30 = true
			end
		end
		assert(var30, "Bad userIds")
		var30 = Promise_upvr
		function var30(arg1_6, arg2_6) -- Line 124
			--[[ Upvalues[4]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: arg3 (readonly)
				[4]: arg4 (readonly)
			]]
			local pcall_result1_10, pcall_result2_5 = pcall(function() -- Line 125
				--[[ Upvalues[4]:
					[1]: arg1 (copied, readonly)
					[2]: arg2 (copied, readonly)
					[3]: arg3 (copied, readonly)
					[4]: arg4 (copied, readonly)
				]]
				arg1:SetAsync(arg2, arg3, arg4)
			end)
			if not pcall_result1_10 then
				return arg2_6(pcall_result2_5)
			end
			return arg1_6(true)
		end
		return var30.spawn(var30)
	end;
	promiseIncrementAsync = function(arg1, arg2, arg3) -- Line 142, Named "promiseIncrementAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		local var35
		if typeof(arg1) ~= "Instance" then
			var35 = false
		else
			var35 = true
		end
		assert(var35, "Bad robloxDataStore")
		if type(arg2) ~= "string" then
			var35 = false
		else
			var35 = true
		end
		assert(var35, "Bad key")
		var35 = true
		if type(arg3) ~= "number" then
			if arg3 ~= nil then
				var35 = false
			else
				var35 = true
			end
		end
		assert(var35, "Bad delta")
		var35 = Promise_upvr
		function var35(arg1_7, arg2_7) -- Line 147
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: arg3 (readonly)
			]]
			local pcall_result1_6, pcall_result2_6 = pcall(function() -- Line 148
				--[[ Upvalues[3]:
					[1]: arg1 (copied, readonly)
					[2]: arg2 (copied, readonly)
					[3]: arg3 (copied, readonly)
				]]
				arg1:IncrementAsync(arg2, arg3)
			end)
			if not pcall_result1_6 then
				return arg2_7(pcall_result2_6)
			end
			return arg1_7(true)
		end
		return var35.spawn(var35)
	end;
	removeAsync = function(arg1, arg2) -- Line 164, Named "removeAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		local var40
		if typeof(arg1) ~= "Instance" then
			var40 = false
		else
			var40 = true
		end
		assert(var40, "Bad robloxDataStore")
		if type(arg2) ~= "string" then
			var40 = false
		else
			var40 = true
		end
		assert(var40, "Bad key")
		var40 = Promise_upvr
		function var40(arg1_8, arg2_8) -- Line 168
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			local pcall_result1_3, pcall_result2_8 = pcall(function() -- Line 169
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg2 (copied, readonly)
				]]
				arg1:RemoveAsync(arg2)
			end)
			if not pcall_result1_3 then
				return arg2_8(pcall_result2_8)
			end
			return arg1_8(true)
		end
		return var40.spawn(var40)
	end;
	promiseSortedPagesAsync = function(arg1, arg2, arg3, arg4, arg5) -- Line 191, Named "promiseSortedPagesAsync"
		--[[ Upvalues[1]:
			[1]: Promise_upvr (readonly)
		]]
		local var45 = false
		if typeof(arg1) == "Instance" then
			var45 = arg1:IsA("OrderedDataStore")
		end
		assert(var45, "Bad orderedDataStore")
		if type(arg2) ~= "boolean" then
			var45 = false
		else
			var45 = true
		end
		assert(var45, "Bad ascending")
		if type(arg3) ~= "number" then
			var45 = false
		else
			var45 = true
		end
		assert(var45, "Bad entries")
		var45 = Promise_upvr
		function var45(arg1_9, arg2_9) -- Line 196
			--[[ Upvalues[5]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: arg3 (readonly)
				[4]: arg4 (readonly)
				[5]: arg5 (readonly)
			]]
			local var46_upvw
			local pcall_result1_2, pcall_result2 = pcall(function() -- Line 198
				--[[ Upvalues[6]:
					[1]: var46_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (copied, readonly)
					[4]: arg3 (copied, readonly)
					[5]: arg4 (copied, readonly)
					[6]: arg5 (copied, readonly)
				]]
				var46_upvw = arg1:GetSortedAsync(arg2, arg3, arg4, arg5)
			end)
			if not pcall_result1_2 then
				return arg2_9(pcall_result2)
			end
			if typeof(var46_upvw) ~= "Instance" then
				return arg2_9(pcall_result2)
			end
			return arg1_9(var46_upvw)
		end
		return var45.spawn(var45)
	end;
}
function module_upvr.promiseOrderedEntries(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 232
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Promise_upvr (readonly)
	]]
	local var50 = false
	if typeof(arg1) == "Instance" then
		var50 = arg1:IsA("OrderedDataStore")
	end
	assert(var50, "Bad orderedDataStore")
	if type(arg2) ~= "boolean" then
		var50 = false
	else
		var50 = true
	end
	assert(var50, "Bad ascending")
	if type(arg4) ~= "number" then
		var50 = false
	else
		var50 = true
	end
	assert(var50, "Bad entries")
	var50 = module_upvr
	var50 = arg1
	return var50.promiseSortedPagesAsync(var50, arg2, arg3, arg5, arg6):Then(function(arg1_10) -- Line 238
		--[[ Upvalues[2]:
			[1]: Promise_upvr (copied, readonly)
			[2]: arg4 (readonly)
		]]
		return Promise_upvr.spawn(function(arg1_11, arg2_10) -- Line 239
			--[[ Upvalues[2]:
				[1]: arg4 (copied, readonly)
				[2]: arg1_10 (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local const_number_2 = 0
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [36] 27. Error Block 22 start (CF ANALYSIS FAILED)
			if const_number_2 < arg4 then
				local pcall_result1, pcall_result2_2 = pcall(function() -- Line 261
					--[[ Upvalues[1]:
						[1]: arg1_10 (copied, readonly)
					]]
					arg1_10:AdvanceToNextPageAsync()
				end)
				if not pcall_result1 then
					return arg2_10(pcall_result2_2)
				end
			end
			-- KONSTANTERROR: [36] 27. Error Block 22 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [3] 3. Error Block 2 start (CF ANALYSIS FAILED)
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [49.1106]
			-- KONSTANTERROR: [3] 3. Error Block 2 end (CF ANALYSIS FAILED)
		end)
	end)
end
return module_upvr