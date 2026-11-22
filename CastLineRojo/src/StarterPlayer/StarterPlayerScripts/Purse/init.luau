--!nonstrict
--!nolint DeprecatedApi

-- Backpack Version 5.1
-- OnlyTwentyCharacters, SolarCrane

-- NOTICE (Apache-2.0 section 4b): This file is a modified copy of ryanlua/purse@1.2.1.
-- Changes by AnimalFarm: custom backpack behavior and styling. See LICENSE.md.

local GuiService = game:GetService("GuiService") -- ROBLOX deviation: use GuiService instead of UserGameSettings
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackConfig = require(ReplicatedStorage.Modules.BackpackConfig)
local Appearance = BackpackConfig.Appearance
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local BackpackGui = Instance.new("ScreenGui") -- ROBLOX deviation: use BackpackGui instead of RobloxGui (CoreGui only)
BackpackGui.Name = "BackpackGui"
BackpackGui.ResetOnSpawn = false
BackpackGui.Parent = playerGui

local homeGuiDisplayOrderConnection = nil

local function syncBackpackGuiDisplayOrder()
	if homeGuiDisplayOrderConnection then
		homeGuiDisplayOrderConnection:Disconnect()
		homeGuiDisplayOrderConnection = nil
	end

	local homeGui = playerGui:FindFirstChild("HomeGui")
	if not homeGui or not homeGui:IsA("ScreenGui") then
		return
	end

	BackpackGui.DisplayOrder = homeGui.DisplayOrder + 1
	homeGuiDisplayOrderConnection = homeGui:GetPropertyChangedSignal("DisplayOrder"):Connect(function()
		BackpackGui.DisplayOrder = homeGui.DisplayOrder + 1
	end)
end

syncBackpackGuiDisplayOrder()
playerGui.ChildAdded:Connect(function(child)
	if child.Name == "HomeGui" then
		syncBackpackGuiDisplayOrder()
	end
end)
-- local CorePackages = game:GetService("CorePackages")
-- local Modules = RobloxGui.Modules
-- local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat).App.InExperienceAppChatModal
-- local getFFlagAppChatCoreUIConflictFix = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagAppChatCoreUIConflictFix
-- local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled

local BackpackScript = {}
BackpackScript.OpenClose = nil -- Function to toggle open/close
BackpackScript.IsHotbarVisible = false
BackpackScript.IsOpen = false

-- ROBLOX deviation START: parent to script for script capabilities
local stateChangedBindableEvent = Instance.new("BindableEvent")
stateChangedBindableEvent.Parent = script
BackpackScript.StateChanged = stateChangedBindableEvent -- Fires after any open/close, passes IsNowOpen
-- ROBLOX deviation END

BackpackScript.ModuleName = "Backpack"
BackpackScript.KeepVRTopbarOpen = true
BackpackScript.VRIsExclusive = true
BackpackScript.VRClosesNonExclusive = true

local ICON_SIZE = 56
local FONT_SIZE = 18
local ICON_BUFFER = 5

local BACKGROUND_FADE_DEFAULT = Appearance.PanelTransparency
local backgroundFade = BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
local BACKGROUND_COLOR = Color3.new(31 / 255, 31 / 255, 31 / 255)

local VR_FADE_TIME = 1
local VR_PANEL_RESOLUTION = 64

local SLOT_DRAGGABLE_COLOR = Color3.new(49 / 255, 49 / 255, 49 / 255)
local SLOT_EQUIP_COLOR = Color3.new(90 / 255, 142 / 255, 233 / 255)
local SLOT_EQUIP_THICKNESS = 0.1 -- Relative
local slotFadeDefault = Appearance.SlotTransparency * GuiService.PreferredTransparency
local SLOT_BORDER_COLOR = Color3.new(1, 1, 1) -- Appears when dragging

local TOOLTIP_BUFFER = 6
local TOOLTIP_HEIGHT = 16
local TOOLTIP_OFFSET = -25 -- From top

local ARROW_IMAGE_OPEN = "rbxasset://textures/ui/Backpack_Open.png"
local ARROW_IMAGE_CLOSE = "rbxasset://textures/ui/Backpack_Close.png"
local ARROW_SIZE = UDim2.fromOffset(14, 9)
local ARROW_HOTKEY = Enum.KeyCode.Backquote.Value --TODO: Hookup '~' too?
local ARROW_HOTKEY_STRING = "`"
local ARROW_HOVER_COLOR = Color3.new(0, 162 / 255, 1)

local HOTBAR_SLOTS_FULL = 10 -- Logical/persisted slots on every device.
local INVENTORY_HEADER_SIZE = 56

local SEARCH_BUFFER = 5
local SEARCH_WIDTH = 200
local SEARCH_TEXT = "Search"

local SEARCH_TEXT_OFFSET_FROMLEFT = 0
local SEARCH_BACKGROUND_COLOR = Color3.new(0.37, 0.37, 0.37)
local SEARCH_BACKGROUND_FADE_DEFAULT = 0.15
local searchBackgroundFade = SEARCH_BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings

local ZERO_KEY_VALUE = Enum.KeyCode.Zero.Value

local GAMEPAD_INPUT_TYPES = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
}

local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local PlayersService = game:GetService("Players")
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local BackpackLayout = require(ReplicatedStorage.Modules.BackpackLayout)
local BackpackDragController = require(ReplicatedStorage.Modules.BackpackDragController)
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
-- RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local IsTenFootInterface = GuiService:IsTenFootInterface() -- ROBLOX deviation: use GuiService
local function Create(instanceType) -- ROBLOX deviation: use a custom Create function
	return function(data)
		local obj = Instance.new(instanceType)
		local parent = nil
		for k, v in pairs(data) do
			if type(k) == "number" then
				v.Parent = obj
			elseif k == "Parent" then
				parent = v
			else
				obj[k] = v
			end
		end
		if parent then
			obj.Parent = parent
		end
		return obj
	end
end
-- local GameTranslator = require(script.GameTranslator) -- ROBLOX deviation: remove GameTranslator

pcall(function()
	local LocalizationService = game:GetService("LocalizationService")
	local CorescriptLocalization = LocalizationService:GetCorescriptLocalizations()[1]
	SEARCH_TEXT = CorescriptLocalization:GetString(LocalizationService.RobloxLocaleId, "BACKPACK_SEARCH")
end)

local TopbarEnabled = true

if IsTenFootInterface then
	ICON_SIZE = 100
	FONT_SIZE = 24
end

local GamepadActionsBound = false

local function computeLayout()
	local size = BackpackGui.AbsoluteSize
	return BackpackLayout.Compute(size.X, size.Y, UserInputService.TouchEnabled and not UserInputService.MouseEnabled)
end

local Layout = computeLayout()
local VisibleHotbarSlots = Layout.VisibleSlots
ICON_SIZE, ICON_BUFFER = Layout.IconSize, Layout.Gap
local DragController = nil

local Player = PlayersService.LocalPlayer

local MainFrame = nil
local HotbarFrame = nil
local OpenInventoryButton = nil
local CloseInventoryButton = nil
local InventoryFrame = nil
local VRInventorySelector = nil
local ScrollingFrame = nil
local UIGridFrame = nil
local UIGridLayout = nil
local ScrollUpInventoryButton = nil
local ScrollDownInventoryButton = nil

local Character = nil
local Humanoid = nil
local Backpack = nil

local Slots = {} -- List of all Slots by index
local LowestEmptySlot = nil
local SlotsByTool = {} -- Map of Tools to their assigned Slots
local HotkeyFns = {} -- Map of KeyCode values to their assigned behaviors
local Dragging = {} -- Only used to check if anything is being dragged, to disable other input
local FullHotbarSlots = 0 -- Now being used to also determine whether or not LB and RB on the gamepad are enabled.
local StarterToolFound = false -- Special handling is required for the gear currently equipped on the site
local WholeThingEnabled = true -- ROBLOX deviation: always emulate being enabled
local TextBoxFocused = false -- ANY TextBox, not just the search box
local ViewingSearchResults = false -- If the results of a search are currently being viewed
local HotkeyStrings = {} -- Used for eating/releasing hotkeys
local CharConns = {} -- Holds character connections to be cleared later
local GamepadEnabled = false -- determines if our gui needs to be gamepad friendly
local TimeOfLastToolChange = 0

local NumberOfHotbarSlots = HOTBAR_SLOTS_FULL -- Includes reserved mobile slots 8..10.
local BackpackPanel = nil

local lastEquippedSlot = nil

BackpackScript.BackpackEmpty = Create("BindableEvent")({
	Name = "BackpackEmpty",
	Parent = script, -- ROBLOX deviation: parent to script for script capabilities
})

BackpackScript.BackpackItemAdded = Create("BindableEvent")({
	Name = "BackpackAdded",
	Parent = script, -- ROBLOX deviation: parent to script for script capabilities
})

BackpackScript.BackpackItemRemoved = Create("BindableEvent")({
	Name = "BackpackRemoved",
	Parent = script, -- ROBLOX deviation: parent to script for script capabilities
})

local function NewGui(className, objectName)
	local newGui = Instance.new(className)
	newGui.Name = objectName
	newGui.BackgroundColor3 = Color3.new(0, 0, 0)
	newGui.BackgroundTransparency = 1
	newGui.BorderColor3 = Color3.new(0, 0, 0)
	newGui.BorderSizePixel = 0
	newGui.Size = UDim2.fromScale(1, 1)
	if className:match("Text") then
		newGui.TextColor3 = Color3.new(1, 1, 1)
		newGui.Text = ""
		newGui.Font = Enum.Font.FredokaOne
		newGui.TextSize = FONT_SIZE
		newGui.TextWrapped = true
		if className == "TextButton" then
			newGui.Font = Enum.Font.FredokaOne
			newGui.BorderSizePixel = 1
		end
	end
	return newGui
end

