local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local EggToolUtil = require(ReplicatedStorage.Modules.EggToolUtil)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local LOCAL_PLAYER = Players.LocalPlayer

local CATEGORY_ALL = "All"
local CATEGORY_ITEMS = "Items"
local TAB_ORDER = { CATEGORY_ALL, CATEGORY_ITEMS }

local TAB_BAR_NAME = "AnimalFarmBackpackTabs"
local TAB_BAR_WIDTH = 84
local TAB_HEIGHT = 72
local TAB_PADDING = 6
local MOBILE_TAB_PADDING = 3
local PHONE_WIDTH_CUTOFF = 1024
local TAB_CORNER_RADIUS = UDim.new(0.2, 0)

local function formatAssetId(iconId: unknown): string
	if typeof(iconId) ~= "string" or iconId == "" then
		return ""
	end

	if iconId:match("^%d+$") then
		return "rbxassetid://" .. iconId
	end

	return iconId
end

local potionData = PurchaseDataHelper.GetData("Potion_DoubleWins")
local TAB_ICONS: { [string]: string } = {
	[CATEGORY_ALL] = "rbxasset://textures/ui/TopBar/inventoryOn.png",
	[CATEGORY_ITEMS] = formatAssetId(potionData and potionData.IconId),
}

local BACKGROUND_COLOR = Color3.fromRGB(28, 32, 40)
local BACKGROUND_TRANSPARENCY_SELECTED = 0.05
local BACKGROUND_TRANSPARENCY_UNSELECTED = 0.35
local TEXT_COLOR_SELECTED = Color3.fromRGB(255, 255, 255)
local TEXT_COLOR_UNSELECTED = Color3.fromRGB(200, 205, 215)
local STROKE_COLOR_SELECTED = Color3.fromRGB(90, 142, 233)
local STROKE_COLOR_UNSELECTED = Color3.fromRGB(0, 0, 0)
local STROKE_THICKNESS_SELECTED = 3
local STROKE_THICKNESS_UNSELECTED = 1

local playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")

local selectedCategory = CATEGORY_ALL
local tabButtons: { [string]: TextButton } = {}
local tabBar: Frame? = nil
local inventoryFrame: Frame? = nil
local searchXButton: GuiObject? = nil
local applyScheduled = false
local boundGui: Instance? = nil
local cameraViewportConnection: RBXScriptConnection? = nil

local function getCharacter(): Model?
	return LOCAL_PLAYER.Character
end

local function categoryForTool(tool: Instance): string?
	if PotionToolUtil.IsPotionTool(tool) or ItemToolUtil.IsItemTool(tool) or EggToolUtil.IsEggTool(tool) then
		return CATEGORY_ITEMS
	end
	return nil
end

local function buildNameToCategory(): { [string]: string }
	local map: { [string]: string } = {}

	local function ingest(container: Instance?)
		if not container then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") then
				local category = categoryForTool(child)
				if category then
					map[child.Name] = category
				end
			end
		end
	end

	ingest(LOCAL_PLAYER:FindFirstChildOfClass("Backpack"))
	ingest(getCharacter())

	return map
end

local function isSearchActive(): boolean
	return searchXButton ~= nil and searchXButton.Visible
end

local function isInventorySlotFrame(instance: Instance): boolean
	return instance:IsA("TextButton")
		and tonumber(instance.Name) ~= nil
		and instance:FindFirstChild("Icon") ~= nil
		and instance:FindFirstChild("ToolName") ~= nil
end

local function getInventoryGrid(): Instance?
	if not inventoryFrame then
		return nil
	end
	local scrolling = inventoryFrame:FindFirstChild("ScrollingFrame")
	if not scrolling then
		return nil
	end
	return scrolling:FindFirstChild("UIGridFrame")
end

local function applyFilter()
	local grid = getInventoryGrid()
	if not grid then
		return
	end

	if isSearchActive() then
		return
	end

	local nameToCategory = buildNameToCategory()

	for _, child in ipairs(grid:GetChildren()) do
		if isInventorySlotFrame(child) then
			local slot = child :: TextButton
			local toolNameLabel = slot:FindFirstChild("ToolName")
			local displayName = (toolNameLabel and toolNameLabel:IsA("TextLabel")) and toolNameLabel.Text or ""

			if displayName ~= "" then
				local shouldShow
				if selectedCategory == CATEGORY_ALL then
					shouldShow = true
				else
					shouldShow = nameToCategory[displayName] == selectedCategory
				end

				if slot.Visible ~= shouldShow then
					slot.Visible = shouldShow
				end
			end
		end
	end
