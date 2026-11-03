-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:39
-- Luau version 6, Types version 3
-- Time taken: 0.003479 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local var5_upvr = Util_upvr.Input.Actions[arg1.Name]
	local var6
	if var5_upvr then
		if var5_upvr.Name then
			arg1.TextLabel.Text = var5_upvr.Name
		end
		local var7_upvw
		if arg1:GetAttribute("Resize") then
			var6 = arg1.TextLabel
			local Text = var6.Text
			var6 = Util_upvr.TextService:GetTextSize(Text, 25, arg1.TextLabel.Font, Vector2.new(math.huge, 25))
			arg1.Size = UDim2.new((var6.X + 35) / arg1.Parent.AbsoluteSize.X, 0, arg1.Size.Y.Scale, arg1.Size.Y.Offset)
			arg1.TextLabel.Text = Text
		end
		var6 = arg1.ActionIcon
		local Size_upvr = var6.Size
		var6 = var5_upvr.Activated
		var6 = var6:_Connect(function() -- Line 35
			--[[ Upvalues[4]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: Util_upvr (copied, readonly)
				[4]: Size_upvr (readonly)
			]]
			if not arg1.Visible then
			else
				any_new_result1_upvr.AnimateButton = Util_upvr.Thread.LoopFor(0.1, function(arg1_4) -- Line 37
					--[[ Upvalues[2]:
						[1]: arg1 (copied, readonly)
						[2]: Size_upvr (copied, readonly)
					]]
					arg1.ActionIcon.Size = UDim2.new(Size_upvr.X.Scale, Size_upvr.X.Offset - 5 * arg1_4, Size_upvr.Y.Scale, Size_upvr.Y.Offset - 5 * arg1_4)
				end)
			end
		end)
		any_new_result1_upvr.OnActive = var6
		var6 = var5_upvr.Deactivated
		var6 = var6:_Connect(function() -- Line 41
			--[[ Upvalues[4]:
				[1]: any_new_result1_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg1 (readonly)
				[4]: Size_upvr (readonly)
			]]
			any_new_result1_upvr.AnimateButton = Util_upvr.Thread.LoopFor(0.1, function(arg1_5) -- Line 42
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: Size_upvr (copied, readonly)
				]]
				local var15 = 1 - arg1_5
				arg1.ActionIcon.Size = UDim2.new(Size_upvr.X.Scale, Size_upvr.X.Offset - 5 * var15, Size_upvr.Y.Scale, Size_upvr.Y.Offset - 5 * var15)
			end)
		end)
		any_new_result1_upvr.OnDeactive = var6
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var6 = arg1
			return var6
		end
		if not arg1:IsA("ImageButton") and not arg1:IsA("TextButton") or not INLINED() then
			local function INLINED_2() -- Internal function, doesn't exist in bytecode
				var6 = arg1.Parent:IsA("TextButton")
				return var6
			end
			if arg1.Parent:IsA("ImageButton") or INLINED_2() then
				var6 = arg1.Parent
			end
		end
		if var6 then
			any_new_result1_upvr.ButtonClickDown = var6.MouseButton1Down:Connect(function() -- Line 51
				--[[ Upvalues[2]:
					[1]: var5_upvr (readonly)
					[2]: any_new_result1_upvr (readonly)
				]]
				var5_upvr.InputEntered:Fire({
					KeyCode = var5_upvr.Keyboard;
					UserInputState = Enum.UserInputState.Begin;
					UserInputType = Enum.UserInputType.Keyboard;
				}, false)
				function any_new_result1_upvr.ActionEnded() -- Line 57
					--[[ Upvalues[1]:
						[1]: var5_upvr (copied, readonly)
					]]
					var5_upvr.InputEntered:Fire({
						KeyCode = var5_upvr.Keyboard;
						UserInputState = Enum.UserInputState.End;
						UserInputType = Enum.UserInputType.Keyboard;
					}, false)
				end
			end)
			any_new_result1_upvr.ButtonClickUp = var6.MouseButton1Click:Connect(function() -- Line 64
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (readonly)
				]]
				if any_new_result1_upvr.ActionEnded then
					any_new_result1_upvr.ActionEnded = nil
				end
			end)
			any_new_result1_upvr.ButtonMouseLeave = (var6 or arg1).MouseLeave:Connect(function() -- Line 70
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (readonly)
				]]
				if any_new_result1_upvr.ActionEnded then
					any_new_result1_upvr.ActionEnded = nil
				end
			end)
		end
		local InputMode = Util_upvr.Input.InputMode
		var7_upvw = var5_upvr[InputMode]
		local var23 = var7_upvw
		if var23 then
			Util_upvr.InputIcons:Set(arg1.ActionIcon, var23, InputMode)
		end
		arg1.Visible = var5_upvr.Running and var23
		any_new_result1_upvr.InputModeChanged = Util_upvr.Input.InputModeChanged:Connect(function(arg1_3) -- Line 18, Named "UpdateInputMode"
			--[[ Upvalues[4]:
				[1]: var7_upvw (read and write)
				[2]: var5_upvr (readonly)
				[3]: Util_upvr (copied, readonly)
				[4]: arg1 (readonly)
			]]
			var7_upvw = var5_upvr[arg1_3]
			if var7_upvw then
				Util_upvr.InputIcons:Set(arg1.ActionIcon, var7_upvw, arg1_3)
			end
		end)
		any_new_result1_upvr.RunningEnabledTracker = var5_upvr.RunningEnabled:Connect(function(arg1_2) -- Line 14, Named "UpdateState"
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: var7_upvw (read and write)
			]]
			local var8 = arg1_2
			if var8 then
				var8 = var7_upvw
			end
			arg1.Visible = var8
		end)
		return any_new_result1_upvr
	end
	warn("[Input] No Action found for:", arg1.Name, '\n'..debug.traceback())
	return any_new_result1_upvr
end
return module