local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)

local MutationTitleUtil = {}

local RAINBOW_GRADIENT_NAME = "MutationRainbowGradient"
local RAINBOW_MARKER_NAME = "GUI_MovingRainbowGradient"

local function getMutationFrame(frame: Instance): GuiObject?
	local mutationFrame = frame:FindFirstChild("MutationFrame")
	return if mutationFrame and mutationFrame:IsA("GuiObject") then mutationFrame else nil
end

local function clearRainbowGradient(image: ImageLabel)
	local existing = image:FindFirstChild(RAINBOW_GRADIENT_NAME)
	if existing then
		existing:Destroy()
	end
end

function MutationTitleUtil.Hide(frame: Instance)
	local mutationFrame = getMutationFrame(frame)
	if mutationFrame then
		mutationFrame.Visible = false
	end
end

function MutationTitleUtil.Show(frame: Instance, value: unknown)
	local mutationId = MutationDataUtil.NormalizeMutationId(value)
	local mutationFrame = getMutationFrame(frame)
	if not mutationFrame then
		return
	end
	local image = mutationFrame:FindFirstChild("MutationImage")
	if not mutationId or not image or not image:IsA("ImageLabel") then
		mutationFrame.Visible = false
		return
	end

	local config = MutationDataUtil.GetConfig(mutationId)
	clearRainbowGradient(image)
	image.Image = if config and typeof(config.Icon) == "string" then config.Icon else ""
	image.ImageColor3 = MutationDataUtil.GetLabelColor(mutationId)
	image.Visible = true
	mutationFrame.Visible = true

	if mutationId ~= "Rainbow" then
		return
	end
	local gui = ReplicatedStorage:FindFirstChild("Gui")
	local gradients = gui and gui:FindFirstChild("UIGradient")
	local template = gradients and gradients:FindFirstChild("UIGradient_Mutation_Rainbow")
	if template and template:IsA("UIGradient") then
		local gradient = template:Clone()
		gradient.Name = RAINBOW_GRADIENT_NAME
		gradient.Enabled = true
		gradient.Parent = image
		local marker = Instance.new("Configuration")
		marker.Name = RAINBOW_MARKER_NAME
		marker.Parent = gradient
		-- Titles are usually assembled while unparented; tag after the caller mounts the clone.
		task.defer(function()
			if marker.Parent and marker:IsDescendantOf(game) then
				CollectionService:AddTag(marker, "LocalScriptAttach")
			end
		end)
	end
end

return MutationTitleUtil
