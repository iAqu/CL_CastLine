-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:52
-- Luau version 6, Types version 3
-- Time taken: 0.000523 seconds

local module_upvr = {
	ClassName = "BaseObject";
}
module_upvr.__index = module_upvr
local var2_upvr = require(script.Parent.loader).load(script)("Maid")
function module_upvr.new(arg1) -- Line 20
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var2_upvr.new()
	setmetatable_result1._obj = arg1
	return setmetatable_result1
end
function module_upvr.Destroy(arg1) -- Line 32
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr