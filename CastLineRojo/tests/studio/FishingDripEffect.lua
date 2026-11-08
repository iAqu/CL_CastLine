-- Studio Client: real surface coverage, emission scheduling, independent burst motion and teardown.
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingDripValidation", workspace
local sequence
local originalFishName = settings.FishName
local function validate(template)
	settings.FishName = template.Name
	local target = Vector3.new(0, 5000, 0)
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local owner = {
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		spin = 0,
		statusLabel = {},
		returnLabel = {},
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_setPhase = function() end,
	}
	sequence = Bite.new(owner, os.clock(), os.clock(), Random.new(1), Random.new(2))
	assert(not sequence.drip, "Droplets created before Caught")
	local deadline = os.clock() + settings.Motion.Animation.LoadTimeout + 1
	while sequence.animation.loading and os.clock() < deadline do
		task.wait(0.05)
	end
	assert(not sequence.animation.failed and not sequence.animation.loading, "Fish animation did not load")
	local startedAt = os.clock()
	sequence.timeline:_enter("Caught", startedAt)
	sequence:Update(startedAt)
	local effect = assert(sequence.drip, "Caught did not create droplets")
	assert(#effect.emitters == 24 and #effect.burstEmitters == 24, "Missing surface emitters")
	assert(effect.lastBurst == nil and effect.lastCount == 0, "Emission preceded tail movement")
	local actuals, normalRecords, burstRecords = {}, {}, {}
	local function probe(layer, records)
		local proxies = {}
		for _, emitter in ipairs(layer) do
			table.insert(actuals, emitter)
			assert(not emitter.Enabled and emitter.Rate == 0, "Automatic emission is still enabled")
			assert(not emitter.LockedToPart and emitter.VelocityInheritance == 0, "Droplets remain attached")
			assert(emitter.Parent.Parent:IsA("Bone"), "Emitter is not bone-attached")
			table.insert(
				proxies,
				setmetatable({
					Emit = function(_, count)
						table.insert(records, { point = emitter.Parent, count = count, token = effect.lastBurst })
						emitter:Emit(count)
					end,
					Clear = function()
						emitter:Clear()
					end,
					Destroy = function()
						emitter:Destroy()
					end,
				}, {
					__index = function(_, key)
						return emitter[key]
					end,
					__newindex = function(_, key, value)
						emitter[key] = value
					end,
				})
			)
		end
		return proxies
	end
	effect.emitters = probe(effect.emitters, normalRecords)
	effect.burstEmitters = probe(effect.burstEmitters, burstRecords)
	for _, emitter in ipairs(effect.emitters) do
		assert(emitter.Drag == 10 and emitter.Acceleration.Y == -150, "Normal drip motion changed")
	end
	for _, emitter in ipairs(effect.burstEmitters) do
		assert(emitter.Drag == 2 and emitter.Acceleration.Y == -60, "Burst motion was not separated")
		assert(emitter.Speed.Min >= 10 and emitter.TimeScale == 0.5, "Burst speed/time scale differ")
	end
	sequence:Update(startedAt + 0.15)
	assert(effect.lastBurst == startedAt and #burstRecords == 10, "Tail window did not emit exactly 10 droplets")
	local unique = {}
	for _, record in ipairs(burstRecords) do
		assert(not unique[record.point], "Burst repeated a surface point")
		unique[record.point] = true
	end
	sequence:Update(startedAt + 0.15)
	assert(#burstRecords == 10, "Repeated Present duplicated burst")
	local view = CFrame.lookAt(target + Vector3.yAxis * 5 - Vector3.zAxis * 11, target + Vector3.yAxis * 5)
	local minCoverage = math.huge
	for _, at in ipairs({ 0.2, 0.32, 0.45, 0.55, 0.65, 0.76, 0.9 }) do
		sequence:Update(startedAt + at)
		task.wait()
		local low, high = math.huge, -math.huge
		for _, emitter in ipairs(effect.emitters) do
			local point = emitter.Parent
			local x = view:PointToObjectSpace(point.WorldPosition).X
			low, high = math.min(low, x), math.max(high, x)
			local normal = point.Parent.TransformedWorldCFrame:VectorToWorldSpace(point.CFrame.UpVector)
			assert((normal - point.WorldCFrame.UpVector).Magnitude < 0.001, "Surface normal did not follow bone")
		end
		local coverage = (high - low) / sequence.fish.PrimaryPart.Size.Y
		minCoverage = math.min(minCoverage, coverage)
		local minimum = math.min(0.3, (template:GetAttribute("FishDripSurfaceCoverage") or 0.3) * 0.7)
		assert(coverage >= minimum, "Droplets collapsed into a vertical column: " .. template.Name)
	end
	for frame = 14, 150 do
		sequence:Update(startedAt + frame / 15)
	end
	assert(#normalRecords == 80, "Absolute-time schedule changed normal density at 15 FPS")
	for first = 1, 49, 24 do
		local seen = {}
		for index = first, first + 23 do
			local record = normalRecords[index]
			assert(record.count == 1 and not seen[record.point], "Surface point repeated inside one cycle")
			seen[record.point] = true
		end
	end
	local before = #normalRecords
	sequence:Update(startedAt + 100)
	assert(#normalRecords - before == 4, "Long frame exceeded catch-up cap")
	sequence:Update(startedAt + 100.01)
	assert(#normalRecords - before == 4, "Skipped particles accumulated as debt")
	local baseline, maxScaleError = {}, 0
	for _, emitter in ipairs(effect.emitters) do
		baseline[emitter.Parent] = emitter.Parent.Position
	end
	for _, scale in ipairs({ 0.65, 1, 1.45 }) do
		sequence.fish:ScaleTo(sequence.baseScale * scale)
		for point, position in pairs(baseline) do
			local error = (point.Position - position * scale).Magnitude
			maxScaleError = math.max(maxScaleError, error)
			assert(error < 0.001, "Surface point did not scale with fish")
		end
	end
	local point = effect.emitters[5].Parent
	local beforePosition = point.WorldPosition
	point.Parent.Transform = CFrame.Angles(0, 0.5, 0)
	local expected = point.Parent.TransformedWorldCFrame:PointToWorldSpace(point.Position)
	local followError = (point.WorldPosition - expected).Magnitude
	assert((point.WorldPosition - beforePosition).Magnitude > 0.1, "Point did not follow bone deformation")
	assert(followError < 0.001, "Point diverged from bone")
	effect:Update("Lifting", 0)
	assert(not effect.active, "Droplets leaked outside Caught")
	local fish = sequence.fish
	sequence:Destroy()
	sequence:Destroy()
	assert(fish.Parent == nil, "Fish/surface points survived teardown")
	for _, emitter in ipairs(actuals) do
		assert(emitter.Parent == nil, "Emitter survived teardown")
	end
	sequence = nil
	bait:Destroy()
	return {
		name = template.Name,
		passed = true,
		points = 24,
		emitters = #actuals,
		minCoverage = minCoverage,
		maxScaleError = maxScaleError,
		boneFollowError = followError,
		normalCount10Seconds = 80,
		catchupLimit = 4,
	}
end
local ok, result = xpcall(function()
	local templates = storage.Models.Fish:GetChildren()
	table.sort(templates, function(a, b)
		return a.Name < b.Name
	end)
	local results = {}
	for _, template in ipairs(templates) do
		if template:IsA("Model") and template.PrimaryPart then
			table.insert(results, validate(template))
			task.wait()
		end
	end
	assert(#results == #templates and #results > 0, "Expected every fish in drip regression")
	return { passed = true, fish = #results, results = results }
end, debug.traceback)
if sequence then
	sequence:Destroy()
end
folder:Destroy()
settings.FishName = originalFishName
assert(ok, result)
return result
