local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)
local MoneyHelper = require(ReplicatedStorage.Config.MoneyHelper)
local Monetization = require(ReplicatedStorage.Config.Monetization)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local StoreDailyHelper = require(ReplicatedStorage.Config.StoreDailyHelper)
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local StoreGuiService
local GamePassService
local PlayerBoostService
local PlayerResourceService

---GUI
local StoreMenu = player.PlayerGui:WaitForChild("MainMenu",5):WaitForChild("CenterMenu"):WaitForChild("StoreMenu")
local store = StoreMenu.Frame.Menu.Container.List

local BtnOpen = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Left.Holder.store.btn
local BtnClose = StoreMenu.Frame.Menu.Exit.TextButton

local LuckPotion = store.Potions.Left.LuckPotion
local LuckPotion10 = store.Potions.Left.LuckPotion10
local SuperLuckPotion = store.Potions.Left.SuperLuckPotion
local SuperLuckPotion10 = store.Potions.Left.SuperLuckPotion10
local MoneyPotion = store.Potions.Left.MoneyPotion
local MoneyPotion10 = store.Potions.Left.MoneyPotion10

local BtnDailyPage=StoreMenu.Frame.Page.daily
local BtnPassPage=StoreMenu.Frame.Page.pass
local BtnBoostPage=StoreMenu.Frame.Page.boost
local BtnMoneyPage=StoreMenu.Frame.Page.money
local BtnGemPage=StoreMenu.Frame.Page.gem

local frameName="StoreMenu"

local connectionPass = {}
local connectionBoost = {}
local connectionSuperBoost=nil
local connectionWins = {}
local connectionSuperWins=nil
local connectionGems = {}
local connectionSuperGems=nil

local StoreGuiController = Knit.CreateController { Name = "StoreGuiController" }

local BoostData

function isPlayerHaveBoost(boostname)       -----是否拥有
	if BoostData[boostname]  then
		if (BoostData[boostname] - os.time()) < 0 then
			return false
		else
			return true
		end
	else
		return false
	end
end

function changeBoost(boostData)
	BoostData = boostData
end

local function isToday(year, month, day)
	local currentTime = os.date("*t") -- 获取当前时间（返回一个table）

	return currentTime.year == year and
		currentTime.month == month and
		currentTime.day == day
end

function changeDailyData()
	local function getData(storeData)
		if isToday(storeData.dayIndex.year, storeData.dayIndex.month, storeData.dayIndex.day) then
			print(storeData)
			local dailyUI = store.daily.container.frame.ScrollingFrame
			for k,v in pairs(dailyUI:GetChildren()) do
				if v:IsA("Frame") then
					v.L.TextButton.Title.Text = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].name
					v.L.TextButton.ImageLabel.Image = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].img
					v.L.TextButton.text.Text = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].num
				end
				if k <= storeData.alreadyGet then
					v.Visible = false
				end
			end
		else
			StoreGuiService:InitStoreDaily()
			local function getNewData(storeData)
				print(storeData)
				local dailyUI = store.daily.container.frame.ScrollingFrame
				for k,v in pairs(dailyUI:GetChildren()) do
					if v:IsA("Frame") then
						v.L.TextButton.Title.Text = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].name
						v.L.TextButton.ImageLabel.Image = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].img
						v.L.TextButton.text.Text = StoreDailyHelper.GetIndexDaily(tonumber(v.Name))[tonumber(storeData.rewardlist[tonumber(v.Name)])].num
					end
				end
			end
			StoreGuiService:GetStoreDailyData(player):andThen(getNewData)
		end
	end
	StoreGuiService:GetStoreDailyData(player):andThen(getData)
	
end

--打开通行证界面
function changePassData()
	local gamePassUI=store.Pass.Gamepass
	for k,v in pairs(gamePassUI:GetChildren()) do
		if v:IsA("Frame") then
			v.TextButton.Title.Text = Monetization.Gamepasses[v.Name].DisplayName
			--v.TextButton.ImageLabel.Image = Monetization.Gamepasses[v.Name].Icon
			v.TextButton.Price.Robux.Text = Monetization.Gamepasses[v.Name].Cost

			GamePassService:GetPlayerAllGamePass():andThen(function(gamePassData)
				--展示通行证数据
				local passData = gamePassData
				if passData and passData[v.Name] then
					local BtnPass = store.Pass.Gamepass[v.Name]
					BtnPass.TextButton.Price.Visible = false
					BtnPass.TextButton.Own.Visible = true
					BtnPass.TextButton.Interactable=false
				else
					local BtnPass = store.Pass.Gamepass[v.Name]
					BtnPass.TextButton.Price.Visible = true
					BtnPass.TextButton.Own.Visible = false
					BtnPass.TextButton.Interactable=true
				end
			end)
			if connectionPass[v.Name] then
				connectionPass[v.Name]:Disconnect()
			end
			connectionPass[v.Name]=v.TextButton.MouseButton1Click:Connect(function()
				MarketplaceService:PromptGamePassPurchase(player,Monetization.Gamepasses[v.Name].Id)
			end)
		end
	end
