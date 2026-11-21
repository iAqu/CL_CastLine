local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")

local LUCKIEST_GUY = Font.fromName("LuckiestGuy", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local ACTION_TEXT_SIZE = 19
local OBJECT_TEXT_SIZE = 14
local TEXT_SIZE_FONT = Enum.Font.GothamBold
local PROGRESS_BILLBOARD_SIZE = 72

local KEYCODE_IMAGES: { [Enum.KeyCode]: string } = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png",
}

local CHAR_IMAGES: { [string]: string } = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png",
}

local KEYCODE_LABELS: { [Enum.KeyCode]: string } = {
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
	[Enum.KeyCode.F12] = "F12",
}

type InputCategory = "Gamepad" | "Touch" | "KeyboardAndMouse"

type ActivePromptEntry = {
	prompt: ProximityPrompt,
	inputFrame: Frame,
}

local ProximityPromptController = Knit.CreateController({
	Name = "ProximityPromptController",
})

local activePrompts: { ActivePromptEntry } = {}
local sharedProgressBillboard: BillboardGui? = nil
local sharedProgressBar: Frame? = nil
local sharedProgressValue: NumberValue? = nil
local sharedProgressWarmupAdornee: BasePart? = nil
local attachedProgressPrompt: ProximityPrompt? = nil
local attachedInputFrame: Frame? = nil
local attachedInputFrameParent: Instance? = nil

local function getScreenGui(): ScreenGui
	local screenGui = PLAYER_GUI:FindFirstChild("ProximityPrompts")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ProximityPrompts"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = PLAYER_GUI
	end
	return screenGui :: ScreenGui
end

local function getProgressScreenGui(): ScreenGui
	local screenGui = PLAYER_GUI:FindFirstChild("ProximityPromptProgress")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ProximityPromptProgress"
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 10
		screenGui.Parent = PLAYER_GUI
	end
	return screenGui :: ScreenGui
end

local function getInputCategory(inputType: Enum.UserInputType): InputCategory
	if inputType == Enum.UserInputType.Touch then
		return "Touch"
	end

	if
		inputType == Enum.UserInputType.Gamepad1
		or inputType == Enum.UserInputType.Gamepad2
		or inputType == Enum.UserInputType.Gamepad3
		or inputType == Enum.UserInputType.Gamepad4
		or inputType == Enum.UserInputType.Gamepad5
		or inputType == Enum.UserInputType.Gamepad6
		or inputType == Enum.UserInputType.Gamepad7
		or inputType == Enum.UserInputType.Gamepad8
	then
		return "Gamepad"
	end

	return "KeyboardAndMouse"
end

local function createProgressBarGradient(parent: Frame, isLeft: boolean): UIGradient
	local sideFrame = Instance.new("Frame")
	sideFrame.Size = UDim2.fromScale(0.5, 1)
	sideFrame.Position = UDim2.fromScale(if isLeft then 0 else 0.5, 0)
	sideFrame.BackgroundTransparency = 1
	sideFrame.ClipsDescendants = true
	sideFrame.Parent = parent

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.fromScale(2, 1)
	imageLabel.Position = UDim2.fromScale(if isLeft then 0 else -1, 0)
	imageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	imageLabel.ImageTransparency = 0
	imageLabel.Parent = sideFrame

	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.4999, 0),
		NumberSequenceKeypoint.new(0.5, 1),
		NumberSequenceKeypoint.new(1, 1),
	})
	gradient.Rotation = if isLeft then 180 else 0
	gradient.Parent = imageLabel

	return gradient
end

local function createCircularProgressBar(): (Frame, NumberValue)
	local progressBar = Instance.new("Frame")
	progressBar.Name = "CircularProgressBar"
	progressBar.Size = UDim2.fromOffset(58, 58)
	progressBar.AnchorPoint = Vector2.new(0.5, 0.5)
	progressBar.Position = UDim2.fromScale(0.5, 0.5)
	progressBar.BackgroundTransparency = 1

	local leftGradient = createProgressBarGradient(progressBar, true)
	local rightGradient = createProgressBarGradient(progressBar, false)

	local progress = Instance.new("NumberValue")
	progress.Name = "Progress"
	progress.Parent = progressBar

	local function renderProgress(value: number)
		local degrees = math.clamp(value * 360, 0, 360)
		leftGradient.Rotation = math.clamp(degrees, 180, 360)
		rightGradient.Rotation = math.clamp(degrees, 0, 180)
	end

	progress.Changed:Connect(renderProgress)
	renderProgress(0)

	return progressBar, progress
