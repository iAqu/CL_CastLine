local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local VISUAL_NAME = "HeldItemVisual"
local GRIP_NAME = "HeldItemVisualGrip"
local LEGACY_R6_GRIP_C0 = CFrame.new(0, -1, 0)

export type HeldItemKind = "potion"
export type HeldItemDescriptor = {
	kind: HeldItemKind,
	identifier: string,
}

type ResolvedItem = {
	kind: HeldItemKind,
	identifier: string,
	potionId: string?,
}

local HeldItemVisualService = Knit.CreateService({
	Name = "HeldItemVisualService",
	Client = {
		ReportHeldItem = Knit.CreateSignal(),
	},
})

local activeVisuals: { [Player]: Model } = {}

local function destroyGripJoint(character: Model)
	for _, handName in ipairs({ "RightHand", "Right Arm" }) do
		local hand = character:FindFirstChild(handName)
		if hand and hand:IsA("BasePart") then
			local gripJoint = hand:FindFirstChild(GRIP_NAME)
			if gripJoint and gripJoint:IsA("Motor6D") then
				gripJoint:Destroy()
			end
		end
	end
end

local function destroyVisual(player: Player)
	local visual = activeVisuals[player]
	if visual then
		activeVisuals[player] = nil
		if visual.Parent then
			visual:Destroy()
		end
	end

	local character = player.Character
	if character then
		local orphan = character:FindFirstChild(VISUAL_NAME)
		if orphan and orphan:IsA("Model") and orphan:GetAttribute("HeldItemVisual") == true then
			orphan:Destroy()
		end
		destroyGripJoint(character)
	end
end

local function hasEquippedPotionTool(player: Player, potionId: string): boolean
	local character = player.Character
	if not character then
		return false
	end

	for _, child in ipairs(character:GetChildren()) do
		if PotionToolUtil.IsPotionTool(child)
			and PotionToolUtil.GetPotionId(child) == potionId
		then
			return true
		end
	end
	return false
end

local function resolveDescriptor(player: Player, descriptor: any): ResolvedItem?
	if typeof(descriptor) ~= "table" then
		return nil
	end

	local kind = descriptor.kind
	local identifier = descriptor.identifier
	if kind ~= "potion" or typeof(identifier) ~= "string" or identifier == "" then
		return nil
	end

	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	local data = profile.Data

	local potion = data.Potions and data.Potions[identifier]
	if typeof(potion) == "table"
		and typeof(potion.Count) == "number"
		and potion.Count > 0
		and PotionToolUtil.HasPotionModel(identifier)
		and hasEquippedPotionTool(player, identifier)
	then
		return {
			kind = "potion",
			identifier = identifier,
			potionId = identifier,
		}
	end

	return nil
end

local function createVisualFromTool(tool: Tool): (Model?, BasePart?, CFrame)
	local grip = tool.Grip
	local visual = Instance.new("Model")
	visual.Name = VISUAL_NAME

	for _, child in ipairs(tool:GetChildren()) do
		child.Parent = visual
	end
	tool:Destroy()

	local handle = visual:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then
		visual:Destroy()
		return nil, nil, grip
	end

	return visual, handle, grip
end

local function createPotionVisual(potionId: string): (Model?, BasePart?, CFrame)
	local tool = PotionToolUtil.CreateTool(potionId, 1)
	if not tool then
		return nil, nil, CFrame.identity
	end
	return createVisualFromTool(tool)
end

local function getGripAnchor(character: Model): (BasePart?, CFrame)
	for _, handName in ipairs({ "RightHand", "Right Arm" }) do
		local hand = character:FindFirstChild(handName)
		if hand and hand:IsA("BasePart") then
			local attachment = hand:FindFirstChild("RightGripAttachment")
			if attachment and attachment:IsA("Attachment") then
				return hand, attachment.CFrame
			end
			return hand, LEGACY_R6_GRIP_C0
		end
	end

	return nil, CFrame.identity
end

local function createVisual(player: Player, resolved: ResolvedItem)
	local character = player.Character
	if not character then
		return
	end

	local hand, gripC0 = getGripAnchor(character)
	if not hand then
		return
	end

	local visual: Model?
	local handle: BasePart?
	local grip = CFrame.identity
	if resolved.kind == "potion" and resolved.potionId then
		visual, handle, grip = createPotionVisual(resolved.potionId)
	end

	if not visual or not handle then
		return
	end

	visual:SetAttribute("HeldItemVisual", true)
	visual:SetAttribute("HeldItemVisualKind", resolved.kind)
	visual.Parent = character

	local gripJoint = Instance.new("Motor6D")
	gripJoint.Name = GRIP_NAME
	gripJoint.Part0 = hand
	gripJoint.Part1 = handle
	gripJoint.C0 = gripC0
	gripJoint.C1 = grip
	gripJoint.Parent = hand

	activeVisuals[player] = visual
end

local function reportHeldItem(player: Player, descriptor: any)
	destroyVisual(player)

	local resolved = resolveDescriptor(player, descriptor)
	if resolved then
		createVisual(player, resolved)
	end
end

function HeldItemVisualService:KnitInit()
	self.Client.ReportHeldItem:Connect(reportHeldItem)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			destroyVisual(player)
		end)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		player.CharacterAdded:Connect(function()
			destroyVisual(player)
		end)
	end

	Players.PlayerRemoving:Connect(function(player)
		destroyVisual(player)
		activeVisuals[player] = nil
	end)
end

return HeldItemVisualService
