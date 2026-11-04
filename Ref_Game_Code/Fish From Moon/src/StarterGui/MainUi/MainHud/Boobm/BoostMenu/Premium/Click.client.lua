local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Tween = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Players = game:GetService("Players")
local player = Players.LocalPlayer 
local mouse = player:GetMouse()	

local button = script.Parent
local showPrompt = true

button.Activated:Connect(function()
	if not showPrompt then return end
	if player.MembershipType == Enum.MembershipType.Premium then
		local MainGuiController = Knit.GetController("MainGuiController")
		MainGuiController:ShowMessage("You are already an honorable Premium member.")
		local PlayerService = Knit.GetService("PlayerService")
		PlayerService:ChangePlayIsPremium(true)
	else
		showPrompt = false
		delay(1, function()
			showPrompt = true
		end)
		MarketplaceService:PromptPremiumPurchase(player)
	end
end)

--鼠标进入时显示
button.MouseEnter:Connect(function()
	button.tit.Visible=true
end)

--鼠标离开时消失
button.MouseLeave:Connect(function()
	button.tit.Visible=false
end)
