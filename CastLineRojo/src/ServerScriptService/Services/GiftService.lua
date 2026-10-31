local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local GIFT_DISTANCE = 12
local REQUEST_TIMEOUT_SECONDS = 15

export type HeldItemDescriptor = {
	kind: string,
	identifier: string,
}

type PendingGift = {
	id: number,
	sender: Player,
	recipient: Player,
	heldItem: HeldItemDescriptor,
}

local GiftService = Knit.CreateService({
	Name = "GiftService",
	Client = {
		SetHeldItem = Knit.CreateSignal(),
		RequestGift = Knit.CreateSignal(),
		RespondGift = Knit.CreateSignal(),
		HeldItemChanged = Knit.CreateSignal(),
		GiftResult = Knit.CreateSignal(),
		GiftRequestReceived = Knit.CreateSignal(),
		GiftRequestCancelled = Knit.CreateSignal(),
		GiftReceived = Knit.CreateSignal(),
	},
})

local heldItems: { [Player]: HeldItemDescriptor } = {}
local pendingById: { [number]: PendingGift } = {}
local pendingBySender: { [Player]: PendingGift } = {}
local pendingByRecipient: { [Player]: PendingGift } = {}
local nextRequestId = 0

local function descriptorsEqual(a: HeldItemDescriptor?, b: HeldItemDescriptor?): boolean
	if a == nil or b == nil then
		return a == b
	end
	return a.kind == b.kind and a.identifier == b.identifier
end

local function getRootPart(player: Player): BasePart?
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil
	end
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return if root and root:IsA("BasePart") then root else nil
end

local function isPlacedOnPlot(profileData, instanceId: string): boolean
	if typeof(profileData.PlotPlacements) ~= "table" then
		return false
	end
	for _, placedUid in pairs(profileData.PlotPlacements) do
		if placedUid == instanceId then
			return true
		end
	end
	return false
end

local function normalizeItemRecord(record): (any?, any?)
	if typeof(record) ~= "table" or typeof(record.ItemId) ~= "string" then
		return nil, nil
	end
	local item = ItemsData[record.ItemId]
	if not item then
		return nil, nil
	end
	local weight = tonumber(record.Weight)
	local conditionId = record.ConditionId
	local condition = typeof(conditionId) == "string" and ConditionsData[conditionId] or nil
	if not weight or weight <= 0 or not condition then
		return nil, nil
	end
	local mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId)
	local price = tonumber(record.Price) or ItemStatUtil.CalculatePrice(
		item,
		weight,
		condition.ValueMult,
		MutationDataUtil.GetPriceRate(mutationId)
	)
	record.Weight = weight
	record.ConditionId = conditionId
	record.Price = price
	record.MutationId = mutationId
	return item, { Weight = weight, ConditionId = conditionId, Price = price, MutationId = mutationId }
end

local function hasEquippedItemTool(player: Player, instanceId: string): boolean
	local character = player.Character
	if not character then
		return false
	end
	for _, child in ipairs(character:GetChildren()) do
		if ItemToolUtil.IsItemTool(child) and ItemToolUtil.GetInstanceId(child) == instanceId then
			return true
		end
	end
	return false
end

local function isGiftBlockedForTutorial(player: Player, instanceId: string): boolean
	if Knit.GetService("TutorialService"):IsProtectedItem(player, instanceId) then
		return true
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or TutorialConfig.IsComplete(profile.Data) then
		return false
	end
	if profile.Data.TutorialDuckInstanceId == instanceId then
		return true
	end
	if profile.Data.TutorialSecondItemInstanceId == instanceId then
		return true
	end
	return false
end

local function destroyItemTools(player: Player, instanceIds: { [string]: boolean })
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				local instanceId = ItemToolUtil.GetInstanceId(child)
				if instanceId and instanceIds[instanceId] then
					child:Destroy()
				end
			end
		end
	end
end

local function buildHeldItemDescriptor(player: Player, kind: any, identifier: any): HeldItemDescriptor?
	if kind ~= "item" or typeof(identifier) ~= "string" or identifier == "" then
		return nil
	end

	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return nil
	end

	local record = profile.Data.Items[identifier]
	if typeof(record) ~= "table" then
		return nil
	end
	if isPlacedOnPlot(profile.Data, identifier) then
		return nil
	end
	if isGiftBlockedForTutorial(player, identifier) then
		return nil
	end

	local item, itemData = normalizeItemRecord(record)
	if not item or not itemData then
		return nil
	end
	if not hasEquippedItemTool(player, identifier) then
		return nil
	end

	return {
		kind = kind,
		identifier = identifier,
	}
end

