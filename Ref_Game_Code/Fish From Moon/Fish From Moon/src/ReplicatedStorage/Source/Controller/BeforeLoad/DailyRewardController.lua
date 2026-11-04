local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local DailyRewardHelper=require(ReplicatedStorage.Config.DailyRewardHelper)

local player = Players.LocalPlayer

local FrameTrigger

local DailyRewardService

----GUI
local MainHud=player.PlayerGui:WaitForChild("MainUi",5).MainHud

local DailyRewardsMenu=player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.DailyRewardsMenu

local BtnOpen=MainHud.Right.daily.DailySign
local BtnClose=DailyRewardsMenu.Menu.Container.Exit.TextButton

local RewardFrame = DailyRewardsMenu.Menu.Container.Icons.ScrollingFrame
local DailyFolder=RewardFrame.Folder.Frame

local frameName="DailyRewardsMenu"

local DailyRewardController = Knit.CreateController { Name = "DailyRewardController" }

local function MenuGetRewards(rewardId)
	DailyRewardService:GetRewards(rewardId):andThen(function(result,message)
		if result then
			--TOOD 发送消息
		end
		FrameTrigger.CloseFram(frameName)
	end)
end
---七日奖励
local function changeRewards()

	local function ShowRewards(dailyRewardData)
		local dailyList=DailyRewardHelper.GetDailyReward()

		local rewardsMax = dailyRewardData.rewardsMax
		local claimList = dailyRewardData.claimList

		for k,v in pairs(RewardFrame:GetChildren()) do
			if v:IsA("TextButton") then
				v:Destroy()
			end
		end

		for k,v in pairs(dailyList) do
			local dailyClone=DailyFolder.PreDaily:Clone()
			dailyClone.Frame.ImageLabel.Image=DailyRewardHelper.GetDailyRewardImg(k)
			dailyClone.Frame.ClaimText.Text="Day"..k
			dailyClone.Frame.NumText.Text=DailyRewardHelper.GetDailyRewardNum(k)
			dailyClone.Frame.TextLabel.Text=DailyRewardHelper.GetDailyRewardTxt(k)

			dailyClone.Name=k
			dailyClone.Parent=RewardFrame
			if tonumber(k)==4 or tonumber(k)==7 then
				dailyClone.Frame.BackgroundColor3=Color3.new(0.333333, 0, 1)
			end

			if k <= rewardsMax then
				dailyClone.Frame.ClaimText.Text="Claim"
				dailyClone.Frame.ClaimText.TextColor3=Color3.new(0.14902, 1, 0)
			end
			local cd=false
			dailyClone.MouseButton1Click:Connect(function()
				if not cd then
					cd = true
					local rewardId = RewardFrame.RewardId.Value
					FrameTrigger.CloseFram(frameName)

					MenuGetRewards(rewardId)
					task.wait(1)
					cd = false
				end
			end)
		end

		for k,rewardId in claimList do
			local claimText = RewardFrame[rewardId].Frame.ClaimText
			claimText.Text="Claimed"
			claimText.TextColor3=Color3.new(1, 1, 1)
		end

		if (#claimList)+1<=rewardsMax then
			RewardFrame.RewardId.Value= (#claimList)+1
		end

		TweenService:Create(
			RewardFrame,
			TweenInfo.new(0.3),
			{
				CanvasPosition = Vector2.new(#claimList*120,0)
			}
		):Play()

	end
	DailyRewardService:GetDailyRewardData():andThen(ShowRewards)
end
--打开七日奖励界面界面
function DailyRewardController:OpenRewardsDedault()
	changeRewards()
end

local function changeRedIcon()
	BtnOpen.Red.Visible=true
end

function DailyRewardController:KnitInit()
	DailyRewardService = Knit.GetService("DailyRewardService")

	FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
end

function DailyRewardController:KnitStart()
	BtnOpen.MouseButton1Click:Connect(function()
		self.OpenRewardsDedault()
		FrameTrigger.OpenFram(frameName)
		BtnOpen.Red.Visible=false
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	DailyRewardService.ChangeRewards:Connect(changeRewards)
	DailyRewardService.ChangeRedIcon:Connect(changeRedIcon)
end

return DailyRewardController
