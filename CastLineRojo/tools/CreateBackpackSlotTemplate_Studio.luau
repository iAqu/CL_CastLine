-- 一次性构建：StarterGui._GuiTemplates.BackpackSlot
-- 结构与样式对齐 Purse MakeSlot + PurseBackpack.client.lua
--
-- 用法（Roblox Studio 已打开 #AF_DEV，且 Assistant → Manage MCP Servers 已开启）：
-- 1) Cursor Roblox Studio MCP：`execute_luau`（datamodel_type: Edit）粘贴本文件全文；或
-- 2) 在 Studio 命令栏粘贴执行。

local StarterGui = game:GetService("StarterGui")

local TEMPLATES_GUI_NAME = "_GuiTemplates"
local SLOT_TEMPLATE_NAME = "BackpackSlot"

local ICON_SIZE = 72
local FONT_SIZE = 18
local BACKGROUND_COLOR = Color3.fromRGB(31, 31, 31)
local SLOT_BORDER_COLOR = Color3.fromRGB(255, 255, 255)
local SLOT_FADE_LOCKED = 0.35
local SLOT_EQUIP_COLOR = Color3.fromRGB(90, 142, 233)
local SLOT_EQUIP_THICKNESS = 0.1
local BACKPACK_SLOT_CORNER_RADIUS = UDim.new(0.1, 0)
local BACKPACK_SLOT_EQUIPPED_STROKE_COLOR = Color3.fromRGB(90, 142, 233)
local BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS = 7

-- Studio 预览占位：表达各节点用途（Clone 后由 Purse / PurseBackpack 运行时覆盖）
local PLACEHOLDER_ICON_IMAGE = "rbxasset://textures/ui/TopBar/inventoryOn.png"
local PLACEHOLDER_TOOL_NAME = "FoxTool_1"
local PLACEHOLDER_ITEM_NAME = "Golden Fox"
local PLACEHOLDER_ITEM_WEIGHT = "12.5 kg"
local PLACEHOLDER_ITEM_LEVEL = "Lvl 99"
local PLACEHOLDER_TOOLTIP = "Equip tool"
local PLACEHOLDER_HOTBAR_NUMBER = "1"

local function resolvePreviewIconImage()
	local ok, iconId = pcall(function()
		local ReplicatedFirst = game:GetService("ReplicatedFirst")
		local dataHelpers = ReplicatedFirst:FindFirstChild("DataHelpers")
		local animalsHelper = dataHelpers and dataHelpers:FindFirstChild("AnimalsDataHelper")
		if not animalsHelper then
			return nil
		end
		local AnimalsDataHelper = require(animalsHelper)
		return AnimalsDataHelper.GetIconId("Fox")
	end)
	if ok and typeof(iconId) == "string" and iconId ~= "" then
		return iconId
	end
	return PLACEHOLDER_ICON_IMAGE
end

local function applyGuiDefaults(gui)
	gui.BorderColor3 = Color3.new(0, 0, 0)
	gui.BorderSizePixel = 0
	gui.BackgroundTransparency = 1
	gui.Size = UDim2.fromScale(1, 1)
end

local function newTextLabel(name)
	local label = Instance.new("TextLabel")
	label.Name = name
	applyGuiDefaults(label)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Text = ""
	label.Font = Enum.Font.SourceSans
	label.TextSize = FONT_SIZE
	label.TextWrapped = true
	return label
end

local function getOrCreateTemplatesGui()
	local existing = StarterGui:FindFirstChild(TEMPLATES_GUI_NAME)
	if existing and existing:IsA("ScreenGui") then
		return existing
	end
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = TEMPLATES_GUI_NAME
	screenGui.Enabled = false
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 0
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = StarterGui
	return screenGui
end

local function createEquippedFrame(parent)
	local equipped = Instance.new("Frame")
	equipped.Name = "Equipped"
	equipped.BackgroundTransparency = 1
	equipped.Size = UDim2.fromScale(1, 1)
	equipped.ZIndex = parent.ZIndex
	equipped.Parent = parent

	local t = SLOT_EQUIP_THICKNESS
	local edgeData = {
		{ t, 1, 0, 0 },
		{ 1 - 2 * t, t, t, 0 },
		{ t, 1, 1 - t, 0 },
		{ 1 - 2 * t, t, t, 1 - t },
	}

	for _, data in ipairs(edgeData) do
		local edge = Instance.new("Frame")
		edge.Name = "Edge"
		edge.BackgroundTransparency = 1
		edge.BackgroundColor3 = SLOT_EQUIP_COLOR
		edge.Size = UDim2.fromScale(data[1], data[2])
		edge.Position = UDim2.fromScale(data[3], data[4])
		edge.ZIndex = equipped.ZIndex
		edge.BorderSizePixel = 0
		edge.Parent = equipped
	end

	return equipped
