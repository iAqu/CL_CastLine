-- Run in Edit against the published, isolated Axolotl.
return function(fish, rig, landmarks)
	local assets = game:GetService("AssetService")
	local body = assert(fish.PrimaryPart, "Published fish has no PrimaryPart")
	local original = workspace.Fish_Processed.Axolotl.PrimaryPart
	assert(
		body.Size == original.Size and body.TextureID == original.TextureID and body.Color == original.Color,
		"Appearance changed"
	)
	assert(
		body.Material == original.Material and body.MouthAttachment.Position == original.MouthAttachment.Position,
		"Material or mouth changed"
	)
	local mesh = assert(assets:CreateEditableMeshAsync(body.MeshContent), "Could not read published mesh")
	local report, samples = {}, {}
	local ok, failure = xpcall(function()
		local bones, joints, effect = {}, {}, {}
		for _, id in mesh:GetBones() do
			local name = mesh:GetBoneName(id)
			local bone = assert(body:FindFirstChild(name, true), name)
			assert(bone:IsA("Bone"))
			bones[id], joints[name] = bone, bone
			local parent = mesh:GetBoneParent(id)
			assert(
				parent == 0 and bone.Parent == body or parent ~= 0 and bone.Parent.Name == mesh:GetBoneName(parent),
				name .. " parent mismatch"
			)
			local bind = mesh:GetBoneCFrame(id)
			local expected = CFrame.new(bind.Position * body.Size / body.MeshSize) * bind.Rotation
			assert(body.CFrame:ToObjectSpace(bone.WorldCFrame):FuzzyEq(expected, 0.001), name .. " bind")
		end
		assert(#mesh:GetBones() == 20 and fish:GetAttribute("LogicalBoneCount") == 20, "Incorrect published bone count")
		local vertices = mesh:GetVertices()
		assert(#vertices == rig.parts[1].vertexCount, "Vertex count changed")
		local ratio = body.Size / body.MeshSize
		local function influences(vertex)
			local result = {}
			local weights = mesh:GetVertexBoneWeights(vertex)
			local total = 0
			for i, id in mesh:GetVertexBones(vertex) do
				local weight = weights[i]
				assert(weight >= 0 and weight <= 1, "Invalid published skin weight")
				if weight > 0 then
					total += weight
					result[bones[id].Name] = weight
				end
			end
			assert(math.abs(total - 1) < 0.001, "Unnormalized published weights")
			return result
		end
		local nearest = {}
		for name, position in landmarks.feet do
			nearest[name] = { position = Vector3.new(table.unpack(position)), distance = math.huge }
		end
		nearest.Tail = { position = Vector3.new(table.unpack(landmarks.tail)), distance = math.huge }
		for index, vertex in vertices do
			local position = mesh:GetPosition(vertex) * ratio
			local skin = influences(vertex)
			for name, weight in skin do
				effect[name] = math.max(effect[name] or 0, weight)
			end
			for _, landmark in nearest do
				local d = (landmark.position - position).Magnitude
				if d < landmark.distance then
					landmark.vertex, landmark.distance = vertex, d
				end
			end
			if index % 4096 == 0 then
				task.wait()
			end
		end
		for _, b in rig.bones do
			assert((effect[b.name] or 0) >= 0.09, "Ineffective bone " .. b.name)
		end
		for name, landmark in nearest do
			local position = mesh:GetPosition(landmark.vertex) * ratio
			samples[name] = { position = { position.X, position.Y, position.Z }, weights = influences(landmark.vertex) }
		end
		for _, p in rig.drip do
			local raw = Vector3.new(table.unpack(p.position))
			local match, skin
			local function consider(vertex)
				if not vertex or (mesh:GetPosition(vertex) - raw).Magnitude > 0.00015 then
					return
				end
				local values = influences(vertex)
				for name, weight in values do
					if math.abs((p.influences[name] or 0) - weight) > 0.009 then
						return
					end
				end
				for name, weight in p.influences do
					if math.abs((values[name] or 0) - weight) > 0.009 then
						return
					end
				end
				match, skin = vertex, values
			end
			consider(vertices[p.sourceVertex + 1])
			if not match then
				for _, vertex in vertices do
					consider(vertex)
					if match then
						break
					end
				end
			end
			assert(match, "Missing published surface point " .. p.name)
			local point = assert(body:FindFirstChild(p.name, true), p.name)
			local rotation = body.CFrame:ToObjectSpace(point.WorldCFrame).Rotation
			local bind = CFrame.new(mesh:GetPosition(match) * ratio) * rotation
			local joint = assert(joints[p.bone], "Missing surface anchor bone " .. p.bone)
			point.Parent = joint
			point.CFrame = joint.WorldCFrame:ToObjectSpace(body.CFrame * bind)
			point:SetAttribute("RigV2SurfaceBind", bind)
			local encoded = {}
			for name, weight in skin do
				table.insert(encoded, name .. ":" .. weight)
			end
			table.sort(encoded)
			point:SetAttribute("RigV2SurfaceWeights", table.concat(encoded, ";"))
		end
		assert(#rig.drip == 24, "Incorrect number of drip points")
		fish:SetAttribute("RigV2SurfaceScale", fish:GetScale())
		fish:SetAttribute("RigV2SurfacePrepared", true)
		report = { bones = 20, vertices = #vertices, points = #rig.drip, effective = effect }
	end, debug.traceback)
	mesh:Destroy()
	assert(ok, failure)
	return report, samples
end
