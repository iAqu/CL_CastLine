local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local PlayerGuidanceDAO = require(ServerScriptService.Source.DAO.PlayerGuidanceDAO)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerGuidanceService = Knit.CreateService {
	Name = "PlayerGuidanceService", 
	Client = {
		CreatTask1Guidance = Knit.CreateSignal(),
		CreatTask2Guidance = Knit.CreateSignal(),
		CreatTask3Guidance = Knit.CreateSignal(),
		CreatTask4Guidance = Knit.CreateSignal(),
		CreatWelcome = Knit.CreateSignal(),
	}
}

--删除
function PlayerGuidanceService.Client:SkipGui(player)
	local playerGuidance = PlayerGuidanceService:GetPlayerGuidanceData(player)
	playerGuidance.isFirst = true
	PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidance)
end

--创建
function PlayerGuidanceService:CreatTask1Guidance(player)
	self.Client.CreatTask1Guidance:Fire(player)
end

--删除
function PlayerGuidanceService.Client:DestoryTask1Guidance(player)
	PlayerGuidanceService:CreatTask2Guidance(player)
end
function PlayerGuidanceService:DestoryTask1Guidance(player)
	PlayerGuidanceService:CreatTask2Guidance(player)
end

--创建
function PlayerGuidanceService:CreatTask2Guidance(player)
	--保存数据
	local playerGuidance = PlayerGuidanceService:GetPlayerGuidanceData(player)
	if playerGuidance["Task2"] or playerGuidance.isFirst then
	else
		playerGuidance["Task2"] = true
		PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidance)
		self.Client.CreatTask2Guidance:Fire(player)
	end
end

--删除
function PlayerGuidanceService.Client:DestoryTask2Guidance(player)
	PlayerGuidanceService:CreatTask3Guidance(player)
end
function PlayerGuidanceService:DestoryTask2Guidance(player)
	PlayerGuidanceService:CreatTask3Guidance(player)
end

--创建
function PlayerGuidanceService:CreatTask3Guidance(player)
	--保存数据
	local playerGuidance = PlayerGuidanceService:GetPlayerGuidanceData(player)
	if playerGuidance["Task3"] or playerGuidance.isFirst then
	else
		playerGuidance["Task3"] = true
		PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidance)
		self.Client.CreatTask3Guidance:Fire(player)
	end
end
--删除
function PlayerGuidanceService.Client:DestoryTask3Guidance(player)
	PlayerGuidanceService:CreatTask4Guidance(player)
end
function PlayerGuidanceService:DestoryTask3Guidance(player)
	PlayerGuidanceService:CreatTask4Guidance(player)
end

--创建
function PlayerGuidanceService:CreatTask4Guidance(player)
	--保存数据
	local playerGuidance = PlayerGuidanceService:GetPlayerGuidanceData(player)
	if playerGuidance["Task4"] or playerGuidance.isFirst then
	else
		playerGuidance["Task4"] = true
		PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidance)
		self.Client.CreatTask4Guidance:Fire(player)
	end
end
--删除
function PlayerGuidanceService:DestoryTask4Guidance(player)
	PlayerGuidanceService:CreatWelcome(player)
end
--创建
function PlayerGuidanceService:CreatWelcome(player)
	local playerGuidance = PlayerGuidanceService:GetPlayerGuidanceData(player)
	if playerGuidance["Welcome"] or playerGuidance.isFirst then
	else
		playerGuidance["Welcome"] = true
		PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidance)
		self.Client.CreatWelcome:Fire(player)
	end
end

-- 获取指引数据
function PlayerGuidanceService:GetPlayerGuidanceData(player)
	local playerGuidanceData = PlayerGuidanceDAO.GetPlayerGuidanceData(player)
	return playerGuidanceData
end

-- 获取指引数据
function PlayerGuidanceService.Client:GetPlayerGuidanceData(player)
	local playerGuidanceData = PlayerGuidanceDAO.GetPlayerGuidanceData(player)
	return playerGuidanceData
end

-- 更新指引数据
function PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidanceData)
	PlayerGuidanceDAO.UpdatePlayerGuidanceData(player, playerGuidanceData)
end

function PlayerGuidanceService:KnitInit()
end

function PlayerGuidanceService:KnitStart()
	game:GetService("Players").PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function ()
			local playerGuidanceData = PlayerGuidanceService:GetPlayerGuidanceData(player)
			if playerGuidanceData["Task1"] then
			else
				PlayerGuidanceService:CreatTask1Guidance(player)
				playerGuidanceData["Task1"] = true
				PlayerGuidanceService:UpdatePlayerGuidanceData(player, playerGuidanceData)
			end
		end)
	end)
end

return PlayerGuidanceService
