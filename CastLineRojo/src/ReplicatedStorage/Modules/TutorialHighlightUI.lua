local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LOCAL_PLAYER = Players.LocalPlayer

local DEFAULT_OVERLAY_DISPLAY_ORDER = 1
local MASK_FRAME_TRANSPARENCY = 0.4
local HIGHLIGHT_SIZE_SCALE = 1.15
local CONTAINER_TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local cleanupConnections: { RBXScriptConnection } = {}
local activeTween: Tween? = nil

local function disconnectAll()
	for _, connection in ipairs(cleanupConnections) do
		connection:Disconnect()
	end
	table.clear(cleanupConnections)

	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end
end

local function trackConnection(connection: RBXScriptConnection)
	table.insert(cleanupConnections, connection)
end

local function createMaskFrame(anchorPoint: Vector2, position: UDim2, size: UDim2): Frame
	local frame = Instance.new("Frame")
	frame.Name = "Mask"
	frame.Active = false
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = MASK_FRAME_TRANSPARENCY
	frame.BorderSizePixel = 0
	frame.AnchorPoint = anchorPoint
	frame.Position = position
	frame.Size = size
	frame.ZIndex = 1
	return frame
end

local function configureFullscreenOverlay(screenGui: ScreenGui)
	screenGui.IgnoreGuiInset = true
	screenGui.ClipToDeviceSafeArea = false
	screenGui.ScreenInsets = Enum.ScreenInsets.None
end

local function createClickTarget(): ScreenGui
	local clickTarget = Instance.new("ScreenGui")
	clickTarget.Name = "TutorialHighlightGui"
	clickTarget.ResetOnSpawn = false
	configureFullscreenOverlay(clickTarget)
	clickTarget.DisplayOrder = DEFAULT_OVERLAY_DISPLAY_ORDER
	clickTarget.Enabled = false

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Size = UDim2.fromScale(0.01, 0.01)
	container.Parent = clickTarget

	createMaskFrame(Vector2.new(0.5, 1), UDim2.fromScale(0.5, 0), UDim2.fromOffset(6880, 3000)).Parent = container
	createMaskFrame(Vector2.new(1, 0.5), UDim2.fromScale(0, 0.5), UDim2.new(0, 3000, 1, 0)).Parent = container
	createMaskFrame(Vector2.new(0, 0.5), UDim2.fromScale(1, 0.5), UDim2.new(0, 3000, 1, 0)).Parent = container
	createMaskFrame(Vector2.new(0.5, 0), UDim2.fromScale(0.5, 1), UDim2.fromOffset(6880, 3000)).Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Thickness = 2
	stroke.Parent = container

	clickTarget.Parent = script
	return clickTarget
end

local ClickTarget = createClickTarget()
local Container = ClickTarget:WaitForChild("Container") :: Frame

return function(target: GuiObject?, overlayDisplayOrder: number?)
	disconnectAll()

	if not target then
		ClickTarget.DisplayOrder = DEFAULT_OVERLAY_DISPLAY_ORDER
		ClickTarget.Enabled = false
		ClickTarget.Parent = script
		return
	end

	ClickTarget.DisplayOrder = overlayDisplayOrder or DEFAULT_OVERLAY_DISPLAY_ORDER
	ClickTarget.Parent = LOCAL_PLAYER:WaitForChild("PlayerGui")
	ClickTarget.Enabled = true
	Container.Size = UDim2.fromScale(0.01, 0.01)

	local function updatePosition()
		if not target.Parent then
			return
		end

		local absoluteSize = target.AbsoluteSize
		if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
			return
		end

		local center = target.AbsolutePosition + absoluteSize * 0.5 - ClickTarget.AbsolutePosition
		if activeTween then
			activeTween:Cancel()
		end
		activeTween = TweenService:Create(Container, CONTAINER_TWEEN_INFO, {
			Size = UDim2.fromOffset(absoluteSize.X * HIGHLIGHT_SIZE_SCALE, absoluteSize.Y * HIGHLIGHT_SIZE_SCALE),
			Position = UDim2.fromOffset(center.X, center.Y),
		})
		activeTween:Play()
	end

	updatePosition()
	task.defer(updatePosition)
	trackConnection(target:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePosition))
	trackConnection(target:GetPropertyChangedSignal("AbsoluteSize"):Connect(updatePosition))
	trackConnection(ClickTarget:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePosition))
end
