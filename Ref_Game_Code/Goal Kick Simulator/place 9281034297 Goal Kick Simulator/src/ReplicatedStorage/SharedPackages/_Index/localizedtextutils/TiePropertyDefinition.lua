-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:26
-- Luau version 6, Types version 3
-- Time taken: 0.001492 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "TiePropertyDefinition"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 15
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1._tieDefinition = assert(arg1, "No tieDefinition")
	setmetatable_result1._propertyName = assert(arg2, "No propertyName")
	setmetatable_result1._defaultValue = arg3
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetTieDefinition(arg1) -- Line 25
	return arg1._tieDefinition
end
function setmetatable_result1_upvr.GetDefaultValue(arg1) -- Line 29
	return arg1._defaultValue
end
local any_load_result1_result1_upvr = any_load_result1("TiePropertyImplementation")
function setmetatable_result1_upvr.Implement(arg1, arg2, arg3) -- Line 33
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var6
	if typeof(arg2) ~= "Instance" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad folder")
	var6 = any_load_result1_result1_upvr
	var6 = arg1
	return var6.new(var6, arg2, arg3)
end
local var1_result1_upvr = any_load_result1("TiePropertyInterface")
function setmetatable_result1_upvr.GetInterface(arg1, arg2) -- Line 39
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var8
	if typeof(arg2) ~= "Instance" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "Bad folder")
	var8 = var1_result1_upvr
	var8 = arg2
	return var8.new(var8, nil, arg1)
end
function setmetatable_result1_upvr.GetMemberName(arg1) -- Line 45
	return arg1._propertyName
end
return setmetatable_result1_upvr