--# selene: allow(global_usage)
assert(not game:GetService("RunService"):IsRunning(), "Export persistent resources in Edit mode")
local h = game:GetService("HttpService")
local serializer = game:GetService("SerializationService")
local manifest = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/source-manifest.json"))
local newFish = {}
local function describe(root)
	local fish, meshes, animations, bones, points, sequences, keyframes = 0, 0, 0, 0, 0, 0, 0
	local ids = {}
	for _, model in root:GetChildren() do
		if model:IsA("Model") then
			fish += 1
			assert(model.PrimaryPart and model.PrimaryPart.MouthAttachment, "Lost primary/mouth")
		end
	end
	for _, item in root:GetDescendants() do
		if item:IsA("MeshPart") then
			meshes += 1
			table.insert(
				ids,
				item:GetFullName():sub(#root:GetFullName() + 1) .. "|" .. item.MeshId .. "|" .. item.TextureID
			)
		elseif item:IsA("Animation") then
			animations += 1
			table.insert(ids, item:GetFullName():sub(#root:GetFullName() + 1) .. "|" .. item.AnimationId)
		elseif item:IsA("Bone") then
			bones += 1
		elseif item:IsA("KeyframeSequence") then
			sequences += 1
		elseif item:IsA("Keyframe") then
			keyframes += 1
		elseif item:IsA("Attachment") and item.Name:sub(1, 9) == "FishDrip_" then
			assert(item.Parent:IsA("Bone"), "Lost drip bind")
			points += 1
		end
	end
	table.sort(ids)
	return {
		fish = fish,
		meshes = meshes,
		animations = animations,
		bones = bones,
		dripPoints = points,
		sequences = sequences,
		keyframes = keyframes,
		ids = ids,
	}
end
local exports = {}
local function export(root, filename, fishAssets)
	local before = describe(root)
	local data = serializer:SerializeInstancesAsync({ root })
	local restored = serializer:DeserializeInstancesAsync(data)
	assert(#restored == 1, "Lost archive root")
	local after = describe(restored[1])
	for _, key in { "fish", "meshes", "animations", "bones", "dripPoints", "sequences", "keyframes" } do
		assert(before[key] == after[key], "RBXM inventory mismatch " .. key)
	end
	assert(table.concat(before.ids, "\n") == table.concat(after.ids, "\n"), "RBXM asset references changed")
	if fishAssets then
		assert(before.animations == before.fish * 5 and before.dripPoints == before.fish * 24, "Incomplete archive")
	end
	restored[1]:Destroy()
	local response = h:RequestAsync({
		Url = "http://127.0.0.1:18775/studio/" .. filename,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/octet-stream" },
		Body = buffer.tostring(data),
	})
	assert(response.Success, "Archive write failed " .. filename)
	before.ids = nil
	before.file, before.bytes, before.roundTripPassed = filename, buffer.len(data), true
	table.insert(exports, before)
end
local subset = Instance.new("Folder")
subset.Name = "NewFish_Processed_59"
for _, source in manifest.fish do
	local fish = workspace.Fish_Processed[source.name]
	fish:Clone().Parent = subset
	local record = {
		name = fish.Name,
		key = fish:GetAttribute("BatchKey"),
		eyeScale = fish:GetAttribute("EyeDiameterScale"),
		logicalBones = fish:GetAttribute("LogicalBoneCount"),
		family = fish:GetAttribute("NewFishFamily"),
		presentationRadius = fish:GetAttribute("PresentationRadius"),
		parts = {},
		animations = {},
		boneInstances = 0,
	}
	for _, part in fish:GetDescendants() do
		if part:IsA("MeshPart") then
			table.insert(record.parts, {
				name = part.Name,
				meshId = part.MeshId,
				textureId = part.TextureID,
				size = { part.Size.X, part.Size.Y, part.Size.Z },
				material = part.Material.Name,
				color = { part.Color.R, part.Color.G, part.Color.B },
				transparency = part.Transparency,
			})
		elseif part:IsA("Bone") then
			record.boneInstances += 1
		end
	end
	for _, animation in fish.Animations:GetChildren() do
		record.animations[animation.Name] = animation.AnimationId
	end
	table.insert(newFish, record)
end
export(subset, "NewFish_Processed_59.rbxm", true)
subset:Destroy()
export(workspace.Fish_Processed, "Fish_Processed_112.rbxm", true)
export(game.ReplicatedStorage.Models.Fish, "Fish_GameTemplates_112.rbxm", true)
export(game.ServerStorage.FishAnimationSources.NewFish, "NewFish_AnimationSources.rbxm", false)
local result = { fish = newFish, exports = exports }
h:PostAsync("http://127.0.0.1:18775/studio-assets.json", h:JSONEncode(result), Enum.HttpContentType.ApplicationJson)
return exports