end

function changeBoostData()
	local boostUI=store.Potions.Left
	for k,v in pairs(boostUI:GetChildren()) do
		if v:IsA("Frame") then
			v.name.Text = Monetization.DevProducts[v.Name].DisplayName
			--v.mid.LastTime.Text = Monetization.DevProducts[v.Name].Desc
			--v.BG.img.Image = Monetization.DevProducts[v.Name].Icon
			v.buy.Frame.TextLabel.Text = Monetization.DevProducts[v.Name].Cost

			PlayerBoostService:GetPlayerBoostData():andThen(function(playerBoostData)
				--获取Boost能够使用的次数
				local useCount = playerBoostData.useCount
				BoostData=playerBoostData

				LuckPotion.use.Frame.number.Text = "x"..tostring(useCount["LuckPotion"])
				LuckPotion10.use.Frame.number.Text = "x"..tostring(useCount["LuckPotion"])
				SuperLuckPotion.use.Frame.number.Text = "x"..tostring(useCount["SuperLuckPotion"])
				SuperLuckPotion10.use.Frame.number.Text = "x"..tostring(useCount["SuperLuckPotion"])
				MoneyPotion.use.Frame.number.Text = "x"..tostring(useCount["MoneyPotion"])
				MoneyPotion10.use.Frame.number.Text = "x"..tostring(useCount["MoneyPotion"])
			end)

			if connectionBoost[v.Name] then
				connectionBoost[v.Name]:Disconnect()
			end
			connectionBoost[v.Name]=v.buy.MouseButton1Click:Connect(function()
				MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts[v.Name].Id)
			end)
		end
	end
	if connectionSuperBoost then
		connectionSuperBoost:Disconnect()
	end
	connectionSuperBoost=store.Potions.Right.PotionBundle.buy.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts["SuperPotionsBundle"].Id)
	end)
end

function changeCoin()
	local WinsUI=store.Money.Left
	for k,v in pairs(WinsUI:GetChildren()) do
		if v:IsA("Frame") then
			v.name.Text = Monetization.DevProducts[v.Name].DisplayName
			v.buy.Frame.TextLabel.Text = Monetization.DevProducts[v.Name].Cost

			PlayerResourceService:GetPlayerResourceData():andThen(function(playerResourceData)
				local maxWorld=playerResourceData.maxWorld
				--coins
				store.Money.Left.MoneySmallPack.describe.Text="+"..NumberFormat.AbbreviateNumber(math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySmallPack")),2)
				store.Money.Left.MoneyMediumPack.describe.Text="+"..NumberFormat.AbbreviateNumber(math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyMediumPack")),2)
				store.Money.Left.MoneyBigPack.describe.Text="+"..NumberFormat.AbbreviateNumber(math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyBigPack")),2)
				store.Money.Left.MoneySuperPack.describe.Text="+"..NumberFormat.AbbreviateNumber(math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneySuperPack")),2)
				store.Money.Right.MoneyUltraPack.describe.Text="+"..NumberFormat.AbbreviateNumber(math.ceil(MapHelper.GetMapPrice(tonumber(maxWorld))*MoneyHelper.GetMoney("MoneyUltraPack")),2)
			end)
			if connectionWins[v.Name] then
				connectionWins[v.Name]:Disconnect()
			end
			connectionWins[v.Name]=v.buy.MouseButton1Click:Connect(function()
				MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts[v.Name].Id)
			end)
		end
	end
	if connectionSuperWins then
		connectionSuperWins:Disconnect()
	end
	connectionSuperWins=store.Money.Right.MoneyUltraPack.buy.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts["MoneyUltraPack"].Id)
	end)
end

function changeGem()
	local GemsUI=store.Gem.Left
	for k,v in pairs(GemsUI:GetChildren()) do
		if v:IsA("Frame") then
			v.name.Text = Monetization.DevProducts[v.Name].DisplayName
			v.buy.Frame.TextLabel.Text = Monetization.DevProducts[v.Name].Cost

			PlayerResourceService:GetPlayerResourceData():andThen(function(playerResourceData)
				local maxWorld=playerResourceData.maxWorld
				--gem
				store.Gem.Left.GemsSmallPack.describe.Text="+"..NumberFormat.AbbreviateNumber(7500,2)
				store.Gem.Left.GemsMediumPack.describe.Text="+"..NumberFormat.AbbreviateNumber(31250,2)
				store.Gem.Left.GemsBigPack.describe.Text="+"..NumberFormat.AbbreviateNumber(125000,2)
				store.Gem.Left.GemsSuperPack.describe.Text="+"..NumberFormat.AbbreviateNumber(250000,2)
				store.Gem.Right.GemsUltraPack.describe.Text="+"..NumberFormat.AbbreviateNumber(750000,2)
			end)
			if connectionGems[v.Name] then
				connectionGems[v.Name]:Disconnect()
			end
			connectionGems[v.Name]=v.buy.MouseButton1Click:Connect(function()
				MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts[v.Name].Id)
			end)
		end
	end
	if connectionSuperGems then
		connectionSuperGems:Disconnect()
	end
	connectionSuperGems=store.Gem.Right.GemsUltraPack.buy.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player,Monetization.DevProducts["GemsUltraPack"].Id)
	end)
