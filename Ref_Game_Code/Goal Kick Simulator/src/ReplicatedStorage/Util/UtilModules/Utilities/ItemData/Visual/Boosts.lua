-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:53
-- Luau version 6, Types version 3
-- Time taken: 0.000875 seconds

local module = {
	DoubleMoney = {
		ID = 1233890529;
		Icon = "";
		Title = "x2 Money";
		Description = "10m";
		Time = 600;
	};
	DoubleXP = {
		ID = 1233890429;
		Icon = "";
		Title = "x2 XP";
		Description = "10m";
		Time = 600;
	};
}
local tbl = {}
local tbl_2_upvr = {}
function tbl.__index(arg1, arg2) -- Line 22
	--[[ Upvalues[1]:
		[1]: tbl_2_upvr (readonly)
	]]
	local rawget_result1 = rawget(arg1, arg2)
	if rawget_result1 then
		return rawget_result1
	end
	local var7 = tbl_2_upvr[arg2]
	if var7 then
		return var7
	end
	tbl_2_upvr[arg2] = {
		ID = -1;
		Icon = "";
		Title = "Missing Info: "..arg2;
		Description = '-';
	}
	return var7
end
setmetatable(module, tbl)
return module