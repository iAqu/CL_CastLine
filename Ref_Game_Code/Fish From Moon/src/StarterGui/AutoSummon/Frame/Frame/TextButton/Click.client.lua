local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local button = script.Parent

button.MouseButton1Down:Connect(function()
	LocalPlayer.PlayerGui:WaitForChild("AutoSummon").Enabled=false
	LocalPlayer.PlayerGui:WaitForChild("AutoSummon").Auto.Value=false
end)