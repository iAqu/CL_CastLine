-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:45
-- Luau version 6, Types version 3
-- Time taken: 0.002905 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("InputModeTypes")
local module_upvr = {}
local var1_result1_upvr_4 = any_load_result1("InputKeyMapList")
local var1_result1_upvr_3 = any_load_result1("InputKeyMap")
function module_upvr.newInputKeyMapFromPrompt(arg1) -- Line 22
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	local var6
	if typeof(arg1) ~= "Instance" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad prompt")
	var6 = var1_result1_upvr_4
	var6 = "custom"
	return var6.new(var6, {var1_result1_upvr_3.new(var1_result1_upvr_2.Gamepads, {arg1.GamepadKeyCode}), var1_result1_upvr_3.new(var1_result1_upvr_2.Keyboard, {arg1.KeyboardKeyCode}), var1_result1_upvr_3.new(var1_result1_upvr_2.Touch, {"Tap"})}, {
		bindingName = arg1.ActionText;
		rebindable = false;
	})
end
function module_upvr.configurePromptFromInputKeyMap(arg1, arg2) -- Line 42
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var12
	if typeof(arg1) ~= "Instance" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad prompt")
	if type(arg2) ~= "table" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad inputKeyMapList")
	var12 = module_upvr
	var12 = arg2
	local any_getFirstInputKeyCode_result1 = var12.getFirstInputKeyCode(var12, var1_result1_upvr_2.Keyboard)
	var12 = module_upvr.getFirstInputKeyCode(arg2, var1_result1_upvr_2.Gamepads)
	if any_getFirstInputKeyCode_result1 then
		arg1.KeyboardKeyCode = any_getFirstInputKeyCode_result1
	end
	if var12 then
		arg1.GamepadKeyCode = var12
	end
end
local var1_result1_upvr = any_load_result1("InputModeType")
function module_upvr.getFirstInputKeyCode(arg1, arg2) -- Line 65
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var23
	if type(arg1) ~= "table" then
		var23 = false
	else
		var23 = true
	end
	assert(var23, "Bad inputKeyMapList")
	var23 = var1_result1_upvr.isInputModeType(arg2)
	assert(var23, "Bad inputModeType")
	var23 = arg1
	for _, v in pairs(var23) do
		for _, v_2 in pairs(v.inputTypes) do
			if typeof(v_2) == "EnumItem" and v_2.EnumType == Enum.KeyCode and arg2:IsValid(v_2) then
				return v_2
			end
		end
	end
	return nil
end
return module_upvr