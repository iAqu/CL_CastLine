--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

--加载模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)
local FishHelper = require(ReplicatedStorage.Config.FishHelper)
local MoneyHelper = require(ReplicatedStorage.Config.MoneyHelper)
local Monetization = require(ReplicatedStorage.Config.Monetization)

-- 此数据存储用于跟踪已成功处理的购买流程
local purchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")

-- 表格相关设置，含有产品 ID 和处理购买操作的函数
local productFunctions = {}

-----新世界修改点
------------------------------------------------------------------------------------------boost
productFunctions[Monetization.DevProducts.LuckPotion.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",1)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.LuckPotion.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.LuckPotion10.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",10)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.LuckPotion10.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.SuperLuckPotion.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",1)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.SuperLuckPotion.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.SuperLuckPotion10.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",10)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.SuperLuckPotion10.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneyPotion.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",1)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneyPotion.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneyPotion10.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",10)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneyPotion10.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.SuperPotionsBundle.Id] = function(receipt, player)
	local PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",999)
	PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",999)
	PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",999)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.SuperPotionsBundle.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
------------------------------------------------------------------------------------------money
productFunctions[Monetization.DevProducts.MoneySmallPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySmallPack"))
	PlayerResourceService:ChangeMoneys(player,money)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneySmallPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneyMediumPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyMediumPack"))
	PlayerResourceService:ChangeMoneys(player,money)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneyMediumPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneyBigPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyBigPack"))
	PlayerResourceService:ChangeMoneys(player,money)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneyBigPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneySuperPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySuperPack"))
	PlayerResourceService:ChangeMoneys(player,money)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneySuperPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.MoneyUltraPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyUltraPack"))
	PlayerResourceService:ChangeMoneys(player,money)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.MoneyUltraPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
------------------------------------------------------------------------------------------Gem
productFunctions[Monetization.DevProducts.GemsSmallPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	PlayerResourceService:ChangeGems(player,7500)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.GemsSmallPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.GemsMediumPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	PlayerResourceService:ChangeGems(player,31250)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.GemsMediumPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.GemsBigPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	PlayerResourceService:ChangeGems(player,125000)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.GemsBigPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.GemsSuperPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	PlayerResourceService:ChangeGems(player,250000)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.GemsSuperPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
productFunctions[Monetization.DevProducts.GemsUltraPack.Id] = function(receipt, player)
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	PlayerResourceService:ChangeGems(player,750000)

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.GemsUltraPack.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end
---------------------------------跳过在线奖励
productFunctions[Monetization.DevProducts.UnlockAllOnlineRewards.Id] = function(receipt, player)     ---
	local FreeGiftService = Knit.GetService("FreeGiftService")
	
	local freeGiftData = FreeGiftService:GetFreeGiftData(player)
	freeGiftData.rewardsTime+=180*60
	FreeGiftService:ChangeFreeGiftTime(player,freeGiftData)
	FreeGiftService:UpdateFreeGiftData(player,freeGiftData)
	
	local num=0
	num=11-#(freeGiftData.claimList)
	FreeGiftService:ShowFreeRedIcon(player,num,"End")

	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend +=Monetization.DevProducts.UnlockAllOnlineRewards.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	
	return true
end
-----------------------------------------付费宠物
productFunctions[Monetization.DevProducts.RBEgg1.Id] = function(receipt, player)     ---购买宠物
	print("宠物1")
	local FishRodRBLuckService = Knit.GetService("FishRodRBLuckService")
	FishRodRBLuckService:LuckOnce(player,5)
	local PlayerService = Knit.GetService("PlayerService")
	local playerData = PlayerService:GetPlayerData(player)
	playerData.robloxSpend += Monetization.DevProducts.RBEgg1.Cost
	PlayerService:UpdatePlayerData(player,playerData)
	return true
end

-- 核心 ‘ProcessReceipt’ 回调函数
local function processReceipt(receiptInfo)
	-- 检查数据存储，判断产品是否已经发放
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased = false
	local success, errorMessage =
		pcall(
			function()
				purchased = purchaseHistoryStore:GetAsync(playerProductKey)
			end
		)
	-- 如果购买流程被记录下来，则说明产品已发放
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		error("Data store error:" .. errorMessage)
	end
	-- 找到服务器中进行购买的玩家
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- 玩家可能离开了游戏
		-- 玩家返回游戏时将会再次调用回调函数
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	-- 从上面的 ‘productFunctions’ 表格中查找处理函数
	local handler = productFunctions[receiptInfo.ProductId]
	-- 调用处理函数并捕捉错误
	local success, result = pcall(handler, receiptInfo, player)
	if not success or not result then
		print(result)
		warn("Error occurred while processing a product purchase")
		print("\nProductId:", receiptInfo.ProductId)
		print("\nPlayer:", player)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	-- 在数据存储中记录好交易内容，确保同样的产品不会被再次发放
	local success, errorMessage =
		pcall(
			function()
				purchaseHistoryStore:SetAsync(playerProductKey, true)
			end
		)
	if not success then
		error("Cannot save purchase data:" .. errorMessage)
	end
	-- 重要：告知 Roblox 购买流程已被成功处理
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- 设置回调函数，这个设置只能由服务器上的一个脚本进行一次！
MarketplaceService.ProcessReceipt = processReceipt