--加载服务
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--加载组件
local Knit = require(ReplicatedStorage.Packages.Knit)
local Luck = require(ReplicatedStorage.GuiUtils.Luck)
local Monetization = require(ReplicatedStorage.Config.Monetization)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local GamePassService
local FishRodLuckService

local MainGuiController
----GUI
local FishRodLuckEgg = player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg
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

local frameName = "FishRodLuckEgg"

local FishRodLuckController = Knit.CreateController { Name = "FishRodLuckController" }

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
function FishRodLuckController:OpenFishRodDedault(fishRodPoolId)
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

local function changePetLuckData()
	FishRodLuckController:OpenFishRodDedault(fishRodPoolIdBack)
end

---结束抽奖是不是还要打开抽奖界面
local function IsShowPetLuckEgg()
	changePetLuckData()
	player.PlayerGui:WaitForChild("MainMenu").Enabled=true
	player:SetAttribute("BuyEgg",false)
end

--单抽
function FishRodLuckController:LuckOnce(fishRodPoolId)
	if player:GetAttribute("BuyFishRod") then
		return
	end
	player:SetAttribute("BuyFishRod",true)
	FishRodLuckService:LuckOnce(fishRodPoolId):andThen(function(result,message,returnFishRodId)
		if result then
			local str = returnFishRodId
			local FishRodArr = {}
			table.insert(FishRodArr,str)
			Luck.openEgg(FishRodArr,fishRodPoolId)
		else
			IsShowPetLuckEgg()
			MainGuiController:ShowMessageEffect("warning",nil,message)
		end
	end)
end
--三抽
function FishRodLuckController:LuckThreeTimes(fishRodPoolId)
	if player:GetAttribute("BuyFishRod") then
		return
	end
	player:SetAttribute("BuyFishRod",true)
	FishRodLuckService:LuckThreeTimes(fishRodPoolId):andThen(function(result,message,eggPetId1,eggPetId2,eggPetId3)
		if result then
			local str1=eggPetId1
			local str2=eggPetId2
			local str3=eggPetId3
			local PetsArr={}
			table.insert(PetsArr,str1)
			table.insert(PetsArr,str2)
			table.insert(PetsArr,str3)
			Luck.openEgg(PetsArr,fishRodPoolId)
		else
			IsShowPetLuckEgg()
			MainGuiController:ShowMessageEffect("warning",nil,message)
		end
	end)
end

local autoLuck=false
---自动抽奖结束
function FishRodLuckController:AutoHatchStop()
	player.PlayerGui:WaitForChild("AutoSummon").Enabled=false
	player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
	IsShowPetLuckEgg()
	player.PlayerGui:WaitForChild("AutoSummon").T.Value=false
end

local function ReturnPrice(eggid,num)
	return (FishRoadPoolHelper.GetFishRoadPoolInfo(eggid).prince) * num
end
--自动抽
function FishRodLuckController:AutoLuck(eggid)
	local coin=0
	autoLuck=true
	if player:GetAttribute("BuyFishRod") then
		return
	end
	player:SetAttribute("BuyFishRod",true)
	FishRodLuckService:ReturnPlayerCoin(eggid):andThen(function(playerData)
		coin=playerData.moneys
		while autoLuck do
			if isHaveOpenThree then
				if coin-ReturnPrice(eggid,3)>=0 then
					player.PlayerGui:WaitForChild("AutoSummon").Enabled=true
					player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=true
					player.PlayerGui:WaitForChild("AutoSummon").T.Value=true
					coin=coin-ReturnPrice(eggid,3)
					FishRodLuckService:LuckThreeTimes(eggid):andThen(function(result,message,eggPetId1,eggPetId2,eggPetId3)
						if result then
							local str1=eggPetId1
							local str2=eggPetId2
							local str3=eggPetId3
							local PetsArr={}
							table.insert(PetsArr,str1)
							table.insert(PetsArr,str2)
							table.insert(PetsArr,str3)
							Luck.openEgg(PetsArr,eggid)
						else
							IsShowPetLuckEgg()
							MainGuiController:ShowMessageEffect("warning",nil,message)
							autoLuck=false
							player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
							if player.PlayerGui:WaitForChild("AutoSummon").Auto.Value then
							else
								FishRodLuckController:AutoHatchStop()
							end
						end
					end)
				else
					player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
					autoLuck=false
					if player.PlayerGui:WaitForChild("AutoSummon").Auto.Value then
					else
						FishRodLuckController:AutoHatchStop()
					end
					break
				end
			else
				if coin-ReturnPrice(eggid,1)>=0 then
					player.PlayerGui:WaitForChild("AutoSummon").Enabled=true
					player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=true
					player.PlayerGui:WaitForChild("AutoSummon").T.Value=true
					coin=coin-ReturnPrice(eggid,1)
					FishRodLuckService:LuckOnce(eggid):andThen(function(result,message,eggPetId)
						if result then
							local str=eggPetId
							local PetsArr={}
							table.insert(PetsArr,str)
							Luck.openEgg(PetsArr,eggid)
						else
							IsShowPetLuckEgg()
							MainGuiController:ShowMessageEffect("warning",nil,message)
							autoLuck=false
							player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
							if player.PlayerGui:WaitForChild("AutoSummon").Auto.Value then
							else
								FishRodLuckController:AutoHatchStop()
							end
						end
					end)
				else
					player.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
					autoLuck=false
					if player.PlayerGui:WaitForChild("AutoSummon").Auto.Value then
					else
						FishRodLuckController:AutoHatchStop()
					end
					break
				end
			end
			task.wait(4)
			autoLuck=player.PlayerGui:WaitForChild("AutoSummon").Auto.Value
			if player.PlayerGui:WaitForChild("AutoSummon").Auto.Value then
			else
				FishRodLuckController:AutoHatchStop()
			end
		end
	end)
end

function FishRodLuckController:KnitInit()
	GamePassService = Knit.GetService("GamePassService")
	FishRodLuckService = Knit.GetService("FishRodLuckService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function FishRodLuckController:KnitStart()
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)
end

return FishRodLuckController