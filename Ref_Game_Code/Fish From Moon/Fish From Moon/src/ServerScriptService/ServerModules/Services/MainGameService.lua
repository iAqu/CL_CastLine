--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishHelper = require(ReplicatedStorage.Config.FishHelper)
local ComboHelper = require(ReplicatedStorage.Config.ComboHelper)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local FishPoolHelper = require(ReplicatedStorage.Config.FishPoolHelper)
local UpgradesHelper = require(game.ReplicatedStorage.Config.UpgradesHelper)
local OverAllCombo = require(ReplicatedStorage.OverallSituation.OverAllCombo)
local FishRodLevelHelper = require(ReplicatedStorage.Config.FishRodLevelHelper)
local FishRodEnchantHelper = require(ReplicatedStorage.Config.FishRodEnchantHelper)

local MapService
local SoundService
local PlayerService
local FishRodService
local MainGuiService
local UpgradesService
local GamePassService
local FishIndexService
local PlayerBoostService
local PlayerResourceService
local PlayerGuidanceService
local PlayerThrowBuffService


local PlayerEndFish = {}
local PlayerFishWeight = {}

local MainGameService = Knit.CreateService {
	Name = "MainGameService",
	Client = {
		SendInfoToAllPlayer = Knit.CreateSignal(),
		
		SoundFishSizeReward = Knit.CreateSignal(),
	},
}
function MainGameService:SendInfoToAllPlayer(player,landingPoint,isWin,fishType,newFish)
	self.Client.SendInfoToAllPlayer:FireAll(player,landingPoint,isWin,fishType,newFish)
end

function MainGameService:SoundFishSizeReward(player,soundName)
	self.Client.SoundFishSizeReward:Fire(player,soundName)
end

local function returnFishPool(playerPos)
	local list = FishPoolHelper.GetFishPool()
	local index = 0
	local ret = list[50]
	for k, v in pairs(list) do
		if playerPos > k then
			if index < k then
				index = k
				ret = v
			end
		end
	end
	return ret
end
local function randomFishPool(player,fishList)
	local totalWeight = 0

	local updateData = UpgradesService:GetUpgradesData(player)
	local fishRodData = FishRodService:GetFishRodData(player)
	-- 计算总权重
	for k, fishData in pairs(fishList) do
		local fishDataWeight = fishData.weight
		
		local enchantUp = 0
		if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant > 15 and fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant < 21 then
			enchantUp = FishRodEnchantHelper.GetEnchantIndex(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant).buff
		end
		if k > 4 then
			fishDataWeight += enchantUp
		end
		
		if k>=3 then
			fishDataWeight = fishDataWeight * UpgradesHelper.GetUpgradesNum("luckLevel",updateData.luckLevel)
		end
		totalWeight = totalWeight + fishDataWeight
	end

	-- 生成随机数（范围：1 到 totalWeight）
	local randomPick = math.random(1, totalWeight)
	local cumulativeWeight = 0

	-- 遍历鱼列表，找到符合的鱼
	for k, fishData in pairs(fishList) do
		local fishDataWeight = fishData.weight
		if k>=3 then
			fishDataWeight = fishDataWeight * UpgradesHelper.GetUpgradesNum("luckLevel",updateData.luckLevel)
		end
		cumulativeWeight = cumulativeWeight + fishDataWeight
		if randomPick <= cumulativeWeight then
			return fishData.fish -- 返回选中的鱼
		end
	end
end

local function flyFishHook(player:Player,percent)
	local isWin
	local fishiList
	local endFish
	local baseFishW
	local newFish = false
	local updateData = UpgradesService:GetUpgradesData(player)
	local disNum = UpgradesHelper.GetUpgradesNum("strengthLevel",updateData.strengthLevel) * (0.5 + (1 - percent) * 0.5)
	local distanceZ = player.Character.HumanoidRootPart.Position.Z - disNum
	if distanceZ <= 30 then
		distanceZ = 1
		--print("这个获胜")
		isWin = true
		fishiList = returnFishPool(player.Character.HumanoidRootPart.Position.Z)
		endFish = randomFishPool(player,fishiList)
		PlayerEndFish[player.UserId] = endFish

		OverAllCombo.Combo += 1

		baseFishW = FishHelper.GetFish(endFish).baseWeight * UpgradesHelper.GetUpgradesNum("luckLevel",updateData.luckLevel)
		local randomOffset = math.random() * 0.4 - 0.2
		baseFishW = baseFishW * (1 + randomOffset)
		PlayerFishWeight[player.UserId] = baseFishW

		local fishIndexData = FishIndexService:GetFishIndexData(player)
		if table.find(fishIndexData.unlockFish,tostring(endFish)) then
			if tonumber(fishIndexData.FishWeight[tostring(endFish)]) <= baseFishW then
				fishIndexData.FishWeight[tostring(endFish)] = baseFishW
			end
		else
			table.insert(fishIndexData.unlockFish,tostring(endFish))
			fishIndexData.FishWeight[tostring(endFish)] = baseFishW
			newFish = true
		end
		FishIndexService:UpdateFishIndexData(player,fishIndexData)
	else
		print("没赢")
		isWin = false
		OverAllCombo.Combo = 0
	end
	local landingPoint = Vector3.new(0, 5, distanceZ)
	MainGameService:SendInfoToAllPlayer(player,landingPoint,isWin,endFish,newFish)
