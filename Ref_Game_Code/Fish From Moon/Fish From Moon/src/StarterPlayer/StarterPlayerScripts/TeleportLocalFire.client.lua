local ReplicatedStorage = game:GetService("ReplicatedStorage")

local targetPlaceID = 102251914603434

local teleportEvent = ReplicatedStorage:WaitForChild("TeleportEvent")

local player = game:GetService("Players").LocalPlayer

local isT=false

game.Players.LocalPlayer.Idled:Connect(function(time)
	print("玩家已闲置了 " .. time .. " 秒")
	if time>=900 and not isT then
	--if time>=180 and not isT then
		isT=true
		teleportEvent:FireServer(targetPlaceID)
	end
end)