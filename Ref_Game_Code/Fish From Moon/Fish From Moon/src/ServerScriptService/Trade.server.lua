local ServerScriptService = game:GetService("ServerScriptService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")

local Remotes=ReplicatedStorage:WaitForChild("Remotes")
--获取模组
local FishRodLevelHelper = require(ReplicatedStorage.Config.FishRodLevelHelper)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)

local TradeAccepted = {}
local TradeSelected={}
local TradeRequests={}
local Trading={}

local NotTrade={}
local function CloseTrade(targetId)
	return table.find(NotTrade,targetId)
end

local function IsTrading(player:Player)
	return Trading[player.UserId]
end

local function IsOnCooldown(playerId,targetId)
	local requests=TradeRequests[playerId]
	if not requests then
		return
	end
	return table.find(requests,targetId)
end

local function HasSentRequest(accepterID:number,senderID:number)
	local requestTable=TradeRequests[senderID]
	if not requestTable then
		return
	end
	if table.find(requestTable,accepterID) then
		return true
	end
	return false
end

local function SendTradeRequest(player:Player,targetID:number)
	local target=Players:GetPlayerByUserId(targetID)
	if not target then return end
	if IsOnCooldown(player.UserId,targetID) then
		return
	end
	
	if CloseTrade(targetID) then
		return
	end
	
	local playerTable=TradeRequests[player.UserId]
	if not playerTable then
		TradeRequests[player.UserId]={}
		playerTable=TradeRequests[player.UserId]
	end
	Remotes.TradeRequestReceived:FireClient(target,player)
	table.insert(playerTable,targetID)
	task.delay(15,function()
		local index=table.find(TradeRequests[player.UserId],targetID)
		table.remove(TradeRequests[player.UserId],index)
	end)
	return true
end

local function AcceptTradeRequest(player:Player,targetID:number)
	local target=Players:GetPlayerByUserId(targetID)
	if not target then return end
	if IsTrading(player) or IsTrading(target) then
		return
	end
	if not HasSentRequest(player.UserId,targetID) then
		return
	end
	Trading[player.UserId]=targetID
	Trading[targetID]=player.UserId
	TradeSelected[player.UserId]={}
	TradeSelected[targetID]={}
	Remotes.TradeBegan:FireClient(player,targetID)
	Remotes.TradeBegan:FireClient(target,player.UserId)
end

local function TradeDeclined(player:Player)
	local targetID = IsTrading(player)

	TradeAccepted[player.UserId] = nil
	TradeRequests[player.UserId] = nil
	Trading[player.UserId] = nil
	if not targetID then return end

	local target = Players:GetPlayerByUserId(targetID)
	if not target then return end

	TradeAccepted[targetID] = nil
	TradeRequests[targetID] = nil
	Trading[targetID] = nil

	Remotes.TradeDeclined:FireClient(target, player.UserId)	
end
local function TradeSelectPet(player:Player,uuid:string)
	local targetID=IsTrading(player)
	if not targetID then
		return
	end
	local target=Players:GetPlayerByUserId(targetID)
	if not target then
		return
	end
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	local petInstance = fishRodData.ownFishRodList[uuid]
	local petTable={}
	local fuseUp = 1
	if petInstance.fuse == 2 then
		fuseUp += 3
	elseif petInstance.fuse == 3 then
		fuseUp += 10
	end
	local levelUp = 1
	levelUp =  1 + (petInstance.level * 0.05)
	
	petTable.atk = FishRodHelper.GetFishRod(petInstance.name).baseMultiplier * fuseUp * levelUp
	
	petTable["uuid"]=uuid
	petTable["name"]=petInstance.name
	petTable["fuse"]=petInstance.fuse
	petTable["level"]=petInstance.level
	petTable["exp"]=petInstance.exp
	petTable["enchant"]=petInstance.enchant
	petTable["enchantNum"]=petInstance.enchantNum
	
	local selectedPets=TradeSelected[player.UserId]
	if not selectedPets then
		TradeSelected[player.UserId]={}
	end
	table.insert(TradeSelected[player.UserId],uuid)
	Remotes.TradeSelectPet:FireClient(target,petTable)
end

local function TradeDeselectPet(player:Player,uuid:string)
	local targetID=IsTrading(player)
	if not targetID then
		return
	end
	local target=Players:GetPlayerByUserId(targetID)
	if not target then
		return
	end
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	local petInstance=fishRodData.ownFishRodList[uuid]
	
	local selectedPets=TradeSelected[player.UserId]
	if not selectedPets then
		return
	end
	local pet=table.find(selectedPets,uuid)
	if not pet then
		return
	end
	table.remove(selectedPets,pet)
	Remotes.TradeDeselectPet:FireClient(target,uuid)