local function validatePlayers(sender: Player, targetUserId: any): (Player?, string?)
	if typeof(targetUserId) ~= "number" then
		return nil, "Gift cancelled."
	end
	local recipient = Players:GetPlayerByUserId(targetUserId)
	if not recipient or recipient == sender then
		return nil, "Player left."
	end

	local senderRoot = getRootPart(sender)
	local recipientRoot = getRootPart(recipient)
	if not senderRoot or not recipientRoot then
		return nil, "Gift cancelled."
	end
	if (senderRoot.Position - recipientRoot.Position).Magnitude > GIFT_DISTANCE then
		return nil, "Gift cancelled."
	end
	return recipient, nil
end

local function cancelRequest(request: PendingGift, senderMessage: string?, recipientMessage: string?)
	if pendingById[request.id] ~= request then
		return
	end
	pendingById[request.id] = nil
	pendingBySender[request.sender] = nil
	pendingByRecipient[request.recipient] = nil

	if request.sender.Parent == Players and senderMessage then
		GiftService.Client.GiftResult:Fire(request.sender, false, senderMessage)
	end
	if request.recipient.Parent == Players then
		GiftService.Client.GiftRequestCancelled:Fire(request.recipient, request.id, recipientMessage)
	end
end

local function setHeldItem(player: Player, descriptor: HeldItemDescriptor?)
	local previous = heldItems[player]
	if descriptor then
		heldItems[player] = descriptor
	else
		heldItems[player] = nil
	end

	if not descriptorsEqual(previous, descriptor) then
		GiftService.Client.HeldItemChanged:FireAll(player, descriptor)
	end

	local pendingRequest = pendingBySender[player]
	if pendingRequest and not descriptorsEqual(pendingRequest.heldItem, descriptor) then
		cancelRequest(pendingRequest, "You cancelled the gift.", "Sender cancelled the gift.")
	end
end

local function updateHeldItem(player: Player, kind: any, identifier: any)
	if kind == "none" then
		setHeldItem(player, nil)
		return
	end
	setHeldItem(player, buildHeldItemDescriptor(player, kind, identifier))
end

local function getCurrentGiftItem(player: Player): (HeldItemDescriptor?, string?)
	local heldItem = heldItems[player]
	if not heldItem or heldItem.kind ~= "item" then
		return nil, "Hold an item."
	end

	local currentItem = buildHeldItemDescriptor(player, heldItem.kind, heldItem.identifier)
	if not descriptorsEqual(heldItem, currentItem) then
		setHeldItem(player, currentItem)
		return nil, "Item unavailable."
	end
	return currentItem, nil
end

local function getGiftDisplayNameForPlayer(player: Player, heldItem: HeldItemDescriptor): string
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return "item"
	end
	local record = profile.Data.Items[heldItem.identifier]
	if typeof(record) ~= "table" or typeof(record.ItemId) ~= "string" then
		return "item"
	end
	local item = ItemsData[record.ItemId]
	return if item and typeof(item.DisplayName) == "string" then item.DisplayName else "item"
end

local function transferItem(sender: Player, recipient: Player, instanceId: string): (boolean, string?)
	local senderProfile = PlayerDataService:GetProfile(sender)
	local recipientProfile = PlayerDataService:GetProfile(recipient)
	if not senderProfile or not recipientProfile then
		return false, "Gift failed."
	end
	if typeof(senderProfile.Data.Items) ~= "table" then
		return false, "Item unavailable."
	end

	local record = senderProfile.Data.Items[instanceId]
	if typeof(record) ~= "table" then
		return false, "Item unavailable."
	end

	local item, itemData = normalizeItemRecord(record)
	if not item or not itemData then
		return false, "Item unavailable."
	end

	local backpack = recipient:FindFirstChildOfClass("Backpack") or recipient:WaitForChild("Backpack", 5)
	if not backpack or not backpack:IsA("Backpack") then
		return false, "Gift failed."
	end

	local transferredRecord = table.clone(record)

	senderProfile.Data.Items[instanceId] = nil
	destroyItemTools(sender, { [instanceId] = true })
	Knit.GetService("HotbarLayoutService"):RemoveItemDescriptors(sender, { instanceId })

	if typeof(recipientProfile.Data.Items) ~= "table" then
		recipientProfile.Data.Items = {}
	end
	recipientProfile.Data.Items[instanceId] = transferredRecord

	local tool = ItemToolUtil.Create(instanceId, item, itemData)
	if not tool then
		recipientProfile.Data.Items[instanceId] = nil
		senderProfile.Data.Items[instanceId] = transferredRecord
		local senderBackpack = sender:FindFirstChildOfClass("Backpack")
		if senderBackpack then
			local restoredTool = ItemToolUtil.Create(instanceId, item, itemData)
			if restoredTool then
				restoredTool.Parent = senderBackpack
			end
		end
		return false, "Gift failed."
	end
	tool.Parent = backpack

	if typeof(recipientProfile.Data.NewItemTagSeenLog) ~= "table" then
		recipientProfile.Data.NewItemTagSeenLog = {}
	end
	recipientProfile.Data.NewItemTagSeenLog[item.ItemID] = true

	local carryCapacityService = Knit.GetService("CarryCapacityService")
	carryCapacityService:RefreshPlayer(sender)
	carryCapacityService:RefreshPlayer(recipient)
	Knit.GetService("IndexService"):DiscoverItem(recipient, item.ItemID)

	return true, nil