end
----打开界面
function StoreGuiController:OpenStoreDedault()
	--
	--changeDailyData()
	--pass
	changePassData()
	--展示Boost数据
	changeBoostData()
	--金币
	changeCoin()
	--钻石
	changeGem()
end

local function MoveS(pos)
	local abY= StoreMenu.Frame.Menu.Container.List.AbsoluteCanvasSize.Y
	TweenService:Create(
		store,
		TweenInfo.new(0.25,Enum.EasingStyle.Linear), 
		{
			CanvasPosition = Vector2.new(0,pos/1700.17*abY)
		}
	):Play()
end

local function HidePage()
	for k,v in pairs(StoreMenu.Frame.Page:GetChildren()) do
		if v:IsA("TextButton") then
			v.Frame.BackgroundColor3 = Color3.new(0.0431373, 0.580392, 0.988235)
		end
	end
end

local function BtnActive()
	---切换页面
	BtnDailyPage.MouseButton1Click:Connect(function()
		MoveS(0)
		HidePage()
		StoreMenu.Frame.Page.daily.Frame.BackgroundColor3 = Color3.new(0.988235, 0.847059, 0.145098)
	end)
	BtnPassPage.MouseButton1Click:Connect(function()
		MoveS(200)
		HidePage()
		StoreMenu.Frame.Page.pass.Frame.BackgroundColor3 = Color3.new(0.988235, 0.847059, 0.145098)
	end)
	BtnBoostPage.MouseButton1Click:Connect(function()
		MoveS(610)
		HidePage()
		StoreMenu.Frame.Page.boost.Frame.BackgroundColor3 = Color3.new(0.988235, 0.847059, 0.145098)
	end)
	BtnMoneyPage.MouseButton1Click:Connect(function()
		MoveS(970)
		HidePage()
		StoreMenu.Frame.Page.money.Frame.BackgroundColor3 = Color3.new(0.988235, 0.847059, 0.145098)
	end)
	BtnGemPage.MouseButton1Click:Connect(function()
		MoveS(1300)
		HidePage()
		StoreMenu.Frame.Page.gem.Frame.BackgroundColor3 = Color3.new(0.988235, 0.847059, 0.145098)
	end)
	---使用
	LuckPotion.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("LuckPotion")
	end)
	LuckPotion10.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("LuckPotion")
	end)
	SuperLuckPotion.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("SuperLuckPotion")
	end)
	SuperLuckPotion10.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("SuperLuckPotion")
	end)
	MoneyPotion.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("MoneyPotion")
	end)
	MoneyPotion10.use.MouseButton1Click:Connect(function()
		PlayerBoostService:UsePlayerBoostData("MoneyPotion")
	end)
end

function StoreGuiController:MainUIMoney()
	self.OpenStoreDedault()
	FrameTrigger.OpenFram(frameName)
	task.spawn(function()
		task.wait(0.5)
		MoveS(970)
	end)
end
function StoreGuiController:MainUIGem()
	self.OpenStoreDedault()
	FrameTrigger.OpenFram(frameName)
	task.spawn(function()
		task.wait(0.5)
		MoveS(1300)
	end)
end

function StoreGuiController:KnitInit()
	StoreGuiService = Knit.GetService("StoreGuiService")
	GamePassService = Knit.GetService("GamePassService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function StoreGuiController:KnitStart()
	BtnOpen.MouseButton1Click:Connect(function()
		self.OpenStoreDedault()
		FrameTrigger.OpenFram(frameName)
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	BtnActive()

	StoreGuiService.ChangeBoostData:Connect(changeBoostData)
	StoreGuiService.ChangePassData:Connect(changePassData)
end

return StoreGuiController