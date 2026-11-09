local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RarityConfig = require(script.Parent.RarityConfig)

local GuiUtil = {}

local currentGuis = {}
local isHideMode = false

function GuiUtil.HideGui(playerGui: PlayerGui, guiBacklist: {string})
    currentGuis = {}
    isHideMode = true

    for _, gui in playerGui:GetChildren() do
        if not gui:IsA("ScreenGui") or table.find(guiBacklist, gui.Name) then continue end
        if gui.Enabled then
            table.insert(currentGuis, gui)
            gui.Enabled = false
        end
    end
end

function GuiUtil.RestoreGui()
    isHideMode = false
    for _, gui in ipairs(currentGuis) do
        gui.Enabled = true
    end
    currentGuis = {}
end

function GuiUtil.RestoreGuiBesides(besides: {ScreenGui})
	isHideMode = false
	for _, gui in ipairs(currentGuis) do
		if table.find(besides, gui) then continue end
		gui.Enabled = true
	end
	currentGuis = {}
end

function GuiUtil.GenerateViewport(viewportFrame: ViewportFrame, model: Model, cameraPos: Vector3?, orientation: CFrame?)
    GuiUtil.CleanAnimViewport(viewportFrame)
	
	orientation = orientation or CFrame.Angles( 0, 0, 0)
    cameraPos = cameraPos or Vector3.new(0, 1, -3)
	local camera = viewportFrame:FindFirstChildOfClass("Camera")
	if not camera then
		camera = Instance.new("Camera")
		camera.FieldOfView = 70
		camera.Parent = viewportFrame

		viewportFrame.CurrentCamera = camera
	end

	model.Parent = viewportFrame

	if model.PrimaryPart then
		camera.CFrame = CFrame.new(model.PrimaryPart.Position + cameraPos) * orientation
	elseif model:FindFirstChild("HumanoidRootPart") then
		camera.CFrame = CFrame.new(model.HumanoidRootPart.Position + cameraPos) * orientation
	else
		warn("Viewport model has no primary part or humanoid root partt：", model.Name)
	end
end

function GuiUtil.CleanViewport(viewportFrame: ViewportFrame)
	local model = viewportFrame:FindFirstChildOfClass("Model")
	if model then
		model:Destroy()
	end
end

function GuiUtil.GenerateAnimViewport(viewportFrame: ViewportFrame, model: Model, cameraPos: Vector3?, orientation: CFrame?, fov: number?)
	GuiUtil.CleanAnimViewport(viewportFrame)

    orientation = orientation or CFrame.Angles( 0, 0, 0)
    fov = fov or 70
    cameraPos = cameraPos or Vector3.new(0, 1, -3)
	local camera = viewportFrame:FindFirstChildOfClass("Camera")
	if not camera then
		camera = Instance.new("Camera")
		camera.Parent = viewportFrame

		viewportFrame.CurrentCamera = camera
	end
	camera.FieldOfView = fov

    local worldModel = Instance.new("WorldModel", viewportFrame)
	model.Parent = worldModel
	-- camera.CFrame = CFrame.new(model.PrimaryPart.Position + cameraPos) * orientation
	if model.PrimaryPart then
		camera.CFrame = CFrame.new(model.PrimaryPart.Position + cameraPos) * orientation
	elseif model:FindFirstChild("HumanoidRootPart") then
		camera.CFrame = CFrame.new(model.HumanoidRootPart.Position + cameraPos) * orientation
	else
		warn("Viewport model has no primary part or humanoid root part：", model.Name)
	end
end

function GuiUtil.CleanAnimViewport(viewportFrame: ViewportFrame)
	local model = viewportFrame:FindFirstChildOfClass("Model")
	if model then
		model:Destroy()
	end

    local worldModel = viewportFrame:FindFirstChildOfClass("WorldModel")
	if worldModel then
		worldModel:Destroy()
	end
end