end

local function ensureWarmupAdornee(): BasePart
	local existing = workspace:FindFirstChild("ProximityPromptProgressWarmup")
	if existing and existing:IsA("BasePart") then
		return existing
	end

	local part = Instance.new("Part")
	part.Name = "ProximityPromptProgressWarmup"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.Position = Vector3.new(0, -10000, 0)
	part.Parent = workspace
	return part
end

local function progressSizeOffsetForPrompt(prompt: ProximityPrompt, keyBillboardWidth: number): Vector2
	local keyCenterX = -keyBillboardWidth / 2 + 36
	return Vector2.new(
		keyCenterX / PROGRESS_BILLBOARD_SIZE + prompt.UIOffset.X / PROGRESS_BILLBOARD_SIZE,
		prompt.UIOffset.Y / PROGRESS_BILLBOARD_SIZE
	)
end

local function ensureSharedProgress()
	if sharedProgressBillboard and sharedProgressValue then
		return
	end

	local warmup = ensureWarmupAdornee()
	sharedProgressWarmupAdornee = warmup

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PromptProgress"
	billboard.AlwaysOnTop = true
	billboard.ResetOnSpawn = false
	billboard.Size = UDim2.fromOffset(PROGRESS_BILLBOARD_SIZE, PROGRESS_BILLBOARD_SIZE)
	billboard.Adornee = warmup
	billboard.Enabled = true
	billboard.Parent = getProgressScreenGui()

	local progressBar, progress = createCircularProgressBar()
	progressBar.ZIndex = 0
	progressBar.Parent = billboard

	sharedProgressBillboard = billboard
	sharedProgressBar = progressBar
	sharedProgressValue = progress
end

local function attachSharedProgress(prompt: ProximityPrompt, promptBillboard: BillboardGui, inputFrame: Frame)
	ensureSharedProgress()
	local billboard = sharedProgressBillboard
	local progressBar = sharedProgressBar
	if not billboard or not progressBar then
		return
	end

	local adornee = prompt.Parent
	if adornee and adornee:IsA("BasePart") then
		billboard.Adornee = adornee
	end
	billboard.SizeOffset = progressSizeOffsetForPrompt(prompt, promptBillboard.Size.Width.Offset)
	billboard.StudsOffsetWorldSpace = promptBillboard.StudsOffsetWorldSpace
	if sharedProgressValue then
		sharedProgressValue.Value = 0
	end

	attachedProgressPrompt = prompt
	attachedInputFrame = inputFrame
	attachedInputFrameParent = inputFrame.Parent
	inputFrame.Parent = billboard
	progressBar.Parent = inputFrame
	progressBar.ZIndex = 0
end

local function detachSharedProgress(prompt: ProximityPrompt)
	if attachedProgressPrompt ~= prompt then
		return
	end

	if sharedProgressBar and sharedProgressBillboard then
		sharedProgressBar.Parent = sharedProgressBillboard
	end
	if attachedInputFrame and attachedInputFrameParent then
		attachedInputFrame.Parent = attachedInputFrameParent
	end

	attachedProgressPrompt = nil
	attachedInputFrame = nil
	attachedInputFrameParent = nil
	if sharedProgressValue then
		sharedProgressValue.Value = 0
	end
	if sharedProgressBillboard and sharedProgressWarmupAdornee then
		sharedProgressBillboard.Adornee = sharedProgressWarmupAdornee
		sharedProgressBillboard.SizeOffset = Vector2.zero
		sharedProgressBillboard.StudsOffsetWorldSpace = Vector3.zero
	end
end

local function clearInputIcons(inputFrame: Frame)
	for _, child in inputFrame:GetChildren() do
		if
			child.Name == "ButtonImage"
			or child.Name == "ButtonText"
			or child.Name == "KeycapBackground"
		then
			child:Destroy()
		end
	end
end

local function registerIconTween(
	target: GuiObject,
	property: string,
	showTweens: { Tween },
	triggerTweens: { Tween },
	buttonTweenInfo: TweenInfo,
	immediateVisible: boolean?
)
	if immediateVisible then
		(target :: any)[property] = 0
		return
	end

	(target :: any)[property] = 1
	table.insert(showTweens, TweenService:Create(target, buttonTweenInfo, { [property] = 0 }))
	table.insert(triggerTweens, TweenService:Create(target, buttonTweenInfo, { [property] = 1 }))
end

