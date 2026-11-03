-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:54
-- Luau version 6, Types version 3
-- Time taken: 0.001968 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "InputKeyMap"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("InputModeType")
local any_load_result1_result1_upvr = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 29
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: setmetatable_result1_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	assert(var1_result1_upvr.isInputModeType(arg1), "Bad inputModeType")
	local var6 = true
	if type(arg2) ~= "table" then
		if arg2 ~= nil then
			var6 = false
		else
			var6 = true
		end
	end
	assert(var6, "Bad inputTypes")
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1._inputModeType = assert(arg1, "No inputModeType")
	local var8 = arg2
	if not var8 then
		var8 = {}
	end
	setmetatable_result1._defaultInputTypes = var8
	setmetatable_result1._inputType = any_load_result1_result1_upvr.new(setmetatable_result1._defaultInputTypes)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._inputType)
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetInputModeType(arg1) -- Line 48
	return arg1._inputModeType
end
function setmetatable_result1_upvr.SetInputTypesList(arg1, arg2) -- Line 57
	local var9
	if type(arg2) ~= "table" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad inputTypes")
	arg1._inputType.Value = arg2
end
local any_load_result1_result1_upvr_2 = any_load_result1("InputTypeUtils")
function setmetatable_result1_upvr.SetDefaultInputTypesList(arg1, arg2) -- Line 72
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var11
	if type(arg2) ~= "table" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad inputTypes")
	if type(arg1._defaultInputTypes) ~= "table" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "bad self._defaultInputTypes")
	var11 = any_load_result1_result1_upvr_2
	var11 = arg1._inputType.Value
	if var11.areInputTypesListsEquivalent(var11, arg1._defaultInputTypes) then
		arg1._inputType.Value = arg2
	end
	arg1._defaultInputTypes = arg2
end
function setmetatable_result1_upvr.GetDefaultInputTypesList(arg1) -- Line 88
	return arg1._defaultInputTypes
end
function setmetatable_result1_upvr.RestoreDefault(arg1) -- Line 95
	arg1._inputType.Value = arg1._defaultInputTypes
end
function setmetatable_result1_upvr.ObserveInputTypesList(arg1) -- Line 104
	return arg1._inputType:Observe()
end
function setmetatable_result1_upvr.GetInputTypesList(arg1) -- Line 113
	return arg1._inputType.Value
end
return setmetatable_result1_upvr