local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

--获取工具类
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)
local FreeGiftHelper= require(ReplicatedStorage.Config.FreeGiftHelper)
local TimeFormat =  require(ReplicatedStorage.Source.Utils.TimeFormat)
local Monetization= require(ReplicatedStorage.Config.Monetization)
local Knit = require(ReplicatedStorage.Packages.Knit)

local FreeGiftService

---GUI
local FreeGiftsMenu=player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FreeGiftsMenu
local RewardFrame = FreeGiftsMenu:WaitForChild("Menu"):WaitForChild("Container").Icons

local BtnOpen=player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Online
local BtnClose=FreeGiftsMenu.Menu.Exit.TextButton

local BtnSkip=FreeGiftsMenu.Menu.SkipAll

local frameName="FreeGiftsMenu"

local FreeGiftController = Knit.CreateController { Name = "FreeGiftController" }

--在线时长奖励
local function changeFreeGiftTime(freeGiftData)
	local timer = freeGiftData.rewardsTime
	local claimList = freeGiftData.claimList
	BtnSkip.Visible=true
	for	rewardId = 1, 12, 1 do
		if rewardId == 1 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 60 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 60 - timer
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
			end
		elseif rewardId == 2 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 180 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 180 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end

		elseif rewardId == 3 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 300 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 300 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end

		elseif rewardId == 4 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 600 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 600 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end

		elseif rewardId == 5 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 15*60 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 15*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		elseif rewardId == 6 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 30*60 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 30*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end

		elseif rewardId == 7 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 45*60 then
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 45*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end

		elseif rewardId == 8 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 60*60 then
				BtnSkip.Visible=false
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 60*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		elseif rewardId == 9 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 90*60 then
				BtnSkip.Visible=false
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 90*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		elseif rewardId == 10 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 120*60 then
				BtnSkip.Visible=false
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 120*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		elseif rewardId == 11 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 150*60 then
				BtnSkip.Visible=false
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 150*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		elseif rewardId == 12 then
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			if timer >= 180*60 then
				BtnSkip.Visible=false
				if table.find(claimList,rewardId) then
					TxtTime.TextColor3 = Color3.new(1, 1, 1)
					TxtTime.Text = "Claimed!"
				else
					TxtTime.TextColor3 = Color3.new(0.113725, 1, 0.0666667)
					TxtTime.Text = "Claim!"
				end
			else
				local curentTime = 180*60 - timer
				TxtTime.TextColor3 = Color3.new(1, 1, 1)
				TxtTime.Text = TimeFormat.HHMMSS(curentTime)
			end
		end
	end
end

--展示免费红点
local function showFreeRedIcon(num,timeNum)
	if num==0 then
		player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Online.Red.Visible=false
	else
		player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Online.Red.Visible=true
	end
end

local function changeFreeGiftRewards()
	local function ShowRewards(freeGiftData,maxworld)
		local freeGiftList=FreeGiftHelper.GetFreeGift()
		for k,v in pairs(freeGiftList) do
			RewardFrame:WaitForChild(k).Frame.ImageLabel.Image=FreeGiftHelper.GetFreeGiftImg(k)
			RewardFrame:WaitForChild(k).Frame.TextLabel.Text=FreeGiftHelper.GetFreeGiftTxt(k)
			RewardFrame:WaitForChild(k).Frame.NumText.Text=FreeGiftHelper.GetFreeGiftNum(k)
		end

		local rewardsTime = freeGiftData.rewardsTime
		local claimList = freeGiftData.claimList

		for k,rewardId in claimList do
			local TxtTime = RewardFrame[rewardId].Frame.Cliam.ClaimText
			TxtTime.Text = "Claimed!"
		end
	end
	FreeGiftService:GetFreeGiftDataAndRes():andThen(ShowRewards)
end

--打开在线奖励界面界面
function FreeGiftController:OpenFreeGiftRewardsDedault()
	changeFreeGiftRewards()
end

local function getFreeGiftRewards(k,giftId)
	FreeGiftService:GetFreeGiftRewards(giftId):andThen(function(result,message)
		if result then
			changeFreeGiftRewards()
		end
	end)
end

--播放Gift动画
local function playGiftAnimation()
	local PowerImag = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Online.Icon
	local goal={}
	goal.Size = UDim2.fromScale(1.8,1.8)	
	local tweenInfo=TweenInfo.new(0.5)
	local tween1=TweenService:Create(PowerImag,tweenInfo,goal)
	tween1:Play()
	tween1.Completed:Connect(function()
		local tween5 = TweenService:Create(PowerImag, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(1.6,1.6)	
		})
		tween5:Play()
	end)
end
--停止播放Gift动画
local function stopGiftAnimation()
	local PowerImag = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Online.Icon
	PowerImag.Size = UDim2.new(1,0,1,0)
end

function FreeGiftController:KnitInit()
	FreeGiftService = Knit.GetService("FreeGiftService")
end

function FreeGiftController:KnitStart()
	for k,v in pairs(RewardFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Click:Connect(function()
				local giftId = v.GiftId.Value
				getFreeGiftRewards(v,giftId)
			end)
		end
	end
	BtnOpen.MouseButton1Click:Connect(function()
		self.OpenFreeGiftRewardsDedault()
		FrameTrigger.OpenFram(frameName)
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)

	end)

	BtnSkip.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts.UnlockAllOnlineRewards.Id)	
	end)

	FreeGiftService.ChangeFreeGiftRewards:Connect(changeFreeGiftRewards)
	FreeGiftService.ChangeFreeGiftTime:Connect(changeFreeGiftTime)

	FreeGiftService.ShowFreeRedIcon:Connect(showFreeRedIcon)
	FreeGiftService.PlayGiftAnimation:Connect(playGiftAnimation)
	FreeGiftService.StopGiftAnimation:Connect(stopGiftAnimation)
end

return FreeGiftController