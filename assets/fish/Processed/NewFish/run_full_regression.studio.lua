--# selene: allow(global_usage)
local function runRandomTest()
-- Studio Client：真实鱼种抽取、整轮身份、嘴部连接、动画、展示取景和清理。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local originalName, originalSelector = settings.FishName, Bite.SelectFishTemplate
local camera = workspace.CurrentCamera
local savedCamera = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRandomFishValidation", workspace
local active, selected
local selections = 0
Bite.SelectFishTemplate = function(...)
	selections += 1
	selected = originalSelector(...)
	return selected
end

local ok, result = xpcall(function()
	local templates = {}
	for _, template in storage.Models.Fish:GetChildren() do
		if template:IsA("Model") and template.PrimaryPart then
			table.insert(templates, template)
		end
	end
	table.sort(templates, function(a, b)
		return a.Name < b.Name
	end)
	assert(#templates > 1, "Random fish validation needs multiple templates")
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local target = Vector3.new(0, 1000, 0)
	local initial = CFrame.lookAt(target + Vector3.new(0, 18, -28), target)
	local owner = setmetatable({
		folder = folder, bait = bait, forward = Vector3.zAxis, spin = 0,
		statusLabel = {}, returnLabel = {}, impulses = {},
		root = { CFrame = CFrame.identity },
		cameraFrame = initial, cameraFov = 60,
		shotMode = "Bite", shotStarted = 100, shotDuration = 0, shotFrom = initial, fovFrom = 60,
		_waterTarget = function() return target end,
		_presentBait = function() end, _waterFeedback = function() end,
		_playWaterVFX = function() end, _playRarityVFX = function() end,
		_nibbleRipple = function() end, _nibbleFeedback = function() end,
		_sound = function() end, _impulse = function() end, _setPhase = function() end,
	}, Cast)
	local samples, randomSpecies = 0, {}
	for round = 1, #templates + 12 do
  _G.NewFishRegressionJob.randomRound=round
		settings.FishName = if round <= #templates then templates[round].Name else nil
		active = Bite.new(owner, 100, 100, Random.new(round), Random.new(round + 100))
		owner.bite = active
		local fish, template, count = active.fish, selected, selections
		assert(count == round, "A round must select exactly one fish")
		local expected = Bite.NewTimeline(100, Random.new(round), 100)
		assert(active.timeline.nibbles == expected.nibbles and active.timeline.appearAt == expected.appearAt,
			"Fish selection consumed the gameplay random stream")
		assert(fish.PrimaryPart.MeshId == template.PrimaryPart.MeshId, "Selected fish was not cloned")
		assert((active.mouthOffset - template.PrimaryPart.MouthAttachment.Position).Magnitude < 0.0001,
			"Selected fish mouth attachment was ignored")
		if round > #templates then
			randomSpecies[template.Name] = true
		end
		-- 后续状态不能再读取指定鱼种或重新抽取。
		settings.FishName = nil
		local deadline = os.clock() + 12
		while active.animation.loading and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(not active.animation.loading and not active.animation.failed, "Fish animations failed: " .. template.Name)
		for name in pairs(settings.Motion.Animation.Clips) do
			assert(active.animation.tracks[name] and active.animation.tracks[name].Length > 0,
				"Missing fish animation: " .. template.Name .. "/" .. name)
		end
		local startedAt = 101
		for _, entry in ipairs({
			{ "Approaching", settings.ApproachTime }, { "Holding", 1 },
			{ "Nibbling", settings.NibbleTime }, { "Bite", settings.HookWindow },
			{ "Struggling", settings.StruggleTime }, { "Lifting", settings.LiftTime },
			{ "Caught", 1.2 },
		}) do
			local phase, duration = entry[1], entry[2]
			if phase == "Nibbling" then
				active.timeline.nibbleIndex = 1
				duration = active.timeline:GetNibbleTiming().duration
			end
			active.timeline:_enter(phase, startedAt, duration)
			for _, fraction in ipairs({ 0, 0.5, 0.95 }) do
				local now = startedAt + duration * fraction
				active:Update(now, true)
				owner:_updateCamera(now, 1 / 60)
				active:Present(camera.CFrame.Position)
				task.wait()
				assert(active.fish == fish and selections == count, "Fish changed during a round")
				local body = fish.PrimaryPart
				local mouth = body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
				if phase == "Bite" and duration * fraction >= settings.BiteSinkTime then
					local yaw = active:_feedingState(phase, duration * fraction)
					assert((mouth - bait.Position - active:_contactOffset(yaw, bait.Size)).Magnitude < 0.001,
						"Biting mouth detached: " .. template.Name)
				end
				if phase == "Lifting" or phase == "Caught" then
					assert((mouth - Vector3.yAxis * settings.ShowcaseLineMouthDrop - active.linePosition).Magnitude < 0.001,
						"Showcase line detached: " .. template.Name)
				end
				if phase == "Caught" then
					for _, viewport in ipairs({ Vector2.new(390, 844), Vector2.new(1877, 1240) }) do
						local view = owner:_showcaseCamera(target, viewport)
						local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
						for x = -1, 1, 2 do
							for y = -1, 1, 2 do
								for z = -1, 1, 2 do
									local corner = body.CFrame:PointToWorldSpace(body.Size * Vector3.new(x, y, z) * 0.5)
									local point = view:PointToObjectSpace(corner)
									assert(point.Z < 0 and math.abs(point.X / (-point.Z * tangent * viewport.X / viewport.Y)) < 1
										and math.abs(point.Y / (-point.Z * tangent)) < 1, "Fish clipped in showcase: " .. template.Name)
								end
							end
						end
					end
				end
				samples += 1
			end
			startedAt += duration
		end
		active:Destroy()
		assert(not fish.Parent and active.animation.destroyed, "Fish survived round cleanup")
		active = nil
	end
	local speciesCount = 0
	for _ in pairs(randomSpecies) do
		speciesCount += 1
	end
	return { passed = true, templates = #templates, randomRounds = 12, randomSpecies = speciesCount, samples = samples }
end, debug.traceback)

if active then
	active:Destroy()
end
folder:Destroy()
settings.FishName, Bite.SelectFishTemplate = originalName, originalSelector
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType = unpack(savedCamera)
assert(ok, result)
return result

end
local function runDripTest()
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
			_G.NewFishRegressionJob.dripFish=template.Name
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

end
local run=(function()
-- Client-only QA wrapper; callbacks execute repository test sources, never synchronize scripts.
return function(runRandom, runDrip)
	assert(_G.FishGameplayJob.done and #_G.FishGameplayJob.errors == 0, "Wait for gameplay QA")
	local job = { done = false }
	_G.NewFishRegressionJob = job
	local storage = game.ReplicatedStorage
	local settings = require(storage.Modules.FishingConfig).Bite
	local originalName = settings.FishName
	local created = {}
	local function cleanup()
		settings.FishName = originalName
		for _, fish in created do
			fish:Destroy()
		end
	end
	task.spawn(function()
		local ok, err = xpcall(function()
			local stage = workspace:FindFirstChild("_FishNewFish_Staging")
			if stage then
				for _, fish in stage:GetChildren() do
					assert(not storage.Models.Fish:FindFirstChild(fish.Name), "Duplicate QA species")
					local clone = fish:Clone()
					clone.Parent = storage.Models.Fish
					table.insert(created, clone)
				end
			end
			job.current = "Random selection and round identity"
			job.random = runRandom()
			job.current = "112-species drip regression"
			job.drip = runDrip()
			job.current = "Legacy mouth fallback"
			local Bite = require(storage.Modules.FishingBiteSequence)
			local legacy = storage.Models.Fish["Elder Fish"]:Clone()
			legacy.Name, legacy.Parent = "_LegacyMouthQA", storage.Models.Fish
			table.insert(created, legacy)
			legacy.PrimaryPart.MouthAttachment:Destroy()
			settings.FishName = legacy.Name
			local folder = Instance.new("Folder")
			folder.Parent = workspace
			table.insert(created, folder)
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
					return Vector3.new(0, 1000, 0)
				end,
			}
			local sequence = Bite.new(owner, 100, 100, Random.new(1))
			local expected = legacy.PrimaryPart.Size * Vector3.new(table.unpack(settings.MouthOffset))
			assert((sequence.mouthOffset - expected).Magnitude < 0.00001, "Legacy mouth ratio ignored")
			sequence:Destroy()
			job.legacyMouthFallback = { passed = true }
		end, debug.traceback)
		cleanup()
		if not ok then
			job.error = err
		end
		job.done = true
	end)
	return "Started random, drip and legacy-mouth regression on temporary Client templates"
end

end)()
return run(runRandomTest,runDripTest)
