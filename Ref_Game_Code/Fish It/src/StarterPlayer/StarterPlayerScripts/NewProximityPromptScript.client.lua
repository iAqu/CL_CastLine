-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local t = {
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
	[Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
	[Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
	[Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
	[Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
	[Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxView.png",
	[Enum.KeyCode.ButtonStart] = "rbxasset://textures/ui/Controls/xboxmenu.png",
	[Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLB.png",
	[Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRB.png",
	[Enum.KeyCode.ButtonL2] = "rbxasset://textures/ui/Controls/xboxLT.png",
	[Enum.KeyCode.ButtonR2] = "rbxasset://textures/ui/Controls/xboxRT.png",
	[Enum.KeyCode.ButtonL3] = "rbxasset://textures/ui/Controls/xboxLS.png",
	[Enum.KeyCode.ButtonR3] = "rbxasset://textures/ui/Controls/xboxRS.png",
	[Enum.KeyCode.Thumbstick1] = "rbxasset://textures/ui/Controls/xboxLSDirectional.png",
	[Enum.KeyCode.Thumbstick2] = "rbxasset://textures/ui/Controls/xboxRSDirectional.png"
}
local t2 = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
}
local t3 = {
	["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png"
}
local t4 = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12"
}
local function getScreenGui() --[[ getScreenGui | Line: 67 | Upvalues: PlayerGui (copy) ]]
	local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")
	if ProximityPrompts == nil then
		local ProximityPrompts_2 = Instance.new("ScreenGui")
		ProximityPrompts_2.Name = "ProximityPrompts"
		ProximityPrompts_2.ResetOnSpawn = false
		ProximityPrompts_2.Parent = PlayerGui
		ProximityPrompts = ProximityPrompts_2
	end
	return ProximityPrompts
end
local function createProgressBarGradient(p1, p2) --[[ createProgressBarGradient | Line: 78 ]]
	local Frame = Instance.new("Frame")
	Frame.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	Frame.Size = UDim2.fromScale(0.5, 1)
	Frame.Position = UDim2.fromScale(if p2 then 0 else 0.5, 0)
	Frame.BackgroundTransparency = 1
	Frame.ClipsDescendants = true
	Frame.Parent = p1
	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Size = UDim2.fromScale(2, 1)
	ImageLabel.Position = UDim2.fromScale(if p2 then 0 else -1, 0)
	ImageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	ImageLabel.Parent = Frame
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.4999, 0),
		NumberSequenceKeypoint.new(0.5, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
	UIGradient.Rotation = if p2 then 180 else 0
	UIGradient.Parent = ImageLabel
	return UIGradient
end
local function createCircularProgressBar() --[[ createCircularProgressBar | Line: 107 | Upvalues: createProgressBarGradient (copy) ]]
	local CircularProgressBar = Instance.new("Frame")
	CircularProgressBar.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	CircularProgressBar.Name = "CircularProgressBar"
	CircularProgressBar.Size = UDim2.fromOffset(58, 58)
	CircularProgressBar.AnchorPoint = Vector2.new(0.5, 0.5)
	CircularProgressBar.Position = UDim2.fromScale(0.5, 0.5)
	CircularProgressBar.BackgroundTransparency = 1
	local v1 = createProgressBarGradient(CircularProgressBar, true)
	local v2 = createProgressBarGradient(CircularProgressBar, false)
	local Progress = Instance.new("NumberValue")
	Progress.Name = "Progress"
	Progress.Parent = CircularProgressBar
	Progress.Changed:Connect(function(p1) --[[ Line: 122 | Upvalues: v1 (copy), v2 (copy) ]]
		local v12 = math.clamp(p1 * 360, 0, 360)
		v1.Rotation = math.clamp(v12, 180, 360)
		v2.Rotation = math.clamp(v12, 0, 180)
	end)
	return CircularProgressBar
end
local function createPrompt(p1, p2, p3) --[[ createPrompt | Line: 131 | Upvalues: TweenService (copy), t (copy), UserInputService (copy), t2 (copy), t3 (copy), t4 (copy), createCircularProgressBar (copy), TextService (copy) ]]
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local list = {}
	local v1 = TweenInfo.new(p1.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v4 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local Prompt = Instance.new("BillboardGui")
	Prompt.Name = "Prompt"
	Prompt.AlwaysOnTop = true
	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 1.2
	UIScale.Parent = Prompt
	local Frame = Instance.new("Frame")
	Frame.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	Frame.Size = UDim2.fromScale(0.5, 1)
	Frame.BackgroundTransparency = 1
	Frame.Parent = Prompt
	Instance.new("UICorner").Parent = Frame
	local InputFrame = Instance.new("Frame")
	InputFrame.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	InputFrame.Name = "InputFrame"
	InputFrame.Size = UDim2.fromScale(1, 1)
	InputFrame.BackgroundTransparency = 1
	InputFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	InputFrame.Parent = Frame
	local Frame_2 = Instance.new("Frame")
	Frame_2.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	Frame_2.Size = UDim2.fromScale(1, 1)
	Frame_2.Position = UDim2.fromScale(0.5, 0.5)
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame_2.BackgroundTransparency = 1
	Frame_2.Parent = InputFrame
	local UIScale_2 = Instance.new("UIScale")
	UIScale_2.Parent = Frame_2
	table.insert(t5, TweenService:Create(UIScale_2, v3, {
		Scale = if p2 == Enum.ProximityPromptInputType.Touch then 1.4 else 1.23
	}))
	table.insert(t6, TweenService:Create(UIScale_2, v3, {
		Scale = 1
	}))
	local ActionText = Instance.new("TextLabel")
	ActionText.Name = "ActionText"
	ActionText.Size = UDim2.fromScale(1, 1)
	ActionText.Font = Enum.Font.MontserratBold
	ActionText.TextSize = 19
	ActionText.BackgroundTransparency = 1
	ActionText.TextTransparency = 1
	ActionText.TextColor3 = Color3.new(255/255, 255/255, 255/255)
	ActionText.TextXAlignment = Enum.TextXAlignment.Left
	ActionText.Parent = Frame
	table.insert(t5, TweenService:Create(ActionText, v3, {
		TextTransparency = 1
	}))
	table.insert(t6, TweenService:Create(ActionText, v3, {
		TextTransparency = 0
	}))
	table.insert(t7, TweenService:Create(ActionText, v3, {
		TextTransparency = 1
	}))
	table.insert(list, TweenService:Create(ActionText, v3, {
		TextTransparency = 0
	}))
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Thickness = 2
	UIStroke.Transparency = 0.5
	UIStroke.Color = Color3.new(0/255, 0/255, 0/255)
	UIStroke.Parent = ActionText
	table.insert(t5, TweenService:Create(UIStroke, v3, {
		Transparency = 1
	}))
	table.insert(t6, TweenService:Create(UIStroke, v3, {
		Transparency = 0.5
	}))
	table.insert(t7, TweenService:Create(UIStroke, v3, {
		Transparency = 1
	}))
	table.insert(list, TweenService:Create(UIStroke, v3, {
		Transparency = 0.5
	}))
	local ObjectText = Instance.new("TextLabel")
	ObjectText.Name = "ObjectText"
	ObjectText.Size = UDim2.fromScale(1, 1)
	ObjectText.Font = Enum.Font.MontserratBold
	ObjectText.TextSize = 16
	ObjectText.BackgroundTransparency = 1
	ObjectText.TextTransparency = 1
	ObjectText.TextColor3 = Color3.new(255/255, 255/255, 255/255)
	ObjectText.TextXAlignment = Enum.TextXAlignment.Left
	ObjectText.Parent = Frame
	table.insert(t5, TweenService:Create(ObjectText, v3, {
		TextTransparency = 1
	}))
	table.insert(t6, TweenService:Create(ObjectText, v3, {
		TextTransparency = 0
	}))
	table.insert(t7, TweenService:Create(ObjectText, v3, {
		TextTransparency = 1
	}))
	table.insert(list, TweenService:Create(ObjectText, v3, {
		TextTransparency = 0
	}))
	local UIStroke_2 = Instance.new("UIStroke")
	UIStroke_2.Thickness = 2
	UIStroke_2.Transparency = 0.5
	UIStroke_2.Color = Color3.new(0/255, 0/255, 0/255)
	UIStroke_2.Parent = ObjectText
	table.insert(t5, TweenService:Create(UIStroke_2, v3, {
		Transparency = 1
	}))
	table.insert(t6, TweenService:Create(UIStroke_2, v3, {
		Transparency = 0.5
	}))
	table.insert(t7, TweenService:Create(UIStroke_2, v3, {
		Transparency = 1
	}))
	table.insert(list, TweenService:Create(UIStroke_2, v3, {
		Transparency = 0.5
	}))
	table.insert(t5, TweenService:Create(Frame, v3, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.5, 1)
	}))
	table.insert(t6, TweenService:Create(Frame, v3, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}))
	table.insert(t7, TweenService:Create(Frame, v3, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.5, 1)
	}))
	table.insert(list, TweenService:Create(Frame, v3, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}))
	local RoundFrame = Instance.new("Frame")
	RoundFrame.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	RoundFrame.Name = "RoundFrame"
	RoundFrame.Size = UDim2.fromOffset(48, 48)
	RoundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	RoundFrame.Position = UDim2.fromScale(0.5, 0.5)
	RoundFrame.BackgroundTransparency = 1
	RoundFrame.Parent = Frame_2
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = RoundFrame
	table.insert(t7, TweenService:Create(RoundFrame, v4, {
		BackgroundTransparency = 1
	}))
	table.insert(list, TweenService:Create(RoundFrame, v4, {
		BackgroundTransparency = 0.5
	}))
	if p2 == Enum.ProximityPromptInputType.Gamepad then
		if t[p1.GamepadKeyCode] then
			local ButtonImage = Instance.new("ImageLabel")
			ButtonImage.Name = "ButtonImage"
			ButtonImage.AnchorPoint = Vector2.new(0.5, 0.5)
			ButtonImage.Size = UDim2.fromOffset(24, 24)
			ButtonImage.Position = UDim2.fromScale(0.5, 0.5)
			ButtonImage.BackgroundTransparency = 1
			ButtonImage.ImageTransparency = 1
			ButtonImage.Image = t[p1.GamepadKeyCode]
			ButtonImage.Parent = Frame_2
			table.insert(t7, TweenService:Create(ButtonImage, v4, {
				ImageTransparency = 1
			}))
			table.insert(list, TweenService:Create(ButtonImage, v4, {
				ImageTransparency = 0
			}))
		end
	elseif p2 == Enum.ProximityPromptInputType.Touch then
		local ButtonImage = Instance.new("ImageLabel")
		ButtonImage.Name = "ButtonImage"
		ButtonImage.BackgroundTransparency = 1
		ButtonImage.ImageTransparency = 1
		ButtonImage.Size = UDim2.fromOffset(25, 31)
		ButtonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		ButtonImage.Position = UDim2.fromScale(0.5, 0.5)
		ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		ButtonImage.Parent = Frame_2
		table.insert(t7, TweenService:Create(ButtonImage, v4, {
			ImageTransparency = 1
		}))
		table.insert(list, TweenService:Create(ButtonImage, v4, {
			ImageTransparency = 0
		}))
	else
		local ButtonImage = Instance.new("ImageLabel")
		ButtonImage.Name = "ButtonImage"
		ButtonImage.BackgroundTransparency = 1
		ButtonImage.ImageTransparency = 1
		ButtonImage.Size = UDim2.fromOffset(28, 30)
		ButtonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		ButtonImage.Position = UDim2.fromScale(0.5, 0.5)
		ButtonImage.Image = "rbxasset://textures/ui/Controls/key_single.png"
		ButtonImage.Parent = Frame_2
		table.insert(t7, TweenService:Create(ButtonImage, v4, {
			ImageTransparency = 1
		}))
		table.insert(list, TweenService:Create(ButtonImage, v4, {
			ImageTransparency = 0
		}))
		local v36 = UserInputService:GetStringForKeyCode(p1.KeyboardKeyCode)
		local v37 = t2[p1.KeyboardKeyCode]
		if v37 == nil then
			v37 = t3[v36]
		end
		if v37 == nil then
			local v38 = t4[p1.KeyboardKeyCode]
			if v38 then
				v36 = v38
			end
		end
		if v37 then
			local ButtonImage_2 = Instance.new("ImageLabel")
			ButtonImage_2.Name = "ButtonImage"
			ButtonImage_2.AnchorPoint = Vector2.new(0.5, 0.5)
			ButtonImage_2.Size = UDim2.fromOffset(36, 36)
			ButtonImage_2.Position = UDim2.fromScale(0.5, 0.5)
			ButtonImage_2.BackgroundTransparency = 1
			ButtonImage_2.ImageTransparency = 1
			ButtonImage_2.Image = v37
			ButtonImage_2.Parent = Frame_2
			table.insert(t7, TweenService:Create(ButtonImage_2, v4, {
				ImageTransparency = 1
			}))
			table.insert(list, TweenService:Create(ButtonImage_2, v4, {
				ImageTransparency = 0
			}))
		else
			if v36 == nil or v36 == "" then
				error("ProximityPrompt \'" .. p1.Name .. "\' has an unsupported keycode for rendering UI: " .. tostring(p1.KeyboardKeyCode))
			end
			local ButtonText = Instance.new("TextLabel")
			ButtonText.Name = "ButtonText"
			ButtonText.Position = UDim2.fromOffset(0, -1)
			ButtonText.Size = UDim2.fromScale(1, 1)
			ButtonText.Font = Enum.Font.MontserratBold
			ButtonText.TextSize = 16
			if string.len(v36) > 2 then
				ButtonText.TextSize = 12
			end
			ButtonText.BackgroundTransparency = 1
			ButtonText.TextTransparency = 1
			ButtonText.TextColor3 = Color3.new(255/255, 255/255, 255/255)
			ButtonText.TextXAlignment = Enum.TextXAlignment.Center
			ButtonText.Text = v36
			ButtonText.Parent = Frame_2
			table.insert(t7, TweenService:Create(ButtonText, v4, {
				TextTransparency = 1
			}))
			table.insert(list, TweenService:Create(ButtonText, v4, {
				TextTransparency = 0
			}))
		end
	end
	if p2 == Enum.ProximityPromptInputType.Touch or p1.ClickablePrompt then
		local TextButton = Instance.new("TextButton")
		TextButton.BackgroundTransparency = 1
		TextButton.TextTransparency = 1
		TextButton.Size = UDim2.fromScale(1, 1)
		TextButton.Parent = Prompt
		local v45 = false
		TextButton.InputBegan:Connect(function(p12) --[[ Line: 379 | Upvalues: p1 (copy), v45 (ref) ]]
			if p12.UserInputType ~= Enum.UserInputType.Touch and p12.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if p12.UserInputState == Enum.UserInputState.Change then
				return
			end
			p1:InputHoldBegin()
			v45 = true
		end)
		TextButton.InputEnded:Connect(function(p12) --[[ Line: 390 | Upvalues: v45 (ref), p1 (copy) ]]
			if p12.UserInputType ~= Enum.UserInputType.Touch and p12.UserInputType ~= Enum.UserInputType.MouseButton1 or not v45 then
				return
			end
			v45 = false
			p1:InputHoldEnd()
		end)
		Prompt.Active = true
	end
	if p1.HoldDuration > 0 then
		local v46 = createCircularProgressBar()
		v46.Parent = Frame_2
		table.insert(t5, TweenService:Create(v46.Progress, v1, {
			Value = 1
		}))
		table.insert(t6, TweenService:Create(v46.Progress, v2, {
			Value = 0
		}))
	end
	local v49, v50
	if p1.HoldDuration > 0 then
		v49 = p1.PromptButtonHoldBegan:Connect(function() --[[ Line: 424 | Upvalues: t5 (copy) ]]
			for i, v in ipairs(t5) do
				v:Play()
			end
		end)
		v50 = p1.PromptButtonHoldEnded:Connect(function() --[[ Line: 430 | Upvalues: t6 (copy) ]]
			for i, v in ipairs(t6) do
				v:Play()
			end
		end)
	else
		v49 = nil
		v50 = nil
	end
	local v51 = p1.Triggered:Connect(function() --[[ Line: 437 | Upvalues: t7 (copy) ]]
		for i, v in ipairs(t7) do
			v:Play()
		end
	end)
	local v52 = p1.TriggerEnded:Connect(function() --[[ Line: 443 | Upvalues: list (copy) ]]
		for i, v in ipairs(list) do
			v:Play()
		end
	end)
	local function updateUIFromPrompt() --[[ updateUIFromPrompt | Line: 449 | Upvalues: TextService (ref), p1 (copy), ActionText (copy), ObjectText (copy), Prompt (copy) ]]
		local v4 = if (p1.ActionText == nil or p1.ActionText == "") and (p1.ObjectText == nil or p1.ObjectText == "") then 72 else math.max(TextService:GetTextSize(p1.ActionText, 19, Enum.Font.MontserratBold, Vector2.new(1000, 1000)).X, TextService:GetTextSize(p1.ObjectText, 16, Enum.Font.MontserratBold, Vector2.new(1000, 1000)).X) + 72 + 24
		ActionText.Position = UDim2.new(0.5, 72 - v4 / 2, 0, if p1.ObjectText == nil or p1.ObjectText == "" then 0 else 9)
		ObjectText.Position = UDim2.new(0.5, 72 - v4 / 2, 0, -10)
		ActionText.Text = p1.ActionText
		ObjectText.Text = p1.ObjectText
		ActionText.AutoLocalize = p1.AutoLocalize
		ActionText.RootLocalizationTable = p1.RootLocalizationTable
		ObjectText.AutoLocalize = p1.AutoLocalize
		ObjectText.RootLocalizationTable = p1.RootLocalizationTable
		Prompt.Size = UDim2.fromOffset(v4 * 1.1, 72)
		Prompt.SizeOffset = Vector2.new(p1.UIOffset.X / Prompt.Size.Width.Offset, p1.UIOffset.Y / Prompt.Size.Height.Offset)
	end
	local v53 = p1.Changed:Connect(updateUIFromPrompt)
	updateUIFromPrompt()
	local v54 = p1.AncestryChanged:Connect(function() --[[ Line: 500 | Upvalues: p1 (copy), Prompt (copy) ]]
		if not p1:IsDescendantOf(workspace) then
			return
		end
		Prompt.Adornee = p1.Parent
	end)
	Prompt.Adornee = p1.Parent
	Prompt.Parent = p3
	for i, v in ipairs(list) do
		v:Play()
	end
	local function cleanup() --[[ cleanup | Line: 513 | Upvalues: v49 (ref), v50 (ref), v51 (ref), v52 (ref), v53 (copy), v54 (copy), t7 (copy), Prompt (copy) ]]
		if v49 then
			v49:Disconnect()
		end
		if v50 then
			v50:Disconnect()
		end
		v51:Disconnect()
		v52:Disconnect()
		v53:Disconnect()
		v54:Disconnect()
		for i, v in ipairs(t7) do
			v:Play()
		end
		wait(0.2)
		Prompt:Destroy()
	end
	p1.Destroying:Once(cleanup)
	return cleanup
end
local function onLoad() --[[ onLoad | Line: 541 | Upvalues: ProximityPromptService (copy), PlayerGui (copy), createPrompt (copy) ]]
	ProximityPromptService.PromptShown:Connect(function(p1_2, p2_2) --[[ Line: 542 | Upvalues: PlayerGui (ref), createPrompt (ref) ]]
		if p1_2.Style == Enum.ProximityPromptStyle.Default then
			return
		end
		local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")
		if ProximityPrompts == nil then
			local ProximityPrompts_2 = Instance.new("ScreenGui")
			ProximityPrompts_2.Name = "ProximityPrompts"
			ProximityPrompts_2.ResetOnSpawn = false
			ProximityPrompts_2.Parent = PlayerGui
			ProximityPrompts = ProximityPrompts_2
		end
		local v1 = createPrompt(p1_2, p2_2, ProximityPrompts)
		local v2 = p1_2:GetPropertyChangedSignal("Enabled"):Once(v1)
		local v3 = p1_2.PromptHidden:Once(v1)
		p1_2.Destroying:Once(function() --[[ Line: 554 | Upvalues: v2 (copy), v3 (copy) ]]
			v2:Disconnect()
			v3:Disconnect()
		end)
	end)
end
ProximityPromptService.PromptShown:Connect(function(p1_2, p2_2) --[[ Line: 542 | Upvalues: PlayerGui (copy), createPrompt (copy) ]]
	if p1_2.Style == Enum.ProximityPromptStyle.Default then
		return
	end
	local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")
	if ProximityPrompts == nil then
		local ProximityPrompts_2 = Instance.new("ScreenGui")
		ProximityPrompts_2.Name = "ProximityPrompts"
		ProximityPrompts_2.ResetOnSpawn = false
		ProximityPrompts_2.Parent = PlayerGui
		ProximityPrompts = ProximityPrompts_2
	end
	local v1 = createPrompt(p1_2, p2_2, ProximityPrompts)
	local v2 = p1_2:GetPropertyChangedSignal("Enabled"):Once(v1)
	local v3 = p1_2.PromptHidden:Once(v1)
	p1_2.Destroying:Once(function() --[[ Line: 554 | Upvalues: v2 (copy), v3 (copy) ]]
		v2:Disconnect()
		v3:Disconnect()
	end)
end)