local function rebuildInputIcon(
	prompt: ProximityPrompt,
	inputFrame: Frame,
	inputCategory: InputCategory,
	showTweens: { Tween },
	triggerTweens: { Tween },
	buttonTweenInfo: TweenInfo,
	immediateVisible: boolean?
)
	clearInputIcons(inputFrame)

	if inputCategory == "Gamepad" then
		local image = UserInputService:GetImageForKeyCode(prompt.GamepadKeyCode)
		if image == "" then
			return
		end

		local buttonImage = Instance.new("ImageLabel")
		buttonImage.Name = "ButtonImage"
		buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		buttonImage.Size = UDim2.fromOffset(24, 24)
		buttonImage.Position = UDim2.fromScale(0.5, 0.5)
		buttonImage.BackgroundTransparency = 1
		buttonImage.Image = image
		buttonImage.Parent = inputFrame
		registerIconTween(
			buttonImage,
			"ImageTransparency",
			showTweens,
			triggerTweens,
			buttonTweenInfo,
			immediateVisible
		)
		return
	end

	if inputCategory == "Touch" then
		local buttonImage = Instance.new("ImageLabel")
		buttonImage.Name = "ButtonImage"
		buttonImage.BackgroundTransparency = 1
		buttonImage.Size = UDim2.fromOffset(25, 31)
		buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		buttonImage.Position = UDim2.fromScale(0.5, 0.5)
		buttonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		buttonImage.Parent = inputFrame
		registerIconTween(
			buttonImage,
			"ImageTransparency",
			showTweens,
			triggerTweens,
			buttonTweenInfo,
			immediateVisible
		)
		return
	end

	local keycapBackground = Instance.new("ImageLabel")
	keycapBackground.Name = "KeycapBackground"
	keycapBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	keycapBackground.Size = UDim2.fromOffset(28, 30)
	keycapBackground.Position = UDim2.fromScale(0.5, 0.5)
	keycapBackground.BackgroundTransparency = 1
	keycapBackground.Image = "rbxasset://textures/ui/Controls/key_single.png"
	keycapBackground.Parent = inputFrame
	registerIconTween(
		keycapBackground,
		"ImageTransparency",
		showTweens,
		triggerTweens,
		buttonTweenInfo,
		immediateVisible
	)

	local keyLabel = UserInputService:GetStringForKeyCode(prompt.KeyboardKeyCode)
	local keyImage = KEYCODE_IMAGES[prompt.KeyboardKeyCode] or CHAR_IMAGES[keyLabel]

	if not keyImage then
		local altLabel = KEYCODE_LABELS[prompt.KeyboardKeyCode]
		if altLabel then
			keyLabel = altLabel
		end
	end

	if keyImage then
		local buttonImage = Instance.new("ImageLabel")
		buttonImage.Name = "ButtonImage"
		buttonImage.AnchorPoint = Vector2.new(0.5, 0.5)
		buttonImage.Size = UDim2.fromOffset(36, 36)
		buttonImage.Position = UDim2.fromScale(0.5, 0.5)
		buttonImage.BackgroundTransparency = 1
		buttonImage.Image = keyImage
		buttonImage.Parent = inputFrame
		registerIconTween(
			buttonImage,
			"ImageTransparency",
			showTweens,
			triggerTweens,
			buttonTweenInfo,
			immediateVisible
		)
		return
	end

	if keyLabel == nil or keyLabel == "" then
		warn(
			"[ProximityPromptController] Unsupported keycode for prompt:",
			prompt.Name,
			prompt.KeyboardKeyCode
		)
		return
	end

	local buttonText = Instance.new("TextLabel")
	buttonText.Name = "ButtonText"
	buttonText.Position = UDim2.fromOffset(0, -1)
	buttonText.Size = UDim2.fromScale(1, 1)
	buttonText.FontFace = LUCKIEST_GUY
	buttonText.TextSize = if string.len(keyLabel) > 2 then 12 else 14
	buttonText.BackgroundTransparency = 1
	buttonText.TextColor3 = Color3.new(1, 1, 1)
	buttonText.TextXAlignment = Enum.TextXAlignment.Center
	buttonText.AutoLocalize = false
	buttonText.Text = keyLabel
	buttonText.Parent = inputFrame
	registerIconTween(
		buttonText,
		"TextTransparency",
		showTweens,
		triggerTweens,
		buttonTweenInfo,
		immediateVisible
	)
end

