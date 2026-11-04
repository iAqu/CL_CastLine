local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local PlayerThrowBuffDAO = require(ServerScriptService.Source.DAO.PlayerThrowBuffDAO)
local UpgradesDataDAO = require(ServerScriptService.Source.DAO.UpgradesDataDAO)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerThrowBuffService = Knit.CreateService {
	Name = "PlayerThrowBuffService", 
	Client = {
		CreatTask1ThrowBuff = Knit.CreateSignal(),
		CreatTask2ThrowBuff = Knit.CreateSignal(),
		CreatTask3ThrowBuff = Knit.CreateSignal(),
	}
}
--创建
function PlayerThrowBuffService:CreatTask1ThrowBuff(player)
	self.Client.CreatTask1ThrowBuff:Fire(player)
end

--创建
function PlayerThrowBuffService:CreatTask2ThrowBuff(player)
	--保存数据
	local playerThrowBuffData = PlayerThrowBuffService:GetPlayerThrowBuffData(player)
	playerThrowBuffData["Task1"] = true
	PlayerThrowBuffService:UpdatePlayerThrowBuffData(player, playerThrowBuffData)
	self.Client.CreatTask2ThrowBuff:Fire(player)
end

--创建
function PlayerThrowBuffService:CreatTask3ThrowBuff(player)
	--保存数据
	local playerThrowBuffData = PlayerThrowBuffService:GetPlayerThrowBuffData(player)
	playerThrowBuffData["Task2"] = true
	PlayerThrowBuffService:UpdatePlayerThrowBuffData(player, playerThrowBuffData)
	self.Client.CreatTask3ThrowBuff:Fire(player)
end

function PlayerThrowBuffService:DestoryTask1ThrowBuff(player)
	PlayerThrowBuffService:CreatTask2ThrowBuff(player)
end

function PlayerThrowBuffService:DestoryTask2ThrowBuff(player)
	PlayerThrowBuffService:CreatTask3ThrowBuff(player)
end

-- 获取指引数据
function PlayerThrowBuffService.Client:GetPlayerThrowBuffAndUpgeadesData(player)
	local playerThrowBuffData = PlayerThrowBuffDAO.GetPlayerThrowBuffData(player)
	local upgradesData = UpgradesDataDAO.GetUpgradesData(player)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	return playerThrowBuffData,upgradesData,fishRodData
end

-- 获取指引数据
function PlayerThrowBuffService:GetPlayerThrowBuffData(player)
	local playerThrowBuffData = PlayerThrowBuffDAO.GetPlayerThrowBuffData(player)
	return playerThrowBuffData
end

-- 获取指引数据
function PlayerThrowBuffService.Client:GetPlayerThrowBuffData(player)
	local playerThrowBuffData = PlayerThrowBuffDAO.GetPlayerThrowBuffData(player)
	return playerThrowBuffData
end

-- 更新指引数据
function PlayerThrowBuffService:UpdatePlayerThrowBuffData(player, playerThrowBuffData)
	PlayerThrowBuffDAO.UpdatePlayerThrowBuffData(player, playerThrowBuffData)
end

function PlayerThrowBuffService:KnitInit()
end

function PlayerThrowBuffService:KnitStart()
	game:GetService("Players").PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function ()
			local playerThrowBuffData = PlayerThrowBuffService:GetPlayerThrowBuffData(player)
			if playerThrowBuffData["Task1"] then
			else
				PlayerThrowBuffService:CreatTask1ThrowBuff(player)
			end
		end)
	end)
end

return PlayerThrowBuffService
