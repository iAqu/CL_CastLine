--加载服务
local ServerScriptService = game:GetService("ServerScriptService")
local MarkPlaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
--加载模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Monetization = require(ReplicatedStorage.Config.Monetization)

Players.PlayerAdded:Connect(function(player)
	task.wait(3)
	if player then
		local GamePassService = Knit.GetService("GamePassService")
		local FishRodService = Knit.GetService("FishRodService")
		task.spawn(function()
			pcall(function()
				--VIP
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.VIP.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"VIP") then
						GamePassService:AddPlayerGamePass(player,"VIP")
					end
				end
				--Teleport
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Teleport.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Teleport") then
						GamePassService:AddPlayerGamePass(player,"Teleport")
					end
				end
				--Luck
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Luck.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Luck") then
						GamePassService:AddPlayerGamePass(player,"Luck")
					end
				end
				--SuperLuck
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.SuperLuck.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"SuperLuck") then
						GamePassService:AddPlayerGamePass(player,"SuperLuck")
					end
				end
				--UltraLuck
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.UltraLuck.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"UltraLuck") then
						GamePassService:AddPlayerGamePass(player,"UltraLuck")
					end
				end
				--Storage50
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Storage50.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Storage50") then
						GamePassService:AddPlayerGamePass(player,"Storage50")
						FishRodService:BuyBagStorage(player,50)
					end
				end
				--Storage100
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Storage100.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Storage100") then
						GamePassService:AddPlayerGamePass(player,"Storage100")
						FishRodService:BuyBagStorage(player,100)
					end
				end
				--Equip1
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Equip1.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Equip1") then
						GamePassService:AddPlayerGamePass(player,"Equip1")
					end
				end
				--Equip1Too
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.Equip1Too.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"Equip1Too") then
						GamePassService:AddPlayerGamePass(player,"Equip1Too")
					end
				end
				--AutoChest
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.AutoChest.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"AutoChest") then
						GamePassService:AddPlayerGamePass(player,"AutoChest")
					end
				end
				--TripleOpen
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.TripleOpen.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"TripleOpen") then
						GamePassService:AddPlayerGamePass(player,"TripleOpen")
					end
				end
				--MagicChest
				if MarkPlaceService:UserOwnsGamePassAsync(player.UserId,Monetization.Gamepasses.MagicChest.Id) and game.Players:FindFirstChild(player.Name) then
					if not GamePassService:IsPlayerHaveGamePass(player,"MagicChest") then
						GamePassService:AddPlayerGamePass(player,"MagicChest")
					end
				end
			end)
		end)
	end
end)