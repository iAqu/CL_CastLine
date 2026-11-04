local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local MainGuiService
local PlayerBoostService
local PlayerResourceService
-- 获取数据服务
local LotteryUtils = require(ReplicatedStorage.Source.Utils.LotteryUtils)
local FreeGiftDAO = require(ServerScriptService.Source.DAO.FreeGiftDAO)
local TimeFormat = require(ReplicatedStorage.Source.Utils.TimeFormat)
local MoneyHelper = require(ReplicatedStorage.Config.MoneyHelper)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)

local FreeGiftService =Knit.CreateService {
	Name = "FreeGiftService",
	Client = {
		ChangeFreeGiftTime = Knit.CreateSignal(),
		ChangeFreeGiftRewards = Knit.CreateSignal(),

		ShowFreeRedIcon = Knit.CreateSignal(),
		PlayGiftAnimation = Knit.CreateSignal(),
		StopGiftAnimation = Knit.CreateSignal(),
	}
}

--显示免费奖励红点
function FreeGiftService:ShowFreeRedIcon(player,num,timeNum)
	self.Client.ShowFreeRedIcon:Fire(player,num,timeNum)	
end
--改变在线奖励界面
function FreeGiftService:ChangeFreeGiftRewards(player)
	self.Client.ChangeFreeGiftRewards:Fire(player)
end

--改变免费奖励倒计时
function FreeGiftService:ChangeFreeGiftTime(player,timer)
	self.Client.ChangeFreeGiftTime:Fire(player,timer)	
end
--播放Gift动画
function FreeGiftService:PlayGiftAnimation(player)
	self.Client.PlayGiftAnimation:Fire(player)
end
--播放Gift动画
function FreeGiftService:StopGiftAnimation(player)
	self.Client.StopGiftAnimation:Fire(player)
end

--领取在线奖励
function FreeGiftService.Client:GetFreeGiftRewards(player,rewardId)
	local function FreeGiftRewards(rewardId)
		if rewardId == 1 then
			PlayerResourceService:ChangeMoneys(player,150)
			local message = "Gift : You get 150 Moneys"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 2 then
			PlayerResourceService:ChangeMoneys(player,500)
			local message = "Gift : You get 500 Moneys"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 3 then
			PlayerResourceService:ChangeGems(player,1500)
			local message = "Gift : You get 2000 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 4 then
			PlayerResourceService:ChangeGems(player,2000)
			local message = "Gift : You get 3000 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 5 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",1)
			local message = "Gift : You get LuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 6 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",1)
			local message = "Gift : You get MoneyPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 7 then
			PlayerResourceService:ChangeGems(player,3500)
			local message = "Gift : You get 4500 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 8 then
			PlayerResourceService:ChangeGems(player,5000)
			local message = "Gift : You get 5500 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 9 then
			PlayerBoostService:AddPlayerBoostUseCount(player,"SuperLuckPotion",1)
			local message = "Gift : You get SuperLuckPotion"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 10 then
			local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
			local money=math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySmallPack"))
			PlayerResourceService:ChangeMoneys(player,money)
			local message = "Gift : You get Money Small Pack"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 11 then
			PlayerResourceService:ChangeGems(player,7000)
			local message = "Gift : You get 8000 Gems"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId == 12 then 
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",3)
			local message = "Gift : You get MoneyPotion"
			MainGuiService:ShowMessage(player,message)
		end
	end

	local function checkCanClaim(rewardsTime,rewardId)
		local result = false
		if rewardId == 1 then
			if rewardsTime >= 1*60 then
				result = true
			end
		elseif rewardId == 2 then
			if rewardsTime >= 3*60 then
				result = true
			end
		elseif rewardId == 3 then
			if rewardsTime >= 5*60 then
				result = true
			end
		elseif rewardId == 4 then
			if rewardsTime >= 10*60 then
				result = true
			end
		elseif rewardId == 5 then
			if rewardsTime >= 15*60 then
				result = true
			end
		elseif rewardId == 6 then
			if rewardsTime >= 30*60 then
				result = true
			end
		elseif rewardId == 7 then
			if rewardsTime >= 45*60 then
				result = true
			end
		elseif rewardId == 8 then
			if rewardsTime >= 60*60 then
				result = true
			end
		elseif rewardId == 9 then
			if rewardsTime >= 90*60 then
				result = true
			end
		elseif rewardId == 10 then
			if rewardsTime >= 120*60 then
				result = true
			end
		elseif rewardId == 11 then
			if rewardsTime >= 150*60 then
				result = true
			end
		elseif rewardId == 12 then
			if rewardsTime >= 180*60 then
				result = true
			end
		end
		return result
	end

	local freeGiftData = FreeGiftService:GetFreeGiftData(player)
	local claimList = freeGiftData.claimList

	if table.find(claimList,rewardId) then
		--TODO 提示已经领取信息
		MainGuiService:ShowMessage(player,"Claimed")
		return false
	else
		local rewardsTime = freeGiftData.rewardsTime
		local result = checkCanClaim(rewardsTime,rewardId)
		if result then
			--给与玩家奖励
			FreeGiftRewards(rewardId)
			table.insert(claimList,rewardId)
			FreeGiftService:UpdateFreeGiftData(player,freeGiftData)
			-- 改变奖励界面的UI
			FreeGiftService:ChangeFreeGiftRewards(player)
			return true
		else
			return false
		end
	end
