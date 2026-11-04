--加载服务
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
--加载模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Monetization = require(ReplicatedStorage.Config.Monetization)

-- 通行证处理函数
local function onPromptGamePassPurchaseFinished(player, purchasedPassID, purchaseSuccess)

	local ChatService = Knit.GetService("ChatService")
	local PlayerService = Knit.GetService("PlayerService")
	local FishRodService = Knit.GetService("FishRodService")
	local GamePassService = Knit.GetService("GamePassService")
	--VIP
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.VIP.Id then
		GamePassService:AddPlayerGamePass(player,"VIP")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.VIP.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.VIP.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--Teleport
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Teleport.Id then
		GamePassService:AddPlayerGamePass(player,"Teleport")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Teleport.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Teleport.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--Luck
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Luck.Id then
		GamePassService:AddPlayerGamePass(player,"Luck")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Luck.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Luck.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--SuperLuck
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.SuperLuck.Id then
		GamePassService:AddPlayerGamePass(player,"SuperLuck")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.SuperLuck.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.SuperLuck.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--UltraLuck
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.UltraLuck.Id then
		GamePassService:AddPlayerGamePass(player,"UltraLuck")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.UltraLuck.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.UltraLuck.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--Storage+50
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Storage50.Id then
		GamePassService:AddPlayerGamePass(player,"Storage50")

		FishRodService:BuyBagStorage(player,50)

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Storage50.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Storage50.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--Storage+100
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Storage100.Id then
		GamePassService:AddPlayerGamePass(player,"Storage100")

		FishRodService:BuyBagStorage(player,100)
		
		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Storage100.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Storage100.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--NPC+1
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Equip1.Id then
		GamePassService:AddPlayerGamePass(player,"Equip1")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Equip1.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Equip1.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--NPC+1!
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.Equip1Too.Id then
		GamePassService:AddPlayerGamePass(player,"Equip1Too")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.Equip1Too.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.Equip1Too.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--Auto Chest
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.AutoChest.Id then
		GamePassService:AddPlayerGamePass(player,"AutoChest")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.AutoChest.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.AutoChest.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--TripleOpen
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.TripleOpen.Id then
		GamePassService:AddPlayerGamePass(player,"TripleOpen")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.TripleOpen.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.TripleOpen.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
	--MagicChest
	if purchaseSuccess == true and purchasedPassID==Monetization.Gamepasses.MagicChest.Id then
		GamePassService:AddPlayerGamePass(player,"MagicChest")

		local playerData = PlayerService:GetPlayerData(player)
		playerData.robloxSpend += Monetization.Gamepasses.MagicChest.Cost
		PlayerService:UpdatePlayerData(player,playerData)

		local message = player.DisplayName .." has just bought "..Monetization.Gamepasses.MagicChest.DisplayName.."!"
		local color = Color3.fromRGB(255, 255, 0)
		ChatService:SendChatNotice(message,color)
	end
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptGamePassPurchaseFinished)