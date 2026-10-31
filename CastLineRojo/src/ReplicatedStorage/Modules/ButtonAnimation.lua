local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)

local MOUSE_ENTER_SIZE = 1.1
local MOUSE_ENTER_DURATION = 0.15
local MOUSE_LEAVE_DURATION = 0.2
local CLICK_SIZE = 1.1
local MOUSE_CLICK_DURATION = 0.05
local UI_SCALE_TWEEN_INFO = TweenInfo.new(0.1)

local module = {}

local setUpButtons: { [GuiButton]: boolean } = {}
local originalSizes: { [GuiButton]: UDim2 } = {}
local mouseEnterScaleSizes: { [GuiButton]: number } = {}

local function tweenUIScale(uiScale: UIScale, targetScale: number)
	TweenService:Create(uiScale, UI_SCALE_TWEEN_INFO, {
		Scale = targetScale,
	}):Play()
end

local function setUpUIScaleButton(button: GuiButton, uiScale: UIScale, hoverScale: number)
	button.MouseEnter:Connect(function()
		tweenUIScale(uiScale, hoverScale)
	end)

	button.MouseLeave:Connect(function()
		tweenUIScale(uiScale, 1)
	end)

	button.MouseButton1Down:Connect(function()
		tweenUIScale(uiScale, 1)
	end)

	button.MouseButton1Up:Connect(function()
		tweenUIScale(uiScale, hoverScale)
	end)

	button.SelectionGained:Connect(function()
		tweenUIScale(uiScale, hoverScale)
	end)

	button.SelectionLost:Connect(function()
		tweenUIScale(uiScale, 1)
	end)
end

local function onMouseEnter(button: GuiButton, originalSize: UDim2)
	local mouseEnterScaleSize = mouseEnterScaleSizes[button] or MOUSE_ENTER_SIZE

	local hoverSize = UDim2.new(
		originalSize.X.Scale * mouseEnterScaleSize,
		0,
		originalSize.Y.Scale * mouseEnterScaleSize,
		0
	)
	button:TweenSize(hoverSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, MOUSE_ENTER_DURATION, true)
end

local function onMouseLeave(button: GuiButton, originalSize: UDim2)
	button:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Back, MOUSE_LEAVE_DURATION, true)
end

local function onMouseClick(button: GuiButton, originalSize: UDim2)
	local clickSize = UDim2.new(
		originalSize.X.Scale / CLICK_SIZE,
		0,
		originalSize.Y.Scale / CLICK_SIZE,
		0
	)
	button:TweenSize(clickSize, "Out", "Sine", MOUSE_CLICK_DURATION, true)
end

local function setUpSizeButton(button: GuiButton, hoverScale: number)
	if not originalSizes[button] then
		originalSizes[button] = button.Size
	end

	local mainSize = originalSizes[button]

	button.MouseEnter:Connect(function()
		onMouseEnter(button, mainSize)
	end)

	button.MouseLeave:Connect(function()
		onMouseLeave(button, mainSize)
	end)

	button.MouseButton1Down:Connect(function()
		onMouseClick(button, mainSize)
	end)

	button.MouseButton1Up:Connect(function()
		onMouseLeave(button, mainSize)
	end)

	button.SelectionGained:Connect(function()
		onMouseEnter(button, mainSize)
	end)

	button.SelectionLost:Connect(function()
		onMouseLeave(button, mainSize)
	end)
end

function module.SetUp(button: GuiButton, mouseEnterScaleSize: number?)
	if setUpButtons[button] then
		return
	end
	setUpButtons[button] = true

	mouseEnterScaleSize = mouseEnterScaleSize or MOUSE_ENTER_SIZE
	mouseEnterScaleSizes[button] = mouseEnterScaleSize
	button.Activated:Connect(function()
		SoundHelper.PlaySound(Constants.SoundRes.GUI_BUTTON_CLICK)
	end)

	local uiScale = button:FindFirstChild("UIScale")
	if uiScale and uiScale:IsA("UIScale") then
		setUpUIScaleButton(button, uiScale, mouseEnterScaleSize)
		return
	end

	setUpSizeButton(button, mouseEnterScaleSize)
end

local function trySetUpButton(button: Instance)
	if button:IsA("GuiButton") then
		module.SetUp(button)
	end
end

-- init static button animations; dynamic buttons are registered via Button tag or manual SetUp
for _, guiElement in pairs(PlayerGui:GetDescendants()) do
	-- not support offset size button
	if guiElement:IsA("GuiButton") and guiElement.Size.X.Offset == 0 and guiElement.Size.Y.Offset == 0 then
		module.SetUp(guiElement)
	end
end

for _, button in CollectionService:GetTagged("Button") do
	trySetUpButton(button)
end

CollectionService:GetInstanceAddedSignal("Button"):Connect(trySetUpButton)

return module
