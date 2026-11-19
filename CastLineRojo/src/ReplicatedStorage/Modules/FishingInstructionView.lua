local UserInputService = game:GetService("UserInputService")
local Config = require(script.Parent.FishingIntroConfig)

local View = {}
local SHOW_BITE_CUE_TEXT = false
local FINGER_X, FINGER_Y = 0.84, 0.6
local WAIT_COLOR = Color3.new(1, 1, 1)
local HOOK_COLOR = Color3.fromRGB(unpack(Config.Instructions.Hook.Color))

function View.Create(playerGui, name)
	local gui = Instance.new("ScreenGui")
	gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset, gui.DisplayOrder = name, false, true, 200
	local label = playerGui.FishingSequenceGui.ContinuePrompt:Clone()
	label.Name, label.AnchorPoint = "Instruction", Vector2.new(0.5, 0.5)
	label.Position, label.Size = UDim2.fromScale(0.5, 0.86), UDim2.fromScale(0.96, 0.12)
	label.BackgroundTransparency, label.TextTransparency, label.TextScaled = 1, 0, true
	label.RichText, label.Active, label.Selectable, label.Interactable = false, false, false, false
	local constraint = label:FindFirstChildOfClass("UITextSizeConstraint") or Instance.new("UITextSizeConstraint")
	constraint.MinTextSize, constraint.MaxTextSize, constraint.Parent = 16, 94, label
	local stroke = label:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	stroke.Thickness, stroke.Color, stroke.Transparency, stroke.Parent = 4, Color3.new(0, 0, 0), 0, label
	label.Visible, label.Parent = false, gui
	local biteCue = label:Clone()
	biteCue.Name, biteCue.AnchorPoint, biteCue.ZIndex = "BiteCue", Vector2.new(0.5, 1), 4
	biteCue.Size = UDim2.fromScale(0.28, 0.1)
	biteCue.TextXAlignment, biteCue.TextYAlignment = Enum.TextXAlignment.Center, Enum.TextYAlignment.Bottom
	biteCue:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 64
	biteCue.Parent = gui
	local tap = Instance.new("ImageLabel")
	tap.Name, tap.Image, tap.BackgroundTransparency = "HookTapFinger", "rbxassetid://8903957093", 1
	tap.AnchorPoint, tap.ScaleType, tap.ZIndex = Vector2.new(0.5, 0.5), Enum.ScaleType.Fit, 3
	tap.Active, tap.Selectable, tap.Interactable, tap.Visible = false, false, false, false
	tap.Parent, gui.Parent = gui, playerGui
	return gui, label, tap, biteCue
end

function View.ShowBiteCue(label, finger, phase, elapsed)
	local canHook = phase == "Bite"
	local showText = SHOW_BITE_CUE_TEXT and (canHook or phase == "Nibbling")
	label.Visible, finger.Visible = showText, canHook
	if not (showText or canHook) then
		return
	end
	local viewport = label.Parent.AbsoluteSize
	local size = math.clamp(math.min(viewport.X, viewport.Y) * 0.14, 72, 148)
	if showText then
		label.Position = UDim2.new(FINGER_X, 0, FINGER_Y, -size * 0.5 - 12)
		label.Text = if canHook then "HOOK!" else "WAIT"
		label.TextColor3 = if canHook then HOOK_COLOR else WAIT_COLOR
	end
	if canHook then
		local press = 0.5 - 0.5 * math.cos(elapsed * math.pi * 2 / 0.36)
		local pressedSize = size * (1 - press * 0.15)
		finger.Position = UDim2.new(FINGER_X, -10 * press, FINGER_Y, 6 * press)
		finger.Size = UDim2.fromOffset(pressedSize, pressedSize)
	end
end

function View.ShowFishing(label, kind)
	local entry = Config.Instructions[if kind == "FinalCast" then "Cast" else kind]
	label.Visible = entry ~= nil
	if entry then
		local prefix = if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then "PRESS A TO " else "TAP TO "
		label.Position = UDim2.fromScale(0.5, if kind == "Continue" then 0.74 else 0.86)
		label.Text = entry.Text or prefix .. entry.Action .. (if entry.Action == "CONTINUE" then "" else "!")
		label.TextColor3 = Color3.fromRGB(unpack(entry.Color))
		label:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = if kind == "FinalCast" then 44 else 94
	end
end

return View
