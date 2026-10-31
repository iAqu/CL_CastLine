local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local BackpackSlotObserver = require(ReplicatedStorage.Modules.BackpackSlotObserver)
local BackpackItemViewport = require(ReplicatedStorage.Modules.BackpackItemViewport)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local LOCAL_PLAYER = Players.LocalPlayer
local BACKPACK_SLOT_CORNER_NAME = "PurseSlotCorner"
local BACKPACK_SLOT_EQUIPPED_STROKE_NAME = "PurseSlotEquippedStroke"
local ITEM_NAME_LABEL_NAME = "ItemNameLabel"
local ITEM_WEIGHT_LABEL_NAME = "ItemWeightLabel"
local BACKPACK_SLOT_CORNER_RADIUS = UDim.new(0.1, 0)
local BACKPACK_SLOT_EQUIPPED_STROKE_COLOR = Color3.fromRGB(90, 142, 233)
local BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_DESKTOP = 7
local BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_MOBILE = 3
local BACKPACK_SLOT_MOBILE_SIZE_CUTOFF = 60
local ITEM_NAME_HEIGHT_SCALE = 0.22
local OVERLAY_MAX_TEXT_SIZE = 14
local ITEM_NAME_MAX_TEXT_SIZE = 18
local BACKPACK_FONT = Enum.Font.FredokaOne

local playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
local trackedToolsByName: { [string]: Tool } = {}
local toolStyleConnections: { [Tool]: { RBXScriptConnection } } = {}
local slotsByTool: { [Tool]: { [TextButton]: boolean } } = {}
local slotTools: { [TextButton]: Tool? } = {}
local dirtySlots: { [TextButton]: boolean } = {}
local slotRefreshScheduled = false
local slotSizeConnections: { [TextButton]: RBXScriptConnection } = {}

local function getEquippedStrokeThickness(slotFrame: TextButton): number
	local size = slotFrame.AbsoluteSize.X
	if size <= 0 then size = slotFrame.Size.X.Offset end
	return if size > 0 and size < BACKPACK_SLOT_MOBILE_SIZE_CUTOFF
		then BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_MOBILE
		else BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_DESKTOP
end

local function setDefaultBackpackEnabled(enabled: boolean)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, enabled)
	end)
end

local function ensureCoreBackpackDisabled()
	if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
		setDefaultBackpackEnabled(false)
	end
end

local function findToolByName(toolName: string): Tool?
	return trackedToolsByName[toolName]
end

local function getSlotTool(slotFrame: TextButton): Tool?
	local reference = slotFrame:FindFirstChild("ToolReference")
	if reference and reference:IsA("ObjectValue") and reference.Value and reference.Value:IsA("Tool") then
		return reference.Value
	end
	local nameLabel = slotFrame:FindFirstChild("ToolName")
	if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text ~= "" then
		return findToolByName(nameLabel.Text)
	end
	return nil
end

local function findTextLabel(slotFrame: TextButton, labelName: string): TextLabel?
	local child = slotFrame:FindFirstChild(labelName)
	if child and child:IsA("TextLabel") then
		return child
	end
	return nil
end

local function ensureTextSizeConstraint(label: TextLabel, maxTextSize: number)
	local constraint = label:FindFirstChildOfClass("UITextSizeConstraint")
	if not constraint then
		constraint = Instance.new("UITextSizeConstraint")
		constraint.Parent = label
	end
	constraint.MinTextSize = 1
	constraint.MaxTextSize = maxTextSize
end

-- Scale-based overlay so 32–45px mobile slots stay aligned. Pixel offsets from
-- the 72px desktop template (e.g. Y=55) fall outside smaller slots.
local function applyOverlayLabel(
	label: TextLabel,
	slotFrame: TextButton,
	anchor: Vector2,
	position: UDim2,
	size: UDim2,
	xAlign: Enum.TextXAlignment,
	zOffset: number,
	maxTextSize: number
)
	label.AnchorPoint = anchor
	label.Position = position
	label.Size = size
	label.TextScaled = true
	label.TextWrapped = true
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.TextXAlignment = xAlign
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.ZIndex = slotFrame.ZIndex + zOffset
	ensureTextSizeConstraint(label, maxTextSize)
end

local function applySlotOverlayLayout(slotFrame: TextButton)
	local weightLabel = findTextLabel(slotFrame, ITEM_WEIGHT_LABEL_NAME)
	if weightLabel then
		applyOverlayLabel(
			weightLabel,
			slotFrame,
			Vector2.new(0.5, 1),
			UDim2.fromScale(0.5, 0.78),
			UDim2.fromScale(0.96, 0.18),
			Enum.TextXAlignment.Center,
			2,
			OVERLAY_MAX_TEXT_SIZE
		)
	end

	local nameLabel = findTextLabel(slotFrame, ITEM_NAME_LABEL_NAME)
	if nameLabel then
		applyOverlayLabel(
			nameLabel,
			slotFrame,
			Vector2.new(0.5, 1),
			UDim2.fromScale(0.5, 1),
			UDim2.fromScale(0.96, ITEM_NAME_HEIGHT_SCALE),
			Enum.TextXAlignment.Center,
			1,
			ITEM_NAME_MAX_TEXT_SIZE
		)
	end
