-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:48
-- Luau version 6, Types version 3
-- Time taken: 0.008665 seconds

local DataStorePromises_upvr = require(script.Parent.DataStorePromises)
local module_upvr = {
	ClassName = "PeriodLeaderboardStore";
}
module_upvr.__index = module_upvr
local BaseObject_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.BaseObject)
function module_upvr.new(arg1, arg2) -- Line 17
	--[[ Upvalues[2]:
		[1]: BaseObject_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(BaseObject_upvr.new(), module_upvr)
	setmetatable_result1._key = assert(arg1, "Bad key")
	setmetatable_result1._periodSeconds = assert(arg2, "No periodSeconds")
	setmetatable_result1._ascending = false
	setmetatable_result1._pageSize = 100
	setmetatable_result1._periodStart = DateTime.fromUniversalTime(2022, 6, 13, 0, 0, 0)
	setmetatable_result1._orderedEntriesCache = {}
	return setmetatable_result1
end
function module_upvr.GetKey(arg1) -- Line 32
	return arg1._key
end
local Maid_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Maid)
function module_upvr.SubscribeToTopN(arg1, arg2, arg3, arg4) -- Line 36
	--[[ Upvalues[1]:
		[1]: Maid_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var6_upvw
	if type(arg2) ~= "number" then
		var6_upvw = false
	else
		var6_upvw = true
	end
	assert(var6_upvw, "Bad refreshWaitTimeSeconds")
	if type(arg3) ~= "number" then
		var6_upvw = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var6_upvw = true
	assert(var6_upvw, "Bad topNRequired")
	if type(arg4) ~= "function" then
		var6_upvw = false
	else
		var6_upvw = true
	end
	assert(var6_upvw, "Bad onRefresh")
	var6_upvw = Maid_upvr
	local any_new_result1 = var6_upvw.new()
	var6_upvw = true
	any_new_result1:GiveTask(function() -- Line 44
		--[[ Upvalues[1]:
			[1]: var6_upvw (read and write)
		]]
		var6_upvw = false
	end)
	task.spawn(function() -- Line 48
		--[[ Upvalues[5]:
			[1]: var6_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: arg3 (readonly)
			[4]: arg4 (readonly)
			[5]: arg2 (readonly)
		]]
		while var6_upvw do
			local any_Yield_result1, any_Yield_result2_upvr = arg1:PromiseOrderedEntries(DateTime.now(), arg3, true):Yield()
			if not any_Yield_result1 then
				warn(any_Yield_result2_upvr or "Failed to refresh")
			else
				task.spawn(function() -- Line 55
					--[[ Upvalues[2]:
						[1]: arg4 (copied, readonly)
						[2]: any_Yield_result2_upvr (readonly)
					]]
					arg4(any_Yield_result2_upvr)
				end)
			end
			task.wait(math.max((arg2) - (os.clock() - os.clock()), 10))
		end
	end)
	do
		return any_new_result1
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.SetPlayerValue(arg1, arg2, arg3, arg4) -- Line 69
	--[[ Upvalues[1]:
		[1]: DataStorePromises_upvr (readonly)
	]]
	local var13
	if typeof(arg2) ~= "DateTime" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad dateTime")
	if type(arg3) ~= "number" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad playerUserId")
	return arg1:_promiseOrderedDataStore(arg2):Then(function(arg1_2) -- Line 74
		--[[ Upvalues[4]:
			[1]: DataStorePromises_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg3 (readonly)
			[4]: arg4 (readonly)
		]]
		return DataStorePromises_upvr.setAsync(arg1_2, arg1:_getPlayerKey(arg3), arg4)
	end)
end
function module_upvr.PromisePlayerValue(arg1, arg2, arg3) -- Line 79
	--[[ Upvalues[1]:
		[1]: DataStorePromises_upvr (readonly)
	]]
	local var15
	if typeof(arg2) ~= "DateTime" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad dateTime")
	if type(arg3) ~= "number" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad playerUserId")
	return arg1:_promiseOrderedDataStore(arg2):Then(function(arg1_3) -- Line 84
		--[[ Upvalues[3]:
			[1]: DataStorePromises_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg3 (readonly)
		]]
		return DataStorePromises_upvr.getAsync(arg1_3, arg1:_getPlayerKey(arg3))
	end)
end
function module_upvr.PromisePlayerRankTopN(arg1, arg2, arg3, arg4) -- Line 89
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var17
	if typeof(arg2) ~= "DateTime" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad dateTime")
	if type(arg3) ~= "number" then
		var17 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var17 = true
	assert(var17, "Bad topNRequired")
	if type(arg4) ~= "number" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "Bad playerUserId")
	var17 = arg1:PromiseOrderedEntries(arg2, arg3)
	local any__getPlayerKey_result1_upvr = arg1:_getPlayerKey(arg4)
	var17 = var17:Then(function(arg1_4) -- Line 97
		--[[ Upvalues[1]:
			[1]: any__getPlayerKey_result1_upvr (readonly)
		]]
		for i, v in pairs(arg1_4) do
			if v.key == any__getPlayerKey_result1_upvr then
				return i
			end
		end
		return nil
	end)
	do
		return var17
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
function module_upvr.PromiseIsPlayerTopN(arg1, arg2, arg3, arg4) -- Line 108
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	local var25
	if typeof(arg2) ~= "DateTime" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad dateTime")
	if type(arg3) ~= "number" then
		var25 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
	var25 = true
	assert(var25, "Bad topNRequired")
	if type(arg4) ~= "number" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad playerUserId")
	do
		return arg1:PromisePlayerRankTopN(arg2, arg3, arg4):Then(function(arg1_5) -- Line 114
			if arg1_5 == nil then
			else
			end
			return true
		end)
	end
	-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
end
local cancellableDelay_upvr = require(script.Parent.cancellableDelay)
function module_upvr.PromiseOrderedEntries(arg1, arg2, arg3, arg4) -- Line 120
	--[[ Upvalues[1]:
		[1]: cancellableDelay_upvr (readonly)
	]]
	local var28_upvr
	if typeof(arg2) ~= "DateTime" then
		var28_upvr = false
	else
		var28_upvr = true
	end
	assert(var28_upvr, "Bad dateTime")
	if type(arg3) ~= "number" then
		var28_upvr = false
	else
		var28_upvr = true
	end
	assert(var28_upvr, "Bad entries")
	local any_GetPeriodDataStoreKey_result1_upvr = arg1:GetPeriodDataStoreKey(arg2)
	var28_upvr = "%s_%d":format(any_GetPeriodDataStoreKey_result1_upvr, arg3)
	if not arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr] then
		arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr] = {}
	end
	if not arg4 and arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr][arg3] then
		return arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr][arg3]
	end
	local any__promiseOrderedEntriesImpl_result1_upvr = arg1:_promiseOrderedEntriesImpl(arg2, arg3)
	arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr][arg3] = any__promiseOrderedEntriesImpl_result1_upvr
	arg1._maid[var28_upvr] = cancellableDelay_upvr(60, function() -- Line 142
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: any_GetPeriodDataStoreKey_result1_upvr (readonly)
			[3]: arg3 (readonly)
			[4]: any__promiseOrderedEntriesImpl_result1_upvr (readonly)
			[5]: var28_upvr (readonly)
		]]
		if arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr][arg3] == any__promiseOrderedEntriesImpl_result1_upvr then
			arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr][arg3] = nil
			if not next(arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr]) then
				arg1._orderedEntriesCache[any_GetPeriodDataStoreKey_result1_upvr] = nil
			end
		end
		arg1._maid[var28_upvr] = nil
	end)
	return any__promiseOrderedEntriesImpl_result1_upvr