local SLOT_TEMPLATE_GUI = "_GuiTemplates"
local SLOT_TEMPLATE_NAME = "BackpackSlot"
local SLOT_TEMPLATE_WAIT_SECONDS = 2
local slotTemplateWarned = false
local slotTemplate = nil
local slotTemplateResolved = false

-- Prefer PlayerGui clone; fall back to StarterGui.
-- MakeSlot runs at require(Mount) time and can race StarterGui→PlayerGui cloning.
local function findSlotTemplateIn(parent)
	if not parent then
		return nil
	end
	local templatesGui = parent:FindFirstChild(SLOT_TEMPLATE_GUI)
	local template = templatesGui and templatesGui:FindFirstChild(SLOT_TEMPLATE_NAME)
	if template and template:IsA("TextButton") then
		return template
	end
	return nil
end

local function getSlotTemplate()
	if slotTemplate and slotTemplate.Parent then
		return slotTemplate
	end

	local template = findSlotTemplateIn(playerGui) or findSlotTemplateIn(StarterGui)

	if not template and not slotTemplateResolved then
		-- One short wait for StarterGui clone into PlayerGui, then StarterGui again.
		playerGui:WaitForChild(SLOT_TEMPLATE_GUI, SLOT_TEMPLATE_WAIT_SECONDS)
		template = findSlotTemplateIn(playerGui) or findSlotTemplateIn(StarterGui)
		slotTemplateResolved = true
	end

	if template then
		slotTemplate = template
		return slotTemplate
	end

	if not slotTemplateWarned then
		slotTemplateWarned = true
		warn(
			"Purse: BackpackSlot template missing (PlayerGui/StarterGui._GuiTemplates.BackpackSlot); using legacy slot UI"
		)
	end
	return nil
end

-- 旧版 Studio 模板尚未同步 StackCountLabel 时，在 Purse 克隆的槽位上补齐同一结构；
-- 新版模板已含该节点，因此这里只会复用而不会重复创建。
local function ensureStackCountLabel(slotFrame)
	local existing = slotFrame:FindFirstChild("StackCountLabel")
	if existing and existing:IsA("TextLabel") then
		return existing
	end
	if existing then
		existing:Destroy()
	end

	local label = Instance.new("TextLabel")
	label.Name = "StackCountLabel"
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(0.55, 0.22)
	label.Position = UDim2.fromScale(0.98, 0.02)
	label.AnchorPoint = Vector2.new(1, 0)
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.4
	label.TextSize = 14
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Right
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.ZIndex = slotFrame.ZIndex + 2
	label.Text = ""
	label.Visible = false

	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MaxTextSize = 14
	textSizeConstraint.Parent = label
	label.Parent = slotFrame
	return label
end

local function resetSlotFrameForRuntime(slotFrame, index)
	slotFrame.Name = index
	slotFrame.LayoutOrder = index
	slotFrame:SetAttribute("MinimalSlotLabels", true)
	for _, label in slotFrame:GetDescendants() do
		if label:IsA("TextLabel") then
			label.Visible = false
		end
	end

	local icon = slotFrame:FindFirstChild("Icon")
	if icon and icon:IsA("ImageLabel") then
		icon.Image = ""
	end

	local toolName = slotFrame:FindFirstChild("ToolName")
	if not toolName then
		toolName = NewGui("TextLabel", "ToolName")
		toolName.Parent = slotFrame
	end
	toolName.Text = ""
	toolName.Visible = false
	local cpsLabel = slotFrame:FindFirstChild("CpsLabel")
	if cpsLabel and cpsLabel:IsA("TextLabel") then
		cpsLabel.Text = ""
	end

	local itemNameLabel = slotFrame:FindFirstChild("ItemNameLabel")
	if itemNameLabel and itemNameLabel:IsA("TextLabel") then
		itemNameLabel.Text = ""
		itemNameLabel.Visible = false
	end

	local itemWeightLabel = slotFrame:FindFirstChild("ItemWeightLabel")
	if itemWeightLabel and itemWeightLabel:IsA("TextLabel") then
		itemWeightLabel.Text = ""
		itemWeightLabel.Visible = false
	end

	local itemLevelLabel = slotFrame:FindFirstChild("ItemLevelLabel")
	if itemLevelLabel and itemLevelLabel:IsA("TextLabel") then
		itemLevelLabel.Text = ""
		itemLevelLabel.Visible = false
	end

	local toolTip = slotFrame:FindFirstChild("ToolTip")
	if toolTip and toolTip:IsA("TextLabel") then
		toolTip.Text = ""
		toolTip.Visible = false
	end

	local numberLabel = slotFrame:FindFirstChild("Number")
	if numberLabel and numberLabel:IsA("TextLabel") then
		numberLabel.Text = ""
		numberLabel.Visible = false
	end

	local stackCountLabel = ensureStackCountLabel(slotFrame)
	stackCountLabel.Text = ""
	stackCountLabel.Visible = false

	local equippedStroke = slotFrame:FindFirstChild("PurseSlotEquippedStroke")
	if equippedStroke and equippedStroke:IsA("UIStroke") then
		equippedStroke.Transparency = 1
	end

	local equipped = slotFrame:FindFirstChild("Equipped")
	if equipped then
		for _, child in ipairs(equipped:GetChildren()) do
			if child:IsA("GuiObject") and child.Name == "Edge" then
				child.BackgroundTransparency = 1
			end
		end
		equipped.Parent = nil
	end
end

local function createEquippedHighlightFrame(slotFrame)
	local highlightFrame = NewGui("Frame", "Equipped")
	highlightFrame.ZIndex = slotFrame.ZIndex
	local t = SLOT_EQUIP_THICKNESS
	local dataTable = {
		{ t, 1, 0, 0 },
		{ 1 - 2 * t, t, t, 0 },
		{ t, 1, 1 - t, 0 },
		{ 1 - 2 * t, t, t, 1 - t },
	}
	for _, data in pairs(dataTable) do
		local edgeFrame = NewGui("Frame", "Edge")
		edgeFrame.BackgroundTransparency = 0
		edgeFrame.BackgroundColor3 = SLOT_EQUIP_COLOR
		edgeFrame.Size = UDim2.fromScale(data[1], data[2])
		edgeFrame.Position = UDim2.fromScale(data[3], data[4])
		edgeFrame.ZIndex = highlightFrame.ZIndex
		edgeFrame.Parent = highlightFrame
	end
	return highlightFrame
end

local function FindLowestEmpty()
	for i = 1, NumberOfHotbarSlots do
		local slot = Slots[i]
		if not slot.Tool then
			return slot
		end
	end
	return nil
end

local function isInventoryEmpty()
	for i = VisibleHotbarSlots + 1, #Slots do
		local slot = Slots[i]
		if slot and slot.Tool then
			return false
		end
	end
	return true
end

BackpackScript.IsInventoryEmpty = isInventoryEmpty

local function UseGazeSelection()
	return false -- disabled in new VR system
end

local function AdjustHotbarFrames()
	local inventoryOpen = InventoryFrame.Visible
	local visualTotal = 0
	for i = 1, VisibleHotbarSlots do
		if inventoryOpen or Slots[i].Tool then
			visualTotal = visualTotal + 1
		end
	end
	local visualIndex = 0
	for i = 1, NumberOfHotbarSlots do
		local slot = Slots[i]
		if i <= VisibleHotbarSlots then
			slot.Frame.Parent = HotbarFrame
			slot.Frame.Visible = slot.Tool ~= nil or inventoryOpen
			if slot.Frame.Visible then
				visualIndex = visualIndex + 1
				slot:Readjust(visualIndex, visualTotal)
			end
		else
			-- Move the presentation only. ToolReference and the saved index stay intact.
			slot.Frame.Parent = UIGridFrame
			slot.Frame.LayoutOrder = i
			slot.Frame.Visible = slot.Tool ~= nil
		end
		slot:TurnNumber(i <= VisibleHotbarSlots and UserInputService.KeyboardEnabled and not Layout.TouchOnly)
	end
	OpenInventoryButton.Visible = false
	BackpackScript.IsHotbarVisible = true
end

local function UpdateScrollingFrameCanvasSize()
	if not UIGridFrame then
		return
	end
	local visible = 0
	for _, child in ipairs(UIGridFrame:GetChildren()) do
		if child:IsA("GuiObject") and child.Visible then
			visible = visible + 1
		end
	end
	local height = BackpackLayout.CanvasHeight(visible, Layout)
	UIGridFrame.Size = UDim2.fromOffset(Layout.GridWidth, height)
	ScrollingFrame.CanvasSize = UDim2.fromOffset(0, height)
end

local function AdjustInventoryFrames()
	for i = NumberOfHotbarSlots + 1, #Slots do
		local slot = Slots[i]
		slot.Frame.LayoutOrder = slot.Index
		if not ViewingSearchResults then
			slot.Frame.Visible = slot.Tool ~= nil
		end
	end
	UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout()
	for _, slot in ipairs(Slots) do
		slot.Frame.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
	end
	UIGridLayout.CellSize = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
	UIGridLayout.CellPadding = UDim2.fromOffset(ICON_BUFFER, ICON_BUFFER)
	UIGridLayout.FillDirectionMaxCells = Layout.GridColumns
	UIGridFrame.Position = UDim2.fromOffset(Layout.GridOffsetX, 0)
	HotbarFrame.Size = UDim2.fromOffset(Layout.HotbarWidth, Layout.HotbarHeight)
	HotbarFrame.Position = UDim2.new(0.5, -Layout.HotbarWidth / 2, 0, Layout.HotbarY)
	InventoryFrame.Size = UDim2.fromOffset(Layout.PanelWidth, Layout.PanelHeight)
	InventoryFrame.Position = UDim2.new(0.5, -Layout.PanelWidth / 2, 0, Layout.PanelY)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -INVENTORY_HEADER_SIZE - 8)
	ScrollingFrame.Position = UDim2.fromOffset(0, INVENTORY_HEADER_SIZE)
	AdjustHotbarFrames()
	AdjustInventoryFrames()
end

local function Clamp(low, high, num)
	return math.min(high, math.max(low, num))
end

