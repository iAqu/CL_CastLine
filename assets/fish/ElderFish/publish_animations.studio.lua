-- Asset-authoring function: use animation_clips.baked.json for the dense struggle curves.
-- Publishes new versions as new group assets; not used by gameplay scripts.
return function(data, names)
	local sources = game.ServerStorage:FindFirstChild("FishAnimationSources")
	if not sources then
		sources = Instance.new("Folder")
		sources.Name, sources.Parent = "FishAnimationSources", game.ServerStorage
	end
	local folder = game.ReplicatedStorage.Animation.Fishing:FindFirstChild("Fish")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name, folder.Parent = "Fish", game.ReplicatedStorage.Animation.Fishing
	end
	local ids = {}
	for _, name in names or { "SwimLoop", "StruggleLeft", "StruggleRight", "LiftFlop", "ShowcaseFlop" } do
		local clip = data.clips[name]
		local sequence = Instance.new("KeyframeSequence")
		sequence.Name, sequence.Loop, sequence.Priority = name, clip.loop, Enum.AnimationPriority.Action
		local easing = clip.interpolation or "Cubic"
		sequence:SetAttribute("Interpolation", easing)
		sequence:SetAttribute("SampleRate", clip.sampleRate or 0)
		for _, frame in clip.frames do
			local key = Instance.new("Keyframe")
			key.Time = frame.time
			local parent = Instance.new("Pose")
			parent.Name, parent.Weight, parent.Parent = "polySurface5", 0, key
			for _, bone in data.bones do
				local pose = Instance.new("Pose")
				pose.Name = bone
				local matrix = frame.rotationMatrices and frame.rotationMatrices[bone]
				if matrix then
					pose.CFrame = CFrame.new(0, 0, 0, table.unpack(matrix))
				else
					local r = frame.rotations[bone]
					pose.CFrame = CFrame.Angles(math.rad(r[1]), math.rad(r[2]), math.rad(r[3]))
				end
				pose.EasingStyle, pose.EasingDirection = Enum.PoseEasingStyle[easing], Enum.PoseEasingDirection.InOut
				pose.Parent, parent = parent, pose
			end
			key.Parent = sequence
		end
		local status, id = game:GetService("AssetService"):CreateAssetAsync(sequence, Enum.AssetType.Animation, {
			CreatorId = game.CreatorId, CreatorType = Enum.AssetCreatorType.Group,
			Name = "Elder Fish " .. name, Description = "Authored five-bone fish animation; fixed head and delayed tail.",
		})
		assert(status == Enum.CreateAssetResult.Success, tostring(status) .. ": " .. tostring(id))
		local previous = sources:FindFirstChild(name)
		if previous then
			local asset = folder:FindFirstChild(name)
			if asset then previous:SetAttribute("PreviousAnimationId", asset.AnimationId) end
			previous.Name = name .. "_Previous_" .. os.date("!%Y%m%d_%H%M%S")
		end
		sequence.Parent = sources
		local animation = folder:FindFirstChild(name) or Instance.new("Animation")
		local baseline = animation:GetAttribute("SparseBaselineAnimationId")
			or (if animation:GetAttribute("Interpolation") == "Linear"
				then animation:GetAttribute("PreviousAnimationId") else animation.AnimationId)
		if baseline and baseline ~= "" then animation:SetAttribute("SparseBaselineAnimationId", baseline) end
		if animation.AnimationId ~= "" then animation:SetAttribute("PreviousAnimationId", animation.AnimationId) end
		animation.Name, animation.AnimationId = name, "rbxassetid://" .. id
		animation:SetAttribute("Duration", clip.duration)
		animation:SetAttribute("Interpolation", easing)
		animation:SetAttribute("SampleRate", clip.sampleRate or 0)
		animation.Parent, ids[name] = folder, id
		task.wait()
	end
	return ids
end
