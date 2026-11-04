--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--FreeGift在数据库中的名称
local dataServiceName = "FreeGift-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local FreeGiftDAO = {}

--获取数据库
local function getFreeGiftStore(player)
	local FreeGiftStore = DataStore2(dataServiceName,player)
	return FreeGiftStore
end

--获取数据库
function FreeGiftDAO.GetFreeGiftStore(player)
	return getFreeGiftStore(player)
end

--获取数据
function FreeGiftDAO.GetFreeGiftData(player)
	local FreeGiftStore = getFreeGiftStore(player)

	local FreeGiftDafaultData = {
		rewardsTime = 0,
		claimList = {},
	}
	local FreeGift = FreeGiftStore:GetTable(FreeGiftDafaultData)
	return FreeGift
end

--更新数据
function FreeGiftDAO.UpdateFreeGiftData(player, FreeGift)
	local FreeGiftStore = getFreeGiftStore(player)
	FreeGiftStore:Set(FreeGift)
end

return FreeGiftDAO