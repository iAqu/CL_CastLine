-- Edit-only: receiver must run with --replace-current to preserve earlier exports.
return function(receiverUrl)
	assert(not game:GetService("RunService"):IsRunning(), "Export persistent fish assets in Edit mode")
	assert(game.PlaceId == 84106335829275, "Wrong development place")
	receiverUrl = receiverUrl or "http://127.0.0.1:18774"
	local serializer, http = game:GetService("SerializationService"), game:GetService("HttpService")
	local results = {}
	for _, entry in ipairs({
		{ folder = workspace.Fish_Processed, file = "Fish_Processed.rbxm" },
		{ folder = game.ReplicatedStorage.Models.Fish, file = "Fish_GameTemplates.rbxm" },
	}) do
		local data = serializer:SerializeInstancesAsync({ entry.folder })
		local clones = serializer:DeserializeInstancesAsync(data)
		local root = clones[1]
		local points, meshes, animations = 0, 0, 0
		for _, item in ipairs(root:GetDescendants()) do
			if item:IsA("Attachment") and string.sub(item.Name, 1, 9) == "FishDrip_" then
				assert(item.Parent:IsA("Bone"), "Exported drip attachment lost its bone")
				points += 1
			elseif item:IsA("MeshPart") then
				meshes += 1
			elseif item:IsA("Animation") then
				animations += 1
			end
		end
		local descendants = #root:GetDescendants()
		local valid = #root:GetChildren() == 28 and points == 672 and meshes == 65 and animations == 140
		root:Destroy()
		assert(valid, "Export round-trip lost fish resources: " .. entry.file)
		local response = http:RequestAsync({
			Url = receiverUrl .. "/" .. entry.file,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/octet-stream" },
			Body = buffer.tostring(data),
		})
		assert(response.Success, "Fish export failed: " .. response.StatusCode .. " " .. response.Body)
		local record = http:JSONDecode(response.Body)
		record.roundTripDescendants, record.roundTripPoints = descendants, points
		record.roundTripMeshes, record.roundTripAnimations = meshes, animations
		table.insert(results, record)
		task.wait()
	end
	return results
end
