local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodBankDataDAO = require(ServerScriptService.Source.DAO.FishRodBankDataDAO)

local FishRodBankService =Knit.CreateService {
	Name = "FishRodBankService",
	Client = {
	}
}
--获取玩家资源数据
function FishRodBankService:GetFishRodBankData(player)
	local fishRodBankData = FishRodBankDataDAO.GetFishRodBankData(player)
	return fishRodBankData
end
--获取玩家资源数据
function FishRodBankService.Client:GetFishRodBankData(player)
	local fishRodBankData = FishRodBankDataDAO.GetFishRodBankData(player)
	return fishRodBankData
end
--更新玩家资源数据
function FishRodBankService:UpdateFishRodBankData(player,fishRodBankData)
	FishRodBankDataDAO.UpdateFishRodBankData(player,fishRodBankData)
end

function FishRodBankService:KnitInit()
end

function FishRodBankService:KnitStart()
end

return FishRodBankService