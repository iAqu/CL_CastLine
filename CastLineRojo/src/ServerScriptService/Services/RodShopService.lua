local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(Modules.Constants)
local FishingAssets = require(Modules.FishingAssets)
local RodInventory = require(Modules.RodInventory)
local Onboarding = require(Modules.FishingOnboarding)
local RodShopZone = require(Modules.RodShopZone)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RodsData = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("RodsData"))

local RodShopService = Knit.CreateService({
	Name = "RodShopService",
	Client = { InventoryChanged = Knit.CreateSignal() },
})
local purchasing = {}

local function failure(message: string)
	return { ok = false, message = message }
end

local function state(data, message: string?)
	return {
		ok = true,
		message = message,
		ownedRods = table.clone(data.OwnedRods),
		equippedRodId = RodInventory.GetEquippedId(data),
	}
end

local function getShopData(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil, "Your rod inventory is still loading"
	end
	return profile.Data
end

local function changeRod(player: Player, rodId: unknown, buy: boolean, claim: boolean?)
	if purchasing[player] then
		return failure("A rod purchase is already in progress")
	end
	local rod = if typeof(rodId) == "string" then RodsData[rodId] else nil
	if not rod or not FishingAssets.GetRod(rod.Model) then
		return failure("Fishing rod unavailable")
	end
	local data, message = getShopData(player)
	if not data then
		return failure(message)
	end

	local id = rod.RodID
	local owned = RodInventory.Owns(data, id)
	local progress = data.FishingOnboarding
	local stage = progress and progress.Stage
	if claim then
		if id ~= Onboarding.RewardRodId or stage ~= "RodReward" or owned then
			return failure("Training reward unavailable")
		end
		local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
		local anchor = RodShopZone.GetAnchor(plot)
		if not anchor or not RodShopZone.Contains(anchor, player.Character, RodShopZone.ExitMargin) then
			return failure("Visit your rod shop to claim the training reward")
		end
		data.OwnedRods[id] = true
	elseif buy then
		if id == Onboarding.RewardRodId and not owned and Onboarding.IsActiveStage(stage) then
			return failure(if stage == "RodReward" then "Claim your training reward at your rod shop"
				else "Finish training to get the Park Rod")
		end
		if owned then
			return failure("You already own this fishing rod")
		end
		if data.Wins < rod.Price then
			return failure(Constants.NOTIFICATION_NO_ENOUGH_WIN)
		end
		purchasing[player] = true
		local charged = PlayerDataService:AdjustWins(player, -rod.Price)
		if not charged then
			purchasing[player] = nil
			return failure("Could not purchase fishing rod")
		end
		data.OwnedRods[id] = true
		purchasing[player] = nil
	elseif not owned then
		return failure("You do not own this fishing rod")
	end
	data.EquippedRodId = id
	local upgraded = rod.LayoutOrder >= RodsData[Onboarding.RewardRodId].LayoutOrder
	if upgraded then
		Onboarding.Advance(player, data, "RodReward", "FinalCatch")
	else
		Onboarding.Advance(player, data, "FinalCatch", "RodReward")
	end
	player:SetAttribute("EquippedRodId", id)
	local result = state(data, if claim then `Claimed and equipped {rod.DisplayName}`
		elseif buy then `Purchased and equipped {rod.DisplayName}` else `Equipped {rod.DisplayName}`)
	RodShopService.Client.InventoryChanged:Fire(player, result)
	return result
end

function RodShopService.Client:GetState(player: Player)
	local data, message = getShopData(player)
	return if data then state(data) else failure(message)
end

function RodShopService.Client:BuyRod(player: Player, rodId: unknown)
	return changeRod(player, rodId, true)
end

function RodShopService.Client:EquipRod(player: Player, rodId: unknown)
	return changeRod(player, rodId, false)
end

function RodShopService.Client:ClaimTrainingRod(player: Player)
	return changeRod(player, Onboarding.RewardRodId, false, true)
end

return RodShopService
