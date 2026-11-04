--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local BoostHelper=require(ReplicatedStorage.Config.BoostHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local PlayerBoostService

local NPCController
local FishRodController

local CenterMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu
local MainHud = player.PlayerGui:WaitForChild("MainUi").MainHud
local ItemMenu = CenterMenu.ItemMenu
local ItemFrame = ItemMenu.menu.Container.left.List

local ItemFolder = ItemFrame.Folder.Frame

local BtnExit = ItemMenu.menu.Exit.TextButton

local BtnFishRodPage = ItemMenu.menu.SwitchBag.FishRodPage
local BtnNPCPage = ItemMenu.menu.SwitchBag.NPCPage

local frameName="ItemMenu"

local ItemController = Knit.CreateController { Name = "ItemController" }

--缓存玩家PlayerBoostData数据
local PlayerBoostData

function ItemController:OpenDedault()
	---清空数据
	for index, object in pairs(ItemFrame:GetChildren()) do 
		if object:IsA("TextButton") then
			object:Destroy()
		end
	end
	for k, v in pairs(PlayerBoostData["useCount"]) do
		if v ~= 0 then
			local potionBtn = ItemFolder:WaitForChild("item"):Clone()
			potionBtn.Frame.imgPet.Image = BoostHelper.GetBoost(k).img
			potionBtn.Frame.number.Text = "x" .. NumberFormat.AbbreviateNumber(tonumber(v))
			potionBtn.Name = k
			potionBtn.Parent = ItemFrame
		end
	end
end

function changeBoostData()
	PlayerBoostService:GetPlayerBoostData():andThen(function(playerBoostData)
		if playerBoostData then
			PlayerBoostData = playerBoostData
			ItemController:OpenDedault()
		end
	end)
end

function ItemController:KnitInit()
	PlayerBoostService = Knit.GetService("PlayerBoostService")

	NPCController = Knit.GetController("NPCController")
	FishRodController = Knit.GetController("FishRodController")
end

function ItemController:KnitStart()
	BtnExit.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	BtnFishRodPage.MouseButton1Click:Connect(function()
		FishRodController:OpenDedault()
		local frameName="RodMenu"
		FrameTrigger.OpenFram(frameName)
	end)
	BtnNPCPage.MouseButton1Click:Connect(function()
		NPCController:OpenDedault()
		local frameName="NPCBagMenu"
		FrameTrigger.OpenFram(frameName)
	end)

	PlayerBoostService:GetPlayerBoostData():andThen(function(playerBoostData)
		PlayerBoostData = playerBoostData
	end)

	PlayerBoostService.ChangeBoostData:Connect(changeBoostData)
end

return ItemController