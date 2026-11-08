return function(name, clip, yaw)
	local old = workspace:FindFirstChild("_RaceVisualQA")
	if old then
		old:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = "_RaceVisualQA"
	folder.Parent = workspace
	local f = workspace._FishRace_Staging[name]:Clone()
	if not f:FindFirstChild("Animations") then
		local a = game.ReplicatedStorage.Animation.Fishing.RaceVariants[f:GetAttribute("RigVariant")]:Clone()
		a.Name = "Animations"
		a.Parent = f
	end
	for _, d in f:GetDescendants() do
		if d:IsA("Attachment") and not d:IsA("Bone") then
			d:Destroy()
		elseif d:IsA("Bone") then
			d.Transform = CFrame.identity
			d.Visible = false
		end
	end
	f.Parent = folder
	local _, size = f:GetBoundingBox()
	f:ScaleTo(f:GetScale() * 6 / math.max(size.X, size.Y, size.Z))
	f:PivotTo(CFrame.new(0, 1000, 0) * CFrame.Angles(0, math.rad(yaw or 90), 0))
	if clip then
		local animator = f:FindFirstChildWhichIsA("AnimationController"):FindFirstChildWhichIsA("Animator")
		local track = animator:LoadAnimation(f.Animations[clip])
		track:Play(0)
		local deadline = os.clock() + 8
		while track.Length == 0 and os.clock() < deadline do
			task.wait(0.05)
		end
		track.TimePosition = 0.15
		animator:StepAnimations(0.001)
		track:AdjustSpeed(0)
	end
	local center = f:GetBoundingBox().Position
	return { center.X, center.Y, center.Z }
end
