-- Studio Client: validate water-camera framing, transitions, and struggle camera noise.
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local Stats = require(storage.Modules.ItemStatUtil)
local config = require(storage.Modules.FishingConfig)
local camera = workspace.CurrentCamera
local saved = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local originalShake = config.Camera.Struggle.Shake
local originalFollow = config.Camera.FollowFishEnabled
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingCameraSmoothnessProbe", workspace
local worldGeometry = Instance.new("Folder")
worldGeometry.Name, worldGeometry.Parent = "FishingCameraWorldGeometry", workspace
local active

local function screenFraction(view, point)
	local relative = view.CFrame:PointToObjectSpace(point)
	if relative.Z >= 0 then
		return math.huge
	end
	local height = -relative.Z * math.tan(math.rad(view.FieldOfView * 0.5))
	local width = height * view.ViewportSize.X / view.ViewportSize.Y
	return math.max(math.abs(relative.X) / width, math.abs(relative.Y) / height)
end

local ok, result = xpcall(function()
	local target = Vector3.new(0, 1000, 0)
	local view = config.Camera.BaitView
	local fixed = CFrame.lookAt(target - Vector3.zAxis * view.Distance + Vector3.yAxis * view.Height, target)
	local transitionSamples = 0
	config.Camera.FollowFishEnabled = true
	for _, fps in { 30, 60, 144 } do
		for _, viewport in { Vector2.new(1600, 900), Vector2.new(900, 1600) } do
			local testCamera = { ViewportSize = viewport }
			local bite = {
				timeline = { phase = "Holding", startedAt = 0 },
				lastPathPosition = target + Vector3.xAxis * 2,
				lastPosition = target + Vector3.xAxis * 2,
				lastBaitPosition = target,
				halfLength = 2,
				presentationRadius = 2,
				scale = 1,
			}
			local probe = setmetatable({
				root = { CFrame = CFrame.identity },
				bait = { Position = target, Size = Vector3.one * 2 },
				forward = Vector3.zAxis,
				cameraFrame = fixed,
				cameraFov = 60,
				biteFocus = target,
				shotMode = "Landing",
				shotStarted = 0,
				shotDuration = 0,
				shotFrom = fixed,
				fovFrom = 60,
				impulses = {},
				bite = bite,
				_waterTarget = function() return target end,
			}, Cast)
			local now = 10
			probe:_updateCamera(now, 0, testCamera)
			local eye = probe.cameraFrame.Position
			local function advance(duration)
				local steps = math.ceil(duration * fps)
				for frame = 1, steps do
					local dt = math.min(1 / fps, duration - (frame - 1) / fps)
					now += dt
					probe:_updateCamera(now, dt, testCamera)
					assert((probe.cameraFrame.Position - eye).Magnitude < 0.001, "Fish movement translated the camera")
					assert(screenFraction(testCamera, target) <= 1 / 3 + 0.001, "Bait left the central third")
					assert(testCamera.FieldOfView <= 76.001, "Water FOV exceeded its cap")
					transitionSamples += 1
				end
			end
			advance(0.18)
			assert(math.abs(testCamera.FieldOfView - 60) < 0.01, "Nearby small fish widened the view")
			bite.lastPathPosition = target + Vector3.xAxis * 80
			advance(0.35)
			assert(testCamera.CFrame.LookVector.X > 0.04, "Camera did not turn right toward the fish")
			assert(math.abs(testCamera.FieldOfView - 64) < 0.02, "Distance FOV missed its opening half-life")
			advance(4)
			local settled = testCamera.FieldOfView
			bite.lastPathPosition = target - Vector3.xAxis * 80
			advance(0.72)
			assert(testCamera.CFrame.LookVector.X < -0.04, "Camera did not turn left toward the fish")
			local angle = math.acos(math.clamp(fixed.LookVector:Dot(testCamera.CFrame.LookVector), -1, 1))
			assert(angle <= math.rad(8.01), "Water camera turned beyond its angle limit")
			bite.lastPosition = target + Vector3.xAxis * 100
			bite.lastMouthPosition = target + Vector3.xAxis * 150
			advance(0.2)
			assert(math.abs(testCamera.FieldOfView - settled) < 0.02, "Turning in place changed the FOV")
			bite.lastPathPosition = target
			probe:_updateCamera(now, 0, testCamera)
			local held = testCamera.FieldOfView
			advance(0.3)
			assert(math.abs(testCamera.FieldOfView - held) < 0.02, "FOV narrowed during the hold")
			advance(0.75)
			assert(math.abs(testCamera.FieldOfView - (held + 60) * 0.5) < 0.02, "FOV missed its closing half-life")
			assert(math.abs(testCamera.CFrame.LookVector.X) < 0.01, "Aim did not recenter ahead of the FOV")
			bite.halfLength, bite.presentationRadius = 40, 44
			bite.lastPathPosition = target + Vector3.xAxis * 40
			advance(5)
			assert(math.abs(testCamera.FieldOfView - 68) < 0.02, "Touching large fish should only widen for size")
			assert(math.abs(testCamera.CFrame.LookVector.X) < 0.001, "A long body biased aim near bait")
			bite.lastPathPosition += Vector3.xAxis * 50
			advance(5)
			assert(math.abs(testCamera.FieldOfView - 76) < 0.02, "Distant large fish did not reach both FOV allowances")
		end
	end
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local initial = CFrame.lookAt(target + Vector3.new(0, 12, -18), target)
	local owner = setmetatable({
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		root = { CFrame = CFrame.identity },
		continueLabel = {},
		shotMode = "Landing",
		shotStarted = 10,
		shotDuration = 0,
		shotFrom = initial,
		fovFrom = 60,
		impulses = {},
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_sound = function() end,
		_impulse = function() end,
		_setPhase = function() end,
	}, Cast)
	local shakeFixture = storage.Models.Fish.GreenSeahorse
	active = Bite.new(owner, 10, 10, Random.new(1), Random.new(2), shakeFixture)
	owner.bite = active
	active.timeline:_enter("Struggling", 10, 3)
	local paths, residuals, lowY, highY = {}, {}, math.huge, -math.huge
	for trial, shake in ipairs({ originalShake, 0 }) do
		config.Camera.Struggle.Shake = shake
		owner.cameraFrame, owner.cameraFov, owner.biteFocus, owner.cameraFocus = initial, 60, target, target
		owner.struggleView = nil
		local residual = 0
		for frame = 0, 179 do
			local elapsed = frame / 60
			local now = 10 + elapsed
			active:Update(now, true)
			owner:_updateCamera(now, 1 / 60)
			active:Present(camera.CFrame.Position)
			local base = active:_struggleFrame(elapsed, target)
			if trial == 1 then
				paths[frame] = base
			else
				assert(base:FuzzyEq(paths[frame], 0.0001), "Camera A/B altered fish path")
			end
			if elapsed >= config.Bite.Struggle.BlendTime then
				lowY, highY = math.min(lowY, base.Position.Y), math.max(highY, base.Position.Y)
			end
			local offset = camera.CFrame.Position - owner.cameraFrame.Position
			local forward = owner.cameraFrame.LookVector
			residual += (offset - forward * offset:Dot(forward)).Magnitude ^ 2
		end
		residuals[trial] = math.sqrt(residual / 180)
	end
	assert(highY - lowY < 0.001, "Whole fish still bounces after expansion")
	assert(residuals[1] > residuals[2] * 1.5, "Camera A/B did not isolate struggle shake")
	active:Destroy()
	active = nil
	config.Camera.Struggle.Shake = originalShake

	local framingSamples, contacts, fixedSamples = 0, 0, 0
	for _, name in { "ElderFish", "MechaWhale" } do
		local template = assert(storage.Models.Fish:FindFirstChild(name), "Missing camera test fish " .. name)
		local scale = if name == "MechaWhale" then 160 / Stats.GetModelBounds(template).longest else 1
		local fishConfig = { DefaultWeight = 1, ModelDefaultScale = scale, NibbleCountMin = 2, NibbleCountMax = 2 }
		for _, viewport in { Vector2.new(1600, 900), Vector2.new(900, 1600) } do
			for _, fps in { 30, 60, 144 } do
				local testCamera = { ViewportSize = viewport }
				local dt = 1 / fps
				bait.CFrame = CFrame.new(target)
				owner.cameraFrame, owner.cameraFov, owner.cameraFocus = fixed, 60, target
				owner.biteFocus, owner.shotFrom = target, fixed
				owner.baitViewAim, owner.baitViewFov, owner.baitViewNarrowAt = nil, nil, nil
				owner.struggleView = nil
				owner.showcaseFrom, owner.showcaseFocus = nil, nil
				active = Bite.new(owner, 100, 100, Random.new(7), Random.new(13), template, fishConfig, nil, false, 1)
				owner.bite = active
				local timeline = active.timeline
				local now, seen, alignedNibbles = timeline.appearAt, {}, {}
				local eye, rendered, sawSettledStruggle
				while now < 160 do
					local phase = active:Update(now, true)
					if phase == "Lifting" then
						owner:_updateCamera(now, dt, testCamera)
						assert((owner.showcaseFrom + target):FuzzyEq(rendered, 0.001), "Lift lost the rendered water view")
						break
					end
					if phase == "Struggling" and not seen.Struggling then
						local incoming, fov = owner.cameraFrame, owner.cameraFov
						owner:_updateCamera(timeline.startedAt, 0, testCamera)
						assert(owner.cameraFrame:FuzzyEq(incoming, 0.001), "Hook moved before blending began")
						assert(math.abs(owner.cameraFov - fov) < 0.001, "Hook snapped the FOV")
					end
					owner:_updateCamera(now, dt, testCamera)
					rendered = testCamera.CFrame
					active:Present(testCamera.CFrame.Position)
					local mouth = active.fish.PrimaryPart.MouthAttachment.WorldPosition
					local label = string.format("%s %dx%d %d fps %s at %.3fs", name, viewport.X, viewport.Y, fps, phase, now)
					local elapsed = now - timeline.startedAt
					if phase == "Struggling" then
						if elapsed >= config.Camera.Struggle.EntryBlendTime then
							sawSettledStruggle = true
							local base = owner.struggleView.frame
							local _, turn = base.Rotation:ToObjectSpace(owner.cameraFrame.Rotation):ToAxisAngle()
							assert((owner.cameraFrame.Position - base.Position).Magnitude < 0.001, "Struggle eye moved: " .. label)
							assert(turn <= math.rad(config.Camera.Struggle.FollowDegrees + 0.01), "Struggle turned too far: " .. label)
							assert(testCamera.FieldOfView == config.Camera.BaitView.Fov, "Struggle changed FOV: " .. label)
							fixedSamples += 1
						end
					else
						eye = eye or testCamera.CFrame.Position
						assert((testCamera.CFrame.Position - eye).Magnitude < 0.001, "Water view moved: " .. label)
						assert(screenFraction(testCamera, bait.Position) <= 1 / 3 + 0.001, "Bait left central third: " .. label)
					end
					assert(testCamera.CFrame.Position.Y > target.Y, "Water camera submerged: " .. label)
					local timing = timeline:GetNibbleTiming()
					local nibbleContact = phase == "Nibbling" and elapsed >= timing.attackTime and elapsed < timing.returnAt
					local trueBite = phase == "Bite" and elapsed >= config.Bite.BiteSinkTime
					if nibbleContact or trueBite then
						local yaw = active:_feedingState(phase, elapsed)
						local contact = bait.Position + active:_contactOffset(yaw, bait.Size)
						assert(screenFraction(testCamera, contact) < 0.01, "Camera missed the contact point: " .. label)
						local viewEye = testCamera.CFrame.Position
						assert((mouth - viewEye).Unit:Cross((contact - viewEye).Unit).Magnitude < 0.002,
							"Fish mouth slipped from the contact point: " .. label)
						if nibbleContact then
							alignedNibbles[timeline.nibbleIndex] = true
						elseif elapsed >= config.Bite.BiteSinkTime + 0.02 then
							assert(active:TryHook(now), "Regression fixture missed the hook")
						end
						contacts += 1
					end
					seen[phase], framingSamples = true, framingSamples + 1
					now += dt
				end
				assert(alignedNibbles[1] and alignedNibbles[2] and sawSettledStruggle and owner.showcaseFrom,
					"Regression fixture missed a phase for " .. name)
				active:Destroy()
				active = nil
			end
		end
	end

	local wall = Instance.new("Part")
	wall.Name, wall.Anchored, wall.Size = "StruggleWall", true, Vector3.new(80, 80, 0.5)
	local wallSamples = 0
	for _, case in { { 2, 50 }, { 45, 50 }, { 2, 9 }, { 45, 9 } } do
		local radius, wallDistance = case[1], case[2]
		wall.Position = target - Vector3.zAxis * wallDistance
		wall.Parent = worldGeometry
		for _, viewport in { Vector2.new(1600, 900), Vector2.new(900, 1600) } do
			local testCamera = { ViewportSize = viewport }
			local probe = setmetatable({
				folder = folder,
				root = { CFrame = CFrame.identity },
				bait = { Position = target, Size = Vector3.one },
				forward = Vector3.zAxis,
				cameraFrame = fixed,
				cameraFov = 60,
				shotMode = "Landing",
				shotStarted = 0,
				shotDuration = 0,
				shotFrom = fixed,
				fovFrom = 60,
				impulses = {},
				bite = {
					timeline = { phase = "Struggling", startedAt = 20 },
					lastPosition = target,
					halfLength = radius,
					presentationRadius = radius,
					scale = 1,
				},
				_waterTarget = function() return target end,
				_sampleImpulses = function() return 10, -10, 1, 1, 1, 8 end,
			}, Cast)
			local largestTurn = 0
			local contactLeftFrame = false
			for index = 1, 60 do
				local angle = index * math.pi / 30
				local contact = target + Vector3.new(math.sin(angle) * 40, -1, math.cos(angle) * 40)
				probe.bite.lastMouthPosition = contact
				probe.bite.lastBaitPosition = contact + Vector3.xAxis * 0.5
				probe:_updateCamera(20 + index / 60, 1 / 60, testCamera)
				local renderedPosition = testCamera.CFrame.Position
				assert((probe.cameraFrame.Position - target).Magnitude <= 20.001, "Base struggle camera exceeded 20 studs")
				assert((renderedPosition - target).Magnitude <= 24.001, "Final struggle camera exceeded 24 studs")
				local _, rotation = probe.cameraFrame.Rotation:ToObjectSpace(testCamera.CFrame.Rotation):ToAxisAngle()
				assert((renderedPosition - probe.cameraFrame.Position).Magnitude <= 0.251, "Combined shake translated too far")
				assert(rotation <= math.rad(1.51), "Combined shake rotated too far")
				assert(testCamera.FieldOfView == 60, "Impulse changed fixed struggle FOV")
				if index > config.Camera.Struggle.EntryBlendTime * 60 then
					local base = probe.struggleView.frame
					local _, turn = base.Rotation:ToObjectSpace(probe.cameraFrame.Rotation):ToAxisAngle()
					assert((probe.cameraFrame.Position - base.Position).Magnitude < 0.001, "Fish motion moved the camera eye")
					assert(turn <= math.rad(config.Camera.Struggle.FollowDegrees + 0.01), "Fish motion turned the camera too far")
					largestTurn = math.max(largestTurn, turn)
					contactLeftFrame = contactLeftFrame or screenFraction(testCamera, contact) > 1
				end
				if wallDistance == 9 then
					assert(renderedPosition.Z > wall.Position.Z + wall.Size.Z * 0.5 + 0.25, "Final camera crossed the wall")
				end
				wallSamples += 1
			end
			assert(contactLeftFrame, "Test contact did not challenge the fixed view")
			assert(largestTurn > math.rad(0.5), "Camera never followed the moving mouth")
			local incoming = testCamera.CFrame
			probe.bite.timeline.phase = "Reeling"
			probe.bite.reelMotion = { position = Vector3.new(2, -4, 0), reboundAllowance = 63 }
			probe._sampleImpulses = nil
			probe:_shot("Reel", config.Reel.CameraTime, 21)
			probe:_updateCamera(21, 1 / 60, testCamera)
			assert(testCamera.CFrame:FuzzyEq(incoming, 0.001), "Empty reel lost the rendered water view")
		end
	end

	local reel = setmetatable({
		baitBaseSize = Vector3.one,
		forward = Vector3.zAxis,
		bite = { reelMotion = { reboundAllowance = 63 } },
	}, Cast)
	for _, viewport in { Vector2.new(1600, 900), Vector2.new(900, 1600) } do
		local expectedDistance
		for _, offset in {
			Vector3.new(-2, -300, 1),
			Vector3.new(-2, -0.5, 1),
			Vector3.new(1, 30, 0),
			Vector3.new(0, config.Bite.ShowcaseHeight, 0),
		} do
			reel.bite.reelMotion.position = offset
			local shot, focus = reel:_reelCamera(target, viewport)
			local distance = (shot.Position - focus).Magnitude
			expectedDistance = expectedDistance or distance
			assert((focus - target - offset).Magnitude < 0.001, "Empty reel missed the current bait position")
			assert(distance >= 5.999 and distance < 12, "Unit bait lost the closeup")
			assert(math.abs(distance - expectedDistance) < 0.001, "Reel travel changed camera distance")
		end
	end
	return {
		passed = true,
		transitionSamples = transitionSamples,
		framingSamples = framingSamples,
		contacts = contacts,
		fixedSamples = fixedSamples,
		wallSamples = wallSamples,
		samples = 360,
		verticalSpan = highY - lowY,
		shakeOnRms = residuals[1],
		shakeOffRms = residuals[2],
		restoredShake = originalShake,
	}
end, debug.traceback)
config.Camera.Struggle.Shake = originalShake
config.Camera.FollowFishEnabled = originalFollow
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType = saved[1], saved[2], saved[3], saved[4]
if active then
	active:Destroy()
end
folder:Destroy()
worldGeometry:Destroy()
assert(ok, result)
return result
