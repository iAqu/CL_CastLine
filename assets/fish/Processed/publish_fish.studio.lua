-- One-time Edit authoring utility. Never install this as a runtime Script.
return function(name, reefTexture)
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	local http = game:GetService("HttpService")
	local assets = game:GetService("AssetService")
	local data = http:JSONDecode(http:GetAsync("http://127.0.0.1:18773/payload/" .. http:UrlEncode(name) .. ".json"))
	local dripData = http:JSONDecode(http:GetAsync("http://127.0.0.1:18773/drip-surface-points.json")).fish[name]
	assert(dripData and #dripData.points == 24, "Generate drip-surface-points.json before publishing")
	local installDrip = assert(loadstring(http:GetAsync("http://127.0.0.1:18773/install_drip_points.studio.lua")))()
	local folder = workspace.Fish_Processed
	assert(not folder:FindFirstChild(name), "Fish already staged")
	local source = workspace.Fish[name]
	local fish = source:Clone()
	local primaryFrame = source.PrimaryPart.CFrame
	local records = {}
	local ok, err = xpcall(function()
		for _, part in fish:GetDescendants() do
			if
				part:IsA("JointInstance")
				or part:IsA("Constraint")
				or part:IsA("WeldConstraint")
				or part:IsA("BaseScript")
			then
				part:Destroy()
			end
		end
		for partIndex, spec in data.parts do
			local originalFrame = CFrame.new(table.unpack(spec.original.cframe))
			local old, distance = nil, math.huge
			for _, candidate in fish:GetDescendants() do
				if candidate:IsA("BasePart") and candidate.Name == spec.original.name then
					local delta = (candidate.Position - originalFrame.Position).Magnitude
					if delta < distance then
						old, distance = candidate, delta
					end
				end
			end
			assert(old and distance < 0.01, "Source part missing: " .. spec.original.name)
			local mesh = assert(assets:CreateEditableMesh(), "Could not allocate authored mesh")
			local partOk, partResult = xpcall(function()
				local vertices, uvs, normals, bones, binds = {}, {}, {}, {}, {}
				local center = Vector3.new(table.unpack(spec.center))
				for i, bone in data.bones do
					local bind = CFrame.new(Vector3.new(table.unpack(bone.position)) - center)
					binds[i] = bind
					bones[i] = mesh:AddBone({
						Name = bone.name,
						ParentId = bones[bone.parent + 1],
						CFrame = bind,
						Virtual = false,
					})
				end
				for i, vertex in spec.vertices do
					local id = mesh:AddVertex(Vector3.new(table.unpack(vertex)))
					vertices[i] = id
					local ids = {}
					for _, index in spec.weights[i][1] do
						table.insert(ids, bones[index + 1])
					end
					mesh:SetVertexBones(id, ids)
					mesh:SetVertexBoneWeights(id, spec.weights[i][2])
					if i % 1000 == 0 then
						task.wait()
					end
				end
				for i, uv in spec.uvs do
					uvs[i] = mesh:AddUV(Vector2.new(uv[1], 1 - uv[2]))
				end
				for i, n in spec.normals do
					normals[i] = mesh:AddNormal(Vector3.new(table.unpack(n)))
				end
				for i, f in spec.faces do
					local id = mesh:AddTriangle(vertices[f[1] + 1], vertices[f[2] + 1], vertices[f[3] + 1])
					mesh:SetFaceUVs(id, { uvs[f[4] + 1], uvs[f[5] + 1], uvs[f[6] + 1] })
					mesh:SetFaceNormals(id, { normals[f[7] + 1], normals[f[8] + 1], normals[f[9] + 1] })
					if i % 1000 == 0 then
						task.wait()
					end
				end
				local status, id = assets:CreateAssetAsync(mesh, Enum.AssetType.Mesh, {
					CreatorId = game.CreatorId,
					CreatorType = Enum.AssetCreatorType.Group,
					Name = "CastLine " .. name .. " " .. spec.name,
					Description = "Native-exported fish; enlarged eyes, weighted spine and authored animation rig.",
				})
				assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ": " .. tostring(id))
				local part = assets:CreateMeshPartAsync(Content.fromAssetId(id))
				assert(part.HasSkinnedMesh, "Published mesh lost skin")
				part.Name = spec.name
				part.Size = Vector3.new(table.unpack(spec.size))
				part.CFrame = primaryFrame * CFrame.new(center)
				part.Color, part.Material, part.Transparency = old.Color, old.Material, old.Transparency
				part.Reflectance, part.CastShadow = old.Reflectance, old.CastShadow
				part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
				part:SetAttribute("OriginalPartName", old.Name)
				if spec.original.texture and spec.original.texture ~= "" then
					part.TextureID = if spec.original.texture == "rbxassetid://100058154460562"
						then "rbxassetid://127837620888950"
						else "rbxassetid://" .. reefTexture
				else
					local h, s, v = part.Color:ToHSV()
					s += 0.35 * s * (1 - s)
					v += 0.20 * (v - 0.5) * 4 * v * (1 - v)
					part.Color = Color3.fromHSV(h, s, v)
				end
				for _, child in part:GetChildren() do
					if child:IsA("Bone") then
						child:Destroy()
					end
				end
				local instances = {}
				for i, bone in data.bones do
					local instance = Instance.new("Bone")
					instance.Name = bone.name
					instance.CFrame = if bone.parent < 0
						then binds[i]
						else binds[bone.parent + 1]:ToObjectSpace(binds[i])
					instance.Parent = instances[bone.parent + 1] or part
					instances[i] = instance
				end
				part.Parent = fish
				for _, child in old:GetChildren() do
					if child:IsA("Attachment") then
						local world = child.WorldCFrame
						local nearest, delta = instances[1], math.huge
						for _, bone in instances do
							local d = (world.Position - bone.WorldPosition).Magnitude
							if d < delta then
								nearest, delta = bone, d
							end
						end
						child.Parent = nearest
						child.CFrame = nearest.WorldCFrame:ToObjectSpace(world)
					elseif not child:IsA("SurfaceAppearance") then
						child.Parent = part
					end
				end
				if partIndex == 1 then
					fish.PrimaryPart = part
				end
				old:Destroy()
				return { part = part.Name, meshId = id, bones = #data.bones, vertices = #spec.vertices }
			end, debug.traceback)
			mesh:Destroy()
			assert(partOk, partResult)
			table.insert(records, partResult)
			task.wait()
		end
		local mouth = Instance.new("Attachment")
		mouth.Name = "MouthAttachment"
		mouth.Position = Vector3.new(table.unpack(data.mouth)) - Vector3.new(table.unpack(data.parts[1].center))
		mouth.Parent = fish.PrimaryPart
		installDrip(fish, dripData)
		local controller = Instance.new("AnimationController")
		controller.Name, controller.Parent = "FishAnimationController", fish
		local animator = Instance.new("Animator")
		animator.Parent = controller
		for _, part in fish:GetDescendants() do
			if part:IsA("BasePart") then
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
			end
		end
		fish:SetAttribute("EyeDiameterScale", data.eye.scale)
		fish:SetAttribute("LogicalBoneCount", #data.bones)
		fish:SetAttribute("RigVariant", data.variant)
		if data.presentationRadius then
			fish:SetAttribute("PresentationRadius", data.presentationRadius)
		end
		fish:SetAttribute("ProcessingStatus", "AwaitingAnimationsAndValidation")
		fish:PivotTo(source:GetPivot() + Vector3.new(60, 0, 0))
		fish.Parent = folder
	end, debug.traceback)
	if not ok then
		fish:Destroy()
		error(err)
	end
	return {
		name = name,
		parts = records,
		eyeScale = data.eye.scale,
		logicalBones = #data.bones,
		variant = data.variant,
	}
end
