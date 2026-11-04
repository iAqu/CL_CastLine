local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FishRodService
local PlayerResourceService
-- 获取数据服务
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodEnchantHelper = require(ReplicatedStorage.Config.FishRodEnchantHelper)

local EnchantService =Knit.CreateService {
	Name = "EnchantService",
	Client = {
	}
}

function getRandomByWeight(data, maxWorld)
	local filtered = {}

	-- 筛选符合 world >= maxWorld 的项
	for i, item in ipairs(data) do
		if item.world <= maxWorld then
			table.insert(filtered, {index = i, weight = item.weight})
		end
	end
	-- 如果没有符合条件的项
	if #filtered == 0 then
		return nil
	end

	-- 计算总权重
	local totalWeight = 0
	for _, item in ipairs(filtered) do
		totalWeight = totalWeight + item.weight
	end

	-- 随机选择
	local rand = math.random() * totalWeight
	local cumulative = 0
	for _, item in ipairs(filtered) do
		cumulative = cumulative + item.weight
		if rand <= cumulative then
			return item.index
		end
	end

	return nil -- 理论上不会走到这里
end

function EnchantService.Client:FishRodEnchant(player,fishRodId)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	local fishRodData = FishRodService:GetFishRodData(player)
	
	local sumGem = 1000 + (fishRodData["ownFishRodList"][fishRodId].enchantNum * 150)
	
	if playerResourceData.gems < sumGem then
		return false,"Diamonds are insufficient"
	end
	PlayerResourceService:ChangeGems(player,(-sumGem))
	local EnchantList = FishRodEnchantHelper.GetEnchant()
	local en = getRandomByWeight(EnchantList,playerResourceData.maxWorld)

	fishRodData["ownFishRodList"][fishRodId].enchant = en
	fishRodData["ownFishRodList"][fishRodId].enchantNum += 1
	FishRodService:UpdateFishRodData(player,fishRodData)
	return true,FishRodEnchantHelper.GetEnchantIndex(en).txtInfo,FishRodEnchantHelper.GetEnchantIndex(en).img
end

function EnchantService:KnitInit()
	FishRodService = Knit.GetService("FishRodService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function EnchantService:KnitStart()
end

return EnchantService