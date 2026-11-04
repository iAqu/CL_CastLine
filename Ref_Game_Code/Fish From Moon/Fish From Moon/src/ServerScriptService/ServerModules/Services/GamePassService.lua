--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local GamePassDataDAO = require(ServerScriptService.Source.DAO.GamePassDataDAO)

local GamePassService =Knit.CreateService {Name = "GamePassService",
	Client = {
		ChangeGamePassData = Knit.CreateSignal(),
		ChangeGiftPassData = Knit.CreateSignal(),
	}
}

--客户端 判断玩家是否拥有权限
function GamePassService.Client:IsPlayerHaveGamePass(player, gamePass)
	local result = self.Server:IsPlayerHaveGamePass(player, gamePass)
	return result
end

----客户端 判断其他玩家是否拥有权限
function GamePassService.Client:IsOtherPlayerHaveGamePass(player,otherPlayer, gamePass)
	local result = self.Server:IsPlayerHaveGamePass(otherPlayer, gamePass)
	return result
end

--服务器端 判断玩家是否拥有权限
function GamePassService:IsPlayerHaveGamePass(player, gamePass)
	local gamePassData = GamePassDataDAO.GetGamePassData(player)
	if gamePassData[gamePass] then
		return true
	else
		return false
	end
end

--客户端 获取玩家所有通行证权限
function GamePassService.Client:GetPlayerAllGamePass(player)
	local gamePassData = self.Server:GetPlayerAllGamePass(player)
	return gamePassData
end

--客户端 获取其他玩家所有通行证权限
function GamePassService.Client:GetOtherPlayerAllGamePass(player,otherPlayer)
	local gamePassData = GamePassService:GetPlayerAllGamePass(otherPlayer)
	return gamePassData
end

--服务器端 获取玩家所有通行证权限
function GamePassService:GetPlayerAllGamePass(player)
	return GamePassDataDAO.GetGamePassData(player)
end

--增加玩家通行证权限
function GamePassService:AddPlayerGamePass(player, gamePass)
	local gamePassData = GamePassDataDAO.GetGamePassData(player)
	gamePassData[gamePass] = true
	GamePassDataDAO.UpdateGamePassData(player, gamePassData)
	--更新玩家GamePass数据
	self.Client.ChangeGamePassData:Fire(player, gamePassData)
end

--增加玩家通行证权限
function GamePassService:AddOtherPlayerGamePass(player,otherPlayer, gamePass)
	local gamePassData = GamePassDataDAO.GetGamePassData(otherPlayer)
	gamePassData[gamePass] = true
	GamePassDataDAO.UpdateGamePassData(otherPlayer, gamePassData)
	--更新玩家GamePass数据
	self.Client.ChangeGiftPassData:Fire(player,otherPlayer)
	self.Client.ChangeGamePassData:Fire(otherPlayer,gamePassData)
end

function GamePassService:KnitInit()
end

function GamePassService:KnitStart()
end

return GamePassService