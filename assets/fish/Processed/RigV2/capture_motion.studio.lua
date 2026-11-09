--# selene: allow(global_usage)
local http = game:GetService("HttpService")
local provider = game:GetService("AnimationClipProvider")
local base = "http://127.0.0.1:18776/"
local catalog = http:JSONDecode(http:GetAsync(base .. "inventory.json"))
local templates = game.ReplicatedStorage.Models.Fish
local previous = _G.RigV2Baseline
local job = { done = false, captured = previous and previous.captured or 0, errors = {} }
_G.RigV2Baseline = job
local clips = {}
local function loadClip(id, root, variant, name)
	local key = id .. "/" .. root
	if clips[key] then
		return clips[key]
	end
	local sequence = provider:GetAnimationClipAsync(id)
	assert(sequence:IsA("KeyframeSequence"), "Unsupported original clip class")
	local keys = sequence:GetKeyframes()
	if #keys == 0 then
		for _, group in game.ServerStorage.FishAnimationSources:GetChildren() do
			local folder = group:FindFirstChild(variant)
			local saved = folder and folder:FindFirstChild(name)
			if saved and saved:IsA("KeyframeSequence") then
				sequence, keys = saved, saved:GetKeyframes()
				break
			end
		end
	end
	assert(#keys > 0, "No baseline keyframes for " .. name)
	local frames = {}
	for _, frame in keys do
		local rootPose = frame:FindFirstChild(root)
		local values = {}
		if rootPose then
			for _, pose in rootPose:GetDescendants() do
				if pose:IsA("Pose") then
					local components = { pose.CFrame:GetComponents() }
					values[pose.Name] = { table.unpack(components, 4) }
				end
			end
		end
		table.insert(frames, { time = frame.Time, rotationMatrices = values })
	end
	table.sort(frames, function(a, b)
		return a.time < b.time
	end)
	local data = { duration = frames[#frames].time, loop = sequence.Loop, frames = frames }
	clips[key] = data
	return data
end
task.spawn(function()
	for _, entry in catalog.rows do
		if previous and not previous.errors[entry.name] then
			continue
		end
		job.current = entry.name
		local ok, reason = pcall(function()
			local fish = templates[entry.name]
			local clipsByName, binds = {}, {}
			for _, child in fish.Animations:GetChildren() do
				if child:IsA("Animation") then
					clipsByName[child.Name] =
						loadClip(child.AnimationId, fish.PrimaryPart.Name, entry.attributes.RigVariant, child.Name)
				end
			end
			for _, bone in fish.PrimaryPart:GetDescendants() do
				if bone:IsA("Bone") then
					local c = { fish.PrimaryPart.CFrame:ToObjectSpace(bone.WorldCFrame):GetComponents() }
					binds[bone.Name] = { table.unpack(c, 4) }
				end
			end
			http:PostAsync(
				base .. "old-motion/" .. entry.key .. ".json",
				http:JSONEncode({ clips = clipsByName, bindRotations = binds }),
				Enum.HttpContentType.ApplicationJson
			)
		end)
		if ok then
			job.captured += 1
		else
			job.errors[entry.name] = reason
		end
		task.wait()
	end
	job.done = true
	http:PostAsync(base .. "baseline-status.json", http:JSONEncode(job), Enum.HttpContentType.ApplicationJson)
end)
return "Reading current published animation curves"
