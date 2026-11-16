-- Sample actual published tracks on a temporary clone at both gameplay weights.
return function(source, published)
	local fish = source:Clone()
	fish.Parent = workspace
	local ok, result = xpcall(function()
		local body = fish.PrimaryPart
		local controller = fish:FindFirstChildOfClass("AnimationController")
		local animator = controller:FindFirstChildOfClass("Animator")
		local bones, bind = {}, {}
		for _, b in body:GetDescendants() do
			if b:IsA("Bone") then
				bones[b.Name] = b
				bind[b.Name] = b.WorldCFrame
			end
		end
		local function skin(sample)
			local rest = body.CFrame:PointToWorldSpace(Vector3.new(table.unpack(sample.position)))
			local moved = Vector3.zero
			for name, weight in sample.weights do
				local bone = bones[name]
				moved += bone.TransformedWorldCFrame:PointToWorldSpace(bind[name]:PointToObjectSpace(rest)) * weight
			end
			return moved
		end
		local clips = {}
		for _, clip in fish.Animations:GetChildren() do
			local name = clip.Name
			local track = animator:LoadAnimation(clip)
			track:Play(0, 1, 0)
			local deadline = os.clock() + 12
			while track.Length == 0 and os.clock() < deadline do
				task.wait()
			end
			assert(math.abs(track.Length - clip:GetAttribute("Duration")) < 0.015, name .. " duration")
			local entries = {}
			for _, weight in (if name == "SwimLoop" then { 0.4, 1 } else { 1 }) do
				track:AdjustWeight(weight, 0)
				for _, rate in { 30, 60 } do
					local feet, first, moved = {}, {}, {}
					local tailMin, tailMax = math.huge, -math.huge
					local seam = 0
					local steps = math.ceil(track.Length * rate)
					for i = 0, steps do
						track.TimePosition = math.min(i / rate, track.Length - 0.00002)
						animator:StepAnimations(0.00001)
						assert(bones.FishBody.Transform:FuzzyEq(CFrame.identity, 0.0001))
						for key, bone in bones do
							local _, angle = bone.Transform:ToAxisAngle()
							moved[key] = math.max(moved[key] or 0, math.abs(angle))
							if i == 0 then
								first[key] = bone.Transform
							elseif i == steps and track.Looped then
								local _, gap = first[key]:ToObjectSpace(bone.Transform):ToAxisAngle()
								seam = math.max(seam, math.abs(gap))
							end
						end
						for label, sample in published.samples do
							local vertex = skin(sample)
							if label == "Tail" then
								local x = body.CFrame:PointToObjectSpace(vertex).X
								tailMin, tailMax = math.min(tailMin, x), math.max(tailMax, x)
							else
								local root = bones[label .. "Leg"]
								local rear = root.Parent.TransformedWorldCFrame:VectorToObjectSpace(
									vertex - root.TransformedWorldCFrame.Position
								).Z
								feet[label] = math.min(feet[label] or math.huge, rear)
							end
						end
					end
					assert(seam < 0.015, name .. " loop seam")
					assert(moved.TailFinTip > 0.03 and tailMax - tailMin > 0.55, name .. " tail motion")
					if name == "SwimLoop" then
						for label, rear in feet do
							assert(rear > 0.1, label .. " failed rearward extension")
							assert(moved[label .. "Leg"] > 0.2 and moved[label .. "Joint"] > 0.05, label .. " inactive")
						end
					end
					table.insert(entries, {
						weight = weight,
						fps = rate,
						minFootBehindRoot = feet,
						loopSeamRadians = seam,
						tailLateralRange = tailMax - tailMin,
						samples = steps + 1,
					})
				end
			end
			track:Stop(0)
			track:Destroy()
			for _, bone in bones do
				bone.Transform = CFrame.identity
			end
			clips[name] = entries
		end
		return { passed = true, clips = clips }
	end, debug.traceback)
	fish:Destroy()
	assert(ok, result)
	return result
end
