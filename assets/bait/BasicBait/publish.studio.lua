-- Edit-time asset authoring only. Serve BasicBait_Eyes2x.mesh.json as /bait.json on localhost:18769.
local assets = game:GetService("AssetService")
local http = game:GetService("HttpService")
local data = http:JSONDecode(http:GetAsync("http://127.0.0.1:18769/bait.json"))
local mesh = assets:CreateEditableMesh()
assert(mesh, "Could not allocate the authored bait mesh")
local ok, result = xpcall(function()
	local vertices, uvs, normals = {}, {}, {}
	for index, p in data.vertices do
		vertices[index] = mesh:AddVertex(Vector3.new(unpack(p)))
		if index % 1000 == 0 then
			task.wait()
		end
	end
	for index, uv in data.uvs do
		-- OBJ uses bottom-left UV origin; Roblox mesh UVs use top-left.
		uvs[index] = mesh:AddUV(Vector2.new(uv[1], 1 - uv[2]))
		if index % 1000 == 0 then
			task.wait()
		end
	end
	for index, normal in data.normals do
		normals[index] = mesh:AddNormal(Vector3.new(unpack(normal)))
		if index % 1000 == 0 then
			task.wait()
		end
	end
	for index, f in data.faces do
		local face = mesh:AddTriangle(vertices[f[1] + 1], vertices[f[2] + 1], vertices[f[3] + 1])
		mesh:SetFaceUVs(face, { uvs[f[4] + 1], uvs[f[5] + 1], uvs[f[6] + 1] })
		mesh:SetFaceNormals(face, { normals[f[7] + 1], normals[f[8] + 1], normals[f[9] + 1] })
		if index % 1000 == 0 then
			task.wait()
		end
	end
	local status, id = assets:CreateAssetAsync(mesh, Enum.AssetType.Mesh, {
		CreatorId = game.CreatorId,
		CreatorType = Enum.AssetCreatorType.Group,
		Name = "CastLine Basic Bait Eyes 2x",
		Description = "Native-exported caterpillar bait; both eyes and white highlights have twice the diameter.",
	})
	assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ": " .. tostring(id))
	local replacement = assets:CreateMeshPartAsync(Content.fromAssetId(id))
	local storage = game:GetService("ServerStorage")
	local folder = storage:FindFirstChild("EyeScaleAssets") or Instance.new("Folder")
	folder.Name, folder.Parent = "EyeScaleAssets", storage
	replacement.Name, replacement.Parent = "BasicBait_Eyes2x", folder
	return { assetId = id, vertices = #data.vertices, triangles = #data.faces }
end, debug.traceback)
mesh:Destroy()
assert(ok, result)
return result
