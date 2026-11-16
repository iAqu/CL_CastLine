local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)

local FishIconPresentation = {}
local RAINBOW_GRADIENT_NAME = "BackpackMutationRainbowGradient"

function FishIconPresentation.ApplyMutation(icon: ImageLabel, mutationId: string?)
	mutationId = MutationDataUtil.NormalizeMutationId(mutationId)
	icon.ImageColor3 = MutationDataUtil.GetLabelColor(mutationId)
	local existing = icon:FindFirstChild(RAINBOW_GRADIENT_NAME)
	if mutationId ~= "Rainbow" then
		if existing then
			existing:Destroy()
		end
		return
	end
	if existing then
		return
	end
	local gui = ReplicatedStorage:FindFirstChild("Gui")
	local gradients = gui and gui:FindFirstChild("UIGradient")
	local template = gradients and gradients:FindFirstChild("UIGradient_Mutation_Rainbow")
	if not template or not template:IsA("UIGradient") then
		warn("FishIconPresentation: rainbow gradient template is missing")
		return
	end
	local gradient = template:Clone()
	gradient.Name = RAINBOW_GRADIENT_NAME
	gradient.Enabled = true
	local marker = Instance.new("Configuration")
	marker.Name = "GUI_MovingRainbowGradient"
	-- Drag previews keep the gradient, without copying its live script reference.
	marker.Archivable = false
	marker.Parent = gradient
	gradient.Parent = icon
	task.defer(function()
		if marker.Parent and marker:IsDescendantOf(game) then
			CollectionService:AddTag(marker, "LocalScriptAttach")
		end
	end)
end

return FishIconPresentation