local function CheckBounds(guiObject, x, y)
	local pos = guiObject.AbsolutePosition
	local size = guiObject.AbsoluteSize
	return (x > pos.X and x <= pos.X + size.X and y > pos.Y and y <= pos.Y + size.Y)
end

local function UnequipAllTools()
	if Humanoid then
		Humanoid:UnequipTools()
	end
end

local function EquipNewTool(tool)
	if GameplayInputGate.IsActive("Training") then
		return
	end
	UnequipAllTools()
	--Humanoid:EquipTool(tool) --NOTE: This would also unequip current Tool
	tool.Parent = Character --TODO: Switch back to above line after EquipTool is fixed!
end

local function IsEquipped(tool)
	return tool and tool.Parent == Character
end

local function MakeSlot(parent, index)
	index = index or (#Slots + 1)

	-- Slot Definition --

	local slot = {}
	slot.Tool = nil
	slot.Index = index
	slot.Frame = nil

	local SlotFrame = nil
	local ToolIcon = nil
	local ToolName = nil
	local ToolChangeConn = nil
	local ToolReference = nil
	local HighlightFrame = nil
	local SelectionObj = nil

	--NOTE: The following are only defined for Hotbar Slots
	local ToolTip = nil
	local SlotNumber = nil

	-- Slot Functions --

	local function UpdateSlotFading()
		SlotFrame.SelectionImageObject = nil
		local equipped = HighlightFrame and HighlightFrame.Parent == SlotFrame
		local transparency = equipped and Appearance.EquippedSlotTransparency or Appearance.SlotTransparency
		SlotFrame.BackgroundTransparency = transparency * GuiService.PreferredTransparency
		SlotFrame.BackgroundColor3 = SlotFrame:GetAttribute("CanDrag") and SLOT_DRAGGABLE_COLOR or BACKGROUND_COLOR
	end
	slot.UpdateFading = UpdateSlotFading

	function slot:Readjust(visualIndex, visualTotal) --NOTE: Only used for Hotbar slots
		local centered = HotbarFrame.Size.X.Offset / 2
		local sizePlus = ICON_BUFFER + ICON_SIZE
		local midpointish = (visualTotal / 2) + 0.5
		local factor = visualIndex - midpointish
		SlotFrame.Position = UDim2.fromOffset(centered - (ICON_SIZE / 2) + (sizePlus * factor), ICON_BUFFER)
	end

	function slot:Fill(tool)
		if not tool then
			return self:Clear()
		end

		self.Tool = tool
		ToolReference.Value = tool

		local function assignToolData()
			local icon = tool.TextureId
			ToolIcon.Image = icon

			ToolName.Visible = false

			ToolName.Text = tool.Name -- ROBLOX deviation: remove GameTranslator

			if ToolTip and tool:IsA("Tool") then --NOTE: HopperBin
				ToolTip.Text = tool.ToolTip -- ROBLOX deviation: remove GameTranslator
				local width = ToolTip.TextBounds.X + TOOLTIP_BUFFER
				ToolTip.Size = UDim2.fromOffset(width, TOOLTIP_HEIGHT)
				ToolTip.Position = UDim2.new(0.5, -width / 2, 0, TOOLTIP_OFFSET)
			end
		end
		assignToolData()

		if ToolChangeConn then
			ToolChangeConn:disconnect()
			ToolChangeConn = nil
		end

		ToolChangeConn = tool.Changed:connect(function(property)
			if property == "TextureId" or property == "Name" or property == "ToolTip" then
				assignToolData()
			end
		end)

		local hotbarSlot = (self.Index <= NumberOfHotbarSlots)
		local inventoryOpen = InventoryFrame.Visible

		if not hotbarSlot or inventoryOpen then
			SlotFrame:SetAttribute("CanDrag", true)
		end

		self:UpdateEquipView()

		if hotbarSlot then
			FullHotbarSlots = FullHotbarSlots + 1
			-- If using a controller, determine whether or not we can enable BindCoreAction("RBXHotbarEquip", etc)
			if WholeThingEnabled then
				if FullHotbarSlots >= 1 and not GamepadActionsBound then
					-- Player added first item to a hotbar slot, enable BindCoreAction
					GamepadActionsBound = true
					-- ROBLOX deviation START: change action name from RBX to Backpack
					ContextActionService:BindAction(
						"BackpackHotbarEquip",
						changeToolFunc,
						false,
						Enum.KeyCode.ButtonL1,
						Enum.KeyCode.ButtonR1
					)
					-- ROBLOX deviation END
				end
			end
		end

		SlotsByTool[tool] = self
		LowestEmptySlot = FindLowestEmpty()
	end

	function slot:Clear()
		if DragController then
			DragController:CancelSlot(self)
		end
		if not self.Tool then
			return
		end

		if ToolChangeConn then
			ToolChangeConn:disconnect()
			ToolChangeConn = nil
		end

		ToolIcon.Image = ""
		ToolName.Text = ""
		if ToolTip then
			ToolTip.Text = ""
			ToolTip.Visible = false
		end
		SlotFrame:SetAttribute("CanDrag", false)

		self:UpdateEquipView(true) -- Show as unequipped

		if self.Index <= NumberOfHotbarSlots then
			FullHotbarSlots = FullHotbarSlots - 1
			if FullHotbarSlots < 1 then
				GamepadActionsBound = false
				ContextActionService:UnbindAction("BackpackHotbarEquip") -- ROBLOX deviation: change action name from RBX to Backpack
			end
		end

		SlotsByTool[self.Tool] = nil
		ToolReference.Value = nil
		self.Tool = nil
		LowestEmptySlot = FindLowestEmpty()
	end

	function slot:UpdateEquipView(unequippedOverride)
		if not unequippedOverride and IsEquipped(self.Tool) then -- Equipped
			lastEquippedSlot = slot
			if not HighlightFrame then
				HighlightFrame = createEquippedHighlightFrame(SlotFrame)
			end
			if HighlightFrame then
				HighlightFrame.ZIndex = SlotFrame.ZIndex
				for _, child in pairs(HighlightFrame:GetChildren()) do
					if child.Name == "Edge" and child:IsA("Frame") then
						child.BackgroundTransparency = 0
						child.BackgroundColor3 = SLOT_EQUIP_COLOR
						child.ZIndex = HighlightFrame.ZIndex
					end
				end
				HighlightFrame.Parent = SlotFrame
			end
		else -- In the Backpack
			if HighlightFrame then
				HighlightFrame.Parent = nil
			end
		end
		UpdateSlotFading()
	end

	function slot:IsEquipped()
		return IsEquipped(self.Tool)
	end

	function slot:Delete()
		Dragging[SlotFrame] = nil
		SlotFrame:Destroy() --NOTE: Also clears connections
		table.remove(Slots, self.Index)
		local newSize = #Slots

		-- Now adjust the rest (both visually and representationally)
		for i = self.Index, newSize do
			Slots[i]:SlideBack()
		end

		UpdateScrollingFrameCanvasSize()
	end

	function slot:Swap(targetSlot) --NOTE: This slot (self) must not be empty!
		local myTool, otherTool = self.Tool, targetSlot.Tool
		self:Clear()
		if otherTool then -- (Target slot might be empty)
			targetSlot:Clear()
			self:Fill(otherTool)
		end
		if myTool then
			targetSlot:Fill(myTool)
		else
			targetSlot:Clear()
		end
	end

	function slot:SlideBack() -- For inventory slot shifting
		self.Index = self.Index - 1
		SlotFrame.Name = self.Index
		SlotFrame.LayoutOrder = self.Index
	end

	function slot:TurnNumber(on)
		if SlotNumber then
			SlotNumber.Visible = on
		end
	end

	function slot:SetClickability(on) -- (Happens on open/close arrow)
		if self.Tool then
			SlotFrame:SetAttribute("CanDrag", not on)
			UpdateSlotFading()
		end
	end

	function slot:CheckTerms(terms)
		local hits = 0
		local function checkEm(str, term)
			local _, n = str:lower():gsub(term, "")
			hits = hits + n
		end
		local tool = self.Tool
		if tool then
			for term in pairs(terms) do
				checkEm(ToolName.Text, term)
				if tool:IsA("Tool") then --NOTE: HopperBin
					local toolTipText = ToolTip and ToolTip.Text or ""
					checkEm(toolTipText, term)
				end
			end
		end
		return hits
	end

	-- Slot select logic, activated by clicking or pressing hotkey
	function slot:Select(isProcessed)
		if isProcessed or GameplayInputGate.IsActive("Training") then
			return
		end
		local tool = slot.Tool
		if tool then
			if IsEquipped(tool) then --NOTE: HopperBin
				UnequipAllTools()
			elseif tool.Parent == Backpack then
				EquipNewTool(tool)
			end
		end
	end

	-- Slot Init Logic --

	local slotTemplateSource = getSlotTemplate()
	local usingSlotTemplate = slotTemplateSource ~= nil

	if usingSlotTemplate then
		SlotFrame = slotTemplateSource:Clone()
		HighlightFrame = SlotFrame:FindFirstChild("Equipped")
		resetSlotFrameForRuntime(SlotFrame, index)
		SlotFrame.BackgroundColor3 = BACKGROUND_COLOR
		SlotFrame.BorderColor3 = SLOT_BORDER_COLOR
		SlotFrame.Text = ""
		SlotFrame.AutoButtonColor = false
		SlotFrame.BorderSizePixel = 0
		SlotFrame.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
		SlotFrame.Active = true
		SlotFrame:SetAttribute("CanDrag", false)
		SlotFrame.BackgroundTransparency = slotFadeDefault

		ToolIcon = SlotFrame:FindFirstChild("Icon")
		ToolName = SlotFrame:FindFirstChild("ToolName")
		ToolTip = SlotFrame:FindFirstChild("ToolTip")
		SlotNumber = SlotFrame:FindFirstChild("Number")
	else
		SlotFrame = NewGui("TextButton", index)
		SlotFrame.BackgroundColor3 = BACKGROUND_COLOR
		SlotFrame.BorderColor3 = SLOT_BORDER_COLOR
		SlotFrame.Text = ""
		SlotFrame.AutoButtonColor = false
		SlotFrame.BorderSizePixel = 0
		SlotFrame.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
		SlotFrame.Active = true
		SlotFrame:SetAttribute("CanDrag", false)
		SlotFrame.BackgroundTransparency = slotFadeDefault

		do
			local selectionObjectClipper = NewGui("Frame", "SelectionObjectClipper")
			selectionObjectClipper.Visible = false
			selectionObjectClipper.Parent = SlotFrame

			SelectionObj = NewGui("ImageLabel", "Selector")
			SelectionObj.Size = UDim2.fromScale(1, 1)
			SelectionObj.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
			SelectionObj.ScaleType = Enum.ScaleType.Slice
			SelectionObj.SliceCenter = Rect.new(12, 12, 52, 52)
			SelectionObj.Parent = selectionObjectClipper
		end

		ToolIcon = NewGui("ImageLabel", "Icon")
		ToolIcon.Size = UDim2.fromScale(0.8, 0.8)
		ToolIcon.Position = UDim2.fromScale(0.1, 0.1)
		ToolIcon.Parent = SlotFrame

		ToolName = NewGui("TextLabel", "ToolName")
		ToolName.Size = UDim2.new(1, -2, 1, -2)
		ToolName.Position = UDim2.fromOffset(1, 1)
		ToolName.Parent = SlotFrame
	end
	ensureStackCountLabel(SlotFrame)
	ToolReference = SlotFrame:FindFirstChild("ToolReference")
	if ToolReference and not ToolReference:IsA("ObjectValue") then
		ToolReference:Destroy()
		ToolReference = nil
	end
	if not ToolReference then
		ToolReference = Instance.new("ObjectValue")
		ToolReference.Name = "ToolReference"
		ToolReference.Parent = SlotFrame
	end
	ToolReference.Value = nil

	if index <= NumberOfHotbarSlots then
		SlotFrame:SetAttribute("HotbarSlotIndex", index)
	end
	if DragController then
		DragController:Bind(SlotFrame, slot)
	end
	slot.Frame = SlotFrame
	slot.Frame.LayoutOrder = slot.Index

	if index <= NumberOfHotbarSlots then -- Hotbar-Specific Slot Stuff
		if not usingSlotTemplate then
			ToolTip = NewGui("TextLabel", "ToolTip")
			ToolTip.TextWrapped = false
			ToolTip.TextYAlignment = Enum.TextYAlignment.Top
			ToolTip.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
			ToolTip.BackgroundTransparency = 0
			ToolTip.Visible = false
			ToolTip.Parent = SlotFrame
		end

		if ToolTip then
			ToolTip.RichText = true
			SlotFrame.MouseEnter:connect(function()
				if not SlotFrame:GetAttribute("MinimalSlotLabels") and ToolTip.Text ~= "" then
					ToolTip.Visible = true
				end
			end)
			SlotFrame.MouseLeave:connect(function()
				ToolTip.Visible = false
			end)
		end

		function slot:MoveToInventory()
			if slot.Index <= NumberOfHotbarSlots then -- From a Hotbar slot
				local tool = slot.Tool
				self:Clear() --NOTE: Order matters here
				local newSlot = MakeSlot(UIGridFrame)
				newSlot:Fill(tool)
				if IsEquipped(tool) then -- Also unequip it --NOTE: HopperBin
					UnequipAllTools()
				end
				-- Also hide the inventory slot if we're showing results right now
				if ViewingSearchResults then
					newSlot.Frame.Visible = false
					newSlot.Parent = InventoryFrame
				end
			end
		end

		-- Show label and assign hotkeys for 1-9 and 0 (zero is always last slot when > 10 total)
		if index < 10 or index == NumberOfHotbarSlots then -- NOTE: Hardcoded on purpose!
			local slotNum = (index < 10) and index or 0
			if not usingSlotTemplate then
				SlotNumber = NewGui("TextLabel", "Number")
				SlotNumber.Size = UDim2.fromScale(0.15, 0.15)
				SlotNumber.Visible = false
				SlotNumber.Parent = SlotFrame
			end
			if SlotNumber then
				SlotNumber.Text = slotNum
			end

			HotkeyFns[ZERO_KEY_VALUE + slotNum] = function(isProcessed)
				slot:Select(isProcessed)
			end
		elseif usingSlotTemplate and SlotNumber then
			SlotNumber.Visible = false
		end
	end

	-- All ready!
	SlotFrame.Parent = parent
	Slots[index] = slot

	if index > NumberOfHotbarSlots then
		UpdateScrollingFrameCanvasSize()
		-- Scroll to new inventory slot, if we're open and not viewing search results
		if InventoryFrame.Visible and not ViewingSearchResults then
			local offset = ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteSize.Y
			ScrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, offset))
		end
	end

	return slot
