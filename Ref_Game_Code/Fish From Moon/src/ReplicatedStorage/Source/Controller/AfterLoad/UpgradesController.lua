--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local UpgradesHelper = require(ReplicatedStorage.Config.UpgradesHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local UpgradesService

local Upgrades = player.PlayerGui:WaitForChild("MainMenu").CenterMenu.Upgrades

local BtnExit = Upgrades.Frame.Exit.TextButton
local BtnSpeed = Upgrades.Frame.Container.Speed.R.TextButton
local BtnStrength = Upgrades.Frame.Container.Strength.R.TextButton
local BtnLuck = Upgrades.Frame.Container.FishLuck.R.TextButton

local frameName="Upgrades"

local UpgradesController = Knit.CreateController { Name = "UpgradesController" }

local function rushUI()
	local function getData(updateData)
		Upgrades.Frame.Container.Speed.L.level.Text = "LVL "..updateData.speedLevel
		if updateData.speedLevel >= 21 then
			print("等级最大值")
			Upgrades.Frame.Container.Speed.R.max.Visible = true
			Upgrades.Frame.Container.Speed.R.TextButton.Visible = false
		end
		Upgrades.Frame.Container.Speed.R.TextLabel.Text = NumberFormat.AbbreviateNumber(UpgradesHelper.GetUpgradesNeedNum("speedLevel",updateData.speedLevel),2)

		Upgrades.Frame.Container.Strength.L.level.Text = "LVL "..updateData.strengthLevel
		if updateData.strengthLevel >= 27 then
			print("等级最大值")
			Upgrades.Frame.Container.Strength.R.max.Visible = true
			Upgrades.Frame.Container.Strength.R.TextButton.Visible = false
		end
		Upgrades.Frame.Container.Strength.R.TextLabel.Text = NumberFormat.AbbreviateNumber(UpgradesHelper.GetUpgradesNeedNum("strengthLevel",updateData.strengthLevel),2)

		Upgrades.Frame.Container.FishLuck.L.level.Text = "LVL "..updateData.luckLevel
		if updateData.luckLevel >= 27 then
			print("等级最大值")
			Upgrades.Frame.Container.FishLuck.R.max.Visible = true
			Upgrades.Frame.Container.FishLuck.R.TextButton.Visible = false
		end
		Upgrades.Frame.Container.FishLuck.R.TextLabel.Text = NumberFormat.AbbreviateNumber(UpgradesHelper.GetUpgradesNeedNum("luckLevel",updateData.luckLevel),2)
	end
	UpgradesService:GetUpgradesData(player):andThen(getData)
end

function UpgradesController:OpenDedault()
	rushUI()
	FrameTrigger.OpenFram(frameName)
end

function UpgradesController:UpgradesLevel(id)
	if id == "speedLevel" then
		UpgradesService:UpgradesAttributes("speedLevel")
	elseif id == "strengthLevel" then
		UpgradesService:UpgradesAttributes("strengthLevel")
	elseif id == "luckLevel" then
		UpgradesService:UpgradesAttributes("luckLevel")
	end
end

local function initWalkSpeed(walkSpeed)
	player.Character.Humanoid.WalkSpeed = walkSpeed
end

function UpgradesController:KnitInit()
	UpgradesService = Knit.GetService("UpgradesService")
end

function UpgradesController:KnitStart()
	BtnExit.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	BtnSpeed.MouseButton1Click:Connect(function()
		UpgradesController:UpgradesLevel("speedLevel")
	end)
	BtnStrength.MouseButton1Click:Connect(function()
		UpgradesController:UpgradesLevel("strengthLevel")
	end)
	BtnLuck.MouseButton1Click:Connect(function()
		UpgradesController:UpgradesLevel("luckLevel")
	end)

	UpgradesService.RushUI:Connect(rushUI)
	UpgradesService.InitWalkSpeed:Connect(initWalkSpeed)
end

return UpgradesController