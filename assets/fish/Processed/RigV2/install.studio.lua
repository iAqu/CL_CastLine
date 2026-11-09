-- Prepare and verify both archives before returning the function that installs the fish.
-- Call the returned installer after the archive transport confirms both copies are saved.
local serialization = game:GetService("SerializationService")
return function(read, storeArchive)
	assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
	assert(not game:GetService("RunService"):IsRunning(), "Use Studio Edit mode")
	local inventory = read("inventory.json")
	local audit = read("audit-all.json")
	local gameplay = read("gameplay-validation.json")
	local regression = read("regression-validation.json")
	local surfaces = read("surface-installation.json")
	assert(audit.done and gameplay.done and regression.done, "Validation incomplete")
	assert(
		surfaces.fish == #inventory.rows and surfaces.points == #inventory.rows * 24 and next(surfaces.errors) == nil,
		"Weighted drip bindings incomplete"
	)
	assert(
		regression.random.passed
			and regression.random.templates == #inventory.rows
			and regression.drip.passed
			and regression.drip.fish == #inventory.rows,
		"Random or drip audit incomplete"
	)
	local gameByName = {}
	for _, result in gameplay.results do
		gameByName[result.name] = result
	end
	local stage = workspace._RigV2Stage
	local processed, templates = workspace.Fish_Processed, game.ReplicatedStorage.Models.Fish
	assert(
		#processed:GetChildren() == #inventory.rows and #templates:GetChildren() == #inventory.rows,
		"Random pool changed"
	)
	local function listParts(fish)
		local parts = {}
		for _, item in fish:GetDescendants() do
			if item:IsA("MeshPart") and item.HasSkinnedMesh then
				table.insert(parts, item)
			end
		end
		table.sort(parts, function(a, b)
			if a == fish.PrimaryPart then
				return b ~= a
			end
			if b == fish.PrimaryPart then
				return false
			end
			return a:GetFullName() < b:GetFullName()
		end)
		return parts
	end
	local records, prepared = {}, {}
	local function create(source, target)
		local clone = source:Clone()
		clone:PivotTo(target:GetPivot())
		if math.abs(clone:GetScale() - target:GetScale()) > 1e-6 then
			clone:ScaleTo(target:GetScale())
		end
		for k, v in target:GetAttributes() do
			if
				k ~= "RigVersion"
				and k ~= "LogicalBoneCount"
				and k ~= "RigVariant"
				and k ~= "PresentationRadius"
				and k ~= "RigV2Key"
				and k ~= "RigV2SurfaceScale"
			then
				clone:SetAttribute(k, v)
			end
		end
		local updated, original = listParts(clone), listParts(target)
		assert(#updated == #original, "Paired mesh count changed")
		for i, part in updated do
			local old = original[i]
			assert(part.Name == old.Name and (part.Size - old.Size).Magnitude < 0.002, "Paired mesh shape differs")
			assert(
				clone.PrimaryPart.CFrame
					:ToObjectSpace(part.CFrame)
					:FuzzyEq(target.PrimaryPart.CFrame:ToObjectSpace(old.CFrame), 0.002),
				"Paired model alignment differs"
			)
			part.Color, part.Material, part.MaterialVariant = old.Color, old.Material, old.MaterialVariant
			part.Transparency, part.Reflectance, part.TextureContent =
				old.Transparency, old.Reflectance, old.TextureContent
			part.CastShadow, part.DoubleSided = old.CastShadow, old.DoubleSided
		end
		return clone
	end
	for _, entry in inventory.rows do
		local checked = audit.results[entry.name]
		local flow = gameByName[entry.name]
		local fish = stage:FindFirstChild(entry.name)
		if
			fish
			and checked
			and checked.passed
			and flow
			and flow.passed
			and flow.framingPassed
			and checked.variant == fish:GetAttribute("RigVariant")
		then
			local oldVisual, oldTemplate = processed[entry.name], templates[entry.name]
			local p, t = create(fish, oldVisual), create(fish, oldTemplate)
			table.insert(prepared, { oldVisual = oldVisual, oldTemplate = oldTemplate, visual = p, template = t })
			records[entry.name] = { passed = true, bones = checked.bones, variant = checked.variant }
		else
			records[entry.name] = { passed = false, reason = "Missing successful asset or gameplay audit" }
		end
	end
	assert(#prepared == #inventory.rows, "One or more fish did not pass; current models preserved")
	local visualArchive, templateArchive = Instance.new("Folder"), Instance.new("Folder")
	visualArchive.Name, templateArchive.Name = processed.Name, templates.Name
	for _, pair in prepared do
		pair.visual.Parent = visualArchive
		pair.template.Parent = templateArchive
	end
	local exports = {}
	local function export(root, name, count)
		local data = serialization:SerializeInstancesAsync({ root })
		local loaded = serialization:DeserializeInstancesAsync(data)
		assert(#loaded == 1 and #loaded[1]:GetDescendants() == #root:GetDescendants(), "RBXM readback differs")
		if count then
			assert(#loaded[1]:GetChildren() == count, "RBXM lost models")
			for _, model in loaded[1]:GetChildren() do
				assert(
					model.PrimaryPart and model:GetAttribute("RigVersion") == 2 and #model.Animations:GetChildren() == 5,
					"Incomplete restored model"
				)
				local live = root[model.Name]
				for _, clip in model.Animations:GetChildren() do
					assert(live.Animations[clip.Name].AnimationId == clip.AnimationId, "Animation reference changed")
				end
				local a, b = listParts(model), listParts(live)
				assert(#a == #b, "Mesh count changed in RBXM")
				for i, part in a do
					assert(
						part.MeshId == b[i].MeshId and part.TextureID == b[i].TextureID,
						"Mesh or texture ID changed"
					)
				end
			end
		end
		loaded[1]:Destroy()
		local info = storeArchive(name, data)
		info.roundTripPassed = true
		table.insert(exports, info)
	end
	export(visualArchive, "Fish_Processed_112_RigV2.rbxm", #inventory.rows)
	export(templateArchive, "Fish_Templates_112_RigV2.rbxm", #inventory.rows)
	export(game.ServerStorage.FishAnimationSources.RigV2, "Fish_AnimationSources_RigV2.rbxm", nil)
	return exports,
		function()
			assert(
				processed.Parent == workspace and templates.Parent == game.ReplicatedStorage.Models,
				"Fish folders changed"
			)
			assert(
				#processed:GetChildren() == #prepared and #templates:GetChildren() == #prepared,
				"Fish count changed"
			)
			for _, pair in prepared do
				assert(pair.oldVisual.Parent == processed and pair.oldTemplate.Parent == templates, "Live fish changed")
			end
			local history = game:GetService("ChangeHistoryService")
			history:SetWaypoint("Before Rig V2 install")
			for _, pair in prepared do
				pair.oldVisual.Parent = nil
				pair.oldTemplate.Parent = nil
				pair.visual.Parent = processed
				pair.template.Parent = templates
			end
			for _, pair in prepared do
				pair.oldVisual:Destroy()
				pair.oldTemplate:Destroy()
			end
			visualArchive:Destroy()
			templateArchive:Destroy()
			stage:Destroy()
			local preview = workspace:FindFirstChild("_RigV2Preview")
			if preview then
				preview:Destroy()
			end
			history:SetWaypoint("Install validated Rig V2 fish")
			return {
				complete = true,
				installed = #prepared,
				records = records,
				exports = exports,
				backup = inventory.backup,
			}
		end
end
