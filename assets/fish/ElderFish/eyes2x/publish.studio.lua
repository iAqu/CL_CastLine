-- Edit-time asset authoring only. Serve eyes2x/validation.json as /fish.json on localhost:18769.
local assets = game:GetService("AssetService")
local http = game:GetService("HttpService")
local body = game.ReplicatedStorage.Models.Fish["Elder Fish"].PrimaryPart
assert(body.MeshId == "rbxassetid://99085213011199", "Expected the original five-bone mesh")
local data = http:JSONDecode(http:GetAsync("http://127.0.0.1:18769/fish.json"))
local mesh = assets:CreateEditableMeshAsync(body.MeshContent)
assert(mesh and #mesh:GetBones() == 5, "Expected the existing five-bone skin")
local ok, result = xpcall(function()
	local originalSize = mesh:GetSize()
	local matches = table.create(#data.edits, 0)
	local changed = 0
	for index, id in mesh:GetVertices() do
		local position = mesh:GetPosition(id)
		local matched = false
		for editIndex, edit in data.edits do
			local old = Vector3.new(unpack(edit.old))
			if (position - old).Magnitude < 0.00005 then
				local bones, weights = mesh:GetVertexBones(id), mesh:GetVertexBoneWeights(id)
				mesh:SetPosition(id, Vector3.new(unpack(edit.new)))
				for i, bone in bones do
					assert(
						mesh:GetVertexBones(id)[i] == bone and mesh:GetVertexBoneWeights(id)[i] == weights[i],
						"Eye edit changed a skin weight"
					)
				end
				matches[editIndex] += 1
				matched = true
			end
		end
		if matched then
			changed += 1
		end
		if index % 1000 == 0 then
			task.wait()
		end
	end
	for _, count in matches do
		assert(count > 0, "Source eye vertex was not found in the installed mesh")
	end
	assert((mesh:GetSize() - originalSize).Magnitude < 0.00001, "Fish bounds changed")
	local status, id = assets:CreateAssetAsync(mesh, Enum.AssetType.Mesh, {
		CreatorId = game.CreatorId,
		CreatorType = Enum.AssetCreatorType.Group,
		Name = "Elder Fish Eyes 2x Five Bone Rig",
		Description = "Original five-bone fish; eye rings and pupils have twice the diameter.",
	})
	assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ": " .. tostring(id))
	local replacement = assets:CreateMeshPartAsync(Content.fromAssetId(id))
	assert(replacement.HasSkinnedMesh, "Published fish lost its skin")
	local storage = game:GetService("ServerStorage")
	local folder = storage:FindFirstChild("EyeScaleAssets") or Instance.new("Folder")
	folder.Name, folder.Parent = "EyeScaleAssets", storage
	replacement.Name, replacement.Parent = "ElderFish_Eyes2x", folder
	return { assetId = id, changedVertices = changed, sourceVerticesMatched = #matches, bones = #mesh:GetBones() }
end, debug.traceback)
mesh:Destroy()
assert(ok, result)
return result
