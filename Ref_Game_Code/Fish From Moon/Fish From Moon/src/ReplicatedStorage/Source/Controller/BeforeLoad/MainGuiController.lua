local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local UITextEffect = require(ReplicatedStorage.GuiUntils.TextEffect)
local MessageEffect = require(ReplicatedStorage.GuiUntils.MessageEffect)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)

local MainHud = player.PlayerGui:WaitForChild("MainUi",5).MainHud
local BtnMoney = MainHud.Top.Moneys.More
local BtnGem = MainHud.Top.Gems.More
--加载UI处理
local MainGuiService

local StoreGuiController

---GUI
local MainHud=player.PlayerGui:WaitForChild("MainUi",5).MainHud

local MainGuiController = Knit.CreateController { Name = "MainGuiController" }

-- 改变金币数据
local function changeGems(gems)
	-- money
	local GemsText = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Gems.Amount
	local value = NumberFormat.AbbreviateNumber(gems, 2)
	GemsText.Text = value
end
-- 改变金币数据
local function changeMoneys(moneys)
	-- money
	local MoneysText = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Moneys.Amount
	local value = NumberFormat.AbbreviateNumber(moneys, 2)
	MoneysText.Text = value
end

--获得展示Coins效果
local function showGemsEffect(gems)
	UITextEffect.open("Gems",NumberFormat.AbbreviateNumber((gems),2))
end
--获得展示Coins效果
local function showMoneysEffect(coinType,moneys)
	MessageEffect:ShowMessage(coinType,moneys)
end

--消息展示
local function showMessageEffect(meaasgeType,txtNum,txt,img)
	MessageEffect:ShowMessage(meaasgeType,txtNum,txt,img)
end

--展示消息
local function showMessage(message,defColor)
	local color=defColor or Color3.new(0.286275, 1, 0.027451)
	local messageMenu=player.PlayerGui:WaitForChild("OldCommonMessage")
	local Message =messageMenu.Message.Folder.Frame.Message:Clone()
	Message.Parent = messageMenu.Message
	Message.TextColor3=color
	Message.Text = message
	task.wait(2)
	Message:Destroy()
end

function MainGuiController:ShowMessage(message,defColor)
	showMessage(message,defColor)
end

function MainGuiController:ShowMessageEffect(meaasgeType,txtNum,txt,img)
	showMessageEffect(meaasgeType,txtNum,txt,img)
end

--画面过度
local function screenSwitching(tweenTime)
	--player.Character:WaitForChild("Humanoid").WalkSpeed=0
	local switching = player.PlayerGui:WaitForChild("ScreenSwitching"):WaitForChild("Switching")
	local UIScale = switching.UIScale
	UIScale.Scale = 0
	local goal = {}
	goal.Scale = 1
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Exponential)
	local tween = TweenService:Create(UIScale, tweenInfo, goal)
	tween:Play()
	task.wait(tweenTime+0.2)
	--player.Character:WaitForChild("Humanoid").WalkSpeed=20
	switching.UIScale.Scale=0
end

-- 初始化主页面数据
local function initMainGui(data)
	-- money
	local MoneysText = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Moneys.Amount
	local moneys = NumberFormat.AbbreviateNumber((data.playerResource.moneys), 2)
	MoneysText.Text = moneys
	-- money
	local GemsText = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Top.Gems.Amount
	local gems = NumberFormat.AbbreviateNumber((data.playerResource.gems), 2)
	GemsText.Text = gems
end

function MainGuiController:PowerLoad()
	
end

function MainGuiController:KnitInit()
	MainGuiService = Knit.GetService("MainGuiService")

	StoreGuiController = Knit.GetController("StoreGuiController")
end

function MainGuiController:KnitStart()
	BtnMoney.MouseButton1Click:Connect(function()
		StoreGuiController:MainUIMoney()
	end)
	BtnGem.MouseButton1Click:Connect(function()
		StoreGuiController:MainUIGem()
	end)
	----改变金币
	MainGuiService.ChangeMoneys:Connect(changeMoneys)
	MainGuiService.ChangeGems:Connect(changeGems)

	MainGuiService.ShowMoneysEffect:Connect(showMoneysEffect)
	MainGuiService.ShowGemsEffect:Connect(showGemsEffect)
	MainGuiService.ShowMessageEffect:Connect(showMessageEffect)
	----展示消息
	MainGuiService.ShowMessage:Connect(showMessage)

	MainGuiService.ScreenSwitching:Connect(screenSwitching)

	MainGuiService.InitMainGui:Connect(initMainGui)
end

return MainGuiController