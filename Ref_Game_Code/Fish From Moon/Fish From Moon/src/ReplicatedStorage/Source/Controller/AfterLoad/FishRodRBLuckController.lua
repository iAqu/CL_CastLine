--加载服务
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--加载组件
local Knit = require(ReplicatedStorage.Packages.Knit)
local RBLuck = require(ReplicatedStorage.GuiUtils.RBLuck)
local Monetization = require(ReplicatedStorage.Config.Monetization)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local GamePassService
local FishRodRBLuckService

local MainGuiController
----GUI
local FishRodLuckEgg = player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodRbLuckEgg
local FishRodFrame = FishRodLuckEgg.Frame.List.FishRoad
local BtnClose = FishRodLuckEgg.Frame.Exit.TextButton

local FishRodFolder = FishRodFrame.Folder.Frame

local tit = FishRodLuckEgg.Frame.List.EggName

local fishRodPoolIdBack = 1
local isHaveLuck = false
local isHaveSuperLuck = false
local isHaveUltraLuck = false
local isHaveAutoChest = false
local isHaveOpenThree = false
local isHaveMagicChest = false

local frameName = "FishRodRbLuckEgg"

local FishRodRBLuckController = Knit.CreateController { Name = "FishRodRBLuckController" }

local function FlashFishRodPass()
	GamePassService:IsPlayerHaveGamePass("Luck"):andThen(function(result)
		if result then
			isHaveLuck=true
		else
			isHaveLuck=false
		end
	end)
	GamePassService:IsPlayerHaveGamePass("SuperLuck"):andThen(function(result)
		if result then
			isHaveSuperLuck=true
		else
			isHaveSuperLuck=false
		end
	end)
	GamePassService:IsPlayerHaveGamePass("UltraLuck"):andThen(function(result)
		if result then
			isHaveUltraLuck=true
		else
			isHaveUltraLuck=false
		end
	end)
	GamePassService:IsPlayerHaveGamePass("AutoChest"):andThen(function(result)
		if result then
			isHaveAutoChest=true
		else
			isHaveAutoChest=false
		end
	end)
	GamePassService:IsPlayerHaveGamePass("TripleOpen"):andThen(function(result)
		if result then
			isHaveOpenThree=true
		else
			isHaveOpenThree=false
		end
	end)
	GamePassService:IsPlayerHaveGamePass("MagicChest"):andThen(function(result)
		if result then
			isHaveMagicChest=true
		else
			isHaveMagicChest=false
		end
	end)
end

--打开宠物抽奖界面
function FishRodRBLuckController:OpenFishRodDedault(fishRodPoolId)
	FlashFishRodPass()

	FishRodLuckEgg.Frame.fishRodPoolId.Value = fishRodPoolId
	fishRodPoolIdBack = fishRodPoolId

	tit.Text = FishRoadPoolHelper.GetFishRoadPoolInfo(fishRodPoolId).fishRoadPoolName
	FishRodLuckEgg.Frame.List.Price.TextLabel.Text = NumberFormat.AbbreviateNumber(FishRoadPoolHelper.GetFishRoadPoolInfo(fishRodPoolId).prince,2)
	---
	for k,v in pairs(FishRodFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	for k,v in ipairs(FishRoadPoolHelper.GetFishRoadPool(fishRodPoolId)) do
		local fishRoadInfo = FishRodHelper.GetFishRod(v.fishRod)
		local FishRoadCell = FishRodFolder:WaitForChild(fishRoadInfo.quality):Clone()
		--FishRoadCell.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRoadInfo.baseMultiplier,2)
		FishRoadCell.Frame.Power.Text = (v.weight / 100).."%"
		FishRoadCell.Frame.imgPet.Image = fishRoadInfo.img
		FishRoadCell.Parent = FishRodFrame
	end
end

--单抽
local function luckOnce(fishRodPoolId,returnFishRodId)
	player.PlayerGui:WaitForChild("MainMenu").Enabled = false
	local str=returnFishRodId
	local PetsArr={}
	table.insert(PetsArr,str)
	RBLuck.openEgg(PetsArr,fishRodPoolId)
end

function FishRodRBLuckController:KnitInit()
	GamePassService = Knit.GetService("GamePassService")
	FishRodRBLuckService = Knit.GetService("FishRodRBLuckService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function FishRodRBLuckController:KnitStart()
	FishRodRBLuckService.LuckOnce:Connect(luckOnce)
	
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)
end

return FishRodRBLuckController