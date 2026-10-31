local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CarryCapacityUtil = require(ReplicatedStorage.Modules.CarryCapacityUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local CarryCapacityService = Knit.CreateService({
	Name = "CarryCapacityService",
	Client = {
		CapacityChanged = Knit.CreateSignal(),
		CapacityRejected = Knit.CreateSignal(),
	},
})

function CarryCapacityService:GetSnapshot(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	local weight, value = CarryCapacityUtil.GetCarriedTotals(profile.Data)
	return {
		weight = weight,
		capacity = CarryCapacityUtil.GetCapacity(profile.Data),
		value = value,
	}
end

function CarryCapacityService:CanCarry(player: Player, addedWeight: unknown): boolean
	local profile = PlayerDataService:GetProfile(player)
	return profile ~= nil and CarryCapacityUtil.CanCarry(profile.Data, addedWeight)
end

function CarryCapacityService:CanSetCarriedWeight(player: Player, targetWeight: unknown): boolean
	local snapshot = self:GetSnapshot(player)
	local weight = tonumber(targetWeight)
	return snapshot ~= nil and weight ~= nil and weight >= 0 and weight <= snapshot.capacity
end

function CarryCapacityService:Reject(player: Player)
	self.Client.CapacityRejected:Fire(player, "Not enough carry weight")
end

function CarryCapacityService:RefreshPlayer(player: Player)
	local snapshot = self:GetSnapshot(player)
	if not snapshot then
		return
	end
	player:SetAttribute(CarryCapacityUtil.WEIGHT_ATTRIBUTE, snapshot.weight)
	player:SetAttribute(CarryCapacityUtil.CAPACITY_ATTRIBUTE, snapshot.capacity)
	player:SetAttribute(CarryCapacityUtil.VALUE_ATTRIBUTE, snapshot.value)
	Knit.GetService("BackpackVisualService"):RefreshPlayer(player)
	self.Client.CapacityChanged:Fire(player, snapshot)
end

function CarryCapacityService:KnitStart()
	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		self:RefreshPlayer(player)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		if PlayerDataService:GetProfile(player) then
			self:RefreshPlayer(player)
		end
	end
end

return CarryCapacityService
