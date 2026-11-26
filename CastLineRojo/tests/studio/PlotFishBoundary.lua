-- Run in a fresh Play Client after Rojo sync. Only the unparented test boundary is temporary.
local storage = game:GetService("ReplicatedStorage")
local motion = require(storage.Modules.PlotFishMotion)
local stats = require(storage.Modules.ItemStatUtil)
local inventory = require(storage.Modules.FishInventoryData)
local ground = workspace.Areas.Plot.Plot_1.Ground
local boundary = Instance.new("Part")
boundary.Size = ground.Size
boundary.CFrame = ground.CFrame * CFrame.Angles(0, 0.37, 0)

local ok, result = xpcall(function()
	local halfX = math.max(boundary.Size.X / 2 - 1.75, 0)
	local halfZ = math.max(boundary.Size.Z / 2 - 1.75, 0)
	local models, checked, samples, edgeContacts, bodyCrossings = 0, 0, 0, 0, 0
	local minimumGap, maximumGap = math.huge, -math.huge
	local referenceTargets = {}
	local seen = {}
	for _, item in inventory do
		if seen[item.Model] then
			continue
		end
		seen[item.Model] = true
		models += 1
		for _, multiplier in { 1, 8 } do
			local geometry = assert(motion.GetGeometry(item, item.DefaultWeight * multiplier, boundary))
			local metrics = stats.GetModelBounds(geometry.template)
			local floatPhase = motion.GetFloatPhase("boundary-qa-" .. item.Model)
			local low, high = metrics.minimum * geometry.scale, metrics.maximum * geometry.scale
			local random = Random.new(12037)
			local entry = Vector3.new(29, 0, 27)
			local move = motion.Start(boundary, entry, 0, random, 0.7)
			local preview = boundary.CFrame:PointToObjectSpace(motion.GetSurfacePoint(boundary, entry))
			assert((move.from - Vector3.new(preview.X, 0, preview.Z)).Magnitude < 0.002, "Preview/spawn mismatch")
			for segment = 1, 60 do
				if referenceTargets[segment] then
					assert((move.target - referenceTargets[segment]).Magnitude < 0.002, "Size changed travel limits: " .. item.Model)
				else
					referenceTargets[segment] = move.target
				end
				for index = 0, 20 do
					local pose = motion.Sample(boundary, geometry.height, move, move.startedAt + move.duration * index / 20, floatPhase)
					local center = boundary.CFrame:PointToObjectSpace(pose.Position)
					local bottomGap = center.Y + metrics.bottom * geometry.scale - boundary.Size.Y / 2
					minimumGap, maximumGap = math.min(minimumGap, bottomGap), math.max(maximumGap, bottomGap)
					assert(bottomGap >= 3.8 - 0.002 and bottomGap <= 6.2 + 0.002,
						"Fish belly outside floating height range: " .. item.Model)
					assert(math.abs(center.X) <= halfX + 0.002 and math.abs(center.Z) <= halfZ + 0.002,
						"Fish center crossed its fixed boundary: " .. item.Model)
					for _, x in { low.X, high.X } do
						for _, z in { low.Z, high.Z } do
							local corner = boundary.CFrame:PointToObjectSpace(pose:PointToWorldSpace(Vector3.new(x, 0, z)))
							if math.abs(corner.X) > boundary.Size.X / 2 + 0.002
								or math.abs(corner.Z) > boundary.Size.Z / 2 + 0.002 then
								bodyCrossings += 1
							end
						end
					end
					samples += 1
				end
				local pose = motion.Sample(boundary, geometry.height, move, move.startedAt + move.duration, floatPhase)
				local center = boundary.CFrame:PointToObjectSpace(pose.Position)
				if math.abs(math.abs(center.X) - halfX) < 0.002 or math.abs(math.abs(center.Z) - halfZ) < 0.002 then
					edgeContacts += 1
				end
				local nextMove = assert(motion.Advance(boundary, move, move.startedAt + move.duration, random))
				local nextPose = motion.Sample(boundary, geometry.height, nextMove, nextMove.startedAt, floatPhase)
				assert((nextPose.Position - pose.Position).Magnitude < 0.002, "Position jumped at the boundary: " .. item.Model)
				assert((nextPose.LookVector - pose.LookVector).Magnitude < 0.0001, "Heading snapped: " .. item.Model)
				move = nextMove
			end
			checked += 1
		end
		task.wait()
	end
	assert(edgeContacts > 0, "Fish must reach the fixed center limits")
	assert(bodyCrossings > 0, "Fish bodies must be allowed past the ground edge")
	return { passed = true, models = models, checkedSizes = checked, samples = samples,
		edgeContacts = edgeContacts, bodyCrossings = bodyCrossings, minimumGap = minimumGap, maximumGap = maximumGap, centerRange = Vector2.new(halfX * 2, halfZ * 2) }
end, debug.traceback)

boundary:Destroy()
assert(ok, result)
return result
