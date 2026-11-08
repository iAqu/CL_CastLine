local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ConditionLabelUtil = require(ReplicatedStorage.Modules.ConditionLabelUtil)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local RarityConfig = require(ReplicatedStorage.Modules.RarityConfig)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationTitleUtil = require(ReplicatedStorage.Modules.MutationTitleUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local LOCAL_PLAYER = Players.LocalPlayer
local VISUAL_NAME = "HeldItemVisual"
local HELD_ITEM_TITLE_NAME = "HeldItemTitle"
local HELD_ITEM_TITLE_ANCHOR_NAME = "HeldItemTitleAnchor"
local LOCAL_TITLE_NAME = "LocalHeldItemTitle"
local TITLE_TEMPLATE_NAME = "ItemTitleTemplate_New"
local TITLE_WEIGHT_COLOR = "#B1DAF8"

type HeldItemDescriptor = {
	kind: "potion",
	identifier: string,
}

local HeldItemVisualController = Knit.CreateController({
	Name = "HeldItemVisualController",
})

local lastDescriptorKey: string? = nil
local localHeldItemTitle: BillboardGui? = nil
local trackedItemTools: { [Tool]: boolean } = {}
local boundTitleCharacters: { [Model]: boolean } = {}

local function descriptorForTool(tool: Instance): HeldItemDescriptor?
	if PotionToolUtil.IsPotionTool(tool) then
		local potionId = PotionToolUtil.GetPotionId(tool)
		if potionId then
			return { kind = "potion", identifier = potionId }
		end
	end
	return nil
end

local function getEquippedDescriptor(character: Model?): HeldItemDescriptor?
	if not character then
		return nil
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			local descriptor = descriptorForTool(child)
			if descriptor then
				return descriptor
			end
		end
	end

	return nil
end

local function hideVisualForLocalPlayer(visual: Model)
	local function hidePart(instance: Instance)
		if instance:IsA("BasePart") then
			instance.LocalTransparencyModifier = 1
		elseif instance:IsA("ParticleEmitter")
			or instance:IsA("Trail")
			or instance:IsA("Beam")
			or instance:IsA("Highlight")
		then
			instance.Enabled = false
		end
	end

	for _, descendant in ipairs(visual:GetDescendants()) do
		hidePart(descendant)
	end
	visual.DescendantAdded:Connect(hidePart)
end

local function isHeldItemVisual(instance: Instance): boolean
	return instance:IsA("Model") and instance.Name == VISUAL_NAME
end

local function findLabel(gui: BillboardGui, name: string): TextLabel?
	local label = gui:FindFirstChild(name, true)
	return if label and label:IsA("TextLabel") then label else nil
end

local function clearLocalHeldItemTitle()
	if localHeldItemTitle then
		localHeldItemTitle:Destroy()
		localHeldItemTitle = nil
	end
end

local function getLocalTitleTemplate(): BillboardGui?
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	local titleGui = playerGui and playerGui:FindFirstChild("TitleGui")
	local template = titleGui and titleGui:FindFirstChild(TITLE_TEMPLATE_NAME)
	return if template and template:IsA("BillboardGui") then template else nil
end

local function getHeldTitleAdornee(tool: Tool): Instance?
	local character = tool.Parent
	if not character or not character:IsA("Model") then
		return nil
	end

	local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
	if not hand or not hand:IsA("BasePart") then
		return nil
	end
	local gripAttachment = hand:FindFirstChild("RightGripAttachment")
	if gripAttachment and gripAttachment:IsA("Attachment") then
		return gripAttachment
	end
	return hand
end

local function createLocalHeldItemTitle(tool: Tool)
	clearLocalHeldItemTitle()
	if not ItemToolUtil.IsItemTool(tool) then
		return
	end

	local titleAnchor = tool:FindFirstChild(HELD_ITEM_TITLE_ANCHOR_NAME, true)
	if not titleAnchor or not titleAnchor:IsA("Attachment") then
		return
	end
	local template = getLocalTitleTemplate()
	if not template then
		return
	end
	local heldTitleAdornee = getHeldTitleAdornee(tool)
	if not heldTitleAdornee then
		return
	end

	local serverTitle = titleAnchor:FindFirstChild(HELD_ITEM_TITLE_NAME)
	if serverTitle and serverTitle:IsA("BillboardGui") then
		serverTitle.Enabled = false
	end

	local itemId = tool:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)
	local weight = tool:GetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE)
	local conditionId = tool:GetAttribute(ItemToolUtil.CONDITION_ID_ATTRIBUTE)
	local price = tool:GetAttribute(ItemToolUtil.PRICE_ATTRIBUTE)
	local item = if typeof(itemId) == "string" then ItemsData[itemId] else nil
	if not item
		or typeof(weight) ~= "number"
		or typeof(conditionId) ~= "string"
		or typeof(price) ~= "number"
	then
		return
	end

	local title = template:Clone()
	title.Name = LOCAL_TITLE_NAME
	title.Adornee = heldTitleAdornee
	title.Enabled = true

	local nameLabel = findLabel(title, "NameLabel")
	if nameLabel then
		nameLabel.RichText = true
		nameLabel.Text = `{item.DisplayName} <font color="{TITLE_WEIGHT_COLOR}">[{WeightFormat.FormatKg(weight)}]</font>`
	end
	local rarityLabel = findLabel(title, "RarityLabel")
	if rarityLabel then
		rarityLabel.Text = RarityConfig.Normalize(item.Rarity)
		GuiUtil.SetRarityGradient(rarityLabel, item.Rarity)
	end
	local priceLabel = findLabel(title, "PriceLabel")
	if priceLabel then
		priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(price)
	end
	local frame = title:FindFirstChild("Frame")
	if frame then
		ConditionLabelUtil.Show(frame, conditionId)
		MutationTitleUtil.Show(frame, tool:GetAttribute(ItemToolUtil.MUTATION_ID_ATTRIBUTE))
	end
	local luckLabel = findLabel(title, "LuckLabel")
	if luckLabel then
		local condition = ConditionsData[conditionId]
		local luck = ItemStatUtil.CalculateLuck(item, weight, condition and condition.LuckMult or 1)
		luckLabel.Text = "Luck: " .. ItemStatUtil.FormatLuckPercent(luck)
	end

	title.Parent = titleAnchor
	ItemTitlePositionUtil.ApplyBottomOffset(title, tool)
	localHeldItemTitle = title
