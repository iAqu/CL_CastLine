local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer

local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local Knit = require(ReplicatedStorage.Packages.Knit)

local button = script.Parent

local frameName="PetBagMenu"

button.MouseButton1Down:Connect(function()

	FrameTrigger.OpenFram(frameName)

	local PetBagController = Knit.GetController("PetBagController")
	PetBagController:OpenPetBagDedault()

	----隐藏红点
	button.Lbl.Visible = false
	
end)