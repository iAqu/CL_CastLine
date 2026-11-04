--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--游戏通行证在数据库中的名称
local dataServiceName = "GamePass-FlyFish"
DataStore2.Combine("DATA",dataServiceName)
local GamePassDataDAO = {}

--获取数据库
local function getGamePassStore(player)
    local gamePassStore = DataStore2(dataServiceName,player)
    return gamePassStore
end

--获取数据库
function GamePassDataDAO.GetGamePassStore(player)
    return getGamePassStore(player)
end

--获取数据
function GamePassDataDAO.GetGamePassData(player)
    local gamePassStore = getGamePassStore(player)
    --设置表的初始值
    local GamePassData = {}
    --游戏通行证数据结构
    --["GamePass"] =  ▼  {
    	--["AutoClick"] = true,
    --}
    local gamePassData = gamePassStore:GetTable(GamePassData)
    return gamePassData
end

--更新数据
function GamePassDataDAO.UpdateGamePassData(player, gamePassData)
    local gamePassStore = getGamePassStore(player)
    gamePassStore:Set(gamePassData)
end

return GamePassDataDAO
