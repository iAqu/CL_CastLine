--# selene: allow(global_usage)
-- One-time Edit authoring: preserve current models, snapshot and select native-export copies.
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
assert(not workspace:FindFirstChild("_RaceFishExportSource"), "Export source already exists")
local source = assert(workspace:FindFirstChild("race的鱼"))
local backups = game.ServerStorage:FindFirstChild("FishUpgradeBackups")
local stamp = os.date("!%Y%m%d_%H%M%S")
local backup = Instance.new("Folder")
backup.Name = "BeforeRace_" .. stamp
backup.Parent = backups
for _, entry in
	{
		{ source, "RaceOriginals" },
		{ workspace.Fish_Processed, "ProcessedBefore" },
		{ game.ReplicatedStorage.Models.Fish, "TemplatesBefore" },
	}
do
	local copy = entry[1]:Clone()
	copy.Name = entry[2]
	copy.Parent = backup
	task.wait()
end
local export = Instance.new("Folder")
export.Name = "_RaceFishExportSource"
export.Parent = workspace
local list = source:GetChildren()
table.sort(list, function(a, b)
	return a.Name < b.Name
end)
local manifest = {
	placeId = game.PlaceId,
	creatorGroupId = game.CreatorId,
	backup = backup:GetFullName(),
	stamp = stamp,
	fish = {},
	sourceFolder = source:GetFullName(),
	existingProcessed = #workspace.Fish_Processed:GetChildren(),
	existingTemplates = #game.ReplicatedStorage.Models.Fish:GetChildren(),
	partCount = 0,
}
local function vec(v)
	return { v.X, v.Y, v.Z }
end
for fi, fish in list do
	assert(fish:IsA("Model"), "Unexpected source child")
	local frame, size = fish:GetBoundingBox()
	local row = {
		name = fish.Name,
		exportKey = string.format("Race%03d", fi),
		pivot = { fish:GetPivot():GetComponents() },
		boundsFrame = { frame:GetComponents() },
		boundsSize = vec(size),
		modelScale = fish:GetScale(),
		parts = {},
		legacyBones = {},
	}
	local parts = {}
	for _, p in fish:GetDescendants() do
		if p:IsA("MeshPart") then
			table.insert(parts, p)
		end
		if p:IsA("Bone") then
			table.insert(
				row.legacyBones,
				{ name = p.Name, path = p:GetFullName(), cframe = { p.CFrame:GetComponents() } }
			)
		end
	end
	table.sort(parts, function(a, b)
		return a:GetFullName() < b:GetFullName()
	end)
	for pi, part in parts do
		local key = string.format("Race%03d_P%03d", fi, pi)
		local copy = part:Clone()
		copy:ClearAllChildren()
		copy.Name = key
		copy.Anchored = true
		copy.CanCollide = false
		copy.CanTouch = false
		copy.CanQuery = false
		copy.Parent = export
		table.insert(row.parts, {
			exportKey = key,
			name = part.Name,
			path = part:GetFullName(),
			mesh = part.MeshId,
			texture = part.TextureID,
			size = vec(part.Size),
			meshSize = vec(part.MeshSize),
			cframe = { part.CFrame:GetComponents() },
			color = { part.Color.R, part.Color.G, part.Color.B },
			material = part.Material.Name,
			materialVariant = part.MaterialVariant,
			transparency = part.Transparency,
			reflectance = part.Reflectance,
			castShadow = part.CastShadow,
			doubleSided = part.DoubleSided,
		})
		manifest.partCount += 1
	end
	table.insert(manifest.fish, row)
	task.wait()
end
assert(#manifest.fish == 25 and manifest.partCount == 273, "Source inventory changed")
game.Selection:Set({ export })
_G.RaceFishManifest = manifest
return game.HttpService:JSONEncode(manifest)