end

local function ensureItemNameLabel(slotFrame: TextButton): TextLabel
	local label = slotFrame:FindFirstChild(ITEM_NAME_LABEL_NAME)
	if label and label:IsA("TextLabel") then
		return label
	end

	if label then
		label:Destroy()
	end

	label = Instance.new("TextLabel")
	label.Name = ITEM_NAME_LABEL_NAME
	label.BackgroundTransparency = 1
	label.Font = BACKPACK_FONT
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.5
	label.Parent = slotFrame

	return label
end

local function ensureItemWeightLabel(slotFrame: TextButton): TextLabel
	local label = slotFrame:FindFirstChild(ITEM_WEIGHT_LABEL_NAME)
	if label and label:IsA("TextLabel") then
		return label
	end
	if label then
		label:Destroy()
	end
	label = Instance.new("TextLabel")
	label.Name = ITEM_WEIGHT_LABEL_NAME
	label.BackgroundTransparency = 1
	label.Font = BACKPACK_FONT
	label.TextColor3 = Color3.fromRGB(255, 238, 130)
	label.TextStrokeTransparency = 0.5
	label.Parent = slotFrame
	return label
end

local function applySlotContentLabels(slotFrame: TextButton)
	local toolNameLabel = slotFrame:FindFirstChild("ToolName")
	if not toolNameLabel or not toolNameLabel:IsA("TextLabel") then
		return
	end

	local tool = getSlotTool(slotFrame)
	if not tool then
		BackpackItemViewport.Clear(slotFrame)
		local nameLabel = slotFrame:FindFirstChild(ITEM_NAME_LABEL_NAME)
		if nameLabel and nameLabel:IsA("TextLabel") then
			nameLabel.Text = ""
			nameLabel.Visible = false
		end
		local weightLabel = slotFrame:FindFirstChild(ITEM_WEIGHT_LABEL_NAME)
		if weightLabel and weightLabel:IsA("TextLabel") then
			weightLabel.Text = ""
			weightLabel.Visible = false
		end
		applySlotOverlayLayout(slotFrame)
		return
	end
	BackpackItemViewport.Show(slotFrame, tool)

	local nameLabel = ensureItemNameLabel(slotFrame)
	local displayName = tool:GetAttribute(ItemToolUtil.DISPLAY_NAME_ATTRIBUTE)
	nameLabel.Text = if typeof(displayName) == "string" then displayName else tool.Name
	nameLabel.Visible = true
	local weightLabel = ensureItemWeightLabel(slotFrame)
	local weight = tool:GetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE)
	weightLabel.Text = if ItemToolUtil.IsItemTool(tool) then WeightFormat.FormatKg(weight) else ""
	weightLabel.Visible = ItemToolUtil.IsItemTool(tool)
	applySlotOverlayLayout(slotFrame)
end

local function applyBackpackSlotStyle(slotFrame: TextButton)
	local corner = slotFrame:FindFirstChild(BACKPACK_SLOT_CORNER_NAME)
	if not corner or not corner:IsA("UICorner") then
		if corner then
			corner:Destroy()
		end

		corner = Instance.new("UICorner")
		corner.Name = BACKPACK_SLOT_CORNER_NAME
		corner.Parent = slotFrame
	end
	corner.CornerRadius = BACKPACK_SLOT_CORNER_RADIUS

	local equippedStroke = slotFrame:FindFirstChild(BACKPACK_SLOT_EQUIPPED_STROKE_NAME)
	if not equippedStroke or not equippedStroke:IsA("UIStroke") then
		if equippedStroke then
			equippedStroke:Destroy()
		end

		equippedStroke = Instance.new("UIStroke")
		equippedStroke.Name = BACKPACK_SLOT_EQUIPPED_STROKE_NAME
		equippedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		equippedStroke.LineJoinMode = Enum.LineJoinMode.Round
		equippedStroke.Parent = slotFrame
	end

	local equippedFrame = slotFrame:FindFirstChild("Equipped")
	if equippedFrame then
		equippedStroke.Color = BACKPACK_SLOT_EQUIPPED_STROKE_COLOR
		equippedStroke.Thickness = getEquippedStrokeThickness(slotFrame)
		equippedStroke.Transparency = 0

		for _, child in ipairs(equippedFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Name == "Edge" then
				child.BackgroundTransparency = 1
			end
		end
	else
		equippedStroke.Transparency = 1
	end

	applySlotContentLabels(slotFrame)
end

local function requestSlotRefresh(slotFrame: TextButton)
	dirtySlots[slotFrame] = true
	if slotRefreshScheduled then
		return
	end
	slotRefreshScheduled = true
	task.defer(function()
		slotRefreshScheduled = false
		local pendingSlots = dirtySlots
		dirtySlots = {}
		for slot in pairs(pendingSlots) do
			if slot.Parent then
				applyBackpackSlotStyle(slot)
			end
		end
	end)
end

local function removeSlotTool(slotFrame: TextButton)
	local tool = slotTools[slotFrame]
	if not tool then
		return
	end
	local slots = slotsByTool[tool]
	if slots then
		slots[slotFrame] = nil
		if next(slots) == nil then
			slotsByTool[tool] = nil
		end
	end
	slotTools[slotFrame] = nil
end

local function updateSlotTool(slotFrame: TextButton)
	if not slotSizeConnections[slotFrame] then
		slotSizeConnections[slotFrame] = slotFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			requestSlotRefresh(slotFrame)
		end)
		slotFrame.Destroying:Once(function()
			local connection = slotSizeConnections[slotFrame]
			if connection then connection:Disconnect(); slotSizeConnections[slotFrame] = nil end
		end)
	end
	removeSlotTool(slotFrame)
	local tool = getSlotTool(slotFrame)
	if tool then
		local slots = slotsByTool[tool] or {}
		slotsByTool[tool] = slots
		slots[slotFrame] = true
		slotTools[slotFrame] = tool
	end
	requestSlotRefresh(slotFrame)
