--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataDAO = require(ServerScriptService.Source.DAO.PlayerDataDAO)

local PlayerService = Knit.CreateService {
	Name = "PlayerService",
	IsPremiumPerPlayer = {},
	Client = {
	},
}
--改变玩家的Premium状态
function PlayerService.Client:ChangePlayIsPremium(player,isPremium)
	PlayerService.IsPremiumPerPlayer[player] = isPremium
end

function PlayerService.Client:SetFGame(player)
	local playerData = PlayerDataDAO.GetPlayerData(player)
	playerData.isFavorite=true
	PlayerDataDAO.UpdatePlayerData(player,playerData)
end

--获取玩家资源数据
function PlayerService:GetPlayerData(player)
	local playerData = PlayerDataDAO.GetPlayerData(player)
	return playerData
end
--获取玩家资源数据
function PlayerService.Client:GetPlayerData(player)
	local playerData = PlayerDataDAO.GetPlayerData(player)
	return playerData
end
--更新玩家资源数据
function PlayerService:UpdatePlayerData(player,playerData)
	PlayerDataDAO.UpdatePlayerData(player,playerData)
end

function PlayerService:KnitInit()
end

function PlayerService:KnitStart()
	game:GetService("Players").PlayerRemoving:Connect(function(player)
		self.IsPremiumPerPlayer[player] = nil
	end)
end

return PlayerService