-- Studio Client：真实鱼体与音画副本，多尺寸、多帧率、横竖屏取景及退出清理。
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local Audio = require(storage.Modules.FishingAudio)
local Stats = require(storage.Modules.ItemStatUtil)
local Water = require(storage.Modules.WaterSurfaceUtil)
local Config = require(storage.Modules.FishingConfig)
local camera = workspace.CurrentCamera
local saved = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local target = Vector3.new(1838, assert(Water.GetWaterSurfaceY()), 1010)
local job = { done = false, passed = false, cases = {}, failures = {} }
-- selene: allow(global_usage)
_G.FishingHighLiftQA = job
local active, owner, folder
local function cleanup()
	if active then
		active:Destroy()
		active = nil
	end
	if owner then
		if owner.fishAudio then
			owner.fishAudio:Destroy(false)
		end
		for sound in pairs(owner.sounds or {}) do
			sound:Destroy()
		end
		owner = nil
	end
	if folder then
		folder:Destroy()
		folder = nil
	end
end
local function protected(frame, center, radius, viewport, fov)
	local view = Cast._protectShowcase({}, frame, center, radius, viewport, fov, 1)
	local point = view:PointToObjectSpace(center)
	local vertical = math.rad(fov * 0.5)
	local horizontal = math.atan(math.tan(vertical) * viewport.X / viewport.Y)
	assert(
		-point.Z * math.sin(vertical) - math.abs(point.Y) * math.cos(vertical) >= radius - 0.002,
		"Fish sphere clipped vertically"
	)
	assert(
		-point.Z * math.sin(horizontal) - math.abs(point.X) * math.cos(horizontal) >= radius - 0.002,
		"Fish sphere clipped horizontally"
	)
	return view
