-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:27
-- Luau version 6, Types version 3
-- Time taken: 0.000617 seconds

local module = {}
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
function tbl_upvr.SendMessage(arg1, arg2, arg3) -- Line 15
	arg1.SayMessageRequest:FireServer(arg2, arg3)
end
function tbl_upvr.RegisterSayMessageFunction(arg1, arg2) -- Line 19
	arg1.SayMessageRequest = arg2
end
function module.new() -- Line 26
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, tbl_upvr)
	setmetatable_result1.SayMessageRequest = nil
	return setmetatable_result1
end
return module.new()