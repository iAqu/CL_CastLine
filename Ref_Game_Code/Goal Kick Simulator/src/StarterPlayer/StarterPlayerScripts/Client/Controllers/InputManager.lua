-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:36
-- Luau version 6, Types version 3
-- Time taken: 0.004766 seconds

local module_upvr = {}
local Util = require(game:GetService("ReplicatedStorage").Util)
local UserInputService_upvr = Util.UserInputService
local tbl = {
	__index = {
		HandleInput = function(arg1, arg2) -- Line 9, Named "HandleInput"
			if arg2.UserInputState == Enum.UserInputState.Begin then
				return 1
			end
		end;
	};
}
local tbl_upvr_2 = {}
local tbl_upvr = {
	Run = {
		Name = "Run";
		Keyboard = Enum.KeyCode.LeftShift;
		Gamepad = Enum.KeyCode.ButtonL3;
		Priority = 1;
	};
	Menu = {
		Keyboard = Enum.KeyCode.M;
		Gamepad = Enum.KeyCode.ButtonX;
		Priority = 1;
	};
	MoveDown = {
		Keyboard = Enum.KeyCode.E;
		Gamepad = Enum.KeyCode.DPadDown;
		Priority = 2;
	};
	MoveUp = {
		Keyboard = Enum.KeyCode.Q;
		Gamepad = Enum.KeyCode.DPadUp;
		Priority = 2;
	};
	MoveRight = {
		Keyboard = Enum.KeyCode.Right;
		Gamepad = Enum.KeyCode.DPadRight;
		Priority = 2;
	};
	MoveLeft = {
		Keyboard = Enum.KeyCode.Left;
		Gamepad = Enum.KeyCode.DPadLeft;
		Priority = 2;
	};
	Click = {
		Keyboard = Enum.UserInputType.MouseButton1;
		Gamepad = Enum.KeyCode.ButtonA;
		Mobile = Enum.UserInputType.Touch;
		Priority = 1;
	};
	Kick = {
		Keyboard = Enum.UserInputType.MouseButton1;
		Gamepad = Enum.KeyCode.ButtonA;
		Priority = 1;
	};
	PowerInterrupt = {
		Keyboard = Enum.KeyCode.Q;
		Gamepad = Enum.KeyCode.ButtonR2;
		Priority = 1;
	};
	PlaceStar = {
		Keyboard = Enum.KeyCode.F;
		Gamepad = Enum.KeyCode.ButtonL2;
		Priority = 1;
	};
	DialogueNext = {
		Keyboard = Enum.KeyCode.F;
		Gamepad = Enum.KeyCode.ButtonA;
		Priority = 2;
	};
	Select = {
		Keyboard = Enum.KeyCode.F;
		Gamepad = Enum.KeyCode.ButtonA;
		Priority = 1;
	};
	MouseMoved = {
		Keyboard = Enum.UserInputType.MouseMovement;
		Priority = 1;
	};
	PreviousInventoryTool = {
		Gamepad = Enum.KeyCode.ButtonL1;
		Priority = 1;
	};
}
local tbl_2 = {
	Gamepad = Enum.KeyCode.ButtonR1;
	Priority = 1;
}
tbl_upvr.NextInventoryTool = tbl_2
function tbl_2(arg1, arg2) -- Line 100, Named "OnPressInputHandle"
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_3, pairs_result2, pairs_result3_3 = pairs(tbl_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [105] 70. Error Block 22 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [105] 70. Error Block 22 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [105.7]
	-- KONSTANTERROR: [5] 5. Error Block 2 end (CF ANALYSIS FAILED)
end
local var27_upvr = tbl_2
local function OnTouchInputHandle_upvr(arg1, arg2, arg3) -- Line 126, Named "OnTouchInputHandle"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	for _, v in pairs(tbl_upvr) do
		if v[arg1] then
			v.Activated:Fire(v, arg3, arg2)
		end
	end
end
module_upvr.Actions = tbl_upvr
for _, v_2 in pairs(tbl_upvr) do
	setmetatable(v_2, tbl)
	v_2.Activated = Util.Signal.new()
	v_2.Deactivated = Util.Signal.new()
	v_2.Changed = Util.Signal.new()
	v_2.Altered = Util.Signal.new()
	v_2.InputEntered = Util.Signal.new()
	v_2.RunningEnabled = Util.Signal.new()
	v_2.Enabled = true
	v_2.Running = false
	v_2.InputEntered:Connect(function(...) -- Line 152
		--[[ Upvalues[1]:
			[1]: var27_upvr (readonly)
		]]
		var27_upvr(...)
	end)
end
module_upvr.InputMode = "Keyboard"
module_upvr.InputModeChanged = Util.Signal.new()
local GuiService_upvr = game:GetService("GuiService")
local function UpdateInputMode() -- Line 160
	--[[ Upvalues[3]:
		[1]: UserInputService_upvr (readonly)
		[2]: GuiService_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 21 start (CF ANALYSIS FAILED)
	if UserInputService_upvr.GamepadEnabled then
		-- KONSTANTWARNING: GOTO [30] #25
	end
	-- KONSTANTERROR: [0] 1. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 6. Error Block 22 start (CF ANALYSIS FAILED)
	if UserInputService_upvr.TouchEnabled and not UserInputService_upvr.KeyboardEnabled then
		if not UserInputService_upvr.MouseEnabled and not UserInputService_upvr.GamepadEnabled and not GuiService_upvr:IsTenFootInterface() then
			-- KONSTANTWARNING: GOTO [30] #25
		end
	end
	local var42 = "Keyboard"
	if module_upvr.InputMode ~= var42 then
		module_upvr.InputMode = var42
		module_upvr.InputModeChanged:Fire(var42)
	end
	-- KONSTANTERROR: [6] 6. Error Block 22 end (CF ANALYSIS FAILED)
end
UserInputService_upvr:GetPropertyChangedSignal("GamepadEnabled"):Connect(UpdateInputMode)
UserInputService_upvr:GetPropertyChangedSignal("TouchEnabled"):Connect(UpdateInputMode)
UserInputService_upvr:GetPropertyChangedSignal("KeyboardEnabled"):Connect(UpdateInputMode)
UpdateInputMode()
Util.Thread.Every(0.1, function() -- Line 175
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1, pairs_result2_3, pairs_result3_4 = pairs(tbl_upvr)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 55. Error Block 14 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [79] 55. Error Block 14 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [79.5]
	-- KONSTANTERROR: [5] 5. Error Block 2 end (CF ANALYSIS FAILED)
end)
UserInputService_upvr.TouchTap:Connect(function(arg1, arg2) -- Line 194
	--[[ Upvalues[1]:
		[1]: OnTouchInputHandle_upvr (readonly)
	]]
	OnTouchInputHandle_upvr("TouchTap", arg1, arg2)
end)
UserInputService_upvr.TouchTapInWorld:Connect(function(arg1, arg2) -- Line 197
	--[[ Upvalues[1]:
		[1]: OnTouchInputHandle_upvr (readonly)
	]]
	OnTouchInputHandle_upvr("TouchTapInWorld", arg1, arg2)
end)
UserInputService_upvr.InputBegan:Connect(function(arg1, arg2) -- Line 201
	--[[ Upvalues[1]:
		[1]: var27_upvr (readonly)
	]]
	var27_upvr(arg1, arg2)
end)
UserInputService_upvr.InputChanged:Connect(function(arg1, arg2) -- Line 204
	--[[ Upvalues[1]:
		[1]: var27_upvr (readonly)
	]]
	var27_upvr(arg1, arg2)
end)
UserInputService_upvr.InputEnded:Connect(function(arg1, arg2) -- Line 207
	--[[ Upvalues[1]:
		[1]: var27_upvr (readonly)
	]]
	var27_upvr(arg1, arg2)
end)
Util.Input = module_upvr
return module_upvr