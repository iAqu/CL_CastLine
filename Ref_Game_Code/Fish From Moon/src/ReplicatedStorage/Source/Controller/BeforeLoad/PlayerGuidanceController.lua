local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerGuidanceService

local PlayerGuidanceController = Knit.CreateController { Name = "PlayerGuidanceController" }

local GuidancePart1 = workspace.World.GuidancePart.Task1
local GuidancePart2 = workspace.World.GuidancePart.Task2
local GuidancePart3 = workspace.World.GuidancePart.Task3
local GuidancePart4 = workspace.World.GuidancePart.Task4

local BtnSkipGuide=player.PlayerGui:WaitForChild("StartClickMenu").CenterMenu.TutorialMenu.Menu.skip
local MainTaskFrame=player.PlayerGui:WaitForChild("StartClickMenu").CenterMenu.TutorialMenu
--创建
local function creatTask1Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local attachment = Instance.new("Attachment", player.Character.HumanoidRootPart)
		local lineClone = ReplicatedStorage.Assets.Prefabs.Guidance.Beam:Clone()
		lineClone.Name = "Task1"
		lineClone.Parent = player.Character.HumanoidRootPart
		lineClone.Attachment0 = attachment
		local WelcomePart = workspace.World.GuidancePart.Task1
		lineClone.Attachment1 = WelcomePart.Attachment
		
		player.PlayerGui:WaitForChild("MainUi").MainHud.BottomTool.menuout.Open.tips.Visible = true

		MainTaskFrame.Menu.TextLabel.Text = "Press the button, try to get 100% on the charge bar and then release it"
		MainTaskFrame.Visible = true
	end	
end

--删除
local function destoryTask1Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character.HumanoidRootPart:FindFirstChild("Task1") then
			player.Character.HumanoidRootPart:FindFirstChild("Task1").Enabled = false
			player.Character.HumanoidRootPart:FindFirstChild("Task1"):Destroy()
			workspace.PreGuidancePart:ClearAllChildren()
		end
	end	
end

--创建
local function creatTask2Guidance()
	destoryTask1Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local attachment = Instance.new("Attachment", player.Character.HumanoidRootPart)
		local lineClone = game.ReplicatedStorage.Assets.Prefabs.Guidance.Beam:Clone()
		lineClone.Name = "Task2"
		lineClone.Parent = player.Character.HumanoidRootPart
		lineClone.Attachment0 = attachment
		local RadiatePart = workspace.World.GuidancePart.Task2
		lineClone.Attachment1 = RadiatePart.Attachment
		
		player.PlayerGui:WaitForChild("MainUi").MainHud.BottomTool.menuout.Open.tips.Visible = false
		
		MainTaskFrame.Menu.TextLabel.Text = "Try fishing a little farther away, and the rewards will be greater."
		MainTaskFrame.Visible = true
	end	
end

--删除
local function destoryTask2Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character.HumanoidRootPart:FindFirstChild("Task2") then
			player.Character.HumanoidRootPart:FindFirstChild("Task2").Enabled = false
			player.Character.HumanoidRootPart:FindFirstChild("Task2"):Destroy()
			MainTaskFrame.Menu.TextLabel.Text = "Try to catch five fish"
			workspace.PreGuidancePart:ClearAllChildren()
		end
	end	
end

--创建
local function creatTask3Guidance()
	destoryTask2Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local attachment = Instance.new("Attachment", player.Character.HumanoidRootPart)
		local lineClone = game.ReplicatedStorage.Assets.Prefabs.Guidance.Beam:Clone()
		lineClone.Name = "Task3"
		lineClone.Parent = player.Character.HumanoidRootPart
		lineClone.Attachment0 = attachment
		local LuckPetPart = workspace.World.GuidancePart.Task3
		lineClone.Attachment1 = LuckPetPart.Attachment

		MainTaskFrame.Menu.TextLabel.Text = "Try to open your first chest"
		MainTaskFrame.Visible = true
	end	
end

