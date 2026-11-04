-- 获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
-- 获取模块
-- 拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
-- FishData在数据库中的名称
local dataServiceName = "FishData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local FishDAO = {}

-- 获取数据库
local function getFishDataStore(player)
	local FishDataStore = DataStore2(dataServiceName, player)
	return FishDataStore
end

-- 获取数据库
function FishDAO.GetFishDataStore(player) return getFishDataStore(player) end

-- 获取数据
function FishDAO.GetFishData(player)
	local FishDataStore = getFishDataStore(player)
	local fishDafaultData = {
		unlockFish ={
			--[1] = "Fish1",
			--[2] = "Fish2",
			--[3] = "Fish4",
			--[4] = "Fish5",
		},
		FishWeight = {
			--["Fish1"] = 100,
			--["Fish2"] = 100,
			--["Fish4"] = 100,
		},
	}
	local FishData = FishDataStore:GetTable(fishDafaultData)
	return FishData
end

-- 更新数据
function FishDAO.UpdateFishData(player, FishData)
	local FishDataStore = getFishDataStore(player)
	FishDataStore:Set(FishData)
end

return FishDAO