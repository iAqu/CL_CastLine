local ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local player:Player = game:GetService("Players").LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local loadingScreen = script:WaitForChild("LoadingScreen")

local clonedLoadingScreen = loadingScreen:Clone()

clonedLoadingScreen.Parent = playerGui

local assets = {}
assets=ReplicatedStorage:GetDescendants()

--背景图片
local Bar = clonedLoadingScreen:WaitForChild("Main",5):WaitForChild("Frame"):WaitForChild("BarContainer"):WaitForChild("Bar"):WaitForChild("Bar")

----背景动起来
--local BG = clonedLoadingScreen:WaitForChild("Main",5):WaitForChild("Frame"):WaitForChild("Texture")
--BG.Position = UDim2.new(1, 0, 1, 0)
--BG:TweenPosition(UDim2.fromScale(2, 2), "Out", "Linear", 20, true)
--tweenService:Create(BG,
--	TweenInfo.new(20,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,true),
--	{Position = UDim2.new(BG.Position.X.Scale,BG.Position.X.Offset +1000,BG.Position.Y.Scale,BG.Position.Y.Offset - 1000)}
--):Play()

clonedLoadingScreen.Enabled = true

for i = 1,#assets do
	local asset = assets[i]
	local percentage = math.round( i / #assets * 100)

	clonedLoadingScreen:WaitForChild("Main",5):WaitForChild("Frame"):WaitForChild("PercentageText").Text = percentage.."%"
	clonedLoadingScreen:WaitForChild("Main",5):WaitForChild("Frame"):WaitForChild("AmountText").Text =  i .. "/" ..#assets
	clonedLoadingScreen:WaitForChild("Main",5):WaitForChild("Frame"):WaitForChild("ObjectNameText").Text = "Loading..."

	tweenService:Create(Bar,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = UDim2.fromScale(percentage/100,1)}):Play()

	if i % 50 == 0 then
		task.wait()
	end

end

task.wait()

clonedLoadingScreen.Enabled = false
clonedLoadingScreen.Parent = nil
clonedLoadingScreen:Destroy()