-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:50
-- Luau version 6, Types version 3
-- Time taken: 0.000502 seconds

local module = {}
local tbl_upvr = {
	Common = 25;
	Rare = 15;
	Epic = 12;
	Legendary = 4;
	Secret = 3;
	Default = 25;
}
function module.GetValueToNextLevel(arg1, arg2, arg3) -- Line 16
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var3 = tbl_upvr[arg3]
	if not var3 then
		var3 = tbl_upvr.Default
	end
	return math.ceil(var3 ^ ((arg2 - 1) * 0.2 + 1))
end
return module