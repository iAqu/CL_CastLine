return function(batch, yaw, clip)
	local h = game.HttpService
	local manifest = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/source-manifest.json"))
	local old = workspace:FindFirstChild("_RaceVisualQA")
	if old then
		old:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = "_RaceVisualQA"
	folder.Parent = workspace
	local names = {}
	for i = (batch - 1) * 5 + 1, math.min(batch * 5, #manifest.fish) do
		local name = manifest.fish[i].name
		local source = workspace._FishRace_Staging:FindFirstChild(name)
		assert(source, "Fish not ready " .. name)
		local fish = source:Clone()
		if not fish:FindFirstChild("Animations") then
			local a = game.ReplicatedStorage.Animation.Fishing.RaceVariants[fish:GetAttribute("RigVariant")]:Clone()
			a.Name = "Animations"
			a.Parent = fish
		end
		for _, d in fish:GetDescendants() do
			if d:IsA("Attachment") and not d:IsA("Bone") then
				d:Destroy()
			elseif d:IsA("Bone") then
				d.Transform = CFrame.identity
				d.Visible = false
			end
		end
		fish.Parent = folder
		local _, size = fish:GetBoundingBox()
		fish:ScaleTo(fish:GetScale() * 6 / math.max(size.X, size.Y, size.Z))
		fish:PivotTo(CFrame.Angles(0, math.rad(yaw), 0))
		local index = (i - 1) % 5
		local target = Vector3.new((index % 3 - 1) * 8, 1003 - math.floor(index / 3) * 6, 0)
		local frame = fish:GetBoundingBox()
		fish:PivotTo(fish:GetPivot() + target - frame.Position)
		if clip then
			local animator = fish:FindFirstChildWhichIsA("AnimationController"):FindFirstChildWhichIsA("Animator")
			local track = animator:LoadAnimation(fish.Animations[clip])
			track:Play(0)
			local deadline = os.clock() + 8
			while track.Length == 0 and os.clock() < deadline do
				task.wait(0.05)
			end
			track.TimePosition = 0.15
			animator:StepAnimations(0.001)
			track:AdjustSpeed(0)
		end
		table.insert(names, name)
	end
	return names
end
