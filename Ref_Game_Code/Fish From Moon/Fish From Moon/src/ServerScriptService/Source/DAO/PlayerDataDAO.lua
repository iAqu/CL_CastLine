--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--PlayerData在数据库中的名称
local dataServiceName = "PlayerData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local PlayerDataDAO = {}

--获取数据库
local function getPlayerDataStore(player)
	local PlayerDataStore = DataStore2(dataServiceName, player)
	return PlayerDataStore
end

--获取数据库
function PlayerDataDAO.GetPlayerDataStore(player)
	return getPlayerDataStore(player)
end

--获取数据
function PlayerDataDAO.GetPlayerData(player)
	local PlayerDataStore = getPlayerDataStore(player)
	local PlayerDafaultData = {

		gameDuration = 0, -- 游戏时长
		robloxSpend=0,

		timeBundle=0,
		isStarterPack=false,
		
		joinGroup = false,
		joinGroupTime = 0,
		VIPTime = 0,

		isFavorite=false,
		
		walkSpeed = 26,
	}
	local PlayerData = PlayerDataStore:GetTable(PlayerDafaultData)
	return PlayerData
end

--更新数据
function PlayerDataDAO.UpdatePlayerData(player, PlayerData)
	local PlayerDataStore = getPlayerDataStore(player)
	PlayerDataStore:Set(PlayerData)
end

return PlayerDataDAO
