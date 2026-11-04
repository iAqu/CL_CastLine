--加载服务
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--加载模块
local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)
local PlayerResourceDAO = require(ServerScriptService.Source.DAO.PlayerResourceDAO)

local GameDurationsPerPlayer = {}

--玩家加入游戏
local function PlayerJoinGame(player)
	local playerResourceData = PlayerResourceDAO.GetPlayerResourceData(player)
	--排行榜数据
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local points = Instance.new("StringValue")
	points.Name = "Moneys"
	points.Value = NumberFormat.AbbreviateNumber(playerResourceData.moneys,2)
	points.Parent = leaderstats
	
	local points = Instance.new("StringValue")
	points.Name = "Gems"
	points.Value = NumberFormat.AbbreviateNumber(playerResourceData.gems,2)
	points.Parent = leaderstats
end

Players.PlayerAdded:Connect(PlayerJoinGame)