--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local ItemController
local FishRodController

local CenterMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu
local MainHud = player.PlayerGui:WaitForChild("MainUi").MainHud
local NPCBagMenu = CenterMenu.NPCBagMenu

local BtnExit = NPCBagMenu.menu.Exit.TextButton

local BtnFishRodPage = NPCBagMenu.menu.SwitchBag.FishRodPage
local BtnItemPage = NPCBagMenu.menu.SwitchBag.ItemPage


local NPCController = Knit.CreateController { Name = "NPCController" }

function NPCController:OpenDedault()

end

function NPCController:KnitInit()
	ItemController = Knit.GetController("ItemController")
	FishRodController = Knit.GetController("FishRodController")
end

function NPCController:KnitStart()
	BtnExit.MouseButton1Click:Connect(function()
		local frameName="NPCBagMenu"
		FrameTrigger.CloseFram(frameName)
	end)
	BtnFishRodPage.MouseButton1Click:Connect(function()
		FishRodController:OpenDedault()
		local frameName="RodMenu"
		FrameTrigger.OpenFram(frameName)
	end)
	BtnItemPage.MouseButton1Click:Connect(function()
		ItemController:OpenDedault()
		local frameName="ItemMenu"
		FrameTrigger.OpenFram(frameName)
	end)
end

return NPCController