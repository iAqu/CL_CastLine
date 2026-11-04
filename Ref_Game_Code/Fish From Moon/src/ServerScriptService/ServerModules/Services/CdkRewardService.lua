local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local CdkRewardDAO = require(ServerScriptService.Source.DAO.CdkRewardDAO)
local Knit = require(ReplicatedStorage.Packages.Knit)

local CdkRewardService = Knit.CreateService {Name = "CdkRewardService", Client = {}}

-- 获取CDK数据
function CdkRewardService:GetCdkRewardData(player)
	local cdkRewardData = CdkRewardDAO.GetCdkRewardData(player)
	return cdkRewardData
end

-- 获取CDK数据
function CdkRewardService.Client:GetCdkRewardData(player)
	local cdkRewardData = CdkRewardDAO.GetCdkRewardData(player)
	return cdkRewardData
end

-- 更新CDK数据
function CdkRewardService:UpdateCdkRewardData(player, cdkRewardData)
	CdkRewardDAO.UpdateCdkRewardData(player, cdkRewardData)
end

function CdkRewardService:KnitStart()
end

function CdkRewardService:KnitInit()
end

return CdkRewardService