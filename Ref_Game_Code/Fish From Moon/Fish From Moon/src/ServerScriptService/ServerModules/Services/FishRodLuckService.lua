--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService") 

local GamePassService
local PlayerBoostService
local FishRodIndexService
local PlayerResourceService
local PlayerGuidanceService
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)

local FishRodLuckService = Knit.CreateService {
	Name = "FishRodLuckService",
	Client = {
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

--单抽
function FishRodLuckService.Client:LuckOnce(player,poolName)
	return self.Server:LuckOnce(player,poolName)
end
function FishRodLuckService:LuckOnce(player,poolName)
	local FishRod = randomFishPool(player,poolName)
	if FishRod == nil then
		return false,"Error"
	end
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	local fishRodNum = Tool.getTableLegth(fishRodData.ownFishRodList)
	if fishRodNum >= fishRodData.fishRodbag then
		return false,"Package is full",false
	end
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	if playerResourceData then
		coin = playerResourceData.moneys
		local price = ReturnPrice(poolName,1)
		if coin-price >= 0 then
			coin = coin-price
			PlayerResourceService:ChangeMoneys(player,(-price))
			FishRodLuckService:LuckAddFishRodUseLuck(player,poolName,FishRod)

			return true,"",FishRod
		else
			return false,"Not enough Wins"
		end
	end
end
--三连
function FishRodLuckService.Client:LuckThreeTimes(player,poolName) 
	return self.Server:LuckThreeTimes(player,poolName)
end
function FishRodLuckService:LuckThreeTimes(player,poolName)
	local SSSRPet1=randomFishPool(player,poolName)
	local SSSRPet2=randomFishPool(player,poolName)
	local SSSRPet3=randomFishPool(player,poolName)
	if SSSRPet1==nil or SSSRPet2==nil or SSSRPet3==nil then
		return false,"Error"
	end
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	local fishRodNum = Tool.getTableLegth(fishRodData.ownFishRodList)
	if fishRodNum >= (fishRodData.fishRodbag - 2) then
		return false,"Package is full",false
	end
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	if playerResourceData then
		coin = playerResourceData.moneys
		local price = ReturnPrice(poolName,3)
		if coin-price >= 0 then
			coin = coin-price
			PlayerResourceService:ChangeMoneys(player,(-price))
			
			FishRodLuckService:LuckAddFishRodUseLuck(player,poolName,SSSRPet1)
			FishRodLuckService:LuckAddFishRodUseLuck(player,poolName,SSSRPet2)
			FishRodLuckService:LuckAddFishRodUseLuck(player,poolName,SSSRPet3)

			return true,"",SSSRPet1,SSSRPet2,SSSRPet3
		else
			return false,"Not enough Wins"
		end
	end
end

--返回玩家金钱
function FishRodLuckService.Client:ReturnPlayerCoin(player) 
	return self.Server:ReturnPlayerCoin(player)
end
function FishRodLuckService:ReturnPlayerCoin(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	if playerResourceData then
		return playerResourceData
	end
end

--抽加一
function FishRodLuckService:LuckAddFishRodUseLuck(player,poolName,fishRodId)
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
	local initfuse=1
	if GamePassService:IsPlayerHaveGamePass(player,"MagicChest")  then
		local randomNum=math.random(0,10000)
		if randomNum >= 0 and randomNum < 1500 then
			fishRod.fuse = 2
		elseif randomNum >= 1500 and randomNum < 1800 then
			fishRod.fuse = 3
		else
			fishRod.fuse = 1
		end
	end
	fishRodData.fishRodNum += 1
	fishRodData.ownFishRodList[tostring(fishRodData.fishRodNum)] = fishRod
	
	local fishRodIndexData = FishRodIndexService:GetFishRodIndexData(player)
	if table.find(fishRodIndexData.unlockFishRod,tostring(fishRodId)) then
	else
		table.insert(fishRodIndexData.unlockFishRod,tostring(fishRodId))
	end
	FishRodIndexService:UpdateFishRodIndexData(player,fishRodIndexData)

	FishRodDataDAO.UpdateFishRodData(player,fishRodData)

	local playerGuidanceData = PlayerGuidanceService:GetPlayerGuidanceData(player)
	if playerGuidanceData["Task3"] and not playerGuidanceData["Welcome"] and not playerGuidanceData.isFirst then
		PlayerGuidanceService:CreatWelcome(player)
	end
end

function FishRodLuckService:KnitInit()
end

function FishRodLuckService:KnitStart()
	GamePassService = Knit.GetService("GamePassService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	FishRodIndexService = Knit.GetService("FishRodIndexService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerGuidanceService = Knit.GetService("PlayerGuidanceService")
end

return FishRodLuckService