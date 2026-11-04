--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--CdkRewardData在数据库中的名称
local dataServiceName = "CdkRewardData-FlyFish"
DataStore2.Combine("DATA", dataServiceName)

local CdkRewardDAO = {}

--获取数据库
local function getCdkRewardDataStore(player)
    local CdkRewardDataStore = DataStore2(dataServiceName, player)
    return CdkRewardDataStore
end

--获取数据库
function CdkRewardDAO.GetCdkRewardDataStore(player)
    return getCdkRewardDataStore(player)
end

--获取数据
function CdkRewardDAO.GetCdkRewardData(player)
    local CdkRewardDataStore = getCdkRewardDataStore(player)
	local CdkRewardDafaultData = {
		
	}
    local CdkRewardData = CdkRewardDataStore:GetTable(CdkRewardDafaultData)
    return CdkRewardData
end

--更新数据
function CdkRewardDAO.UpdateCdkRewardData(player, CdkRewardData)
    local CdkRewardDataStore = getCdkRewardDataStore(player)
    CdkRewardDataStore:Set(CdkRewardData)
end

return CdkRewardDAO
