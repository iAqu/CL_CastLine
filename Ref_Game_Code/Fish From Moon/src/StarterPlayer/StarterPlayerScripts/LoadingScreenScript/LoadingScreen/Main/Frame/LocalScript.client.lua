
-- Create a basic loading screen
local screenGui = script.Parent
local TweenService = game:GetService("TweenService")
local Background = screenGui
local Fade = Background:WaitForChild("Fade")
local Texture = screenGui:WaitForChild("Texture")
local Logo = Background:WaitForChild("Logo")

Texture.Position = UDim2.new(1, 0, 1, 0)
coroutine.wrap(function()
	Texture:TweenPosition(UDim2.fromScale(2, 2), "Out", "Linear", 20, true)
	task.wait(1)
	TweenService:Create(Texture, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
		BackgroundTransparency = 1, 
		ImageTransparency = 1
	}):Play()
	Logo:TweenPosition(UDim2.fromScale(0.5, -0.5), "Out", "Quad", 0.3, true)
	wait(0.3)

	TweenService:Create(Background, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(Background.Fade, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(1)
	screenGui:Destroy()
	script:Destroy()
end)()