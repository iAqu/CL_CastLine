local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishingAssets = {}

local function getFolder(name: string): Instance?
	local models = ReplicatedStorage:FindFirstChild("Models")
	return models and models:FindFirstChild(name)
end

function FishingAssets.GetFish(name: string): Model?
	local folder = getFolder("Fish")
	if not folder then
		return nil
	end
	local model = folder:FindFirstChild(name)
	if not model and name:match("^Elder Fish %d+$") then
		model = folder:FindFirstChild("Elder Fish")
	end
	if model and model:IsA("Model") and model.PrimaryPart then
		return model
	end
	return nil
end

function FishingAssets.GetBait(name: string): BasePart?
	local folder = getFolder("FishBait")
	local group = folder and folder:FindFirstChild(name)
	local bait = group and group:FindFirstChild("1")
	return if bait and bait:IsA("BasePart") then bait else nil
end

return FishingAssets
