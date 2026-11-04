local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tween = game:GetService("TweenService")
local player = game:GetService('Players').LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local mouse = player:GetMouse()	

local frame = script.Parent

for i, v in pairs(frame:GetDescendants()) do
	if (v:IsA("ImageButton") or v:IsA("TextButton")) and v:FindFirstChild("Shake") then
		--鼠标进入时变大
		local originalSize = v.Size
		v.MouseEnter:Connect(function()
			local bigtween = Tween:Create(v,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.new(originalSize.X.Scale*1.1,0,originalSize.Y.Scale*1.1,0)})
			bigtween:Play()
		end)
		--鼠标离开时变正常
		v.MouseLeave:Connect(function()
			local normalween = Tween:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = originalSize})
			normalween:Play()
		end)
		--鼠标点击时变小
		v.MouseButton1Down:Connect(function()
			local smallween = Tween:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.new(originalSize.X.Scale*0.9,0,originalSize.Y.Scale*0.9,0)})
			smallween:Play()
		end)
	end
end

