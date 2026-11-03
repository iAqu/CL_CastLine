-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:00
-- Luau version 6, Types version 3
-- Time taken: 0.002919 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local UserInputService_upvr = game:GetService("UserInputService")
local any_load_result1_result1_upvr = any_load_result1("InputModeTypes")
local module = {
	ServiceName = "InputModeServiceClient";
}
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("InputModeProcessor")
function module.Init(arg1, arg2) -- Line 23
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._maid = var1_result1_upvr.new()
	arg1._inputModes = {}
	arg1._inputModeProcessor = any_load_result1_result1_upvr_2.new()
	arg1:GetInputMode(any_load_result1_result1_upvr.KeyboardAndMouse)
	arg1:GetInputMode(any_load_result1_result1_upvr.Gamepads)
	arg1:GetInputMode(any_load_result1_result1_upvr.Keyboard)
	arg1:GetInputMode(any_load_result1_result1_upvr.Touch)
	arg1:GetInputMode(any_load_result1_result1_upvr.Mouse)
	arg1:GetInputMode(any_load_result1_result1_upvr.ArrowKeys)
	arg1:GetInputMode(any_load_result1_result1_upvr.Keypad)
	arg1:GetInputMode(any_load_result1_result1_upvr.WASD)
	arg1:GetInputMode(any_load_result1_result1_upvr.DPad)
	arg1:_triggerEnabled()
	arg1:_bindProcessor()
end
local any_load_result1_result1_upvr_3 = any_load_result1("InputModeType")
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_4 = any_load_result1("InputMode")
function module.GetInputMode(arg1, arg2) -- Line 49
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: RunService_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	assert(any_load_result1_result1_upvr_3.isInputModeType(arg2), "Bad inputModeType")
	if not RunService_upvr:IsRunning() and not arg1._inputModes then
		return any_load_result1_result1_upvr_4.new(arg2)
	end
	if arg1._inputModes[arg2] then
		return arg1._inputModes[arg2]
	end
	local any_new_result1 = any_load_result1_result1_upvr_4.new(arg2)
	arg1._inputModeProcessor:AddInputMode(any_new_result1)
	arg1._maid:GiveTask(any_new_result1)
	arg1._inputModes[arg2] = any_new_result1
	return any_new_result1
end
local GuiService_upvr = game:GetService("GuiService")
function module._triggerEnabled(arg1) -- Line 71
	--[[ Upvalues[3]:
		[1]: UserInputService_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: GuiService_upvr (readonly)
	]]
	if UserInputService_upvr.MouseEnabled then
		arg1:GetInputMode(any_load_result1_result1_upvr.Mouse):Enable()
	end
	if UserInputService_upvr.TouchEnabled then
		arg1:GetInputMode(any_load_result1_result1_upvr.Touch):Enable()
	end
	if UserInputService_upvr.KeyboardEnabled then
		arg1:GetInputMode(any_load_result1_result1_upvr.Keyboard):Enable()
	end
	if UserInputService_upvr.KeyboardEnabled and UserInputService_upvr.MouseEnabled then
		arg1:GetInputMode(any_load_result1_result1_upvr.KeyboardAndMouse):Enable()
	end
	if UserInputService_upvr.GamepadEnabled or 0 < #UserInputService_upvr:GetConnectedGamepads() or GuiService_upvr:IsTenFootInterface() then
		arg1:GetInputMode(any_load_result1_result1_upvr.Gamepads):Enable()
	end
end
function module._bindProcessor(arg1) -- Line 91
	--[[ Upvalues[2]:
		[1]: UserInputService_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	arg1._maid:GiveTask(UserInputService_upvr.InputBegan:Connect(function(arg1_2) -- Line 92
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._inputModeProcessor:Evaluate(arg1_2)
	end))
	arg1._maid:GiveTask(UserInputService_upvr.InputEnded:Connect(function(arg1_3) -- Line 95
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._inputModeProcessor:Evaluate(arg1_3)
	end))
	arg1._maid:GiveTask(UserInputService_upvr.InputChanged:Connect(function(arg1_4) -- Line 98
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [6] 4. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [6] 4. Error Block 2 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [12] 7. Error Block 8 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [12] 7. Error Block 8 end (CF ANALYSIS FAILED)
	end))
	arg1._maid:GiveTask(UserInputService_upvr.GamepadConnected:Connect(function(arg1_5) -- Line 111
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		arg1:GetInputMode(any_load_result1_result1_upvr.Gamepads):Enable()
	end))
	arg1._maid:GiveTask(UserInputService_upvr.GamepadDisconnected:Connect(function(arg1_6) -- Line 115
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_triggerEnabled()
	end))
end
function module.Destroy(arg1) -- Line 120
	arg1._maid:DoCleaning()
end
return module