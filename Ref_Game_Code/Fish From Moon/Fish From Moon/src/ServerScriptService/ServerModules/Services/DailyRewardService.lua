--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnalyticsService=game:GetService("AnalyticsService")
local Players = game:GetService("Players")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
-- 获取数据服务
local DailyRewardDataDAO = require(ServerScriptService.Source.DAO.DailyRewardDataDAO)
local MoneyHelper = require(ReplicatedStorage.Config.MoneyHelper)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)

local MainGuiService
local PlayerBoostService
local PlayerResourceService

local DailyRewardService = Knit.CreateService {
	Name = "DailyRewardService",
	Client = {
		ChangeRewards = Knit.CreateSignal(),
		ChangeRedIcon = Knit.CreateSignal(),
	},
}

--领取七日奖励
function DailyRewardService.Client:GetRewards(player,rewardId)
	local function Rewards(rewardId)
		if rewardId == 1 then
			PlayerResourceService:ChangeMoneys(player,500)
			local message = "Daily : You get 500 Money"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 2 then
			PlayerResourceService:ChangeGems(player,6000)
			local message = "Daily : You get 6000 Gem"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 3 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",2)
			local message = "Daily : You get LuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 4 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",3)
			local message = "Daily : You get MoneyPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 5 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",1)
			local message = "Daily : You get SuperLuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 6 then
			local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
			local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySmallPack"))
			PlayerResourceService:ChangeMoney(player,money)
			local message = "Daily : You get Money Small Pack"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 7 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",2)
			local message = "Daily : You get LuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 8 then
			local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
			local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySmallPack"))
			PlayerResourceService:ChangeMoney(player,money)
			local message = "Daily : You get Money Small Pack"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 9 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",3)
			local message = "Daily : You get MoneyPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 10 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",1)
			local message = "Daily : You get LuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 11 then
			PlayerResourceService:ChangeGems(player,30000)
			local message = "Daily : You get 30000 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 12 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",2)
			local message = "Daily : You get SuperLuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 13 then
			local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
			local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyMediumPack"))
			PlayerResourceService:ChangeMoney(player,money)
			local message = "Daily : You get Money Medium Pack"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 14 then
			PlayerResourceService:ChangeGems(player,80000)
			local message = "Daily : You get 80000 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 15 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",8)
			local message = "Daily : You get SuperLuckPotion"
			MainGuiService:ShowMessage(player,message)
		end
	end
	local dailyRewardData = DailyRewardService:GetDailyRewardData(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.isGetDaily=true
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)

	local rewardsMax = dailyRewardData.rewardsMax
	local claimList = dailyRewardData.claimList
	if rewardId <= rewardsMax then
		if table.find(claimList,rewardId) then
		else
			--给与玩家奖励
			Rewards(rewardId)
			table.insert(claimList,rewardId)
			DailyRewardService:UpdateDailyRewardData(player,dailyRewardData)
			-- 改变奖励界面的UI
			DailyRewardService:ChangeRewards(player)	
		end
	end
end

--改变七日奖励界面
function DailyRewardService:ChangeRewards(player)
	self.Client.ChangeRewards:Fire(player)
end 
function DailyRewardService:ChangeRedIcon(player)
	self.Client.ChangeRedIcon:Fire(player)
end 

function DailyRewardService:GetDailyRewardData(player)
	local dailyRewardData = DailyRewardDataDAO.GetDailyRewardData(player)
	return dailyRewardData
end

function DailyRewardService.Client:GetDailyRewardData(player)
	local dailyRewardData = DailyRewardDataDAO.GetDailyRewardData(player)
	return dailyRewardData
end

function DailyRewardService:UpdateDailyRewardData(player,dailyRewardData)
	DailyRewardDataDAO.UpdateDailyRewardData(player, dailyRewardData)
end

local ChangeRewardsTimesPerPlayer = {}
local function changeRewardsTime(player)
	ChangeRewardsTimesPerPlayer[player] = true
	while ChangeRewardsTimesPerPlayer[player] do
		local dailyRewardData = DailyRewardService:GetDailyRewardData(player)
		--展示主界面数据
		local rewardsTime = dailyRewardData.rewardsTime - os.time()
		if rewardsTime > 0 then
		else
			DailyRewardService:ChangeRedIcon(player)	
			if dailyRewardData.rewardsMax < 7 then
				--重新计时
				local _rewardsTime = os.time() + 24 * 3600
				dailyRewardData.rewardsTime = _rewardsTime
				--增加每日奖励次数
				dailyRewardData.rewardsMax += 1

				local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
				playerResourceData.isGetDaily=false
				PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)

				DailyRewardService:UpdateDailyRewardData(player,dailyRewardData)
			else
				dailyRewardData.rewardsMax = 1
				dailyRewardData.claimList = {}
				local _rewardsTime = os.time() + 24*3600
				dailyRewardData.rewardsTime = _rewardsTime
				DailyRewardService:UpdateDailyRewardData(player,dailyRewardData)
			end
		end
		task.wait(60)
	end
end

local function PlayerAdded(player)
	changeRewardsTime(player)
end
local function PlayerRemoved(player)
	--不在循环记录玩家抽奖时间
	ChangeRewardsTimesPerPlayer[player] = nil
end

function DailyRewardService:KnitInit()
	MainGuiService = Knit.GetService("MainGuiService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function DailyRewardService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		PlayerAdded(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		PlayerRemoved(player)
	end)
end


return DailyRewardService
