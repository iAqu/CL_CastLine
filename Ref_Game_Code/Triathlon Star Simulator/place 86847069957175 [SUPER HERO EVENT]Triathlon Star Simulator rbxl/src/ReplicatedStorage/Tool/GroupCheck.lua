-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:23
-- Luau version 6, Types version 3
-- Time taken: 0.000816 seconds

local module = {}
local Value_upvr = game:GetService("ReplicatedStorage")["游戏全局配置"]["群组设置"]["群组ID"].Value
function module.IsPlayInGroup(arg1) -- Line 12
	--[[ Upvalues[1]:
		[1]: Value_upvr (readonly)
	]]
	if not arg1 then
		return false
	end
	local pcall_result1, pcall_result2 = pcall(function() -- Line 17
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Value_upvr (copied, readonly)
		]]
		return arg1:GetRoleInGroup(Value_upvr)
	end)
	if pcall_result2 == "Guest" then
	else
	end
	return true
end
return module