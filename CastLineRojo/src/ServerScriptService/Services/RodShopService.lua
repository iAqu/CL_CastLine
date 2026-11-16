local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(Modules.Constants)
local FishingAssets = require(Modules.FishingAssets)
local RodInventory = require(Modules.RodInventory)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RodsData = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("RodsData"))

local RodShopService = Knit.CreateService({ Name = "RodShopService", Client = {} })
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
	if buy then
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
	player:SetAttribute("EquippedRodId", id)
	return state(data, if buy then `Purchased and equipped {rod.DisplayName}` else `Equipped {rod.DisplayName}`)
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
