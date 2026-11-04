-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:28
-- Luau version 6, Types version 3
-- Time taken: 0.000586 seconds

local module = {}
local var2_upvw
function module.UpdateLocalData(arg1, arg2) -- Line 5
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	var2_upvw = arg2
end
function module.GetLocalData(arg1) -- Line 9
	--[[ Upvalues[1]:
		[1]: var2_upvw (read and write)
	]]
	return var2_upvw
end
function module.GetSerVerTime(arg1) -- Line 13
	return workspace:GetServerTimeNow()
end
return module