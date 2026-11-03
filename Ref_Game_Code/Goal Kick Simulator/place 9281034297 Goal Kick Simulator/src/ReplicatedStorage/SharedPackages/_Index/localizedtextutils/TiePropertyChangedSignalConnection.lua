-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:35
-- Luau version 6, Types version 3
-- Time taken: 0.000956 seconds

local module_upvr = {
	ClassName = "TiePropertyChangedSignalConnection";
}
module_upvr.__index = module_upvr
local var2_upvr = require(script.Parent.loader).load(script)("Maid")
function module_upvr.new(arg1) -- Line 13
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var2_upvr.new()
	setmetatable_result1._connected = true
	arg1(setmetatable_result1._maid)
	return setmetatable_result1
end
function module_upvr.Disconnect(arg1) -- Line 24
	arg1:Destroy()
end
function module_upvr.__index(arg1, arg2) -- Line 28
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "IsConnected" then
		return arg1._connected
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("Bad index %q for TiePropertyChangedSignalConnection":format(tostring(arg2)))
end
function module_upvr.Destroy(arg1) -- Line 38
	arg1._connected = false
	arg1._maid:DoCleaning()
end
return module_upvr