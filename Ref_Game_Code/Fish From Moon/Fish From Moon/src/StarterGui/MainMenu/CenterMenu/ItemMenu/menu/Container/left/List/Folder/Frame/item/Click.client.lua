local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")   

local LocalPlayer = Players.LocalPlayer   

local Knit = require(ReplicatedStorage.Packages.Knit)

local button = script.Parent

local isCoolDown = false

button.MouseButton1Down:Connect(function()
	if not isCoolDown then
		isCoolDown = true
		local PlayerBoostService = Knit.GetService("PlayerBoostService")
		PlayerBoostService:UsePlayerBoostData(button.Name)
		task.wait(1)
		isCoolDown = false
	end
end)
