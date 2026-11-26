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
local Analytics = require(script.Parent.OnboardingAnalyticsService)
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

local function changeRod(player: Player, rodId: unknown, buy: boolean)
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
	local isGuidedParkRod = id == Onboarding.RewardRodId and stage == "RodReward"
	if buy then
		if owned then
			return failure("You already own this fishing rod")
		end
		if id == Onboarding.RewardRodId and Onboarding.IsActiveStage(stage) then
			if stage ~= "RodReward" then
				return failure("Finish training to buy the Park Rod")
			end
			local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
			local anchor = RodShopZone.GetAnchor(plot)
			if not anchor or not RodShopZone.Contains(anchor, player.Character, RodShopZone.ExitMargin) then
				return failure("Visit your rod shop to buy the Park Rod")
			end
		end
		if data.Wins < rod.Price then
			if isGuidedParkRod then
				Analytics:Detail(player, "Guide", "RodPurchaseInsufficientCash")
			end
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
	local previouslyEquipped = RodInventory.GetEquippedId(data)
	data.EquippedRodId = id
	local upgraded = rod.LayoutOrder >= RodsData[Onboarding.RewardRodId].LayoutOrder
	if upgraded then
		if Onboarding.Advance(player, data, "RodReward", "FinalCatch") then
			Analytics:Step(player, "RodReady")
			Analytics:Detail(player, "Guide", if buy then "RodPurchased" else "OwnedRodEquipped")
		end
	else
		Onboarding.Advance(player, data, "FinalCatch", "RodReward")
	end
	if buy or previouslyEquipped ~= id then
		Analytics:Growth(player, "CL_RodChange_v1", if buy then rod.Price else 0, id,
			if buy then "Purchase" else "Equip")
	end
	player:SetAttribute("EquippedRodId", id)
	local result = state(data, if buy then `Purchased and equipped {rod.DisplayName}` else `Equipped {rod.DisplayName}`)
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

return RodShopService
