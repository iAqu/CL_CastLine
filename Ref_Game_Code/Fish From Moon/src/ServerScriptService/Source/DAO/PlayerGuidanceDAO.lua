--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--PlayerGuidanceData在数据库中的名称
local dataServiceName = "PlayerGuidanceData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local PlayerGuidanceDAO = {}

--获取数据库
local function getPlayerGuidanceDataStore(player)
    local PlayerGuidanceDataStore = DataStore2(dataServiceName, player)
    return PlayerGuidanceDataStore
end

--获取数据库
function PlayerGuidanceDAO.GetPlayerGuidanceDataStore(player)
    return getPlayerGuidanceDataStore(player)
end

--获取数据
function PlayerGuidanceDAO.GetPlayerGuidanceData(player)
    local PlayerGuidanceDataStore = getPlayerGuidanceDataStore(player)
	local PlayerGuidanceDafaultData = {
		Task1 = false,
		Task2 = false,
		Task3 = false,
		Task4 = false,
		Welcome = false,
		
		isFirst = false,
	}
    local PlayerGuidanceData = PlayerGuidanceDataStore:GetTable(PlayerGuidanceDafaultData)
    return PlayerGuidanceData
end

--更新数据
function PlayerGuidanceDAO.UpdatePlayerGuidanceData(player, PlayerGuidanceData)
    local PlayerGuidanceDataStore = getPlayerGuidanceDataStore(player)
    PlayerGuidanceDataStore:Set(PlayerGuidanceData)
end

return PlayerGuidanceDAO
