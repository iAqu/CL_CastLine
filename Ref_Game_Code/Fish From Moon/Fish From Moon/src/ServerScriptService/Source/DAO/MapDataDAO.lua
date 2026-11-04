-- 获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
-- 获取模块
-- 拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
-- MapData在数据库中的名称
local dataServiceName = "MapData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local MapDAO = {}

-- 获取数据库
local function getMapDataStore(player)
    local MapDataStore = DataStore2(dataServiceName, player)
    return MapDataStore
end

-- 获取数据库
function MapDAO.GetMapDataStore(player) return getMapDataStore(player) end

-- 获取数据
function MapDAO.GetMapData(player)
    local MapDataStore = getMapDataStore(player)
	local mapDafaultData = {
		lock = {
			[1]="1",
		},
		teleptLock = {
			[1]="1",
		},
    }
    local MapData = MapDataStore:GetTable(mapDafaultData)
    return MapData
end

-- 更新数据
function MapDAO.UpdateMapData(player, MapData)
    local MapDataStore = getMapDataStore(player)
    MapDataStore:Set(MapData)
end

return MapDAO
