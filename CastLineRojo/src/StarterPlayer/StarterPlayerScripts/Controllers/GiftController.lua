local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ConfirmGuiClient = require(ReplicatedStorage.Modules.ConfirmGuiClient)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local GIFT_PROMPT_NAME = "GiftPrompt"
local EQUIP_WAIT_SECONDS = 3

type HeldItemDescriptor = {
	kind: string,
	identifier: string,
}

local GiftController = Knit.CreateController({
	Name = "GiftController",
})

local promptsByPlayer: { [Player]: ProximityPrompt } = {}
local targetConnections: { [Player]: { RBXScriptConnection } } = {}
local characterConnections: { RBXScriptConnection } = {}
local confirmationOpen = false
local requestPending = false
local incomingRequestId: number? = nil
local closeIncomingConfirmation: (() -> nil)? = nil
local lastReportedKind: string? = nil
local lastReportedIdentifier: string? = nil
local GiftService: any = nil

local function getHeldTool(): Tool?
	local character = LOCAL_PLAYER.Character
	if not character then
		return nil
	end
	for _, child in ipairs(character:GetChildren()) do
		if ItemToolUtil.IsItemTool(child) then
			return child :: Tool
		end
	end
	return nil
end

local function getGiftTool(): Tool?
	return getHeldTool()
end

local function getHeldItemIdentity(tool: Tool?): (string?, string?)
	if not tool or not ItemToolUtil.IsItemTool(tool) then
		return nil, nil
	end
	local instanceId = ItemToolUtil.GetInstanceId(tool)
	if not instanceId then
		return nil, nil
	end
	return "item", instanceId
end

local function getGiftName(tool: Tool): string
	local displayName = tool:GetAttribute(ItemToolUtil.DISPLAY_NAME_ATTRIBUTE)
	return if typeof(displayName) == "string" and displayName ~= "" then displayName else tool.Name
end

local function clearIncomingConfirmation()
	if closeIncomingConfirmation then
		closeIncomingConfirmation()
		closeIncomingConfirmation = nil
	end
	incomingRequestId = nil
end

local function declineIncomingRequest()
	local requestId = incomingRequestId
	clearIncomingConfirmation()
	if requestId and GiftService then
		GiftService.RespondGift:Fire(requestId, false)
	end
end

local function destroyPrompt(player: Player)
	local prompt = promptsByPlayer[player]
	if prompt then
		prompt:Destroy()
		promptsByPlayer[player] = nil
	end
end

local function refreshPrompts()
	local giftTool = getGiftTool()
	for player, prompt in pairs(promptsByPlayer) do
		if not giftTool or not player.Character or not prompt.Parent then
			destroyPrompt(player)
		end
	end
	if not giftTool then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LOCAL_PLAYER then
			continue
		end
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and root:IsA("BasePart") and not promptsByPlayer[player] then
			local prompt = PromptUtil.Create(root, {
				Name = GIFT_PROMPT_NAME,
				ActionText = "Gift",
				ObjectText = player.DisplayName,
				RequiresLineOfSight = false,
			})
			promptsByPlayer[player] = prompt
			prompt.Triggered:Connect(function()
				if confirmationOpen or requestPending or incomingRequestId or getGiftTool() ~= giftTool then
					return
				end
				confirmationOpen = true
				ConfirmGuiClient.OpenConfirmtGui(
					("Confirm gifting %s to %s?"):format(getGiftName(giftTool), player.DisplayName),
					function()
						confirmationOpen = false
						if requestPending or getGiftTool() ~= giftTool then
							return
						end
						requestPending = true
						GiftService.RequestGift:Fire(player.UserId)
					end,
					function()
						confirmationOpen = false
					end
				)
			end)
		end
	end
end

local function reportHeldItem()
	if not GiftService then
		return
	end
	local kind, identifier = getHeldItemIdentity(getHeldTool())
	if kind == lastReportedKind and identifier == lastReportedIdentifier then
		return
	end
	lastReportedKind = kind
	lastReportedIdentifier = identifier
	if kind and identifier then
		GiftService.SetHeldItem:Fire(kind, identifier)
	else
		GiftService.SetHeldItem:Fire("none")
	end
end

local function refreshLocalHeldItem()
	reportHeldItem()
	refreshPrompts()
end

