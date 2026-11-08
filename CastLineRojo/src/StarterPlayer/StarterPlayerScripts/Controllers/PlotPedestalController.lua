local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ConditionLabelUtil = require(ReplicatedStorage.Modules.ConditionLabelUtil)
local DropVFXUtil = require(ReplicatedStorage.Modules.DropVFXUtil)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local RarityConfig = require(ReplicatedStorage.Modules.RarityConfig)
local ItemBoundsUtil = require(ReplicatedStorage.Modules.ItemBoundsUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local MutationTitleUtil = require(ReplicatedStorage.Modules.MutationTitleUtil)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlotCashPoolUtil = require(ReplicatedStorage.Modules.PlotCashPoolUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local LOCAL_PLAYER = Players.LocalPlayer
local PROMPT_NAME = "ProximityPrompt"
local TITLE_WEIGHT_COLOR = "#B1DAF8"
local FLOAT_AMPLITUDE = 0.15
local FLOAT_SPEED = 2
local ROTATE_SPEED_DEG = 25
local DISPLAY_ANIMATION_DISTANCE = 160
local DISPLAY_ANIMATION_REFRESH_INTERVAL = 0.25
local MOUNT_TOP_OFFSET = 1
local TITLE_HOME_HEIGHT_OFFSET = 2
local DISPLAY_BOUNDS_OFFSET_ATTRIBUTE = "DisplayBoundsOffset"
local DISPLAY_BOUNDS_SIZE_ATTRIBUTE = "DisplayBoundsSize"

local PlotPedestalController = Knit.CreateController({
	Name = "PlotPedestalController",
})

type Display = {
	model: Model,
	anchor: BasePart,
	title: BillboardGui?,
	baseBoundsCFrame: CFrame,
	boundsToPivot: CFrame,
	baseAnchorPosition: Vector3,
	startTime: number,
}

local boundPedestals: { [Instance]: boolean } = {}
local displays: { [Instance]: Display } = {}
local animatedDisplays: { Display } = {}
local refreshQueued: { [Instance]: boolean } = {}
local promptBusy: { [Instance]: boolean } = {}

local function getSlot(pedestal: Instance): number?
	local slot = pedestal:GetAttribute("Slot")
	if typeof(slot) == "number" then
		return slot
	end
	return tonumber(pedestal.Name:match("_(%d+)$"))
end

local function getPlot(pedestal: Instance): Instance?
	local current: Instance? = pedestal.Parent
	while current do
		if PlotWorkspaceUtil.isValidPlot(current) then
			return current
		end
		current = current.Parent
	end
	return nil
end

local function isOwnedByLocalPlayer(pedestal: Instance): boolean
	local plot = getPlot(pedestal)
	return plot ~= nil and plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId
end

local function getHeldTool(): Tool?
	local character = LOCAL_PLAYER.Character
	return character and character:FindFirstChildOfClass("Tool") or nil
end

local function isPickupHandState(heldTool: Tool?): boolean
	return heldTool == nil
end

local function getPedestalPrompt(pedestal: Instance): ProximityPrompt?
	local promptPart = pedestal:FindFirstChild("PedestalPrompt", true)
	if not promptPart or not promptPart:IsA("BasePart") then
		return nil
	end
	return PromptUtil.Ensure(promptPart, PROMPT_NAME, {
		ActionText = "Place",
		HoldDuration = 0.5,
		MaxActivationDistance = 12,
		RequiresLineOfSight = false,
		Enabled = false,
	})
end

local function hasDisplayedItem(pedestal: Instance): boolean
	return typeof(pedestal:GetAttribute("ItemUid")) == "string" and pedestal:GetAttribute("ItemUid") ~= ""
end

local function refreshPrompt(pedestal: Instance)
	local prompt = getPedestalPrompt(pedestal)
	if not prompt then
		return
	end
	if not isOwnedByLocalPlayer(pedestal) or pedestal:GetAttribute("Owned") == false then
		prompt.Enabled = false
		return
	end

	local heldTool = getHeldTool()
	if ItemToolUtil.IsItemTool(heldTool) then
		prompt.ActionText = hasDisplayedItem(pedestal) and "Swap" or "Place"
		prompt.Enabled = true
		return
	end

	if isPickupHandState(heldTool) and hasDisplayedItem(pedestal) then
		prompt.ActionText = "Pick Up"
		prompt.Enabled = true
		return
	end

	prompt.Enabled = false
end

local function getPedestalBounds(pedestal: Model): (Vector3, Vector3)
	local minimum: Vector3? = nil
	local maximum: Vector3? = nil
	for _, descendant in ipairs(pedestal:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Name ~= "PedestalPrompt" then
			for x = -1, 1, 2 do
				for y = -1, 1, 2 do
					for z = -1, 1, 2 do
						local point = descendant.CFrame:PointToWorldSpace(Vector3.new(
							descendant.Size.X * x * 0.5,
							descendant.Size.Y * y * 0.5,
							descendant.Size.Z * z * 0.5
						))
						if minimum and maximum then
							minimum = Vector3.new(
								math.min(minimum.X, point.X),
								math.min(minimum.Y, point.Y),
								math.min(minimum.Z, point.Z)
							)
							maximum = Vector3.new(
								math.max(maximum.X, point.X),
								math.max(maximum.Y, point.Y),
								math.max(maximum.Z, point.Z)
							)
						else
							minimum = point
							maximum = point
						end
					end
				end
			end
		end
	end
	if not minimum or not maximum then
		local cframe, size = pedestal:GetBoundingBox()
		return cframe.Position, size
	end
	return (minimum + maximum) * 0.5, maximum - minimum
end

local function scaleCFramePosition(cframe: CFrame, scale: number): CFrame
	return CFrame.new(cframe.Position * scale) * cframe.Rotation
end

local function getDisplayBounds(model: Model, scaleFromTemplate: number): (CFrame, Vector3)
	local boundsOffset = model:GetAttribute(DISPLAY_BOUNDS_OFFSET_ATTRIBUTE)
	local boundsSize = model:GetAttribute(DISPLAY_BOUNDS_SIZE_ATTRIBUTE)
	if typeof(boundsOffset) == "CFrame"
		and typeof(boundsSize) == "Vector3"
		and boundsSize.X > 0
		and boundsSize.Y > 0
		and boundsSize.Z > 0
	then
		return model:GetPivot() * scaleCFramePosition(boundsOffset, scaleFromTemplate), boundsSize * scaleFromTemplate
	end
	return ItemBoundsUtil.GetWorldAxisBounds(model)
end

local function resolveDisplayBaseBounds(
	pedestal: Model,
	model: Model,
	scaleFromTemplate: number
): (CFrame, CFrame, Vector3)
	local mountPart = pedestal:FindFirstChild("PedestalPrompt", true)
	local mountCFrame: CFrame? = nil
	if mountPart and mountPart:IsA("BasePart") then
		local _, yaw = mountPart.CFrame:ToEulerAnglesYXZ()
		mountCFrame = CFrame.new(mountPart.Position) * CFrame.Angles(0, yaw, 0)
	end
	local pedestalCenter, pedestalSize = getPedestalBounds(pedestal)
	local targetBottomY = pedestalCenter.Y + pedestalSize.Y * 0.5 + MOUNT_TOP_OFFSET
	local targetCenterXZ = pedestalCenter
	local authoredRotation = model:GetPivot().Rotation

	if mountCFrame then
		model:PivotTo(mountCFrame * authoredRotation)
		targetCenterXZ = mountCFrame.Position
	else
		local _, yaw = pedestal:GetPivot():ToEulerAnglesYXZ()
		model:PivotTo(CFrame.new(pedestalCenter) * CFrame.Angles(0, yaw, 0) * authoredRotation)
	end

	local boundsCFrame, boundsSize = getDisplayBounds(model, scaleFromTemplate)
	local targetCenter = Vector3.new(
		targetCenterXZ.X,
		targetBottomY + boundsSize.Y * 0.5,
		targetCenterXZ.Z
	)
	local placementOffset = targetCenter - boundsCFrame.Position
	model:PivotTo(model:GetPivot() + placementOffset)

	local baseBoundsCFrame = boundsCFrame + placementOffset
	local boundsToPivot = baseBoundsCFrame:ToObjectSpace(model:GetPivot())
	return baseBoundsCFrame, boundsToPivot, boundsSize
end

local function setDisplayPartProperties(model: Model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
end

local function findLabel(gui: BillboardGui, name: string): TextLabel?
	local label = gui:FindFirstChild(name, true)
	return if label and label:IsA("TextLabel") then label else nil
end

local function createTitle(
	anchor: BasePart,
	item,
	weight: number,
	_conditionId: string,
	mutationId: string?
): BillboardGui?
	local titleGui = StarterGui:FindFirstChild("TitleGui")
	local template = titleGui and titleGui:FindFirstChild("ItemTitleTemplate_New")
	if not template or not template:IsA("BillboardGui") then
		return nil
	end
	local title = template:Clone()
	title.Enabled = true
	title.Adornee = anchor

	local nameLabel = findLabel(title, "NameLabel")
	if nameLabel then
		nameLabel.Text = `{item.DisplayName} <font color="{TITLE_WEIGHT_COLOR}">[{WeightFormat.FormatKg(weight)}]</font>`
	end
	local rarityLabel = findLabel(title, "RarityLabel")
	if rarityLabel then
		rarityLabel.Text = RarityConfig.Normalize(item.Rarity)
		GuiUtil.SetRarityGradient(rarityLabel, item.Rarity)
	end
	local priceLabel = findLabel(title, "PriceLabel")
	if priceLabel then
		priceLabel.Visible = false
	end
	local cpsLabel = findLabel(title, "CpsLabel")
	if cpsLabel then
		local cpsPrice = PlotCashPoolUtil.GetCpsPrice(item, MutationDataUtil.GetEarnCashRate(mutationId))
		cpsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(cpsPrice) .. "/s"
		cpsLabel.Visible = true
	end
	local condition = ConditionsData[_conditionId]
	local frame = title:FindFirstChild("Frame")
	if frame then
		ConditionLabelUtil.Show(frame, _conditionId)
		MutationTitleUtil.Show(frame, mutationId)
	end
	local luckLabel = findLabel(title, "LuckLabel")
	if luckLabel then
		local luck = ItemStatUtil.CalculateLuck(item, weight, condition and condition.LuckMult or 1)
		luckLabel.Text = "Luck: " .. ItemStatUtil.FormatLuckPercent(luck)
	end
	title.Parent = anchor
	return title
end

local function destroyDisplay(pedestal: Instance)
	local display = displays[pedestal]
	if display then
		displays[pedestal] = nil
		if display.model.Parent then
			display.model:Destroy()
		end
		if display.anchor.Parent then
			display.anchor:Destroy()
		end
	end

	local plot = getPlot(pedestal)
	local slot = getSlot(pedestal)
	if plot and slot then
		local modelName = "PlotDisplay_" .. tostring(slot)
		local anchorName = "PlotItemTitleAnchor_" .. tostring(slot)
		for _, child in ipairs(plot:GetChildren()) do
			if child.Name == modelName or child.Name == anchorName then
				child:Destroy()
			end
		end
	end
end

local function refreshAnimatedDisplays()
	table.clear(animatedDisplays)
	local character = LOCAL_PLAYER.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root or not root:IsA("BasePart") then
		return
	end

	local rootPosition = root.Position
	local maxDistanceSquared = DISPLAY_ANIMATION_DISTANCE * DISPLAY_ANIMATION_DISTANCE
	for pedestal, display in pairs(displays) do
		if not pedestal.Parent or not display.model.Parent or not display.anchor.Parent then
			destroyDisplay(pedestal)
		else
			local offset = display.baseBoundsCFrame.Position - rootPosition
			local distanceSquared = offset.X * offset.X + offset.Y * offset.Y + offset.Z * offset.Z
			if distanceSquared <= maxDistanceSquared then
				table.insert(animatedDisplays, display)
			end
		end
	end
end

local function rebuildDisplay(pedestal: Instance)
	destroyDisplay(pedestal)
	local itemUid = pedestal:GetAttribute("ItemUid")
	local itemId = pedestal:GetAttribute("ItemId")
	local weight = pedestal:GetAttribute("Weight")
	local conditionId = pedestal:GetAttribute("ConditionId")
	local mutationId = MutationDataUtil.NormalizeMutationId(pedestal:GetAttribute("MutationId"))
	if typeof(itemUid) ~= "string" or itemUid == "" or typeof(itemId) ~= "string" or typeof(weight) ~= "number" then
		return
	end
	local item = ItemsData[itemId]
	local models = ReplicatedStorage:FindFirstChild("Models")
	local itemModels = models and models:FindFirstChild("Items")
	local template = item and itemModels and itemModels:FindFirstChild(item.Model)
	local plot = getPlot(pedestal)
	if not item or not template or not template:IsA("Model") or not plot then
		return
	end

	local model = template:Clone()
	model.Name = "PlotDisplay_" .. tostring(getSlot(pedestal) or 0)
	local templateScale = model:GetScale()
	ItemStatUtil.ScaleModel(model, item, weight)
	local scaleFromTemplate = model:GetScale() / templateScale
	setDisplayPartProperties(model)
	local baseBoundsCFrame, boundsToPivot = resolveDisplayBaseBounds(
		pedestal,
		model,
		scaleFromTemplate
	)
	model.Parent = plot
	MutationVisualUtil.Apply(model, mutationId)
	if item.IsRareReward == 1 then
		DropVFXUtil.AttachRarityPointLight(model, item.Rarity)
	end

	local anchor = Instance.new("Part")
	anchor.Name = "PlotItemTitleAnchor_" .. tostring(getSlot(pedestal) or 0)
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(0.1, 0.1, 0.1)
	anchor.Position = baseBoundsCFrame.Position
	anchor.Parent = plot
	local title = createTitle(
		anchor,
		item,
		weight,
		if typeof(conditionId) == "string" then conditionId else "",
		mutationId
	)
	if title then
		ItemTitlePositionUtil.ApplyBottomOffset(title, model, TITLE_HOME_HEIGHT_OFFSET)
	end

	displays[pedestal] = {
		model = model,
		anchor = anchor,
		title = title,
		baseBoundsCFrame = baseBoundsCFrame,
		boundsToPivot = boundsToPivot,
		baseAnchorPosition = anchor.Position,
		startTime = os.clock(),
	}
end

local function queueRefresh(pedestal: Instance)
	if refreshQueued[pedestal] then
		return
	end
	refreshQueued[pedestal] = true
	task.defer(function()
		refreshQueued[pedestal] = nil
		if pedestal.Parent then
			refreshPrompt(pedestal)
			rebuildDisplay(pedestal)
		end
	end)
end

local function activatePedestal(pedestal: Instance)
	if promptBusy[pedestal] or not isOwnedByLocalPlayer(pedestal) then
		return
	end
	local slot = getSlot(pedestal)
	if not slot then
		return
	end
	local heldTool = getHeldTool()
	local heldItemTool = ItemToolUtil.IsItemTool(heldTool)
	local canPickup = isPickupHandState(heldTool) and hasDisplayedItem(pedestal)
	if not heldItemTool and not canPickup then
		return
	end

	promptBusy[pedestal] = true
	local service = Knit.GetService("PlotPedestalService")
	local request
	if heldItemTool then
		local itemUid = ItemToolUtil.GetInstanceId(heldTool)
		if not itemUid then
			NotificationClient.RedNotify("Hold an item to place")
			promptBusy[pedestal] = nil
			return
		end
		request = service:placeItem(slot, itemUid)
	elseif hasDisplayedItem(pedestal) then
		request = service:pickupItem(slot)
	else
		promptBusy[pedestal] = nil
		return
	end

	request:andThen(function(response)
		if not response or response.ok ~= true then
			NotificationClient.RedNotify((response and response.message) or "Could not update pedestal")
		end
	end):catch(function()
		NotificationClient.RedNotify("Could not update pedestal")
	end):finally(function()
		promptBusy[pedestal] = nil
		refreshPrompt(pedestal)
	end)
end

local function bindPedestal(pedestal: Instance)
	if boundPedestals[pedestal] then
		return
	end
	boundPedestals[pedestal] = true
	local prompt = getPedestalPrompt(pedestal)
	if prompt then
		prompt.Triggered:Connect(function()
			activatePedestal(pedestal)
		end)
	end
	for _, attribute in ipairs({ "ItemUid", "ItemId", "Weight", "ConditionId", "Price", "MutationId", "Owned", "Slot" }) do
		pedestal:GetAttributeChangedSignal(attribute):Connect(function()
			queueRefresh(pedestal)
		end)
	end
	local plot = getPlot(pedestal)
	if plot then
		plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
			refreshPrompt(pedestal)
		end)
	end
	queueRefresh(pedestal)
end

function PlotPedestalController:KnitStart()
	local areas = Workspace:WaitForChild("Areas")
	local plotRoot = areas:WaitForChild("Plot")
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		local pedestals = plot:FindFirstChild("Pedestals")
		if pedestals then
			for _, pedestal in ipairs(pedestals:GetChildren()) do
				if pedestal:IsA("Model") and pedestal.Name:match("^Pedestal_%d+$") then
					bindPedestal(pedestal)
				end
			end
		end
	end
	plotRoot.DescendantAdded:Connect(function(instance)
		if instance:IsA("Model") and instance.Name:match("^Pedestal_%d+$") then
			bindPedestal(instance)
		end
	end)

	local function refreshAllPrompts()
		for pedestal in pairs(boundPedestals) do
			if pedestal.Parent then
				refreshPrompt(pedestal)
			end
		end
	end
	LOCAL_PLAYER.CharacterAdded:Connect(function(character)
		character.ChildAdded:Connect(refreshAllPrompts)
		character.ChildRemoved:Connect(refreshAllPrompts)
		refreshAllPrompts()
	end)
	if LOCAL_PLAYER.Character then
		LOCAL_PLAYER.Character.ChildAdded:Connect(refreshAllPrompts)
		LOCAL_PLAYER.Character.ChildRemoved:Connect(refreshAllPrompts)
	end

	local animationRefreshElapsed = DISPLAY_ANIMATION_REFRESH_INTERVAL
	RunService.RenderStepped:Connect(function(deltaTime)
		animationRefreshElapsed += deltaTime
		if animationRefreshElapsed >= DISPLAY_ANIMATION_REFRESH_INTERVAL then
			animationRefreshElapsed = 0
			refreshAnimatedDisplays()
		end
		local time = os.clock()
		for _, display in ipairs(animatedDisplays) do
			if display.model.Parent and display.anchor.Parent then
				local elapsed = time - display.startTime
				local offset = (math.sin(elapsed * FLOAT_SPEED) + 1) * FLOAT_AMPLITUDE
				local rotation = math.rad(elapsed * ROTATE_SPEED_DEG)
				local animatedBoundsCFrame = (display.baseBoundsCFrame + Vector3.new(0, offset, 0))
					* CFrame.Angles(0, rotation, 0)
				display.model:PivotTo(animatedBoundsCFrame * display.boundsToPivot)
				display.anchor.Position = display.baseAnchorPosition + Vector3.new(0, offset, 0)
				if display.title then
					ItemTitlePositionUtil.ApplyBottomOffset(display.title, display.model, TITLE_HOME_HEIGHT_OFFSET)
				end
			end
		end
	end)
end

return PlotPedestalController
