local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)
local StarterGui = game:GetService("StarterGui")

local FishTitleUtil = require(ReplicatedStorage.Modules.FishTitleUtil)
local ItemBoundsUtil = require(ReplicatedStorage.Modules.ItemBoundsUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local ItemToolUtil = {}

ItemToolUtil.KIND_ATTRIBUTE = "InventoryKind"
ItemToolUtil.INSTANCE_ID_ATTRIBUTE = "ItemInstanceId"
ItemToolUtil.ITEM_ID_ATTRIBUTE = "ItemId"
ItemToolUtil.DISPLAY_NAME_ATTRIBUTE = "DisplayName"
ItemToolUtil.WEIGHT_ATTRIBUTE = "Weight"
ItemToolUtil.PRICE_ATTRIBUTE = "Price"
ItemToolUtil.MUTATION_ID_ATTRIBUTE = "MutationId"
ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE = "ItemVisualPivotOffset"
ItemToolUtil.FISH_CARRY_GRIP_ATTRIBUTE = "FishCarryGrip"
ItemToolUtil.FISH_CARRY_SPAN_ATTRIBUTE = "FishCarrySpan"

-- Keep carried items slightly in front of the hand after anchoring their bottom.
local HELD_ITEM_REAR_GRIP_RATIO = 0.1
local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)
local FISH_CARRY_ROTATION = CFrame.Angles(0, math.pi / 2, 0)
local HELD_ITEM_TITLE_NAME = "HeldItemTitle"
local HELD_ITEM_TITLE_ANCHOR_NAME = "HeldItemTitleAnchor"
local TITLE_WEIGHT_COLOR = "#B1DAF8"
local TOOLTIP_PRICE_COLOR = "#FFBD30"

export type ItemConfig = {
	ItemID: string,
	DisplayName: string,
	Rarity: string,
	Model: string,
	DefaultPrice: number,
	CpsPrice: number,
	DefaultWeight: number,
	ModelDefaultScale: number?,
	MinWeight: number,
	MaxWeight: number,
	SpecialLuckMult: number,
	Icon: string,
}

export type ItemInstanceData = {
	Weight: number,
	PaidOrigin: string?,
	Price: number,
	MutationId: string?,
}

function ItemToolUtil.IsItemTool(tool: Instance?): boolean
	return tool ~= nil and tool:IsA("Tool") and tool:GetAttribute(ItemToolUtil.KIND_ATTRIBUTE) == "Item"
end

function ItemToolUtil.GetInstanceId(tool: Instance?): string?
	if not ItemToolUtil.IsItemTool(tool) then
		return nil
	end
	local value = tool:GetAttribute(ItemToolUtil.INSTANCE_ID_ATTRIBUTE)
	return if typeof(value) == "string" then value else nil
end

local function getBottomRearGrip(visual: Model, handle: BasePart): CFrame
	local boundsCFrame, boundsSize = ItemBoundsUtil.GetWorldAxisBounds(visual)
	local bottomRearPoint = boundsCFrame * CFrame.new(
		0,
		-boundsSize.Y / 2,
		boundsSize.Z * HELD_ITEM_REAR_GRIP_RATIO
	)
	return handle.CFrame:ToObjectSpace(bottomRearPoint * FRONT_FACING_ROTATION)
end

local function setFishCarryGrip(tool: Tool, visual: Model, handle: BasePart)
	local bounds = ItemStatUtil.GetModelBounds(visual)
	local center = (bounds.minimum + bounds.maximum) * 0.5
	local belly = Vector3.new(center.X, bounds.minimum.Y, center.Z)
	local body = if visual.PrimaryPart then visual.PrimaryPart.CFrame else visual:GetPivot()
	-- RightGrip.C1 is in Handle space. Its inverse places the belly across the palms.
	tool:SetAttribute(
		ItemToolUtil.FISH_CARRY_GRIP_ATTRIBUTE,
		handle.CFrame:ToObjectSpace(body * CFrame.new(belly) * FISH_CARRY_ROTATION:Inverse())
	)
	tool:SetAttribute(ItemToolUtil.FISH_CARRY_SPAN_ATTRIBUTE, bounds.maximum.Z - bounds.minimum.Z)
end

local function attachVisualPartsToTool(tool: Tool, visual: Model, handle: BasePart)
	local rigRoot = visual.PrimaryPart
	local animations = visual:FindFirstChild("Animations")
	handle.Parent = tool

	local visualParts: { BasePart } = {}
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(visualParts, descendant)
		end
	end

	for _, part in ipairs(visualParts) do
		part.Parent = tool
		local weld = Instance.new("WeldConstraint")
		weld.Name = "ItemVisualWeld"
		weld.Part0 = handle
		weld.Part1 = part
		weld.Parent = handle
	end

	tool.PrimaryPart = rigRoot or handle
	if animations then
		animations.Parent = tool
	end
	visual:Destroy()
