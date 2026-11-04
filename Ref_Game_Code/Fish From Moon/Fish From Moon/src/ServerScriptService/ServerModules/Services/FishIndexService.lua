local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishDataDAO = require(ServerScriptService.Source.DAO.FishDataDAO)

local FishIndexService =Knit.CreateService {
	Name = "FishIndexService",
	Client = {
		ChangeFishIndexData = Knit.CreateSignal(),
	}
}
--ChangeMapData
function FishIndexService:ChangeFishIndexData(player)
	self.Client.ChangeFishIndexData:Fire(player)
end
--获取玩家资源数据
function FishIndexService:GetFishIndexData(player)
	local fishData = FishDataDAO.GetFishData(player)
	return fishData
end
--获取玩家资源数据
function FishIndexService.Client:GetFishIndexData(player)
	local fishData = FishDataDAO.GetFishData(player)
	return fishData
end
--更新玩家资源数据
function FishIndexService:UpdateFishIndexData(player,fishData)
	FishDataDAO.UpdateFishData(player,fishData)
end

function FishIndexService:KnitInit()
end

function FishIndexService:KnitStart()
end

return FishIndexService