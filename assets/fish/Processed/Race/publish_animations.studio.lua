-- Publish one family; all material-layer roots receive identical articulated poses.
return function(variant)
	local h = game.HttpService
	local data = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/motions/" .. variant .. ".json"))
	local sourceRoot = game.ServerStorage.FishAnimationSources:FindFirstChild("Race")
	if not sourceRoot then
		sourceRoot = Instance.new("Folder")
		sourceRoot.Name = "Race"
		sourceRoot.Parent = game.ServerStorage.FishAnimationSources
	end
	local library = game.ReplicatedStorage.Animation.Fishing:FindFirstChild("RaceVariants")
	if not library then
		library = Instance.new("Folder")
		library.Name = "RaceVariants"
		library.Parent = game.ReplicatedStorage.Animation.Fishing
	end
	assert(not library:FindFirstChild(variant), "Already published " .. variant)
	local sources = Instance.new("Folder")
	sources.Name = variant
	sources.Parent = sourceRoot
	local folder = Instance.new("Folder")
	folder.Name = variant
	local ids = {}
	for _, name in { "SwimLoop", "StruggleLeft", "StruggleRight", "LiftFlop", "ShowcaseFlop" } do
		local clip = data.clips[name]
		local sequence = Instance.new("KeyframeSequence")
		sequence.Name = name
		sequence.Loop = clip.loop
		sequence.Priority = Enum.AnimationPriority.Action
		sequence.Parent = sources
		for fi, frame in clip.frames do
			local key = Instance.new("Keyframe")
			key.Time = frame.time
			key.Parent = sequence
			for pi = 1, data.partCount do
				local root = Instance.new("Pose")
				root.Name = if pi == 1 then "polySurface5" else string.format("FishMesh%02d", pi)
				root.Weight = 0
				root.Parent = key
				local poses = {}
				for bi, b in data.bones do
					local p = Instance.new("Pose")
					p.Name = b.name
					p.CFrame = CFrame.new(0, 0, 0, table.unpack(frame.rotationMatrices[b.name]))
					p.EasingStyle = Enum.PoseEasingStyle[clip.interpolation]
					p.EasingDirection = Enum.PoseEasingDirection.InOut
					p.Parent = poses[b.parent + 1] or root
					poses[bi] = p
				end
			end
			if fi % 4 == 0 then
				task.wait()
			end
		end
		local status, id = game.AssetService:CreateAssetAsync(sequence, Enum.AssetType.Animation, {
			CreatorId = game.CreatorId,
			CreatorType = Enum.AssetCreatorType.Group,
			Name = "CastLine " .. variant .. " " .. name,
			Description = "Elder timing adapted to coherent multi-mesh fish and species-specific appendages.",
		})
		assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ":" .. tostring(id))
		local a = Instance.new("Animation")
		a.Name = name
		a.AnimationId = "rbxassetid://" .. id
		a:SetAttribute("Duration", clip.duration)
		a.Parent = folder
		ids[name] = id
		task.wait()
	end
	folder.Parent = library
	return { variant = variant, partCount = data.partCount, logicalBones = #data.bones, animations = ids }
end
