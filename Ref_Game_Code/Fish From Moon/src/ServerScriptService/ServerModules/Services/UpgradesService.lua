local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local UpgradesHelper = require(ReplicatedStorage.Config.UpgradesHelper)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)
local UpgradesDataDAO = require(ServerScriptService.Source.DAO.UpgradesDataDAO)

local PlayerService
local PlayerResourceService
local PlayerGuidanceService

local UpgradesService =Knit.CreateService {
	Name = "UpgradesService",Client = {
		RushUI = Knit.CreateSignal(),
		InitWalkSpeed = Knit.CreateSignal(),
	}
}

function UpgradesService:RushUI(player)
	self.Client.RushUI:Fire(player)
end

function UpgradesService.Client:UpgradesAttributes(player,attribute)
	local updateData = UpgradesDataDAO.GetUpgradesData(player)
	if attribute == "speedLevel" then
		local needNum = UpgradesHelper.GetUpgradesNeedNum("speedLevel",updateData.speedLevel)
		local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
		if playerResourceData.moneys >= needNum then
			PlayerResourceService:ChangeMoneys(player,-(needNum))
			updateData.speedLevel += 1
			if updateData.speedLevel >= 21 then
				updateData.speedLevel = 21
			end
			local playerData = PlayerService:GetPlayerData(player)
			playerData.walkSpeed = 26 * (1+UpgradesHelper.GetUpgradesNum("speedLevel",updateData.speedLevel))
			PlayerService:UpdatePlayerData(player,playerData)
			UpgradesService:InitWalkSpeed(player)
		else
			print("金币不足")
		end
		UpgradesDataDAO.UpdateUpgradesData(player,updateData)
		UpgradesService:RushUI(player)
	elseif attribute == "strengthLevel" then
		local needNum = UpgradesHelper.GetUpgradesNeedNum("strengthLevel",updateData.strengthLevel)
		local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
		if playerResourceData.moneys >= needNum then
			PlayerResourceService:ChangeMoneys(player,-(needNum))
			updateData.strengthLevel += 1
			if updateData.strengthLevel >= 27 then
				updateData.strengthLevel = 27
			end
			local playerGuidanceData = PlayerGuidanceService:GetPlayerGuidanceData(player)
			if playerGuidanceData["Task4"] and not playerGuidanceData["Task3"] and not playerGuidanceData.isFirst then
				PlayerGuidanceService:CreatTask3Guidance(player)
			end
		else
			print("金币不足")
		end
		UpgradesDataDAO.UpdateUpgradesData(player,updateData)
		UpgradesService:RushUI(player)
	elseif attribute == "luckLevel" then
		local needNum = UpgradesHelper.GetUpgradesNeedNum("luckLevel",updateData.luckLevel)
		local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
		if playerResourceData.moneys >= needNum then
			PlayerResourceService:ChangeMoneys(player,-(needNum))
			updateData.luckLevel += 1
			if updateData.luckLevel >= 27 then
				updateData.luckLevel = 27
			end
		else
			print("金币不足")
		end
		UpgradesDataDAO.UpdateUpgradesData(player,updateData)
		UpgradesService:RushUI(player)
	end
end

--获取玩家资源数据
function UpgradesService.Client:GetUpgradesAndFishRodData(player)
	local updateData = UpgradesDataDAO.GetUpgradesData(player)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	return updateData,fishRodData
end

--获取玩家资源数据
function UpgradesService:GetUpgradesData(player)
	local updateData = UpgradesDataDAO.GetUpgradesData(player)
	return updateData
end

--获取玩家资源数据
function UpgradesService.Client:GetUpgradesData(player)
	local updateData = UpgradesDataDAO.GetUpgradesData(player)
	return updateData
end

--更新玩家资源数据
function UpgradesService:UpdatePlayerResourceData(player,updateData)
	UpgradesDataDAO.UpdateUpgradesData(player,updateData)
end

function UpgradesService:InitWalkSpeed(player)
	local playerData = PlayerService:GetPlayerData(player)
	self.Client.InitWalkSpeed:Fire(player,playerData.walkSpeed)
end

function UpgradesService.Client:CSWalkSpeed(player)
	UpgradesService:InitWalkSpeed(player)
end

function UpgradesService:KnitInit()
	PlayerService = Knit.GetService("PlayerService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerGuidanceService = Knit.GetService("PlayerGuidanceService")
end

function UpgradesService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		UpgradesService:InitWalkSpeed(player)
	end)
end

return UpgradesService