end

local function createHeldItemTitle(
	visual: Model,
	handle: BasePart,
	item: ItemConfig,
	instanceData: ItemInstanceData,
	owner: Player?
)
	local titleGui = StarterGui:FindFirstChild("TitleGui")

	local titleAnchor = Instance.new("Attachment")
	titleAnchor.Name = HELD_ITEM_TITLE_ANCHOR_NAME
	titleAnchor.Position = Vector3.zero
	titleAnchor.Parent = handle

	local title = FishTitleUtil.Create(titleGui, item, instanceData.MutationId, owner, instanceData.Weight)
	if not title then
		warn("ItemToolUtil: missing held fish title template")
		return
	end
	title.Name = HELD_ITEM_TITLE_NAME
	title.Adornee = titleAnchor
	title.Enabled = true
	title.Parent = titleAnchor
	ItemTitlePositionUtil.ApplyBottomOffset(title, visual)
end

function ItemToolUtil.Create(instanceId: string, item: ItemConfig, instanceData: ItemInstanceData, owner: Player?): Tool?
	local template = FishingAssets.GetFish(item.Model)
	if not template then
		warn("ItemToolUtil: missing item model", item.Model)
		if not instanceData.PaidOrigin then
			return nil
		end
	end

	local tool = Instance.new("Tool")
	tool.Name = "Item_" .. instanceId
	tool.ToolTip = string.format(
		"%s | <font color=\"%s\">%s</font> | <font color=\"%s\">$%s</font>",
		item.DisplayName,
		TITLE_WEIGHT_COLOR,
		WeightFormat.FormatKgCompact(instanceData.Weight),
		TOOLTIP_PRICE_COLOR,
		NumberUtil.FormatItemPriceCompact(instanceData.Price)
	)
	tool.TextureId = item.Icon
	tool.CanBeDropped = false
	tool.RequiresHandle = true
	tool:SetAttribute(ItemToolUtil.KIND_ATTRIBUTE, "Item")
	tool:SetAttribute(ItemToolUtil.INSTANCE_ID_ATTRIBUTE, instanceId)
	tool:SetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE, item.ItemID)
	tool:SetAttribute(ItemToolUtil.DISPLAY_NAME_ATTRIBUTE, item.DisplayName)
	tool:SetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE, instanceData.Weight)
	tool:SetAttribute("PaidOrigin", instanceData.PaidOrigin)
	tool:SetAttribute(ItemToolUtil.PRICE_ATTRIBUTE, instanceData.Price)
	tool:SetAttribute(ItemToolUtil.MUTATION_ID_ATTRIBUTE, instanceData.MutationId)

	local visual
	if template then
		visual = template:Clone()
		MutationVisualUtil.ApplyAppearance(visual, instanceData.MutationId, template.Name)
		ItemStatUtil.ScaleModel(visual, item, instanceData.Weight, template)
	else
		-- A paid fish still has a usable inventory icon while its world model is unavailable.
		visual = Instance.new("Model")
		local fallback = Instance.new("Part")
		fallback.Name = "Handle"
		fallback.Size = Vector3.one
		fallback.Transparency = 1
		fallback.Parent = visual
		visual.PrimaryPart = fallback
	end
	local handle = visual:FindFirstChild("Handle", true)
	if not handle or not handle:IsA("BasePart") then
		local gripPart = visual:FindFirstChildWhichIsA("BasePart", true)
		if gripPart then
			-- Preserve the original mesh name so the fish clips can still bind to it.
			handle = Instance.new("Part")
			handle.Name = "Handle"
			handle.CFrame, handle.Size = gripPart.CFrame, gripPart.Size
			handle.Transparency = 1
			handle.CastShadow = false
			handle.CanCollide, handle.CanTouch, handle.CanQuery, handle.Massless = false, false, false, true
		end
	end
	if not handle or not handle:IsA("BasePart") then
		visual:Destroy()
		tool:Destroy()
		warn("ItemToolUtil: model has no BasePart", item.Model)
		return nil
	end
	tool:SetAttribute(
		ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE,
		handle.CFrame:ToObjectSpace(visual:GetPivot())
	)

	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
		end
	end
	createHeldItemTitle(visual, handle, item, instanceData, owner)
	visual.Parent = tool
	tool.Grip = getBottomRearGrip(visual, handle)
	setFishCarryGrip(tool, visual, handle)
	-- Equipped Tools replicate their direct parts reliably to the owning client.
	-- Keep every visual part beside Handle and weld it into the Tool assembly.
	attachVisualPartsToTool(tool, visual, handle)
	MutationVisualUtil.Apply(tool, instanceData.MutationId)
	return tool
end

return ItemToolUtil
