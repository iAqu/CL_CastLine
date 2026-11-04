-- Edit-time authoring validation; not a runtime game Script.
local job = { done = false, results = {}, errors = {} }
_G.FishValidationJob = job
task.spawn(function()
	local list = workspace.Fish_Processed:GetChildren()
	table.sort(list, function(a, b)
		return a.Name < b.Name
	end)
	for _, fish in list do
		job.current = fish.Name
		local ok, result = xpcall(function()
			local animator =
				assert(fish:FindFirstChildWhichIsA("AnimationController")):FindFirstChildWhichIsA("Animator")
			local parts = {}
			local bones = {}
			for _, p in fish:GetDescendants() do
				if p:IsA("MeshPart") then
					assert(p.HasSkinnedMesh, fish.Name .. " unskinned " .. p.Name)
					table.insert(parts, p)
				end
				if p:IsA("Bone") then
					table.insert(bones, p)
					p.Transform = CFrame.identity
				end
			end
			assert(#bones == #parts * fish:GetAttribute("LogicalBoneCount"), "Bone count mismatch")
			assert(fish.PrimaryPart:FindFirstChild("MouthAttachment"), "Missing mouth")
			local records = {}
			for _, clip in fish.Animations:GetChildren() do
				local track = animator:LoadAnimation(clip)
				track:Play(0, 1, 1)
				local deadline = os.clock() + 15
				while track.Length == 0 and os.clock() < deadline do
					task.wait(0.1)
				end
				assert(track.Length > 0, "Clip failed to load " .. clip.Name)
				local moved = {}
				local maxAngle = 0
				for i = 0, 12 do
					track.TimePosition = track.Length * (i / 13)
					animator:StepAnimations(0.001)
					for _, b in bones do
						local _, angle = b.Transform:ToAxisAngle()
						if b.Name == "FishBody" then
							assert(math.abs(angle) < 0.0001, "Head moved")
						elseif math.abs(angle) > 0.001 then
							moved[b] = true
							maxAngle = math.max(maxAngle, math.abs(angle))
						end
						local reference = fish.PrimaryPart:FindFirstChild(b.Name, true)
						assert(
							reference and reference.Transform:FuzzyEq(b.Transform, 0.0001),
							"Part animation mismatch " .. b:GetFullName()
						)
					end
				end
				local count = 0
				for _, b in bones do
					if b.Name ~= "FishBody" then
						assert(moved[b], "No articulation " .. b:GetFullName() .. " " .. clip.Name)
						count += 1
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
						local _, a = first[b]:ToObjectSpace(b.Transform):ToAxisAngle()
						seam = math.max(seam, math.abs(a))
					end
					assert(seam < 0.01, "Loop seam " .. seam)
				end
				table.insert(
					records,
					{
						name = clip.Name,
						assetId = clip.AnimationId,
						duration = track.Length,
						movingBoneInstances = count,
						maxAngle = maxAngle,
						loopSeamRadians = seam,
						loop = track.Looped,
					}
				)
				track:Stop(0)
				track:Destroy()
				for _, b in bones do
					b.Transform = CFrame.identity
				end
				task.wait()
			end
			assert(#records == 5, "Expected five animations")
			return {
				name = fish.Name,
				passed = true,
				parts = #parts,
				boneInstances = #bones,
				logicalBones = fish:GetAttribute("LogicalBoneCount"),
				clips = records,
			}
		end, debug.traceback)
		if ok then
			table.insert(job.results, result)
		else
			table.insert(job.errors, { name = fish.Name, error = result })
		end
		for _, b in fish:GetDescendants() do
			if b:IsA("Bone") then
				b.Transform = CFrame.identity
			end
		end
		task.wait()
	end
	job.done = true
end)
return "Started all 140 animation and multipart binding checks"
