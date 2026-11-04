local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local PlayerResourceService

local DailyRewardController

local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local Knit = require(ReplicatedStorage.Packages.Knit)

local UpdateLogHelper = require(ReplicatedStorage.Config.UpdateLogHelper)

---GUI
local UpdateLogMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu.UpdateLogMenu

local BtnOpen=player.PlayerGui:WaitForChild("TopBar").TopMenu.UpdateLog
local BtnClose=UpdateLogMenu.Menu.Exit.TextButton

local frameName="UpdateLogMenu"

local UpdateLogController = Knit.CreateController { Name = "UpdateLogController" }

function UpdateLogController:SelectUpdate(index)
	for k,v in ipairs(UpdateLogMenu.Menu.Menu.ScrollingFrame:GetChildren()) do
		if v.ClassName=="Frame" then
			if v.Name=="bgline" then
			else
				v:Destroy()
			end
		end
	end
	for k,v in ipairs(UpdateLogHelper.GetIndex(tonumber(index))["TxtInfo"]) do
		local leftClone=UpdateLogMenu.Menu.Menu.ScrollingFrame.Folder.Frame.Frame:Clone()
		leftClone.TextLabel.Text=v
		leftClone.Parent=UpdateLogMenu.Menu.Menu.ScrollingFrame
	end
end
---更新公告
function UpdateLogController:ShowUpdateLog()
	for k,v in ipairs(UpdateLogMenu.Menu.Left.List:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	for k,v in ipairs(UpdateLogHelper.GetAll()) do
		local leftClone=UpdateLogMenu.Menu.Left.List.Folder.Frame.upd:Clone()
		leftClone.Frame.TextLabel.Text=UpdateLogHelper.GetIndex(k).UpName
		leftClone.Name=k
		leftClone.LayoutOrder=100-k
		leftClone.Parent=UpdateLogMenu.Menu.Left.List
		leftClone.MouseButton1Click:Connect(function()
			UpdateLogController:SelectUpdate(k)
		end)
	end
	for k,v in ipairs(UpdateLogMenu.Menu.Menu.ScrollingFrame:GetChildren()) do
		if v.ClassName=="Frame" then
			if v.Name=="bgline" then
			else
				v:Destroy()
			end
		end
	end
	for k,v in ipairs(UpdateLogHelper.GetIndex(1)["TxtInfo"]) do
		local leftClone=UpdateLogMenu.Menu.Menu.ScrollingFrame.Folder.Frame.Frame:Clone()
		leftClone.TextLabel.Text=v
		leftClone.Parent=UpdateLogMenu.Menu.Menu.ScrollingFrame
	end
end

function UpdateLogController:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")

	DailyRewardController = Knit.GetController("DailyRewardController")
end

local function isShowDaily(data)
	if data.isGetDaily then
		--print("今天领过了，今天的登录不再弹")
	else
		local frameName="DailyRewardsMenu"
		FrameTrigger.OpenFram(frameName)

		DailyRewardController:OpenRewardsDedault()
	end
end

function UpdateLogController:KnitStart()
	BtnOpen.MouseButton1Click:Connect(function()
		self.ShowUpdateLog()
		FrameTrigger.OpenFram(frameName)
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)

		PlayerResourceService:GetPlayerResourceData(player):andThen(isShowDaily)
	end)

	task.spawn(function()
		UpdateLogController:ShowUpdateLog()
		FrameTrigger.OpenFram(frameName)
	end)
end

return UpdateLogController