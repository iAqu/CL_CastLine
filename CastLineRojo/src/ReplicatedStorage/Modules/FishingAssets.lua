local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishingAssets = {}

function FishingAssets.GetEgg(name: string): Model?
	local models = ReplicatedStorage:FindFirstChild("Models")
	local folder = models and models:FindFirstChild("Eggs")
	local model = folder and folder:FindFirstChild(name)
	return if model and model:IsA("Model") and model.PrimaryPart then model else nil
end

local function getFolder(name: string): Instance?
	local models = ReplicatedStorage:FindFirstChild("Models")
	return models and models:FindFirstChild(name)
end

function FishingAssets.GetRod(name: string): Tool?
	local folder = getFolder("FishRod")
	local tool = folder and folder:FindFirstChild(name)
	local handle = tool and tool:FindFirstChild("Handle")
	return if tool and tool:IsA("Tool") and handle and handle:IsA("BasePart") then tool else nil
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

function FishingAssets.GetBait(name: string?): (BasePart?, Model?)
	local folder = getFolder("FishBait")
	if not folder then
		return nil, nil
	end
	if name == nil then
		local model = folder:FindFirstChild("DefaultBait")
		if model and model:IsA("Model") and model.PrimaryPart then
			return model.PrimaryPart, model
		end
		return nil, nil
	end
	local group = folder:FindFirstChild(name)
	local bait = group and group:FindFirstChild("1")
	return if bait and bait:IsA("BasePart") then bait else nil, nil
end

return FishingAssets