end

local function refreshLocalHeldItemTitle()
	local character = LOCAL_PLAYER.Character
	local tool = character and character:FindFirstChildOfClass("Tool")
	if tool then
		createLocalHeldItemTitle(tool)
	else
		clearLocalHeldItemTitle()
	end
end

local function queueLocalHeldItemTitleRefresh()
	task.defer(refreshLocalHeldItemTitle)
end

local function trackItemTool(instance: Instance)
	if ItemToolUtil.IsItemTool(instance) then
		trackedItemTools[instance :: Tool] = true
	end
end

local function clearCharacterItemTools(character: Model)
	for tool in pairs(trackedItemTools) do
		if tool.Parent == character or not tool.Parent then
			trackedItemTools[tool] = nil
		end
	end
end

local function bindTitleCharacter(character: Model)
	if boundTitleCharacters[character] then
		return
	end
	boundTitleCharacters[character] = true

	for _, child in ipairs(character:GetChildren()) do
		trackItemTool(child)
	end
	character.ChildAdded:Connect(trackItemTool)
	character.ChildRemoved:Connect(function(child)
		if child:IsA("Tool") then
			trackedItemTools[child] = nil
		end
	end)
	character.Destroying:Connect(function()
		boundTitleCharacters[character] = nil
		clearCharacterItemTools(character)
	end)
end

local function bindTitlePlayer(player: Player)
	if player.Character then
		bindTitleCharacter(player.Character)
	end
	player.CharacterAdded:Connect(bindTitleCharacter)
	player.CharacterRemoving:Connect(clearCharacterItemTools)
end

local function updateTrackedItemTitles()
	for tool in pairs(trackedItemTools) do
		local character = tool.Parent
		if not character or not character:IsA("Model") then
			trackedItemTools[tool] = nil
			continue
		end

		local titleAnchor = tool:FindFirstChild(HELD_ITEM_TITLE_ANCHOR_NAME, true)
		if not titleAnchor or not titleAnchor:IsA("Attachment") then
			continue
		end
		if character == LOCAL_PLAYER.Character
			and localHeldItemTitle
			and localHeldItemTitle:IsDescendantOf(tool)
		then
			ItemTitlePositionUtil.ApplyBottomOffset(localHeldItemTitle, tool)
		else
			local serverTitle = titleAnchor:FindFirstChild(HELD_ITEM_TITLE_NAME)
			if serverTitle and serverTitle:IsA("BillboardGui") then
				ItemTitlePositionUtil.ApplyBottomOffset(serverTitle, tool)
			end
		end
	end
end

local function reportCurrentTool(force: boolean?)
	local descriptor = getEquippedDescriptor(LOCAL_PLAYER.Character)
	local key = if descriptor then descriptor.kind .. ":" .. descriptor.identifier else ""
	if not force and key == lastDescriptorKey then
		return
	end

	lastDescriptorKey = key
	Knit.GetService("HeldItemVisualService").ReportHeldItem:Fire(descriptor)
end

local function bindCharacter(character: Model)
	for _, child in ipairs(character:GetChildren()) do
		if isHeldItemVisual(child) then
			hideVisualForLocalPlayer(child)
		end
	end

	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			task.defer(reportCurrentTool)
			queueLocalHeldItemTitleRefresh()
		elseif isHeldItemVisual(child) then
			hideVisualForLocalPlayer(child)
		end
	end)

	character.ChildRemoved:Connect(function(child)
		if child:IsA("Tool") then
			task.defer(reportCurrentTool)
			queueLocalHeldItemTitleRefresh()
		end
	end)

	character.DescendantAdded:Connect(function(descendant)
		if descendant.Name == HELD_ITEM_TITLE_ANCHOR_NAME and descendant:IsA("Attachment") then
			queueLocalHeldItemTitleRefresh()
		end
	end)

	task.defer(reportCurrentTool, true)
	task.delay(1, reportCurrentTool, true)
	queueLocalHeldItemTitleRefresh()
end

function HeldItemVisualController:KnitStart()
	LOCAL_PLAYER:WaitForChild("PlayerGui"):WaitForChild("TitleGui")
	for _, player in ipairs(Players:GetPlayers()) do
		bindTitlePlayer(player)
	end
	Players.PlayerAdded:Connect(bindTitlePlayer)
	RunService.RenderStepped:Connect(updateTrackedItemTitles)

	if LOCAL_PLAYER.Character then
		bindCharacter(LOCAL_PLAYER.Character)
	end

	LOCAL_PLAYER.CharacterAdded:Connect(function(character)
		lastDescriptorKey = nil
		clearLocalHeldItemTitle()
		bindCharacter(character)
	end)
end

return HeldItemVisualController
