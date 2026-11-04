local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit) 
local button = script.Parent

local player = Players.LocalPlayer

button.MouseButton1Click:Connect(function()  --点击购买100wins
	
	local mapId = script.Parent.Parent.MapId.Value
	local MapService = Knit.GetService("MapService")
	
	MapService:GoMap(mapId):andThen(function(result,message)
		if result then
			--TOOD 发送消息
			player:SetAttribute("InWord",mapId)
		end
	end)
end)