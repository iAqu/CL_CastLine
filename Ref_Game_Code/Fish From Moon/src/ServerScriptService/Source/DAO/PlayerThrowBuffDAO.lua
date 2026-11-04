--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--PlayerThrowBuffData在数据库中的名称
local dataServiceName = "PlayerThrowBuffData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local PlayerThrowBuffDAO = {}

--获取数据库
local function getPlayerThrowBuffDataStore(player)
    local PlayerThrowBuffDataStore = DataStore2(dataServiceName, player)
    return PlayerThrowBuffDataStore
end

--获取数据库
function PlayerThrowBuffDAO.GetPlayerThrowBuffDataStore(player)
    return getPlayerThrowBuffDataStore(player)
end

--获取数据
function PlayerThrowBuffDAO.GetPlayerThrowBuffData(player)
    local PlayerThrowBuffDataStore = getPlayerThrowBuffDataStore(player)
	local PlayerThrowBuffDafaultData = {
		Task1 = false,
		Task2 = false,
	}
    local PlayerThrowBuffData = PlayerThrowBuffDataStore:GetTable(PlayerThrowBuffDafaultData)
    return PlayerThrowBuffData
end

--更新数据
function PlayerThrowBuffDAO.UpdatePlayerThrowBuffData(player, PlayerThrowBuffData)
    local PlayerThrowBuffDataStore = getPlayerThrowBuffDataStore(player)
    PlayerThrowBuffDataStore:Set(PlayerThrowBuffData)
end

return PlayerThrowBuffDAO
