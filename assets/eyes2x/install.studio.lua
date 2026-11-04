-- Edit-time only. Applies already-published assets to the existing template instances.
local history = game:GetService("ChangeHistoryService")
local storage = game:GetService("ServerStorage")
local replacements = storage:WaitForChild("EyeScaleAssets")
local targets = {
	{ game.ReplicatedStorage.Models.FishBait["1"]["1"], replacements.BasicBait_Eyes2x },
	{ game.ReplicatedStorage.Models.Fish["Elder Fish"].PrimaryPart, replacements.ElderFish_Eyes2x },
}
local results = {}
history:SetWaypoint("Before 2x eye meshes")
for _, pair in targets do
	local part, replacement = pair[1], pair[2]
	local saved = {
		size = part.Size,
		frame = part.CFrame,
		pivot = part.PivotOffset,
		texture = part.TextureID,
		color = part.Color,
		material = part.Material,
		doubleSided = part.DoubleSided,
	}
	part:ApplyMesh(replacement)
	part.Size, part.CFrame, part.PivotOffset = saved.size, saved.frame, saved.pivot
	part.TextureID, part.Color, part.Material = saved.texture, saved.color, saved.material
	part.DoubleSided = saved.doubleSided
	part:SetAttribute("EyeDiameterScale", 2)
	assert(
		part.Size == saved.size and part.CFrame == saved.frame and part.TextureID == saved.texture,
		"Installing the eye mesh changed a template property"
	)
	table.insert(results, { path = part:GetFullName(), meshId = part.MeshId, size = tostring(part.Size) })
end
history:SetWaypoint("Install 2x eye meshes")
return results
