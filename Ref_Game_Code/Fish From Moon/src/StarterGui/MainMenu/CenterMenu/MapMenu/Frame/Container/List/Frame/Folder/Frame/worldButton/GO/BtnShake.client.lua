local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tween = game:GetService("TweenService")
local player = game:GetService('Players').LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local mouse = player:GetMouse()	

local btn = script.Parent

--鼠标进入时变大
local originalSize = btn.Size

btn.MouseEnter:Connect(function()
	local bigtween = Tween:Create(btn,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.new(originalSize.X.Scale*1.1,0,originalSize.Y.Scale*1.1,0)})
	bigtween:Play()
end)
--鼠标离开时变正常
btn.MouseLeave:Connect(function()
	local normalween = Tween:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = originalSize})
	normalween:Play()
end)