end
--装备武器
function MainGameService.Client:FlyFishHook(player,UIX)
	--print(player)
	--print(UIX)
	flyFishHook(player,UIX)
end

local function calculateCoin(player:Player)
	local upBuff=1

	----鱼竿金钱倍率
	local fishRodUp=1
	local fishRodData = FishRodService:GetFishRodData(player)
	fishRodUp = FishRodHelper.GetFishRod(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].name).baseMultiplier
	if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].fuse == 2 then
		fishRodUp = fishRodUp * 3
	elseif fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].fuse == 3 then
		fishRodUp = fishRodUp * 10
	elseif fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].fuse == 4 then
		fishRodUp = fishRodUp * 20
	end
	
	local levelUp = 1
	levelUp = FishRodLevelHelper.GetlevelUp(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].level)
	fishRodUp = fishRodUp * levelUp
	
	local enchantUp = 1
	if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant > 0 and fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant < 6 then
		enchantUp = FishRodEnchantHelper.GetEnchantIndex(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant).buff
	end
	fishRodUp = fishRodUp * enchantUp
	--print("fishRodUp "..fishRodUp)

	----鱼金钱倍率
	local fishUp=1
	fishUp = FishHelper.GetFish(PlayerEndFish[player.UserId]).baseMultiplier
	--print("fishUp "..fishUp)
	
	--boost
	local boostUp=1
	if PlayerBoostService:IsPlayerHaveBoost(player,"MoneyPotion") then
		boostUp+=1
	end
	
	--计算Premium
	local premiumUp=1 
	if PlayerService.IsPremiumPerPlayer[player] then
		premiumUp += 0.1
	end
	--print("大会员"..premiumUp)
	
	---好友
	local friendsUp=1
	local friendsData=FriendsService:GetFriendsData(player)
	local num=#(friendsData.friendList)
	if num>10 then
		friendsUp += 0.5
	else
		friendsUp += (0.05 * num)
	end
	--print("friendsUp"..friendsUp)

	upBuff=upBuff*fishRodUp*fishUp*boostUp*premiumUp*friendsUp

	return upBuff
end

local function getComboMultiplier(comboCount)
	local bestKey = 0  -- 记录最大但不超过comboCount的Key
	local ComboConfig = ComboHelper.GetComboList()
	for key, _ in pairs(ComboConfig) do
		if key <= comboCount and key > bestKey then
			bestKey = key
		end
	end

	return ComboConfig[bestKey] or 0 -- 确保不会出错
end

function MainGameService.Client:GamePhotoMoney(player:Player)
	--距离
	local dis = player.Character.HumanoidRootPart.Position.Z - 30
	
	local enchantUp = 1
	local fishRodData = FishRodService:GetFishRodData(player)
	if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant > 10 and fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant < 16 then
		enchantUp = FishRodEnchantHelper.GetEnchantIndex(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant).buff
	end
	--基础金币
	local baseMoney = dis
	baseMoney *= calculateCoin(player)
	local photoMoney = baseMoney * 0.1 * enchantUp + 20
	local photoGem = 100 * enchantUp
	if math.random() > 0.6 then
		PlayerResourceService:ChangeMoneys(player,photoMoney)
		task.delay(0.5,function()
			MainGuiService:ShowMessageEffect(player,"snapgold",photoMoney)
		end)
	else
		PlayerResourceService:ChangeGems(player,photoGem)
		task.delay(0.5,function()
			MainGuiService:ShowMessageEffect(player,"snapgem",photoGem)
		end)
	end
end