end

local function updateResponsiveLayout()
	local nextLayout = computeLayout()
	if DragController then
		DragController:Cancel()
	end
	Layout = nextLayout
	VisibleHotbarSlots = Layout.VisibleSlots
	ICON_SIZE, ICON_BUFFER = Layout.IconSize, Layout.Gap
	BackpackScript.VisibleHotbarSlots = VisibleHotbarSlots
	UpdateBackpackLayout()
end

local function OnChildAdded(child) -- To Character or Backpack
	if child:IsA("HopperBin") then
		warn(`[Purse] Ignoring '{child}' hopper in backpack. HopperBin is deprecated and not supported.`)
		return
	end
	if not child:IsA("Tool") then
		if child:IsA("Humanoid") and child.Parent == Character then
			Humanoid = child
		end
		return
	end
	local tool = child

	if tool.Parent == Character then
		TimeOfLastToolChange = tick()
	end

	--TODO: Optimize / refactor / do something else
	if not StarterToolFound and tool.Parent == Character and not SlotsByTool[tool] then
		local starterGear = Player:FindFirstChild("StarterGear")
		if starterGear then
			if starterGear:FindFirstChild(tool.Name) then
				StarterToolFound = true
				local slot = LowestEmptySlot or MakeSlot(UIGridFrame)
				for i = slot.Index, 1, -1 do
					local curr = Slots[i] -- An empty slot, because above
					local pIndex = i - 1
					if pIndex > 0 then
						local prev = Slots[pIndex] -- Guaranteed to be full, because above
						prev:Swap(curr)
					else
						curr:Fill(tool)
					end
				end
				-- Have to manually unequip a possibly equipped tool
				for _, child in pairs(Character:GetChildren()) do
					if child:IsA("Tool") and child ~= tool then
						child.Parent = Backpack
					end
				end
				AdjustHotbarFrames()
				return -- We're done here
			end
		end
	end

	-- The tool is either moving or new
	local slot = SlotsByTool[tool]
	if slot then
		slot:UpdateEquipView()
	else -- New! Put into lowest hotbar slot or new inventory slot
		slot = LowestEmptySlot or MakeSlot(UIGridFrame)
		slot:Fill(tool)
		if slot.Index <= NumberOfHotbarSlots and not InventoryFrame.Visible then
			AdjustHotbarFrames()
		end
	end

	AdjustHotbarFrames()
	UpdateScrollingFrameCanvasSize()
	BackpackScript.BackpackItemAdded:Fire()
end

local function OnChildRemoved(child) -- From Character or Backpack
	if not child:IsA("Tool") then
		return
	end
	local tool = child

	TimeOfLastToolChange = tick()

	-- Ignore this event if we're just moving between the two
	local newParent = tool.Parent
	if newParent == Character or newParent == Backpack then
		return
	end

	local slot = SlotsByTool[tool]
	if slot then
		slot:Clear()
		if slot.Index > NumberOfHotbarSlots then -- Inventory slot
			slot:Delete()
		elseif not InventoryFrame.Visible then
			AdjustHotbarFrames()
		end
	end

	AdjustHotbarFrames()
	UpdateScrollingFrameCanvasSize()
	BackpackScript.BackpackItemRemoved:Fire()
	if isInventoryEmpty() then
		BackpackScript.BackpackEmpty:Fire()
	end
end

local function OnCharacterAdded(character)
	if BackpackScript.Close then
		BackpackScript.Close()
	end
	-- First, clean up any old slots
	for i = #Slots, 1, -1 do
		local slot = Slots[i]
		if slot.Tool then
			slot:Clear()
		end
		if i > NumberOfHotbarSlots then
			slot:Delete()
		end
	end

	-- And any old connections
	for _, conn in pairs(CharConns) do
		conn:disconnect()
	end
	CharConns = {}

	-- Hook up the new character
	Character = character
	table.insert(CharConns, character.ChildRemoved:connect(OnChildRemoved))
	table.insert(CharConns, character.ChildAdded:connect(OnChildAdded))
	for _, child in pairs(character:GetChildren()) do
		OnChildAdded(child)
	end
	--NOTE: Humanoid is set inside OnChildAdded

	-- And the new backpack, when it gets here
	Backpack = Player:WaitForChild("Backpack")
	table.insert(CharConns, Backpack.ChildRemoved:connect(OnChildRemoved))
	table.insert(CharConns, Backpack.ChildAdded:connect(OnChildAdded))
	for _, child in pairs(Backpack:GetChildren()) do
		OnChildAdded(child)
	end

	AdjustHotbarFrames()
end

local function OnInputBegan(input, isProcessed)
	if GameplayInputGate.IsActive("Fishing") or GameplayInputGate.IsActive("Training") then
		return
	end
	-- Pass through keyboard hotkeys when the backpack is enabled and no TextBox has focus.
	if input.UserInputType == Enum.UserInputType.Keyboard and not TextBoxFocused and WholeThingEnabled then
		local hotkeyBehavior = HotkeyFns[input.KeyCode.Value]
		if hotkeyBehavior then
			hotkeyBehavior(isProcessed)
		end
	end

	local inputType = input.UserInputType
	if not isProcessed then
		if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
			if InventoryFrame.Visible then
				BackpackScript.OpenClose()
			end
		end
	end
