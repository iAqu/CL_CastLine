local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local ShovelToolUtil = require(ReplicatedStorage.Modules.ShovelToolUtil)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local ShovelsData = require(ReplicatedFirst.Data.ShovelsData)

local ShovelService = Knit.CreateService({
	Name = "ShovelService",
	Client = {
		ShovelStateChanged = Knit.CreateSignal(),
	},
	_Requests = {} :: { [Player]: boolean },
})

export type ShovelState = {
	ownedShovelIds: { [string]: boolean },
	equippedShovelId: string,
}

export type ShovelResult = ShovelState & {
	ok: boolean,
	reason: string?,
	message: string,
}

local RESULT_MESSAGES = table.freeze({
	ProfileUnavailable = "Player data is unavailable",
	InvalidShovel = "Invalid shovel",
	AlreadyOwned = "Shovel already owned",
	AlreadyEquipped = "Shovel already equipped",
	InsufficientCash = "Not enough cash",
	NotOwned = "You do not own this shovel",
	CreateFailed = "Could not equip shovel",
	RequestPending = "Shovel request already in progress",
})

local function copyOwnedShovelIds(ownedShovelIds: unknown): { [string]: boolean }
	local result = {}
	if typeof(ownedShovelIds) == "table" then
		for shovelId, isOwned in pairs(ownedShovelIds) do
			if typeof(shovelId) == "string" and isOwned == true and ShovelsData[shovelId] then
				result[shovelId] = true
			end
		end
	end
	result[ShovelToolUtil.DEFAULT_SHOVEL_ID] = true
	return result
end

local function getState(player: Player): ShovelState
	local profile = PlayerDataService:GetProfile(player)
	local data = profile and profile.Data or nil
	local equippedShovelId = data and data.EquippedShovelId or ShovelToolUtil.DEFAULT_SHOVEL_ID
	if typeof(equippedShovelId) ~= "string" or not ShovelsData[equippedShovelId] then
		equippedShovelId = ShovelToolUtil.DEFAULT_SHOVEL_ID
	end
	return {
		ownedShovelIds = copyOwnedShovelIds(data and data.OwnedShovelIds or nil),
		equippedShovelId = equippedShovelId,
	}
end

local function makeResult(player: Player, ok: boolean, reason: string?, successMessage: string?): ShovelResult
	local state = getState(player)
	return {
		ok = ok,
		reason = reason,
		message = successMessage or RESULT_MESSAGES[reason] or "Shovel request failed",
		ownedShovelIds = state.ownedShovelIds,
		equippedShovelId = state.equippedShovelId,
	}
end

local function ensureOwnedShovelIds(profileData): { [string]: boolean }
	local ownedShovelIds = copyOwnedShovelIds(profileData.OwnedShovelIds)
	profileData.OwnedShovelIds = ownedShovelIds
	return ownedShovelIds
end

local function findShovelTool(player: Player): Tool?
	return ShovelToolUtil.FindShovelTool(player:FindFirstChildOfClass("Backpack"))
		or ShovelToolUtil.FindShovelTool(player.Character)
end

local function getSelectedShovelId(player: Player): string
	local profile = PlayerDataService:GetProfile(player)
	local selectedId = profile and profile.Data.EquippedShovelId
	if typeof(selectedId) == "string" and ShovelsData[selectedId] and ShovelToolUtil.HasShovelModel(selectedId) then
		return selectedId
	end
	if profile then
		profile.Data.EquippedShovelId = ShovelToolUtil.DEFAULT_SHOVEL_ID
	end
	return ShovelToolUtil.DEFAULT_SHOVEL_ID
end

local function destroyShovelTools(player: Player)
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if ShovelToolUtil.IsShovelTool(child) then
					child:Destroy()
				end
			end
		end
	end
end

local function ensureShovelTool(player: Player): Tool?
	local selectedId = getSelectedShovelId(player)
	local existing = findShovelTool(player)
	if existing and ShovelToolUtil.GetShovelId(existing) == selectedId then
		if ShovelToolUtil.GetHandAttachment(existing) then
			ShovelToolUtil.ApplyIdleGrip(existing)
			return existing
		end
	end
	destroyShovelTools(player)

	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack or not backpack:IsA("Backpack") then
		warn("ShovelService: Backpack missing, cannot create shovel tool")
		return nil
	end

	local tool = ShovelToolUtil.CreateTool(selectedId)
	if not tool then
		return nil
	end

	tool.Parent = backpack
	return tool
end

local function equipShovelForCurrentCharacter(player: Player, tool: Tool)
	local character = player.Character
	if not character or tool.Parent == character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if humanoid and humanoid:IsA("Humanoid") then
		humanoid:EquipTool(tool)
	end
end

local function syncPlayerShovel(player: Player)
	local tool = ensureShovelTool(player)
	if tool then
		equipShovelForCurrentCharacter(player, tool)
	end
