--# selene: allow(global_usage)
-- Continuous Edit-time readback/playback audit of the current staged instances.
local h = game.HttpService

local function inspect(fish)
	local data = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/payload/" .. fish:GetAttribute("BatchKey") .. ".json"))
	local library = game.ReplicatedStorage.Animation.Fishing.NewFishVariants[fish:GetAttribute("RigVariant")]
	local old = fish:FindFirstChild("Animations")
	if old then
		old:Destroy()
	end
	local clips = library:Clone()
	clips.Name = "Animations"
	clips.Parent = fish
	local bounds = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/animation-bounds.json"))
	fish:SetAttribute("PresentationRadius", bounds[fish.Name].presentationRadius)
	local parts, bones = {}, {}
	for _, p in fish:GetDescendants() do
		if p:IsA("MeshPart") then
			assert(p.HasSkinnedMesh, "Unskinned layer")
			table.insert(parts, p)
		end
		if p:IsA("Bone") then
			p.Transform = CFrame.identity
			table.insert(bones, p)
		end
	end
	assert(#parts == #data.parts and #bones == #parts * #data.bones, "Rig inventory mismatch")
	local animator = fish:FindFirstChildWhichIsA("AnimationController"):FindFirstChildWhichIsA("Animator")
	local playback = {}
	for _, clip in clips:GetChildren() do
		local track = animator:LoadAnimation(clip)
		track:Play(0)
		local deadline = os.clock() + 20
		while track.Length == 0 and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(track.Length > 0, "Animation failed " .. clip.Name)
		local moved = {}
		for sample = 0, 16 do
			track.TimePosition = track.Length * sample / 17
			animator:StepAnimations(0.001)
			for _, bone in bones do
				local _, angle = bone.Transform:ToAxisAngle()
				if bone.Name == "FishBody" then
					assert(math.abs(angle) < 0.0001, "Head moved")
				elseif math.abs(angle) > 0.0001 then
					moved[bone] = true
				end
				local reference = fish.PrimaryPart:FindFirstChild(bone.Name, true)
				assert(reference.Transform:FuzzyEq(bone.Transform, 0.0001), "Material layers did not synchronize")
			end
		end
		for _, bone in bones do
			if bone.Name ~= "FishBody" then
				assert(moved[bone], "No articulation " .. bone:GetFullName() .. " " .. clip.Name)
			end
		end
		local seam = 0
		if track.Looped then
			track.TimePosition = 0
			animator:StepAnimations(0.00001)
			local first = {}
			for _, b in bones do
				first[b] = b.Transform
			end
			track.TimePosition = track.Length - 0.00002
			animator:StepAnimations(0.00001)
			for _, b in bones do
				local _, angle = first[b]:ToObjectSpace(b.Transform):ToAxisAngle()
				seam = math.max(seam, math.abs(angle))
			end
			assert(seam < 0.01, "Loop seam")
		end
		table.insert(playback, {
			name = clip.Name,
			id = clip.AnimationId,
			duration = track.Length,
			loop = track.Looped,
			seamRadians = seam,
		})
		track:Stop(0)
		track:Destroy()
		for _, b in bones do
			b.Transform = CFrame.identity
		end
		task.wait()
	end
	local vertexCount, skinParts = 0, 0
	local effective = {}
	local shellParts = 0
	for _, spec in data.parts do
		local part = assert(fish:FindFirstChild(spec.name))
		local mesh = assert(game.AssetService:CreateEditableMeshAsync(part.MeshContent), "Published mesh unreadable")
		local ok, err = xpcall(function()
			local boneNames = {}
			assert(#mesh:GetBones() == #data.bones, "Published bone count")
			for _, id in mesh:GetBones() do
				local name = mesh:GetBoneName(id)
				boneNames[id] = name
				local bone = assert(part:FindFirstChild(name, true))
				local parentId = mesh:GetBoneParent(id)
				assert(
					(parentId == 0 and bone.Parent == part)
						or (parentId ~= 0 and mesh:GetBoneName(parentId) == bone.Parent.Name),
					"Published parent mismatch"
				)
				local definition
				for _, candidate in data.bones do
					if candidate.name == name then
						definition = candidate
						break
					end
				end
				local authored =
					CFrame.new(Vector3.new(table.unpack(definition.position)) - Vector3.new(table.unpack(spec.center)))
				assert(
					part.CFrame:ToObjectSpace(bone.WorldCFrame):FuzzyEq(authored, 0.003),
					"Rig differs from authored bind " .. part.Name .. " " .. name
				)
				local bind = mesh:GetBoneCFrame(id)
				local expected = CFrame.new(bind.Position * part.Size / part.MeshSize) * bind.Rotation
				assert(
					part.CFrame:ToObjectSpace(bone.WorldCFrame):FuzzyEq(expected, 0.003),
					"Bind mismatch " .. part.Name .. " " .. name
				)
			end
			local rigid = {}
 local function positionKey(v)
 return string.format("%.3f,%.3f,%.3f", v.X, v.Y, v.Z)
 end
 for _,vi in spec.shellRigidVertices do
 rigid[positionKey(Vector3.new(table.unpack(spec.vertices[vi+1])))]=true
 end
 for index, id in mesh:GetVertices() do
				local ids = mesh:GetVertexBones(id)
				local weights = mesh:GetVertexBoneWeights(id)
				local total = 0
				for i, w in weights do
					assert(w >= 0 and w <= 1 and boneNames[ids[i]], "Invalid influence")
					total += w
					if w > 0.00001 then
						effective[boneNames[ids[i]]] = true
					end
					if rigid[positionKey(mesh:GetPosition(id))] and w > 0.00001 then
						assert(boneNames[ids[i]] == "SpineMid" and w > 0.99999, "Carapace is not rigid")
					end
				end
				assert(math.abs(total - 1) < 0.00001, "Weights not normalized")
				vertexCount += 1
				if index % 1500 == 0 then
					task.wait()
				end
			end
			if #spec.shellRigidVertices > 0 then
				shellParts += 1
			end
		end, debug.traceback)
		mesh:Destroy()
		assert(ok, err)
		skinParts += 1
		task.wait()
	end
	for _, b in data.bones do
		assert(effective[b.name], "No effective weights " .. b.name)
	end
	if data.family == "turtle" then
		assert(shellParts > 0, "Missing rigid carapace")
	end
	local settings = require(game.ReplicatedStorage.Modules.FishingConfig).Bite.Drip
	for _, name in settings.Points do
		local point = fish.PrimaryPart:FindFirstChild("FishDrip_" .. name, true)
		assert(point and point:IsA("Attachment") and point.Parent:IsA("Bone"), "Missing surface drip point " .. name)
	end
	assert(
		(fish:GetAttribute("FishBodySize") - Vector3.new(table.unpack(data.bodySize))).Magnitude < 0.001,
		"Whole size marker"
	)
	return {
		name = fish.Name,
		passed = true,
		meshes = skinParts,
		vertices = vertexCount,
		logicalBones = #data.bones,
		boneInstances = #bones,
		clips = playback,
		rigidCarapaceLayers = shellParts,
		dripPoints = 24,
		eyeScale = data.eye.scale,
	}
end

return inspect
