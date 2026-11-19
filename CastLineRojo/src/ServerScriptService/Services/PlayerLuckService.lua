local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerLuckUtil = require(ReplicatedStorage.Modules.PlayerLuckUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local PlayerLuckService = Knit.CreateService({
	Name = "PlayerLuckService",
	Client = { LuckChanged = Knit.CreateSignal() },
	_PlayerLuck = {} :: { [Player]: number },
})

function PlayerLuckService:GetPlayerRollLuck(player: Player): number?
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	return PlayerLuckUtil.CombineRollLuck(
		PlayerLuckUtil.GetPlacedItemLuck(profile.Data, FishInventoryData),
		GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)
	)
end

function PlayerLuckService:RefreshPlayerLuck(player: Player)
	local luck = self:GetPlayerRollLuck(player)
	if typeof(luck) ~= "number" or self._PlayerLuck[player] == luck then
		return
	end
	self._PlayerLuck[player] = luck
	self.Client.LuckChanged:Fire(player, luck)
end

function PlayerLuckService.Client:GetPlayerRollLuck(player: Player): number?
	return self.Server:GetPlayerRollLuck(player)
end

function PlayerLuckService:KnitStart()
	PlayerDataService.ProfileLoaded:Connect(function(player)
		self:RefreshPlayerLuck(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self._PlayerLuck[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:RefreshPlayerLuck(player)
	end
end

return PlayerLuckService
