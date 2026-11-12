-- Run before changing animation assets: only the struggle camera noise varies between trials.
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local config = require(storage.Modules.FishingConfig)
local camera = workspace.CurrentCamera
local saved = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local originalShake = config.Camera.Struggle.Shake
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingCameraSmoothnessProbe", workspace
local active
local ok, result = xpcall(function()
	local target = Vector3.new(0, 1000, 0)
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
		owner.cameraFrame, owner.cameraFov, owner.biteFocus = initial, 60, nil
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
		samples = 360,
		verticalSpan = highY - lowY,
		shakeOnRms = residuals[1],
		shakeOffRms = residuals[2],
		restoredShake = originalShake,
	}
end, debug.traceback)
config.Camera.Struggle.Shake = originalShake
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType = saved[1], saved[2], saved[3], saved[4]
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
