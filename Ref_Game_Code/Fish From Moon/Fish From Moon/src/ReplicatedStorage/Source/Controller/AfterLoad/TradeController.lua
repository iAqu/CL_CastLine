--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local FrameTrigger=require(LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local PlayerResourceService

local MainGuiController

----GUI
local BtnOpenList = LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Left.Holder.trade.btn

local TradeoutMenu = LocalPlayer.PlayerGui:WaitForChild("Trade").CenterMenu.TradeoutMenu
local TradeoutMenuFrame = TradeoutMenu.Menu.Menu
local TradeoutMenuContainer = TradeoutMenuFrame.ScrollingFrame.Frame
local TradeoutMenuTemplate = TradeoutMenuContainer.cloneFrame

local BtnClose = TradeoutMenu.Menu.Exit.TextButton
	
local Remotes=ReplicatedStorage:WaitForChild("Remotes")

local TradeController = Knit.CreateController { Name = "TradeController" }

local function changeTradeoutMenuData(player:Player)
	if player == LocalPlayer then
		return
	end
	local function getData(playerResourceData)
		if tonumber(playerResourceData.maxWorld) < 3 then
			return
		end
		if not playerResourceData.isTrade then
			return
		end
		local clone=TradeoutMenuTemplate:Clone()
		clone.Parent=TradeoutMenuContainer

		clone.Name=player.UserId
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size60x60
		local success, ret = pcall(function()
			return game:GetService("Players"):GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
		end)
		clone.send.ImageLabel.Image=(success and ret) or ""
		clone.send.nameFrame.disName.Text=player.DisplayName
		clone.send.nameFrame.realName.Text="@"..player.Name
		clone.Visible=true

		clone.send.ImageButton.MouseButton1Click:Connect(function()		
			TradeoutMenu.Visible=false

			local result=Remotes.SendTradeRequest:InvokeServer(player.UserId)
			if result then
				clone.send.ImageButton.Visible=false
				clone.send.Unable.Visible=true

				task.delay(15,function()
					clone.send.Unable.Visible=false
					clone.send.ImageButton.Visible=true
				end)
			end

		end)
	end
	PlayerResourceService:GetOtherPlayerResourceData(player):andThen(getData)
end

local function checkMaxWorld()
	local function getData(playerResourceData)
		local maxWorld=playerResourceData.maxWorld
		if tonumber(maxWorld) >= 3 then
			FrameTrigger.CloseAllFrams()
			LocalPlayer.PlayerGui:WaitForChild("Trade").CenterMenu.TradeoutMenu.Visible=true
		else
			MainGuiController:ShowMessage("Need World 3!")
		end
	end
	PlayerResourceService:GetPlayerResourceData(LocalPlayer):andThen(getData)
end

function TradeController:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function TradeController:KnitStart()

	for _,player in pairs(Players:GetChildren()) do
		changeTradeoutMenuData(player)
	end
	Players.PlayerAdded:Connect(function(player)
		changeTradeoutMenuData(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		local playerTemplate=TradeoutMenuContainer:FindFirstChild(player.UserId)
		if playerTemplate then
			playerTemplate:Destroy()
		end
	end)

	BtnOpenList.MouseButton1Click:Connect(function()
		checkMaxWorld()
	end)
	BtnClose.MouseButton1Click:Connect(function()
		TradeoutMenu.Visible=false
	end)
end

return TradeController