end
local function run(template, maximum, fps)
	folder = Instance.new("Folder")
	folder.Name, folder.Parent = "_FishingHighLiftQA", workspace
	local bait = Instance.new("Part")
	bait.Anchored, bait.Parent = true, folder
	local cues, waterBursts, impulses = {}, {}, {}
	local incoming = CFrame.lookAt(target + Vector3.new(0, 12, -18), target)
	owner = setmetatable({
		options = {},
		folder = folder,
		bait = bait,
		baitBaseSize = Vector3.one,
		forward = Vector3.zAxis,
		continueLabel = {},
		sounds = {},
		impulses = {},
		root = { CFrame = CFrame.identity },
		cameraFrame = incoming,
		cameraFocus = target,
		cameraFov = 60,
		biteFocus = target,
		shotFrom = incoming,
		shotMode = "Landing",
		shotStarted = 0,
		shotDuration = 0,
		fovFrom = 60,
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function(self, now, name, position, direction, scale)
			if name == Config.WaterVFX.Exit then
				table.insert(waterBursts, scale)
			end
			return Cast._playWaterVFX(self, now, name, position, direction, scale)
		end,
		_impulse = function(self, settings, now)
			table.insert(impulses, settings)
			Cast._impulse(self, settings, now)
		end,
		_sound = function(self, name)
			cues[name] = (cues[name] or 0) + 1
			return Cast._sound(self, name)
		end,
	}, Cast)
	owner.fishAudio = Audio.new(function()
		return true
	end)
	local play = owner.fishAudio.Play
	owner.fishAudio.Play = function(self, name, looped)
		cues[name] = (cues[name] or 0) + 1
		return play(self, name, looped)
	end
	active = Bite.new(
		owner,
		0,
		0,
		Random.new(51),
		Random.new(52),
		template,
		{ DefaultWeight = 1, ModelDefaultScale = 1, Rarity = "Common" }
	)
	owner.bite = active
	active:SetCaughtWeight(if maximum then 1e12 else 1)
	local timing = active:GetLiftTiming()
	active.timeline:_enter("Lifting", 100, timing.duration)
	local deadline = os.clock() + 10
	while active.animation.loading and os.clock() < deadline do
		task.wait(0.05)
	end
	assert(not active.animation.failed and not active.animation.loading, "Fish animation failed to load")
	local maxY, lagged, frozen = -math.huge, false, nil
	local previousBase, endBase
	for index = 0, math.ceil((timing.duration + 0.1) * fps) do
		local t = index / fps
		active:Update(100 + t, true)
		owner:_updateCamera(100 + t, 1 / fps)
		active:Present(camera.CFrame.Position)
		local plan = active.liftPlan
		frozen = frozen or plan.diameter
		assert(plan.diameter == frozen, "Animated scaling changed the flight distance")
		maxY = math.max(maxY, active.fish.PrimaryPart.Position.Y - target.Y)
		if t > plan.exitAt + 0.04 and t < plan.exitAt + Config.Bite.FishLift.CameraHold then
			assert((owner.cameraFocus - target).Magnitude < 0.002, "Camera did not hold the water reference")
			lagged = true
		end
		if t >= timing.riseEnd then
			assert(not active.fishTrail or not active.fishTrail.trail.Enabled, "Trail kept generating after the apex")
		end
		if t >= timing.landAt then
			local lowest = active.displayFrame.Position.Y - active.presentationRadius * active.scale
			assert(lowest >= target.Y + Config.Bite.WaterClearance - 0.002, "Rebound dipped into the water")
		end
		for _, viewport in ipairs({ Vector2.new(390, 844), Vector2.new(844, 390) }) do
			local base = owner:_fishLiftCamera(100 + t, target, viewport)
			if t >= timing.riseEnd and t < timing.fallStart then
				assert(base.LookVector.Y > 0.05, "Apex camera must tilt upward")
			end
			local radius = (
				if active.timeline.phase == "Caught"
					then active:GetShowcaseRadius()
					else active.presentationRadius * active.scale
			) + Config.Bite.ShowcasePadding
			-- 验证震动后的保护，包括竖屏和起跳的第一帧。
			protected(
				base * CFrame.new(0.5, 0.4, 0) * CFrame.Angles(0.02, 0.02, 0.01),
				active.showcasePosition,
				radius,
				viewport,
				60
			)
		end
		if t >= timing.duration then
			endBase = endBase or owner.cameraFrame
			assert(owner.cameraFrame:FuzzyEq(endBase, 0.0001), "Caught changed the settled camera")
		end
		if previousBase and t >= timing.duration - 1 / fps and t <= timing.duration + 1 / fps then
			assert(
				(owner.cameraFrame.Position - previousBase.Position).Magnitude < 1,
				"Caught reset the camera position"
			)
		end
		previousBase = owner.cameraFrame
		if index % 30 == 0 then
			task.wait()
		end
	end
	assert(lagged, "No sample covered the camera lag")
	assert(math.abs(maxY - active.liftPlan.peakHeight) < 0.01, "Fish missed its size-adapted apex")
	assert(
		cues.FishWaterOut == 1 and cues.CameraWhoosh == 1 and cues.FishDrop == 1,
		"Water exit or landing cue was missing or repeated"
	)
	assert(#waterBursts == 1 and #impulses == 2, "Water burst or camera impulses repeated")
	assert(waterBursts[1] == math.clamp(frozen / 12, 1, 3), "Wrong size-scaled splash")
	local before = #impulses
	active:Update(110, true)
	assert(#impulses == before, "Stale update replayed feedback")
	local audioFolder, fish = owner.fishAudio.folder, active.fish
	local result = {
		name = template.Name,
		maximum = maximum,
		fps = fps,
		diameter = frozen,
		peak = active.liftPlan.peakHeight,
		cues = cues,
		lag = lagged,
		framed = true,
	}
	cleanup()
	assert(not audioFolder.Parent and not fish.Parent, "Exit left fish or audio objects alive")
	table.insert(job.cases, result)
end

task.spawn(function()
	local ok, err = xpcall(function()
		local smallest, longest, widest
		for _, model in ipairs(storage.Models.Fish:GetChildren()) do
			if model:IsA("Model") and model.PrimaryPart then
				local size = model:GetAttribute("FishBodySize") or model.PrimaryPart.Size
				local radius = Stats.GetModelBounds(model).framingRadius
				if not smallest or radius < smallest.score then
					smallest = { model = model, score = radius }
				end
				if not longest or size.Z > longest.score then
					longest = { model = model, score = size.Z }
				end
				if not widest or math.max(size.X, size.Y) > widest.score then
					widest = { model = model, score = math.max(size.X, size.Y) }
				end
			end
		end
		for _, case in ipairs({
			{ smallest.model, false },
			{ longest.model, false },
			{ widest.model, false },
			{ longest.model, true },
		}) do
			for _, fps in ipairs({ 30, 60, 144 }) do
				run(case[1], case[2], fps)
			end
		end
	end, debug.traceback)
	cleanup()
	camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType = saved[1], saved[2], saved[3], saved[4]
	job.passed, job.done = ok, true
	if not ok then
		table.insert(job.failures, err)
	end
end)
return { started = true }
