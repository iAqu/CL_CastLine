-- Prepare both replacements and read back their RBXM before touching the live folders.
return function(source, backup, published)
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	assert(not game:GetService("RunService"):IsRunning(), "Install in Edit mode")
	assert(
		source:GetAttribute("LogicalBoneCount") == 20 and source:GetAttribute("RigV2SurfacePrepared"),
		"Stage is incomplete"
	)
	assert(
		source.PrimaryPart.MeshId == published.mesh and source:GetAttribute("RigVariant") == published.variant,
		"Stage changed"
	)
	for name, id in published.clips do
		assert(source.Animations[name].AnimationId == id, "Stage animation changed " .. name)
	end
	local serialization = game:GetService("SerializationService")
	local history = game:GetService("ChangeHistoryService")
	local entries = {
		{ name = "Processed", folder = workspace.Fish_Processed },
		{ name = "Template", folder = game.ReplicatedStorage.Models.Fish },
	}
	local archive = Instance.new("Folder")
	archive.Name = "AxolotlSwim"
	local rigAttributes = {
		RigVersion = true,
		RigVariant = true,
		LogicalBoneCount = true,
		PresentationRadius = true,
		RigV2Key = true,
		RigV2SurfacePrepared = true,
		RigV2SurfaceScale = true,
	}
	for _, entry in entries do
		local previous = entry.folder.Axolotl
		local saved = backup[entry.name].Axolotl
		assert(saved.PrimaryPart.MeshId == previous.PrimaryPart.MeshId, "Target changed after backup " .. entry.name)
		local clone = source:Clone()
		clone:ScaleTo(previous:GetScale())
		clone:PivotTo(previous:GetPivot())
		for name, value in previous:GetAttributes() do
			if not rigAttributes[name] then
				clone:SetAttribute(name, value)
			end
		end
		local body, oldBody = clone.PrimaryPart, previous.PrimaryPart
		assert((body.Size - oldBody.Size).Magnitude < 0.001, "Axolotl size changed")
		assert(
			(body.MouthAttachment.Position - oldBody.MouthAttachment.Position).Magnitude < 0.001,
			"Mouth bind changed"
		)
		body.Color, body.Material, body.MaterialVariant = oldBody.Color, oldBody.Material, oldBody.MaterialVariant
		body.Transparency, body.TextureContent = oldBody.Transparency, oldBody.TextureContent
		body.Anchored, body.CanCollide = oldBody.Anchored, oldBody.CanCollide
		body.CanTouch, body.CanQuery = oldBody.CanTouch, oldBody.CanQuery
		body.CastShadow, body.DoubleSided = oldBody.CastShadow, oldBody.DoubleSided
		body.Reflectance, body.Massless, body.CollisionGroup =
			oldBody.Reflectance, oldBody.Massless, oldBody.CollisionGroup
		local bucket = Instance.new("Folder")
		bucket.Name, bucket.Parent = entry.name, archive
		clone.Parent = bucket
		entry.previous, entry.new, entry.count = previous, clone, #entry.folder:GetChildren()
	end
	game.ServerStorage.FishAnimationSources.RigV2[published.variant]:Clone().Parent = archive
	local data = serialization:SerializeInstancesAsync({ archive })
	local restored = serialization:DeserializeInstancesAsync(data)[1]
	for _, entry in entries do
		local copy = restored[entry.name].Axolotl
		assert(
			copy:GetAttribute("LogicalBoneCount") == 20 and copy.PrimaryPart.MeshId == published.mesh,
			"RBXM rig changed"
		)
		assert(#copy.Animations:GetChildren() == 5, "RBXM lost animations")
		local points = 0
		for _, item in copy.PrimaryPart:GetDescendants() do
			if item:IsA("Attachment") and item:GetAttribute("RigV2SurfaceBind") then
				points += 1
			end
		end
		assert(points == 24, "RBXM lost drip bindings")
	end
	restored:Destroy()
	return data,
		function()
			for _, entry in entries do
				assert(
					entry.previous.Parent == entry.folder and #entry.folder:GetChildren() == entry.count,
					"Fish folder changed"
				)
			end
			history:SetWaypoint("Before Axolotl four-leg swim")
			local ok, reason = pcall(function()
				for _, entry in entries do
					entry.previous.Parent = nil
					entry.new.Parent = entry.folder
				end
			end)
			if not ok then
				for _, entry in entries do
					entry.new.Parent = archive[entry.name]
					entry.previous.Parent = entry.folder
				end
				error(reason)
			end
			local counts = {}
			for _, entry in entries do
				entry.previous:Destroy()
				counts[entry.folder:GetFullName()] = #entry.folder:GetChildren()
			end
			archive:Destroy()
			source.Parent:Destroy()
			history:SetWaypoint("Install Axolotl four-leg swim")
			return {
				installed = true,
				mesh = published.mesh,
				clips = published.clips,
				counts = counts,
				backup = backup:GetFullName(),
			}
		end
end