local function createPrompt(
	prompt: ProximityPrompt,
	inputType: Enum.ProximityPromptInputType,
	parentGui: ScreenGui
): () -> ()
	local holdTweens: { Tween } = {}
	local holdEndTweens: { Tween } = {}
	local triggerTweens: { Tween } = {}
	local showTweens: { Tween } = {}

	local fadeTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local buttonTweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local showTweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
	local hideTweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Prompt"
	billboard.AlwaysOnTop = true
	billboard.Enabled = true
	local worldOffset = prompt:GetAttribute("StudsOffsetWorldSpace")
	if typeof(worldOffset) == "Vector3" then
		billboard.StudsOffsetWorldSpace = worldOffset
	end

	local promptFrame = Instance.new("Frame")
	promptFrame.Size = UDim2.fromScale(0.5, 1)
	promptFrame.BackgroundTransparency = 1
	promptFrame.Rotation = -22
	promptFrame.Parent = billboard
	Instance.new("UICorner").Parent = promptFrame

	local inputFrameContainer = Instance.new("Frame")
	inputFrameContainer.Name = "InputFrame"
	inputFrameContainer.Size = UDim2.fromScale(1, 1)
	inputFrameContainer.BackgroundTransparency = 1
	inputFrameContainer.SizeConstraint = Enum.SizeConstraint.RelativeYY
	inputFrameContainer.Parent = promptFrame

	local inputFrame = Instance.new("Frame")
	inputFrame.Size = UDim2.fromScale(1, 1)
	inputFrame.Position = UDim2.fromScale(0.5, 0.5)
	inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	inputFrame.BackgroundTransparency = 1
	inputFrame.Parent = inputFrameContainer

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = 0.4
	uiScale.Parent = inputFrame

	table.insert(showTweens, TweenService:Create(uiScale, showTweenInfo, { Scale = 1 }))
	table.insert(showTweens, TweenService:Create(promptFrame, showTweenInfo, { Rotation = 0 }))
	table.insert(triggerTweens, TweenService:Create(uiScale, hideTweenInfo, { Scale = 0.4 }))
	table.insert(holdTweens, TweenService:Create(uiScale, fadeTweenInfo, {
		Scale = if inputType == Enum.ProximityPromptInputType.Touch then 1.6 else 1.33,
	}))
	table.insert(holdEndTweens, TweenService:Create(uiScale, fadeTweenInfo, { Scale = 1 }))

	local actionText = Instance.new("TextLabel")
	actionText.Name = "ActionText"
	actionText.Size = UDim2.fromScale(1, 1)
	actionText.FontFace = LUCKIEST_GUY
	actionText.TextSize = ACTION_TEXT_SIZE
	actionText.BackgroundTransparency = 1
	actionText.TextTransparency = 1
	actionText.TextColor3 = Color3.new(1, 1, 1)
	actionText.TextStrokeTransparency = 0
	actionText.TextXAlignment = Enum.TextXAlignment.Left
	actionText.AutoLocalize = false
	actionText.Parent = promptFrame

	local objectText = Instance.new("TextLabel")
	objectText.Name = "ObjectText"
	objectText.Size = UDim2.fromScale(1, 1)
	objectText.FontFace = LUCKIEST_GUY
	objectText.TextSize = OBJECT_TEXT_SIZE
	objectText.BackgroundTransparency = 1
	objectText.TextTransparency = 1
	objectText.TextStrokeTransparency = 0
	objectText.TextColor3 = Color3.new(0.7, 0.7, 0.7)
	objectText.TextXAlignment = Enum.TextXAlignment.Left
	objectText.AutoLocalize = false
	objectText.Parent = promptFrame

	local function addTextTweens(label: TextLabel)
		table.insert(holdTweens, TweenService:Create(label, fadeTweenInfo, { TextTransparency = 1 }))
		table.insert(holdEndTweens, TweenService:Create(label, fadeTweenInfo, { TextTransparency = 0 }))
		table.insert(triggerTweens, TweenService:Create(label, fadeTweenInfo, { TextTransparency = 1 }))
		table.insert(showTweens, TweenService:Create(label, fadeTweenInfo, { TextTransparency = 0 }))
	end

	addTextTweens(actionText)
	addTextTweens(objectText)

	local strokeScale = prompt:GetAttribute("ActionTextStrokeScale")
	if typeof(strokeScale) == "number" and strokeScale > 0 then
		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		stroke.Thickness = strokeScale
		stroke.Color = actionText.TextStrokeColor3
		stroke.Transparency = 1
		stroke.Parent = actionText
		actionText.TextStrokeTransparency = 1
		table.insert(holdTweens, TweenService:Create(stroke, fadeTweenInfo, { Transparency = 1 }))
		table.insert(holdEndTweens, TweenService:Create(stroke, fadeTweenInfo, { Transparency = 0 }))
		table.insert(triggerTweens, TweenService:Create(stroke, fadeTweenInfo, { Transparency = 1 }))
		table.insert(showTweens, TweenService:Create(stroke, fadeTweenInfo, { Transparency = 0 }))
	end

	table.insert(holdTweens, TweenService:Create(promptFrame, fadeTweenInfo, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.5, 1),
	}))
	table.insert(holdEndTweens, TweenService:Create(promptFrame, fadeTweenInfo, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}))
	table.insert(triggerTweens, TweenService:Create(promptFrame, fadeTweenInfo, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.5, 1),
	}))
	table.insert(showTweens, TweenService:Create(promptFrame, fadeTweenInfo, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}))

	local roundFrame = Instance.new("Frame")
	roundFrame.Name = "RoundFrame"
	roundFrame.Size = UDim2.fromOffset(48, 48)
	roundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	roundFrame.Position = UDim2.fromScale(0.5, 0.5)
	roundFrame.BackgroundTransparency = 1
	roundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	roundFrame.Parent = inputFrame

	local roundCorner = Instance.new("UICorner")
	roundCorner.CornerRadius = UDim.new(0.5, 0)
	roundCorner.Parent = roundFrame

	table.insert(triggerTweens, TweenService:Create(roundFrame, buttonTweenInfo, { BackgroundTransparency = 1 }))
	table.insert(showTweens, TweenService:Create(roundFrame, buttonTweenInfo, { BackgroundTransparency = 0.5 }))

	local initialCategory = getInputCategory(UserInputService:GetLastInputType())
	rebuildInputIcon(prompt, inputFrame, initialCategory, showTweens, triggerTweens, buttonTweenInfo)

	if inputType == Enum.ProximityPromptInputType.Touch or prompt.ClickablePrompt then
		local textButton = Instance.new("TextButton")
		textButton.BackgroundTransparency = 1
		textButton.TextTransparency = 1
		textButton.Size = UDim2.fromScale(1, 1)
		textButton.Parent = billboard

		local holding = false

		textButton.InputBegan:Connect(function(input: InputObject)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if input.UserInputState == Enum.UserInputState.Change then
				return
			end

			prompt:InputHoldBegin()
			holding = true
		end)

		textButton.InputEnded:Connect(function(input: InputObject)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if not holding then
				return
			end

			holding = false
			prompt:InputHoldEnd()
		end)

		billboard.Active = true
	end

	if prompt.HoldDuration > 0 then
		ensureSharedProgress()
	end
	local progressValue: NumberValue? = if prompt.HoldDuration > 0 then sharedProgressValue else nil

	local holdBeganConn: RBXScriptConnection? = nil
	local holdEndedConn: RBXScriptConnection? = nil
	local holdDriverConn: RBXScriptConnection? = nil
	local holdElapsed = 0

	local function stopHoldDriver()
		if holdDriverConn then
			holdDriverConn:Disconnect()
			holdDriverConn = nil
		end
	end

	local function resetHoldProgress()
		stopHoldDriver()
		holdElapsed = 0

		if progressValue then
			progressValue.Value = 0
		end
	end

	local function startHoldDriver()
		local progress = progressValue
		if not progress or prompt.HoldDuration <= 0 then
			return
		end

		resetHoldProgress()
		holdDriverConn = RunService.Heartbeat:Connect(function(deltaTime: number)
			holdElapsed += deltaTime
			local nextProgress = math.clamp(holdElapsed / math.max(prompt.HoldDuration, 0.001), 0, 1)
			progress.Value = nextProgress

			if nextProgress >= 1 then
				stopHoldDriver()
			end
		end)
	end

	if prompt.HoldDuration > 0 then
		holdBeganConn = prompt.PromptButtonHoldBegan:Connect(function()
			for _, tween in holdTweens do
				tween:Play()
			end

			startHoldDriver()
		end)

		holdEndedConn = prompt.PromptButtonHoldEnded:Connect(function()
			resetHoldProgress()

			for _, tween in holdEndTweens do
				tween:Play()
			end
		end)
	end

	local triggeredConn = prompt.Triggered:Connect(function()
		resetHoldProgress()

		for _, tween in triggerTweens do
			tween:Play()
		end
	end)

	local triggerEndedConn = prompt.TriggerEnded:Connect(function()
		for _, tween in showTweens do
			tween:Play()
		end
	end)

	local function updateUIFromPrompt()
		local actionTextValue = prompt.ActionText or ""
		local objectTextValue = prompt.ObjectText or ""

		local width = if actionTextValue == "" and objectTextValue == "" then 72
			else math.max(
				TextService:GetTextSize(actionTextValue, ACTION_TEXT_SIZE, TEXT_SIZE_FONT, Vector2.new(1000, 1000)).X,
				TextService:GetTextSize(objectTextValue, OBJECT_TEXT_SIZE, TEXT_SIZE_FONT, Vector2.new(1000, 1000)).X
			) + 72 + 24

		actionText.Position = UDim2.new(
			0.5,
			72 - width / 2,
			0,
			if objectTextValue == "" then 0 else 9
		)
		objectText.Position = UDim2.new(0.5, 72 - width / 2, 0, -10)
		actionText.Text = actionTextValue
		objectText.Text = objectTextValue
		billboard.Size = UDim2.fromOffset(width, 72)
		billboard.SizeOffset = Vector2.new(
			prompt.UIOffset.X / billboard.Size.Width.Offset,
			prompt.UIOffset.Y / billboard.Size.Height.Offset
		)
		if attachedProgressPrompt == prompt and sharedProgressBillboard then
			sharedProgressBillboard.SizeOffset = progressSizeOffsetForPrompt(prompt, width)
		end
	end

	local changedConn = prompt.Changed:Connect(updateUIFromPrompt)
	local ancestryConn = prompt.AncestryChanged:Connect(function(_, parent)
		if parent and parent:IsA("BasePart") then
			billboard.Adornee = parent
			if attachedProgressPrompt == prompt and sharedProgressBillboard then
				sharedProgressBillboard.Adornee = parent
			end
		end
	end)

	updateUIFromPrompt()
	billboard.Adornee = prompt.Parent
	billboard.Parent = parentGui

	table.insert(activePrompts, {
		prompt = prompt,
		inputFrame = inputFrame,
	})

	for _, tween in showTweens do
		tween:Play()
	end

	if prompt.HoldDuration > 0 then
		attachSharedProgress(prompt, billboard, inputFrame)
	end

	local cleanedUp = false

	return function()
		if cleanedUp then
			return
		end
		cleanedUp = true
		detachSharedProgress(prompt)
		billboard.Enabled = false
		billboard.Parent = nil

		if holdBeganConn then
			holdBeganConn:Disconnect()
		end
		if holdEndedConn then
			holdEndedConn:Disconnect()
		end
		resetHoldProgress()

		triggeredConn:Disconnect()
		triggerEndedConn:Disconnect()
		changedConn:Disconnect()
		ancestryConn:Disconnect()

		for index, entry in activePrompts do
			if entry.prompt == prompt then
				table.remove(activePrompts, index)
				break
			end
		end

		billboard:Destroy()
	end
