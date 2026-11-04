--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FishRoadPoolHelper = require(ReplicatedStorage.Config.FishRoadPoolHelper)
local FrameTrigger=require(LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FishRodIndexService

----GUI
local IndexMenu = LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.IndexMenu
local IndexFrame = IndexMenu.Menu.Container.List

local BtnClose = IndexMenu.Menu.Exit.TextButton

local FishRodPoolFolder = IndexFrame.Folder

local FishRodIndexController = Knit.CreateController { Name = "FishRodIndexController" }

local function changeFishRodIndexData()
	local function getData(fishRodIndexData)
		---清空数据
		for index, object in pairs(IndexFrame:GetChildren()) do 
			if object:IsA("Frame") then
				object:Destroy()
			end
		end
		
		local indexList = FishRoadPoolHelper.GetAllFishRoadPool()
		local FishRodList = FishRodHelper.GetFishRodList()
		local FishRodReWard = {}
		
		for k,v in ipairs(indexList) do
			FishRodReWard[v.fishRoadPoolName] = true
			local PreFishRodPool = FishRodPoolFolder.FishRodPool.FishRodIndex:Clone()
			PreFishRodPool.left.EggName.EggName.Text = v.fishRoadPoolName
			PreFishRodPool.right.rewardWins.Frame.Power.Text = "x"..NumberFormat.AbbreviateNumber(v.indexReward[1],2)
			PreFishRodPool.right.rewardGems.Frame.Power.Text = "x"..NumberFormat.AbbreviateNumber(v.indexReward[2],2)
			PreFishRodPool.Parent = IndexFrame
			
			PreFishRodPool.right.claim.IndexId.Value = k
			
			for y,z in ipairs(v.pool) do
				local fishRodInfo = FishRodHelper.GetFishRod(z.fishRod)
				local PreFishRod = FishRodPoolFolder.Frame:WaitForChild(fishRodInfo.quality):Clone()
				PreFishRod.Frame.imgPet.Image = fishRodInfo.img
				PreFishRod.Frame.imgPet.ImageColor3 = Color3.new(0, 0, 0)
				PreFishRod.Frame.Power.Text = "???"
				if table.find(fishRodIndexData.unlockFishRod,tostring(z.fishRod)) then
					PreFishRod.Frame.imgPet.ImageColor3 = Color3.new(1, 1, 1)
				end
				PreFishRod.Frame.Power.Text = "x"..NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier,2)
				PreFishRod.Parent = PreFishRodPool.left.FishRod
			end
			for y,z in ipairs(v.pool) do
				if not FishRodReWard[v.fishRoadPoolName] then
					break
				end
				if table.find(fishRodIndexData.unlockFishRod,tostring(z.fishRod)) then
					FishRodReWard[v.fishRoadPoolName] = true
				else
					FishRodReWard[v.fishRoadPoolName] = false
				end
			end
			--最后判断能不能领取
			if FishRodReWard[v.fishRoadPoolName] then
				PreFishRodPool.right.claim.Visible = true
			end
			if table.find(fishRodIndexData.getRewardList,tostring(v.fishRoadPoolName)) then
				PreFishRodPool.right.claim.Visible = false
				PreFishRodPool.right.claimmed.Visible = true
			end
		end
		IndexMenu.Menu.Count.number.Text = #(fishRodIndexData.unlockFishRod).."/"..Tool.getTableLegth(FishRodList)
	end
	FishRodIndexService:GetFishRodIndexData(LocalPlayer):andThen(getData)
end

--打开界面
function FishRodIndexController:OpenDedault()
	changeFishRodIndexData()
end

function FishRodIndexController:KnitInit()
	FishRodIndexService = Knit.GetService("FishRodIndexService")
end

function FishRodIndexController:KnitStart()
	BtnClose.MouseButton1Click:Connect(function()
		local frameName="IndexMenu"
		FrameTrigger.CloseFram(frameName)
	end)
	FishRodIndexService.ChangeFishRodIndexData:Connect(changeFishRodIndexData)
end

return FishRodIndexController