function GuiUtil.SetButtonColor(button: TextButton, color: Color3, strokeColor: Color3?)
	button.BackgroundColor3 = color
	if strokeColor then
		for _, child in pairs(button:GetChildren()) do
			if child:IsA("UIStroke") then
				child.Color = strokeColor
			end
		end
	end
end

-- Adjusting AutomaticCanvasSize properly with UILayouts/UIPadding.
-- https://devforum.roblox.com/t/scrollingframeautomaticcanvassize-not-working-with-uilistlayout-andor-automaticsized-children/1670886/5?u=heixiaogu
local boundScrollingFrames: { [ScrollingFrame]: boolean } = {}
local boundLayouts: { [Instance]: boolean } = {}
local boundPaddings: { [UIPadding]: boolean } = {}

local function getLayout(scrollingFrame: ScrollingFrame): Instance?
	return scrollingFrame:FindFirstChildOfClass("UIListLayout")
		or scrollingFrame:FindFirstChildOfClass("UIGridLayout")
end

local function applyCanvasSize(scrollingFrame: ScrollingFrame)
	if not scrollingFrame.Parent then
		return
	end
	local layout = getLayout(scrollingFrame)
	if not layout then
		return
	end

	local paddingX = 0
	local paddingY = 0
	local uiPadding = scrollingFrame:FindFirstChildOfClass("UIPadding")
	if uiPadding then
		paddingX = uiPadding.PaddingLeft.Offset + uiPadding.PaddingRight.Offset
		paddingY = uiPadding.PaddingTop.Offset + uiPadding.PaddingBottom.Offset
	end

	local content = (layout :: any).AbsoluteContentSize
	local mode = scrollingFrame.AutomaticCanvasSize
	local oldCanvasSize = scrollingFrame.CanvasSize
	if mode == Enum.AutomaticSize.X then
		scrollingFrame.CanvasSize = UDim2.new(0, content.X + paddingX, oldCanvasSize.Y.Scale, oldCanvasSize.Y.Offset)
	elseif mode == Enum.AutomaticSize.Y then
		scrollingFrame.CanvasSize = UDim2.new(oldCanvasSize.X.Scale, oldCanvasSize.X.Offset, 0, content.Y + paddingY)
	elseif mode == Enum.AutomaticSize.XY then
		scrollingFrame.CanvasSize = UDim2.new(0, content.X + paddingX, 0, content.Y + paddingY)
	end
end

local function bindLayout(scrollingFrame: ScrollingFrame, layout: Instance)
	if boundLayouts[layout] then
		return
	end
	boundLayouts[layout] = true

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		applyCanvasSize(scrollingFrame)
	end)
end

local function bindPadding(scrollingFrame: ScrollingFrame, uiPadding: UIPadding)
	if boundPaddings[uiPadding] then
		return
	end
	boundPaddings[uiPadding] = true

	for _, propName in ipairs({ "PaddingLeft", "PaddingRight", "PaddingTop", "PaddingBottom" }) do
		uiPadding:GetPropertyChangedSignal(propName):Connect(function()
			applyCanvasSize(scrollingFrame)
		end)
	end
end

local function tryBindChild(scrollingFrame: ScrollingFrame, child: Instance)
	if child:IsA("UIListLayout") or child:IsA("UIGridLayout") then
		bindLayout(scrollingFrame, child)
		applyCanvasSize(scrollingFrame)
	elseif child:IsA("UIPadding") then
		bindPadding(scrollingFrame, child)
		applyCanvasSize(scrollingFrame)
	end
end

local function bindScrollingFrame(scrollingFrame: ScrollingFrame)
	if boundScrollingFrames[scrollingFrame] then
		return
	end
	boundScrollingFrames[scrollingFrame] = true

	scrollingFrame:GetPropertyChangedSignal("AutomaticCanvasSize"):Connect(function()
		applyCanvasSize(scrollingFrame)
	end)

	for _, child in scrollingFrame:GetChildren() do
		tryBindChild(scrollingFrame, child)
	end

	scrollingFrame.ChildAdded:Connect(function(child)
		tryBindChild(scrollingFrame, child)
		applyCanvasSize(scrollingFrame)
	end)

	scrollingFrame.ChildRemoved:Connect(function()
		applyCanvasSize(scrollingFrame)
	end)

	applyCanvasSize(scrollingFrame)
