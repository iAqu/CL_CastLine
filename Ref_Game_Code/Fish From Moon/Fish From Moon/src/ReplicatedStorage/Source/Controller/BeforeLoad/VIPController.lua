local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local TimeFormat = require(ReplicatedStorage.Source.Utils.TimeFormat)
local Monetization = require(ReplicatedStorage.Config.Monetization)

local GamePassService
local PlayerService
local VIPService

local MainGuiController

local BillboardGui=game.Workspace.Lobby.LuckArea.CheckArea:WaitForChild("VIP").VIP.BillboardGui
local timeCd=BillboardGui.Frame.Time

local CD

local VIPController = Knit.CreateController { Name = "VIPController" }

local function CheckVIP()
	GamePassService:IsPlayerHaveGamePass("VIP"):andThen(function(result)
		if result then
			player:SetAttribute("VIP",true)
		else
			player:SetAttribute("VIP",false)
		end
	end)
end

function VIPController:InitVIPTime()
	local function getData(data,isVIP)
		local Time = data.VIPTime

		if isVIP then
			---领过宠物了，刷新时间领取奖励
			timeCd.Visible=true
			if game.Workspace:GetServerTimeNow() - Time < 24*60*60 then
				CD =  Time + 24*60*60 - game.Workspace:GetServerTimeNow()
			else
				timeCd.Text = "Claim!"
			end
		else
			----没有领取，打开界面
			timeCd.Visible=false
		end 
	end
	VIPService:GetPlayerAndPassData(player):andThen(getData)
end
--改变VIP界面展示
local function changeVIP()
	VIPController:InitVIPTime()
end

function VIPController:OpenVIPDedault()
	local function getData(data,isVIP)
		if isVIP then
			VIPService:GetVIPRewards():andThen(function(result)
				if result then
					MainGuiController:ShowMessage("You get VIP Gift!")
				else
					MainGuiController:ShowMessage("Time is insufficient!")
				end
			end)
		else
			MarketService:PromptGamePassPurchase(player,Monetization.Gamepasses.VIP.Id)
		end
	end
	VIPService:GetPlayerAndPassData(player):andThen(getData)
end

function VIPController:KnitInit()
	GamePassService = Knit.GetService("GamePassService")
	PlayerService = Knit.GetService("PlayerService")
	VIPService = Knit.GetService("VIPService")

	MainGuiController =Knit.GetController("MainGuiController")
end

function VIPController:KnitStart()
	
	self.InitVIPTime()
	
	task.spawn(function()			  
		while true do
			wait(1)
			if CD then
				if CD > 0 then
					CD = CD - 1
					timeCd.Text = "(" .. TimeFormat.HHMMSS(CD) .. ")"
					if CD <= 0 then
						timeCd.Text = "Claim!"
					end
				else
					timeCd.Text = "Claim!"
				end
			end
		end
	end)
	
	VIPService.ChangePassVIP:Connect(changeVIP)
end

return VIPController
