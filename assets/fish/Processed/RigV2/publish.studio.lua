--# selene: allow(global_usage)
-- Edit-time authoring; only cloned templates are changed.
return function(onlyPilots, options)
	options = options or {}
	local http, assets = game:GetService("HttpService"), game:GetService("AssetService")
	local base = "http://127.0.0.1:18776/"
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	assert(not (_G.RigV2Publication and not _G.RigV2Publication.done), "Publication already running")
	local function read(path)
		if options.read then
			return options.read(path)
		end
		return http:JSONDecode(http:GetAsync(base .. path))
	end
	local function post(path, data)
		if options.post then
			options.post(path, data)
			return
		end
		http:PostAsync(base .. path, http:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end
	local function folder(parent, name)
		local f = parent:FindFirstChild(name) or Instance.new("Folder")
		f.Name, f.Parent = name, parent
		return f
	end
	local stage = folder(workspace, options.stageName or "_RigV2Stage")
	local sources = folder(game.ServerStorage.FishAnimationSources, "RigV2")
	local libraries = folder(game.ReplicatedStorage.Animation.Fishing, "RigV2")
	local templates = options.templates or game.ReplicatedStorage.Models.Fish
	local listParts = assert(options.listParts or _G.RigV2ListParts, "Run the source capture first")
	local okCache, cache = pcall(read, "asset-cache.json")
	if not okCache then
		cache = {}
	end
	local job = { done = false, errors = {}, results = {}, mode = if onlyPilots then "pilots" else "all" }
	_G.RigV2Publication = job
	local nextUpload = 0
	local function publish(key, item, kind, name)
		if cache[key] then
			return cache[key]
		end
		for attempt = 1, 14 do
			task.wait(math.max(0, nextUpload - os.clock()))
			nextUpload = os.clock() + 4
			local ok, status, id = pcall(function()
				return assets:CreateAssetAsync(item, kind, {
					CreatorId = game.CreatorId,
					CreatorType = Enum.AssetCreatorType.Group,
					Name = name,
					Description = "CastLine Rig V2: articulated body, tail and appendages.",
				})
			end)
			if ok and status == Enum.CreateAssetResult.Success then
				cache[key] = id
				post("asset-cache.json", cache)
				job.waiting = nil
				return id
			end
			local message = tostring(status) .. ":" .. tostring(id)
			assert(message:find("429") or message:find("5%d%d") or message:lower():find("timeout"), message)
			job.waiting = { asset = name, attempt = attempt, error = message }
			task.wait(math.min(60, 10 * 2 ^ (attempt - 1)))
		end
		error("Publication retry limit: " .. name)
	end
	local function library(rig)
		local prior = libraries:FindFirstChild(rig.variant)
		if prior then
			assert(#prior:GetChildren() == 5, "Incomplete variant")
			return prior
		end
		local recipe = read("motions/" .. rig.variant .. ".json")
		local clips = Instance.new("Folder")
		clips.Name = rig.variant
		local seqFolder = folder(sources, rig.variant)
		for _, name in { "SwimLoop", "StruggleLeft", "StruggleRight", "LiftFlop", "ShowcaseFlop" } do
			local clip = recipe.clips[name]
			local sequence = seqFolder:FindFirstChild(name)
			if not sequence then
				sequence = Instance.new("KeyframeSequence")
				sequence.Name, sequence.Loop = name, clip.loop
				sequence.Priority = Enum.AnimationPriority.Action
				for i, frame in clip.frames do
					local key = Instance.new("Keyframe")
					key.Time, key.Parent = frame.time, sequence
					for _, partName in recipe.partNames do
						local root = Instance.new("Pose")
						root.Name, root.Weight, root.Parent = partName, 0, key
						local poses = {}
						for index, bone in recipe.bones do
							local pose = Instance.new("Pose")
							pose.Name = bone.name
							pose.CFrame = CFrame.new(0, 0, 0, table.unpack(frame.rotationMatrices[bone.name]))
							pose.EasingStyle = Enum.PoseEasingStyle.Linear
							pose.Parent = poses[bone.parent + 1] or root
							poses[index] = pose
						end
					end
					if i % 8 == 0 then
						task.wait()
					end
				end
				sequence.Parent = seqFolder
			end
			local id = publish(
				rig.variant .. "/" .. name,
				sequence,
				Enum.AssetType.Animation,
				"CastLine " .. rig.variant .. " " .. name
			)
			local clipInstance = Instance.new("Animation")
			clipInstance.Name, clipInstance.AnimationId, clipInstance.Parent = name, "rbxassetid://" .. id, clips
			clipInstance:SetAttribute("Duration", clip.duration)
		end
		clips.Parent = libraries
		return clips
	end
	local function upgradePart(part, primary, rig, index)
		local spec = rig.parts[index]
		assert(part.Name == spec.name and part.MeshId == (spec.baseMesh or spec.mesh), "Source changed during build")
		local definition = read(("payload/%s/part%03d.json"):format(rig.key, index))
		local localFrame = CFrame.new(table.unpack(spec.frame))
		local size, meshSize = part.Size, part.MeshSize
		local oldTexture, oldCF = part.TextureContent, part.CFrame
		local oldRender = part.RenderFidelity
		local ratio = size / meshSize
		local binds = {}
		for i, bone in rig.bones do
			local frame = localFrame:ToObjectSpace(CFrame.new(Vector3.new(table.unpack(bone.position))))
			binds[i] = CFrame.new(frame.Position / ratio) * frame.Rotation
		end
		local id = cache[spec.recipe]
		if not id then
			local content = if spec.baseMesh then Content.fromUri(spec.mesh) else part.MeshContent
			local editable =
				assert(assets:CreateEditableMeshAsync(content, { FixedSize = false }), "Source mesh unreadable")
			local ok, value = xpcall(function()
				local oldBones = editable:GetBones()
				for i = #oldBones, 1, -1 do
					editable:RemoveBone(oldBones[i])
				end
				local ids = {}
				for i, b in rig.bones do
					ids[i] = editable:AddBone({
						Name = b.name,
						ParentId = ids[b.parent + 1],
						CFrame = binds[i],
						Virtual = false,
					})
				end
				local vertices = editable:GetVertices()
				assert(#vertices == spec.vertexCount, "Vertex order changed")
				for i, position in spec.vertexChecks or {} do
					assert(
						(editable:GetPosition(vertices[tonumber(i)]) - Vector3.new(table.unpack(position))).Magnitude
							< 0.00002,
						"Vertex order changed"
					)
				end
				for i, vertex in vertices do
					local jointIds, values = {}, {}
					for j = (i - 1) * 4 + 1, i * 4 do
						local w = definition.weights[j]
						if w > 0 then
							table.insert(jointIds, ids[definition.indices[j] + 1])
							table.insert(values, w)
						end
					end
					editable:SetVertexBones(vertex, jointIds)
					editable:SetVertexBoneWeights(vertex, values)
					if i % 4096 == 0 then
						task.wait()
					end
				end
				return publish(
					spec.recipe,
					editable,
					Enum.AssetType.Mesh,
					("CastLine V2 %s %s"):format(rig.name, part.Name)
				)
			end, debug.traceback)
			editable:Destroy()
			assert(ok, value)
			id = value
		end
		local published = assets:CreateMeshPartAsync(
			Content.fromAssetId(id),
			{ RenderFidelity = oldRender, CollisionFidelity = part.CollisionFidelity }
		)
		assert(published.HasSkinnedMesh, "Published mesh lost its skin")
		local attachments = {}
		for _, item in part:GetDescendants() do
			if item:IsA("Attachment") and not item:IsA("Bone") and item.Parent:IsA("Bone") then
				table.insert(
					attachments,
					{ instance = item, frame = part.CFrame:ToObjectSpace(item.WorldCFrame), bone = item.Parent.Name }
				)
			end
		end
		for _, item in attachments do
			item.instance.Parent = part
		end
		for _, child in part:GetChildren() do
			if child:IsA("Bone") then
				child:Destroy()
			end
		end
		part:ApplyMesh(published)
		part.Size, part.CFrame, part.TextureContent = size, oldCF, oldTexture
		published:Destroy()
		local instances, frames, named = {}, {}, {}
		for i, b in rig.bones do
			local bind = binds[i]
			local frame = CFrame.new(bind.Position * size / part.MeshSize) * bind.Rotation
			local parent = instances[b.parent + 1]
			local joint = Instance.new("Bone")
			joint.Name = b.name
			joint.CFrame = if parent then frames[b.parent + 1]:ToObjectSpace(frame) else frame
			joint.Parent = parent or part
			instances[i], frames[i], named[b.name] = joint, frame, joint
		end
		local drip = {}
		if part == primary then
			for _, rec in rig.drip do
				drip[rec.name] = rec.bone
			end
		end
		for _, attachment in attachments do
			local target = named[drip[attachment.instance.Name] or attachment.bone] or instances[1]
			attachment.instance.Parent = target
			attachment.instance.CFrame = target.WorldCFrame:ToObjectSpace(part.CFrame * attachment.frame)
		end
		return { name = part.Name, id = part.MeshId, vertices = spec.vertexCount }
	end
	local function author(entry)
		local rig = read("payload/" .. entry.key .. "/rig.json")
		assert(#rig.weak == 0, "Ineffective joints: " .. table.concat(rig.weak, ", "))
		local old = templates[rig.name]
		local clone = old:Clone()
		local ok, report = xpcall(function()
			local clips = library(rig):Clone()
			local meshIds = {}
			for i, part in listParts(clone) do
				job.part = i
				table.insert(meshIds, upgradePart(part, clone.PrimaryPart, rig, i))
			end
			clone.Animations:Destroy()
			clips.Name, clips.Parent = "Animations", clone
			clone:SetAttribute("RigVersion", 2)
			clone:SetAttribute("LogicalBoneCount", #rig.bones)
			clone:SetAttribute("RigVariant", rig.variant)
			local boundsOk, bounds = pcall(read, "bounds/" .. rig.key .. ".json")
			assert(boundsOk and bounds.radius > 0, "Measured animation radius required")
			clone:SetAttribute("PresentationRadius", bounds.radius)
			clone:SetAttribute("RigV2Key", rig.key)
			clone:PivotTo(
				CFrame.new(
					430 + ((entry.pilot or tonumber(entry.key:sub(4))) - 1) % 8 * 40,
					26,
					120 + math.floor(tonumber(entry.key:sub(4)) / 8) * 40
				)
			)
			local replaced = stage:FindFirstChild(clone.Name)
			clone.Parent = stage
			if replaced then
				replaced:Destroy()
			end
			local animationIds = {}
			for _, a in clips:GetChildren() do
				animationIds[a.Name] = a.AnimationId
			end
			return {
				name = rig.name,
				key = rig.key,
				meshes = meshIds,
				bones = #rig.bones,
				animations = animationIds,
				variant = rig.variant,
			}
		end, debug.traceback)
		if not ok then
			clone:Destroy()
			error(report)
		end
		return report
	end
	task.spawn(function()
		local ok, reason = xpcall(function()
			for _, entry in read("inventory.json").rows do
				if onlyPilots and not entry.pilot then
					continue
				end
				local staged = stage:FindFirstChild(entry.name)
				if staged then
					local current = read("payload/" .. entry.key .. "/rig.json")
					local matches = staged:GetAttribute("RigVariant") == current.variant
					for i, part in listParts(staged) do
						matches = matches and part.MeshId == "rbxassetid://" .. tostring(cache[current.parts[i].recipe])
					end
					if matches then
						continue
					end
				end
				job.current, job.part = entry.name, 0
				local passed, result = xpcall(function()
					return author(entry)
				end, debug.traceback)
				if passed then
					job.results[entry.name] = result
				else
					job.errors[entry.name] = result
				end
				post("publication-" .. job.mode .. ".json", job)
			end
		end, debug.traceback)
		if not ok then
			job.fatal = reason
		end
		job.done = true
		post("publication-" .. job.mode .. ".json", job)
	end)
	return { started = true, mode = job.mode }
end
