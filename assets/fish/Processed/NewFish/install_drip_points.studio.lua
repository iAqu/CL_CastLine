-- Edit-only authoring helper. Execute from the publishing workflow; never install as a Script.
return function(fish, data)
	assert(not game:GetService("RunService"):IsRunning(), "Install drip points in Edit mode")
	local body = assert(fish.PrimaryPart, "Fish PrimaryPart is missing")
	assert(data and #data.points == 24, "Expected 24 authored drip points: " .. fish.Name)
	if data.primarySize then
		assert(
			(body.Size - Vector3.new(table.unpack(data.primarySize))).Magnitude < 0.01,
			"Drip geometry does not match the fish: " .. fish.Name
		)
	end
	local targets, names = {}, {}
	for _, spec in ipairs(data.points) do
		local name = "FishDrip_" .. spec.name
		assert(not names[name], "Duplicate authored drip name: " .. name)
		names[name] = true
		local bone = body:FindFirstChild(spec.bone, true)
		assert(bone and bone:IsA("Bone"), "Drip bone is missing: " .. fish.Name .. "/" .. spec.bone)
		local position = Vector3.new(table.unpack(spec.bodyPosition))
		local normal = Vector3.new(table.unpack(spec.bodyNormal)).Unit
		local right = normal:Cross(if math.abs(normal.Y) < 0.99 then Vector3.yAxis else Vector3.xAxis).Unit
		local frame = CFrame.fromMatrix(position, right, normal, right:Cross(normal))
		table.insert(targets, { name = name, bone = bone, frame = bone.WorldCFrame:ToObjectSpace(body.CFrame * frame) })
	end
	fish:SetAttribute("FishDripSurfaceCoverage", data.validation.coverage)
	-- Preserve the already verified Elder points when they are complete.
	local preserve = fish.Name == "Elder Fish"
	for _, target in ipairs(targets) do
		local count = 0
		for _, item in ipairs(body:GetDescendants()) do
			if item.Name == target.name then
				count += 1
				preserve = preserve and item:IsA("Attachment") and item.Parent:IsA("Bone")
			end
		end
		preserve = preserve and count == 1
	end
	if preserve then
		return { name = fish.Name, points = 24, changed = 0, preserved = true }
	end
	for _, target in ipairs(targets) do
		local point
		for _, item in ipairs(body:GetDescendants()) do
			if item.Name == target.name then
				if not point and item:IsA("Attachment") then
					point = item
				else
					item:Destroy()
				end
			end
		end
		point = point or Instance.new("Attachment")
		point.Name, point.Parent, point.CFrame = target.name, target.bone, target.frame
	end
	return { name = fish.Name, points = 24, changed = 24 }
end
