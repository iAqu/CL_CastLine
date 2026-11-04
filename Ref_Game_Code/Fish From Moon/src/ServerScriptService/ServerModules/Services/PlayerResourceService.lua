local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)
local PlayerResourceDAO = require(ServerScriptService.Source.DAO.PlayerResourceDAO)

local MainGuiService

local PlayerResourceService =Knit.CreateService {Name = "PlayerResourceService",Client = {}}

--改变玩家金币
function PlayerResourceService:ChangeMoneys(player,moneys)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.moneys = playerResourceData.moneys + math.ceil(moneys)
	-----超出数值长度
	if playerResourceData.moneys>=1*10^60 then
		playerResourceData.moneys=1*10^60
	end
	if moneys >= 0 then
		playerResourceData.sumMoneys += math.ceil(moneys)
	end
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	--改变UI
	MainGuiService:ChangeMoneys(player,playerResourceData.moneys)
end
--改变玩家宝石
function PlayerResourceService:ChangeGems(player,gems)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.gems = playerResourceData.gems + math.ceil(gems)
	-----超出数值长度
	if playerResourceData.gems>=1*10^60 then
		playerResourceData.gems=1*10^60
	end
	if gems >= 0 then
		playerResourceData.sumGems += math.ceil(gems)
	end
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	--改变UI
	MainGuiService:ChangeGems(player,playerResourceData.gems)
end

--获取玩家资源数据
function PlayerResourceService:GetPlayerResourceData(player)
	local playerResourceData = PlayerResourceDAO.GetPlayerResourceData(player)
	return playerResourceData
end

--获取玩家资源数据
function PlayerResourceService.Client:GetPlayerResourceData(player)
	local playerResourceData = PlayerResourceDAO.GetPlayerResourceData(player)
	return playerResourceData
end

--获取其他玩家资源数据
function PlayerResourceService.Client:GetOtherPlayerResourceData(player,otherPlayer)
	local playerResourceData = PlayerResourceDAO.GetPlayerResourceData(otherPlayer)
	return playerResourceData
end

--更新玩家资源数据
function PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	PlayerResourceDAO.UpdatePlayerResource(player,playerResourceData)
end

function PlayerResourceService:KnitInit()
	MainGuiService = Knit.GetService("MainGuiService")
end

function PlayerResourceService:KnitStart()
end

return PlayerResourceService
