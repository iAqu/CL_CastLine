local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)
local FishRodIndexDataDAO = require(ServerScriptService.Source.DAO.FishRodIndexDataDAO)

local PlayerResourceService

local FishRodIndexService =Knit.CreateService {
	Name = "FishRodIndexService",
	Client = {
		ChangeFishRodIndexData = Knit.CreateSignal(),
	}
}

--领取奖励
function FishRodIndexService.Client:GetReward(player,indexId)
	local fishRodIndexData = FishRodIndexDataDAO.GetFishRodIndexData(player)
	local fishRodPoolList = FishRoadPoolHelper.GetFishRoadPoolInfo(indexId)
	for k,v in ipairs(fishRodPoolList.pool) do
		if table.find(fishRodIndexData.unlockFishRod,tostring(v.fishRod)) then
		else
			return false
		end
	end
	local rewardWins = fishRodPoolList.indexReward[1]
	local rewardGems = fishRodPoolList.indexReward[2]

	PlayerResourceService:ChangeMoneys(player,rewardWins)
	PlayerResourceService:ChangeGems(player,rewardGems)
	
	table.insert(fishRodIndexData.getRewardList,tostring(fishRodPoolList.fishRoadPoolName))
	FishRodIndexDataDAO.UpdateFishRodIndexData(player,fishRodIndexData)
	
	FishRodIndexService:ChangeFishRodIndexData(player)
end

--ChangeMapData
function FishRodIndexService:ChangeFishRodIndexData(player)
	self.Client.ChangeFishRodIndexData:Fire(player)
end
--获取玩家资源数据
function FishRodIndexService:GetFishRodIndexData(player)
	local fishRodIndexData = FishRodIndexDataDAO.GetFishRodIndexData(player)
	return fishRodIndexData
end
--获取玩家资源数据
function FishRodIndexService.Client:GetFishRodIndexData(player)
	local fishRodIndexData = FishRodIndexDataDAO.GetFishRodIndexData(player)
	return fishRodIndexData
end
--更新玩家资源数据
function FishRodIndexService:UpdateFishRodIndexData(player,fishRodIndexData)
	FishRodIndexDataDAO.UpdateFishRodIndexData(player,fishRodIndexData)
end

function FishRodIndexService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function FishRodIndexService:KnitStart()
end

return FishRodIndexService