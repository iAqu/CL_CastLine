-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:37
-- Luau version 6, Types version 3
-- Time taken: 0.003081 seconds

local MarketplaceService_upvr = game:GetService("MarketplaceService")
local Promise_upvr = require(game:GetService("ReplicatedStorage").ChiefUtils.Utilities.Promise)
return {
	promiseProductInfo = function(arg1, arg2) -- Line 68, Named "promiseProductInfo"
		--[[ Upvalues[2]:
			[1]: Promise_upvr (readonly)
			[2]: MarketplaceService_upvr (readonly)
		]]
		local var5
		if type(arg1) ~= "number" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad assetId")
		if typeof(arg2) ~= "EnumItem" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad infoType")
		var5 = Promise_upvr
		function var5(arg1_2, arg2_2) -- Line 72
			--[[ Upvalues[3]:
				[1]: MarketplaceService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local var6_upvw
			local pcall_result1, pcall_result2_3 = pcall(function() -- Line 75
				--[[ Upvalues[4]:
					[1]: var6_upvw (read and write)
					[2]: MarketplaceService_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg2 (copied, readonly)
				]]
				var6_upvw = MarketplaceService_upvr:GetProductInfo(arg1, arg2)
			end)
			if not pcall_result1 then
				return arg2_2(pcall_result2_3)
			end
			if type(var6_upvw) ~= "table" then
				return arg2_2("Bad productInfo type")
			end
			return arg1_2(var6_upvw)
		end
		return var5.spawn(var5)
	end;
	promiseUserOwnsGamePass = function(arg1, arg2) -- Line 94, Named "promiseUserOwnsGamePass"
		--[[ Upvalues[2]:
			[1]: Promise_upvr (readonly)
			[2]: MarketplaceService_upvr (readonly)
		]]
		local var11
		if typeof(arg1) ~= "number" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad userId")
		if type(arg2) ~= "number" then
			var11 = false
		else
			var11 = true
		end
		assert(var11, "Bad gamePassId")
		var11 = Promise_upvr
		function var11(arg1_3, arg2_3) -- Line 98
			--[[ Upvalues[3]:
				[1]: MarketplaceService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local var12_upvw
			local pcall_result1_3, pcall_result2_2 = pcall(function() -- Line 100
				--[[ Upvalues[4]:
					[1]: var12_upvw (read and write)
					[2]: MarketplaceService_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg2 (copied, readonly)
				]]
				var12_upvw = MarketplaceService_upvr:UserOwnsGamePassAsync(arg1, arg2)
			end)
			if not pcall_result1_3 then
				return arg2_3(pcall_result2_2)
			end
			if type(var12_upvw) ~= "boolean" then
				return arg2_3("Bad result type")
			end
			return arg1_3(var12_upvw)
		end
		return var11.spawn(var11)
	end;
	promisePlayerOwnsAsset = function(arg1, arg2) -- Line 119, Named "promisePlayerOwnsAsset"
		--[[ Upvalues[2]:
			[1]: Promise_upvr (readonly)
			[2]: MarketplaceService_upvr (readonly)
		]]
		local var17
		if typeof(arg1) ~= "Instance" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Bad player")
		if type(arg2) ~= "number" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Bad assetId")
		var17 = Promise_upvr
		function var17(arg1_4, arg2_4) -- Line 123
			--[[ Upvalues[3]:
				[1]: MarketplaceService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: arg2 (readonly)
			]]
			local var18_upvw
			local pcall_result1_2, pcall_result2 = pcall(function() -- Line 125
				--[[ Upvalues[4]:
					[1]: var18_upvw (read and write)
					[2]: MarketplaceService_upvr (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg2 (copied, readonly)
				]]
				var18_upvw = MarketplaceService_upvr:PlayerOwnsAsset(arg1, arg2)
			end)
			if not pcall_result1_2 then
				return arg2_4(pcall_result2)
			end
			if type(var18_upvw) ~= "boolean" then
				return arg2_4("Bad result type")
			end
			return arg1_4(var18_upvw)
		end
		return var17.spawn(var17)
	end;
}