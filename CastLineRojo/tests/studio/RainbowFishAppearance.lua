-- Client Play validation of the real mutation module and rainbow controller.
-- Leaves three client-only fish for screenshot QA; destroy _RainbowFishAppearanceQA afterwards.
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
assert(RunService:IsClient(), "Run RainbowFishAppearance in the Client Play datamodel")

local visual = require(ReplicatedStorage.Modules.MutationVisualUtil)
local fishRoot = ReplicatedStorage.Models.Fish
local surfaces = ReplicatedStorage.VFX.FishSurface
local white = Color3.new(1, 1, 1)
local folder = Instance.new("Folder")
folder.Name = "_RainbowFishAppearanceQA"
assert(not Workspace:FindFirstChild(folder.Name), "Clean up the previous Rainbow fish QA first")
folder.Parent = Workspace
local report = { models = 0, meshes = 0, animated = 0, lifecycle = {}, regressions = {} }

local function settle()
	RunService.Heartbeat:Wait()
	RunService.Heartbeat:Wait()
end

local function makeFish(template: Model, mutation: string?): Model
	local model = template:Clone()
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end
	end
	visual.ApplyAppearance(model, mutation, template.Name)
	model:PivotTo(CFrame.new(0, 10000, 0) * model:GetPivot().Rotation)
	model.Parent = folder
	if mutation == "Rainbow" then
		CollectionService:AddTag(model, visual.RAINBOW_TAG)
	end
	return model
end

local ok, message = xpcall(function()
	local checked = {}
	for _, template in fishRoot:GetChildren() do
		if not template:IsA("Model") then
			continue
		end
		local originals = {}
		for _, mesh in template:GetDescendants() do
			if mesh:IsA("MeshPart") and mesh.Transparency < 1 and mesh.Name ~= "CameraPart"
				and mesh.TextureID ~= "" and not mesh:FindFirstChildOfClass("SurfaceAppearance") then
				originals[mesh.Name] = mesh.TextureID
			end
		end
		if next(originals) == nil then
			continue
		end
		report.models += 1
		local model = makeFish(template, "Rainbow")
		for _, mesh in model:GetDescendants() do
			local texture = originals[mesh.Name]
			if mesh:IsA("MeshPart") and texture then
				local surface = assert(mesh:FindFirstChildOfClass("SurfaceAppearance"), template.Name .. "." .. mesh.Name)
				assert(surface.ColorMap == texture and mesh.TextureID == texture, "Changed original texture")
				report.meshes += 1
				table.insert(checked, { mesh = mesh, surface = surface, texture = texture })
			end
		end
	end
	assert(report.models == 82 and report.meshes == 114, "Unexpected legacy fish coverage")
	settle()
	for _, entry in checked do
		entry.color = entry.surface.Color
	end
	task.wait(0.2)
	for _, entry in checked do
		assert(entry.surface.Color ~= entry.color, "Surface color did not animate: " .. entry.mesh:GetFullName())
		assert(entry.surface.ColorMap == entry.texture, "Animation changed the texture map")
		report.animated += 1
	end
	for _, value in surfaces:GetDescendants() do
		if value:IsA("SurfaceAppearance") and value.Name == "SurfaceAppearance_Rainbow" then
			assert(value.Color == white, "Animation mutated a shared surface template")
		end
	end

	local moby = assert(folder:FindFirstChild("MobyWhale"))
	local body = assert(moby:FindFirstChildWhichIsA("MeshPart", true))
	local surface = assert(body:FindFirstChildOfClass("SurfaceAppearance"))
	CollectionService:RemoveTag(moby, visual.RAINBOW_TAG)
	settle()
	assert(surface.Color == white, "Removing the Rainbow tag must restore the surface tint")
	table.insert(report.lifecycle, "remove tag restores tint")
	CollectionService:AddTag(moby, visual.RAINBOW_TAG)
	settle()
	assert(surface.Color ~= white, "Adding the tag must restart tint animation")
	table.insert(report.lifecycle, "reapply tag restarts animation")
	moby.Parent = nil
	settle()
	assert(surface.Color == white, "Leaving Workspace must restore the original surface tint")
	moby.Parent = folder
	settle()
	assert(surface.Color ~= white, "Returning to Workspace must resume animation")
	table.insert(report.lifecycle, "leave and return to Workspace")
	moby:Destroy()
	moby = makeFish(fishRoot.MobyWhale, "Rainbow")
	settle()
	assert(moby:FindFirstChildWhichIsA("MeshPart", true):FindFirstChildOfClass("SurfaceAppearance").Color ~= white,
		"Recreating the home display must restart animation")
	table.insert(report.lifecycle, "destroy and recreate display")

	for _, mutation in { "Golden", "Diamond" } do
		local clone = makeFish(fishRoot.MobyWhale, mutation)
		local actual = clone:FindFirstChildWhichIsA("MeshPart", true):FindFirstChildOfClass("SurfaceAppearance")
		local expected = surfaces["Moby Whale"].polySurface5["SurfaceAppearance_" .. mutation]
		assert(actual and actual.ColorMap == expected.ColorMap and actual.Color == expected.Color,
			"Changed " .. mutation .. " appearance")
		assert(not CollectionService:HasTag(clone, visual.RAINBOW_TAG), "Tagged a non-Rainbow fish")
		clone:Destroy()
		table.insert(report.regressions, mutation)
	end
	local normal = makeFish(fishRoot.MobyWhale, nil)
	local normalBody = normal:FindFirstChildWhichIsA("MeshPart", true)
	local originalBody = fishRoot.MobyWhale:FindFirstChildWhichIsA("MeshPart", true)
	assert(not normalBody:FindFirstChildOfClass("SurfaceAppearance")
		and normalBody.Color == originalBody.Color and normalBody.TextureID == originalBody.TextureID,
		"Changed the normal whale appearance")
	normal:Destroy()
	table.insert(report.regressions, "Normal")
	local manta = makeFish(fishRoot.MantaRay, "Rainbow")
	settle()
	local mantaBody = assert(manta:FindFirstChildWhichIsA("MeshPart", true))
	local mantaColor = mantaBody.Color
	task.wait(0.2)
	assert(not mantaBody:FindFirstChildOfClass("SurfaceAppearance") and mantaBody.Color ~= mantaColor,
		"Untextured Rainbow fish must keep their existing animation")
	manta:Destroy()
	table.insert(report.regressions, "untextured Rainbow")

	local keep = { MobyWhale = true, Axolotl = true, CandyJellyfish = true }
	for _, model in folder:GetChildren() do
		if not keep[model.Name] then
			model:Destroy()
		end
	end
end, debug.traceback)

if not ok then
	folder:Destroy()
	error(message)
end
return report
