-- Asset-authoring utility, run in development Studio Edit; never a runtime script.
local assets = game:GetService("AssetService")
local fish = game.ReplicatedStorage.Models.Fish["Elder Fish"]
local body = fish.PrimaryPart
assert(body.MeshId == "rbxassetid://84615964971990", "Expected the correctly-facing two-bone source")
local names = { "FishBody", "SpineFront", "SpineMid", "TailBase", "FishTail" }
local pivots = { 0.5, 0.28, 0.48, 0.70, 0.88 }
local anchors = { 0.25, 0.42, 0.62, 0.82, 0.97 }
local mesh = assets:CreateEditableMeshAsync(body.MeshContent, { FixedSize = false })
local ok, result = xpcall(function()
	local old = mesh:GetBones()
	for _, id in old do mesh:SetBoneName(id, "Legacy_" .. mesh:GetBoneName(id)) end
	local ids, binds = {}, {}
	for index, name in names do
		local bind = if index == 1 then CFrame.identity else CFrame.new(0, 0, body.MeshSize.Z * (pivots[index] - 0.5))
		binds[index] = bind
		ids[index] = mesh:AddBone({ Name = name, ParentId = ids[index - 1], CFrame = bind, Virtual = false })
	end
	local vertices = mesh:GetVertices()
	for index, id in vertices do
		local along = mesh:GetPosition(id).Z / body.MeshSize.Z + 0.5
		local segment = 1
		while segment < #anchors - 1 and along > anchors[segment + 1] do segment += 1 end
		local alpha = math.clamp((along - anchors[segment]) / (anchors[segment + 1] - anchors[segment]), 0, 1)
		alpha = alpha * alpha * (3 - 2 * alpha)
		mesh:SetVertexBones(id, { ids[segment], ids[segment + 1] })
		mesh:SetVertexBoneWeights(id, { 1 - alpha, alpha })
		if index % 1000 == 0 then task.wait() end
	end
	local function depth(id)
		local count = 0
		while mesh:GetBoneParent(id) ~= 0 do id = mesh:GetBoneParent(id); count += 1 end
		return count
	end
	table.sort(old, function(a, b) return depth(a) > depth(b) end)
	for _, id in old do mesh:RemoveBone(id) end
	assert(#mesh:GetBones() == 5, "Incorrect bone count")
	local status, id = assets:CreateAssetAsync(mesh, Enum.AssetType.Mesh, {
		CreatorId = game.CreatorId, CreatorType = Enum.AssetCreatorType.Group,
		Name = "Elder Fish Five Bone Rig", Description = "Original -Z facing fish, fixed head and four articulated spine/tail bones.",
	})
	assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ": " .. tostring(id))
	local replacement = assets:CreateMeshPartAsync(Content.fromAssetId(id))
	assert(replacement.HasSkinnedMesh, "Uploaded asset has no skin")
	local backup = fish:Clone()
	backup.Name = "ElderFish_TwoBone_" .. os.date("!%Y%m%d_%H%M%S")
	backup.Parent = game.ServerStorage.FishRigBackups
	local saved = { size = body.Size, cframe = body.CFrame, pivot = body.PivotOffset, texture = body.TextureID,
		color = body.Color, material = body.Material }
	game:GetService("ChangeHistoryService"):SetWaypoint("Before five-bone fish rig")
	body:ApplyMesh(replacement)
	body.Size, body.CFrame, body.PivotOffset = saved.size, saved.cframe, saved.pivot
	body.TextureID, body.Color, body.Material = saved.texture, saved.color, saved.material
	body.FishBody:Destroy()
	local parent = body
	for index, name in names do
		local bone = Instance.new("Bone")
		bone.Name = name
		bone.CFrame = if index == 1 then binds[index] else binds[index - 1]:ToObjectSpace(binds[index])
		bone.Parent, parent = parent, bone
	end
	replacement:Destroy()
	game:GetService("ChangeHistoryService"):SetWaypoint("Install five-bone fish rig")
	return { meshId = id, backup = backup:GetFullName(), bones = names, vertices = #vertices }
end, debug.traceback)
mesh:Destroy()
assert(ok, result)
return result