--删
local function destoryTask3Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character.HumanoidRootPart:FindFirstChild("Task3") then
			player.Character.HumanoidRootPart:FindFirstChild("Task3").Enabled = false
			player.Character.HumanoidRootPart:FindFirstChild("Task3"):Destroy()
			MainTaskFrame.Visible = false
		end
	end	
end

--创建
local function creatTask4Guidance()
	destoryTask3Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local attachment = Instance.new("Attachment", player.Character.HumanoidRootPart)
		local lineClone = game.ReplicatedStorage.Assets.Prefabs.Guidance.Beam:Clone()
		lineClone.Name = "Task4"
		lineClone.Parent = player.Character.HumanoidRootPart
		lineClone.Attachment0 = attachment
		local LuckPetPart = workspace.World.GuidancePart.Task4
		lineClone.Attachment1 = LuckPetPart.Attachment

		MainTaskFrame.Menu.TextLabel.Text = "Well done! Now let’s get stronger. Level up Strength +1"
		MainTaskFrame.Visible = true
	end	
end

--删
local function destoryTask4Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character.HumanoidRootPart:FindFirstChild("Task4") then
			player.Character.HumanoidRootPart:FindFirstChild("Task4").Enabled = false
			player.Character.HumanoidRootPart:FindFirstChild("Task4"):Destroy()
			MainTaskFrame.Visible = false
		end
	end	
end

--创建
local function creatWelcome()
	destoryTask4Guidance()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		MainTaskFrame.Menu.TextLabel.Text = "Well done! You’ve completed the tutorial. Thanks for playing!"
		MainTaskFrame.Visible = true
		task.spawn(function()
			task.wait(3)
			MainTaskFrame.Visible = false
		end)
	end	
end

local isCoolDown = {
	task1 = false,
	task2 = false,
	task3 = false,
	task4 = false,
}
local function destoryTask1(ortherPart)
	if not isCoolDown.task1 and ortherPart.Parent:FindFirstChild("HumanoidRootPart") then
		isCoolDown.task1 = true
		destoryTask1Guidance()
		task.wait(1)
		isCoolDown.task1 = false
	end
end
local function destoryTask2(ortherPart)
	if not isCoolDown.task2 and ortherPart.Parent:FindFirstChild("HumanoidRootPart") then
		isCoolDown.task2 = true
		destoryTask2Guidance()
		task.wait(1)
		isCoolDown.task2 = false
	end
end
local function destoryTask3(ortherPart)
	if not isCoolDown.task3 and ortherPart.Parent:FindFirstChild("HumanoidRootPart") then
		isCoolDown.task3 = true
		destoryTask3Guidance()
		task.wait(1)
		isCoolDown.task3 = false
	end
end
local function destoryTask4(ortherPart)
	if not isCoolDown.task4 and ortherPart.Parent:FindFirstChild("HumanoidRootPart") then
		isCoolDown.task4 = true
		destoryTask4Guidance()
		task.wait(1)
		isCoolDown.task4 = false
	end
end

function PlayerGuidanceController:KnitInit()
	PlayerGuidanceService = Knit.GetService("PlayerGuidanceService")
end

function PlayerGuidanceController:KnitStart()
	BtnSkipGuide.MouseButton1Click:Connect(function()
		destoryTask1Guidance()
		destoryTask2Guidance()
		destoryTask3Guidance()
		destoryTask4Guidance()
		MainTaskFrame.Visible = false
		PlayerGuidanceService:SkipGui()
	end)

	PlayerGuidanceService.CreatTask1Guidance:Connect(creatTask1Guidance)
	PlayerGuidanceService.CreatTask2Guidance:Connect(creatTask2Guidance)
	PlayerGuidanceService.CreatTask3Guidance:Connect(creatTask3Guidance)
	PlayerGuidanceService.CreatTask4Guidance:Connect(creatTask4Guidance)
	PlayerGuidanceService.CreatWelcome:Connect(creatWelcome)

	GuidancePart1.Touched:Connect(destoryTask1)
	GuidancePart2.Touched:Connect(destoryTask2)
	GuidancePart3.Touched:Connect(destoryTask3)
	GuidancePart4.Touched:Connect(destoryTask4)
end

return PlayerGuidanceController
