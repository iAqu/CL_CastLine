--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local button = script.Parent

button.MouseEnter:Connect(function()
	button.tit.Visible=true
end)

button.MouseLeave:Connect(function()
	button.tit.Visible=false
end)