end

local function OnUISChanged(property)
	if property == "KeyboardEnabled" or property == "VREnabled" then
		local on = UserInputService.KeyboardEnabled and not VRService.VREnabled
		for i = 1, NumberOfHotbarSlots do
			Slots[i]:TurnNumber(on and i <= VisibleHotbarSlots and not Layout.TouchOnly)
		end
	end
end

local lastChangeToolInputObject = nil
local lastChangeToolInputTime = nil
local maxEquipDeltaTime = 0.06
local noOpFunc = function() end
local selectDirection = Vector2.new(0, 0)
local hotbarVisible = false

function unbindAllGamepadEquipActions()
	-- ROBLOX deviation START: change action name from RBX to Backpack
	ContextActionService:UnbindAction("BackpackHasGamepadFocus")
	ContextActionService:UnbindAction("BackpackCloseInventory")
	-- ROBLOX deviation END
end

local function setHotbarVisibility(visible, isInventoryScreen)
	for i = 1, NumberOfHotbarSlots do
		local hotbarSlot = Slots[i]
		if hotbarSlot and hotbarSlot.Frame and (isInventoryScreen or hotbarSlot.Tool) then
			hotbarSlot.Frame.Visible = visible
		end
	end
end

local function getInputDirection(inputObject)
	local buttonModifier = 1
	if inputObject.UserInputState == Enum.UserInputState.End then
		buttonModifier = -1
	end

	if inputObject.KeyCode == Enum.KeyCode.Thumbstick1 then
		local magnitude = inputObject.Position.magnitude

		if magnitude > 0.98 then
			local normalizedVector =
				Vector2.new(inputObject.Position.x / magnitude, -inputObject.Position.y / magnitude)
			selectDirection = normalizedVector
		else
			selectDirection = Vector2.new(0, 0)
		end
	elseif inputObject.KeyCode == Enum.KeyCode.DPadLeft then
		selectDirection = Vector2.new(selectDirection.x - 1 * buttonModifier, selectDirection.y)
	elseif inputObject.KeyCode == Enum.KeyCode.DPadRight then
		selectDirection = Vector2.new(selectDirection.x + 1 * buttonModifier, selectDirection.y)
	elseif inputObject.KeyCode == Enum.KeyCode.DPadUp then
		selectDirection = Vector2.new(selectDirection.x, selectDirection.y - 1 * buttonModifier)
	elseif inputObject.KeyCode == Enum.KeyCode.DPadDown then
		selectDirection = Vector2.new(selectDirection.x, selectDirection.y + 1 * buttonModifier)
	else
		selectDirection = Vector2.new(0, 0)
	end

	return selectDirection
end

local selectToolExperiment = function(actionName, inputState, inputObject)
	local inputDirection = getInputDirection(inputObject)

	if inputDirection == Vector2.new(0, 0) then
		return
	end

	local angle = math.atan2(inputDirection.y, inputDirection.x) - math.atan2(-1, 0)
	if angle < 0 then
		angle = angle + (math.pi * 2)
	end

	local quarterPi = (math.pi * 0.25)

	local index = (angle / quarterPi) + 1
	index = math.floor(index + 0.5) -- round index to whole number
	if index > NumberOfHotbarSlots then
		index = 1
	end

	if index > 0 then
		local selectedSlot = Slots[index]
		if selectedSlot and selectedSlot.Tool and not selectedSlot:IsEquipped() then
			selectedSlot:Select()
		end
	else
		UnequipAllTools()
	end
end

changeToolFunc = function(actionName, inputState, inputObject)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end

	if lastChangeToolInputObject then
		if
			(
				lastChangeToolInputObject.KeyCode == Enum.KeyCode.ButtonR1
				and inputObject.KeyCode == Enum.KeyCode.ButtonL1
			)
			or (
				lastChangeToolInputObject.KeyCode == Enum.KeyCode.ButtonL1
				and inputObject.KeyCode == Enum.KeyCode.ButtonR1
			)
		then
			if (tick() - lastChangeToolInputTime) <= maxEquipDeltaTime then
				UnequipAllTools()
				lastChangeToolInputObject = inputObject
				lastChangeToolInputTime = tick()
				return
			end
		end
	end

	lastChangeToolInputObject = inputObject
	lastChangeToolInputTime = tick()

	delay(maxEquipDeltaTime, function()
		if lastChangeToolInputObject ~= inputObject then
			return
		end

		local moveDirection = 0
		if inputObject.KeyCode == Enum.KeyCode.ButtonL1 then
			moveDirection = -1
		else
			moveDirection = 1
		end

		for i = 1, NumberOfHotbarSlots do
			local hotbarSlot = Slots[i]
			if hotbarSlot:IsEquipped() then
				local newSlotPosition = moveDirection + i
				local hitEdge = false
				if newSlotPosition > NumberOfHotbarSlots then
					newSlotPosition = 1
					hitEdge = true
				elseif newSlotPosition < 1 then
					newSlotPosition = NumberOfHotbarSlots
					hitEdge = true
				end

				local origNewSlotPos = newSlotPosition
				while not Slots[newSlotPosition].Tool do
					newSlotPosition = newSlotPosition + moveDirection
					if newSlotPosition == origNewSlotPos then
						return
					end

					if newSlotPosition > NumberOfHotbarSlots then
						newSlotPosition = 1
						hitEdge = true
					elseif newSlotPosition < 1 then
						newSlotPosition = NumberOfHotbarSlots
						hitEdge = true
					end
				end

				if hitEdge then
					UnequipAllTools()
					lastEquippedSlot = nil
				else
					Slots[newSlotPosition]:Select()
				end
				return
			end
		end

		if lastEquippedSlot and lastEquippedSlot.Tool then
			lastEquippedSlot:Select()
			return
		end

		local startIndex = moveDirection == -1 and NumberOfHotbarSlots or 1
		local endIndex = moveDirection == -1 and 1 or NumberOfHotbarSlots
		for i = startIndex, endIndex, moveDirection do
			if Slots[i].Tool then
				Slots[i]:Select()
				return
			end
		end
	end)
end

function getGamepadSwapSlot()
	for i = 1, #Slots do
		if Slots[i].Frame.BorderSizePixel > 0 then
			return Slots[i]
		end
	end
end

function changeSlot(slot)
	if GameplayInputGate.IsActive("Training") then
		return
	end
	local gamepadCursorEnabled = GamepadService.GamepadCursorEnabled

	if slot.Frame == GuiService.SelectedObject and not gamepadCursorEnabled then
		local currentlySelectedSlot = getGamepadSwapSlot()

		if currentlySelectedSlot then
			currentlySelectedSlot.Frame.BorderSizePixel = 0
			if currentlySelectedSlot ~= slot then
				slot:Swap(currentlySelectedSlot)
				VRInventorySelector.SelectionImageObject.Visible = false

				if slot.Index > NumberOfHotbarSlots and not slot.Tool then
					if GuiService.SelectedObject == slot.Frame then
						GuiService.SelectedObject = currentlySelectedSlot.Frame
					end
					slot:Delete()
				end

				if currentlySelectedSlot.Index > NumberOfHotbarSlots and not currentlySelectedSlot.Tool then
					if GuiService.SelectedObject == currentlySelectedSlot.Frame then
						GuiService.SelectedObject = slot.Frame
					end
					currentlySelectedSlot:Delete()
				end
			end
		else
			local startSize = slot.Frame.Size
			local startPosition = slot.Frame.Position
			slot.Frame:TweenSizeAndPosition(
				startSize + UDim2.fromOffset(10, 10),
				startPosition - UDim2.fromOffset(5, 5),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true,
				function()
					slot.Frame:TweenSizeAndPosition(
						startSize,
						startPosition,
						Enum.EasingDirection.In,
						Enum.EasingStyle.Quad,
						0.1,
						true
					)
				end
			)
			slot.Frame.BorderSizePixel = 3
			VRInventorySelector.SelectionImageObject.Visible = true
		end
	else
		slot:Select()
		VRInventorySelector.SelectionImageObject.Visible = false
	end
end

function enableGamepadInventoryControl()
	local goBackOneLevel = function(actionName, inputState, inputObject)
		if inputState ~= Enum.UserInputState.Begin then
			return
		end

		local selectedSlot = getGamepadSwapSlot()
		if selectedSlot then
			local selectedSlot = getGamepadSwapSlot()
			if selectedSlot then
				selectedSlot.Frame.BorderSizePixel = 0
				return
			end
		elseif InventoryFrame.Visible then
			BackpackScript.OpenClose()
		end
	end

	-- ROBLOX deviation START: change action name from RBX to Backpack
	ContextActionService:BindAction("BackpackHasGamepadFocus", noOpFunc, false, Enum.UserInputType.Gamepad1)
	ContextActionService:BindAction(
		"BackpackCloseInventory",
		goBackOneLevel,
		false,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.ButtonStart
	)
	-- ROBLOX deviation END

	-- Gaze select will automatically select the object for us!
	if not UseGazeSelection() then
		GuiService.SelectedObject = HotbarFrame:FindFirstChild("1")
	end
end

function disableGamepadInventoryControl()
	unbindAllGamepadEquipActions()

	for i = 1, NumberOfHotbarSlots do
		local hotbarSlot = Slots[i]
		if hotbarSlot and hotbarSlot.Frame then
			hotbarSlot.Frame.BorderSizePixel = 0
		end
	end

	if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(MainFrame) then
		GuiService.SelectedObject = nil
	end
end

local function bindBackpackHotbarAction()
	if WholeThingEnabled and not GamepadActionsBound then
		GamepadActionsBound = true
		-- ROBLOX deviation START: change action name from RBX to Backpack
		ContextActionService:BindAction(
			"BackpackHotbarEquip",
			changeToolFunc,
			false,
			Enum.KeyCode.ButtonL1,
			Enum.KeyCode.ButtonR1
		)
		-- ROBLOX deviation END
	end
