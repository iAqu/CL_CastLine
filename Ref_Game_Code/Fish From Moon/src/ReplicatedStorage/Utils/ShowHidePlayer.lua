local ShowHidePlayer = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to show models
function ShowHidePlayer.showModels()
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local character = otherPlayer.Character
			if character then
				character.Parent=game.workspace
			end
		end
	end
end

-- Function to hide models
function ShowHidePlayer.hideModels()
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local character = otherPlayer.Character
			if character then
				character.Parent=game.ReplicatedStorage.HidePlayer
			end
		end
	end
end

return ShowHidePlayer