end

local function scheduleApply()
	if applyScheduled then
		return
	end
	applyScheduled = true
	task.defer(function()
		applyScheduled = false
		applyFilter()
	end)
end

local function updateTabVisuals()
	for category, button in pairs(tabButtons) do
		local isSelected = category == selectedCategory
		button.BackgroundTransparency = isSelected and BACKGROUND_TRANSPARENCY_SELECTED
			or BACKGROUND_TRANSPARENCY_UNSELECTED

		local label = button:FindFirstChild("TabLabel")
		if label and label:IsA("TextLabel") then
			label.TextColor3 = isSelected and TEXT_COLOR_SELECTED or TEXT_COLOR_UNSELECTED
		end

		local stroke = button:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Color = isSelected and STROKE_COLOR_SELECTED or STROKE_COLOR_UNSELECTED
			stroke.Thickness = isSelected and STROKE_THICKNESS_SELECTED or STROKE_THICKNESS_UNSELECTED
		end
	end
end

local function selectCategory(category: string)
	if selectedCategory == category then
		return
	end
	selectedCategory = category
	updateTabVisuals()
	applyFilter()
end

local function createTabButton(category: string, layoutOrder: number): TextButton
	local button = Instance.new("TextButton")
	button.Name = category
	button.LayoutOrder = layoutOrder
	button.Size = UDim2.new(1, 0, 0, TAB_HEIGHT)
	button.BackgroundColor3 = BACKGROUND_COLOR
	button.BackgroundTransparency = BACKGROUND_TRANSPARENCY_UNSELECTED
	button.AutoButtonColor = false
	button.Text = ""

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 1
	aspect.AspectType = Enum.AspectType.FitWithinMaxSize
	aspect.DominantAxis = Enum.DominantAxis.Width
	aspect.Parent = button

	local corner = Instance.new("UICorner")
	corner.CornerRadius = TAB_CORNER_RADIUS
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Color = STROKE_COLOR_UNSELECTED
	stroke.Thickness = STROKE_THICKNESS_UNSELECTED
	stroke.Parent = button

	local label = Instance.new("TextLabel")
	label.Name = "TabLabel"
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -4, 0.28, 0)
	label.Position = UDim2.new(0, 2, 0.04, 0)
	label.Font = Enum.Font.FredokaOne
	label.Text = category
	label.TextSize = 14
	label.TextColor3 = TEXT_COLOR_UNSELECTED
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = button

	local icon = Instance.new("ImageLabel")
	icon.Name = "TabIcon"
	icon.BackgroundTransparency = 1
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Size = UDim2.fromScale(0.72, 0.72)
	icon.Position = UDim2.fromScale(0.5, 0.62)
	icon.Image = TAB_ICONS[category] or ""
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = button

	button.Activated:Connect(function()
		selectCategory(category)
	end)

	return button
end

local function isPhoneLayout(): boolean
	local camera = workspace.CurrentCamera
	return UserInputService.TouchEnabled and camera ~= nil and camera.ViewportSize.X < PHONE_WIDTH_CUTOFF
end