end

local function unbindBackpackHotbarAction()
	disableGamepadInventoryControl()
	GamepadActionsBound = false
	ContextActionService:UnbindAction("BackpackHotbarEquip") -- ROBLOX deviation: change action name from RBX to Backpack
end

function gamepadDisconnected()
	if not VRService.VREnabled then
		GamepadEnabled = false
		disableGamepadInventoryControl()
	end
end

function gamepadConnected()
	if not VRService.VREnabled then
		GamepadEnabled = true
		GuiService:AddSelectionParent("BackpackSelection", MainFrame) -- ROBLOX deviation: change action name from RBX to Backpack

		if FullHotbarSlots >= 1 then
			bindBackpackHotbarAction()
		end

		if InventoryFrame.Visible then
			enableGamepadInventoryControl()
		end
	end
end

-- ROBLOX deviation START: disable CoreGui toggling for backpack
-- local function OnCoreGuiChanged(coreGuiType, enabled)
-- 	-- Check for enabling/disabling the whole thing
-- 	if coreGuiType == Enum.CoreGuiType.Backpack or coreGuiType == Enum.CoreGuiType.All then
-- 		enabled = enabled and TopbarEnabled
-- 		WholeThingEnabled = enabled
-- 		if FFlagMountCoreGuiBackpack then
-- 			if enabled then
-- 				MainFrame.Parent = RobloxGui
-- 			else
-- 				MainFrame.Parent = nil
-- 			end
-- 		else
-- 			MainFrame.Visible = enabled
-- 		end

-- 		-- Eat/Release hotkeys (Doesn't affect UserInputService)
-- 		for _, keyString in pairs(HotkeyStrings) do
-- 			if enabled then
-- 				GuiService:AddKey(keyString)
-- 			else
-- 				GuiService:RemoveKey(keyString)
-- 			end
-- 		end

-- 		if enabled then
-- 			if FullHotbarSlots >= 1 then
-- 				bindBackpackHotbarAction()
-- 			end
-- 		else
-- 			unbindBackpackHotbarAction()
-- 		end
-- 	end
-- end
-- ROBLOX deviation END

local function MakeVRRoundButton(name, image)
	local newButton = NewGui("ImageButton", name)
	newButton.Size = UDim2.fromOffset(40, 40)
	newButton.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

	local buttonIcon = NewGui("ImageLabel", "Icon")
	buttonIcon.Size = UDim2.fromScale(0.5, 0.5)
	buttonIcon.Position = UDim2.fromScale(0.25, 0.25)
	buttonIcon.Image = image
	buttonIcon.Parent = newButton

	local buttonSelectionObject = NewGui("ImageLabel", "Selection")
	buttonSelectionObject.Size = UDim2.fromScale(0.9, 0.9)
	buttonSelectionObject.Position = UDim2.fromScale(0.05, 0.05)
	buttonSelectionObject.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
	newButton.SelectionImageObject = buttonSelectionObject

	return newButton, buttonIcon, buttonSelectionObject
end

-- Make the main frame, which (mostly) covers the screen
MainFrame = NewGui("Frame", "Backpack")
-- The custom UI owns its mount independently of Roblox's default backpack.
-- Loading/fishing can disable CoreGui before this module starts.
MainFrame.Parent = BackpackGui

-- Make the HotbarFrame, which holds only the Hotbar Slots
HotbarFrame = NewGui("Frame", "Hotbar")
HotbarFrame.Parent = MainFrame

-- Make all the Hotbar Slots
for i = 1, NumberOfHotbarSlots do
	local slot = MakeSlot(HotbarFrame, i)
	slot.Frame.Visible = false

	if not LowestEmptySlot then
		LowestEmptySlot = slot
	end
end

-- Up arrow to open the inventory
OpenInventoryButton = NewGui("ImageButton", "OpenInventory")
do
	OpenInventoryButton.Size = UDim2.fromOffset(30, 30)
	OpenInventoryButton.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
	OpenInventoryButton.Activated:connect(function()
		BackpackScript.OpenClose()
	end)
	OpenInventoryButton.SelectionGained:connect(function()
		OpenInventoryButton.ImageColor3 = ARROW_HOVER_COLOR
	end)
	OpenInventoryButton.SelectionLost:connect(function()
		OpenInventoryButton.ImageColor3 = Color3.new(1, 1, 1)
	end)
	local openInventoryButtonSelectionObject = NewGui("Frame", "Selection")
	openInventoryButtonSelectionObject.Visible = false
	OpenInventoryButton.SelectionImageObject = openInventoryButtonSelectionObject
end

CloseInventoryButton = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
CloseInventoryButton.Position = UDim2.fromOffset(0, -50)
CloseInventoryButton.Activated:connect(function()
	if InventoryFrame.Visible then
		BackpackScript.OpenClose()
	end
end)

LeftBumperButton = NewGui("ImageLabel", "LeftBumper")
LeftBumperButton.Size = UDim2.fromOffset(40, 40)
LeftBumperButton.Position = UDim2.new(0, -LeftBumperButton.Size.X.Offset, 0.5, -LeftBumperButton.Size.Y.Offset / 2)

RightBumperButton = NewGui("ImageLabel", "RightBumper")
RightBumperButton.Size = UDim2.fromOffset(40, 40)
RightBumperButton.Position = UDim2.new(1, 0, 0.5, -RightBumperButton.Size.Y.Offset / 2)

-- Make the Inventory, which holds the ScrollingFrame, the header, and the search box
InventoryFrame = NewGui("Frame", "Inventory")
InventoryFrame.BackgroundTransparency = backgroundFade
InventoryFrame.BackgroundColor3 = BACKGROUND_COLOR
InventoryFrame.Active = true
InventoryFrame.Visible = false
InventoryFrame.Parent = MainFrame
local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, Appearance.PanelCornerRadius)
inventoryCorner.Parent = InventoryFrame
local inventoryStroke = Instance.new("UIStroke")
inventoryStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
inventoryStroke.Color = Color3.new(0, 0, 0)
inventoryStroke.Thickness = Appearance.PanelStrokeThickness
inventoryStroke.Transparency = Appearance.PanelStrokeTransparency
inventoryStroke.Parent = InventoryFrame

VRInventorySelector = NewGui("TextButton", "VRInventorySelector")
VRInventorySelector.Position = UDim2.new(0, 0, 0, 0)
VRInventorySelector.Size = UDim2.fromScale(1, 1)
VRInventorySelector.BackgroundTransparency = 1
VRInventorySelector.Text = ""
VRInventorySelector.Parent = InventoryFrame

local selectorImage = NewGui("ImageLabel", "Selector")
selectorImage.Size = UDim2.fromScale(1, 1)
selectorImage.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
selectorImage.ScaleType = Enum.ScaleType.Slice
selectorImage.SliceCenter = Rect.new(12, 12, 52, 52)
selectorImage.Visible = false
VRInventorySelector.SelectionImageObject = selectorImage

-- Make the ScrollingFrame, which holds the rest of the Slots (however many)
ScrollingFrame = NewGui("ScrollingFrame", "ScrollingFrame")
ScrollingFrame.Selectable = false
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.Parent = InventoryFrame

UIGridFrame = NewGui("Frame", "UIGridFrame")
UIGridFrame.Selectable = false
UIGridFrame.Size = UDim2.fromOffset(Layout.GridWidth, 0)
UIGridFrame.Position = UDim2.fromOffset(Layout.GridOffsetX, 0)
UIGridFrame.Parent = ScrollingFrame

UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
UIGridLayout.FillDirectionMaxCells = Layout.GridColumns
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIGridLayout.CellSize = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
UIGridLayout.CellPadding = UDim2.fromOffset(ICON_BUFFER, ICON_BUFFER)
UIGridLayout.Parent = UIGridFrame
UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateScrollingFrameCanvasSize)
ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateScrollingFrameCanvasSize)

ScrollUpInventoryButton = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
ScrollUpInventoryButton.Size = UDim2.fromOffset(34, 34)
ScrollUpInventoryButton.Position =
	UDim2.new(0.5, -ScrollUpInventoryButton.Size.X.Offset / 2, 0, INVENTORY_HEADER_SIZE + 3)
ScrollUpInventoryButton.Icon.Position = ScrollUpInventoryButton.Icon.Position - UDim2.fromOffset(0, 2)
ScrollUpInventoryButton.Activated:connect(function()
	ScrollingFrame.CanvasPosition = Vector2.new(
		ScrollingFrame.CanvasPosition.X,
		Clamp(
			0,
			ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y,
			ScrollingFrame.CanvasPosition.Y - (ICON_BUFFER + ICON_SIZE)
		)
	)
end)

ScrollDownInventoryButton = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
ScrollDownInventoryButton.Rotation = 180
ScrollDownInventoryButton.Icon.Position = ScrollDownInventoryButton.Icon.Position - UDim2.fromOffset(0, 2)
ScrollDownInventoryButton.Size = UDim2.fromOffset(34, 34)
ScrollDownInventoryButton.Position =
	UDim2.new(0.5, -ScrollDownInventoryButton.Size.X.Offset / 2, 1, -ScrollDownInventoryButton.Size.Y.Offset - 3)
ScrollDownInventoryButton.Activated:connect(function()
	ScrollingFrame.CanvasPosition = Vector2.new(
		ScrollingFrame.CanvasPosition.X,
		Clamp(
			0,
			ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y,
			ScrollingFrame.CanvasPosition.Y + (ICON_BUFFER + ICON_SIZE)
		)
	)
end)

ScrollingFrame.Changed:connect(function(prop)
	if prop == "AbsoluteWindowSize" or prop == "CanvasPosition" or prop == "CanvasSize" then
		local canScrollUp = ScrollingFrame.CanvasPosition.Y ~= 0
		local canScrollDown = ScrollingFrame.CanvasPosition.Y
			< ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteWindowSize.Y

		ScrollUpInventoryButton.Visible = canScrollUp
		ScrollDownInventoryButton.Visible = canScrollDown
	end
end)

