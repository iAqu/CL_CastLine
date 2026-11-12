-- Studio Client: validate water-camera transitions and isolate struggle camera noise.
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local config = require(storage.Modules.FishingConfig)
local camera = workspace.CurrentCamera
local saved = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local originalShake = config.Camera.Struggle.Shake
local originalFollow = config.Camera.FollowFishEnabled
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingCameraSmoothnessProbe", workspace
local active
local ok, result = xpcall(function()
	local target = Vector3.new(0, 1000, 0)
	local view = config.Camera.BaitView
	local fixed = CFrame.lookAt(target - Vector3.zAxis * view.Distance + Vector3.yAxis * view.Height, target)
	local followOffset = Vector3.new(0, 0.65, -0.8).Unit * config.Camera.FollowFishMaxDistance
	local transitionSamples = 0
	config.Camera.FollowFishEnabled = true
	for _, fps in ipairs({ 30, 60, 144 }) do
		local probe = setmetatable({
			root = { CFrame = CFrame.identity },
			bait = { Position = target },
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
			_waterTarget = function() return target end,
		}, Cast)
		local now = 10
		probe:_updateCamera(now, 0)
		local function transition(goalFocus, goalFrame, label)
			local before, focusBefore = probe.cameraFrame, camera.Focus.Position
			local positionError = (before.Position - goalFrame.Position).Magnitude
			local focusError = (focusBefore - goalFocus).Magnitude
			local _, angleError = before:ToObjectSpace(goalFrame):ToAxisAngle()
			probe:_updateCamera(now, 0)
			assert(probe.cameraFrame:FuzzyEq(before, 0.0001), label .. " jumped with zero elapsed time")
			assert((camera.Focus.Position - focusBefore).Magnitude < 0.0001, label .. " snapped focus")
			for frame = 1, math.ceil(fps * 0.6) do
				now += 1 / fps
				probe:_updateCamera(now, 1 / fps)
				if frame == 1 then
					assert((probe.cameraFrame.Position - before.Position).Magnitude < positionError * 0.2 + 0.001,
						label .. " moved too far on its first frame")
					assert((camera.Focus.Position - focusBefore).Magnitude < focusError * 0.2 + 0.001,
						label .. " moved focus too far on its first frame")
				end
				assert((probe.cameraFrame.Position - camera.Focus.Position).Magnitude <= 24.0002,
					label .. " exceeded follow distance")
				transitionSamples += 1
			end
			local _, remainingAngle = probe.cameraFrame:ToObjectSpace(goalFrame):ToAxisAngle()
			assert((probe.cameraFrame.Position - goalFrame.Position).Magnitude <= positionError * 0.055 + 0.001,
				label .. " did not settle in about 0.6 seconds")
			assert((camera.Focus.Position - goalFocus).Magnitude <= focusError * 0.055 + 0.001,
				label .. " focus did not settle")
			assert(math.abs(remainingAngle) <= math.abs(angleError) * 0.055 + 0.001,
				label .. " rotation did not settle")
		end
		local function fish(position)
			return { timeline = { phase = "Approaching" }, lastPosition = position,
				halfLength = 8, presentationRadius = 10, scale = 10 }
		end
		probe.bite = fish(target + Vector3.new(80, 0, 40))
		local goal = target:Lerp(probe.bite.lastPosition, 0.5)
		transition(goal, CFrame.lookAt(goal + followOffset, goal), "Fish appearing")
		probe.bite.timeline.phase = "Escaped"
		transition(target, CFrame.lookAt(target + followOffset, target), "Fish escaping")
		probe.bite = { timeline = { phase = "Settling" } }
		transition(target, fixed, "Next round settling")
		probe.bite = fish(target + Vector3.new(-80, 0, -40))
		goal = target:Lerp(probe.bite.lastPosition, 0.5)
		transition(goal, CFrame.lookAt(goal + followOffset, goal), "Next fish appearing")
		probe.bite = nil
		transition(target, fixed, "Fish removed")
		probe.bite = fish(target + Vector3.new(80, 0, 40))
		goal = target:Lerp(probe.bite.lastPosition, 0.5)
		transition(goal, CFrame.lookAt(goal + followOffset, goal), "Following again")
		config.Camera.FollowFishEnabled = false
		transition(target, fixed, "Follow disabled")
		config.Camera.FollowFishEnabled = true
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
			residual += owner.cameraFrame:ToObjectSpace(camera.CFrame).Position.Magnitude ^ 2
		end
		residuals[trial] = math.sqrt(residual / 180)
	end
	assert(highY - lowY < 0.001, "Whole fish still bounces after expansion")
	assert(residuals[1] > residuals[2] * 1.5, "Camera A/B did not isolate struggle shake")
	return {
		passed = true,
		transitionSamples = transitionSamples,
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