function MainGameService.Client:GameWinGetMoney(player:Player,throwBuff)
	--距离
	local dis = player.Character.HumanoidRootPart.Position.Z - 30
	MainGuiService:ShowMessageEffect(player,"distance",dis)
	---排行榜钓鱼总数+1
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.sumFish += 1
	if player.Character.HumanoidRootPart.Position.Z > playerResourceData.maxLine then
		playerResourceData.maxLine = player.Character.HumanoidRootPart.Position.Z
	end
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	MapService:ChangeMaxLine(player)
	--基础金币
	local baseMoney = dis
	baseMoney *= calculateCoin(player)
	PlayerResourceService:ChangeMoneys(player,baseMoney)
	task.delay(0.5,function()
		MainGuiService:ShowMessageEffect(player,"gold",baseMoney)
	end)
	---连击数金币
	local comboCount = OverAllCombo.Combo
	local comboMultiplier = getComboMultiplier(comboCount)
	local comboMoney = baseMoney * comboMultiplier
	PlayerResourceService:ChangeMoneys(player,comboMoney)
	if comboMoney <= 0 then
	else
		task.delay(1,function()
			MainGuiService:ShowMessageEffect(player,"combo",comboMoney)
		end)
	end
	--鱼体型额外金币
	local fishWeightMultiplier = 1
	if PlayerFishWeight[player.UserId] >= FishHelper.GetFish(PlayerEndFish[player.UserId]).baseWeight * 1.2 then
		local fishWMoney = baseMoney * 0.1
		PlayerResourceService:ChangeMoneys(player,fishWMoney)
		task.delay(1.5,function()
			MainGuiService:ShowMessageEffect(player,"size",fishWMoney)
		end)
		MainGameService:SoundFishSizeReward(player,"FishRewared3")
	elseif PlayerFishWeight[player.UserId] >= FishHelper.GetFish(PlayerEndFish[player.UserId]).baseWeight * 1.35 then
		local fishWMoney = baseMoney * 0.3
		PlayerResourceService:ChangeMoneys(player,fishWMoney)
		task.delay(1.5,function()
			MainGuiService:ShowMessageEffect(player,"size",fishWMoney)
		end)
		MainGameService:SoundFishSizeReward(player,"FishRewared3")
	else
		MainGameService:SoundFishSizeReward(player,"FishRewared1")
	end
	--鱼竿经验
	local fishRodData = FishRodService:GetFishRodData(player)
	local fishInfo  = fishRodData.ownFishRodList[tostring(fishRodData["usingFishRodList"][1])]
	---通行证
	local passUp = 1
	if GamePassService:IsPlayerHaveGamePass(player,"VIP")  then
		passUp += 0.5
	end
	local endExp = tonumber(dis) * passUp
	fishInfo.exp += endExp
	if fishInfo.exp >= FishRodHelper.GetFishRod(fishInfo.name).baseExp * FishRodLevelHelper.GetExpSum(fishInfo.level) then
		fishInfo.exp -= FishRodHelper.GetFishRod(fishInfo.name).baseExp * FishRodLevelHelper.GetExpSum(fishInfo.level)
		if fishInfo.level < 20 then
			fishInfo.level += 1
		end
	end
	task.delay(2,function()
		MainGuiService:ShowMessageEffect(player,"xp",endExp)
	end)
	FishRodService:UpdateFishRodData(player,fishRodData)
	
	if throwBuff then
		local throwBuffMoney = baseMoney * 0.25
		PlayerResourceService:ChangeMoneys(player,throwBuffMoney)
		task.delay(2.5,function()
			MainGuiService:ShowMessageEffect(player,"bonus",throwBuffMoney)
		end)
	end
	
	local playerGuidanceData = PlayerGuidanceService:GetPlayerGuidanceData(player)
	local playerThrowBuffData = PlayerThrowBuffService:GetPlayerThrowBuffData(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	if playerGuidanceData["Task1"] and not playerGuidanceData["Task2"] and not playerGuidanceData.isFirst then
		PlayerGuidanceService:DestoryTask1Guidance(player)
	end
	if not playerThrowBuffData["Task1"] and not playerThrowBuffData["Task2"] then
		PlayerThrowBuffService:DestoryTask1ThrowBuff(player)
	end
	if playerThrowBuffData["Task1"] and not playerThrowBuffData["Task2"] then
		PlayerThrowBuffService:DestoryTask2ThrowBuff(player)
	end
	if playerGuidanceData["Task2"] and not playerGuidanceData["Task4"] and not playerGuidanceData.isFirst and playerResourceData.sumFish >= 6 then
		PlayerGuidanceService:CreatTask4Guidance(player)
	end
end

function MainGameService:KnitInit()
	MapService = Knit.GetService("MapService")
	SoundService = Knit.GetService("SoundService")
	PlayerService = Knit.GetService("PlayerService")
	FishRodService = Knit.GetService("FishRodService")
	MainGuiService = Knit.GetService("MainGuiService")
	FriendsService = Knit.GetService("FriendsService")
	GamePassService = Knit.GetService("GamePassService")
	UpgradesService = Knit.GetService("UpgradesService")
	FishIndexService = Knit.GetService("FishIndexService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerGuidanceService = Knit.GetService("PlayerGuidanceService")
	PlayerThrowBuffService = Knit.GetService("PlayerThrowBuffService")
end

function MainGameService:KnitStart()
	Players.PlayerRemoving:Connect(function(player)
		PlayerEndFish[player.UserId] = nil
	end)
end

return MainGameService