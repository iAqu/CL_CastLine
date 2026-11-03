-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:41
-- Luau version 6, Types version 3
-- Time taken: 0.002191 seconds

local Promise_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Promise)
local module_upvr = {}
local UserService_upvr = game:GetService("UserService")
function module_upvr.promiseUserInfosByUserIds(arg1) -- Line 24
	--[[ Upvalues[2]:
		[1]: Promise_upvr (readonly)
		[2]: UserService_upvr (readonly)
	]]
	local var5
	if type(arg1) ~= "table" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad userIds")
	var5 = Promise_upvr
	function var5(arg1_2, arg2) -- Line 27
		--[[ Upvalues[2]:
			[1]: UserService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local var6_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 29
			--[[ Upvalues[3]:
				[1]: var6_upvw (read and write)
				[2]: UserService_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			var6_upvw = UserService_upvr:GetUserInfosByUserIdsAsync(arg1)
		end)
		if not pcall_result1 then
			return arg2(pcall_result2)
		end
		if type(var6_upvw) ~= "table" then
			return arg2("Failed to get an array of user infos back")
		end
		return arg1_2(var6_upvw)
	end
	return var5.spawn(var5)
end
function module_upvr.promiseUserInfo(arg1) -- Line 50
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Promise_upvr (readonly)
	]]
	local var10
	if type(arg1) ~= "number" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "Bad userId")
	var10 = module_upvr
	var10 = {}
	var10[1] = arg1
	return var10.promiseUserInfosByUserIds(var10):Then(function(arg1_3) -- Line 54
		--[[ Upvalues[1]:
			[1]: Promise_upvr (copied, readonly)
		]]
		local _1 = arg1_3[1]
		if not _1 then
			return Promise_upvr.rejected("Failed to retrieve data for userId")
		end
		return _1
	end)
end
function module_upvr.promiseDisplayName(arg1) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var13
	if type(arg1) ~= "number" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad userId")
	var13 = module_upvr
	var13 = arg1
	return var13.promiseUserInfo(var13):Then(function(arg1_4) -- Line 75
		return arg1_4.DisplayName
	end)
end
function module_upvr.promiseUserName(arg1) -- Line 86
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var15
	if type(arg1) ~= "number" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad userId")
	var15 = module_upvr
	var15 = arg1
	return var15.promiseUserInfo(var15):Then(function(arg1_5) -- Line 90
		return arg1_5.Username
	end)
end
return module_upvr