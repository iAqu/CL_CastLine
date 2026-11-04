--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishHelper = require(ReplicatedStorage.Config.FishHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FishIndexService

----GUI
local FishIndexMenu = LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishIndexMenu
local FishIndexFrame = FishIndexMenu.Menu.Container.List

local BtnOpen=LocalPlayer.PlayerGui:WaitForChild("MainUi",5).MainHud.Left.Holder.fishindex.btn
local BtnClose=FishIndexMenu.Menu.Exit.TextButton

local FishIndexFolder = FishIndexFrame.Folder.Frame

local frameName="FishIndexMenu"

local FishIndexController = Knit.CreateController { Name = "FishIndexController" }

local function changeFishIndexData()
	local function getData(fishData)
		---清空数据
		for index, object in pairs(FishIndexFrame:GetChildren()) do 
			if object:IsA("Frame") then
				object:Destroy()
			end
		end

		local fishIndexList = FishHelper.GetFishList()

		for k,v in pairs(fishIndexList) do
			local PreFishPool:Frame = FishIndexFolder:WaitForChild(v.quality):Clone()
			PreFishPool.frame.Fish.Image = v.img
			PreFishPool.frame.Fish.ImageColor3 = Color3.new(0, 0, 0)
			PreFishPool.frame.FishTopName.Text = "???"
			PreFishPool.frame.FishName.Visible = false
			PreFishPool.frame.MaxSize.Text = "???"
			PreFishPool.LayoutOrder = v.layout
			PreFishPool.Parent = FishIndexFrame

			if table.find(fishData.unlockFish,tostring(k)) then
				PreFishPool.frame.FishTopName.Text = v.nameUp
				if v.nameDown == "" then
					PreFishPool.frame.FishName.Visible = false
				else
					PreFishPool.frame.FishName.Text = v.nameDown
					PreFishPool.frame.FishName.Visible = true
				end
				PreFishPool.frame.Fish.ImageColor3 = Color3.new(1, 1, 1)
				PreFishPool.frame.MaxSize.Text = NumberFormat.AbbreviateNumber(fishData.FishWeight[tostring(k)],2)
			end
		end
		FishIndexMenu.Menu.Count.number.Text = #(fishData.unlockFish).."/"..Tool.getTableLegth(fishIndexList)
	end
	FishIndexService:GetFishIndexData(LocalPlayer):andThen(getData)
end
--打开界面
function FishIndexController:OpenDedault()
	changeFishIndexData()
end

function FishIndexController:NewFishUI(fishName)
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips["New Fish"].picture.ImageLabel.Image = FishHelper.GetFish(fishName).img
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips["New Fish"].txt.TextLabel.Text = fishName
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips["New Fish"].Visible = true
	task.spawn(function()
		task.wait(2)
		LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips["New Fish"].Visible = false
	end)
end

function FishIndexController:KnitInit()
	FishIndexService = Knit.GetService("FishIndexService")
end

function FishIndexController:KnitStart()
	BtnOpen.MouseButton1Click:Connect(function()
		FishIndexController:OpenDedault()

		local frameName="FishIndexMenu"
		FrameTrigger.OpenFram(frameName)
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)
end

return FishIndexController