end

local function requestGift(sender: Player, targetUserId: any)
	if pendingBySender[sender] then
		GiftService.Client.GiftResult:Fire(sender, false, "Gift pending.")
		return
	end

	local recipient, validationError = validatePlayers(sender, targetUserId)
	if not recipient then
		GiftService.Client.GiftResult:Fire(sender, false, validationError or "Gift cancelled.")
		return
	end
	if pendingByRecipient[recipient] then
		GiftService.Client.GiftResult:Fire(sender, false, "Player is busy.")
		return
	end

	local heldItem, heldItemError = getCurrentGiftItem(sender)
	if not heldItem then
		GiftService.Client.GiftResult:Fire(sender, false, heldItemError or "Gift failed.")
		return
	end

	nextRequestId += 1
	local request: PendingGift = {
		id = nextRequestId,
		sender = sender,
		recipient = recipient,
		heldItem = heldItem,
	}
	pendingById[request.id] = request
	pendingBySender[sender] = request
	pendingByRecipient[recipient] = request
	GiftService.Client.GiftRequestReceived:Fire(
		recipient,
		request.id,
		heldItem.kind,
		heldItem.identifier,
		getGiftDisplayNameForPlayer(sender, heldItem),
		sender.DisplayName
	)

	task.delay(REQUEST_TIMEOUT_SECONDS, function()
		if pendingById[request.id] == request then
			cancelRequest(request, "Gift expired.", "Gift expired.")
		end
	end)
end

local function recipientIsEmptyHanded(player: Player): boolean
	local character = player.Character
	return character ~= nil and character:FindFirstChildOfClass("Tool") == nil
end

local function respondGift(recipient: Player, requestId: any, accepted: any)
	if typeof(requestId) ~= "number" or typeof(accepted) ~= "boolean" then
		return
	end
	local request = pendingById[requestId]
	if not request or request.recipient ~= recipient then
		return
	end

	if not accepted then
		cancelRequest(request, "Gift declined.", nil)
		return
	end

	local validatedRecipient, validationError = validatePlayers(request.sender, recipient.UserId)
	if validatedRecipient ~= recipient then
		cancelRequest(request, validationError or "Gift cancelled.", "Gift cancelled.")
		return
	end

	local heldItem, heldItemError = getCurrentGiftItem(request.sender)
	if not heldItem or not descriptorsEqual(heldItem, request.heldItem) then
		cancelRequest(request, heldItemError or "Gift cancelled.", "Gift cancelled.")
		return
	end

	pendingById[request.id] = nil
	pendingBySender[request.sender] = nil
	pendingByRecipient[request.recipient] = nil

	local shouldAutoEquip = recipientIsEmptyHanded(recipient)
	local success, errMsg = transferItem(request.sender, recipient, heldItem.identifier)
	if not success then
		GiftService.Client.GiftResult:Fire(request.sender, false, errMsg or "Gift failed.")
		GiftService.Client.GiftRequestCancelled:Fire(recipient, request.id, errMsg or "Gift failed.")
		return
	end

	setHeldItem(request.sender, nil)
	GiftService.Client.GiftResult:Fire(request.sender, true, "Gift sent!")
	GiftService.Client.GiftReceived:Fire(
		recipient,
		heldItem.kind,
		heldItem.identifier,
		request.sender.DisplayName,
		shouldAutoEquip
	)
end

function GiftService.Client:GetHeldItems(_player: Player): { { player: Player, descriptor: HeldItemDescriptor } }
	local snapshot = {}
	for player, descriptor in pairs(heldItems) do
		if player.Parent == Players then
			table.insert(snapshot, { player = player, descriptor = descriptor })
		end
	end
	return snapshot
end

function GiftService:KnitInit()
	self.Client.SetHeldItem:Connect(updateHeldItem)
	self.Client.RequestGift:Connect(requestGift)
	self.Client.RespondGift:Connect(respondGift)
	Players.PlayerRemoving:Connect(function(player: Player)
		local outgoingRequest = pendingBySender[player]
		if outgoingRequest then
			cancelRequest(outgoingRequest, nil, "Player left.")
		end
		local incomingRequest = pendingByRecipient[player]
		if incomingRequest then
			cancelRequest(incomingRequest, "Player left.", nil)
		end
		setHeldItem(player, nil)
	end)
end

return GiftService