-- Position the frames and sizes for the Backpack GUI elements
UpdateBackpackLayout()

--Make the gamepad hint frame
local gamepadHintsFrame = Create("Frame")({
	Name = "GamepadHintsFrame",
	Size = UDim2.fromOffset(HotbarFrame.Size.X.Offset, (IsTenFootInterface and 95 or 60)),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = MainFrame,
})

local function addGamepadHint(hintImage, hintImageLarge, hintText)
	local hintFrame = Create("Frame")({
		Name = "HintFrame",
		Size = UDim2.new(1, 0, 1, -5),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Parent = gamepadHintsFrame,
	})

	local hintImage = Create("ImageLabel")({
		Name = "HintImage",
		Size = (IsTenFootInterface and UDim2.fromOffset(90, 90) or UDim2.fromOffset(60, 60)),
		BackgroundTransparency = 1,
		Image = (IsTenFootInterface and hintImageLarge or hintImage),
		Parent = hintFrame,
	})

	local hintText = Create("TextLabel")({
		Name = "HintText",
		Position = UDim2.fromOffset((IsTenFootInterface and 100 or 70), 0),
		Size = UDim2.new(1, -(IsTenFootInterface and 100 or 70), 1, 0),
		Font = Enum.Font.FredokaOne,
		FontSize = (IsTenFootInterface and Enum.FontSize.Size36 or Enum.FontSize.Size24),
		BackgroundTransparency = 1,
		Text = hintText,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = hintFrame,
	})
	local textSizeConstraint = Instance.new("UITextSizeConstraint", hintText)
	textSizeConstraint.MaxTextSize = hintText.TextSize
end

local function resizeGamepadHintsFrame()
	gamepadHintsFrame.Size =
		UDim2.new(HotbarFrame.Size.X.Scale, HotbarFrame.Size.X.Offset, 0, (IsTenFootInterface and 95 or 60))
	gamepadHintsFrame.Position = UDim2.new(
		HotbarFrame.Position.X.Scale,
		HotbarFrame.Position.X.Offset,
		InventoryFrame.Position.Y.Scale,
		InventoryFrame.Position.Y.Offset - gamepadHintsFrame.Size.Y.Offset
	)

	local spaceTaken = 0

	local gamepadHints = gamepadHintsFrame:GetChildren()
	--First get the total space taken by all the hints
	for i = 1, #gamepadHints do
		gamepadHints[i].Size = UDim2.new(1, 0, 1, -5)
		gamepadHints[i].Position = UDim2.new(0, 0, 0, 0)
		spaceTaken = spaceTaken + (gamepadHints[i].HintText.Position.X.Offset + gamepadHints[i].HintText.TextBounds.X)
	end

	--The space between all the frames should be equal
	local spaceBetweenElements = (gamepadHintsFrame.AbsoluteSize.X - spaceTaken) / (#gamepadHints - 1)
	for i = 1, #gamepadHints do
		gamepadHints[i].Position = (
			i == 1 and UDim2.new(0, 0, 0, 0)
			or UDim2.new(
				0,
				gamepadHints[i - 1].Position.X.Offset + gamepadHints[i - 1].Size.X.Offset + spaceBetweenElements,
				0,
				0
			)
		)
		gamepadHints[i].Size =
			UDim2.new(0, (gamepadHints[i].HintText.Position.X.Offset + gamepadHints[i].HintText.TextBounds.X), 1, -5)
	end
end

addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonX@2x.png",
	"Remove From Hotbar"
)
addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonA@2x.png",
	"Select/Swap"
)
addGamepadHint(
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
	"rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png",
	"Close Backpack"
)

local searchFrame = NewGui("Frame", "Search")
searchFrame.Visible = BackpackConfig.SearchEnabled
if BackpackConfig.SearchEnabled then -- Retained, but no bindings when disabled.
	searchFrame.BackgroundColor3 = SEARCH_BACKGROUND_COLOR
	searchFrame.BackgroundTransparency = searchBackgroundFade
	searchFrame.Size = UDim2.fromOffset(SEARCH_WIDTH - (SEARCH_BUFFER * 2), INVENTORY_HEADER_SIZE - (SEARCH_BUFFER * 2))
	searchFrame.Position = UDim2.new(1, -searchFrame.Size.X.Offset - 60, 0, 12)
	searchFrame.Parent = InventoryFrame

	local searchBox = NewGui("TextBox", "TextBox")
	searchBox.Text = SEARCH_TEXT
	searchBox.ClearTextOnFocus = false
	searchBox.FontSize = Enum.FontSize.Size24
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.Size = searchFrame.Size - UDim2.fromOffset(SEARCH_TEXT_OFFSET_FROMLEFT, 0)
	searchBox.Position = UDim2.fromOffset(SEARCH_TEXT_OFFSET_FROMLEFT, 0)
	searchBox.Parent = searchFrame

	local xButton = NewGui("TextButton", "X")
	xButton.Text = "x"
	xButton.TextColor3 = SLOT_EQUIP_COLOR
	xButton.FontSize = Enum.FontSize.Size24
	xButton.TextYAlignment = Enum.TextYAlignment.Bottom
	xButton.BackgroundColor3 = SEARCH_BACKGROUND_COLOR
	xButton.BackgroundTransparency = 0
	xButton.Size = UDim2.new(
		0,
		searchFrame.Size.Y.Offset - (SEARCH_BUFFER * 2),
		0,
		searchFrame.Size.Y.Offset - (SEARCH_BUFFER * 2)
	)
	xButton.Position = UDim2.new(1, -xButton.Size.X.Offset - (SEARCH_BUFFER * 2), 0.5, -xButton.Size.Y.Offset / 2)
	xButton.ZIndex = 0
	xButton.Visible = false
	xButton.BorderSizePixel = 0
	xButton.Parent = searchFrame

	local function search()
		local terms = {}
		for word in searchBox.Text:gmatch("%S+") do
			terms[word:lower()] = true
		end

		local hitTable = {}
		for i = NumberOfHotbarSlots + 1, #Slots do -- Only search inventory slots
			local slot = Slots[i]
			local hits = slot:CheckTerms(terms)
			table.insert(hitTable, { slot, hits })
			slot.Frame.Visible = false
			slot.Frame.Parent = InventoryFrame
		end

		table.sort(hitTable, function(left, right)
			return left[2] > right[2]
		end)
		ViewingSearchResults = true

		local hitCount = 0
		for i, data in ipairs(hitTable) do
			local slot, hits = data[1], data[2]
			if hits > 0 then
				slot.Frame.Visible = true
				slot.Frame.Parent = UIGridFrame
				slot.Frame.LayoutOrder = NumberOfHotbarSlots + hitCount
				hitCount = hitCount + 1
			end
		end

		ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
		UpdateScrollingFrameCanvasSize()

		xButton.ZIndex = 3
	end

	local function clearResults()
		if xButton.ZIndex > 0 then
			ViewingSearchResults = false
			for i = NumberOfHotbarSlots + 1, #Slots do
				local slot = Slots[i]
				slot.Frame.LayoutOrder = slot.Index
				slot.Frame.Parent = UIGridFrame
				slot.Frame.Visible = true
			end
			xButton.ZIndex = 0
		end
		UpdateScrollingFrameCanvasSize()
	end

	local function reset()
		clearResults()
		searchBox.Text = SEARCH_TEXT
	end

	local function onChanged(property)
		if property == "Text" then
			local text = searchBox.Text
			if text == "" then
				clearResults()
			elseif text ~= SEARCH_TEXT then
				search()
			end
			xButton.Visible = (text ~= "" and text ~= SEARCH_TEXT)
		end
	end

	local function onFocused()
		if searchBox.Text == SEARCH_TEXT then
			searchBox.Text = ""
		end
	end

	local function focusLost(enterPressed)
		if enterPressed then
			--TODO: Could optimize
			search()
		elseif searchBox.Text == "" then
			searchBox.Text = SEARCH_TEXT
		end
	end

	searchBox.Focused:connect(onFocused)
	xButton.Activated:connect(reset)
	searchBox.Changed:connect(onChanged)
	searchBox.FocusLost:connect(focusLost)

	BackpackScript.StateChanged.Event:connect(function(isNowOpen)
		xButton.Modal = isNowOpen -- Allows free mouse movement even in first person
		if not isNowOpen then
			reset()
		end
	end)

	HotkeyFns[Enum.KeyCode.Escape.Value] = function(isProcessed)
		if isProcessed then -- Pressed from within a TextBox
			reset()
		elseif InventoryFrame.Visible then
			BackpackScript.OpenClose()
		end
	end

	local function detectGamepad(lastInputType)
		if lastInputType == Enum.UserInputType.Gamepad1 and not VRService.VREnabled then
			searchFrame.Visible = false
		else
			searchFrame.Visible = true
		end
	end
	UserInputService.LastInputTypeChanged:connect(detectGamepad)
end