end

local function requestToolSlotsRefresh(tool: Tool)
	local slots = slotsByTool[tool]
	if slots then
		for slotFrame in pairs(slots) do
			requestSlotRefresh(slotFrame)
		end
	end
end

local function setTrackedToolName(tool: Tool, name: string)
	for previousName, tracked in pairs(trackedToolsByName) do
		if tracked == tool and previousName ~= name then trackedToolsByName[previousName] = nil end
	end
	trackedToolsByName[name] = tool
end

local function addTool(tool: Tool)
	setTrackedToolName(tool, tool.Name)
	local connections: { RBXScriptConnection } = {}
	toolStyleConnections[tool] = connections
	table.insert(connections, tool:GetPropertyChangedSignal("Name"):Connect(function()
		setTrackedToolName(tool, tool.Name)
		requestToolSlotsRefresh(tool)
	end))
	for _, attributeName in ipairs({ ItemToolUtil.DISPLAY_NAME_ATTRIBUTE, ItemToolUtil.WEIGHT_ATTRIBUTE, ItemToolUtil.CONDITION_ID_ATTRIBUTE, ItemToolUtil.PRICE_ATTRIBUTE }) do
		table.insert(connections, tool:GetAttributeChangedSignal(attributeName):Connect(function()
			requestToolSlotsRefresh(tool)
		end))
	end
	-- A replicated Tool can appear in the Backpack before its Handle/model.
	-- Re-render when the visual data arrives so the icon fallback is temporary.
	table.insert(connections, tool.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			requestToolSlotsRefresh(tool)
		end
	end))
	requestToolSlotsRefresh(tool)
end

local function removeTool(tool: Tool)
	local connections = toolStyleConnections[tool]
	if connections then
		for _, connection in ipairs(connections) do connection:Disconnect() end
		toolStyleConnections[tool] = nil
	end
	local toolName = tool.Name
	if trackedToolsByName[toolName] == tool then
		trackedToolsByName[toolName] = nil
	end
	requestToolSlotsRefresh(tool)
end

local purseMounted = false

local function applyBackpackFont(instance: Instance)
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		instance.Font = BACKPACK_FONT
	end
end

local function applyBackpackFonts(backpackGui: Instance)
	applyBackpackFont(backpackGui)
	for _, descendant in ipairs(backpackGui:GetDescendants()) do
		applyBackpackFont(descendant)
	end
	backpackGui.DescendantAdded:Connect(applyBackpackFont)
end

LOCAL_PLAYER.CharacterAdded:Connect(function()
	if purseMounted then
		task.defer(ensureCoreBackpackDisabled)
	end
end)

task.spawn(function()
	local backpackGui = playerGui:WaitForChild("BackpackGui", 30)
	local mainFrame = backpackGui and backpackGui:WaitForChild("Backpack", 30)
	if not mainFrame then
		warn("PurseBackpack: Purse backpack UI not mounted within 30s, keeping CoreGui backpack")
		return
	end

	applyBackpackFonts(backpackGui)
	purseMounted = true
	for _ = 1, 20 do
		ensureCoreBackpackDisabled()
		task.wait(0.5)
	end
end)

BackpackSlotObserver.new({
	player = LOCAL_PLAYER,
	playerGui = playerGui,
	isRelevantTool = function(tool: Tool): boolean
		return tool:IsA("Tool")
	end,
	onSlotAdded = updateSlotTool,
	onSlotTextChanged = updateSlotTool,
	onSlotToolChanged = updateSlotTool,
	onSlotRemoving = removeSlotTool,
	onToolAdded = addTool,
	onToolRemoved = removeTool,
})
