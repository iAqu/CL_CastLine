--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService") 

local GamePassService
local PlayerBoostService
local FishRodIndexService
local PlayerResourceService
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)

local FishRodRBLuckService = Knit.CreateService {
	Name = "FishRodRBLuckService",
	Client = {
		LuckOnce =Knit.CreateSignal(),
	},
}
--算价格
local function ReturnPrice(fishRodPoolId,num)
	return FishRoadPoolHelper.GetFishRoadPoolInfo(fishRodPoolId).prince * num
end

local coin=0     ---拿到玩家金钱

local function calculateLuck(player)
	local sumLuck=1

	---通行证
	local passUp=0
	if GamePassService:IsPlayerHaveGamePass(player,"Luck")  then
		passUp+=0.7
	end
	if GamePassService:IsPlayerHaveGamePass(player,"SuperLuck")  then
		passUp+=1.3
	end
	if GamePassService:IsPlayerHaveGamePass(player,"UltraLuck")  then
		passUp+=2.2
	end
	--print(passUp)

	--boost
	local boostUp = 0
	if PlayerBoostService:IsPlayerHaveBoost(player,"LuckBoost") then
		boostUp += 0.5
	end
	local boostUp=0
	if PlayerBoostService:IsPlayerHaveBoost(player,"SuperLuckPotion") then
		boostUp += 1
	end
	--print(boostUp)

	sumLuck=sumLuck+passUp+boostUp

	return sumLuck
end

local function randomFishPool(player,fishRodPoolId)
	local fishRodPoolList = FishRoadPoolHelper.GetFishRoadPool(fishRodPoolId)
	local totalWeight = 0

	-- 计算总权重
	for k, fishRodPoolData in pairs(fishRodPoolList) do
		local fishRodPoolDataWeight = fishRodPoolData.weight
		if k>=3 then
			fishRodPoolDataWeight = fishRodPoolDataWeight * calculateLuck(player)
		end
		totalWeight = totalWeight + fishRodPoolDataWeight
	end

	-- 生成随机数（范围：1 到 totalWeight）
	local randomPick = math.random(1, totalWeight)
	local cumulativeWeight = 0

	-- 遍历鱼列表，找到符合的鱼
	for k, fishData in pairs(fishRodPoolList) do
		local fishDataWeight = fishData.weight
		if k>=3 then
			fishDataWeight = fishDataWeight * calculateLuck(player)
		end
		cumulativeWeight = cumulativeWeight + fishDataWeight
		if randomPick <= cumulativeWeight then
			return fishData.fishRod
		end
	end
end

function FishRodRBLuckService:LuckOnce(player,poolName)
	local FishRod = randomFishPool(player,poolName)
	if FishRod == nil then
		return false,"Error"
	end
	FishRodRBLuckService:LuckAddFishRodUseLuck(player,poolName,FishRod)
	
	self.Client.LuckOnce:Fire(player,poolName,FishRod)
end

--抽加一
function FishRodRBLuckService:LuckAddFishRodUseLuck(player,poolName,fishRodId)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	local fishRod
	fishRod={
		name = tostring(fishRodId),
		level = 1,
		exp = 0,
		fuse = 1,
		enchant = 0,
		enchantNum = 0,
		lock = false,
	}
	fishRodData.fishRodNum += 1
	fishRodData.ownFishRodList[tostring(fishRodData.fishRodNum)] = fishRod
	
	local fishRodIndexData = FishRodIndexService:GetFishRodIndexData(player)
	if table.find(fishRodIndexData.unlockFishRod,tostring(fishRodId)) then
	else
		table.insert(fishRodIndexData.unlockFishRod,tostring(fishRodId))
	end
	FishRodIndexService:UpdateFishRodIndexData(player,fishRodIndexData)

	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
end

function FishRodRBLuckService:KnitInit()
end

function FishRodRBLuckService:KnitStart()
	GamePassService = Knit.GetService("GamePassService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	FishRodIndexService = Knit.GetService("FishRodIndexService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

return FishRodRBLuckService