end

function GuiUtil.RichFontColor(text: string, color: Color3): string
	return `<font color="#{color:ToHex()}">{text}</font>`
end

function GuiUtil.AutoResizeScrollingFrame(screenGui: ScreenGui)
	for _, descendant in screenGui:GetDescendants() do
		if descendant:IsA("ScrollingFrame") then
			bindScrollingFrame(descendant)
		end
	end
end

if RunService:IsClient() then
	task.spawn(function()
		local localPlayer = Players.LocalPlayer
		while not localPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			localPlayer = Players.LocalPlayer
		end
		local playerGui = localPlayer:WaitForChild("PlayerGui")

		for _, descendant in playerGui:GetDescendants() do
			if descendant:IsA("ScrollingFrame") then
				bindScrollingFrame(descendant)
			end
		end

		playerGui.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("ScrollingFrame") then
				bindScrollingFrame(descendant)
			end
		end)
	end)
end

function GuiUtil.ClearGradeint(parent: Instance)
    for _, child in parent:GetChildren() do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end
	pcall(function()
		parent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		parent.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

local function getRarityGradientTemplate(rarity: string?, quiet: boolean?): UIGradient?
	if not rarity or rarity == "" then
		return nil
	end

	local guiFolder = ReplicatedStorage:FindFirstChild("Gui")
	local gradientsFolder = guiFolder and guiFolder:FindFirstChild("UIGradient")
	local gradientName = "UIGradient_" .. rarity
	local gradient = gradientsFolder and gradientsFolder:FindFirstChild(gradientName)
	if not gradient or not gradient:IsA("UIGradient") then
		if not quiet then
			warn("Gradient not found:", gradientName)
		end
		return nil
	end

	return gradient
end

local function getColorSequenceColorAt(colorSequence: ColorSequence, time: number): Color3
	local keypoints = colorSequence.Keypoints
	local previousKeypoint = keypoints[1]
	if time <= previousKeypoint.Time then
		return previousKeypoint.Value
	end

	for index = 2, #keypoints do
		local nextKeypoint = keypoints[index]
		if time <= nextKeypoint.Time then
			local span = nextKeypoint.Time - previousKeypoint.Time
			if span <= 0 then
				return nextKeypoint.Value
			end

			local alpha = (time - previousKeypoint.Time) / span
			return previousKeypoint.Value:Lerp(nextKeypoint.Value, alpha)
		end
		previousKeypoint = nextKeypoint
	end

	return previousKeypoint.Value
end

function GuiUtil.GetRarityGradientColor(rarity: string?): Color3?
	local entry = RarityConfig.ByName[RarityConfig.Normalize(rarity)]
	if entry and entry.Name ~= "Exclusive" then
		return entry.Color
	end
	local gradient = getRarityGradientTemplate(rarity, entry ~= nil)
	return if gradient then getColorSequenceColorAt(gradient.Color, 0.5) else entry and entry.Color
end

function GuiUtil.SetRarityGradient(parent: Instance, rarity: string?)
	GuiUtil.ClearGradeint(parent)
	local entry = RarityConfig.ByName[RarityConfig.Normalize(rarity)]
	if not entry or entry.Name == "Exclusive" then
		local template = getRarityGradientTemplate(rarity, entry ~= nil)
		if template then
			local clone = template:Clone()
			clone.Enabled = true
			clone.Parent = parent
			return
		end
	end
	if entry then
		local gradient = Instance.new("UIGradient")
		gradient.Name = "UIGradient_" .. entry.Name
		gradient.Color = entry.Gradient
		gradient.Parent = parent
	end
end

-- Backward-compatible alias for callers that still use the old helper name.
function GuiUtil.SetRarityColor(parent: Instance, rarity: string, _isStroke: boolean?)
	GuiUtil.SetRarityGradient(parent, rarity)
end

return GuiUtil
