--# selene: allow(global_usage)
-- Edit-time resource authoring, never a runtime Script.
return function(key)
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	local h = game.HttpService
	local assets = game.AssetService
	local data = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/payload/" .. key .. ".json"))
	local drip = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/drip-surface-points.json")).fish[data.name]
	local installDrip = assert(loadstring(h:GetAsync("http://127.0.0.1:18775/install_drip_points.studio.lua")))()
	local staged = workspace:FindFirstChild("_FishRace_Staging")
	if not staged then
		staged = Instance.new("Folder")
		staged.Name = "_FishRace_Staging"
		staged.Parent = workspace
	end
	assert(not staged:FindFirstChild(data.name), "Already staged " .. data.name)
	local fish = Instance.new("Model")
	fish.Name = data.name
	local records = {}
	local radius = 0
	local ok, result = xpcall(function()
		for pi, spec in data.parts do
			local editable = assert(assets:CreateEditableMesh(), "Could not allocate skin")
			local meshOk, record = xpcall(function()
				local vertices, uvs, normals, bones, binds = {}, {}, {}, {}, {}
				local center = Vector3.new(table.unpack(spec.center))
				for i, b in data.bones do
					local bind = CFrame.new(Vector3.new(table.unpack(b.position)) - center)
					binds[i] = bind
					bones[i] = editable:AddBone({
						Name = b.name,
						ParentId = bones[b.parent + 1],
						CFrame = bind,
						Virtual = false,
					})
				end
				for i, v in spec.vertices do
					local position = Vector3.new(table.unpack(v))
					local id = editable:AddVertex(position)
					vertices[i] = id
					radius = math.max(radius, (position + center).Magnitude)
					local ids = {}
					for _, bi in spec.weights[i][1] do
						table.insert(ids, bones[bi + 1])
					end
					editable:SetVertexBones(id, ids)
					editable:SetVertexBoneWeights(id, spec.weights[i][2])
					if i % 1000 == 0 then
						task.wait()
					end
				end
				for i, uv in spec.uvs do
					uvs[i] = editable:AddUV(Vector2.new(uv[1], 1 - uv[2]))
				end
				for i, n in spec.normals do
					normals[i] = editable:AddNormal(Vector3.new(table.unpack(n)))
				end
				for i, f in spec.faces do
					local id = editable:AddTriangle(vertices[f[1] + 1], vertices[f[2] + 1], vertices[f[3] + 1])
					editable:SetFaceUVs(id, { uvs[f[4] + 1], uvs[f[5] + 1], uvs[f[6] + 1] })
					editable:SetFaceNormals(id, { normals[f[7] + 1], normals[f[8] + 1], normals[f[9] + 1] })
					if i % 1000 == 0 then
						task.wait()
					end
				end
				_G.RaceMeshCache = _G.RaceMeshCache or {}
				_G.RaceMeshCache[key] = _G.RaceMeshCache[key] or {}
				local cached = _G.RaceMeshCache[key][spec.name]
				local id = cached and cached.hash == spec.meshRecipeHash and cached.id or nil
				if not id then
					for attempt = 1, 14 do
						local delay = math.max(0, (_G.RaceNextUploadAt or 0) - os.clock())
						if delay > 0 then
							task.wait(delay)
						end
						_G.RaceNextUploadAt = os.clock() + 4
						local uploadOk, status, value = pcall(function()
							return assets:CreateAssetAsync(editable, Enum.AssetType.Mesh, {
								CreatorId = game.CreatorId,
								CreatorType = Enum.AssetCreatorType.Group,
								Name = "CastLine Race " .. data.name .. " " .. spec.name,
								Description = "Current-size fish skin with enlarged eyes and coherent weighted creature rig.",
							})
						end)
						if uploadOk and status == Enum.CreateAssetResult.Success then
							id = value
							break
						end
						local message = tostring(status) .. ":" .. tostring(value)
						assert(message:find("429") or message:find("5%d%d") or message:lower():find("timeout"), message)
						local backoff = math.min(60, 15 * 2 ^ (attempt - 1))
						if _G.RaceRetryJob then
							_G.RaceRetryJob.waiting =
								{ key = key, part = spec.name, attempt = attempt, backoff = backoff, error = message }
							h:PostAsync(
								"http://127.0.0.1:18775/retry-publication.json",
								h:JSONEncode(_G.RaceRetryJob),
								Enum.HttpContentType.ApplicationJson
							)
						end
						task.wait(backoff)
					end
					assert(id, "Upload retry budget exhausted: " .. key .. " " .. spec.name)
					_G.RaceMeshCache[key][spec.name] = { id = id, hash = spec.meshRecipeHash }
					h:PostAsync(
						"http://127.0.0.1:18775/mesh-cache.json",
						h:JSONEncode(_G.RaceMeshCache),
						Enum.HttpContentType.ApplicationJson
					)
				end
				if _G.RaceRetryJob then
					_G.RaceRetryJob.waiting = nil
					_G.RaceRetryJob.part = pi
				end
				local part = assets:CreateMeshPartAsync(Content.fromAssetId(id))
				assert(part.HasSkinnedMesh, "Published asset lost skin")
				part.Name = spec.name
				part.Size = Vector3.new(table.unpack(spec.size))
				part.CFrame = CFrame.new(center)
				part.Color = Color3.new(table.unpack(spec.color))
				part.Material = Enum.Material[spec.original.material]
				part.MaterialVariant = spec.original.materialVariant or ""
				part.Transparency = spec.original.transparency
				part.Reflectance = spec.original.reflectance
				part.CastShadow = spec.original.castShadow
				part.DoubleSided = spec.original.doubleSided
				part.Anchored = true
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part:SetAttribute("OriginalPartName", spec.original.name)
				part:SetAttribute("SourceMeshId", spec.original.mesh)
				part:SetAttribute("RaceSourceKey", spec.sourceKey)
				if spec.original.texture ~= "" then
					part.TextureID = "rbxassetid://127837620888950"
				end
				for _, b in part:GetChildren() do
					if b:IsA("Bone") then
						b:Destroy()
					end
				end
				local instances = {}
				for i, b in data.bones do
					local bone = Instance.new("Bone")
					bone.Name = b.name
					bone.CFrame = if b.parent < 0 then binds[i] else binds[b.parent + 1]:ToObjectSpace(binds[i])
					bone.Parent = instances[b.parent + 1] or part
					instances[i] = bone
				end
				part.Parent = fish
				if pi == 1 then
					fish.PrimaryPart = part
				end
				return {
					part = part.Name,
					sourcePart = spec.original.name,
					meshId = id,
					vertices = #spec.vertices,
					bones = #data.bones,
					transparency = part.Transparency,
				}
			end, debug.traceback)
			editable:Destroy()
			assert(meshOk, record)
			table.insert(records, record)
			if _G.RaceMeshJob then
				_G.RaceMeshJob.part = pi
			end
			task.wait()
		end
		local mouth = Instance.new("Attachment")
		mouth.Name = "MouthAttachment"
		mouth.Position = Vector3.new(table.unpack(data.mouth)) - Vector3.new(table.unpack(data.parts[1].center))
		mouth.Parent = fish.PrimaryPart
		installDrip(fish, drip)
		local controller = Instance.new("AnimationController")
		controller.Name = "FishAnimationController"
		controller.Parent = fish
		local animator = Instance.new("Animator")
		animator.Parent = controller
		fish:SetAttribute("EyeDiameterScale", data.eye.scale)
		fish:SetAttribute("LogicalBoneCount", #data.bones)
		fish:SetAttribute("RigVariant", data.variant)
		fish:SetAttribute("RaceFamily", data.family)
		fish:SetAttribute("FishBodySize", Vector3.new(table.unpack(data.bodySize)))
		fish:SetAttribute("PresentationRadius", data.presentationRadius or radius * 2)
		fish:SetAttribute("ProcessingStatus", "AwaitingAnimationsAndValidation")
		fish:SetAttribute("BatchKey", key)
		local index = tonumber(key:match("%d+")) - 1
		fish:PivotTo(CFrame.new(250 + (index % 5) * 30, 25, 150 + math.floor(index / 5) * 35))
		fish.Parent = staged
	end, debug.traceback)
	if not ok then
		fish:Destroy()
		error(result)
	end
	return {
		name = data.name,
		key = key,
		parts = records,
		eyeScale = data.eye.scale,
		logicalBones = #data.bones,
		family = data.family,
		variant = data.variant,
	}
end
