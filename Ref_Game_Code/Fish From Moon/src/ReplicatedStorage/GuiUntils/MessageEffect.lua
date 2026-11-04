local MessageEffect = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local commonMessage = player.PlayerGui:WaitForChild("CommonMessage").Message
local messageFolder = commonMessage.Folder.Frame

local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)

local function animateText(guiObject, targetValue)
	local startValue = 0
	local duration = 1

	local numberValue = Instance.new("NumberValue")
	numberValue.Value = startValue

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(numberValue, tweenInfo, { Value = targetValue })

	numberValue.Changed:Connect(function(newValue)
		guiObject.Text = NumberFormat.AbbreviateNumber(newValue,2)
	end)

	tween:Play()

	tween.Completed:Connect(function()
		numberValue:Destroy()
	end)
end

function MessageEffect:ShowMessage(messageType,num,text,img)
	local guiObject = messageFolder:FindFirstChild(messageType):Clone()
	local targetValue = num
	if tostring(messageType) == "warning" then
		guiObject.txt.TextLabel.Text = text
	elseif tostring(messageType) == "Enchant" then
		guiObject.txt.TextLabel.Text = text
		guiObject.picture.ImageLabel.Image = img
	else
		animateText(guiObject.number.TextLabel, targetValue)
	end
	guiObject.Parent = commonMessage
	task.delay(3,function()
		guiObject:Destroy()
	end)
end

return MessageEffect