local function updateTabLayout()
	if not tabBar or not tabBar.Parent or not inventoryFrame then return end
	local layout = tabBar:FindFirstChildOfClass("UIListLayout")
	if not layout then return end
	local side = TAB_BAR_WIDTH
	if isPhoneLayout() then
		local height = inventoryFrame.AbsoluteSize.Y
		if height <= 0 then return end
		side = math.max(1, math.min(TAB_BAR_WIDTH, math.floor((height - MOBILE_TAB_PADDING * (#TAB_ORDER - 1)) / #TAB_ORDER)))
		layout.Padding = UDim.new(0, MOBILE_TAB_PADDING)
	else
		layout.Padding = UDim.new(0, TAB_PADDING)
	end
	tabBar.Size = UDim2.new(0, side, 1, 0)
	for _, button in pairs(tabButtons) do
		button.Size = UDim2.new(1, 0, 0, side)
		local label = button:FindFirstChild("TabLabel")
		if label and label:IsA("TextLabel") then label.TextSize = math.clamp(math.floor(side * 0.20), 8, 14) end
	end
end

local function bindCameraViewport()
	if cameraViewportConnection then
		cameraViewportConnection:Disconnect()
		cameraViewportConnection = nil
	end
	local camera = workspace.CurrentCamera
	if camera then
		cameraViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateTabLayout)
	end
	updateTabLayout()
end

local function ensureTabBar()
	if tabBar and tabBar.Parent then
		return
	end
	if not inventoryFrame then
		return
	end

	local stale = inventoryFrame:FindFirstChild(TAB_BAR_NAME)
	if stale then
		stale:Destroy()
	end

	local bar = Instance.new("Frame")
	bar.Name = TAB_BAR_NAME
	bar.AnchorPoint = Vector2.new(1, 0)
	bar.Position = UDim2.fromOffset(-10, 0)
	bar.Size = UDim2.new(0, TAB_BAR_WIDTH, 1, 0)
	bar.BackgroundTransparency = 1
	bar.Visible = inventoryFrame.Visible
	bar.Parent = inventoryFrame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, TAB_PADDING)
	layout.Parent = bar

	table.clear(tabButtons)
	for index, category in ipairs(TAB_ORDER) do
		local button = createTabButton(category, index)
		button.Parent = bar
		tabButtons[category] = button
	end

	tabBar = bar
	updateTabVisuals()
	updateTabLayout()
end

local function isOwnTabInstance(instance: Instance): boolean
	return tabBar ~= nil and (instance == tabBar or instance:IsDescendantOf(tabBar))
end

local function bindSearch()
	if not inventoryFrame then
		return
	end
	local searchFrame = inventoryFrame:FindFirstChild("Search")
	if not searchFrame then
		return
	end
	local xButton = searchFrame:FindFirstChild("X")
	if not xButton or not xButton:IsA("GuiObject") then
		return
	end

	searchXButton = xButton
	xButton:GetPropertyChangedSignal("Visible"):Connect(scheduleApply)
end

local function bindInventoryVisibility()
	if not inventoryFrame then
		return
	end
	inventoryFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		if tabBar then
			tabBar.Visible = inventoryFrame.Visible
		end
		if inventoryFrame.Visible then
			selectedCategory = CATEGORY_ALL
			updateTabVisuals()
			scheduleApply()
		end
	end)
end

local function bindToolContainers()
	local function bindContainer(container: Instance?)
		if not container then
			return
		end
		container.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				scheduleApply()
			end
		end)
		container.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then
				scheduleApply()
			end
		end)
	end

	bindContainer(LOCAL_PLAYER:FindFirstChildOfClass("Backpack"))
	bindContainer(getCharacter())

	LOCAL_PLAYER.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			bindContainer(child)
			scheduleApply()
		end
	end)
	LOCAL_PLAYER.CharacterAdded:Connect(function(character)
		bindContainer(character)
		scheduleApply()
	end)
end

local function bindBackpackGui(backpackGui: Instance?)
	if not backpackGui or boundGui == backpackGui then
		return
	end
	boundGui = backpackGui

	local mainFrame = backpackGui:WaitForChild("Backpack", 10)
	if not mainFrame then
		return
	end
	local inventory = mainFrame:WaitForChild("Inventory", 10)
	if not inventory or not inventory:IsA("Frame") then
		return
	end
	inventoryFrame = inventory :: Frame

	ensureTabBar()
	inventoryFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTabLayout)
	bindCameraViewport()
	bindInventoryVisibility()
	bindSearch()
	bindToolContainers()

	backpackGui.DescendantAdded:Connect(function(descendant)
		if isOwnTabInstance(descendant) then
			return
		end
		scheduleApply()
	end)
	backpackGui.DescendantRemoving:Connect(function(descendant)
		if isOwnTabInstance(descendant) then
			return
		end
		scheduleApply()
	end)

	scheduleApply()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCameraViewport)

playerGui.ChildAdded:Connect(function(child)
	if child.Name == "BackpackGui" then
		bindBackpackGui(child)
	end
end)

bindBackpackGui(playerGui:FindFirstChild("BackpackGui"))