local function disconnectTarget(player: Player)
	destroyPrompt(player)
	local connections = targetConnections[player]
	if connections then
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		targetConnections[player] = nil
	end
end

local function watchTarget(player: Player)
	if player == LOCAL_PLAYER or targetConnections[player] then
		return
	end
	targetConnections[player] = {
		player.CharacterAdded:Connect(refreshPrompts),
		player.CharacterRemoving:Connect(function()
			destroyPrompt(player)
		end),
	}
end

local function findReceivedTool(kind: string, identifier: string): Tool?
	local backpack = LOCAL_PLAYER:FindFirstChildOfClass("Backpack")
	if not backpack then
		return nil
	end
	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool")
			and kind == "item"
			and ItemToolUtil.IsItemTool(child)
			and ItemToolUtil.GetInstanceId(child) == identifier
		then
			return child
		end
	end
	return nil
end

local function isEmptyHanded(): boolean
	local character = LOCAL_PLAYER.Character
	return character ~= nil and character:FindFirstChildOfClass("Tool") == nil
end

local function equipReceivedTool(kind: string, identifier: string)
	local deadline = os.clock() + EQUIP_WAIT_SECONDS
	while os.clock() < deadline do
		if isEmptyHanded() then
			local tool = findReceivedTool(kind, identifier)
			if tool then
				tool.Parent = LOCAL_PLAYER.Character
				return
			end
		end
		task.wait(0.1)
	end
end

local function bindLocalCharacter(character: Model)
	for _, connection in ipairs(characterConnections) do
		connection:Disconnect()
	end
	characterConnections = {
		character.ChildAdded:Connect(refreshLocalHeldItem),
		character.ChildRemoved:Connect(refreshLocalHeldItem),
	}
	refreshLocalHeldItem()
end

function GiftController:KnitStart()
	GiftService = Knit.GetService("GiftService")
	GiftService.GiftResult:Connect(function(success: boolean, message: string)
		requestPending = false
		if success then
			NotificationClient.GreenNotify(message)
		else
			NotificationClient.RedNotify(message)
		end
		refreshLocalHeldItem()
	end)
	GiftService.GiftRequestReceived:Connect(function(
		requestId: number,
		_kind: string,
		_identifier: string,
		giftName: string,
		senderName: string
	)
		if incomingRequestId or confirmationOpen or requestPending then
			GiftService.RespondGift:Fire(requestId, false)
			return
		end

		incomingRequestId = requestId
		closeIncomingConfirmation = ConfirmGuiClient.OpenConfirmtGui(
			("Accept %s from %s?"):format(giftName, senderName),
			function()
				if incomingRequestId ~= requestId then
					return
				end
				incomingRequestId = nil
				closeIncomingConfirmation = nil
				GiftService.RespondGift:Fire(requestId, true)
			end,
			function()
				if incomingRequestId ~= requestId then
					return
				end
				incomingRequestId = nil
				closeIncomingConfirmation = nil
				GiftService.RespondGift:Fire(requestId, false)
			end
		)
	end)
	GiftService.GiftRequestCancelled:Connect(function(requestId: number, message: string?)
		if incomingRequestId == requestId then
			clearIncomingConfirmation()
		end
		if message and message ~= "" then
			NotificationClient.RedNotify(message)
		end
	end)
	GiftService.GiftReceived:Connect(function(kind: string, identifier: string, _senderName: string, shouldAutoEquip: boolean)
		NotificationClient.GreenNotify("Gift received!")
		if shouldAutoEquip then
			task.spawn(equipReceivedTool, kind, identifier)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		watchTarget(player)
	end
	Players.PlayerAdded:Connect(watchTarget)
	Players.PlayerRemoving:Connect(disconnectTarget)

	if LOCAL_PLAYER.Character then
		bindLocalCharacter(LOCAL_PLAYER.Character)
	end
	LOCAL_PLAYER.CharacterAdded:Connect(bindLocalCharacter)
	LOCAL_PLAYER.CharacterRemoving:Connect(function()
		lastReportedKind = nil
		lastReportedIdentifier = nil
		GiftService.SetHeldItem:Fire("none")
		declineIncomingRequest()
		for player in pairs(promptsByPlayer) do
			destroyPrompt(player)
		end
	end)
end

return GiftController
