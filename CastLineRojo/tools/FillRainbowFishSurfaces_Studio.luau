-- Run in #CL_DEV Edit mode through the Studio command bar / MCP.
-- Author texture maps here; runtime scripts only clone surfaces and animate Color.
-- Safe to rerun: existing Rainbow surfaces are checked, never overwritten.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
assert(not RunService:IsRunning(), "FillRainbowFishSurfaces: run in Studio Edit mode")

local models = assert(ReplicatedStorage:FindFirstChild("Models"), "Missing Models")
local fishRoot = assert(models:FindFirstChild("Fish"), "Missing Models.Fish")
local effects = assert(ReplicatedStorage:FindFirstChild("VFX"), "Missing VFX")
local surfaceRoot = assert(effects:FindFirstChild("FishSurface"), "Missing VFX.FishSurface")
local SURFACE_NAME = "SurfaceAppearance_Rainbow"
local report = { models = 0, meshes = 0, created = {}, skipped = {}, missing = {}, conflicts = {} }
local pending = {}
local seen = {}

local function getSurfaceFolder(modelName: string): Instance?
	local exact = surfaceRoot:FindFirstChild(modelName)
	if exact then
		return exact
	end
	local normalizedName = modelName:gsub("%s+", "")
	local match: Instance? = nil
	for _, folder in surfaceRoot:GetChildren() do
		if folder.Name:gsub("%s+", "") == normalizedName then
			if match then
				table.insert(report.conflicts, "Ambiguous FishSurface directory for " .. modelName)
				return nil
			end
			match = folder
		end
	end
	if not match then
		table.insert(report.missing, "Missing FishSurface directory for " .. modelName)
	end
	return match
end

-- Preflight the entire batch before authoring any resources.
for _, model in fishRoot:GetChildren() do
	if not model:IsA("Model") then
		continue
	end
	local folder: Instance? = nil
	local counted = false
	for _, mesh in model:GetDescendants() do
		if not mesh:IsA("MeshPart") or mesh.Transparency >= 1 or mesh.Name == "CameraPart"
			or mesh.TextureID == "" or mesh:FindFirstChildOfClass("SurfaceAppearance") then
			continue
		end
		if not counted then
			report.models += 1
			folder = getSurfaceFolder(model.Name)
			counted = true
		end
		report.meshes += 1
		if not folder then
			continue
		end
		local key = folder.Name .. "/" .. mesh.Name
		if seen[key] then
			if seen[key] ~= mesh.TextureID then
				table.insert(report.conflicts, "Different TextureIDs share " .. key)
			end
			continue
		end
		seen[key] = mesh.TextureID
		local meshFolder = folder:FindFirstChild(mesh.Name)
		local existing = meshFolder and meshFolder:FindFirstChild(SURFACE_NAME)
		if existing then
			if not existing:IsA("SurfaceAppearance") or existing.ColorMap ~= mesh.TextureID then
				table.insert(report.conflicts, "Existing Rainbow surface has a different map or class: " .. key)
			else
				table.insert(report.skipped, key)
			end
		else
			table.insert(pending, { folder = folder, meshName = mesh.Name, texture = mesh.TextureID, key = key })
		end
	end
end

if #report.missing == 0 and #report.conflicts == 0 then
	for index, entry in pending do
		local meshFolder = entry.folder:FindFirstChild(entry.meshName)
		if not meshFolder then
			meshFolder = Instance.new("Folder")
			meshFolder.Name = entry.meshName
			meshFolder.Parent = entry.folder
		end
		local surface = Instance.new("SurfaceAppearance")
		surface.Name = SURFACE_NAME
		surface.ColorMap = entry.texture
		surface.Color = Color3.new(1, 1, 1)
		surface.AlphaMode = Enum.AlphaMode.Overlay
		surface.Parent = meshFolder
		table.insert(report.created, entry.key)
		if index % 32 == 0 then
			task.wait()
		end
	end
end

for _, message in report.missing do
	warn("FillRainbowFishSurfaces: " .. message)
end
for _, message in report.conflicts do
	warn("FillRainbowFishSurfaces: " .. message)
end
warn(("FillRainbowFishSurfaces: models=%d meshes=%d created=%d skipped=%d missing=%d conflicts=%d"):format(
	report.models, report.meshes, #report.created, #report.skipped, #report.missing, #report.conflicts
))
return report
