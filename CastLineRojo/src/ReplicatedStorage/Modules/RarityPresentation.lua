local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RarityConfig = require(script.Parent.RarityConfig)

local RarityPresentation = {}
local warned: { [string]: boolean } = {}

local function findTemplate(name: string): UIGradient?
	local gui = ReplicatedStorage:FindFirstChild("Gui")
	local gradients = gui and gui:FindFirstChild("UIGradient")
	local template = gradients and gradients:FindFirstChild("UIGradient_" .. name)
	if template and template:IsA("UIGradient") then
		return template
	end
	if not warned[name] then
		warned[name] = true
		warn("[RarityPresentation] Missing gradient template: UIGradient_" .. name)
	end
	return nil
end

function RarityPresentation.GetTemplate(rarity: string?): UIGradient?
	local name = RarityConfig.Normalize(rarity)
	if name == "" then
		name = "Common"
	elseif name == "Mythic" then
		name = "Mythical"
	end
	local template = findTemplate(name)
	if template or name == "Common" then
		return template
	end
	return findTemplate("Common")
end

function RarityPresentation.GetColor(rarity: string?): Color3
	local template = RarityPresentation.GetTemplate(rarity)
	if not template then
		return Color3.new(1, 1, 1)
	end
	local keypoints = template.Color.Keypoints
	local previousKeypoint = keypoints[1]
	for index = 2, #keypoints do
		local nextKeypoint = keypoints[index]
		if nextKeypoint.Time == 0.5 then
			return nextKeypoint.Value
		elseif nextKeypoint.Time > 0.5 then
			local alpha = (0.5 - previousKeypoint.Time) / (nextKeypoint.Time - previousKeypoint.Time)
			return previousKeypoint.Value:Lerp(nextKeypoint.Value, alpha)
		end
		previousKeypoint = nextKeypoint
	end
	return previousKeypoint.Value
end

return RarityPresentation