end

function FreeGiftService:GetFreeGiftData(player)
	local freeGiftData = FreeGiftDAO.GetFreeGiftData(player)
	return freeGiftData
end

function FreeGiftService.Client:GetFreeGiftData(player)
	local freeGiftData = FreeGiftDAO.GetFreeGiftData(player)
	return freeGiftData
end

function FreeGiftService.Client:GetFreeGiftDataAndRes(player)
	local freeGiftData = FreeGiftDAO.GetFreeGiftData(player)
	local maxWorld=PlayerResourceService:GetPlayerResourceData(player).maxWorld
	return freeGiftData,maxWorld
end

function FreeGiftService:UpdateFreeGiftData(player,freeGiftData)
	FreeGiftDAO.UpdateFreeGiftData(player, freeGiftData)
end

--加载工具类
local FreeGiftTimesPerPlayer = {}
local IsExitPerPlayer = {}

local function ChangePlayerGift(player)
	local freeGiftData = FreeGiftService:GetFreeGiftData(player)
	local freeGiftData = {
		rewardsTime = 0,
		claimList = {}
	}
	FreeGiftService:UpdateFreeGiftData(player,freeGiftData)
	FreeGiftTimesPerPlayer[player] = true
	IsExitPerPlayer[player.UserId] = true
	while FreeGiftTimesPerPlayer[player] do
		local freeGiftData1 = FreeGiftService:GetFreeGiftData(player)
		freeGiftData1.rewardsTime += 1

		if not IsExitPerPlayer[player.UserId] then
			return
		end
		local freeGiftData = FreeGiftService:GetFreeGiftData(player)
		local timer = freeGiftData.rewardsTime
		local timeNum=""
		local num=0

		local curentTime = 60 - timer
		timeNum = TimeFormat.FreeGiftTime(curentTime)

		if freeGiftData.rewardsTime>=60 and freeGiftData.rewardsTime<180 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=1-#(freeGiftData.claimList)

			local curentTime = 180 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=180 and freeGiftData.rewardsTime<300 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=2-#(freeGiftData.claimList)

			local curentTime = 300 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=300 and freeGiftData.rewardsTime<600 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=3-#(freeGiftData.claimList)

			local curentTime = 600 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=600 and freeGiftData.rewardsTime<15*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=4-#(freeGiftData.claimList)

			local curentTime = 15*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=15*60 and freeGiftData.rewardsTime<30*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=5-#(freeGiftData.claimList)

			local curentTime = 30*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=30*60 and freeGiftData.rewardsTime<45*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=6-#(freeGiftData.claimList)

			local curentTime = 45*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=45*60 and freeGiftData.rewardsTime<60*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=7-#(freeGiftData.claimList)

			local curentTime = 60*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=60*60 and freeGiftData.rewardsTime<90*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=8-#(freeGiftData.claimList)

			local curentTime = 90*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=90*60 and freeGiftData.rewardsTime<120*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=9-#(freeGiftData.claimList)

			local curentTime = 120*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=120*60 and freeGiftData.rewardsTime<150*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=10-#(freeGiftData.claimList)

			local curentTime = 150*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=150*60 and freeGiftData.rewardsTime<180*60 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=11-#(freeGiftData.claimList)

			local curentTime = 180*60 - timer
			timeNum = TimeFormat.FreeGiftTime(curentTime)
		end
		if freeGiftData.rewardsTime>=180*60 and #(freeGiftData.claimList) < 12 then
			--FreeGiftService:PlayGiftAnimation(player)
			num=12-#(freeGiftData.claimList)
			timeNum = "End"
		end
		--if #(freeGiftData.claimList) >= 12 then
		--	FreeGiftService:StopGiftAnimation(player)
		--end
		FreeGiftService:ShowFreeRedIcon(player,num,timeNum)
		--渲染页面数据
		FreeGiftService:ChangeFreeGiftTime(player,freeGiftData1)
		FreeGiftService:UpdateFreeGiftData(player,freeGiftData1)
		task.wait(1)
	end
end

local function PlayerAdded(player)
	ChangePlayerGift(player)
end
local function PlayerRemoved(player)
	--不在循环记录玩家抽奖时间
	FreeGiftTimesPerPlayer[player] = nil
	IsExitPerPlayer[player.UserId] = false
end

function FreeGiftService:KnitInit()
	MainGuiService = Knit.GetService("MainGuiService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function FreeGiftService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		PlayerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlayerRemoved(player)
	end)
end

return FreeGiftService