do -- Make the Inventory expand/collapse arrow (unless TopBar)
	local removeHotBarSlot = function(name, state, input)
		if state ~= Enum.UserInputState.Begin then
			return
		end
		if not GuiService.SelectedObject then
			return
		end

		for i = 1, NumberOfHotbarSlots do
			if Slots[i].Frame == GuiService.SelectedObject and Slots[i].Tool then
				Slots[i]:MoveToInventory()
				return
			end
		end
	end

	local function setOpen(open)
		if open and (GameplayInputGate.IsActive("Fishing") or GameplayInputGate.IsActive("Training")) then
			return
		end
		if not open and DragController then
			DragController:Cancel()
		end
		if InventoryFrame.Visible == open and BackpackScript.IsOpen == open then
			return
		end
		InventoryFrame.Visible = open
		AdjustHotbarFrames()
		UpdateScrollingFrameCanvasSize()
		HotbarFrame.Active = not open
		for i = 1, NumberOfHotbarSlots do
			Slots[i]:SetClickability(not open)
		end
		if open and GamepadEnabled then
			if GAMEPAD_INPUT_TYPES[UserInputService:GetLastInputType()] then
				resizeGamepadHintsFrame()
				gamepadHintsFrame.Visible = true
			end
			enableGamepadInventoryControl()
		else
			gamepadHintsFrame.Visible = false
			disableGamepadInventoryControl()
		end
		GameplayInputGate.SetActive("Backpack", MainFrame, open)
		if open then
			ContextActionService:BindAction("BackpackRemoveSlot", removeHotBarSlot, false, Enum.KeyCode.ButtonX)
		else
			ContextActionService:UnbindAction("BackpackRemoveSlot")
		end
		BackpackScript.IsOpen = open
		BackpackScript.StateChanged:Fire(open)
	end

	BackpackScript.Open = function()
		setOpen(true)
	end
	BackpackScript.Close = function()
		setOpen(false)
	end
	local function openClose()
		setOpen(not InventoryFrame.Visible)
	end

	-- HotkeyFns[ARROW_HOTKEY] = function()
	-- 	if GuiService.MenuIsOpen then
	-- 		return
	-- 	end

	-- 	openClose()
	-- end
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) -- ROBLOX deviation: disable CoreGui Backpack
	BackpackScript.OpenClose = openClose -- Exposed
end

-- Header and interaction are generated in code; slot styling keeps the authored template.
local title = NewGui("TextLabel", "Title")
title.Text = "Inventory"
title.TextSize = Appearance.TitleTextSize
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(1, -80, 0, 44)
title.Position = UDim2.fromOffset(12, 6)
title.Parent = InventoryFrame
local titleStroke = Instance.new("UIStroke")
titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
titleStroke.Color = Color3.new(0, 0, 0)
titleStroke.Thickness = 2
titleStroke.Parent = title

local function createCloseButton()
	local indexGui = StarterGui:FindFirstChild("IndexGui_New")
	local frame = indexGui and indexGui:FindFirstChild("Frame")
	local template = frame and frame:FindFirstChild("CloseButton")
	local button
	if template and template:IsA("GuiButton") then
		button = template:Clone()
		local baseZ = button.ZIndex
		for _, descendant in ipairs(button:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				descendant.ZIndex = 5 + math.max(0, descendant.ZIndex - baseZ)
			end
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				descendant:SetAttribute("PreserveBackpackFont", true)
			end
		end
	else
		warn("Purse: IndexGui_New close-button template missing; using generated close button")
		button = NewGui("TextButton", "CloseButton")
		button.Text = "X"
		button.TextSize = 24
		button.BackgroundColor3 = Color3.fromRGB(220, 62, 62)
		button.BackgroundTransparency = 0
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0.16, 0)
		corner.Parent = button
	end
	button.Name = "CloseButton"
	button.AnchorPoint = Vector2.new(1, 0)
	button.Position = UDim2.new(1, -6, 0, 6)
	button.Size = UDim2.fromOffset(44, 44)
	button.ZIndex = 5
	button.Visible = true
	local scale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = button
	ButtonAnimation.SetUp(button)
	return button
end

local closeButton = createCloseButton()
closeButton.Modal = BackpackScript.IsOpen
BackpackScript.StateChanged.Event:Connect(function()
	-- Release modal input as soon as the window closes, including queued changes.
	closeButton.Modal = BackpackScript.IsOpen
end)
closeButton.Parent = InventoryFrame
closeButton.Activated:Connect(function()
	BackpackScript.Close()
end)

local dragLayer = NewGui("Frame", "DragLayer")
dragLayer.ZIndex = 40
dragLayer.Parent = BackpackGui

DragController = BackpackDragController.new({
	layer = dragLayer,
	scrolling = ScrollingFrame,
	canInteract = function()
		return BackpackGui.Enabled
			and MainFrame.Visible
			and not GameplayInputGate.IsActive("Fishing")
			and not GameplayInputGate.IsActive("Training")
			and not GuiService.MenuIsOpen
	end,
	canDrag = function()
		return InventoryFrame.Visible
	end,
	click = function(slot)
		changeSlot(slot)
	end,
	started = function(frame)
		Dragging[frame] = true
	end,
	finished = function(frame)
		Dragging[frame] = nil
	end,
	drop = function(source, point)
		if not source.Tool then
			return
		end
		local target
		for i = 1, VisibleHotbarSlots do
			local candidate = Slots[i]
			if candidate.Frame.Visible and CheckBounds(candidate.Frame, point.X, point.Y) then
				target = candidate
				break
			end
		end
		local inInventory = InventoryFrame.Visible and CheckBounds(ScrollingFrame, point.X, point.Y)
		local action = BackpackLayout.DropAction(source.Index, target and target.Index, inInventory, VisibleHotbarSlots)
		if action == "MoveReserved" then
			local tool, displaced = source.Tool, target.Tool
			source:Clear()
			target:Clear()
			if displaced then
				MakeSlot(UIGridFrame):Fill(displaced)
				if IsEquipped(displaced) then
					UnequipAllTools()
				end
			end
			target:Fill(tool)
		elseif action == "Swap" then
			source:Swap(target)
			if source.Index > VisibleHotbarSlots and IsEquipped(source.Tool) then
				UnequipAllTools()
			end
			if source.Index > NumberOfHotbarSlots and not source.Tool then
				source:Delete()
			end
		elseif action == "MoveToInventory" then
			source:MoveToInventory()
		end
		AdjustHotbarFrames()
		AdjustInventoryFrames()
	end,
})
for _, slot in ipairs(Slots) do
	DragController:Bind(slot.Frame, slot)
end
HotkeyFns[Enum.KeyCode.Escape.Value] = function(isProcessed)
	if not isProcessed then
		BackpackScript.Close()
	end
end
BackpackGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if not BackpackGui.Enabled then
		BackpackScript.Close()
	end
end)
MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	if not MainFrame.Visible then
		BackpackScript.Close()
	end
end)

-- Now that we're done building the GUI, we connect to all the major events

-- Wait for the player if LocalPlayer wasn't ready earlier
while not Player do
	wait()
	Player = PlayersService.LocalPlayer
end

-- Listen to current and all future characters of our player
Player.CharacterAdded:connect(OnCharacterAdded)
if Player.Character then
	OnCharacterAdded(Player.Character)
end

do -- Hotkey stuff
	-- Init HotkeyStrings, used for eating hotkeys
	for i = 0, 9 do
		table.insert(HotkeyStrings, tostring(i))
	end
	table.insert(HotkeyStrings, ARROW_HOTKEY_STRING)

	-- Listen to key down
	UserInputService.InputBegan:connect(OnInputBegan)

	-- Listen to ANY TextBox gaining or losing focus, for disabling all hotkeys
	UserInputService.TextBoxFocused:connect(function()
		TextBoxFocused = true
	end)
	UserInputService.TextBoxFocusReleased:connect(function()
		TextBoxFocused = false
	end)

	-- Listen to keyboard status, for showing/hiding hotkey labels
	UserInputService.Changed:connect(OnUISChanged)
	OnUISChanged("KeyboardEnabled")

	-- Listen to gamepad status, for allowing gamepad style selection/equip
	if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
		gamepadConnected()
	end
	UserInputService.GamepadConnected:connect(function(gamepadEnum)
		if gamepadEnum == Enum.UserInputType.Gamepad1 then
			gamepadConnected()
		end
	end)
	UserInputService.GamepadDisconnected:connect(function(gamepadEnum)
		if gamepadEnum == Enum.UserInputType.Gamepad1 then
			gamepadDisconnected()
		end
	end)
end

-- ROBLOX deviation START: disable CoreGui toggling for backpack
-- function BackpackScript:TopbarEnabledChanged(enabled)
-- 	TopbarEnabled = enabled
-- 	-- Update coregui to reflect new topbar status
-- 	OnCoreGuiChanged(Enum.CoreGuiType.Backpack, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
-- end

-- -- Listen to enable/disable signals from the StarterGui
-- StarterGui.CoreGuiChangedSignal:connect(OnCoreGuiChanged)
-- local backpackType, healthType = Enum.CoreGuiType.Backpack, Enum.CoreGuiType.Health
-- OnCoreGuiChanged(backpackType, StarterGui:GetCoreGuiEnabled(backpackType))
-- OnCoreGuiChanged(healthType, StarterGui:GetCoreGuiEnabled(healthType))
-- ROBLOX deviation END

GuiService.MenuOpened:Connect(function()
	-- ROBLOX deviation: remove FFlag isInExperienceUIVREnabled
	if BackpackScript.IsOpen then
		BackpackScript.OpenClose()
	end
end)

-- ROBLOX deviation START: remove FFlag AppChatCoreUIConflictFix
-- if getFFlagAppChatCoreUIConflictFix() then
-- 	InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(visible)
-- 		if visible and BackpackScript.IsOpen then
-- 			BackpackScript.OpenClose()
-- 		end
-- 	end)
-- end
-- ROBLOX deviation END

local function OnPreferredTransparencyChanged()
	local preferredTransparency = GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings

	backgroundFade = BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
	InventoryFrame.BackgroundTransparency = backgroundFade

	slotFadeDefault = Appearance.SlotTransparency * preferredTransparency
	for _, slot in ipairs(Slots) do
		slot:UpdateFading()
	end

	searchBackgroundFade = SEARCH_BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
	if searchFrame then
		searchFrame.BackgroundTransparency = searchBackgroundFade
	end
end
GuiService:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)

local cameraViewportConnection = nil
local function refreshForViewport()
	updateResponsiveLayout()
	if gamepadHintsFrame then
		resizeGamepadHintsFrame()
	end
end

local function bindCameraViewport()
	if cameraViewportConnection then
		cameraViewportConnection:Disconnect()
		cameraViewportConnection = nil
	end
	local camera = workspace.CurrentCamera
	if camera then
		cameraViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshForViewport)
	end
	refreshForViewport()
end

BackpackGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshForViewport)
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(refreshForViewport)
UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(refreshForViewport)
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCameraViewport)
bindCameraViewport()

return BackpackScript
