local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local FishTitleUtil = require(ReplicatedStorage.Modules.FishTitleUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local VISUAL_NAME = "HeldItemVisual"
local HELD_ITEM_TITLE_NAME = "HeldItemTitle"
local HELD_ITEM_TITLE_ANCHOR_NAME = "HeldItemTitleAnchor"
local LOCAL_TITLE_NAME = "LocalHeldItemTitle"

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

local function clearLocalHeldItemTitle()
	if localHeldItemTitle then
		local titleAnchor = localHeldItemTitle.Parent
		local serverTitle = titleAnchor and titleAnchor:FindFirstChild(HELD_ITEM_TITLE_NAME)
		if serverTitle and serverTitle:IsA("BillboardGui") then
			serverTitle.Enabled = true
		end
		localHeldItemTitle:Destroy()
		localHeldItemTitle = nil
	end
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
	local heldTitleAdornee = getHeldTitleAdornee(tool)
	if not heldTitleAdornee then
		return
	end

	local itemId = tool:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)
	local mutationId = tool:GetAttribute(ItemToolUtil.MUTATION_ID_ATTRIBUTE)
	local item = if typeof(itemId) == "string" then FishInventoryData[itemId] else nil
	if not item then
		return
	end

	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	local titleGui = playerGui and playerGui:FindFirstChild("TitleGui")
	local title = FishTitleUtil.Create(titleGui, item, mutationId, LOCAL_PLAYER)
	if not title then
		return
	end
	title.Name = LOCAL_TITLE_NAME
	title.Adornee = heldTitleAdornee
	title.Enabled = true
	title.Parent = titleAnchor
	ItemTitlePositionUtil.ApplyBottomOffset(title, tool)
	localHeldItemTitle = title

	local serverTitle = titleAnchor:FindFirstChild(HELD_ITEM_TITLE_NAME)
	if serverTitle and serverTitle:IsA("BillboardGui") then
		serverTitle.Enabled = false
	end
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
		if (descendant.Name == HELD_ITEM_TITLE_ANCHOR_NAME and descendant:IsA("Attachment"))
			or (descendant.Name == HELD_ITEM_TITLE_NAME and descendant:IsA("BillboardGui"))
		then
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
