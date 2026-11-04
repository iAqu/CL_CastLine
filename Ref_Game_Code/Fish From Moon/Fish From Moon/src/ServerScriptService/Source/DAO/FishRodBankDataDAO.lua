-- 获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
-- 获取模块
-- 拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
-- FishRodBankData在数据库中的名称
local dataServiceName = "FishRodBankData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local FishRodBankDAO = {}

-- 获取数据库
local function getFishRodBankDataStore(player)
	local FishRodBankDataStore = DataStore2(dataServiceName, player)
	return FishRodBankDataStore
end

-- 获取数据库
function FishRodBankDAO.GetFishRodBankDataStore(player) return getFishRodBankDataStore(player) end

-- 获取数据
function FishRodBankDAO.GetFishRodBankData(player)
	local FishRodBankDataStore = getFishRodBankDataStore(player)
	local fishRodBankDafaultData = {
		fishRodRankLevel = 1,
		fishRodRankBag = 50,
		cliamTime = 0,
		payGems = 0,
		bankList = {
			--["1"]={
			--	name = "FishRod1",
			--	level = 0,
			--	exp = 0,
			--	fuse = 1,
			-- enchant = 1,
			-- enchantNum = 0,
			--	lock = false,
			--},
			--["2"]={
			--	name = "FishRod2",
			--	level = 0,
			--	exp = 0,
			--	fuse = 1,
			--  enchant = 1,
			--  enchantNum = 0,
			--	lock = false,
			--},
		},
	}
	local FishRodBankData = FishRodBankDataStore:GetTable(fishRodBankDafaultData)
	return FishRodBankData
end

-- 更新数据
function FishRodBankDAO.UpdateFishRodBankData(player, FishRodBankData)
	local FishRodBankDataStore = getFishRodBankDataStore(player)
	FishRodBankDataStore:Set(FishRodBankData)
end

return FishRodBankDAO