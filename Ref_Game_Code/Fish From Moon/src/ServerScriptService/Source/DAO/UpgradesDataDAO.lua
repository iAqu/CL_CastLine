--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--PlayerData在数据库中的名称
local dataServiceName = "UpgradesData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local UpgradesDataDAO = {}

--获取数据库
local function getUpgradesDataStore(player)
	local UpgradesDataStore = DataStore2(dataServiceName, player)
	return UpgradesDataStore
end

--获取数据库
function UpgradesDataDAO.GetUpgradesDataStore(player)
	return getUpgradesDataStore(player)
end

--获取数据
function UpgradesDataDAO.GetUpgradesData(player)
	local UpgradesDataStore = getUpgradesDataStore(player)
	local UpgradesDafaultData = {
		speedLevel = 1,
		strengthLevel = 1,
		luckLevel = 1,
	}
	local UpgradesData = UpgradesDataStore:GetTable(UpgradesDafaultData)
	return UpgradesData
end

--更新数据
function UpgradesDataDAO.UpdateUpgradesData(player, UpgradesData)
	local UpgradesDataStore = getUpgradesDataStore(player)
	UpgradesDataStore:Set(UpgradesData)
end

return UpgradesDataDAO