end

function ShovelService:KnitStart()
	PlayerDataService.ProfileLoaded:Connect(function(player)
		task.spawn(syncPlayerShovel, player)
		player.CharacterAdded:Connect(function()
			task.spawn(syncPlayerShovel, player)
		end)
	end)
	game:GetService("Players").PlayerRemoving:Connect(function(player)
		self._Requests[player] = nil
	end)
end

function ShovelService:PurchaseAndEquipShovel(player: Player, shovelId: unknown): ShovelResult
	if typeof(shovelId) ~= "string" or not ShovelsData[shovelId] or not ShovelToolUtil.HasShovelModel(shovelId) then
		return makeResult(player, false, "InvalidShovel")
	end
	if self._Requests[player] then
		return makeResult(player, false, "RequestPending")
	end
	self._Requests[player] = true

	local profile = PlayerDataService:GetProfile(player)
	local shovel = ShovelsData[shovelId]
	if not profile then
		self._Requests[player] = nil
		return makeResult(player, false, "ProfileUnavailable")
	end
	local ownedShovelIds = ensureOwnedShovelIds(profile.Data)
	if ownedShovelIds[shovelId] then
		self._Requests[player] = nil
		return makeResult(player, false, "AlreadyOwned")
	end
	local canSpend, spendMessage = Knit.GetService("TutorialService"):CanSpendWins(
		player,
		TutorialConfig.STEP.BUY_SHOVEL
	)
	if not canSpend then
		self._Requests[player] = nil
		local blocked = makeResult(player, false, "TutorialBlocked")
		blocked.message = spendMessage or "Finish the tutorial first!"
		return blocked
	end
	if (tonumber(profile.Data.Wins) or 0) < shovel.Price then
		self._Requests[player] = nil
		return makeResult(player, false, "InsufficientCash")
	end

	local previousShovelId = getSelectedShovelId(player)
	PlayerDataService:AdjustWins(player, -shovel.Price, false)
	ownedShovelIds[shovelId] = true
	profile.Data.EquippedShovelId = shovelId
	local tool = ensureShovelTool(player)
	if not tool then
		profile.Data.EquippedShovelId = previousShovelId
		ownedShovelIds[shovelId] = nil
		PlayerDataService:AdjustWins(player, shovel.Price, false)
		syncPlayerShovel(player)
		self._Requests[player] = nil
		return makeResult(player, false, "CreateFailed")
	end
	equipShovelForCurrentCharacter(player, tool)
	self._Requests[player] = nil
	local result = makeResult(player, true, nil, `Purchased and equipped {shovel.DisplayName}`)
	Knit.GetService("DigItemService"):RefreshPlayerLuck(player)
	self.Client.ShovelStateChanged:Fire(player, result.ownedShovelIds, result.equippedShovelId)
	Knit.GetService("TutorialService"):OnShovelPurchased(player, shovelId)
	return result
end

function ShovelService:EquipShovel(player: Player, shovelId: unknown): ShovelResult
	if typeof(shovelId) ~= "string" or not ShovelsData[shovelId] or not ShovelToolUtil.HasShovelModel(shovelId) then
		return makeResult(player, false, "InvalidShovel")
	end
	if self._Requests[player] then
		return makeResult(player, false, "RequestPending")
	end
	self._Requests[player] = true

	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		self._Requests[player] = nil
		return makeResult(player, false, "ProfileUnavailable")
	end
	local ownedShovelIds = ensureOwnedShovelIds(profile.Data)
	if not ownedShovelIds[shovelId] then
		self._Requests[player] = nil
		return makeResult(player, false, "NotOwned")
	end

	local previousShovelId = getSelectedShovelId(player)
	if previousShovelId == shovelId then
		self._Requests[player] = nil
		return makeResult(player, false, "AlreadyEquipped")
	end
	profile.Data.EquippedShovelId = shovelId
	local tool = ensureShovelTool(player)
	if not tool then
		profile.Data.EquippedShovelId = previousShovelId
		syncPlayerShovel(player)
		self._Requests[player] = nil
		return makeResult(player, false, "CreateFailed")
	end
	equipShovelForCurrentCharacter(player, tool)
	self._Requests[player] = nil
	local result = makeResult(player, true, nil, `Equipped {ShovelsData[shovelId].DisplayName}`)
	Knit.GetService("DigItemService"):RefreshPlayerLuck(player)
	self.Client.ShovelStateChanged:Fire(player, result.ownedShovelIds, result.equippedShovelId)
	return result
end

function ShovelService.Client:PurchaseAndEquipShovel(player: Player, shovelId: string)
	return self.Server:PurchaseAndEquipShovel(player, shovelId)
end

function ShovelService.Client:EquipShovel(player: Player, shovelId: string)
	return self.Server:EquipShovel(player, shovelId)
end

return ShovelService