end

local function CompleteTrade(player: Player, target: Player)
	local playerPets = TradeSelected[player.UserId]
	local targetPets = TradeSelected[target.UserId]

	local targetAcceptance = TradeAccepted[target.UserId]
	if TradeAccepted[player.UserId] and targetAcceptance == true then
	else
		return
	end

	if playerPets then
		for _, uuid in ipairs(playerPets) do
			local fishRodData = FishRodDataDAO.GetFishRodData(player)
			local petInstance = fishRodData.ownFishRodList[uuid]
			local petDataTTT = FishRodDataDAO.GetFishRodData(target)
			petDataTTT.fishRodNum+=1
			petDataTTT.ownFishRodList[tostring(petDataTTT.fishRodNum)] = petInstance
			FishRodDataDAO.UpdateFishRodData(target,petDataTTT)
			
			fishRodData.ownFishRodList[tostring(uuid)]=nil
			FishRodDataDAO.UpdateFishRodData(player,fishRodData)
		end
		TradeSelected[player.UserId] = nil
	end

	if targetPets then
		for _, uuid in ipairs(targetPets) do
			local fishRodData = FishRodDataDAO.GetFishRodData(target)
			local petInstance = fishRodData.ownFishRodList[uuid]
			local petDataTTT = FishRodDataDAO.GetFishRodData(player)
			petDataTTT.fishRodNum+=1
			petDataTTT.ownFishRodList[tostring(petDataTTT.fishRodNum)] = petInstance
			FishRodDataDAO.UpdateFishRodData(player,petDataTTT)
			
			fishRodData.ownFishRodList[tostring(uuid)]=nil
			FishRodDataDAO.UpdateFishRodData(target,fishRodData)
		end
		TradeSelected[target.UserId] = nil
	end

	TradeAccepted[player.UserId] = nil
	TradeRequests[player.UserId] = nil
	Trading[player.UserId] = nil

	TradeAccepted[target.UserId] = nil
	TradeRequests[target.UserId] = nil
	Trading[target.UserId] = nil
	
	local MainGuiService = Knit.GetService("MainGuiService")
	MainGuiService:ShowMessage(player,"Trade success!")

	Remotes.TradeCompleted:FireClient(player)
	Remotes.TradeCompleted:FireClient(target)
end

local function TradeAccept(player: Player)
	local targetID = IsTrading(player)
	if not targetID then return end
	local target = Players:GetPlayerByUserId(targetID)
	if not target then return end

	Remotes.TradeAccept:FireClient(target)
	
	TradeAccepted[player.UserId] = true
	local targetAcceptance = TradeAccepted[targetID]
	if targetAcceptance and targetAcceptance == true then
		Remotes.WaitTimeFive:FireClient(player)
		Remotes.WaitTimeFive:FireClient(target)
		task.wait(5)
		CompleteTrade(player, target)
	end
	--Remotes.TradeAccept:FireClient(target)
end

local function TradeUnaccept(player: Player)
	local targetID = IsTrading(player)
	if not targetID then return end
	local target = Players:GetPlayerByUserId(targetID)
	if not target then return end

	local acceptance = TradeAccepted[player.UserId]
	if acceptance then
		TradeAccepted[player.UserId] = nil
	end
	local acceptance = TradeAccepted[target.UserId]
	if acceptance then
		TradeAccepted[target.UserId] = nil
	end
	Remotes.TradeUnaccept:FireClient(target)
end



local function YesTrade(player:Player,targetID:number)
	table.insert(NotTrade,targetID)
end

local function NoTrade(player:Player,targetID:number)
	if table.find(NotTrade,targetID) then
		table.remove(NotTrade,table.find(NotTrade,targetID))
	end
end


Players.PlayerRemoving:Connect(TradeDeclined)
Remotes.SendTradeRequest.OnServerInvoke=SendTradeRequest
Remotes.AcceptTradeRequest.OnServerEvent:Connect(AcceptTradeRequest)
Remotes.TradeDeclined.OnServerEvent:Connect(TradeDeclined)
Remotes.TradeSelectPet.OnServerEvent:Connect(TradeSelectPet)
Remotes.TradeDeselectPet.OnServerEvent:Connect(TradeDeselectPet)
Remotes.TradeAccept.OnServerEvent:Connect(TradeAccept)
Remotes.TradeUnaccept.OnServerEvent:Connect(TradeUnaccept)

Remotes.YesTrade.OnServerEvent:Connect(YesTrade)
Remotes.NoTrade.OnServerEvent:Connect(NoTrade)