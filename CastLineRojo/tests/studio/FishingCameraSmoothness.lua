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
	active = Bite.new(owner, 10, 10, Random.new(1), Random.new(2))
	owner.bite = active
	active.timeline:_enter("Struggling", 10, 3)
	local paths, residuals, lowY, highY = {}, {}, math.huge, -math.huge
	for trial, shake in ipairs({ originalShake, 0 }) do
		config.Camera.Struggle.Shake = shake
		owner.cameraFrame, owner.cameraFov, owner.biteFocus, owner.cameraFocus = initial, 60, target, target
		owner.waterViewPullback = nil
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
			local shakenFrame = camera.CFrame * CFrame.new(0, 0, -(owner.waterViewPullback or 0))
			residual += owner.cameraFrame:ToObjectSpace(shakenFrame).Position.Magnitude ^ 2
		end
		residuals[trial] = math.sqrt(residual / 180)
	end
	assert(highY - lowY < 0.001, "Whole fish still bounces after expansion")
	assert(residuals[1] > residuals[2] * 1.5, "Camera A/B did not isolate struggle shake")
	active:Destroy()
	active = nil
	config.Camera.Struggle.Shake = originalShake

	local framingSamples, contacts = 0, 0
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
				owner.waterViewPullback = nil
				owner.showcaseFrom, owner.showcaseFocus = nil, nil
				active = Bite.new(owner, 100, 100, Random.new(7), Random.new(13), template, fishConfig, nil, false, 1)
				owner.bite = active
				local timeline = active.timeline
				local now, seen, alignedNibbles = timeline.appearAt, {}, {}
				local eye
				while now < 160 do
					local phase = active:Update(now, true)
					if phase == "Lifting" then
						local incoming = owner.cameraFrame * CFrame.new(0, 0, owner.waterViewPullback or 0)
						owner:_updateCamera(now, dt, testCamera)
						assert((owner.showcaseFrom + target):FuzzyEq(incoming, 0.001), "Lift lost the incoming water view")
						break
					end
					if phase == "Struggling" and not seen.Struggling then
						local incoming, fov = owner.cameraFrame, owner.cameraFov
						owner:_updateCamera(now, 0, testCamera)
						assert(owner.cameraFrame:FuzzyEq(incoming, 0.001), "Hook moved before blending began")
						assert(math.abs(owner.cameraFov - fov) < 0.001, "Hook snapped the FOV")
					end
					owner:_updateCamera(now, dt, testCamera)
					active:Present(testCamera.CFrame.Position)
					local mouth = active.fish.PrimaryPart.MouthAttachment.WorldPosition
					local label = string.format("%s %dx%d %d fps %s at %.3fs", name, viewport.X, viewport.Y, fps, phase, now)
					local elapsed = now - timeline.startedAt
					if phase == "Struggling" then
						assert(screenFraction(testCamera, mouth) < 1, "Struggling mouth clipped: " .. label)
						assert(screenFraction(testCamera, bait.Position) < 1, "Struggling bait clipped: " .. label)
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
				assert(alignedNibbles[1] and alignedNibbles[2] and seen.Struggling and owner.showcaseFrom,
					"Regression fixture missed a phase for " .. name)
				active:Destroy()
				active = nil
			end
		end
	end
	return {
		passed = true,
		transitionSamples = transitionSamples,
		framingSamples = framingSamples,
		contacts = contacts,
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
assert(ok, result)
return result
