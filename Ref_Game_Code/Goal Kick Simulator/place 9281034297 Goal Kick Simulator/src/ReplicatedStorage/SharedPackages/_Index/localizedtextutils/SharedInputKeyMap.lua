-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:29
-- Luau version 6, Types version 3
-- Time taken: 0.001313 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("InputKeyMapList")
local var1_result1_upvr = any_load_result1("InputKeyMap")
local var1_result1_upvr_2 = any_load_result1("InputModeTypes")
local var1_result1_upvr_4 = any_load_result1("SlottedTouchButtonUtils")
return any_load_result1("InputKeyMapListProvider").new(script.Name, function(arg1) -- Line 14
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	arg1:Add(var1_result1_upvr_3.new("PRIMARY", {var1_result1_upvr.new(var1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.E}), var1_result1_upvr.new(var1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonA}), var1_result1_upvr.new(var1_result1_upvr_2.Touch, {"Tap", var1_result1_upvr_4.createSlottedTouchButton("primary1")})}, {
		bindingName = "Interact (Primary)";
		rebindable = true;
	}))
	arg1:Add(var1_result1_upvr_3.new("SECONDARY", {var1_result1_upvr.new(var1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.R}), var1_result1_upvr.new(var1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonY}), var1_result1_upvr.new(var1_result1_upvr_2.Touch, {var1_result1_upvr_4.createSlottedTouchButton("primary2")})}, {
		bindingName = "Interact (Secondary)";
		rebindable = true;
	}))
	arg1:Add(var1_result1_upvr_3.new("EXIT_ITEM", {var1_result1_upvr.new(var1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.Backspace}), var1_result1_upvr.new(var1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonB}), var1_result1_upvr.new(var1_result1_upvr_2.Touch, {var1_result1_upvr_4.createSlottedTouchButton("primary1")})}, {
		bindingName = "Cancel";
		rebindable = true;
	}))
end)