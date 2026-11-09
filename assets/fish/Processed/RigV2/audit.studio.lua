--# selene: allow(global_usage)
return function(onlyPilots, onlyNames)
	local http, assets = game:GetService("HttpService"), game:GetService("AssetService")
	local base = "http://127.0.0.1:18776/"
	local function read(path)
		return http:JSONDecode(http:GetAsync(base .. path))
	end
	local function post(path, data)
		http:PostAsync(base .. path, http:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end
	local settings = require(game.ReplicatedStorage.Modules.FishingConfig).Bite
	local listParts = _G.RigV2ListParts
	local stage = workspace._RigV2Stage
	local originals = game.ReplicatedStorage.Models.Fish
	local job = { done = false, results = {}, errors = {} }
	local historyOk, history = pcall(read, if onlyNames then "audit-all.json" else "audit-pilots.json")
	if not onlyPilots and historyOk then
		for name, item in history.results do
			job.results[name] = item
		end
	end
	_G.RigV2Audit = job
	local function audit(fish)
		local rig = read("payload/" .. fish:GetAttribute("RigV2Key") .. "/rig.json")
		assert(fish:GetAttribute("RigVariant") == rig.variant, "Stage holds an obsolete prototype")
		local old = originals[fish.Name]
		local parts, oldParts = listParts(fish), listParts(old)
		assert(#parts == #oldParts and #parts == #rig.parts, "Mesh count changed")
		assert(fish.PrimaryPart.MouthAttachment.Position == old.PrimaryPart.MouthAttachment.Position, "Mouth shifted")
		local examples, joints, effective, count = {}, {}, {}, 0
		for i, part in parts do
			local spec, previous = rig.parts[i], oldParts[i]
			assert(
				part.Size == previous.Size
					and part.TextureID == previous.TextureID
					and part.Color == previous.Color
					and part.Material == previous.Material
					and part.Transparency == previous.Transparency
					and part.MaterialVariant == previous.MaterialVariant
					and part.DoubleSided == previous.DoubleSided,
				"Appearance or dimensions changed"
			)
			assert((part.MeshSize - previous.MeshSize).Magnitude < 0.005, "Neutral mesh bounds changed")
			local bodyRelative = fish.PrimaryPart.CFrame:ToObjectSpace(part.CFrame)
			assert(bodyRelative:FuzzyEq(CFrame.new(table.unpack(spec.frame)), 0.002), "Mesh alignment changed")
			local mesh = assert(assets:CreateEditableMeshAsync(part.MeshContent), "Published mesh unreadable")
			local ok, reason = xpcall(function()
				local names, byId = {}, {}
				local boneIds = mesh:GetBones()
				assert(#boneIds == #rig.bones, "Missing published joints")
				local definitions = {}
				for _, b in rig.bones do
					definitions[b.name] = b
				end
				for _, id in boneIds do
					local n = mesh:GetBoneName(id)
					local b = assert(part:FindFirstChild(n, true), "Bone instance missing")
					names[n], byId[id] = b, b
					table.insert(joints, b)
					assert(b:IsA("Bone"), "Bone class changed")
					local bind = mesh:GetBoneCFrame(id)
					local actual = part.CFrame:ToObjectSpace(b.WorldCFrame)
					local expected = CFrame.new(bind.Position * part.Size / part.MeshSize) * bind.Rotation
					assert(actual:FuzzyEq(expected, 0.003), "Bind pose mismatch")
					local authored = Vector3.new(table.unpack(definitions[n].position))
					assert(
						(fish.PrimaryPart.CFrame:PointToObjectSpace(b.WorldPosition) - authored).Magnitude < 0.005,
						"Layer bind differs"
					)
					local parentId = mesh:GetBoneParent(id)
					assert(
						(if parentId == 0 then part else part:FindFirstChild(mesh:GetBoneName(parentId), true))
							== b.Parent,
						"Mesh hierarchy differs"
					)
				end
				local verts = mesh:GetVertices()
				assert(#verts == spec.vertexCount, "Vertex count changed")
				for index, vertex in verts do
					local ids, values = mesh:GetVertexBones(vertex), mesh:GetVertexBoneWeights(vertex)
					local total = 0
					for k, id in ids do
						local w = values[k]
						assert(w >= 0 and w <= 1 and byId[id], "Invalid skin weight")
						total += w
						local n = byId[id].Name
						if part.Transparency < 1 and w > (effective[n] or 0) then
							effective[n] = w
							if w >= 0.10 then
								local rest =
									part.CFrame:PointToWorldSpace(mesh:GetPosition(vertex) * part.Size / part.MeshSize)
								local influences = {}
								for q, j in ids do
									influences[q] = {
										joint = byId[j],
										point = byId[j].WorldCFrame:PointToObjectSpace(rest),
										weight = values[q],
									}
								end
								examples[n] = { rest = rest, influences = influences }
							end
						end
					end
					assert(math.abs(total - 1) < 0.0001, "Weights do not sum to one")
					if index % 4096 == 0 then
						task.wait()
					end
				end
				count += #verts
			end, debug.traceback)
			mesh:Destroy()
			assert(ok, reason)
		end
		for _, b in rig.bones do
			assert((effective[b.name] or 0) >= 0.09, "No effective mesh influence " .. b.name)
		end
		for _, name in settings.Drip.Points do
			local point = fish.PrimaryPart:FindFirstChild("FishDrip_" .. name, true)
			assert(point and point:IsA("Attachment") and point.Parent:IsA("Bone"), "Invalid drip point")
		end
		local animator = fish:FindFirstChildWhichIsA("AnimationController"):FindFirstChildWhichIsA("Animator")
		local clips = {}
		for _, clip in fish.Animations:GetChildren() do
			local track = animator:LoadAnimation(clip)
			track:Play(0, 1, 0)
			local deadline = os.clock() + 12
			while track.Length == 0 and os.clock() < deadline do
				task.wait(0.05)
			end
			assert(
				math.abs(track.Length - settings.Motion.Animation.Clips[clip.Name].Duration) < 0.025,
				"Clip failed to load or changed duration"
			)
			local maxAngles, displacements = {}, {}
			local samples = {}
			for _, rate in { 30, 60 } do
				local n = math.ceil(track.Length * rate)
				local prior = {}
				local maxStep = 0
				for sample = 0, n do
					track.TimePosition = math.min(sample / rate, track.Length - 0.00002)
					animator:StepAnimations(0.00001)
					for _, joint in joints do
						local reference = fish.PrimaryPart:FindFirstChild(joint.Name, true)
						assert(reference.Transform:FuzzyEq(joint.Transform, 0.001), "Layer pose mismatch")
						local _, angle = joint.Transform:ToAxisAngle()
						maxAngles[joint.Name] = math.max(maxAngles[joint.Name] or 0, math.abs(angle))
					end
					for name, example in examples do
						local pos = Vector3.zero
						for _, influence in example.influences do
							pos += influence.joint.TransformedWorldCFrame:PointToWorldSpace(influence.point) * influence.weight
						end
						displacements[name] = math.max(displacements[name] or 0, (pos - example.rest).Magnitude)
						if prior[name] then
							maxStep = math.max(maxStep, (pos - prior[name]).Magnitude)
						end
						prior[name] = pos
					end
				end
				samples[tostring(rate)] = { samples = n + 1, maxVertexStep = maxStep }
			end
			local seam = 0
			if track.Looped then
				track.TimePosition = 0
				animator:StepAnimations(0.00001)
				local start = {}
				for _, b in joints do
					start[b] = b.Transform
				end
				track.TimePosition = track.Length - 0.00003
				animator:StepAnimations(0.00001)
				for _, b in joints do
					local _, angle = start[b]:ToObjectSpace(b.Transform):ToAxisAngle()
					seam = math.max(seam, math.abs(angle))
				end
				assert(seam < 0.01, "Loop has a pose seam")
			end
			track:Stop(0)
			track:Destroy()
			for _, b in joints do
				b.Transform = CFrame.identity
			end
			assert(maxAngles.FishBody < 0.0001 and (displacements.FishBody or 0) < 0.001, "Protected head moved")
			local tail = rig.bones[rig.main[#rig.main] + 1].name
			assert(maxAngles[tail] > 0.03 and displacements[tail] > 0.01, "Tail did not bend independently")
			clips[clip.Name] = {
				id = clip.AnimationId,
				length = settings.Motion.Animation.Clips[clip.Name].Duration,
				loopSeam = seam,
				tail = tail,
				tailAngle = maxAngles[tail],
				tailVertexDisplacement = displacements[tail],
				sampleRates = samples,
			}
			task.wait()
		end
		assert(#fish.Animations:GetChildren() == 5, "Five clips are required")
		return {
			name = fish.Name,
			variant = rig.variant,
			passed = true,
			bones = #rig.bones,
			boneInstances = #joints,
			vertices = count,
			clips = clips,
		}
	end
	task.spawn(function()
		local ok, reason = xpcall(function()
			local manifest = read("inventory.json")
			local pending = {}
			for _, entry in manifest.rows do
				if (not onlyPilots or entry.pilot) and (not onlyNames or onlyNames[entry.name]) then
					pending[entry.name] = read("payload/" .. entry.key .. "/rig.json").variant
				end
			end
			while next(pending) do
				local live = _G.RigV2Publication
				for _, entry in manifest.rows do
					if not pending[entry.name] then
						continue
					end
					local fish = stage:FindFirstChild(entry.name)
					local variant = pending[entry.name]
					if not fish or fish:GetAttribute("RigVariant") ~= variant then
						if live and not live.done then
							continue
						end
						job.errors[entry.name] = "Expected staged rig is absent"
					else
						local prior = job.results[entry.name]
						if onlyNames or not prior or not prior.passed or prior.variant ~= variant then
							job.current = entry.name
							local passed, result = xpcall(function()
								return audit(fish)
							end, debug.traceback)
							if passed then
								job.results[entry.name] = result
							else
								job.errors[entry.name] = result
							end
						end
					end
					pending[entry.name] = nil
					post(if onlyPilots then "audit-pilots.json" else "audit-all.json", job)
				end
				if next(pending) then
					task.wait(3)
				end
			end
		end, debug.traceback)
		if not ok then
			job.fatal = reason
		end
		job.done = true
		post(if onlyPilots then "audit-pilots.json" else "audit-all.json", job)
	end)
	return "Started v2 asset audit"
end
