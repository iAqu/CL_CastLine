--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--DailyRewardData在数据库中的名称
local dataServiceName = "DailyRewardData-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local DailyRewardDataDAO = {}

--获取数据库
local function getDailyRewardDataStore(player)
	local DailyRewardDataStore = DataStore2(dataServiceName,player)
	return DailyRewardDataStore
end

--获取数据库
function DailyRewardDataDAO.GetDailyRewardDataStore(player)
	return getDailyRewardDataStore(player)
end

--获取数据
function DailyRewardDataDAO.GetDailyRewardData(player)
	local DailyRewardDataStore = getDailyRewardDataStore(player)

	local DailyRewardDafaultData = {
		rewardsMax = 0,
		rewardsTime = 0,
		claimList = {},
	}

	local DailyRewardData = DailyRewardDataStore:GetTable(DailyRewardDafaultData)
	return DailyRewardData
end

--更新数据
function DailyRewardDataDAO.UpdateDailyRewardData(player, DailyRewardData)
	local DailyRewardDataStore = getDailyRewardDataStore(player)
	DailyRewardDataStore:Set(DailyRewardData)
end

return DailyRewardDataDAO