end
function module_upvr._promiseOrderedEntriesImpl(arg1, arg2, arg3) -- Line 156
	--[[ Upvalues[1]:
		[1]: DataStorePromises_upvr (readonly)
	]]
	local var32
	if typeof(arg2) ~= "DateTime" then
		var32 = false
	else
		var32 = true
	end
	assert(var32, "Bad dateTime")
	if type(arg3) ~= "number" then
		var32 = false
	else
		var32 = true
	end
	assert(var32, "Bad entryCount")
	return arg1:_promiseOrderedDataStore(arg2):Then(function(arg1_6) -- Line 161
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: DataStorePromises_upvr (copied, readonly)
			[3]: arg3 (readonly)
		]]
		return arg1._maid:GivePromise(DataStorePromises_upvr.promiseOrderedEntries(arg1_6, arg1._ascending, arg1._pageSize, arg3))
	end)
end
function module_upvr.GetPastPeriodDateTime(arg1, arg2, arg3) -- Line 166
	if arg1._periodSeconds == math.huge then
		error("No past period exists")
	end
	return DateTime.fromUnixTimestamp(arg2.UnixTimestamp - (arg3 or 1) * arg1._periodSeconds)
end
function module_upvr._getPlayerKey(arg1, arg2) -- Line 176
	local var34
	if type(arg2) ~= "number" then
		var34 = false
	else
		var34 = true
	end
	assert(var34, "Bad playerUserId")
	var34 = arg2
	return tostring(var34)
end
function module_upvr.GetPeriodDataStoreKey(arg1, arg2) -- Line 182
	local var35
	if typeof(arg2) ~= "DateTime" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad dateTime")
	if arg1._periodSeconds == math.huge then
		return "total"
	end
	var35 = arg2.UnixTimestamp
	var35 = math.floor((var35 - arg1._periodStart.UnixTimestamp) / arg1._periodSeconds)
	return "week_"..var35
end
function module_upvr._promiseOrderedDataStore(arg1, arg2) -- Line 197
	--[[ Upvalues[1]:
		[1]: DataStorePromises_upvr (readonly)
	]]
	return arg1._maid:GivePromise(DataStorePromises_upvr.promiseOrderedDataStore(arg1._key, arg1:GetPeriodDataStoreKey(arg2)))
end
return module_upvr