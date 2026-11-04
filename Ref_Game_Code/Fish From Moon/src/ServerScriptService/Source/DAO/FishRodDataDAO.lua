-- 获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
-- 获取模块
-- 拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
-- FishRodData在数据库中的名称
local dataServiceName = "FishRodData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local FishRodDAO = {}

-- 获取数据库
local function getFishRodDataStore(player)
	local FishRodDataStore = DataStore2(dataServiceName, player)
	return FishRodDataStore
end

-- 获取数据库
function FishRodDAO.GetFishRodDataStore(player) return getFishRodDataStore(player) end

-- 获取数据
function FishRodDAO.GetFishRodData(player)
	local FishRodDataStore = getFishRodDataStore(player)
	local fishRodDafaultData = {
		fishRodNum = 1,
		fishRodbag = 50,
		usingFishRodList = {
			[1] = "1"
		},
		ownFishRodList = {
			["1"]={
				name = "Rod",
				level = 1,
				exp = 0,
				fuse = 1,
				enchant = 0,
				enchantNum = 0,
				lock = false,
			},
			--["2"]={
			--	name = "Rod",
			--	level = 0,
			--	exp = 0,
			--	fuse = 2,
			--	enchant = 1,
			--	enchantNum = 0,
			--	lock = false,
			--},
		},
	}
	local FishRodData = FishRodDataStore:GetTable(fishRodDafaultData)
	return FishRodData
end

-- 更新数据
function FishRodDAO.UpdateFishRodData(player, FishRodData)
	local FishRodDataStore = getFishRodDataStore(player)
	FishRodDataStore:Set(FishRodData)
end

return FishRodDAO