end

local function createBackpackSlot(parent)
	local slot = Instance.new("TextButton")
	slot.Name = SLOT_TEMPLATE_NAME
	slot.BackgroundColor3 = BACKGROUND_COLOR
	slot.BackgroundTransparency = SLOT_FADE_LOCKED
	slot.BorderColor3 = SLOT_BORDER_COLOR
	slot.BorderSizePixel = 0
	slot.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
	slot.AutoButtonColor = false
	slot.Active = true
	slot.Draggable = false
	slot.Text = ""
	slot.Font = Enum.Font.SourceSansBold
	slot.TextSize = FONT_SIZE
	slot.TextColor3 = Color3.new(1, 1, 1)
	slot.Parent = parent

	local corner = Instance.new("UICorner")
	corner.Name = "PurseSlotCorner"
	corner.CornerRadius = BACKPACK_SLOT_CORNER_RADIUS
	corner.Parent = slot

	local equippedStroke = Instance.new("UIStroke")
	equippedStroke.Name = "PurseSlotEquippedStroke"
	equippedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	equippedStroke.LineJoinMode = Enum.LineJoinMode.Round
	equippedStroke.Color = BACKPACK_SLOT_EQUIPPED_STROKE_COLOR
	equippedStroke.Thickness = BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS
	equippedStroke.Transparency = 1
	equippedStroke.Parent = slot

	local selectionClipper = Instance.new("Frame")
	selectionClipper.Name = "SelectionObjectClipper"
	selectionClipper.Visible = false
	applyGuiDefaults(selectionClipper)
	selectionClipper.Parent = slot

	local selector = Instance.new("ImageLabel")
	selector.Name = "Selector"
	selector.Size = UDim2.fromScale(1, 1)
	selector.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
	selector.ScaleType = Enum.ScaleType.Slice
	selector.SliceCenter = Rect.new(12, 12, 52, 52)
	selector.BackgroundTransparency = 1
	selector.BorderSizePixel = 0
	selector.Parent = selectionClipper

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.fromScale(0.8, 0.8)
	icon.Position = UDim2.fromScale(0.1, 0.1)
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 0
	icon.Image = resolvePreviewIconImage()
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Parent = slot

	local toolName = newTextLabel("ToolName")
	toolName.Size = UDim2.new(1, -2, 1, -2)
	toolName.Position = UDim2.fromOffset(1, 1)
	toolName.Text = PLACEHOLDER_TOOL_NAME
	toolName.Visible = false -- 有 Icon 时 Purse 会隐藏；模板预览以 Icon 为主
	toolName.Parent = slot

	createEquippedFrame(slot)

	local itemNameLabel = Instance.new("TextLabel")
	itemNameLabel.Name = "ItemNameLabel"
	itemNameLabel.BackgroundTransparency = 1
	itemNameLabel.AnchorPoint = Vector2.new(0.5, 1)
	itemNameLabel.Size = UDim2.fromScale(0.96, 0.22)
	itemNameLabel.Position = UDim2.fromScale(0.5, 1)
	itemNameLabel.Font = Enum.Font.SourceSansBold
	itemNameLabel.TextSize = 17
	itemNameLabel.TextScaled = true
	itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	itemNameLabel.TextStrokeTransparency = 0.5
	itemNameLabel.TextWrapped = true
	itemNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	itemNameLabel.TextXAlignment = Enum.TextXAlignment.Center
	itemNameLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemNameLabel.ZIndex = slot.ZIndex + 1
	itemNameLabel.Visible = true
	itemNameLabel.Text = PLACEHOLDER_ITEM_NAME
	local itemNameConstraint = Instance.new("UITextSizeConstraint")
	itemNameConstraint.MinTextSize = 1
	itemNameConstraint.MaxTextSize = 18
	itemNameConstraint.Parent = itemNameLabel
	itemNameLabel.Parent = slot

	local itemWeightLabel = Instance.new("TextLabel")
	itemWeightLabel.Name = "ItemWeightLabel"
	itemWeightLabel.BackgroundTransparency = 1
	itemWeightLabel.AnchorPoint = Vector2.new(0.5, 1)
	itemWeightLabel.Size = UDim2.fromScale(0.96, 0.18)
	itemWeightLabel.Position = UDim2.fromScale(0.5, 0.78)
	itemWeightLabel.Font = Enum.Font.SourceSansBold
	itemWeightLabel.TextSize = 14
	itemWeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	itemWeightLabel.TextStrokeTransparency = 0.4
	itemWeightLabel.TextScaled = true
	itemWeightLabel.TextWrapped = true
	itemWeightLabel.TextTruncate = Enum.TextTruncate.AtEnd
	itemWeightLabel.TextXAlignment = Enum.TextXAlignment.Center
	itemWeightLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemWeightLabel.ZIndex = slot.ZIndex + 2
	itemWeightLabel.Visible = true
	itemWeightLabel.Text = PLACEHOLDER_ITEM_WEIGHT
	local itemWeightConstraint = Instance.new("UITextSizeConstraint")
	itemWeightConstraint.MinTextSize = 1
	itemWeightConstraint.MaxTextSize = 14
	itemWeightConstraint.Parent = itemWeightLabel
	itemWeightLabel.Parent = slot

	local itemLevelLabel = Instance.new("TextLabel")
	itemLevelLabel.Name = "ItemLevelLabel"
	itemLevelLabel.BackgroundTransparency = 1
	itemLevelLabel.Size = UDim2.fromOffset(48, 18)
	itemLevelLabel.Position = UDim2.fromOffset(2, 2)
	itemLevelLabel.Font = Enum.Font.SourceSansBold
	itemLevelLabel.TextSize = 14
	itemLevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	itemLevelLabel.TextStrokeTransparency = 0.4
	itemLevelLabel.TextScaled = false
	itemLevelLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemLevelLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemLevelLabel.ZIndex = slot.ZIndex + 2
	itemLevelLabel.Visible = false
	itemLevelLabel.Text = PLACEHOLDER_ITEM_LEVEL
	itemLevelLabel.Parent = slot

	local stackCountLabel = Instance.new("TextLabel")
	stackCountLabel.Name = "StackCountLabel"
	stackCountLabel.BackgroundTransparency = 1
	stackCountLabel.Size = UDim2.fromOffset(30, 20)
	stackCountLabel.Position = UDim2.new(1, -32, 0, 2)
	stackCountLabel.AnchorPoint = Vector2.new(0, 0)
	stackCountLabel.Font = Enum.Font.GothamBold
	stackCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	stackCountLabel.TextStrokeTransparency = 0.4
	stackCountLabel.TextSize = 14
	stackCountLabel.TextScaled = true
	stackCountLabel.TextXAlignment = Enum.TextXAlignment.Right
	stackCountLabel.TextYAlignment = Enum.TextYAlignment.Center
	stackCountLabel.ZIndex = slot.ZIndex + 2
	stackCountLabel.Text = ""
	stackCountLabel.Visible = false

	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MaxTextSize = 14
	textSizeConstraint.Parent = stackCountLabel
	stackCountLabel.Parent = slot

	local toolTip = newTextLabel("ToolTip")
	toolTip.TextWrapped = false
	toolTip.TextYAlignment = Enum.TextYAlignment.Top
	toolTip.BackgroundColor3 = Color3.fromRGB(102, 102, 102)
	toolTip.BackgroundTransparency = 0
	toolTip.Text = PLACEHOLDER_TOOLTIP
	toolTip.Visible = false
	toolTip.Parent = slot

	local numberLabel = newTextLabel("Number")
	numberLabel.Size = UDim2.fromScale(0.15, 0.15)
	numberLabel.Text = PLACEHOLDER_HOTBAR_NUMBER
	numberLabel.Visible = true
	numberLabel.Parent = slot

	return slot
end

local templatesGui = getOrCreateTemplatesGui()
templatesGui.Enabled = false
templatesGui.ResetOnSpawn = false

local existingSlot = templatesGui:FindFirstChild(SLOT_TEMPLATE_NAME)
if existingSlot then
	existingSlot:Destroy()
end

local slot = createBackpackSlot(templatesGui)

print("[CreateBackpackSlotTemplate] Created:", slot:GetFullName())
print("[CreateBackpackSlotTemplate] Child count:", #slot:GetChildren())

return {
	path = slot:GetFullName(),
	childNames = (function()
		local names = {}
		for _, child in ipairs(slot:GetChildren()) do
			table.insert(names, child.Name)
		end
		table.sort(names)
		return names
	end)(),
}
