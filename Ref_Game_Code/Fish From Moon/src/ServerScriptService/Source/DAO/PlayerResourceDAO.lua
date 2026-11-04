--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--PlayerResource在数据库中的名称
local dataServiceName = "PlayerResource-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local PlayerResourceDAO = {}

local function getPlayerResourceStore(player)
	local PlayerResourceStore = DataStore2(dataServiceName,player)
	return PlayerResourceStore
end

--获取数据库
function PlayerResourceDAO.GetPlayerResourceStore(player)
	return getPlayerResourceStore(player)
end

--获取数据
function PlayerResourceDAO.GetPlayerResourceData(player)
	local PlayerResourceStore = getPlayerResourceStore(player)
	--定义默认数据
	local playerResourceDafaultData = {
		
		--排行榜的数值
		sumMoneys = 0,
		sumGems = 0,
		sumFish = 0,
		
		moneys = 0, -- 金币
		gems = 0, -- 宝石
		
		world = 1, -- 当前世界
		maxWorld = 1, -- 最高世界
		maxLine = 0, --最大成功距离
		

		isGetDaily=false,---是否领了每日
		
		isTrade=true
	}
	local playerResourceData = PlayerResourceStore:GetTable(playerResourceDafaultData)
	return playerResourceData
end

--更新数据
function PlayerResourceDAO.UpdatePlayerResource(player, playerResourceData)
	local PlayerResourceStore = getPlayerResourceStore(player)
	PlayerResourceStore:Set(playerResourceData)
end

return PlayerResourceDAO