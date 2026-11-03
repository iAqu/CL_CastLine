-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:08
-- Luau version 6, Types version 3
-- Time taken: 0.000905 seconds

local module = {}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local PolicyService_upvr = game:GetService("PolicyService")
function module.CanUnlockPaidRandomItems(arg1, arg2) -- Line 7
	--[[ Upvalues[2]:
		[1]: LocalPlayer_upvr (readonly)
		[2]: PolicyService_upvr (readonly)
	]]
	local var4 = arg2
	if not var4 then
		var4 = LocalPlayer_upvr
	end
	local var5_upvw = var4
	if not var5_upvw:GetAttribute("RestrictedCountry") then
	end
	local var6_upvw
	local pcall_result1, pcall_result2 = pcall(function() -- Line 13
		--[[ Upvalues[3]:
			[1]: var6_upvw (read and write)
			[2]: PolicyService_upvr (copied, readonly)
			[3]: var5_upvw (read and write)
		]]
		var6_upvw = PolicyService_upvr:GetPolicyInfoForPlayerAsync(var5_upvw)
	end)
	print("policies", pcall_result1, var6_upvw)
	if pcall_result1 and var6_upvw and var6_upvw.ArePaidRandomItemsRestricted then
		return false
	end
	return true
end
require(game:GetService("ReplicatedStorage").Util).PolicyService = module
return module