end

local function refreshActiveInputIcons()
	local inputCategory = getInputCategory(UserInputService:GetLastInputType())

	for _, entry in activePrompts do
		local prompt = entry.prompt
		local inputFrame = entry.inputFrame

		if prompt and inputFrame then
			rebuildInputIcon(prompt, inputFrame, inputCategory, {}, {}, TweenInfo.new(0), true)
		end
	end
end

function ProximityPromptController:KnitStart()
	ensureSharedProgress()
	UserInputService.LastInputTypeChanged:Connect(refreshActiveInputIcons)

	ProximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt, inputType: Enum.ProximityPromptInputType)
		if prompt:GetAttribute("DontShow") ~= nil then
			return
		end
		if prompt.Style == Enum.ProximityPromptStyle.Default then
			return
		end

		local cleanup = createPrompt(prompt, inputType, getScreenGui())

		local hiddenConn: RBXScriptConnection? = nil
		local destroyedConn: RBXScriptConnection? = nil

		local function finish()
			if hiddenConn then
				hiddenConn:Disconnect()
				hiddenConn = nil
			end
			if destroyedConn then
				destroyedConn:Disconnect()
				destroyedConn = nil
			end
			cleanup()
		end

		hiddenConn = prompt.PromptHidden:Connect(finish)
		destroyedConn = prompt.AncestryChanged:Connect(function()
			if not prompt:IsDescendantOf(game) then
				finish()
			end
		end)

		if not prompt:IsDescendantOf(game) then
			finish()
		end
	end)
end

return ProximityPromptController
