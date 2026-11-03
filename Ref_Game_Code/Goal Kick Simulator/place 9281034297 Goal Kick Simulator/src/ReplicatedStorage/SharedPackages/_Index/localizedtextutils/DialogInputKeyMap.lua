-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:27
-- Luau version 6, Types version 3
-- Time taken: 0.001896 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("InputKeyMapList")
local any_load_result1_result1_upvr_3 = any_load_result1("InputKeyMap")
local any_load_result1_result1_upvr_2 = any_load_result1("InputModeTypes")
return any_load_result1("InputKeyMapListProvider").new(script.Name, function(arg1) -- Line 12
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg1:Add(any_load_result1_result1_upvr.new("ADVANCE_DIALOG", {any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Keyboard, {Enum.KeyCode.Return}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Mouse, {Enum.UserInputType.MouseButton1}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonA}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Touch, {"Tap"})}, {
		bindingName = "Next dialog (Dialog)";
		rebindable = true;
	}))
	arg1:Add(any_load_result1_result1_upvr.new("DIALOG_SLIDER_MOVE_LEFT", {any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Mouse, {}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.ArrowKeys, {Enum.KeyCode.Left}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.WASD, {Enum.KeyCode.A}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.DPad, {Enum.KeyCode.DPadLeft}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Thumbsticks, {Enum.KeyCode.Thumbstick1}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Touch, {Enum.UserInputType.Touch, "Drag"})}, {
		bindingName = "Slide left (Dialog)";
		rebindable = false;
	}))
	arg1:Add(any_load_result1_result1_upvr.new("DIALOG_SLIDER_MOVE_RIGHT", {any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Mouse, {}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.ArrowKeys, {Enum.KeyCode.Right}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.WASD, {Enum.KeyCode.D}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.DPad, {Enum.KeyCode.DPadRight}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Thumbsticks, {Enum.KeyCode.Thumbstick1}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Touch, {Enum.UserInputType.Touch, "Drag"})}, {
		bindingName = "Slide right (Dialog)";
		rebindable = false;
	}))
	arg1:Add(any_load_result1_result1_upvr.new("DIALOG_SELECT_TEXTBOX", {any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.Tab}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonR1}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Touch, {})}, {
		bindingName = "Select textbox (Dialog)";
		rebindable = false;
	}))
	arg1:Add(any_load_result1_result1_upvr.new("DIALOG_CONFIRM_SHORTCUT", {any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.KeyboardAndMouse, {Enum.KeyCode.Return}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Gamepads, {Enum.KeyCode.ButtonA}), any_load_result1_result1_upvr_3.new(any_load_result1_result1_upvr_2.Touch, {})}, {
		bindingName = "Confirm input (Dialog)";
		rebindable = true;
	}))
end)