-- 获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
-- 获取模块
-- 拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
-- FishRodIndexData在数据库中的名称
local dataServiceName = "FishRodIndexData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local FishRodIndexDAO = {}

-- 获取数据库
local function getFishRodIndexDataStore(player)
	local FishRodIndexDataStore = DataStore2(dataServiceName, player)
	return FishRodIndexDataStore
end

-- 获取数据库
function FishRodIndexDAO.GetFishRodIndexDataStore(player) return getFishRodIndexDataStore(player) end

-- 获取数据
function FishRodIndexDAO.GetFishRodIndexData(player)
	local FishRodIndexDataStore = getFishRodIndexDataStore(player)
	local fishRodIndexDafaultData = {
		unlockFishRod = {
			--[1] = "FishRod1",
			--[2] = "FishRod2",
			--[3] = "FishRod3",
			--[4] = "FishRod4",
			--[5] = "FishRod5",
		},
		getRewardList = {
			--[1] = "FishRodPool1",
			--[2] = "FishRodPool2",
		},
	}
	local FishRodIndexData = FishRodIndexDataStore:GetTable(fishRodIndexDafaultData)
	return FishRodIndexData
end

-- 更新数据
function FishRodIndexDAO.UpdateFishRodIndexData(player, FishRodIndexData)
	local FishRodIndexDataStore = getFishRodIndexDataStore(player)
	FishRodIndexDataStore:Set(FishRodIndexData)
end

return FishRodIndexDAO