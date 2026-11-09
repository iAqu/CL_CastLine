local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)

local BackpackItemViewport = {}

local VIEWPORT_NAME = "ItemModelPreview"
local CAMERA_FIELD_OF_VIEW = 70
local MODEL_ROTATION = CFrame.Angles(math.rad(15), math.rad(25), 0)
local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)
-- Matches Mine a Mountain's camera-fit formula, with a small consistent margin.
local CAMERA_FIT_SINE = 0.7002075382097097
local CAMERA_PADDING = 1.4

local function clearPreview(slotFrame: TextButton)
	local preview = slotFrame:FindFirstChild(VIEWPORT_NAME)
	if preview then
		preview:Destroy()
	end
end

local function restoreIcon(slotFrame: TextButton)
	local icon = slotFrame:FindFirstChild("Icon")
	if icon and icon:IsA("ImageLabel") then
		icon.Visible = true
	end
end

local function removeNonVisualDescendants(model: Model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Script")
			or descendant:IsA("LocalScript")
			or descendant:IsA("ModuleScript")
			or descendant:IsA("Sound")
			or descendant:IsA("ParticleEmitter")
			or descendant:IsA("Trail")
			or descendant:IsA("Beam")
			or descendant:IsA("Fire")
			or descendant:IsA("Smoke")
			or descendant:IsA("Sparkles") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
end

local function getAuthoredRotation(tool: Tool): CFrame
	local itemId = tool:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)
	local item = if typeof(itemId) == "string" then FishInventoryData[itemId] else nil
	local template = item and FishingAssets.GetFish(item.Model)
	if template and template:IsA("Model") then
		-- The Tool's current rotation can include the character's equipped pose.
		return template:GetPivot().Rotation
	end
	return CFrame.identity
end

local function cloneToolVisual(tool: Tool): Model?
	-- Tool metadata can replicate before its Handle/model reaches the client.
	-- Leave the slot's normal icon in place until the visual is available; the
	-- backpack listener will request another render when a BasePart arrives.
	if not tool:FindFirstChildWhichIsA("BasePart", true) then
		return nil
	end

	local previewModel = Instance.new("Model")
	previewModel.Name = "PreviewModel"

	for _, child in ipairs(tool:GetChildren()) do
		if child:IsA("BasePart") or child:IsA("Model") then
			local ok, visualClone = pcall(function()
				return child:Clone()
			end)
			if not ok or not visualClone then
				previewModel:Destroy()
				warn("BackpackItemViewport: failed to clone visual for", tool.Name)
				return nil
			end
			visualClone.Parent = previewModel
		end
	end

	if not previewModel:FindFirstChildWhichIsA("BasePart", true) then
		previewModel:Destroy()
		warn("BackpackItemViewport: failed to copy item tool BasePart", tool.Name)
		return nil
	end

	removeNonVisualDescendants(previewModel)
	local visualPivotOffset = tool:GetAttribute(ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE)
	local handle = previewModel:FindFirstChild("Handle")
	if typeof(visualPivotOffset) == "CFrame" and handle and handle:IsA("BasePart") then
		handle.PivotOffset = visualPivotOffset
		previewModel.PrimaryPart = handle
	end
	local authoredRotation = getAuthoredRotation(tool)
	previewModel:PivotTo(MODEL_ROTATION * FRONT_FACING_ROTATION * authoredRotation)
	return previewModel
end

function BackpackItemViewport.Clear(slotFrame: TextButton)
	clearPreview(slotFrame)
	restoreIcon(slotFrame)
end

function BackpackItemViewport.Show(slotFrame: TextButton, tool: Tool): boolean
	BackpackItemViewport.Clear(slotFrame)
	if not ItemToolUtil.IsItemTool(tool) then
		return false
	end

	local icon = slotFrame:FindFirstChild("Icon")
	if not icon or not icon:IsA("ImageLabel") then
		warn("BackpackItemViewport: backpack slot has no ImageLabel Icon")
		return false
	end

	local previewModel = cloneToolVisual(tool)
	if not previewModel then
		return false
	end

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = VIEWPORT_NAME
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.AnchorPoint = icon.AnchorPoint
	viewport.Position = icon.Position
	viewport.Size = icon.Size
	viewport.ZIndex = icon.ZIndex
	viewport.Ambient = Color3.fromRGB(190, 190, 190)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)
	viewport.Active = false

	previewModel.Parent = viewport
	local boundsCFrame, boundsSize = previewModel:GetBoundingBox()
	local radius = math.max(boundsSize.X, boundsSize.Y, boundsSize.Z) * 0.5
	local distance = radius / CAMERA_FIT_SINE * CAMERA_PADDING
	local camera = Instance.new("Camera")
	camera.FieldOfView = CAMERA_FIELD_OF_VIEW
	camera.CFrame = CFrame.new(boundsCFrame.Position + Vector3.new(0, 0, distance), boundsCFrame.Position)
	camera.Parent = viewport
	viewport.CurrentCamera = camera
	viewport.Parent = slotFrame

	icon.Visible = false
	return true
end

return BackpackItemViewport
