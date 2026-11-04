local FrameTrigger = {}
----------放到mainMenu下面

local TweenService=game:GetService("TweenService")
local frames=script.Parent:WaitForChild("CenterMenu")

local frameOpenSpeed=0.2   ------速度
local frameOpenEasingStyle=Enum.EasingStyle.Back   ----风格
local frameOpenEasingDirection=Enum.EasingDirection.Out

local frameCloseSpeed=0.1   ------速度
local frameClosingEasingStyle=Enum.EasingStyle.Sine   ----风格
local frameClosingEasingDirection=Enum.EasingDirection.Out

function FrameTrigger.CloseFram(frameName)
	local frame=frames:FindFirstChild(frameName)
	if frame then
		game.Lighting.Blur.Enabled=false
		local closeTween=TweenService:Create(frame,TweenInfo.new(frameCloseSpeed,frameClosingEasingStyle,frameClosingEasingDirection),{Size=UDim2.fromScale(0,0)})

		closeTween:Play()
		closeTween.Completed:Connect(function()
			frame.Visible=false
		end)
	end
end

function FrameTrigger.CloseAllFrams()
	for _,frame in pairs(frames:GetChildren()) do
		if frame:IsA("Frame") then
			coroutine.wrap(FrameTrigger.CloseFram)(frame.Name)
		end
	end
end

function FrameTrigger.OpenFram(frameName)
	
	local frame=frames:FindFirstChild(frameName)
	
	if not frame.Visible then
		
		FrameTrigger.CloseAllFrams()
		
		game.Lighting.Blur.Enabled=true
		frame.Size=UDim2.fromScale(0,0)
		task.wait(frameCloseSpeed + 0.1)
		frame.Visible=true
		
		local openTween=TweenService:Create(frame,TweenInfo.new(frameOpenSpeed,frameOpenEasingStyle,frameOpenEasingDirection),{Size=UDim2.fromScale(1,1)})
		
		openTween:Play()
	else
		FrameTrigger.CloseAllFrams()
	end
end

return FrameTrigger
