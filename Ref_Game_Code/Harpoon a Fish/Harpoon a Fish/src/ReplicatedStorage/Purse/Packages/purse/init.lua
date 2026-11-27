-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=112061170330936

-- ! Source from the asset above; the game may have edited it since.

--[[
--!nonstrict
--!nolint DeprecatedApi

-- Backpack Version 5.1
-- OnlyTwentyCharacters, SolarCrane

local GuiService = game:GetService("GuiService") -- ROBLOX deviation: use GuiService instead of UserGameSettings
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local BackpackGui = Instance.new("ScreenGui") -- ROBLOX deviation: use BackpackGui instead of RobloxGui (CoreGui only)
BackpackGui.Name = "BackpackGui"
BackpackGui.ResetOnSpawn = false
BackpackGui.Parent = playerGui
-- local CorePackages = game:GetService("CorePackages")
-- local Modules = RobloxGui.Modules
-- local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat).App.InExperienceAppChatModal
-- local getFFlagAppChatCoreUIConflictFix = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagAppChatCoreUIConflictFix
local FFlagMountCoreGuiBackpack = true -- ROBLOX deviation: always true for now
-- local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled

local FFlagSAToolEquipLuauFlag = true -- ROBLOX deviation: always true, DefineFastFlag is RobloxScriptSecurity
-- Workspace.AuthorityMode may change at runtime, in which case we want this feature on
local function featureSAToolEquipEnabled()
	if FFlagSAToolEquipLuauFlag then -- ROBLOX deviation: remove SAToolEquipEngineFeature check, GetEngineFeature is LocalUserSecurity
		return script:FindFirstChild("RequestToolEvent", true) ~= nil -- ROBLOX deviation: AuthorityMode is RobloxScriptSecurity, check if ServerAuthority script is enabled instead
	else
		return false
	end
end

-- ROBLOX deviation START: use RemoteEvent instead of Player:RequestTool (RobloxScriptSecurity)
local function RequestTool(tool: Tool?)
	const requestToolRemote = script:FindFirstChild("RequestToolEvent", true)
	if requestToolRemote then
		requestToolRemote:FireServer(tool)
	end
end
-- ROBLOX deviation END

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

local ICON_SIZE = 60
local FONT_SIZE = Enum.FontSize.Size14
local ICON_BUFFER = 5

local BACKGROUND_FADE_DEFAULT = 0.50
local backgroundFade = BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
local BACKGROUND_COLOR = Color3.new(31 / 255, 31 / 255, 31 / 255)

local VR_FADE_TIME = 1
local VR_PANEL_RESOLUTION = 64

local SLOT_DRAGGABLE_COLOR = Color3.new(49 / 255, 49 / 255, 49 / 255)
local SLOT_EQUIP_COLOR = Color3.new(90 / 255, 142 / 255, 233 / 255)
local SLOT_EQUIP_THICKNESS = 0.1 -- Relative
local SLOT_FADE_LOCKED_DEFAULT = 0.50 -- Locked means undraggable
local slotFadeLocked = SLOT_FADE_LOCKED_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
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

local HOTBAR_SLOTS_FULL = 10
local HOTBAR_SLOTS_VR = 6
local HOTBAR_SLOTS_MINI = 3
local HOTBAR_SLOTS_WIDTH_CUTOFF = 1024 -- Anything smaller is MINI
local HOTBAR_OFFSET_FROMBOTTOM = -30 -- Offset to make room for the Health GUI

local INVENTORY_ROWS_FULL = 4
local INVENTORY_ROWS_VR = 3
local INVENTORY_ROWS_MINI = 2
local INVENTORY_HEADER_SIZE = 40
local INVENTORY_ARROWS_BUFFER_VR = 40

local SEARCH_BUFFER = 5
local SEARCH_WIDTH = 200
local SEARCH_TEXT = "Search"

local SEARCH_TEXT_OFFSET_FROMLEFT = 0
local SEARCH_BACKGROUND_COLOR = Color3.new(0.37, 0.37, 0.37)
local SEARCH_BACKGROUND_FADE_DEFAULT = 0.15
local searchBackgroundFade = SEARCH_BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings

local DOUBLE_CLICK_TIME = 0.5

local ZERO_KEY_VALUE = Enum.KeyCode.Zero.Value
local DROP_HOTKEY_VALUE = Enum.KeyCode.Backspace.Value

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
	FONT_SIZE = Enum.FontSize.Size24
end

local GamepadActionsBound = false

local IS_PHONE = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < HOTBAR_SLOTS_WIDTH_CUTOFF -- ROBLOX deviation: use workspace.CurrentCamera.ViewportSize instead of GuiService:GetScreenResolution()

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
local ActiveHopper = nil -- NOTE: HopperBin
local StarterToolFound = false -- Special handling is required for the gear currently equipped on the site
local WholeThingEnabled = true -- ROBLOX deviation: always emulate being enabled
local TextBoxFocused = false -- ANY TextBox, not just the search box
local ViewingSearchResults = false -- If the results of a search are currently being viewed
local HotkeyStrings = {} -- Used for eating/releasing hotkeys
local CharConns = {} -- Holds character connections to be cleared later
local GamepadEnabled = false -- determines if our gui needs to be gamepad friendly
local TimeOfLastToolChange = 0

local NumberOfHotbarSlots = IS_PHONE and HOTBAR_SLOTS_MINI or HOTBAR_SLOTS_FULL -- Number of slots shown at the bottom
local NumberOfInventoryRows = IS_PHONE and INVENTORY_ROWS_MINI or INVENTORY_ROWS_FULL -- How many rows in the popped-up inventory
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
		newGui.Font = Enum.Font.SourceSans
		newGui.FontSize = FONT_SIZE
		newGui.TextWrapped = true
		if className == "TextButton" then
			newGui.Font = Enum.Font.SourceSansBold
			newGui.BorderSizePixel = 1
		end
	end
	return newGui
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
	for i = NumberOfHotbarSlots + 1, #Slots do
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
	local inventoryOpen = InventoryFrame.Visible -- (Show all)
	local visualTotal = inventoryOpen and NumberOfHotbarSlots or FullHotbarSlots
	local visualIndex = 0
	local hotbarIsVisible = (visualTotal >= 1)

	for i = 1, NumberOfHotbarSlots do
		local slot = Slots[i]
		if slot.Tool or inventoryOpen then
			visualIndex = visualIndex + 1
			slot:Readjust(visualIndex, visualTotal)
			slot.Frame.Visible = true
		else
			slot.Frame.Visible = false
		end
	end

	OpenInventoryButton.Visible = not inventoryOpen and (hotbarIsVisible or not isInventoryEmpty())
	OpenInventoryButton.Position = UDim2.new(0.5, -15, 1, hotbarIsVisible and -110 or -50)
	BackpackScript.IsHotbarVisible = hotbarIsVisible
end

local function UpdateScrollingFrameCanvasSize()
	local countX = math.floor(ScrollingFrame.AbsoluteSize.X / (ICON_SIZE + ICON_BUFFER))
	local maxRow = math.ceil((#UIGridFrame:GetChildren() - 1) / countX)
	local canvasSizeY = maxRow * (ICON_SIZE + ICON_BUFFER) + ICON_BUFFER
	ScrollingFrame.CanvasSize = UDim2.fromOffset(0, canvasSizeY)
end

local function AdjustInventoryFrames()
	for i = NumberOfHotbarSlots + 1, #Slots do
		local slot = Slots[i]
		slot.Frame.LayoutOrder = slot.Index
		slot.Frame.Visible = (slot.Tool ~= nil)
	end
	UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout()
	HotbarFrame.Size = UDim2.new(
		0,
		ICON_BUFFER + (NumberOfHotbarSlots * (ICON_SIZE + ICON_BUFFER)),
		0,
		ICON_BUFFER + ICON_SIZE + ICON_BUFFER
	)
	HotbarFrame.Position = UDim2.new(0.5, -HotbarFrame.Size.X.Offset / 2, 1, -HotbarFrame.Size.Y.Offset)
	InventoryFrame.Size = UDim2.new(
		0,
		HotbarFrame.Size.X.Offset,
		0,
		(HotbarFrame.Size.Y.Offset * NumberOfInventoryRows) + INVENTORY_HEADER_SIZE
	)
	InventoryFrame.Position = UDim2.new(
		0.5,
		-InventoryFrame.Size.X.Offset / 2,
		1,
		HotbarFrame.Position.Y.Offset - InventoryFrame.Size.Y.Offset
	)

	ScrollingFrame.Size = UDim2.new(1, ScrollingFrame.ScrollBarThickness + 1, 1, -INVENTORY_HEADER_SIZE)
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

local function GetOffset(guiObject, point)
	local centerPoint = guiObject.AbsolutePosition + (guiObject.AbsoluteSize / 2)
	return (centerPoint - point).magnitude
end

local function DisableActiveHopper() --NOTE: HopperBin
	-- ROBLOX deviation START: remove HopperBin support (RobloxScriptSecurity)
	warn(`[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.`)
	-- ActiveHopper:ToggleSelect()
	-- SlotsByTool[ActiveHopper]:UpdateEquipView()
	-- ActiveHopper = nil
	-- ROBLOX deviation END
end

local function UnequipAllTools() --NOTE: HopperBin
	if Humanoid then
		-- ROBLOX deviation START: notify server on all unequip paths, not just slot select
		if featureSAToolEquipEnabled() then
			RequestTool(nil)
		end
		-- ROBLOX deviation END
		Humanoid:UnequipTools()
		if ActiveHopper then
			DisableActiveHopper()
		end
	end
end

local function EquipNewTool(tool) --NOTE: HopperBin
	UnequipAllTools()
	if tool:IsA("HopperBin") then
		-- ROBLOX deviation START: remove HopperBin support (RobloxScriptSecurity)
		warn(`[Purse] Cannot select '{tool}' hopper. HopperBin is deprecated and not supported.`)
		-- tool:ToggleSelect()
		-- SlotsByTool[tool]:UpdateEquipView()
		-- ActiveHopper = tool
		-- ROBLOX deviation END
	else
		if featureSAToolEquipEnabled() then
			RequestTool(tool) -- ROBLOX deviation: use RemoteEvent instead of Player:RequestTool
		end

		--Humanoid:EquipTool(tool) --NOTE: This would also unequip current Tool
		tool.Parent = Character --TODO: Switch back to above line after EquipTool is fixed!
	end
end

local function IsEquipped(tool)
	return tool and ((tool:IsA("HopperBin") and tool.Active) or tool.Parent == Character) --NOTE: HopperBin
end

local function MakeSlot(parent, index)
	index = index or (#Slots + 1)

	-- Slot Definition --

	local slot = {}
	slot.Tool = nil
	slot.Index = index
	slot.Frame = nil

	local SlotFrameParent = nil
	local SlotFrame = nil
	local FakeSlotFrame = nil
	local ToolIcon = nil
	local ToolName = nil
	local ToolChangeConn = nil
	local HighlightFrame = nil
	local SelectionObj = nil

	--NOTE: The following are only defined for Hotbar Slots
	local ToolTip = nil
	local SlotNumber = nil

	-- Slot Functions --

	local function UpdateSlotFading()
		SlotFrame.SelectionImageObject = nil
		SlotFrame.BackgroundTransparency = SlotFrame.Draggable and 0 or slotFadeLocked
		SlotFrame.BackgroundColor3 = SlotFrame.Draggable and SLOT_DRAGGABLE_COLOR or BACKGROUND_COLOR
	end

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

		local function assignToolData()
			local icon = tool.TextureId
			ToolIcon.Image = icon

			if icon ~= "" then
				ToolName.Visible = false
			else
				ToolName.Visible = true
			end

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
			SlotFrame.Draggable = true
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
		SlotFrame.Draggable = false

		self:UpdateEquipView(true) -- Show as unequipped

		if self.Index <= NumberOfHotbarSlots then
			FullHotbarSlots = FullHotbarSlots - 1
			if FullHotbarSlots < 1 then
				GamepadActionsBound = false
				ContextActionService:UnbindAction("BackpackHotbarEquip") -- ROBLOX deviation: change action name from RBX to Backpack
			end
		end

		SlotsByTool[self.Tool] = nil
		self.Tool = nil
		LowestEmptySlot = FindLowestEmpty()
	end

	function slot:UpdateEquipView(unequippedOverride)
		if not unequippedOverride and IsEquipped(self.Tool) then -- Equipped
			lastEquippedSlot = slot
			if not HighlightFrame then
				HighlightFrame = NewGui("Frame", "Equipped")
				HighlightFrame.ZIndex = SlotFrame.ZIndex
				local t = SLOT_EQUIP_THICKNESS
				local dataTable = { -- Relative sizes and positions
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
					edgeFrame.ZIndex = HighlightFrame.ZIndex
					edgeFrame.Parent = HighlightFrame
				end
			end
			HighlightFrame.Parent = SlotFrame
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
			SlotFrame.Draggable = not on
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
		if isProcessed then
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

	SlotFrame = NewGui("TextButton", index)
	SlotFrame.BackgroundColor3 = BACKGROUND_COLOR
	SlotFrame.BorderColor3 = SLOT_BORDER_COLOR
	SlotFrame.Text = ""
	SlotFrame.AutoButtonColor = false
	SlotFrame.BorderSizePixel = 0
	SlotFrame.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
	SlotFrame.Active = true
	SlotFrame.Draggable = false
	SlotFrame.BackgroundTransparency = slotFadeLocked
	SlotFrame.MouseButton1Click:connect(function()
		changeSlot(slot)
	end)
	slot.Frame = SlotFrame

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

	slot.Frame.LayoutOrder = slot.Index

	if index <= NumberOfHotbarSlots then -- Hotbar-Specific Slot Stuff
		-- ToolTip stuff
		ToolTip = NewGui("TextLabel", "ToolTip")
		ToolTip.TextWrapped = false
		ToolTip.TextYAlignment = Enum.TextYAlignment.Top
		ToolTip.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
		ToolTip.BackgroundTransparency = 0
		ToolTip.Visible = false
		ToolTip.Parent = SlotFrame
		SlotFrame.MouseEnter:connect(function()
			if ToolTip.Text ~= "" then
				ToolTip.Visible = true
			end
		end)
		SlotFrame.MouseLeave:connect(function()
			ToolTip.Visible = false
		end)

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
			SlotNumber = NewGui("TextLabel", "Number")
			SlotNumber.Text = slotNum
			SlotNumber.Size = UDim2.fromScale(0.15, 0.15)
			SlotNumber.Visible = false
			SlotNumber.Parent = SlotFrame

			HotkeyFns[ZERO_KEY_VALUE + slotNum] = function(isProcessed)
				slot:Select(isProcessed)
			end
		end
	end

	do -- Dragging Logic
		local startPoint = SlotFrame.Position
		local lastUpTime = 0
		local startParent = nil

		SlotFrame.DragBegin:connect(function(dragPoint)
			Dragging[SlotFrame] = true
			startPoint = dragPoint

			SlotFrame.BorderSizePixel = 2

			-- Raise above other slots
			SlotFrame.ZIndex = 2
			ToolIcon.ZIndex = 2
			ToolName.ZIndex = 2
			SlotFrame.Parent.ZIndex = 2
			if SlotNumber then
				SlotNumber.ZIndex = 2
			end
			if HighlightFrame then
				HighlightFrame.ZIndex = 2
				for _, child in pairs(HighlightFrame:GetChildren()) do
					child.ZIndex = 2
				end
			end

			-- Circumvent the ScrollingFrame's ClipsDescendants property
			startParent = SlotFrame.Parent
			if startParent == UIGridFrame then
				local oldAbsolutPos = SlotFrame.AbsolutePosition
				local newPosition = UDim2.new(
					0,
					SlotFrame.AbsolutePosition.X - InventoryFrame.AbsolutePosition.X,
					0,
					SlotFrame.AbsolutePosition.Y - InventoryFrame.AbsolutePosition.Y
				)
				SlotFrame.Parent = InventoryFrame
				SlotFrame.Position = newPosition

				FakeSlotFrame = NewGui("Frame", "FakeSlot")
				FakeSlotFrame.LayoutOrder = SlotFrame.LayoutOrder
				FakeSlotFrame.Size = SlotFrame.Size
				FakeSlotFrame.BackgroundTransparency = 1
				FakeSlotFrame.Parent = UIGridFrame
			end
		end)

		SlotFrame.DragStopped:connect(function(x, y)
			if FakeSlotFrame then
				FakeSlotFrame:Destroy()
			end

			local now = tick()
			SlotFrame.Position = startPoint
			SlotFrame.Parent = startParent

			SlotFrame.BorderSizePixel = 0

			-- Restore height
			SlotFrame.ZIndex = 1
			ToolIcon.ZIndex = 1
			ToolName.ZIndex = 1
			startParent.ZIndex = 1
			if SlotNumber then
				SlotNumber.ZIndex = 1
			end
			if HighlightFrame then
				HighlightFrame.ZIndex = 1
				for _, child in pairs(HighlightFrame:GetChildren()) do
					child.ZIndex = 1
				end
			end

			Dragging[SlotFrame] = nil

			-- Make sure the tool wasn't dropped
			if not slot.Tool then
				return
			end

			-- Check where we were dropped
			if CheckBounds(InventoryFrame, x, y) then
				if slot.Index <= NumberOfHotbarSlots then
					slot:MoveToInventory()
				end
				-- Check for double clicking on an inventory slot, to move into empty hotbar slot
				if slot.Index > NumberOfHotbarSlots and now - lastUpTime < DOUBLE_CLICK_TIME then
					if LowestEmptySlot then
						local myTool = slot.Tool
						slot:Clear()
						LowestEmptySlot:Fill(myTool)
						slot:Delete()
					end
					now = 0 -- Resets the timer
				end
			elseif CheckBounds(HotbarFrame, x, y) then
				local closest = { math.huge, nil }
				for i = 1, NumberOfHotbarSlots do
					local otherSlot = Slots[i]
					local offset = GetOffset(otherSlot.Frame, Vector2.new(x, y))
					if offset < closest[1] then
						closest = { offset, otherSlot }
					end
				end
				local closestSlot = closest[2]
				if closestSlot ~= slot then
					slot:Swap(closestSlot)
					if slot.Index > NumberOfHotbarSlots then
						local tool = slot.Tool
						if not tool then -- Clean up after ourselves if we're an inventory slot that's now empty
							slot:Delete()
						else -- Moved inventory slot to hotbar slot, and gained a tool that needs to be unequipped
							if IsEquipped(tool) then --NOTE: HopperBin
								UnequipAllTools()
							end
							-- Also hide the inventory slot if we're showing results right now
							if ViewingSearchResults then
								slot.Frame.Visible = false
								slot.Frame.Parent = InventoryFrame
							end
						end
					end
				end
			else
				-- local tool = slot.Tool
				-- if tool.CanBeDropped then --TODO: HopperBins
				-- tool.Parent = workspace
				-- --TODO: Move away from character
				-- end
				if slot.Index <= NumberOfHotbarSlots then
					slot:MoveToInventory() --NOTE: Temporary
				end
			end

			lastUpTime = now
		end)
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

-- NOTE: We should probably migrate to a 2 collection system:
-- One collection for the hotbar and another collection for the inventory
local function SetNumberOfHotbarSlots(numSlots)
	if NumberOfHotbarSlots ~= numSlots then
		local prevNumberOfSlots = NumberOfHotbarSlots
		local newNumberOfSlots = numSlots
		-- If we are shrinking the number of slots we need
		-- to move around our tools to the right locations
		if prevNumberOfSlots > newNumberOfSlots then
			-- Delete the slots that are now no longer in the Hotbar
			-- Iterate backwards as to not corrupt our iterator
			for i = prevNumberOfSlots, newNumberOfSlots + 1, -1 do
				local slot = Slots[i]
				if slot then
					slot:MoveToInventory()
					slot:Delete()
				end
			end
			-- Also need to slide-back the inventory slots now that they are indexed earlier
			for i = prevNumberOfSlots, newNumberOfSlots + 1, -1 do
				local slot = Slots[i]
				if not slot.Tool then
					slot:Delete()
				end
			end
		else -- If we added more slots
			for i = prevNumberOfSlots, newNumberOfSlots do
				-- Incrementally add hotbar slots
				NumberOfHotbarSlots = i
				if Slots[i] then
					-- Move old
					local oldSlot = Slots[i]
					local oldTool = Slots[i].Tool

					local newSlot = MakeSlot(HotbarFrame, i)

					if oldTool then
						newSlot:Fill(oldTool)
					elseif not LowestEmptySlot then
						LowestEmptySlot = newSlot
					end
				else
					local slot = MakeSlot(HotbarFrame, i)

					slot.Frame.Visible = false

					if not LowestEmptySlot then
						LowestEmptySlot = slot
					end
				end
			end
		end
		NumberOfHotbarSlots = numSlots
		FullHotbarSlots = 0
		for i = 1, NumberOfHotbarSlots do
			if Slots[i] and Slots[i].Tool then
				FullHotbarSlots = FullHotbarSlots + 1
			end
		end

		UpdateBackpackLayout()
	end
end

local function OnChildAdded(child) -- To Character or Backpack
	if child:IsA("HopperBin") then
		warn(`[Purse] Ignoring '{child}' hopper in backpack. HopperBin is deprecated and not supported.`)
		return
	end
	if not child:IsA("Tool") then --NOTE: HopperBin
		if child:IsA("Humanoid") and child.Parent == Character then
			Humanoid = child
		end
		return
	end
	local tool = child

	if tool.Parent == Character then
		TimeOfLastToolChange = tick()
	end

	if ActiveHopper and tool.Parent == Character then --NOTE: HopperBin
		DisableActiveHopper()
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
		if tool:IsA("HopperBin") then --NOTE: HopperBin
			if tool.Active then
				UnequipAllTools()
				ActiveHopper = tool
			end
		end
	end

	BackpackScript.BackpackItemAdded:Fire()
end

local function OnChildRemoved(child) -- From Character or Backpack
	if child:IsA("HopperBin") then
		return
	end
	if not child:IsA("Tool") then --NOTE: HopperBin
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

	if tool == ActiveHopper then --NOTE: HopperBin
		ActiveHopper = nil
	end

	BackpackScript.BackpackItemRemoved:Fire()
	if isInventoryEmpty() then
		BackpackScript.BackpackEmpty:Fire()
	end
end

local function OnCharacterAdded(character)
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
	ActiveHopper = nil --NOTE: HopperBin

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
	-- Pass through keyboard hotkeys when not typing into a TextBox and not disabled (except for the Drop key)
	if
		input.UserInputType == Enum.UserInputType.Keyboard
		and not TextBoxFocused
		and (WholeThingEnabled or input.KeyCode.Value == DROP_HOTKEY_VALUE)
	then
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
			Slots[i]:TurnNumber(on)
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
if FFlagMountCoreGuiBackpack then
	if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
		MainFrame.Parent = BackpackGui
	end
else
	MainFrame.Visible = false
	MainFrame.Parent = BackpackGui
end

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
	OpenInventoryButton.MouseButton1Click:connect(function()
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
CloseInventoryButton.MouseButton1Click:connect(function()
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
ScrollingFrame.Parent = InventoryFrame

UIGridFrame = NewGui("Frame", "UIGridFrame")
UIGridFrame.Selectable = false
UIGridFrame.Size = UDim2.new(1, -(ICON_BUFFER * 2), 1, 0)
UIGridFrame.Position = UDim2.fromOffset(ICON_BUFFER, 0)
UIGridFrame.Parent = ScrollingFrame

UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
UIGridLayout.CellPadding = UDim2.fromOffset(ICON_BUFFER, ICON_BUFFER)
UIGridLayout.Parent = UIGridFrame

ScrollUpInventoryButton = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")
ScrollUpInventoryButton.Size = UDim2.fromOffset(34, 34)
ScrollUpInventoryButton.Position =
	UDim2.new(0.5, -ScrollUpInventoryButton.Size.X.Offset / 2, 0, INVENTORY_HEADER_SIZE + 3)
ScrollUpInventoryButton.Icon.Position = ScrollUpInventoryButton.Icon.Position - UDim2.fromOffset(0, 2)
ScrollUpInventoryButton.MouseButton1Click:connect(function()
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
ScrollDownInventoryButton.MouseButton1Click:connect(function()
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
		Font = Enum.Font.SourceSansBold,
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
do -- Search stuff
	searchFrame.BackgroundColor3 = SEARCH_BACKGROUND_COLOR
	searchFrame.BackgroundTransparency = searchBackgroundFade
	searchFrame.Size = UDim2.fromOffset(SEARCH_WIDTH - (SEARCH_BUFFER * 2), INVENTORY_HEADER_SIZE - (SEARCH_BUFFER * 2))
	searchFrame.Position = UDim2.new(1, -searchFrame.Size.X.Offset - SEARCH_BUFFER, 0, SEARCH_BUFFER)
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
	xButton.MouseButton1Click:connect(reset)
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

	local function openClose()
		if not next(Dragging) then -- Only continue if nothing is being dragged
			InventoryFrame.Visible = not InventoryFrame.Visible
			local nowOpen = InventoryFrame.Visible
			AdjustHotbarFrames()
			HotbarFrame.Active = not HotbarFrame.Active
			for i = 1, NumberOfHotbarSlots do
				Slots[i]:SetClickability(not nowOpen)
			end
		end

		if InventoryFrame.Visible then
			if GamepadEnabled then
				if GAMEPAD_INPUT_TYPES[UserInputService:GetLastInputType()] then
					resizeGamepadHintsFrame()
					gamepadHintsFrame.Visible = true
				end
				enableGamepadInventoryControl()
			end
		else
			if GamepadEnabled then
				gamepadHintsFrame.Visible = false
			end
			disableGamepadInventoryControl()
		end

		-- ROBLOX deviation START: change action name from RBX to Backpack
		if InventoryFrame.Visible then
			ContextActionService:BindAction("BackpackRemoveSlot", removeHotBarSlot, false, Enum.KeyCode.ButtonX)
		else
			ContextActionService:UnbindAction("BackpackRemoveSlot")
		end
		-- ROBLOX deviation END

		BackpackScript.IsOpen = InventoryFrame.Visible
		BackpackScript.StateChanged:Fire(InventoryFrame.Visible)
	end

	-- HotkeyFns[ARROW_HOTKEY] = function()
	-- 	if GuiService.MenuIsOpen then
	-- 		return
	-- 	end

	-- 	openClose()
	-- end
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) -- ROBLOX deviation: disable CoreGui backpack
	BackpackScript.OpenClose = openClose -- Exposed
end

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

	-- Manual unequip for HopperBins on drop button pressed
	HotkeyFns[DROP_HOTKEY_VALUE] = function() --NOTE: HopperBin
		if ActiveHopper then
			UnequipAllTools()
		end
	end

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

	slotFadeLocked = SLOT_FADE_LOCKED_DEFAULT * preferredTransparency
	for _, slot in ipairs(Slots) do
		slot.Frame.BackgroundTransparency = slotFadeLocked
	end

	searchBackgroundFade = SEARCH_BACKGROUND_FADE_DEFAULT * GuiService.PreferredTransparency -- ROBLOX deviation: use GuiService instead of UserGameSettings
	searchFrame.BackgroundTransparency = searchBackgroundFade
end
GuiService:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)

return BackpackScript

]]

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "BackpackGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local t1 = {
    OpenClose = nil,
    IsHotbarVisible = false,
    IsOpen = false
}
local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Parent = script
t1.StateChanged = BindableEvent
t1.ModuleName = "Backpack"
t1.KeepVRTopbarOpen = true
t1.VRIsExclusive = true
t1.VRClosesNonExclusive = true

local v1 = Enum.FontSize.Size14
local v2 = 0.5 * GuiService.PreferredTransparency

Color3.new(0.12156862745098039, 0.12156862745098039, 0.12156862745098039)
Color3.new(0.19215686274509805, 0.19215686274509805, 0.19215686274509805)

local v3 = Color3.new(1, 1, 1)
local v4 = 0.5 * GuiService.PreferredTransparency
local v5 = Color3.new(1, 1, 1)

UDim2.fromOffset(14, 9)

local _ = Enum.KeyCode.Backquote.Value
local v6 = Color3.new(0, 0.6352941176470588, 1)
local v7 = "Search"

Color3.new(0.37, 0.37, 0.37)

local v8 = 0.15 * GuiService.PreferredTransparency
local Value = Enum.KeyCode.Zero.Value
local Value2 = Enum.KeyCode.Backspace.Value
local t2 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
}
local ContextActionService = game:GetService("ContextActionService")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local v9 = GuiService:IsTenFootInterface()

local function Create(p1) -- line: 112
    return function(p2) -- line: 113
        -- upvalues: p1 (copy)
        local v10 = Instance.new(p1)
        local v11

        for v12, v13 in pairs(p2) do
            if type(v12) == "number" then
                v13.Parent = v10
            elseif v12 == "Parent" then
                v11 = v13
            else
                v10[v12] = v13
            end
        end

        if v11 then
            v10.Parent = v11
        end

        return v10
    end
end

local function v14() -- line: 133
    -- upvalues: v7 (ref)
    local LocalizationService = game:GetService("LocalizationService")

    v7 = LocalizationService:GetCorescriptLocalizations()[1]:GetString(LocalizationService.RobloxLocaleId, "BACKPACK_SEARCH")
end

pcall(v14)

if v9 then
    v1 = Enum.FontSize.Size24
end

local v15 = false

v14 = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < 1024

local n1 = 60
local n2 = 5
local t3 = {
    INV_TILE = v14 and 76 or 94,
    INV_COLUMNS = if v14 then 3 else nil,
    INV_COLUMNS_MIN_W = 720,
    ROW_HEADER = v14 and 24 or 30,
    ROW_TEXT = v14 and 18 or 22,
    TILE_GAP = 12,
    HOTBAR_MARGIN = 8,
    PANEL_GAP = 5,
    FONT = Enum.Font.BuilderSansExtraBold,
    SLOT_COLOR = Color3.new(0, 0, 0),
    SLOT_FADE = 0.5,
    SLOT_FADE_OPEN = 0.5,
    TILE_COLOR = Color3.new(0, 0, 0),
    TILE_FADE = 0.45,
    TILE_FADE_OPEN = 0.45,
    SLOT_CORNER = 5,
    PANEL_CORNER = 8,
    PANEL_COLOR = Color3.new(0, 0, 0),
    PANEL_FADE = 0.55,
    TITLE_COLOR = Color3.fromRGB(150, 156, 168),
    SEARCH_COLOR = Color3.new(1, 1, 1),
    SEARCH_FADE = 0.8,
    NAME_SIZE = v14 and 10 or 11,
    NAME_BOX = 30,
    NAME_BOTTOM = 7,
    TEXT_STROKE = 2,
    ICON_SCALE = 0.9,
    ICON_Y = 0.44,
    HOTBAR_ICON_SCALE = 0.86,
    SHADOW_FADE = 0.55,
    SHADOW_OFFSET = Vector2.new(2, 3),
    BADGE_SCALE = 0.3,
    CROWN_ICON = "rbxassetid://132409368513754",
    FAV_COLOR = Color3.fromRGB(255, 184, 28),
    FAV_FADE = 0.2,
    STAR_ICON = "rbxassetid://137513422393347"
}
local v16 = Vector2.new(61, 85)
local new = Vector2.new
local v17

t3.STAR_RECT = {
    v16,
    new(902, 844)
}
t3.TITLE_TEXT = "All Items"
t3.STOCK_ARROWS = false
t3.INCOME_COLOR = Color3.fromRGB(50, 255, 60)
t3.INCOME_W = 94
t3.PERK_W = 150
t3.PERK_COLOR = Color3.fromRGB(255, 210, 74)
t3.CARD_COLOR = Color3.fromRGB(28, 32, 38)
t3.CARD_FADE = 0
t3.CARD_SIZE = Vector2.new(190, 190)
t3.CARD_CORNER = 6
t3.CARD_STROKE = Color3.new(0, 0, 0)
t3.CARD_STROKE_THICKNESS = 2.5
t3.DIVIDER_COLOR = Color3.fromRGB(95, 100, 110)
t3.COMMON_KG = "#B0B4BC"

local LocalPlayer3 = Players.LocalPlayer
local v18, v19, v20, v21, v22, v23, v24, UIGridLayout, v25, v26, Backpack
local t4 = {}
local v27
local t5 = {}
local t6 = {}
local t7 = {}
local n3 = 0
local v28
local v29 = false
local v30 = false
local v31 = false
local t8 = {}
local t9 = {}
local v32 = false
local n4 = 0
local n5 = 3

if v14 then
    v17 = 3
    n5 = 2
else
    v17 = 10
end

local t10, t11
local v33 = "BindableEvent"

local function v34(p3) -- line: 113
    -- upvalues: v33 (copy)
    local v35 = Instance.new(v33)
    local v36

    for v37, v38 in pairs(p3) do
        if type(v37) == "number" then
            v38.Parent = v35
        elseif v37 == "Parent" then
            v36 = v38
        else
            v35[v37] = v38
        end
    end

    if v36 then
        v35.Parent = v36
    end

    return v35
end

t1.BackpackEmpty = v34({
    Name = "BackpackEmpty",
    Parent = script
})

local v39 = "BindableEvent"

v34 = function(p4) -- line: 113
    -- upvalues: v39 (copy)
    local v40 = Instance.new(v39)
    local v41

    for v42, v43 in pairs(p4) do
        if type(v42) == "number" then
            v43.Parent = v40
        elseif v42 == "Parent" then
            v41 = v43
        else
            v40[v42] = v43
        end
    end

    if v41 then
        v40.Parent = v41
    end

    return v40
end

t1.BackpackItemAdded = v34({
    Name = "BackpackAdded",
    Parent = script
})

local v44 = "BindableEvent"

v34 = function(p5) -- line: 113
    -- upvalues: v44 (copy)
    local v45 = Instance.new(v44)
    local v46

    for v47, v48 in pairs(p5) do
        if type(v47) == "number" then
            v48.Parent = v45
        elseif v47 == "Parent" then
            v46 = v48
        else
            v45[v47] = v48
        end
    end

    if v46 then
        v45.Parent = v46
    end

    return v45
end

t1.BackpackItemRemoved = v34({
    Name = "BackpackRemoved",
    Parent = script
})

local function NewGui(p6, p7) -- line: 284
    -- upvalues: v1 (ref)
    local v49 = Instance.new(p6)

    v49.Name = p7
    v49.BackgroundColor3 = Color3.new(0, 0, 0)
    v49.BackgroundTransparency = 1
    v49.BorderColor3 = Color3.new(0, 0, 0)
    v49.BorderSizePixel = 0
    v49.Size = UDim2.fromScale(1, 1)

    if p6:match("Text") then
        v49.TextColor3 = Color3.new(1, 1, 1)
        v49.Text = ""
        v49.Font = Enum.Font.SourceSans
        v49.FontSize = v1
        v49.TextWrapped = true

        if p6 == "TextButton" then
            v49.Font = Enum.Font.SourceSansBold
            v49.BorderSizePixel = 1
        end
    end

    return v49
end

function t1.IsInventoryEmpty() -- line: 316
    -- upvalues: t4 (copy), v17 (ref)
    for i = v17 + 1, #t4 do
        local v50 = t4[i]

        if v50 and v50.Tool then
            return false
        end
    end

    return true
end

local function UseGazeSelection() -- line: 328
    return false
end

local function AdjustHotbarFrames() -- line: 332
    -- upvalues: t1 (copy), t3 (copy), v20 (ref), v21 (ref), t4 (copy), n3 (ref), v17 (ref)
    local Visible = v21.Visible
    local v51

    if Visible then
        v51 = v17
        v51 = v51 or n3
    else
        v51 = n3
    end

    local v52 = v51 >= 1
    local v53 = v17
    local n6 = 0

    for i = 1, v53 do
        local v54 = t4[i]

        if v54.Tool or Visible then
            n6 += 1
            v54:Readjust(n6, v51)
            v54.Frame.Visible = true
        else
            v54.Frame.Visible = false
        end
    end

    local v55 = v20
    local STOCK_ARROWS = t3.STOCK_ARROWS

    if STOCK_ARROWS then
        STOCK_ARROWS = not Visible

        if STOCK_ARROWS then
            if v52 then
                STOCK_ARROWS = v52
            else
                local v56 = v17 + 1
                local v57 = #t4
                local v58 = false
                local v59

                for i = v56, v57 do
                    local v60 = t4[i]

                    if v60 and v60.Tool then
                        v59 = false
                        v58 = true
                        break
                    end
                end

                if not v58 then
                    v59 = true
                end

                STOCK_ARROWS = not v59
            end
        end
    end

    v55.Visible = STOCK_ARROWS
    v55.Position = UDim2.new(0.5, -15, 1, v52 and -110 or -50)
    t1.IsHotbarVisible = v52
end

local function UpdateScrollingFrameCanvasSize() -- line: 354
    -- upvalues: t3 (copy), v23 (ref), v24 (ref), t10 (ref)
    local v63 = math.max(1, (math.floor((v23.AbsoluteSize.X - t3.TILE_GAP) / (t3.INV_TILE + t3.TILE_GAP))))

    if t10.rows(v63) then
        return
    end

    local v65 = math.ceil((#v24:GetChildren() - 1) / v63) * (t3.INV_TILE + t3.TILE_GAP) + t3.TILE_GAP
    local v66 = v23

    v66.CanvasSize = UDim2.fromOffset(0, v65)
end

local function AdjustInventoryFrames() -- line: 363
    -- upvalues: t4 (copy), v17 (ref), t10 (ref), UpdateScrollingFrameCanvasSize (copy)
    for i = v17 + 1, #t4 do
        local v67 = t4[i]

        t10.place(v67, t10.has(v67.Tool))
    end

    t10.sort()
    UpdateScrollingFrameCanvasSize()
end

local function UpdateBackpackLayout() -- line: 372
    -- upvalues: n1 (copy), n2 (copy), t3 (copy), v19 (ref), v21 (ref), v23 (ref), v17 (ref), AdjustHotbarFrames (copy), AdjustInventoryFrames (copy), n5 (ref)
    local v68 = v19

    v68.Size = UDim2.new(0, n2 + v17 * (n1 + n2), 0, n2 + n1 + n2)
    v68.Position = UDim2.new(0.5, -v19.Size.X.Offset / 2, 1, -v19.Size.Y.Offset - t3.HOTBAR_MARGIN)

    local v69 = v21
    local new = UDim2.new
    local v70, v71

    if t3.INV_COLUMNS and workspace.CurrentCamera.ViewportSize.X >= t3.INV_COLUMNS_MIN_W then
        local v72 = t3.TILE_GAP + t3.INV_COLUMNS * (t3.INV_TILE + t3.TILE_GAP)

        if v72 then
            v70 = v72
            v71 = true
        else
            v71 = false
        end
    else
        v71 = false
    end

    if not v71 then
        v70 = v19.Size.X.Offset
    end

    v69.Size = new(0, v70, 0, (t3.INV_TILE + t3.TILE_GAP) * n5 + t3.TILE_GAP + 43)
    v69.Position = UDim2.new(0.5, -v21.Size.X.Offset / 2, 1, v19.Position.Y.Offset - v21.Size.Y.Offset - t3.PANEL_GAP)

    local v73 = v23

    v73.Size = UDim2.new(1, v23.ScrollBarThickness + 1, 1, -43)
    v73.Position = UDim2.fromOffset(0, 43)
    AdjustHotbarFrames()
    AdjustInventoryFrames()
end

local function Clamp(p8, p9, p10) -- line: 399
    return (math.min(p9, (math.max(p8, p10))))
end

local function CheckBounds(p11, p12, p13) -- line: 403
    local AbsolutePosition, AbsoluteSize = p11.AbsolutePosition, p11.AbsoluteSize

    if AbsolutePosition.X < p12 and p12 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p13 then
        return p13 <= AbsolutePosition.Y + AbsoluteSize.Y
    end

    return false
end

local function GetOffset(p14, p15) -- line: 409
    return (p14.AbsolutePosition + p14.AbsoluteSize / 2 - p15).magnitude
end

local function DisableActiveHopper() -- line: 414
    warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
end

local function UnequipAllTools() -- line: 423
    -- upvalues: v26 (ref), v28 (ref), t10 (ref)
    if t10.holdLocked() or not v26 then
        return
    end

    v26:UnequipTools()

    if v28 then
        warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
    end
end

local function EquipNewTool(p16) -- line: 433
    -- upvalues: v25 (ref), v26 (ref), v28 (ref), t10 (ref)
    if not t10.holdLocked() then
        if not t10.holdLocked() and v26 then
            v26:UnequipTools()

            if v28 then
                warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
            end
        end

        if p16:IsA("HopperBin") then
            warn((("[Purse] Cannot select '%*' hopper. HopperBin is deprecated and not supported."):format(p16)))
        else
            p16.Parent = v25
        end
    end
end

local function IsEquipped(p17) -- line: 449
    -- upvalues: v25 (ref)
    local v75, v76

    if p17 then
        if p17:IsA("HopperBin") then
            local Active = p17.Active

            if Active then
                v75 = Active
                v76 = true
            else
                v76 = false
            end
        else
            v76 = false
        end
    else
        v75 = p17
        v76 = true
    end

    if not v76 then
        v75 = p17.Parent == v25
    end

    return v75
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local Loc = require(Modules:WaitForChild("Loc"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))

t10 = {
    active = "Fish",
    GAP = 8,
    list = {
        {
            name = "Fish",
            icon = "rbxassetid://88976101808812"
        },
        {
            name = "Harpoons",
            icon = "rbxassetid://72264768812222"
        },
        {
            name = "Guns",
            icon = "rbxassetid://84309628083698"
        },
        {
            name = "Bait",
            icon = "rbxassetid://97433166170129"
        },
        {
            name = "Potions",
            icon = "rbxassetid://95689780794934"
        },
        {
            name = "Tickets",
            icon = "rbxassetid://86687813193543"
        }
    },
    TAB = v14 and 64 or 84
}

local RarityStyle = require(Modules:WaitForChild("HarpoonSkins"))

t10.skins = RarityStyle
t10.perks = require(Modules:WaitForChild("PassPerks"))
t10.view = require(Modules:WaitForChild("HarpoonView"))
t10.baits = {
    ById = {}
}

for _, v77 in ipairs({
        require(Modules:WaitForChild("BaitConfig")).ALWAYS,
        require(Modules:WaitForChild("BaitConfig")).POOL,
        require(Modules:WaitForChild("BaitConfig")).UNKNOWN
    }) do
    for _, v78 in ipairs(v77) do
        t10.baits.ById[v78.id] = v78
    end
end

RarityStyle = require
t10.rarityStyle = RarityStyle(Modules:WaitForChild("RarityStyle"))
t10.potions = require(Modules:WaitForChild("PotionConfig"))
t10.tickets = require(Modules:WaitForChild("TicketConfig"))
t10.guns = require(Modules:WaitForChild("GunSkins"))
t10.titanShiny = require(Modules:WaitForChild("TitanConfig")).SHINY_ODDS

function t10.holdLocked() -- line: 506
    -- upvalues: v25 (ref)
    if not game:GetService("Players").LocalPlayer:GetAttribute("TutorialHoldLock") then
        return false
    end

    local Tool = v25 and v25:FindFirstChildOfClass("Tool")

    return Tool ~= nil and Tool:GetAttribute("Species") ~= nil
end

function t10.has(p18) -- line: 511
    -- upvalues: t10 (ref)
    return p18 ~= nil and (p18:GetAttribute("Category") or "Fish") == t10.active
end

function t10.place(p19, p20) -- line: 515
    -- upvalues: v21 (ref), v24 (ref)
    p19.Frame.Visible = p20
    p19.Frame.Parent = p20 and v24 or v21
end

function t10.weights() -- line: 529
    -- upvalues: t10 (ref), ReplicatedStorage (copy)
    if t10.mutWeight then
        return t10.mutWeight
    end

    local MutationWeights = ReplicatedStorage:GetAttribute("MutationWeights")

    local function v79() -- line: 532
        -- upvalues: MutationWeights (copy)
        return game:GetService("HttpService"):JSONDecode(MutationWeights)
    end

    local ok, result = pcall(v79)

    if not MutationWeights or not ok or type(result) ~= "table" then
        return {}
    end

    local t13 = {}

    for _, v80 in ipairs(result) do
        t13[v80.n] = tonumber(v80.w)
    end

    t10.mutWeight = t13

    return t13
end

function t10.key(p21) -- line: 540
    -- upvalues: t10 (ref), FishDisplay (copy), RarityDisplay (copy)
    if p21:GetAttribute("Category") == "Tickets" then
        local v81 = t10.tickets.Get(p21:GetAttribute("Ticket"))
        local v82 = v81 and t10.tickets.GROUP_ORDER[v81.group] or 9
        local price = v81 and v81.price or 0

        return {
            1, 1,
            v82,
            -price,
            "",
            0, 0,
            p21.Name
        }
    end

    if p21:GetAttribute("Category") == "Potions" then
        local v84 = t10.potions.Get(p21:GetAttribute("Potion"))

        return {
            1, 1,
            if not v84 or v84.kind ~= "Bag" then 0 else 1,
            -(v84 and v84.tier or 0),
            "",
            0, 0,
            p21.Name
        }
    end

    if p21:GetAttribute("Category") == "Guns" then
        local v87 = t10.guns.Get(p21:GetAttribute("GunSkin"))

        return {
            1, 1,
            -(table.find(RarityDisplay.order, v87 and v87.rarity) or 0),
            v87 and v87.order or 0,
            "",
            0, 0,
            p21.Name
        }
    end

    if p21:GetAttribute("Category") == "Harpoons" then
        local v89 = t10.skins.Get(p21:GetAttribute("HarpoonSkin"))

        return {
            1, 1,
            -(table.find(RarityDisplay.order, v89 and v89.rarity) or 0),
            0,
            "",
            0, 0,
            v89 and v89.name or p21.Name
        }
    end

    if p21:GetAttribute("Category") == "Bait" then
        local v91 = t10.baits.ById[p21:GetAttribute("Bait")]
        local v92 = v91 and FishDisplay[v91.catches]

        return {
            1, 1,
            -(table.find(RarityDisplay.order, v92 and v92.rarity) or 0),
            0,
            "",
            0, 0,
            p21.Name
        }
    end

    local v94 = p21:GetAttribute("Species") or ""
    local v95 = FishDisplay[v94]
    local Mutation = p21:GetAttribute("Mutation")
    local v96 = if Mutation then t10.weights()[Mutation] or 0 else 1e999
    local v97 = if p21:GetAttribute("Favorite") == true then 0 else 1

    if t10.sortMode == "Rarity" then
        return {
            0,
            v97,
            -(table.find(RarityDisplay.order, v95 and v95.rarity) or 0),
            p21:GetAttribute("SpeciesRank") or 1e999,
            v94,
            v96,
            -(tonumber(p21:GetAttribute("Weight")) or 0),
            (tostring(p21:GetAttribute("BagId") or p21.Name))
        }
    end

    local v103 = tonumber(p21:GetAttribute("Rate")) or 0
    local v104 = tonumber(p21:GetAttribute("Copy"))
    local v105 = tonumber(p21:GetAttribute("Boost"))
    local v106

    if v104 then
        v106 = 0
    elseif v105 then
        v104 = v105
        v106 = 1
    else
        v106 = 2
        v104 = 0
    end

    local v107 = t10.sortMode == "Base" and v103 / 2 ^ ((tonumber(p21:GetAttribute("Stage")) or 1) - 1) or v103

    return {
        0,
        v97,
        v106,
        -v104,
        -v107,
        -v103,
        -(tonumber(p21:GetAttribute("Weight")) or 0),
        (tostring(p21:GetAttribute("BagId") or p21.Name))
    }
end

function t10.sort() -- line: 588
    -- upvalues: t4 (copy), v17 (ref), t10 (ref), UpdateScrollingFrameCanvasSize (copy)
    t10.queued = false

    local t21 = {}

    for i = v17 + 1, #t4 do
        local v114 = t4[i]
        local v115 = #t21 + 1
        local t22 = {
            slot = v114
        }
        local Tool = v114.Tool
        local v116 = if Tool then t10.key(v114.Tool) else nil

        t22.key = if not Tool or not v116 then { 2, 1, 0, 0, "", 0, 0, "" } else v116
        t21[v115] = t22
    end

    table.sort(t21, function(p22, p23) -- line: 595
        for i = 1, #p22.key do
            if p22.key[i] ~= p23.key[i] then
                return p22.key[i] < p23.key[i]
            end
        end

        return false
    end)

    for v117, v118 in ipairs(t21) do
        v118.slot.Frame.LayoutOrder = v17 + v117
    end

    if t10.active == "Harpoons" or t10.active == "Guns" then
        UpdateScrollingFrameCanvasSize()
    end
end

function t10.resort() -- line: 605
    -- upvalues: t10 (ref)
    if t10.queued then
        return
    end

    t10.queued = true
    task.defer(t10.sort)
end

function t10.front(p24) -- line: 620
    -- upvalues: t4 (copy), v17 (ref)
    if not p24:GetAttribute("HotbarFront") then
        return nil
    end

    for i = 1, v17 do
        local v120 = t4[i]

        if not (not v120 or v120.Tool and (v120.Tool:GetAttribute("Potion") or v120.Tool:GetAttribute("HotbarFront"))) then
            if v120.Tool then
                v120:MoveToInventory(true)
            end

            v120:Fill(p24)

            return v120
        end
    end

    return nil
end

local function formatKg(p25) -- line: 633
    local v121, v122 = string.format("%.1f", p25):match("^(%d+)%.(%d)$")

    return v121:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. (v122 ~= "0" and "." .. v122 or "") .. "Kg"
end

local t23 = { "K", "M", "B", "T" }

local function formatShort(p26) -- line: 640
    -- upvalues: t23 (copy)
    if p26 < 1000 then
        return (tostring((math.floor(p26))))
    end

    local v124 = p26
    local n7 = 0

    while v124 >= 1000 and n7 < #t23 do
        v124 /= 1000
        n7 += 1
    end

    return string.format("%.1f", v124):gsub("%.0$", "") .. t23[n7]
end

local function legible(p27) -- line: 653
    local v125 = math.max(p27.R, p27.G, p27.B)

    if v125 >= 0.55 then
        return p27
    end

    if v125 <= 0 then
        return Color3.fromRGB(140, 35, 140)
    end

    local v126 = 0.55 / v125

    return Color3.new(math.min(1, p27.R * v126), math.min(1, p27.G * v126), (math.min(1, p27.B * v126)))
end

local function gradientOf(p28) -- line: 666
    -- upvalues: t10 (ref)
    local v132, v133, v134 = p28:ToHSV()

    if t10.rarityStyle.Glows(p28) then
        return ColorSequence.new(Color3.new(1, 1, 1))
    end

    if v133 < 0.15 then
        return ColorSequence.new(p28)
    end

    local v135, v136

    if v132 > 0.09 and v132 < 0.19 then
        v135 = Color3.fromHSV(v132 - 0.012, 1, 0.86)
        v136 = Color3.fromHSV(v132 + 0.01, 0.78, 1)
    elseif not (v132 > 0.5 and v132 < 0.72) then
        v135 = Color3.fromHSV((v132 - 0.035) % 1, math.min(1, v133 * 1.15), v134 * 0.78)
        v136 = Color3.fromHSV((v132 + 0.02) % 1, math.min(v133, 0.85), (math.min(1, v134 * 1.3)))
    else
        v135 = Color3.fromHSV(v132 + 0.03, 1, 0.8)
        v136 = Color3.fromHSV(v132 - 0.015, 0.8, 1)
    end

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v135),
        ColorSequenceKeypoint.new(0.5, v136),
        ColorSequenceKeypoint.new(1, v135)
    })
end

local function strokeOf(p29) -- line: 687
    -- upvalues: t10 (ref)
    local v142, v143 = p29:ToHSV()

    if t10.rarityStyle.Glows(p29) then
        return t10.rarityStyle.StrokeOf(p29)
    end

    if v143 < 0.15 then
        return Color3.fromRGB(30, 30, 30)
    end

    if not (v142 > 0.09 and v142 < 0.19) then
        return Color3.fromHSV(v142, math.max(v143, 0.9), 0.42)
    end

    return Color3.fromHSV(v142 - 0.02, 1, 0.42)
end

local function titleCase(p30) -- line: 694
    return p30:sub(1, 1):upper() .. p30:sub(2):lower()
end

local function styledText(p31, p32, p33, p34, p35, p36, p37) -- line: 700
    -- upvalues: t3 (copy), NewGui (copy)
    local v144 = NewGui("TextLabel", p32)

    v144.Font = t3.FONT
    v144.TextSize = p33
    v144.TextWrapped = true
    v144.TextXAlignment = Enum.TextXAlignment.Center
    v144.TextYAlignment = p36 or Enum.TextYAlignment.Center
    v144.Position = p34
    v144.Size = p35
    v144.ZIndex = p37
    v144.Parent = p31

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "Edge"
    UIStroke.Thickness = t3.TEXT_STROKE
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = v144

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Name = "Grad"
    UIGradient.Rotation = 0
    UIGradient.Parent = v144

    return v144
end

local function styleText(p38, p39, p40) -- line: 722
    -- upvalues: t10 (ref), gradientOf (copy), strokeOf (copy)
    p38.Text = p39

    local Flat = p38:GetAttribute("Flat")
    local v145, v146

    if Flat then
        v146 = false
    elseif t10.rarityStyle.Glows(p40) and p40 then
        v145 = p40
        v146 = true
    else
        v146 = false
    end

    p38.TextColor3 = if not v146 then Color3.new(1, 1, 1) else v145
    p38.Grad.Color = Flat and ColorSequence.new(p40) or gradientOf(p40)
    p38.Edge.Color = Flat and Color3.new(0, 0, 0) or strokeOf(p40)
    t10.rarityStyle.Track(p38, if Flat or not p40 then nil else p40)
end

function t10.rows(p41) -- line: 737
    -- upvalues: t3 (copy), v23 (ref), v24 (ref), UIGridLayout (ref), t4 (copy), v17 (ref), t10 (ref), NewGui (copy), RarityDisplay (copy), styledText (copy), styleText (copy)
    local v147 = t10.active == "Harpoons" or t10.active == "Guns"

    UIGridLayout.Parent = not v147 and v24 or nil

    local rowBox = t10.rowBox

    if not rowBox then
        rowBox = NewGui("Frame", "RarityRows")
        rowBox.Selectable = false
        rowBox.Size = v24.Size
        rowBox.Position = v24.Position
        rowBox.Parent = v23

        local t24 = t10
        local t25 = {}

        t24.rowBox = rowBox
        t24.rowLabels = t25
    end

    rowBox.Visible = v147

    if not v147 then
        return false
    end

    local t26 = {}

    for i = v17 + 1, #t4 do
        local v148 = t4[i]

        if v148.Tool and v148.Frame.Parent == v24 and v148.Frame.Visible then
            t26[#t26 + 1] = v148
        end
    end

    table.sort(t26, function(p42, p43) -- line: 756
        return p42.Frame.LayoutOrder < p43.Frame.LayoutOrder
    end)

    local v149 = t3.INV_TILE + t3.TILE_GAP
    local n8 = 0
    local n9 = 0
    local n10 = 0
    local v150

    for _, v151 in ipairs(t26) do
        local v152 = t10.skins.Get(v151.Tool:GetAttribute("HarpoonSkin")) or t10.guns.Get(v151.Tool:GetAttribute("GunSkin"))
        local v153 = v152 and v152.rarity or ""

        if v153 ~= v150 then
            v150 = v153

            if n9 > 0 then
                n8 += v149
                n9 = 0
            end

            n10 += 1

            local v154 = t10.rowLabels[n10]

            if not v154 then
                v154 = styledText(rowBox, "Rarity", t3.ROW_TEXT, UDim2.new(), UDim2.new(1, 0, 0, t3.ROW_HEADER), Enum.TextYAlignment.Center, 2)
                v154.TextXAlignment = Enum.TextXAlignment.Left
                v154.TextWrapped = false
                t10.rowLabels[n10] = v154
            end

            local v155 = RarityDisplay[v153]
            local color, v156

            if v155 then
                local display = v155.display

                v156 = display:sub(1, 1):upper() .. display:sub(2):lower() or ""
                color = v155.color or Color3.new(1, 1, 1)
            else
                v156 = ""
                color = Color3.new(1, 1, 1)
            end

            styleText(v154, v156, color)
            v154.Position = UDim2.fromOffset(0, n8)
            v154.Visible = true
            n8 += t3.ROW_HEADER
        end

        v151.Frame.Position = UDim2.fromOffset(n9 * v149, n8)
        n9 += 1

        if p41 <= n9 then
            n8 += v149
            n9 = 0
        end
    end

    if n9 > 0 then
        n8 += v149
    end

    for i = n10 + 1, #t10.rowLabels do
        t10.rowLabels[i].Visible = false
    end

    v23.CanvasSize = UDim2.fromOffset(0, n8 + t3.TILE_GAP)

    return true
end

local function describeTool(p44) -- line: 789
    -- upvalues: LocalPlayer (copy), t10 (ref), FishDisplay (copy), MutationDisplay (copy), Loc (copy), RarityDisplay (copy), formatKg (copy), legible (copy)
    local HarpoonSkin = p44:GetAttribute("HarpoonSkin")
    local v158 = HarpoonSkin and t10.skins.Get(HarpoonSkin)

    if v158 then
        local v159 = RarityDisplay[v158.rarity]
        local color = v159 and v159.color or Color3.new(1, 1, 1)
        local v160 = t10.perks.MyHarpoonPerks(LocalPlayer, HarpoonSkin)

        local function pc(p45) -- line: 799
            return (string.format("%.2f", p45 * 100):gsub("%.?0+$", ""))
        end

        local t27 = {}

        if v160.instant then
            t27[#t27 + 1] = Loc.F("harpoon.instant", "Instant Catch")
        end

        if not v160.instant and (v160.instantChance or 0) > 0 then
            local v161 = #t27 + 1
            local F = Loc.F
            local instantChance = v160.instantChance

            t27[v161] = F("harpoon.instantChance", "{p}% Instant Catch Chance", {
                p = string.format("%.2f", instantChance * 100):gsub("%.?0+$", "")
            })
        end

        if (v160.hits or 0) > 0 then
            t27[#t27 + 1] = Loc.F("harpoon.hits", "-{n} Hits", {
                n = tostring(v160.hits)
            })
        end

        if (v160.life or 0) > 0 then
            local v163 = #t27 + 1
            local F = Loc.F
            local life = v160.life

            t27[v163] = F("harpoon.life", "{p}% Extra Life Chance", {
                p = string.format("%.2f", life * 100):gsub("%.?0+$", "")
            })
        end

        if (v160.double or 0) > 0 then
            local v164 = #t27 + 1
            local F = Loc.F
            local double = v160.double

            t27[v164] = F("harpoon.double", "{p}% Double Catch Chance", {
                p = string.format("%.2f", double * 100):gsub("%.?0+$", "")
            })
        end

        if v160.size > 0 then
            local v165 = #t27 + 1
            local F = Loc.F
            local size = v160.size

            t27[v165] = F("harpoon.size", "+{p}% Size Bonus", {
                p = string.format("%.2f", size * 100):gsub("%.?0+$", "")
            })
        end

        if v160.luck > 1 then
            local v166 = #t27 + 1
            local F = Loc.F
            local v167 = v160.luck - 1

            t27[v166] = F("harpoon.luck", "+{p}% Mutation Chance", {
                p = string.format("%.2f", v167 * 100):gsub("%.?0+$", "")
            })
        end

        if v160.reel < 1 then
            local v168 = #t27 + 1
            local F = Loc.F
            local v169 = 1 - v160.reel

            t27[v168] = F("harpoon.slower_pct", "{p}% Slower Minigame", {
                p = string.format("%.2f", v169 * 100):gsub("%.?0+$", "")
            })
        end

        return v158.name, "", color, v159 and v159.display or "", color, nil, "", v158.rarity == "Common", table.concat(t27, "\n")
    end

    local v170 = p44:GetAttribute("GunSkin") and t10.guns.Get(p44:GetAttribute("GunSkin"))

    if v170 then
        local v171 = RarityDisplay[v170.rarity]
        local color = v171 and v171.color or Color3.new(1, 1, 1)

        return v170.name, "", color, v171 and v171.display or "", color, nil, "", v170.rarity == "Common", Loc.F("gun.equipHint", "Hold it at your harpoon and press EQUIP")
    end

    local v172 = p44:GetAttribute("Ticket") and t10.tickets.Get(p44:GetAttribute("Ticket"))

    if v172 then
        local text = t10.tickets.GROUPS[v172.group].text

        return Loc.T(t10.tickets.Title(v172)), "x" .. tostring(p44:GetAttribute("Count") or 1), text, "", text, nil, "", false, table.concat(t10.tickets.Info(v172, Loc, t10.titanShiny), "\n")
    end

    local Potion = p44:GetAttribute("Potion")
    local v175, v176

    if Potion then
        v175 = t10.potions.Kind(Potion)

        if v175 then
            if t10.potions.Length(Potion) == "" then
                v176 = t10.potions.Title(Potion, Loc)

                if not v176 then
                    local F = Loc.F
                    local t36 = t10

                    v176 = F("potion.card", "{what} for {len}", {
                        what = t36.potions.Title(Potion, Loc),
                        len = Loc.F(t36.potions.LenKey(Potion), t36.potions.Length(Potion))
                    })
                end
            else
                local F = Loc.F
                local t38 = t10

                v176 = F("potion.card", "{what} for {len}", {
                    what = t38.potions.Title(Potion, Loc),
                    len = Loc.F(t38.potions.LenKey(Potion), t38.potions.Length(Potion))
                })
            end

            return Loc.T(v175.name), "", v175.color, "", v175.color, nil, "", false, v176
        end
    end

    local Species = p44:GetAttribute("Species")
    local v179 = Species and FishDisplay[Species]
    local Mutation = p44:GetAttribute("Mutation")
    local v180 = Mutation and MutationDisplay[Mutation]
    local RarityDisplay2, v181, v182

    if v179 then
        local rarity = v179.rarity

        if rarity then
            RarityDisplay2 = RarityDisplay
            v181 = v179.shown or v179.rarity
            v182 = RarityDisplay2[v181]
        else
            v182 = rarity
        end
    else
        v182 = v179
    end

    local v183, v184

    if v179 then
        local v185 = Loc.Fish(v180 and v180.prefix, v179.display or Species)

        if v185 then
            v183 = v185
            v184 = true
        else
            v184 = false
        end
    else
        v184 = false
    end

    if not v184 then
        v183 = p44.Name
    end

    local Serial = p44:GetAttribute("Serial")

    if Serial and v179 then
        v183 ..= " #" .. Serial
    end

    local v186, v187

    if v180 then
        local textColor = v180.textColor

        if textColor then
            v186 = textColor
            v187 = true
        else
            local v188 = legible(v180.color)

            if v188 then
                v186 = v188
                v187 = true
            else
                v187 = false
            end
        end
    else
        v187 = false
    end

    if not v187 then
        local color = if v182 then v182.color else nil

        v186 = if not v182 or not color then Color3.new(1, 1, 1) else color
    end

    local Weight = p44:GetAttribute("Weight")
    local v189 = Weight and formatKg(Weight) or ""
    local display = v182 and v182.display or ""
    local v190 = v182 and v182.color
    local Rate = p44:GetAttribute("Rate")
    local icon = v180 and v180.icon or ""
    local v191 = not v180 and v179 ~= nil and v179.rarity == "Common"

    return v183, v189, v186, display, v190, Rate, icon, v191
end

local v192

local function showHoverCard(p46) -- line: 859
    -- upvalues: t3 (copy), v18 (ref), formatShort (copy), styleText (copy), describeTool (copy), v192 (ref)
    local Tool = p46.Tool

    if v192 and Tool and v18 then
        local v193, v194, _, v195, v196, v197, _, _, v198 = describeTool(Tool)
        local v199 = Color3.new(1, 1, 1)

        styleText(v192.Title, v193, v199)
        styleText(v192.Kg, v194, v199)
        styleText(v192.Rarity, v195 ~= "" and v195:sub(1, 1):upper() .. v195:sub(2):lower() or "", v196 or v199)

        local v201 = v198 ~= nil and v198 ~= ""

        v192.Income.Size = UDim2.fromOffset(v201 and t3.PERK_W or t3.INCOME_W, v192.Income.Size.Y.Offset)

        if v201 then
            styleText(v192.Income, v198, t3.PERK_COLOR)
        else
            local Copy = Tool:GetAttribute("Copy")

            styleText(v192.Income, Copy and tostring(Copy) .. "x BEST $/s" or v197 and "$" .. formatShort(v197) .. "/s" or "", t3.INCOME_COLOR)
        end

        local Frame = p46.Frame
        local v203 = Frame.AbsolutePosition.X + Frame.AbsoluteSize.X / 2 - t3.CARD_SIZE.X / 2 - v18.AbsolutePosition.X
        local v204 = Frame.AbsolutePosition.Y - t3.CARD_SIZE.Y - 10 - v18.AbsolutePosition.Y
        local v207 = math.clamp(v203, 4, (math.max(4, v18.AbsoluteSize.X - t3.CARD_SIZE.X - 4)))
        local v208 = v192

        v208.Position = UDim2.fromOffset(v207, (math.max(4, v204)))
        v208.Visible = true
    end
end

local function hideHoverCard() -- line: 886
    -- upvalues: v192 (ref)
    if v192 then
        v192.Visible = false
    end
end

local function MakeSlot(p47, p48) -- line: 890
    -- upvalues: v3 (copy), v5 (copy), Value (copy), ContextActionService (copy), v15 (ref), n1 (copy), n2 (copy), t3 (copy), v19 (ref), v21 (ref), v24 (ref), v25 (ref), v26 (ref), Backpack (ref), t4 (copy), v27 (ref), t5 (copy), t6 (copy), t7 (copy), n3 (ref), v28 (ref), v31 (ref), v17 (ref), t10 (ref), t11 (ref), NewGui (copy), UpdateScrollingFrameCanvasSize (copy), MutationDisplay (copy), styledText (copy), styleText (copy), describeTool (copy), v192 (ref), showHoverCard (copy), hideHoverCard (copy), MakeSlot (copy)
    p48 = p48 or #t4 + 1

    local v210 = p48 <= v17
    local t39 = {
        Tool = nil,
        Index = p48,
        Frame = nil
    }
    local v211, v212, v213, v214, v215, connection, v216, v217, v218, v219, v220, v221, v222

    local function UpdateSlotFading() -- line: 919
        -- upvalues: t39 (copy), v211 (ref), v210 (copy), t3 (copy)
        v211.SelectionImageObject = nil

        if t39.Tool ~= nil and t39.Tool:GetAttribute("Favorite") == true then
            local v223 = v211

            v223.BackgroundTransparency = t3.FAV_FADE
            v223.BackgroundColor3 = t3.FAV_COLOR
        elseif v210 then
            local v224 = v211

            v224.BackgroundTransparency = v211.Draggable and t3.SLOT_FADE_OPEN or t3.SLOT_FADE
            v224.BackgroundColor3 = t3.SLOT_COLOR
        else
            local v225 = v211

            v225.BackgroundTransparency = v211.Draggable and t3.TILE_FADE_OPEN or t3.TILE_FADE
            v225.BackgroundColor3 = t3.TILE_COLOR
        end
    end

    local function dressFav(p49) -- line: 936
        -- upvalues: t39 (copy), v219 (ref), v220 (ref), UpdateSlotFading (copy), v210 (copy), t3 (copy)
        local v226 = t39.Tool ~= nil and t39.Tool:GetAttribute("Favorite") == true

        if v226 and p49 and not v220.Visible then
            v220.Pop.Scale = 0
            game:GetService("TweenService"):Create(v220.Pop, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end

        v220.Visible = v226

        if v210 then
            local v227 = v220

            v227.Position = UDim2.new(0, 3, 1, -3)
        else
            local v228 = v220

            v228.Position = v219.Visible and UDim2.new(t3.BADGE_SCALE, 5, 0, 3) or UDim2.new(0, 3, 0, 3)
        end

        UpdateSlotFading()
    end

    function t39.Readjust(_, p51, p52) -- line: 952
        -- upvalues: v211 (ref), n1 (copy), n2 (copy), v19 (ref)
        local v229 = v19.Size.X.Offset / 2
        local v230 = n2 + n1
        local v231 = p51 - (p52 / 2 + 0.5)

        v211.Position = UDim2.fromOffset(v229 - n1 / 2 + v230 * v231, n2)
    end

    function t39.Fill(p53, p54) -- line: 960
        -- upvalues: v211 (ref), v213 (ref), v214 (ref), v215 (ref), connection (ref), v216 (ref), v217 (ref), v218 (ref), v219 (ref), v221 (ref), dressFav (copy), ContextActionService (copy), v15 (ref), t3 (copy), v21 (ref), t4 (copy), v27 (ref), t5 (copy), n3 (ref), v31 (ref), v17 (ref), t10 (ref), UpdateScrollingFrameCanvasSize (copy), MutationDisplay (copy), styleText (copy), describeTool (copy)
        if not p54 then
            return p53:Clear()
        end

        p53.Tool = p54

        local function assignToolData() -- line: 967
            -- upvalues: p54 (copy), v213 (ref), v214 (ref), v216 (ref), v217 (ref), v218 (ref), v219 (ref), v221 (ref), dressFav (copy), t3 (copy), t10 (ref), MutationDisplay (copy), styleText (copy), describeTool (copy)
            local TextureId = p54.TextureId

            v213.Image = TextureId
            v217.Image = TextureId

            local HarpoonSkin = p54:GetAttribute("HarpoonSkin")
            local v233 = HarpoonSkin and t10.skins.ShopIcon(HarpoonSkin)

            if v233 then
                local v234 = v213
                local v235 = v217

                v234.Image = v233
                v235.Image = v233
                t10.view.Unmount(v213)
            elseif HarpoonSkin then
                local v236 = v213
                local v237 = v217

                v236.Image = ""
                v237.Image = ""
                t10.view.Mount(v213, HarpoonSkin, v213.ZIndex)
            else
                HarpoonSkin = TextureId
                t10.view.Unmount(v213)
            end

            if HarpoonSkin == "" then
                v214.Visible = true
            else
                v214.Visible = false
            end

            v214.Text = p54.Name

            local v239, v240, v241, _, _, _, v242, v243 = describeTool(p54)
            local v244 = v218

            v244.Image = v242
            v244.Visible = v242 ~= ""

            local v245 = p54:GetAttribute("Hat") and p54:GetAttribute("Crown") ~= true
            local Cap = p54:GetAttribute("Cap")
            local v246, v247

            if v245 or p54:GetAttribute("Crown") == true then
                v247 = false
            elseif type(Cap) == "string" and game:GetService("ReplicatedStorage"):FindFirstChild("HatProps") then
                local v248 = game:GetService("ReplicatedStorage").HatProps:FindFirstChild(Cap)

                if v248 then
                    v246 = v248
                    v247 = true
                else
                    v247 = false
                end
            else
                v247 = false
            end

            if not v247 then
                v246 = nil
            end

            local v249 = v219

            if p54:GetAttribute("Crown") == true then
                v249.Visible = true
            else
                v249.Visible = v245 or v246 ~= nil
            end

            local v250

            if v246 then
                v250 = v246:GetAttribute("Icon") or ""
            else
                if v245 then
                    v250 = require(game:GetService("ReplicatedStorage").Modules.ThanksgivingConfig).HatIcon(p54:GetAttribute("Hat"))
                end

                if not v245 or not v250 then
                    v250 = t3.CROWN_ICON
                end
            end

            v249.Image = v250
            dressFav(false)

            if v216 then
                if v243 then
                    styleText(v216, v239 .. (v240 ~= "" and " <font color=\"" .. t3.COMMON_KG .. "\">(" .. v240 .. ")</font>" or ""), Color3.new(1, 1, 1))
                else
                    styleText(v216, v239 .. (v240 ~= "" and " (" .. v240 .. ")" or ""), v241)

                    local v255 = MutationDisplay[p54:GetAttribute("Mutation") or ""]

                    if v255 and v255.glow and not v255.cycle and not v216:GetAttribute("Flat") then
                        v216.Edge.Color = v255.glow
                    end
                end
            end

            if not (v221 and p54:IsA("Tool")) then
                return
            end

            local v256 = v221

            v256.Text = p54.ToolTip

            local v257 = v221.TextBounds.X + 6

            v256.Size = UDim2.fromOffset(v257, 16)
            v256.Position = UDim2.new(0.5, -v257 / 2, 0, -25)
        end

        assignToolData()

        if v215 then
            v215:disconnect()
            v215 = nil
        end

        v215 = p54.Changed:connect(function(p55) -- line: 1033
            -- upvalues: assignToolData (copy)
            if p55 == "TextureId" or p55 == "Name" or p55 == "ToolTip" then
                assignToolData()
            end
        end)

        if connection then
            connection:Disconnect()
        end

        connection = p54:GetAttributeChangedSignal("Favorite"):Connect(function() -- line: 1040
            -- upvalues: p53 (copy), dressFav (copy), v17 (ref), t10 (ref)
            dressFav(true)

            if p53.Index > v17 then
                if t10.favMode then
                    t10.favDirty = true
                else
                    t10.resort()
                end
            end
        end)

        local v258 = p53.Index <= v17
        local Visible = v21.Visible

        if not v258 or Visible then
            v211.Draggable = true
        end

        p53:UpdateEquipView()

        if v258 then
            n3 += 1

            if n3 >= 1 and not v15 then
                v15 = true
                ContextActionService:BindAction("BackpackHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
            end
        end

        t5[p54] = p53

        if p53.Index <= v17 then
            v211:SetAttribute("HotbarFish", p54:GetAttribute("Species") ~= nil or nil)
        end

        local v260 = v17
        local v261 = false
        local v262

        for i = 1, v260 do
            local v263 = t4[i]

            if not v263.Tool then
                v262 = v263
                v261 = true
                break
            end
        end

        if not v261 then
            v262 = nil
        end

        v27 = v262

        if p53.Index > v17 and not v31 then
            t10.place(p53, t10.has(p54))
            UpdateScrollingFrameCanvasSize()
        end

        if p53.Index > v17 then
            t10.resort()
        end
    end

    function t39.Clear(p56) -- line: 1089
        -- upvalues: v211 (ref), v213 (ref), v214 (ref), v215 (ref), connection (ref), v216 (ref), v217 (ref), v218 (ref), v219 (ref), v220 (ref), v221 (ref), UpdateSlotFading (copy), ContextActionService (copy), v15 (ref), t4 (copy), v27 (ref), t5 (copy), n3 (ref), v17 (ref), t10 (ref), v192 (ref)
        if p56.Tool then
            if v215 then
                v215:disconnect()
                v215 = nil
            end

            if connection then
                connection:Disconnect()
                connection = nil
            end

            v220.Visible = false
            v213.Image = ""
            v217.Image = ""
            t10.view.Unmount(v213)
            v218.Visible = false
            v219.Visible = false
            v214.Text = ""

            if v216 then
                v216.Text = ""
            end

            if v192 then
                v192.Visible = false
            end

            if v221 then
                local v264 = v221

                v264.Text = ""
                v264.Visible = false
            end

            local v265 = v211

            v265.Draggable = false
            p56:UpdateEquipView(true)

            if p56.Index <= v17 then
                n3 -= 1

                if n3 < 1 then
                    v15 = false
                    ContextActionService:UnbindAction("BackpackHotbarEquip")
                end
            end

            t5[p56.Tool] = nil
            p56.Tool = nil
            v265:SetAttribute("HotbarFish", nil)
            UpdateSlotFading()

            local v266 = v17
            local v267 = false
            local v268

            for i = 1, v266 do
                local v269 = t4[i]

                if not v269.Tool then
                    v268 = v269
                    v267 = true
                    break
                end
            end

            if not v267 then
                v268 = nil
            end

            v27 = v268
        end
    end

    function t39.UpdateEquipView(p57, p58) -- line: 1134
        -- upvalues: t39 (copy), v211 (ref), UpdateSlotFading (copy), v3 (copy), v25 (ref), t11 (ref)
        local Stroke = v211:FindFirstChild("Stroke")
        local v270

        if p58 then
            v270 = false
        else
            local Tool = p57.Tool
            local Active

            if Tool then
                if Tool:IsA("HopperBin") then
                    Active = Tool.Active

                    if not Active then
                        Active = Tool.Parent == v25
                    end
                else
                    Active = Tool.Parent == v25
                end
            else
                Active = Tool
            end

            v270 = not not Active
        end

        if v270 then
            t11 = t39

            if Stroke then
                Stroke.Color = v3
                Stroke.Thickness = 3
                Stroke.Transparency = 0
            end
        elseif Stroke then
            Stroke.Transparency = 1
        end

        UpdateSlotFading()
    end

    function t39.IsEquipped(p59) -- line: 1153
        -- upvalues: v25 (ref)
        local Tool = p59.Tool
        local v273, v274

        if Tool then
            if Tool:IsA("HopperBin") then
                local Active = Tool.Active

                if Active then
                    v273 = Active
                    v274 = true
                else
                    v274 = false
                end
            else
                v274 = false
            end
        else
            v273 = Tool
            v274 = true
        end

        if not v274 then
            v273 = Tool.Parent == v25
        end

        return v273
    end

    function t39.Delete(p60) -- line: 1157
        -- upvalues: v211 (ref), t4 (copy), t7 (copy), t10 (ref), UpdateScrollingFrameCanvasSize (copy)
        t7[v211] = nil
        v211:Destroy()
        table.remove(t4, p60.Index)

        local v275 = #t4

        for i = p60.Index, v275 do
            t4[i]:SlideBack()
        end

        t10.resort()
        UpdateScrollingFrameCanvasSize()
    end

    function t39.Swap(p61, p62) -- line: 1172
        local Tool = p61.Tool
        local Tool2 = p62.Tool

        p61:Clear()

        if Tool2 then
            p62:Clear()
            p61:Fill(Tool2)
        end

        if Tool then
            p62:Fill(Tool)
        else
            p62:Clear()
        end
    end

    function t39.SlideBack(p63) -- line: 1186
        -- upvalues: v211 (ref)
        p63.Index -= 1

        local v276 = v211

        v276.Name = p63.Index
        v276.LayoutOrder = p63.Index
    end

    function t39.TurnNumber(_, p65) -- line: 1192
        -- upvalues: v222 (ref)
        if v222 then
            v222.Visible = p65
        end
    end

    function t39.SetClickability(p66, p67) -- line: 1198
        -- upvalues: v211 (ref), UpdateSlotFading (copy)
        if p66.Tool then
            v211.Draggable = not p67
            UpdateSlotFading()
        end
    end

    function t39.CheckTerms(p68, p69) -- line: 1205
        -- upvalues: v214 (ref), v221 (ref)
        local n11 = 0

        local function checkEm(p70, p71) -- line: 1207
            -- upvalues: n11 (ref)
            local _, v278 = p70:lower():gsub(p71, "")

            n11 += v278
        end

        local Tool = p68.Tool

        if Tool then
            for v279 in pairs(p69) do
                local _, v280 = v214.Text:lower():gsub(v279, "")

                n11 += v280

                if Tool:IsA("Tool") then
                    local _, v281 = (v221 and v221.Text or ""):lower():gsub(v279, "")

                    n11 += v281
                end
            end
        end

        return n11
    end

    function t39.Select(_, p73) -- line: 1225
        -- upvalues: t39 (copy), v25 (ref), v26 (ref), Backpack (ref), v28 (ref), t10 (ref)
        if p73 then
            return
        end

        local Tool = t39.Tool

        if Tool then
            local Active

            if Tool:IsA("HopperBin") then
                Active = Tool.Active

                if not Active then
                    Active = Tool.Parent == v25
                end
            else
                Active = Tool.Parent == v25
            end

            if Active then
                if t10.holdLocked() then
                    return
                end

                if v26 then
                    v26:UnequipTools()

                    if v28 then
                        warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
                    end
                end
            elseif Tool.Parent == Backpack then
                if t10.holdLocked() then
                    return
                end

                if not t10.holdLocked() and v26 then
                    v26:UnequipTools()

                    if v28 then
                        warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
                    end
                end

                if Tool:IsA("HopperBin") then
                    warn((("[Purse] Cannot select '%*' hopper. HopperBin is deprecated and not supported."):format(Tool)))
                else
                    Tool.Parent = v25
                end
            end
        end
    end

    v211 = NewGui("TextButton", p48)

    local SLOT_COLOR = v210 and t3.SLOT_COLOR or t3.TILE_COLOR

    v211.BackgroundColor3 = SLOT_COLOR
    v211.BorderColor3 = v5
    v211.Text = ""
    v211.AutoButtonColor = false
    v211.BorderSizePixel = 0
    v211.Size = v210 and UDim2.fromOffset(n1, n1) or UDim2.fromOffset(t3.INV_TILE, t3.INV_TILE)
    v211.Active = true
    v211.Draggable = false
    v211.BackgroundTransparency = v210 and t3.SLOT_FADE or t3.TILE_FADE
    v211.MouseButton1Click:connect(function() -- line: 1252
        -- upvalues: t39 (copy)
        changeSlot(t39)
    end)
    t39.Frame = v211

    local SLOT_FADE = Instance.new("UICorner")

    SLOT_FADE.CornerRadius = UDim.new(0, t3.SLOT_CORNER)
    SLOT_FADE.Parent = v211
    SLOT_FADE = Instance.new("UIStroke")
    SLOT_FADE.Name = "Stroke"
    SLOT_FADE.Color = v3
    SLOT_FADE.Thickness = 3
    SLOT_FADE.Transparency = 1
    SLOT_FADE.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SLOT_FADE.Parent = v211
    v211.MouseEnter:connect(function() -- line: 1267
        -- upvalues: t39 (copy), v213 (ref), t10 (ref), showHoverCard (copy)
        showHoverCard(t39)
        t10.view.Spin(v213 and v213:FindFirstChild("HarpoonView"))
    end)
    v211.MouseLeave:connect(hideHoverCard)
    v211.SelectionGained:Connect(function() -- line: 1274
        -- upvalues: t39 (copy), v213 (ref), t10 (ref), showHoverCard (copy)
        showHoverCard(t39)
        t10.view.Spin(v213 and v213:FindFirstChild("HarpoonView"))
    end)
    v211.SelectionLost:Connect(hideHoverCard)
    SLOT_FADE = NewGui("Frame", "SelectionObjectClipper")
    SLOT_FADE.Visible = false
    SLOT_FADE.Parent = v211

    local MouseEnter = NewGui("ImageLabel", "Selector")

    MouseEnter.Size = UDim2.fromScale(1, 1)
    MouseEnter.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
    MouseEnter.ScaleType = Enum.ScaleType.Slice
    MouseEnter.SliceCenter = Rect.new(12, 12, 52, 52)
    MouseEnter.Parent = SLOT_FADE

    local HOTBAR_ICON_SCALE

    if v210 then
        HOTBAR_ICON_SCALE = t3.HOTBAR_ICON_SCALE or t3.ICON_SCALE
        SLOT_FADE = 0.5
    else
        HOTBAR_ICON_SCALE = t3.ICON_SCALE
        SLOT_FADE = t3.ICON_Y
    end

    v217 = NewGui("ImageLabel", "IconShadow")
    MouseEnter = Enum.ScaleType.Fit
    v217.ScaleType = MouseEnter
    v217.ImageColor3 = Color3.new(0, 0, 0)
    v217.ImageTransparency = t3.SHADOW_FADE
    v217.AnchorPoint = Vector2.new(0.5, 0.5)
    v217.Position = UDim2.new(0.5, t3.SHADOW_OFFSET.X, SLOT_FADE, t3.SHADOW_OFFSET.Y)
    v217.Size = UDim2.fromScale(HOTBAR_ICON_SCALE, HOTBAR_ICON_SCALE)
    v217.ZIndex = 1
    v217.Parent = v211
    v213 = NewGui("ImageLabel", "Icon")
    MouseEnter = Enum.ScaleType.Fit
    v213.ScaleType = MouseEnter
    v213.AnchorPoint = Vector2.new(0.5, 0.5)
    v213.Position = UDim2.fromScale(0.5, SLOT_FADE)
    v213.Size = UDim2.fromScale(HOTBAR_ICON_SCALE, HOTBAR_ICON_SCALE)
    v213.ZIndex = 2

    if not v210 then
        v216 = styledText(v211, "FishName", t3.NAME_SIZE, UDim2.fromOffset(2, t3.INV_TILE - t3.NAME_BOX - t3.NAME_BOTTOM), UDim2.new(1, -4, 0, t3.NAME_BOX), Enum.TextYAlignment.Bottom, 3)
        v216.RichText = true
    end

    v213.Parent = v211
    v218 = NewGui("ImageLabel", "Badge")
    MouseEnter = Enum.ScaleType.Fit
    v218.ScaleType = MouseEnter
    v218.AnchorPoint = Vector2.new(1, 0)
    v218.Position = UDim2.new(1, -3, 0, 3)
    v218.Size = UDim2.fromScale(t3.BADGE_SCALE, t3.BADGE_SCALE)
    v218.Visible = false
    v218.ZIndex = 5
    v218.Parent = v211
    Instance.new("UIAspectRatioConstraint").Parent = v218
    v219 = NewGui("ImageLabel", "CrownBadge")
    MouseEnter = Enum.ScaleType.Fit
    v219.ScaleType = MouseEnter
    v219.Image = t3.CROWN_ICON
    v219.AnchorPoint = Vector2.new(0, 0)
    v219.Position = UDim2.new(0, 3, 0, 3)
    v219.Size = UDim2.fromScale(t3.BADGE_SCALE, t3.BADGE_SCALE)
    v219.Visible = false
    v219.ZIndex = 5
    v219.Parent = v211
    Instance.new("UIAspectRatioConstraint").Parent = v219
    v220 = NewGui("ImageLabel", "FavStar")
    MouseEnter = Enum.ScaleType.Fit
    v220.ScaleType = MouseEnter
    v220.Image = t3.STAR_ICON
    MouseEnter = t3.STAR_RECT[1]

    local v284 = t3.STAR_RECT[2]

    v220.ImageRectOffset = MouseEnter
    v220.ImageRectSize = v284
    v220.AnchorPoint = v210 and Vector2.new(0, 1) or Vector2.new(0, 0)
    v220.Position = v210 and UDim2.new(0, 3, 1, -3) or UDim2.new(0, 3, 0, 3)
    v220.Size = UDim2.fromScale(t3.BADGE_SCALE, t3.BADGE_SCALE)
    v220.Visible = false
    v220.ZIndex = 5
    v220.Parent = v211
    Instance.new("UIAspectRatioConstraint").Parent = v220
    SLOT_FADE = Instance.new("UIScale")
    SLOT_FADE.Name = "Pop"
    SLOT_FADE.Parent = v220
    v214 = NewGui("TextLabel", "ToolName")

    local v285 = UDim2.new(1, -2, 1, -2)

    v214.Size = v285
    v214.Position = UDim2.fromOffset(1, 1)
    v214.Parent = v211
    t39.Frame.LayoutOrder = t39.Index

    if p48 <= v17 then
        v221 = NewGui("TextLabel", "ToolTip")

        local v286 = v221

        v286.TextWrapped = false
        v286.TextYAlignment = Enum.TextYAlignment.Top
        v286.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        v286.BackgroundTransparency = 0
        v286.Visible = false
        v286.Parent = v211
        v211.MouseEnter:connect(function() -- line: 1368
            -- upvalues: v221 (ref)
            if v221.Text ~= "" then
                v221.Visible = true
            end
        end)
        v211.MouseLeave:connect(function() -- line: 1373
            -- upvalues: v221 (ref)
            v221.Visible = false
        end)

        function t39.MoveToInventory(p74, p75) -- line: 1378
            -- upvalues: t39 (copy), v21 (ref), v24 (ref), v25 (ref), v26 (ref), v28 (ref), v31 (ref), v17 (ref), t10 (ref), MakeSlot (copy)
            local v287 = false
            local v288 = false
            local v289 = false
            local v290 = false
            local v291 = false

            if t39.Index <= v17 then
                v287 = true
            else
                v291 = true
            end

            local Tool, v292

            if v287 then
                Tool = t39.Tool
                p74:Clear()
                v292 = MakeSlot(v24)
                v292:Fill(Tool)

                if p75 then
                    v291 = false
                else
                    v288 = true
                end
            end

            v287 = false

            local v293

            if v288 then
                if Tool then
                    v287 = true
                else
                    v293 = Tool
                    v289 = true
                end
            end

            v288 = false

            if v287 then
                if Tool:IsA("HopperBin") then
                    v288 = true
                else
                    v290 = true
                end
            end

            v287 = false

            if v288 then
                local Active = Tool.Active

                if Active then
                    v293 = Active
                    v289 = true
                else
                    v290 = true
                end
            end

            v288 = false

            if v290 then
                if Tool.Parent == v25 then
                    v287 = true
                else
                    v288 = true
                end
            end

            if v288 then
                v293 = false
                v289 = true
            end

            if v287 then
                v293 = true
                v289 = true
            end

            v287 = false

            if v289 then
                if v293 then
                    v287 = true
                else
                    v291 = false
                end
            end

            v289 = false

            if v287 then
                if t10.holdLocked() then
                    v291 = false
                else
                    v289 = true
                end
            end

            v287 = false

            if v289 then
                if v26 then
                    v287 = true
                else
                    v291 = false
                end
            end

            v289 = false

            if v287 then
                v26:UnequipTools()

                if v28 then
                    v289 = true
                else
                    v291 = false
                end
            end

            if v289 then
                v291 = false
                warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
            end

            if not v291 and v31 then
                v292.Frame.Visible = false
                v292.Parent = v21
            end
        end

        if p48 < 10 or p48 == v17 then
            HOTBAR_ICON_SCALE = if not (p48 < 10) or not p48 then 0 else p48
            v222 = NewGui("TextLabel", "Number")

            local v294 = v222

            v294.Text = HOTBAR_ICON_SCALE
            v294.Font = t3.FONT
            v294.TextSize = 15
            v294.TextXAlignment = Enum.TextXAlignment.Left
            v294.TextYAlignment = Enum.TextYAlignment.Top
            v294.Size = UDim2.fromOffset(20, 18)
            v294.Position = UDim2.fromOffset(5, 2)
            v294.ZIndex = 4
            v294.Visible = false
            v294.Parent = v211
            v285 = Instance.new("UIStroke")
            v285.Color = Color3.new(0, 0, 0)
            v285.Thickness = 2
            v285.Parent = v222

            t6[Value + HOTBAR_ICON_SCALE] = function(p76) -- line: 1414
                -- upvalues: t39 (copy)
                t39:Select(p76)
            end
        end
    end

    local v296 = v211.Position
    local n12 = 0
    local Parent

    v211.DragBegin:connect(function(p77) -- line: 1425
        -- upvalues: v211 (ref), v212 (ref), v214 (ref), v296 (ref), Parent (ref), v21 (ref), v24 (ref), t7 (copy), NewGui (copy)
        t7[v211] = true
        v296 = p77

        local v297 = v211

        v297.BorderSizePixel = 2
        v297.ZIndex = 2
        v214.ZIndex = 2
        v211.Parent.ZIndex = 2
        Parent = v211.Parent

        if Parent ~= v24 then
            return
        end

        local _ = v211.AbsolutePosition
        local v298 = UDim2.new(0, v211.AbsolutePosition.X - v21.AbsolutePosition.X, 0, v211.AbsolutePosition.Y - v21.AbsolutePosition.Y)

        v297.Parent = v21
        v297.Position = v298
        v212 = NewGui("Frame", "FakeSlot")
        v212.LayoutOrder = v211.LayoutOrder
        v212.Size = v211.Size
        v212.BackgroundTransparency = 1
        v212.Parent = v24
    end)
    v211.DragStopped:connect(function(p78, p79) -- line: 1463
        -- upvalues: t39 (copy), v211 (ref), v212 (ref), v214 (ref), v296 (ref), n12 (ref), Parent (ref), v19 (ref), v21 (ref), v25 (ref), v26 (ref), t4 (copy), v27 (ref), t7 (copy), v28 (ref), v31 (ref), v17 (ref), t10 (ref)
        if v212 then
            v212:Destroy()
        end

        local v301 = tick()
        local v302 = v211

        v302.Position = v296
        v302.Parent = Parent
        v302.BorderSizePixel = 0
        v302.ZIndex = 1
        v214.ZIndex = 1
        Parent.ZIndex = 1
        t7[v211] = nil

        if t39.Tool then
            local v303 = v21
            local AbsolutePosition, AbsoluteSize = v303.AbsolutePosition, v303.AbsoluteSize

            if AbsolutePosition.X < p78 and p78 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p79 and p79 <= AbsolutePosition.Y + AbsoluteSize.Y then
                if t39.Index <= v17 then
                    t39:MoveToInventory()
                end

                if t39.Index > v17 and v301 - n12 < 0.5 then
                    if v27 then
                        local Tool = t39.Tool

                        t39:Clear()
                        v27:Fill(Tool)
                        t39:Delete()
                    end

                    n12 = 0
                else
                    n12 = v301
                end
            else
                local v304 = v19
                local AbsolutePosition, AbsoluteSize = v304.AbsolutePosition, v304.AbsoluteSize

                if AbsolutePosition.X < p78 and p78 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p79 and p79 <= AbsolutePosition.Y + AbsoluteSize.Y then
                    local t40 = {
                        1e999,
                        nil
                    }

                    for i = 1, v17 do
                        local v306 = t4[i]
                        local Frame = v306.Frame
                        local v307 = Vector2.new(p78, p79)
                        local magnitude = (Frame.AbsolutePosition + Frame.AbsoluteSize / 2 - v307).magnitude

                        if magnitude < t40[1] then
                            t40 = { magnitude, v306 }
                        end
                    end

                    local v308 = t40[2]

                    if v308 ~= t39 then
                        t39:Swap(v308)

                        if t39.Index > v17 then
                            local Tool = t39.Tool

                            if Tool then
                                local Active

                                if Tool:IsA("HopperBin") then
                                    Active = Tool.Active

                                    if not Active then
                                        Active = Tool.Parent == v25
                                    end
                                else
                                    Active = Tool.Parent == v25
                                end

                                if Active and not t10.holdLocked() and v26 then
                                    v26:UnequipTools()

                                    if v28 then
                                        warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
                                    end
                                end

                                if v31 then
                                    t39.Frame.Visible = false
                                    t39.Frame.Parent = v21
                                end
                            else
                                t39:Delete()
                            end
                        end
                    end
                elseif t39.Index <= v17 then
                    t39:MoveToInventory()
                end

                n12 = v301
            end
        end
    end)
    v211.Parent = p47
    t4[p48] = t39

    if v17 < p48 then
        UpdateScrollingFrameCanvasSize()
    end

    return t39
end

local function OnChildAdded(p80) -- line: 1628
    -- upvalues: t1 (copy), LocalPlayer3 (ref), v21 (ref), v24 (ref), v25 (ref), v26 (ref), Backpack (ref), t4 (copy), v27 (ref), t5 (copy), v28 (ref), v29 (ref), n4 (ref), v17 (ref), t10 (ref), AdjustHotbarFrames (copy), MakeSlot (copy)
    if not (p80:IsA("Tool") or p80:IsA("HopperBin")) then
        if p80:IsA("Humanoid") and p80.Parent == v25 then
            v26 = p80
        end
    else
        if p80.Parent == v25 then
            n4 = tick()
        end

        if v28 and p80.Parent == v25 then
            warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
        end

        local v311, v312

        if v29 then
            v312 = true
        elseif p80.Parent ~= v25 or t5[p80] then
            v312 = true
        else
            local StarterGear = LocalPlayer3:FindFirstChild("StarterGear")

            if StarterGear and StarterGear:FindFirstChild(p80.Name) then
                v29 = true
                v311 = v27 or MakeSlot(v24)
                v312 = false
            else
                v312 = true
            end
        end

        if not v312 then
            for i = v311.Index, 1, -1 do
                local v313 = t4[i]
                local v314 = i - 1

                if v314 > 0 then
                    t4[v314]:Swap(v313)
                else
                    v313:Fill(p80)
                end
            end

            for _, child in pairs(v25:GetChildren()) do
                if child:IsA("Tool") and child ~= p80 then
                    child.Parent = Backpack
                end
            end

            AdjustHotbarFrames()
        else
            local v315 = t5[p80]

            if v315 then
                v315:UpdateEquipView()
            else
                local v316 = t10.front(p80)

                if not v316 then
                    v316 = v27 or MakeSlot(v24)
                    v316:Fill(p80)
                end

                if v316.Index <= v17 and not v21.Visible then
                    AdjustHotbarFrames()
                end

                if p80:IsA("HopperBin") and p80.Active then
                    if not t10.holdLocked() and v26 then
                        v26:UnequipTools()

                        if v28 then
                            warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
                        end
                    end

                    v28 = p80
                end
            end

            t1.BackpackItemAdded:Fire()
        end
    end
end

local function OnChildRemoved(p81) -- line: 1698
    -- upvalues: t1 (copy), v21 (ref), v25 (ref), Backpack (ref), t4 (copy), t5 (copy), v28 (ref), n4 (ref), v17 (ref), AdjustHotbarFrames (copy)
    if not (p81:IsA("Tool") or p81:IsA("HopperBin")) then
        return
    end

    n4 = tick()

    local Parent = p81.Parent

    if Parent == v25 or Parent == Backpack then
        return
    end

    local v317 = t5[p81]

    if v317 then
        v317:Clear()

        if v317.Index > v17 then
            v317:Delete()
        else
            for i = v317.Index + 1, v17 do
                if t4[i].Tool then
                    t4[i]:Swap(t4[i - 1])
                end
            end

            if not v21.Visible then
                AdjustHotbarFrames()
            end
        end
    end

    if p81 == v28 then
        v28 = nil
    end

    t1.BackpackItemRemoved:Fire()

    local v320 = v17 + 1
    local v321 = #t4
    local v322 = false
    local v323

    for i = v320, v321 do
        local v324 = t4[i]

        if v324 and v324.Tool then
            v323 = false
            v322 = true
            break
        end
    end

    if not v322 then
        v323 = true
    end

    if v323 then
        t1.BackpackEmpty:Fire()
    end
end

local function OnCharacterAdded(p82) -- line: 1741
    -- upvalues: LocalPlayer3 (ref), v25 (ref), Backpack (ref), t4 (copy), v28 (ref), t9 (ref), v17 (ref), AdjustHotbarFrames (copy), OnChildAdded (copy), OnChildRemoved (copy)
    for i = #t4, 1, -1 do
        local v325 = t4[i]

        if v325.Tool then
            v325:Clear()
        end

        if v17 < i then
            v325:Delete()
        end
    end

    v28 = nil

    for _, v326 in pairs(t9) do
        v326:disconnect()
    end

    t9 = {}
    v25 = p82

    local t41 = t9

    table.insert(t41, p82.ChildRemoved:connect(OnChildRemoved))

    local t42 = t9

    table.insert(t42, p82.ChildAdded:connect(OnChildAdded))

    for _, child in pairs(p82:GetChildren()) do
        OnChildAdded(child)
    end

    Backpack = LocalPlayer3:WaitForChild("Backpack")

    local t43 = t9

    table.insert(t43, Backpack.ChildRemoved:connect(OnChildRemoved))

    local t44 = t9

    table.insert(t44, Backpack.ChildAdded:connect(OnChildAdded))

    for _, child in pairs(Backpack:GetChildren()) do
        OnChildAdded(child)
    end

    AdjustHotbarFrames()
end

local function OnInputBegan(p83, p84) -- line: 1780
    -- upvalues: t1 (copy), v21 (ref), t6 (copy), v30 (ref)
    if p83.UserInputType == Enum.UserInputType.Keyboard and not v30 then
        local v327 = t6[p83.KeyCode.Value]

        if v327 then
            v327(p84)
        end
    end

    local UserInputType = p83.UserInputType

    if not (p84 or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch) and v21.Visible then
        t1.OpenClose()
    end
end

local function OnUISChanged(p85) -- line: 1803
    -- upvalues: UserInputService (copy), VRService (copy), t4 (copy), v17 (ref)
    if p85 ~= "KeyboardEnabled" and p85 ~= "VREnabled" then
        return
    end

    local KeyboardEnabled = UserInputService.KeyboardEnabled and not VRService.VREnabled

    for i = 1, v17 do
        t4[i]:TurnNumber(KeyboardEnabled)
    end
end

local v329 = nil
local v330

local function v331() -- line: 1815
end

local v332 = Vector2.new(0, 0)

function unbindAllGamepadEquipActions() -- line: 1819
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("BackpackHasGamepadFocus")
    ContextActionService:UnbindAction("BackpackCloseInventory")
end

local function getInputDirection(p86) -- line: 1835
    -- upvalues: v332 (ref)
    local v333 = if p86.UserInputState == Enum.UserInputState.End then -1 else 1

    if p86.KeyCode == Enum.KeyCode.Thumbstick1 then
        local magnitude = p86.Position.magnitude

        v332 = if magnitude > 0.98 then Vector2.new(p86.Position.x / magnitude, -p86.Position.y / magnitude) else Vector2.new(0, 0)
    else
        v332 = if p86.KeyCode == Enum.KeyCode.DPadLeft then Vector2.new(v332.x - v333 * 1, v332.y)
            elseif p86.KeyCode == Enum.KeyCode.DPadRight then Vector2.new(v332.x + v333 * 1, v332.y)
            elseif p86.KeyCode == Enum.KeyCode.DPadUp then Vector2.new(v332.x, v332.y - v333 * 1)
            elseif p86.KeyCode == Enum.KeyCode.DPadDown then Vector2.new(v332.x, v332.y + v333 * 1)
            else Vector2.new(0, 0)
    end

    return v332
end

changeToolFunc = function(_, p88, p89) -- line: 1896
    -- upvalues: v26 (ref), t4 (copy), v28 (ref), v17 (ref), t10 (ref), t11 (ref), v329 (ref), v330 (ref)
    if p88 ~= Enum.UserInputState.Begin then
        return
    end

    local v334 = not v329 or (v329.KeyCode ~= Enum.KeyCode.ButtonR1 or p89.KeyCode ~= Enum.KeyCode.ButtonL1) and (v329.KeyCode ~= Enum.KeyCode.ButtonL1 or p89.KeyCode ~= Enum.KeyCode.ButtonR1)

    if not v334 and tick() - v330 <= 0.06 then
        if not t10.holdLocked() and v26 then
            v26:UnequipTools()

            if v28 then
                warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
            end
        end

        v329 = p89
        v330 = tick()
    else
        v329 = p89
        v330 = tick()
        delay(0.06, function() -- line: 1924
            -- upvalues: p89 (copy), v26 (ref), t4 (copy), v28 (ref), v17 (ref), t10 (ref), t11 (ref), v329 (ref)
            if v329 ~= p89 then
                return
            end

            local v336 = if p89.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1

            for i = 1, v17 do
                if t4[i]:IsEquipped() then
                    local v338 = v336 + i
                    local v339 = false

                    if v17 < v338 then
                        v338 = 1
                        v339 = true
                    elseif v338 < 1 then
                        v338 = v17
                        v339 = true
                    end

                    local v340 = v338

                    while not t4[v340].Tool do
                        v340 += v336

                        if v340 == v338 then
                            return
                        end

                        if v17 < v340 then
                            v340 = 1
                            v339 = true
                        elseif v340 < 1 then
                            v340 = v17
                            v339 = true
                        end
                    end

                    if v339 then
                        if not t10.holdLocked() and v26 then
                            v26:UnequipTools()

                            if v28 then
                                warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
                            end
                        end

                        t11 = nil
                    else
                        t4[v340]:Select()
                    end

                    return
                end
            end

            if t11 and t11.Tool then
                t11:Select()
            else
                for i = v336 == -1 and v17 or 1, if v336 == -1 then 1 else v17, v336 do
                    if t4[i].Tool then
                        t4[i]:Select()

                        return
                    end
                end
            end
        end)
    end
end

function getGamepadSwapSlot() -- line: 1991
    -- upvalues: t4 (copy)
    for i = 1, #t4 do
        if t4[i].Frame.BorderSizePixel > 0 then
            return t4[i]
        end
    end
end

function changeSlot(p90) -- line: 1999
    -- upvalues: GuiService (copy), GamepadService (copy), v22 (ref), v17 (ref), t10 (ref)
    if t10.favMode and p90.Tool and p90.Tool:GetAttribute("Species") and p90.Tool:GetAttribute("BagId") then
        t10.toggleFav(p90.Tool)
    else
        local GamepadCursorEnabled = GamepadService.GamepadCursorEnabled

        if p90.Frame ~= GuiService.SelectedObject or GamepadCursorEnabled then
            p90:Select()
            v22.SelectionImageObject.Visible = false
        else
            local v342 = getGamepadSwapSlot()

            if not v342 then
                local Size, FramePosition = p90.Frame.Size, p90.Frame.Position

                p90.Frame:TweenSizeAndPosition(Size + UDim2.fromOffset(10, 10), FramePosition - UDim2.fromOffset(5, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 2040
                    -- upvalues: p90 (copy), Size (copy), FramePosition (copy)
                    p90.Frame:TweenSizeAndPosition(Size, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
                end)
                p90.Frame.BorderSizePixel = 3
                v22.SelectionImageObject.Visible = true
            else
                v342.Frame.BorderSizePixel = 0

                if v342 ~= p90 then
                    p90:Swap(v342)
                    v22.SelectionImageObject.Visible = false

                    if p90.Index > v17 and not p90.Tool then
                        if GuiService.SelectedObject == p90.Frame then
                            GuiService.SelectedObject = v342.Frame
                        end

                        p90:Delete()
                    end

                    if v342.Index > v17 and not v342.Tool then
                        if GuiService.SelectedObject == v342.Frame then
                            GuiService.SelectedObject = p90.Frame
                        end

                        v342:Delete()
                    end
                end
            end
        end
    end
end

function enableGamepadInventoryControl() -- line: 2060
    -- upvalues: GuiService (copy), t1 (copy), ContextActionService (copy), v19 (ref), v21 (ref), v331 (copy)
    local function v343(_, p92, _) -- line: 2061
        -- upvalues: t1 (copy), v21 (ref)
        if p92 == Enum.UserInputState.Begin then
            if getGamepadSwapSlot() then
                local v344 = getGamepadSwapSlot()

                if v344 then
                    v344.Frame.BorderSizePixel = 0
                end
            elseif v21.Visible then
                t1.OpenClose()
            end
        end
    end

    ContextActionService:BindAction("BackpackHasGamepadFocus", v331, false, Enum.UserInputType.Gamepad1)
    ContextActionService:BindAction("BackpackCloseInventory", v343, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)
    GuiService.SelectedObject = v19:FindFirstChild("1")
end

function disableGamepadInventoryControl() -- line: 2095
    -- upvalues: GuiService (copy), v18 (ref), t4 (copy), v17 (ref)
    unbindAllGamepadEquipActions()

    for i = 1, v17 do
        local v346 = t4[i]

        if v346 and v346.Frame then
            v346.Frame.BorderSizePixel = 0
        end
    end

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(v18) then
        GuiService.SelectedObject = nil
    end
end

local function bindBackpackHotbarAction() -- line: 2110
    -- upvalues: ContextActionService (copy), v15 (ref)
    if not v15 then
        v15 = true
        ContextActionService:BindAction("BackpackHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end
end

local function unbindBackpackHotbarAction() -- line: 2125
    -- upvalues: ContextActionService (copy), v15 (ref)
    disableGamepadInventoryControl()
    v15 = false
    ContextActionService:UnbindAction("BackpackHotbarEquip")
end

function gamepadDisconnected() -- line: 2131
    -- upvalues: VRService (copy), v32 (ref)
    if not VRService.VREnabled then
        v32 = false
        disableGamepadInventoryControl()
    end
end

function gamepadConnected() -- line: 2138
    -- upvalues: GuiService (copy), ContextActionService (copy), VRService (copy), v15 (ref), v18 (ref), v21 (ref), n3 (ref), v32 (ref)
    if VRService.VREnabled then
        return
    end

    v32 = true
    GuiService:AddSelectionParent("BackpackSelection", v18)

    if n3 >= 1 and not v15 then
        v15 = true
        ContextActionService:BindAction("BackpackHotbarEquip", changeToolFunc, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end

    if v21.Visible then
        enableGamepadInventoryControl()
    end
end

local function MakeVRRoundButton(p94, p95) -- line: 2189
    -- upvalues: NewGui (copy)
    local v348 = NewGui("ImageButton", p94)

    v348.Size = UDim2.fromOffset(40, 40)
    v348.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

    local Icon = NewGui("ImageLabel", "Icon")

    Icon.Size = UDim2.fromScale(0.5, 0.5)
    Icon.Position = UDim2.fromScale(0.25, 0.25)
    Icon.Image = p95
    Icon.Parent = v348

    local Selection = NewGui("ImageLabel", "Selection")

    Selection.Size = UDim2.fromScale(0.9, 0.9)
    Selection.Position = UDim2.fromScale(0.05, 0.05)
    Selection.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
    v348.SelectionImageObject = Selection

    return v348, Icon, Selection
end

v18 = NewGui("Frame", "Backpack")

if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
    v18.Parent = ScreenGui
end

v19 = NewGui("Frame", "Hotbar")
v19.Parent = v18

for i = 1, v17 do
    local v349 = MakeSlot(v19, i)

    v349.Frame.Visible = false
    v27 = v27 or v349
end

v20 = NewGui("ImageButton", "OpenInventory")

local MouseButton1Click = UDim2.fromOffset(30, 30)

v20.Size = MouseButton1Click
v20.Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png"
v20.MouseButton1Click:connect(function() -- line: 2239
    -- upvalues: t1 (copy)
    t1.OpenClose()
end)
v20.SelectionGained:connect(function() -- line: 2242
    -- upvalues: v6 (copy), v20 (ref)
    v20.ImageColor3 = v6
end)
v20.SelectionLost:connect(function() -- line: 2245
    -- upvalues: v20 (ref)
    v20.ImageColor3 = Color3.new(1, 1, 1)
end)
MouseButton1Click = NewGui("Frame", "Selection")
MouseButton1Click.Visible = false
v20.SelectionImageObject = MouseButton1Click
MouseButton1Click = MakeVRRoundButton("CloseInventory", "rbxasset://textures/ui/Keyboard/close_button_icon.png")
MouseButton1Click.Position = UDim2.fromOffset(0, -50)
MouseButton1Click.MouseButton1Click:connect(function() -- line: 2255
    -- upvalues: t1 (copy), v21 (ref)
    if v21.Visible then
        t1.OpenClose()
    end
end)
LeftBumperButton = NewGui("ImageLabel", "LeftBumper")
LeftBumperButton.Size = UDim2.fromOffset(40, 40)
LeftBumperButton.Position = UDim2.new(0, -LeftBumperButton.Size.X.Offset, 0.5, -LeftBumperButton.Size.Y.Offset / 2)
RightBumperButton = NewGui("ImageLabel", "RightBumper")
RightBumperButton.Size = UDim2.fromOffset(40, 40)
RightBumperButton.Position = UDim2.new(1, 0, 0.5, -RightBumperButton.Size.Y.Offset / 2)
v21 = NewGui("Frame", "Inventory")
MouseButton1Click = t3.PANEL_FADE
v21.BackgroundTransparency = MouseButton1Click
v21.BackgroundColor3 = t3.PANEL_COLOR
v21.Active = true
v21.Visible = false
v21.Parent = v18
MouseButton1Click = Instance.new("UICorner")
MouseButton1Click.CornerRadius = UDim.new(0, t3.PANEL_CORNER)
MouseButton1Click.Parent = v21
MouseButton1Click = NewGui("TextLabel", "Title")
MouseButton1Click.Text = t3.TITLE_TEXT
MouseButton1Click.Font = t3.FONT
MouseButton1Click.TextSize = 26
MouseButton1Click.TextColor3 = t3.TITLE_COLOR
MouseButton1Click.TextXAlignment = Enum.TextXAlignment.Left
MouseButton1Click.TextWrapped = false
MouseButton1Click.Size = UDim2.new(0.5, 0, 0, 43)
MouseButton1Click.Position = UDim2.fromOffset(14, 0)
MouseButton1Click.Parent = v21
v192 = NewGui("Frame", "HoverCard")
MouseButton1Click = UDim2.fromOffset(t3.CARD_SIZE.X, t3.CARD_SIZE.Y)
v192.Size = MouseButton1Click
v192.BackgroundColor3 = t3.CARD_COLOR
v192.BackgroundTransparency = t3.CARD_FADE
v192.ZIndex = 10
v192.Visible = false
v192.Parent = v18
MouseButton1Click = Instance.new("UICorner")
MouseButton1Click.CornerRadius = UDim.new(0, t3.CARD_CORNER)
MouseButton1Click.Parent = v192
MouseButton1Click = Instance.new("UIStroke")
MouseButton1Click.Color = t3.CARD_STROKE
MouseButton1Click.Thickness = t3.CARD_STROKE_THICKNESS
MouseButton1Click.Parent = v192

local function cardLine(p96, p97, p98, p99, p100, p101) -- line: 2310
    -- upvalues: t3 (copy), styledText (copy), v192 (ref)
    local v351 = styledText(v192, p96, 20, UDim2.fromOffset(t3.CARD_SIZE.X / 2, p99), UDim2.fromOffset(p97, p98), Enum.TextYAlignment.Center, 11)

    v351.AnchorPoint = Vector2.new(0.5, 0.5)
    v351.TextScaled = true
    v351.Edge.Thickness = p101

    if p100 then
        v351:SetAttribute("Flat", true)
    end

    return v351
end

local function divider(p102) -- line: 2318
    -- upvalues: t3 (copy), NewGui (copy), v192 (ref)
    local Divider = NewGui("Frame", "Divider")

    Divider.BackgroundColor3 = t3.DIVIDER_COLOR
    Divider.BackgroundTransparency = 0
    Divider.AnchorPoint = Vector2.new(0.5, 0.5)
    Divider.Position = UDim2.fromOffset(t3.CARD_SIZE.X / 2, p102)
    Divider.Size = UDim2.new(0, 150, 0, 1.5)
    Divider.ZIndex = 11
    Divider.Parent = v192

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Divider
end

cardLine("Title", 140, 40, 30, true, 2)
cardLine("Kg", 56, 24, 59, true, 1.6)
divider(80)
cardLine("Rarity", 120, 34, 102, false, 2)
divider(127)
cardLine("Income", t3.INCOME_W, 46, 152, true, 2.4)
v22 = NewGui("TextButton", "VRInventorySelector")
MouseButton1Click = UDim2.new(0, 0, 0, 0)
v22.Position = MouseButton1Click
v22.Size = UDim2.fromScale(1, 1)
v22.BackgroundTransparency = 1
v22.Text = ""
v22.Parent = v21
MouseButton1Click = NewGui("ImageLabel", "Selector")
MouseButton1Click.Size = UDim2.fromScale(1, 1)
MouseButton1Click.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
MouseButton1Click.ScaleType = Enum.ScaleType.Slice
MouseButton1Click.SliceCenter = Rect.new(12, 12, 52, 52)
MouseButton1Click.Visible = false
v22.SelectionImageObject = MouseButton1Click
v23 = NewGui("ScrollingFrame", "ScrollingFrame")
v23.Selectable = false
v23.CanvasSize = UDim2.new(0, 0, 0, 0)
v23.Parent = v21
v24 = NewGui("Frame", "UIGridFrame")
v24.Selectable = false
v24.Size = UDim2.new(1, -(t3.TILE_GAP * 2), 1, -t3.TILE_GAP)
v24.Position = UDim2.fromOffset(t3.TILE_GAP, t3.TILE_GAP)
v24.Parent = v23
UIGridLayout = Instance.new("UIGridLayout")

local v352 = Enum.SortOrder.LayoutOrder

UIGridLayout.SortOrder = v352
UIGridLayout.CellSize = UDim2.fromOffset(t3.INV_TILE, t3.INV_TILE)
UIGridLayout.CellPadding = UDim2.fromOffset(t3.TILE_GAP, t3.TILE_GAP)
UIGridLayout.Parent = v24

local v353 = MakeVRRoundButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v353.Size = UDim2.fromOffset(34, 34)
v353.Position = UDim2.new(0.5, -v353.Size.X.Offset / 2, 0, 46)
v353.Icon.Position = v353.Icon.Position - UDim2.fromOffset(0, 2)
v353.MouseButton1Click:connect(function() -- line: 2377
    -- upvalues: n1 (copy), n2 (copy), v23 (ref)
    v23.CanvasPosition = Vector2.new(v23.CanvasPosition.X, (math.min(v23.CanvasSize.Y.Offset - v23.AbsoluteWindowSize.Y, (math.max(0, v23.CanvasPosition.Y - (n2 + n1))))))
end)

local v358 = MakeVRRoundButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v358.Rotation = 180
v358.Icon.Position = v358.Icon.Position - UDim2.fromOffset(0, 2)
v358.Size = UDim2.fromOffset(34, 34)
v358.Position = UDim2.new(0.5, -v358.Size.X.Offset / 2, 1, -v358.Size.Y.Offset - 3)
v358.MouseButton1Click:connect(function() -- line: 2394
    -- upvalues: n1 (copy), n2 (copy), v23 (ref)
    v23.CanvasPosition = Vector2.new(v23.CanvasPosition.X, (math.min(v23.CanvasSize.Y.Offset - v23.AbsoluteWindowSize.Y, (math.max(0, v23.CanvasPosition.Y + (n2 + n1))))))
end)
v23.Changed:connect(function(p103) -- line: 2405
    -- upvalues: t3 (copy), v23 (ref), v353 (copy), v358 (copy)
    if p103 ~= "AbsoluteWindowSize" and p103 ~= "CanvasPosition" and p103 ~= "CanvasSize" then
        return
    end

    local v363 = v23.CanvasPosition.Y ~= 0
    local v364 = v23.CanvasPosition.Y < v23.CanvasSize.Y.Offset - v23.AbsoluteWindowSize.Y

    v353.Visible = t3.STOCK_ARROWS and v363
    v358.Visible = t3.STOCK_ARROWS and v364
end)
UpdateBackpackLayout()

if t3.INV_COLUMNS then
    local v365 = workspace.CurrentCamera.ViewportSize.X >= t3.INV_COLUMNS_MIN_W

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 2422
        -- upvalues: t3 (copy), UpdateBackpackLayout (copy), v365 (ref)
        local v366 = workspace.CurrentCamera.ViewportSize.X >= t3.INV_COLUMNS_MIN_W

        if v366 ~= v365 then
            v365 = v366
            UpdateBackpackLayout()
        end
    end)
end

local v367 = "Frame"

MouseButton1Click = function(p104) -- line: 113
    -- upvalues: v367 (copy)
    local v368 = Instance.new(v367)
    local v369

    for v370, v371 in pairs(p104) do
        if type(v370) == "number" then
            v371.Parent = v368
        elseif v370 == "Parent" then
            v369 = v371
        else
            v368[v370] = v371
        end
    end

    if v369 then
        v368.Parent = v369
    end

    return v368
end

v352 = {
    Name = "GamepadHintsFrame",
    BackgroundTransparency = 1,
    Visible = false
}
v352.Size = UDim2.fromOffset(v19.Size.X.Offset, v9 and 95 or 60)
v352.Parent = v18

local v372 = MouseButton1Click(v352)
local t45 = {}

local function hintImageFor(p105) -- line: 2444
    -- upvalues: UserInputService (copy)
    local function v373() -- line: 2445
        -- upvalues: p105 (copy), UserInputService (copy)
        return UserInputService:GetImageForKeyCode(p105)
    end

    local ok, result = pcall(v373)

    if not ok or not result then
        result = ""
    end

    return result
end

local function addGamepadHint(p106, p107) -- line: 2448
    -- upvalues: UserInputService (copy), v9 (copy), v372 (copy), t45 (copy)
    local v374 = "Frame"
    local v380 = (function(p108) -- line: 113
        -- upvalues: v374 (copy)
        local v376 = Instance.new(v374)
        local v377

        for v378, v379 in pairs(p108) do
            if type(v378) == "number" then
                v379.Parent = v376
            elseif v378 == "Parent" then
                v377 = v379
            else
                v376[v378] = v379
            end
        end

        if v377 then
            v376.Parent = v377
        end

        return v376
    end)({
        Name = "HintFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -5),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = v372
    })
    local v381 = "ImageLabel"

    local function v382(p109) -- line: 113
        -- upvalues: v381 (copy)
        local v383 = Instance.new(v381)
        local v384

        for v385, v386 in pairs(p109) do
            if type(v385) == "number" then
                v386.Parent = v383
            elseif v385 == "Parent" then
                v384 = v386
            else
                v383[v385] = v386
            end
        end

        if v384 then
            v383.Parent = v384
        end

        return v383
    end

    local t46 = {
        Name = "HintImage",
        BackgroundTransparency = 1
    }

    t46.Size = v9 and UDim2.fromOffset(90, 90) or UDim2.fromOffset(60, 60)

    local function v387() -- line: 2445
        -- upvalues: p106 (copy), UserInputService (copy)
        return UserInputService:GetImageForKeyCode(p106)
    end

    local ok, result = pcall(v387)

    t46.Image = if not ok or not result then "" else result
    t46.Parent = v380
    table.insert(t45, {
        v382(t46),
        p106
    })

    local v388 = "TextLabel"
    local v394 = (function(p110) -- line: 113
        -- upvalues: v388 (copy)
        local v390 = Instance.new(v388)
        local v391

        for v392, v393 in pairs(p110) do
            if type(v392) == "number" then
                v393.Parent = v390
            elseif v392 == "Parent" then
                v391 = v393
            else
                v390[v392] = v393
            end
        end

        if v391 then
            v390.Parent = v391
        end

        return v390
    end)({
        Name = "HintText",
        BackgroundTransparency = 1,
        TextWrapped = true,
        Position = UDim2.fromOffset(v9 and 100 or 70, 0),
        Size = UDim2.new(1, -(v9 and 100 or 70), 1, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = v9 and Enum.FontSize.Size36 or Enum.FontSize.Size24,
        Text = p107,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = v380
    })

    Instance.new("UITextSizeConstraint", v394).MaxTextSize = v394.TextSize
end

local function resizeGamepadHintsFrame() -- line: 2483
    -- upvalues: v9 (copy), v19 (ref), v21 (ref), v372 (copy)
    v372.Size = UDim2.new(v19.Size.X.Scale, v19.Size.X.Offset, 0, v9 and 95 or 60)
    v372.Position = UDim2.new(v19.Position.X.Scale, v19.Position.X.Offset, v21.Position.Y.Scale, v21.Position.Y.Offset - v372.Size.Y.Offset)

    local Children = v372:GetChildren()
    local n13 = 0

    for i = 1, #Children do
        Children[i].Size = UDim2.new(1, 0, 1, -5)
        Children[i].Position = UDim2.new(0, 0, 0, 0)
        n13 += Children[i].HintText.Position.X.Offset + Children[i].HintText.TextBounds.X
    end

    local v396 = (v372.AbsoluteSize.X - n13) / (#Children - 1)

    for i = 1, #Children do
        local v397 = Children[i]
        local v398 = i == 1
        local v399 = if v398 then UDim2.new(0, 0, 0, 0) else nil

        if not v398 or not v399 then
            v397.Position = UDim2.new(0, Children[i - 1].Position.X.Offset + Children[i - 1].Size.X.Offset + v396, 0, 0)
        else
            v397.Position = v399
        end

        Children[i].Size = UDim2.new(0, Children[i].HintText.Position.X.Offset + Children[i].HintText.TextBounds.X, 1, -5)
    end
end

addGamepadHint(Enum.KeyCode.ButtonX, "Remove From Hotbar")
addGamepadHint(Enum.KeyCode.ButtonA, "Select/Swap")
addGamepadHint(Enum.KeyCode.ButtonB, "Close Backpack")

local Search = NewGui("Frame", "Search")

Search.BackgroundColor3 = t3.SEARCH_COLOR
Search.BackgroundTransparency = t3.SEARCH_FADE
Search.Size = UDim2.fromOffset(125, 26)
Search.Position = UDim2.new(1, -Search.Size.X.Offset - 12, 0, 8)
Search.Parent = v21

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, t3.SLOT_CORNER)
UICorner.Parent = Search

local TextBox = NewGui("TextBox", "TextBox")

TextBox.Text = v7
TextBox.ClearTextOnFocus = false
TextBox.Font = t3.FONT
TextBox.TextSize = 16
TextBox.TextColor3 = t3.TITLE_COLOR
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.Size = UDim2.new(1, -40, 1, 0)
TextBox.Position = UDim2.fromOffset(10, 0)
TextBox.Parent = Search

local X = NewGui("TextButton", "X")

X.Text = "x"
X.TextColor3 = v3
X.FontSize = Enum.FontSize.Size24
X.TextYAlignment = Enum.TextYAlignment.Bottom
X.BackgroundColor3 = Color3.fromRGB(45, 50, 56)
X.BackgroundTransparency = 1
X.Size = UDim2.new(0, Search.Size.Y.Offset - 10, 0, Search.Size.Y.Offset - 10)
X.Position = UDim2.new(1, -X.Size.X.Offset - 10, 0.5, -X.Size.Y.Offset / 2)
X.ZIndex = 0
X.Visible = false
X.BorderSizePixel = 0
X.Parent = Search

local function search() -- line: 2565
    -- upvalues: v21 (ref), v23 (ref), v24 (ref), t4 (copy), v31 (ref), v17 (ref), t10 (ref), UpdateScrollingFrameCanvasSize (copy), TextBox (copy), X (copy)
    local t49 = {}

    for match in TextBox.Text:gmatch("%S+") do
        t49[match:lower()] = true
    end

    local t50 = {}

    for i = v17 + 1, #t4 do
        local v400 = t4[i]

        table.insert(t50, {
            v400,
            (v400:CheckTerms(t49))
        })
        v400.Frame.Visible = false
        v400.Frame.Parent = v21
    end

    table.sort(t50, function(p111, p112) -- line: 2580
        return p111[2] > p112[2]
    end)
    v31 = true

    local n14 = 0

    for _, v401 in ipairs(t50) do
        local v402 = v401[1]

        if v401[2] > 0 and t10.has(v402.Tool) then
            v402.Frame.Visible = true
            v402.Frame.Parent = v24
            n14 += 1
        end
    end

    local v403 = v23

    v403.CanvasPosition = Vector2.new(0, 0)
    UpdateScrollingFrameCanvasSize()
    X.ZIndex = 3
end

local function clearResults() -- line: 2601
    -- upvalues: t4 (copy), v31 (ref), v17 (ref), t10 (ref), UpdateScrollingFrameCanvasSize (copy), X (copy)
    if X.ZIndex > 0 then
        v31 = false

        for i = v17 + 1, #t4 do
            local v404 = t4[i]

            t10.place(v404, t10.has(v404.Tool))
        end

        X.ZIndex = 0
    end

    UpdateScrollingFrameCanvasSize()
end

local function reset() -- line: 2613
    -- upvalues: v7 (ref), TextBox (copy), clearResults (copy)
    clearResults()
    TextBox.Text = v7
end

local function onChanged(p113) -- line: 2618
    -- upvalues: v7 (ref), TextBox (copy), X (copy), search (copy), clearResults (copy)
    if p113 ~= "Text" then
        return
    end

    local Text = TextBox.Text

    if Text == "" then
        clearResults()
    elseif Text ~= v7 then
        search()
    end

    X.Visible = Text ~= "" and Text ~= v7
end

local function onFocused() -- line: 2630
    -- upvalues: v7 (ref), TextBox (copy)
    if TextBox.Text == v7 then
        TextBox.Text = ""
    end
end

local function focusLost(p114) -- line: 2636
    -- upvalues: v7 (ref), TextBox (copy), search (copy)
    if p114 then
        search()
    elseif TextBox.Text == "" then
        TextBox.Text = v7
    end
end

TextBox.Focused:connect(onFocused)
X.MouseButton1Click:connect(reset)
TextBox.Changed:connect(onChanged)
TextBox.FocusLost:connect(focusLost)

local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local Sections = NewGui("Frame", "Sections")

Sections.AnchorPoint = Vector2.new(1, 0)
Sections.Position = UDim2.new(0, -t10.GAP, 0, 0)
Sections.Size = UDim2.new(0, t10.TAB, 1, 0)
Sections.Parent = v21

local Focused = Instance.new("UIListLayout")

Focused.SortOrder = Enum.SortOrder.LayoutOrder
Focused.Padding = UDim.new(0, t10.GAP)
Focused.Parent = Sections

local t52 = {}

local function dressTabs() -- line: 2665
    -- upvalues: t10 (ref), t52 (copy)
    for v406, v407 in pairs(t52) do
        v407.Outline.Transparency = v406 == t10.active and 0 or 1
    end
end

t10.sortMode = "Rarity"
t10.SORTS = {
    Rarity = {
        nextMode = "Rate",
        text = "Rarity"
    },
    Rate = {
        nextMode = "Base",
        text = "Best $/s",
        income = true
    },
    Base = {
        nextMode = "Rarity",
        text = "Best Base\n$/s",
        income = true
    }
}

local Sort = NewGui("ImageButton", "Sort")

Sort.Position = UDim2.new(1, t10.GAP, 0, 0)
Sort.Size = UDim2.fromOffset(t10.TAB, t10.TAB)
Sort.BackgroundColor3 = t3.PANEL_COLOR
Sort.BackgroundTransparency = t3.PANEL_FADE
Sort.Visible = t10.active == "Fish"
Sort.Parent = v21

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, t3.PANEL_CORNER)
UICorner2.Parent = Sort

local function text(p115, p116, p117, p118) -- line: 2694
    -- upvalues: t3 (copy), NewGui (copy), Sort (copy)
    local v408 = NewGui("TextLabel", p115)

    v408.Font = t3.FONT
    v408.TextScaled = true
    v408.TextColor3 = Color3.new(1, 1, 1)
    v408.AnchorPoint = Vector2.new(0.5, p118)
    v408.Position = p116
    v408.Size = p117
    v408.ZIndex = 3
    v408.Parent = Sort

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Thickness = t3.TEXT_STROKE
    UIStroke.Parent = v408

    return v408
end

text("Label", UDim2.fromScale(0.5, 0.05), UDim2.fromScale(0.86, 0.22), 0).Text = "Sort"
text("Mode", UDim2.fromScale(0.5, 0.92), UDim2.fromScale(0.86, 0.42), 1)

local function dressSort() -- line: 2714
    -- upvalues: t3 (copy), t10 (ref), Sort (copy)
    local v409 = t10.SORTS[t10.sortMode]

    Sort.Mode.Text = v409.text
    Sort.Mode.TextColor3 = v409.income and t3.INCOME_COLOR or Color3.new(1, 1, 1)
end

local Favorite = t10.SORTS[t10.sortMode]

Sort.Mode.Text = Favorite.text
Sort.Mode.TextColor3 = Favorite.income and t3.INCOME_COLOR or Color3.new(1, 1, 1)
ButtonHover.Attach(Sort, {
    shine = false
})
Sort.Activated:Connect(function() -- line: 2721
    -- upvalues: t3 (copy), v23 (ref), t10 (ref), v192 (ref), ButtonHover (copy), Sort (copy)
    ButtonHover.Press(Sort)
    t10.sortMode = t10.SORTS[t10.sortMode].nextMode

    local v410 = t10.SORTS[t10.sortMode]

    Sort.Mode.Text = v410.text
    Sort.Mode.TextColor3 = v410.income and t3.INCOME_COLOR or Color3.new(1, 1, 1)

    if v192 then
        v192.Visible = false
    end

    t10.sort()
    v23.CanvasPosition = Vector2.new(0, 0)
end)
t10.favMode = false
Favorite = NewGui("ImageButton", "Favorite")
Favorite.Position = UDim2.new(1, t10.GAP, 0, t10.TAB + t10.GAP)
Favorite.Size = UDim2.fromOffset(t10.TAB, t10.TAB)
Favorite.BackgroundColor3 = t3.PANEL_COLOR
Favorite.BackgroundTransparency = t3.PANEL_FADE
Favorite.Visible = t10.active == "Fish"
Favorite.Parent = v21

local Mode = Instance.new("UICorner")

Mode.CornerRadius = UDim.new(0, t3.PANEL_CORNER)
Mode.Parent = Favorite
Mode = Instance.new("UIStroke")
Mode.Name = "Outline"
Mode.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Mode.Color = Color3.new(1, 1, 1)
Mode.Thickness = 3
Mode.Transparency = 1
Mode.Parent = Favorite
Mode = NewGui("TextLabel", "Label")
Mode.Text = "Favorite"
Mode.Font = t3.FONT
Mode.TextScaled = true
Mode.TextColor3 = Color3.new(1, 1, 1)
Mode.AnchorPoint = Vector2.new(0.5, 0)
Mode.Position = UDim2.fromScale(0.5, 0.05)
Mode.Size = UDim2.fromScale(0.86, 0.22)
Mode.ZIndex = 3
Mode.Parent = Favorite

local INCOME_COLOR = Instance.new("UIStroke")

INCOME_COLOR.Color = Color3.new(0, 0, 0)
INCOME_COLOR.Thickness = t3.TEXT_STROKE
INCOME_COLOR.Parent = Mode
INCOME_COLOR = NewGui("ImageLabel", "Star")
INCOME_COLOR.Image = t3.STAR_ICON

local v412 = t3.STAR_RECT[1]
local v413 = t3.STAR_RECT[2]

INCOME_COLOR.ImageRectOffset = v412
INCOME_COLOR.ImageRectSize = v413
INCOME_COLOR.ScaleType = Enum.ScaleType.Fit
INCOME_COLOR.AnchorPoint = Vector2.new(0.5, 1)
INCOME_COLOR.Position = UDim2.fromScale(0.5, 0.94)
INCOME_COLOR.Size = UDim2.fromScale(0.64, 0.64)
INCOME_COLOR.ZIndex = 3
INCOME_COLOR.Parent = Favorite
t10.favBtn = Favorite

function t10.setFav(p119) -- line: 2782
    -- upvalues: t10 (ref)
    local t54 = t10

    t54.favMode = p119
    t10.favBtn.Outline.Transparency = p119 and 0 or 1

    if p119 or not t10.favDirty then
        return
    end

    t54.favDirty = false
    t10.resort()
end

function t10.toggleFav(p120) -- line: 2791
    -- upvalues: ReplicatedStorage (copy)
    local v414 = p120:GetAttribute("Favorite") ~= true

    p120:SetAttribute("Favorite", v414 or nil)

    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local FavoriteFish = Remotes and Remotes:FindFirstChild("FavoriteFish")

    if FavoriteFish then
        FavoriteFish:FireServer(p120:GetAttribute("BagId"), v414)
    end
end

ButtonHover.Attach(t10.favBtn, {
    shine = false,
    icon = t10.favBtn.Star
})
t10.favBtn.Activated:Connect(function() -- line: 2799
    -- upvalues: t10 (ref), v192 (ref), ButtonHover (copy)
    ButtonHover.Press(t10.favBtn)
    t10.setFav(not t10.favMode)

    if v192 then
        v192.Visible = false
    end
end)
v21:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 2805
    -- upvalues: v21 (ref), t10 (ref)
    if not v21.Visible then
        t10.setFav(false)
    end
end)

local function pick(p121) -- line: 2808
    -- upvalues: v23 (ref), v31 (ref), t10 (ref), AdjustInventoryFrames (copy), v192 (ref), search (copy), t52 (copy), Sort (copy)
    if p121 == t10.active then
        return
    end

    t10.active = p121
    Sort.Visible = p121 == "Fish"
    t10.favBtn.Visible = p121 == "Fish"

    if p121 ~= "Fish" then
        t10.setFav(false)
    end

    for v415, v416 in pairs(t52) do
        v416.Outline.Transparency = v415 == t10.active and 0 or 1
    end

    if v192 then
        v192.Visible = false
    end

    if v31 then
        search()
    else
        AdjustInventoryFrames()

        local v417 = v23

        v417.CanvasPosition = Vector2.new(0, 0)
    end
end

for v418, v419 in ipairs(t10.list) do
    local v420 = NewGui("ImageButton", v419.name)

    v420.LayoutOrder = v418
    v420.Size = UDim2.fromOffset(t10.TAB, t10.TAB)
    v420.BackgroundColor3 = t3.PANEL_COLOR
    v420.BackgroundTransparency = t3.PANEL_FADE
    v420.Parent = Sections

    local Label = Instance.new("UICorner")

    Label.CornerRadius = UDim.new(0, t3.PANEL_CORNER)
    Label.Parent = v420
    Label = Instance.new("UIStroke")
    Label.Name = "Outline"
    Label.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Label.Color = Color3.new(1, 1, 1)
    Label.Thickness = 3
    Label.Parent = v420
    Label = NewGui("TextLabel", "Label")
    Label.Text = v419.name
    Label.Font = t3.FONT
    Label.TextScaled = true
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.Position = UDim2.fromScale(0.5, 0.05)
    Label.Size = UDim2.fromScale(0.86, 0.22)
    Label.ZIndex = 3
    Label.Parent = v420

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Thickness = t3.TEXT_STROKE
    UIStroke.Parent = Label
    UIStroke = NewGui("ImageLabel", "Icon")
    UIStroke.Image = v419.icon
    UIStroke.ScaleType = Enum.ScaleType.Fit
    UIStroke.AnchorPoint = Vector2.new(0.5, 1)
    UIStroke.Position = UDim2.fromScale(0.5, 0.94)
    UIStroke.Size = UDim2.fromScale(0.64, 0.64)
    UIStroke.ZIndex = 3
    UIStroke.Parent = v420
    ButtonHover.Attach(v420, {
        shine = false,
        icon = UIStroke
    })
    v420.Activated:Connect(function() -- line: 2862
        -- upvalues: ButtonHover (copy), pick (copy), v419 (copy), v420 (copy)
        ButtonHover.Press(v420)
        pick(v419.name)
    end)
    t52[v419.name] = v420
end

for v421, v422 in pairs(t52) do
    v422.Outline.Transparency = v421 == t10.active and 0 or 1
end

local function fitTabs() -- line: 2871
    -- upvalues: t10 (ref), Sections (copy), t52 (copy)
    local v423 = #t10.list
    local Y = Sections.AbsoluteSize.Y

    if Y < 10 then
        return
    end

    local v426 = math.min(t10.TAB, (math.floor((Y - t10.GAP * (v423 - 1)) / v423)))

    Sections.Size = UDim2.new(0, v426, 1, 0)

    for _, v427 in pairs(t52) do
        v427.Size = UDim2.fromOffset(v426, v426)
    end
end

Sections:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitTabs)
fitTabs()
t1.StateChanged.Event:connect(function(p122) -- line: 2883
    -- upvalues: v7 (ref), TextBox (copy), X (copy), clearResults (copy)
    X.Modal = p122

    if not p122 then
        clearResults()
        TextBox.Text = v7
    end
end)

t6[Enum.KeyCode.Escape.Value] = function(p123) -- line: 2890
    -- upvalues: t1 (copy), v7 (ref), v21 (ref), TextBox (copy), clearResults (copy)
    if p123 then
        clearResults()
        TextBox.Text = v7
    elseif v21.Visible then
        t1.OpenClose()
    end
end

local function detectGamepad(p124) -- line: 2898
    -- upvalues: VRService (copy), Search (copy)
    if p124 ~= Enum.UserInputType.Gamepad1 or VRService.VREnabled then
        Search.Visible = true
    else
        Search.Visible = false
    end
end

UserInputService.LastInputTypeChanged:connect(detectGamepad)

local function v428(_, p126, _) -- line: 2909
    -- upvalues: GuiService (copy), t4 (copy), v17 (ref)
    if p126 == Enum.UserInputState.Begin and GuiService.SelectedObject then
        for i = 1, v17 do
            if t4[i].Frame == GuiService.SelectedObject and t4[i].Tool then
                t4[i]:MoveToInventory()

                return
            end
        end
    end
end

local function openClose() -- line: 2925
    -- upvalues: t1 (copy), t2 (copy), ContextActionService (copy), UserInputService (copy), v19 (ref), v21 (ref), t4 (copy), t7 (copy), v32 (ref), v17 (ref), AdjustHotbarFrames (copy), v192 (ref), v372 (copy), t45 (copy), resizeGamepadHintsFrame (copy), v428 (copy)
    if not next(t7) then
        local v430 = v21

        v430.Visible = not v21.Visible

        local Visible = v21.Visible

        AdjustHotbarFrames()

        local v431 = v19

        v431.Active = not v19.Active

        local v432 = v17

        for i = 1, v432 do
            t4[i]:SetClickability(not Visible)
        end
    end

    if v21.Visible then
        if v32 then
            if t2[UserInputService:GetLastInputType()] then
                for _, v433 in ipairs(t45) do
                    local v434 = v433[1]
                    local v435 = v433[2]

                    local function v436() -- line: 2445
                        -- upvalues: v435 (copy), UserInputService (copy)
                        return UserInputService:GetImageForKeyCode(v435)
                    end

                    local ok, result = pcall(v436)

                    v434.Image = ok and result or ""
                end

                resizeGamepadHintsFrame()
                v372.Visible = true
            end

            enableGamepadInventoryControl()
        end
    else
        if v32 then
            v372.Visible = false
        end

        disableGamepadInventoryControl()
    end

    if v21.Visible then
        ContextActionService:BindAction("BackpackRemoveSlot", v428, false, Enum.KeyCode.ButtonX)
    else
        ContextActionService:UnbindAction("BackpackRemoveSlot")
    end

    t1.IsOpen = v21.Visible
    t1.StateChanged:Fire(v21.Visible)

    if v192 then
        v192.Visible = false
    end
end

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
t1.OpenClose = openClose

while not LocalPlayer3 do
    wait()
    LocalPlayer3 = Players.LocalPlayer
end

LocalPlayer3.CharacterAdded:connect(OnCharacterAdded)

if LocalPlayer3.Character then
    OnCharacterAdded(LocalPlayer3.Character)
end

for i = 0, 9 do
    table.insert(t8, (tostring(i)))
end

table.insert(t8, "`")
UserInputService.InputBegan:connect(OnInputBegan)
UserInputService.TextBoxFocused:connect(function() -- line: 3001
    -- upvalues: v30 (ref)
    v30 = true
end)
UserInputService.TextBoxFocusReleased:connect(function() -- line: 3004
    -- upvalues: v30 (ref)
    v30 = false
end)

t6[Value2] = function() -- line: 3009
    -- upvalues: v26 (ref), v28 (ref), t10 (ref)
    if v28 then
        if t10.holdLocked() then
            return
        end

        if v26 then
            v26:UnequipTools()

            if v28 then
                warn("[Purse] Cannot deselect active hopper. HopperBin is deprecated and not supported.")
            end
        end
    end
end

UserInputService.Changed:connect(OnUISChanged)

local v438 = UserInputService.KeyboardEnabled and not VRService.VREnabled

for i = 1, v17 do
    t4[i]:TurnNumber(v438)
end

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected()
end

UserInputService.GamepadConnected:connect(function(p128) -- line: 3023
    if p128 == Enum.UserInputType.Gamepad1 then
        gamepadConnected()
    end
end)
UserInputService.GamepadDisconnected:connect(function(p129) -- line: 3028
    if p129 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected()
    end
end)
GuiService.MenuOpened:Connect(function() -- line: 3049
    -- upvalues: t1 (copy)
    if t1.IsOpen then
        t1.OpenClose()
    end
end)

local function OnPreferredTransparencyChanged() -- line: 3066
    -- upvalues: GuiService (copy), v2 (ref), v4 (ref), v8 (ref)
    local PreferredTransparency = GuiService.PreferredTransparency

    v2 = 0.5 * PreferredTransparency
    v4 = 0.5 * PreferredTransparency
    v8 = 0.15 * PreferredTransparency
end

GuiService:GetPropertyChangedSignal("PreferredTransparency"):connect(OnPreferredTransparencyChanged)

return t1
