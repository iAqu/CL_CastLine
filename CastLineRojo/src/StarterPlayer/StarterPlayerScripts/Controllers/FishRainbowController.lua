local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)

local FishRainbowController = Knit.CreateController({ Name = "FishRainbowController" })
local HUE_SPEED = 0.5
local COLOR_DISTANCE = 160
local DISTANCE_CHECK_INTERVAL = 0.25
local TAG = MutationVisualUtil.RAINBOW_TAG
local random = Random.new()

local watched = {}
local inWorld = {}
local nearby = {}
local nextDistanceCheck = 0
local heartbeat: RBXScriptConnection? = nil

local function restore(mesh: MeshPart, original)
	if original.surface then
		if original.surface.Parent == mesh then
			original.surface.Color = original.color
		end
	else
		mesh.Color = original.color
		mesh.Reflectance = original.reflectance
	end
end

local function refreshMeshes(root: Instance, state)
	for mesh, original in pairs(state.meshes) do
		if not mesh:IsDescendantOf(root) or mesh:FindFirstChildOfClass("SurfaceAppearance") ~= original.surface then
			restore(mesh, original)
			state.meshes[mesh] = nil
		end
	end
	for _, mesh in root:GetDescendants() do
		if mesh:IsA("MeshPart") and mesh.Transparency < 1 and mesh.Name ~= "CameraPart" and not state.meshes[mesh] then
			local surface = mesh:FindFirstChildOfClass("SurfaceAppearance")
			local originalHue, _, brightness = mesh.Color:ToHSV()
			state.meshes[mesh] = {
				surface = surface,
				color = if surface then surface.Color else mesh.Color,
				reflectance = mesh.Reflectance,
				brightness = math.clamp(brightness + (originalHue - 0.5) * 0.5, 0.1, 1),
			}
			if not surface then
				mesh.Reflectance = 0.1
			end
		end
	end
	state.dirty = false
end

local function updateColors()
	local now = Workspace:GetServerTimeNow()
	if now >= nextDistanceCheck then
		nextDistanceCheck = now + DISTANCE_CHECK_INTERVAL
		table.clear(nearby)
		local camera = Workspace.CurrentCamera
		if camera then
			local position = camera.CFrame.Position
			for root, state in inWorld do
				local part = if root:IsA("PVInstance") then root else root:FindFirstChildWhichIsA("BasePart", true)
				if part and (part:GetPivot().Position - position).Magnitude <= COLOR_DISTANCE then
					nearby[root] = state
				end
			end
		end
	end
	local baseHue = now * HUE_SPEED % 1
	for root, state in pairs(nearby) do
		if state.dirty then
			refreshMeshes(root, state)
		end
		local hue = (baseHue + state.offset) % 1
		local color = Color3.fromHSV(hue, 1, 1)
		for mesh, original in pairs(state.meshes) do
			if original.surface then
				original.surface.Color = color
			else
				mesh.Color = Color3.fromHSV(hue, 1, original.brightness)
			end
		end
	end
end

local function stopVisual(root: Instance, state)
	if not inWorld[root] then
		return
	end
	inWorld[root], nearby[root] = nil, nil
	state.added:Disconnect()
	state.removing:Disconnect()
	for mesh, original in pairs(state.meshes) do
		restore(mesh, original)
	end
	table.clear(state.meshes)
	if heartbeat and next(inWorld) == nil then
		heartbeat:Disconnect()
		heartbeat = nil
	end
end

local function watch(root: Instance)
	if watched[root] then
		return
	end
	local state = { meshes = {}, offset = random:NextNumber(), dirty = true }
	watched[root] = state
	local function updateVisibility()
		if not root:IsDescendantOf(Workspace) then
			stopVisual(root, state)
		elseif not inWorld[root] then
			local function markDirty(descendant: Instance)
				if descendant:IsA("MeshPart") or descendant:IsA("SurfaceAppearance") then
					state.dirty = true
				end
			end
			state.dirty = true
			state.added = root.DescendantAdded:Connect(markDirty)
			state.removing = root.DescendantRemoving:Connect(markDirty)
			inWorld[root] = state
			nextDistanceCheck = 0
			if not heartbeat then
				heartbeat = RunService.Heartbeat:Connect(updateColors)
			end
		end
	end
	state.ancestry = root.AncestryChanged:Connect(updateVisibility)
	updateVisibility()
end

function FishRainbowController:KnitStart()
	CollectionService:GetInstanceAddedSignal(TAG):Connect(watch)
	CollectionService:GetInstanceRemovedSignal(TAG):Connect(function(root)
		local state = watched[root]
		if state then
			state.ancestry:Disconnect()
			stopVisual(root, state)
			watched[root] = nil
		end
	end)
	for _, root in CollectionService:GetTagged(TAG) do
		watch(root)
	end
end

return FishRainbowController
