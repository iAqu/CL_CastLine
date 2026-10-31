local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IndexItemViewport = {}

local VIEWPORT_NAME = "IndexModelPreview"
local CAMERA_FIELD_OF_VIEW = 70
local CAMERA_FIT_SINE = 0.7002075382097097
local CAMERA_PADDING = 1.4
local MODEL_ROTATION = CFrame.Angles(math.rad(-15), math.rad(25), 0)
local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)

local function clearPreview(parent: Instance)
	local preview = parent:FindFirstChild(VIEWPORT_NAME)
	if preview then
		preview:Destroy()
	end
end

local function prepareModel(model: Model): boolean
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Script")
			or descendant:IsA("LocalScript")
			or descendant:IsA("ModuleScript")
			or descendant:IsA("Sound")
			or descendant:IsA("ParticleEmitter")
			or descendant:IsA("Trail")
			or descendant:IsA("Beam") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
	return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
end

function IndexItemViewport.Show(parent: GuiObject, icon: ImageLabel, modelName: string, discovered: boolean): boolean
	clearPreview(parent)
	local models = ReplicatedStorage:FindFirstChild("Models")
	local items = models and models:FindFirstChild("Items")
	local template = items and items:FindFirstChild(modelName)
	if not template or not template:IsA("Model") then
		return false
	end

	local authoredRotation = template:GetPivot().Rotation
	local previewModel = template:Clone()
	if not prepareModel(previewModel) then
		previewModel:Destroy()
		return false
	end
	previewModel:PivotTo(MODEL_ROTATION * FRONT_FACING_ROTATION * authoredRotation)

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = VIEWPORT_NAME
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.AnchorPoint = icon.AnchorPoint
	viewport.Position = icon.Position
	viewport.Size = icon.Size
	viewport.ZIndex = icon.ZIndex
	viewport.Active = false
	viewport.Ambient = if discovered then Color3.fromRGB(140, 140, 140) else Color3.new()
	viewport.LightColor = if discovered then Color3.new(1, 1, 1) else Color3.new()
	viewport.ImageColor3 = if discovered then Color3.new(1, 1, 1) else Color3.fromRGB(20, 20, 20)

	previewModel.Parent = viewport
	local boundsCFrame, boundsSize = previewModel:GetBoundingBox()
	local radius = math.max(boundsSize.X, boundsSize.Y, boundsSize.Z) * 0.5
	local distance = radius / CAMERA_FIT_SINE * CAMERA_PADDING
	local camera = Instance.new("Camera")
	camera.FieldOfView = CAMERA_FIELD_OF_VIEW
	camera.CFrame = CFrame.new(boundsCFrame.Position + Vector3.new(0, 0, distance), boundsCFrame.Position)
	camera.Parent = viewport
	viewport.CurrentCamera = camera
	viewport.Parent = parent
	icon.Visible = false
	return true
end

return IndexItemViewport
