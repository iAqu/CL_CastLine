-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:42
-- Luau version 6, Types version 3
-- Time taken: 0.001402 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "TieMethodDefinition";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2) -- Line 14
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._tieDefinition = assert(arg1, "No tieDefinition")
	setmetatable_result1._methodName = assert(arg2, "No methodName")
	return setmetatable_result1
end
local var1_result1_upvr = any_load_result1("TieMethodImplementation")
function module_upvr.Implement(arg1, arg2, arg3, arg4) -- Line 23
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var5
	if typeof(arg2) ~= "Instance" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad folder")
	var5 = arg4
	assert(var5, "No actualSelf")
	var5 = var1_result1_upvr
	var5 = arg1
	return var5.new(var5, arg2, arg3, arg4)
end
local var1_result1_upvr_2 = any_load_result1("TieMethodInterfaceUtils")
function module_upvr.GetInterface(arg1, arg2, arg3) -- Line 30
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var7
	if typeof(arg2) ~= "Instance" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad folder")
	var7 = arg3
	assert(var7, "No aliasSelf")
	var7 = var1_result1_upvr_2
	var7 = arg3
	return var7.get(var7, arg1._tieDefinition, arg1, arg2, nil)
end
function module_upvr.GetTieDefinition(arg1) -- Line 38
	return arg1._tieDefinition
end
function module_upvr.GetMemberName(arg1) -- Line 42
	return arg1._methodName
end
return module_upvr