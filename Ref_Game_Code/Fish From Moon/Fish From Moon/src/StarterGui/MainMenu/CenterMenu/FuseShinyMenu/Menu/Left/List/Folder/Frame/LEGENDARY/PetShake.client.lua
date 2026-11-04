local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService('Players')

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local btn = script.Parent

local img=btn.Frame.imgPet

local originalSize = img.Size

btn.MouseButton1Click:Connect(function()
	local FishRodFuseController = Knit.GetController("FishRodFuseController")
	FishRodFuseController:SelectShinyFishRod(btn.Name)
end)

btn.MouseEnter:Connect(function()
	local bigtween = TweenService:Create(img,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.new(originalSize.X.Scale*1.4,0,originalSize.Y.Scale*1.4,0)})
	bigtween:Play()
end)
btn.MouseLeave:Connect(function()
	local normalween = TweenService:Create(img,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = originalSize})
	normalween:Play()
end)