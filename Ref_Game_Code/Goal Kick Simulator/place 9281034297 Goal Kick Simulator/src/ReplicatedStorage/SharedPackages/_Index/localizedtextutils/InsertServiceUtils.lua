-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:57
-- Luau version 6, Types version 3
-- Time taken: 0.001069 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("Promise")
local InsertService_upvr = game:GetService("InsertService")
function module.promiseAsset(arg1) -- Line 19
	--[[ Upvalues[2]:
		[1]: var2_upvr (readonly)
		[2]: InsertService_upvr (readonly)
	]]
	local var5
	if type(arg1) ~= "number" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad assetId")
	if arg1 == 0 then
		var5 = var2_upvr
		return var5.rejected()
	end
	var5 = var2_upvr
	function var5(arg1_2, arg2) -- Line 26
		--[[ Upvalues[2]:
			[1]: InsertService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local var6_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 28
			--[[ Upvalues[3]:
				[1]: var6_upvw (read and write)
				[2]: InsertService_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			var6_upvw = InsertService_upvr:LoadAsset(arg1)
		end)
		if not pcall_result1 then
			return arg2(pcall_result2)
		end
		if typeof(var6_upvw) ~= "Instance" then
			return arg2("Result was not an instance")
		end
		arg1_2(var6_upvw)
	end
	return var5.spawn(var5)
end
return module