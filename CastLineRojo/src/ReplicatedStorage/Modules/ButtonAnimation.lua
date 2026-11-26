local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local MOUSE_ENTER_SIZE = 1.1
local MOUSE_ENTER_DURATION = 0.15
local MOUSE_LEAVE_DURATION = 0.2
local CLICK_SIZE = 1.1
local MOUSE_CLICK_DURATION = 0.05
local UI_SCALE_TWEEN_INFO = TweenInfo.new(0.1)

local module = {}

local started = false
local buttonConnections: { [GuiButton]: { RBXScriptConnection } } = {}
local originalSizes: { [GuiButton]: UDim2 } = {}
local mouseEnterScaleSizes: { [GuiButton]: number } = {}

local function connectButton(button: GuiButton, signal: RBXScriptSignal, callback: () -> ())
	table.insert(buttonConnections[button], signal:Connect(callback))
end

local function disconnectButton(button: GuiButton)
	for _, connection in buttonConnections[button] do
		connection:Disconnect()
	end
	buttonConnections[button] = nil
	originalSizes[button] = nil
	mouseEnterScaleSizes[button] = nil
end

local function playClickSound()
	-- 音效依赖存档和声音资源，不能阻塞动画初始化。
	local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
	local Constants = require(ReplicatedStorage.Modules.Constants)
	SoundHelper.PlaySound(Constants.SoundRes.GUI_BUTTON_CLICK)
end

local function tweenUIScale(uiScale: UIScale, targetScale: number)
	TweenService:Create(uiScale, UI_SCALE_TWEEN_INFO, {
		Scale = targetScale,
	}):Play()
end

local function setUpUIScaleButton(button: GuiButton, uiScale: UIScale)
	connectButton(button, button.MouseEnter, function()
		tweenUIScale(uiScale, mouseEnterScaleSizes[button])
	end)

	connectButton(button, button.MouseLeave, function()
		tweenUIScale(uiScale, 1)
	end)

	connectButton(button, button.MouseButton1Down, function()
		tweenUIScale(uiScale, 1)
	end)

	connectButton(button, button.MouseButton1Up, function()
		tweenUIScale(uiScale, mouseEnterScaleSizes[button])
	end)

	connectButton(button, button.SelectionGained, function()
		tweenUIScale(uiScale, mouseEnterScaleSizes[button])
	end)

	connectButton(button, button.SelectionLost, function()
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

local function setUpSizeButton(button: GuiButton)
	if not originalSizes[button] then
		originalSizes[button] = button.Size
	end

	local mainSize = originalSizes[button]

	connectButton(button, button.MouseEnter, function()
		onMouseEnter(button, mainSize)
	end)

	connectButton(button, button.MouseLeave, function()
		onMouseLeave(button, mainSize)
	end)

	connectButton(button, button.MouseButton1Down, function()
		onMouseClick(button, mainSize)
	end)

	connectButton(button, button.MouseButton1Up, function()
		onMouseLeave(button, mainSize)
	end)

	connectButton(button, button.SelectionGained, function()
		onMouseEnter(button, mainSize)
	end)

	connectButton(button, button.SelectionLost, function()
		onMouseLeave(button, mainSize)
	end)
end

function module.SetUp(button: GuiButton, mouseEnterScaleSize: number?, useUIScale: boolean?)
	-- TopbarPlus owns this hit area and updates its size after parenting it.
	-- Capturing its temporary zero size makes every later hover disable the icon.
	if button:GetAttribute("CorrespondingIconUID") ~= nil then
		return
	end
	if buttonConnections[button] then
		if not useUIScale or not originalSizes[button] then
			if mouseEnterScaleSize ~= nil then
				mouseEnterScaleSizes[button] = mouseEnterScaleSize
			end
			return
		end
		mouseEnterScaleSize = mouseEnterScaleSize or mouseEnterScaleSizes[button]
		disconnectButton(button)
	end
	buttonConnections[button] = {}

	mouseEnterScaleSizes[button] = mouseEnterScaleSize or MOUSE_ENTER_SIZE
	connectButton(button, button.Destroying, function()
		disconnectButton(button)
	end)
	connectButton(button, button.Activated, playClickSound)

	local uiScale = if useUIScale then button:FindFirstChildOfClass("UIScale") else button:FindFirstChild("UIScale")
	if useUIScale and not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = button
	end
	if uiScale and uiScale:IsA("UIScale") then
		setUpUIScaleButton(button, uiScale)
		return
	end

	setUpSizeButton(button)
end

local function trySetUpButton(button: Instance)
	if button:IsA("GuiButton") then
		module.SetUp(button)
	end
end

local function trySetUpScaleButton(guiElement: Instance)
	-- 保留原有自动注册范围；Offset 按钮由标签或显式 SetUp 接管。
	if guiElement:IsA("GuiButton") and guiElement.Size.X.Offset == 0 and guiElement.Size.Y.Offset == 0 then
		module.SetUp(guiElement)
	end
end

function module.Start()
	if started then
		return
	end
	started = true

	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	-- 先监听后扫描，覆盖初次复制、动态克隆以及重生后重建的 GUI。
	playerGui.DescendantAdded:Connect(trySetUpScaleButton)
	CollectionService:GetInstanceAddedSignal("Button"):Connect(trySetUpButton)

	for _, guiElement in playerGui:GetDescendants() do
		trySetUpScaleButton(guiElement)
	end
	for _, button in CollectionService:GetTagged("Button") do
		trySetUpButton(button)
	end
end

return module
