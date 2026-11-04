local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local Knit = require(ReplicatedStorage.Packages.Knit)

local MusicController
local MainGuiController

local CodeService
local SettingService
local PlayerResourceService

---GUI
local SettingMenu = player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.SettingMenu

local BtnOpen=player.PlayerGui:WaitForChild("MainUi",5).MainHud.Right.daily.Setting
local BtnClose=SettingMenu.Menu.Exit.TextButton
----点On从On变Off
-----背景音乐开关
local OnBgm=SettingMenu.Menu.Container.ScrollingFrame.Bgm.On
local OffBgm=SettingMenu.Menu.Container.ScrollingFrame.Bgm.Off
-----音效开关
local OnEffect=SettingMenu.Menu.Container.ScrollingFrame.Effect.On
local OffEffect=SettingMenu.Menu.Container.ScrollingFrame.Effect.Off
-----交易
local OnTrade=SettingMenu.Menu.Container.ScrollingFrame.Trade.On
local OffTrade=SettingMenu.Menu.Container.ScrollingFrame.Trade.Off
----使用Code
local UseCode=SettingMenu.Menu.Container.ScrollingFrame.code.RewardBG.OK

local frameName="SettingMenu"

local SettingController = Knit.CreateController { Name = "SettingController" }

local function checkTrade()
	local function getData(playerResourceData)
		if playerResourceData.isTrade then
			OffTrade.Visible=false
			OnTrade.Visible=true
		else
			OnTrade.Visible=false
			OffTrade.Visible=true
		end
	end
	PlayerResourceService:GetPlayerResourceData(player):andThen(getData)
end

local function changeTrade(isTrade)
	SettingService:ChangeTrade(isTrade):andThen(function(result,message)
		if result then
			checkTrade()
		else
			MainGuiController.ShowMessage(message)
		end
	end)
end

local lock=false
function SettingController:UseCode()
	if lock then
		return
	end
	if not lock then
		lock=true
		local cdk = SettingMenu.Menu.Container.ScrollingFrame.code.RewardBG.Box.RewardInput.Text
		CodeService:UseCdk(cdk):andThen(function(result,message)
			if result then
				lock=false
				MainGuiController:ShowMessage(message)
			else
				MainGuiController:ShowMessage(message)
				lock=false
			end
		end)
	end
end

function SettingController:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	SettingService = Knit.GetService("SettingService")
	CodeService=Knit.GetService("CodeService")
	
	MainGuiController =Knit.GetController("MainGuiController")
	MusicController=Knit.GetController("MusicController")
end

function SettingController:KnitStart()

	BtnOpen.MouseButton1Click:Connect(function()
		checkTrade()
		FrameTrigger.OpenFram(frameName)
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	OnBgm.MouseButton1Click:Connect(function()
		MusicController:OnToOffBgm()
	end)
	OffBgm.MouseButton1Click:Connect(function()
		MusicController:OffToOnBgm()
	end)
	OnEffect.MouseButton1Click:Connect(function()
		MusicController:OnToOffEff()
	end)
	OffEffect.MouseButton1Click:Connect(function()
		MusicController:OffToOnEff()
	end)
	
	OnTrade.MouseButton1Click:Connect(function()
		changeTrade(false)
	end)
	OffTrade.MouseButton1Click:Connect(function()
		changeTrade(true)
	end)
	
	UseCode.MouseButton1Click:Connect(function()
		self.UseCode()
	end)

end

return SettingController
