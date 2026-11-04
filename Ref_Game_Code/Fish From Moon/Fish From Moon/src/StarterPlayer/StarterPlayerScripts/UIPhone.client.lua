local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local Players=game:GetService("Players")

local player=Players.LocalPlayer
local PlayerGui=player.PlayerGui

if UserInputService.TouchEnabled then
	local MobileUI = PlayerGui:WaitForChild("PhoneTouch")
	MobileUI.Enabled=true
	PlayerGui:WaitForChild("MainUi").MainHud.BottomTool.menuout.Open.Btn.Lbl.Visible = false
else
	local MobileUI = PlayerGui:WaitForChild("PhoneTouch")
	MobileUI.Enabled=false
	PlayerGui:WaitForChild("MainUi").MainHud.BottomTool.menuout.Open.Btn.Lbl.Visible = true
end