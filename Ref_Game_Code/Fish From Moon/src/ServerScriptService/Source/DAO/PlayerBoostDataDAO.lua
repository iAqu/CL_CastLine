--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)

--游戏加成在数据库中的名称
local dataServiceName = "PlayerBoost-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local PlayerBoostDataDAO = {}

--获取数据库
local function getPlayerBoostStore(player)
	local PlayerBoostStore = DataStore2(dataServiceName,player)
	return PlayerBoostStore
end

--获取数据库
function PlayerBoostDataDAO.GetPlayerBoostStore(player)
	return getPlayerBoostStore(player)
end

--获取数据
function PlayerBoostDataDAO.GetPlayerBoostData(player)
	local PlayerBoostStore = getPlayerBoostStore(player)
	--设置表的初始值
	local playerBoostData = {
		useCount = {
			["LuckPotion"] = 0,
			["SuperLuckPotion"] = 0,
			["MoneyPotion"] = 0,
		}
	}
	local playerBoostData = PlayerBoostStore:GetTable(playerBoostData)
	return playerBoostData
end

--更新数据
function PlayerBoostDataDAO.UpdatePlayerBoostData(player, playerBoostData)
	local PlayerBoostStore = getPlayerBoostStore(player)
	PlayerBoostStore:Set(playerBoostData)
end

return PlayerBoostDataDAO