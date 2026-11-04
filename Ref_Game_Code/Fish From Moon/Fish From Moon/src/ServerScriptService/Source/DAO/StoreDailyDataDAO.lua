--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--DailyRewardData在数据库中的名称
local dataServiceName = "StoreDailyData-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local StoreDailyDataDAO = {}

--获取数据库
local function getStoreDailyDataStore(player)
	local StoreDailyDataStore = DataStore2(dataServiceName,player)
	return StoreDailyDataStore
end

--获取数据库
function StoreDailyDataDAO.GetStoreDailyDataStore(player)
	return getStoreDailyDataStore(player)
end

--获取数据
function StoreDailyDataDAO.GetStoreDailyData(player)
	local StoreDailyDataStore = getStoreDailyDataStore(player)

	local StoreDailyDafaultData = {
		rewardlist = {
			--1,
			--1,
			--2,
			--2,
			--1,
			--3,
			--1,
		},
		alreadyGet = 0,
		dayIndex = {
			year = 0,
			month = 0,
			day = 0
		},
	}

	local StoreDailyData = StoreDailyDataStore:GetTable(StoreDailyDafaultData)
	return StoreDailyData
end

--更新数据
function StoreDailyDataDAO.UpdateStoreDailyData(player, StoreDailyData)
	local StoreDailyDataStore = getStoreDailyDataStore(player)
	StoreDailyDataStore:Set(StoreDailyData)
end

return StoreDailyDataDAO
