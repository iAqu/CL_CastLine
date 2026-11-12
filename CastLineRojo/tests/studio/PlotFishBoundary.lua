-- Run in a fresh Play Client after Rojo sync. Reads assets; only the test boundary is temporary.
local storage = game:GetService("ReplicatedStorage")
local motion = require(storage.Modules.PlotFishMotion)
local stats = require(storage.Modules.ItemStatUtil)
local envelopes = require(storage.Modules.FishSwimBounds)
local inventory = require(storage.Modules.FishInventoryData)
local ground = workspace.Areas.Plot.Plot_1.Ground
local boundary = Instance.new("Part")
boundary.Size = ground.Size
boundary.CFrame = ground.CFrame * CFrame.Angles(0, 0.37, 0)

local ok, result = xpcall(function()
	local covered, checked, samples, edgeContacts = 0, 0, 0, 0
	for _, template in storage.Models.Fish:GetChildren() do
		local swim = template.Animations.SwimLoop
		assert(envelopes[template.PrimaryPart.MeshId .. "/" .. swim.AnimationId], "Rebake SwimLoop bounds: " .. template.Name)
		covered += 1
	end
	local seen = {}
	for _, item in inventory do
		if seen[item.Model] then
			continue
		end
		seen[item.Model] = true
		for _, multiplier in { 1, 8 } do
			local geometry = assert(motion.GetGeometry(item, item.DefaultWeight * multiplier, boundary))
			assert(typeof(geometry.footprint) == "table", "Missing directional footprint: " .. item.Model)
			local metrics = stats.GetModelBounds(geometry.template)
			local low, high = metrics.minimum * geometry.scale, metrics.maximum * geometry.scale
			local random = Random.new(12037)
			local move = motion.Start(boundary, Vector3.new(29, 0, 27), 0, random, 0.7, geometry.footprint)
			for _ = 1, 60 do
				for index = 0, 20 do
					local pose = motion.Sample(boundary, geometry.height, move,
						move.startedAt + move.duration * index / 20, geometry.footprint)
					for _, x in { low.X, high.X } do
						for _, z in { low.Z, high.Z } do
							local corner = boundary.CFrame:PointToObjectSpace(pose:PointToWorldSpace(Vector3.new(x, 0, z)))
							assert(math.abs(corner.X) <= boundary.Size.X / 2 + 0.002
								and math.abs(corner.Z) <= boundary.Size.Z / 2 + 0.002,
								"Fish crossed the boundary: " .. item.Model)
						end
					end
					samples += 1
				end
				local pose = motion.Sample(boundary, geometry.height, move, move.startedAt + move.duration, geometry.footprint)
				local center = boundary.CFrame:PointToObjectSpace(pose.Position)
				if math.abs(center.X) > boundary.Size.X / 2 - geometry.radius + 0.01
					or math.abs(center.Z) > boundary.Size.Z / 2 - geometry.radius + 0.01 then
					edgeContacts += 1
				end
				local nextMove = assert(motion.Advance(boundary, move, move.startedAt + move.duration, random, geometry.footprint))
				local nextPose = motion.Sample(boundary, geometry.height, nextMove, nextMove.startedAt, geometry.footprint)
				assert((nextPose.Position - pose.Position).Magnitude < 0.002, "Position jumped at the boundary: " .. item.Model)
				assert((nextPose.LookVector - pose.LookVector).Magnitude < 0.0001, "Heading snapped: " .. item.Model)
				move = nextMove
			end
			checked += 1
		end
		task.wait()
	end
	assert(edgeContacts > 0, "Fish still cannot leave the old circular inset")
	return { passed = true, coveredTemplates = covered, checkedSizes = checked, samples = samples, beyondOldInset = edgeContacts }
end, debug.traceback)

boundary:Destroy()
assert(ok, result)
return result
