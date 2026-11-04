local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local StoreDailyHelper = require(ReplicatedStorage.Config.StoreDailyHelper)
local StoreDailyDataDAO = require(ServerScriptService.Source.DAO.StoreDailyDataDAO)

local StoreGuiService = Knit.CreateService {
	Name = "StoreGuiService",
	Client = {
		ChangeBoostData = Knit.CreateSignal(),
		ChangePassData = Knit.CreateSignal(),
	},
}

function StoreGuiService.Client:InitStoreDaily(player)
	local storeData = StoreDailyDataDAO.GetStoreDailyData(player)
	--日期不是一天，重新Init
	storeData.rewardlist = {}
	for i=1,7,1 do
		table.insert(storeData.rewardlist,math.random(1,#StoreDailyHelper.GetIndexDaily(i)))
	end
	storeData.alreadyGet = 0
	local currentTime = os.date("*t")
	storeData.dayIndex.year = currentTime.year
	storeData.dayIndex.month = currentTime.month
	storeData.dayIndex.day = currentTime.day
	StoreDailyDataDAO.UpdateStoreDailyData(player,storeData)
end

--改变Boost数据
function StoreGuiService:ChangeBoostData(player)
	self.Client.ChangeBoostData:Fire(player)
end
--改变Pass数据
function StoreGuiService:ChangePassData(player)
	self.Client.ChangePassData:Fire(player)
end

--获取玩家资源数据
function StoreGuiService:GetStoreDailyData(player)
	local storeDailyData = StoreDailyDataDAO.GetStoreDailyData(player)
	return storeDailyData
end

--获取玩家资源数据
function StoreGuiService.Client:GetStoreDailyData(player)
	local storeDailyData = StoreDailyDataDAO.GetStoreDailyData(player)
	return storeDailyData
end

--更新玩家资源数据
function StoreGuiService:UpdateStoreDailyData(player,storeDailyData)
	StoreDailyDataDAO.UpdateStoreDailyData(player,storeDailyData)
end

function StoreGuiService:KnitInit()
end

function StoreGuiService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			--StoreGuiService:ChangePassData(player)
		end)
	end)
end

return StoreGuiService