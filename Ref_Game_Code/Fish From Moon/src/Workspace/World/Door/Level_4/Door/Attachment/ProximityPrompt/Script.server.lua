local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit) 

local player = game:GetService("Players").LocalPlayer

local proximityPrompt=script.Parent

local cd=false
proximityPrompt.Triggered:Connect(function(player)
	if not cd then
		cd=true
		if not player then
			return
		end
		if not player.Character then
			return
		end
		local id=script.Parent.Value.Value
		local MapService = Knit.GetService("MapService")
		MapService:BuyMap(id)
		task.wait(2)
		cd=false
	end
end)