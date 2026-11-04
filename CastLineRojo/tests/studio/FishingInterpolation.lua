-- Compare the published dense curves against their backed-up sparse predecessors.
local storage = game:GetService("ReplicatedStorage")
local Animation = require(storage.Modules.FishAnimationController)
local assets = storage.Animation.Fishing.Fish
local fish = storage.Models.Fish["Elder Fish"]:Clone()
fish.Name, fish.Parent = "FishInterpolationValidation", workspace
fish:PivotTo(CFrame.new(0, 2000, 0))
local controller, previousTrack
local ok, result = xpcall(function()
	controller = Animation.new(fish, 0, Random.new(1))
	local deadline = os.clock() + 12
	while controller.loading and os.clock() < deadline do
		task.wait(0.05)
	end
	assert(not controller.failed and not controller.loading, "Dense clips failed to load")
	local bone = fish.PrimaryPart:FindFirstChild("TailBase", true)
	local tip = fish.PrimaryPart:FindFirstChild("FishTail", true)
	local function sample(track, time)
		track.TimePosition = time
		task.wait()
		task.wait()
		local frame = bone.Transform
		assert(fish.PrimaryPart.FishBody.Transform:FuzzyEq(CFrame.identity, 0.0001), "Fixed head moved")
		return math.deg(math.atan2(-frame.LookVector.X, frame.RightVector.X))
	end
	local function profile(track)
		track:Play(0, 1, 0)
		local near = (sample(track, 0.076) - sample(track, 0.074)) / 0.002
		local mid = (sample(track, 0.1135) - sample(track, 0.1115)) / 0.002
		local first = sample(track, 0)
		local left = (first - sample(track, 0.5998)) / 0.0002
		local right = (sample(track, 0.0002) - first) / 0.0002
		track:Stop(0)
		return { nearKeySpeed = near, midSegmentSpeed = mid, seamLeftSpeed = left, seamRightSpeed = right }
	end
	local profiles = {}
	for _, name in ipairs({ "StruggleLeft", "StruggleRight" }) do
		assert(
			assets[name]:GetAttribute("SampleRate") == 80 and assets[name]:GetAttribute("Interpolation") == "Linear",
			"Struggle asset is not the 80 FPS linear bake"
		)
		local current = profile(controller.tracks[name])
		local track = controller.tracks[name]
		local sign = if name == "StruggleLeft" then 1 else -1
		track:Play(0, 1, 0)
		assert(math.abs(sample(track, 0.15) * sign - 22) < 0.05, "Tail-base peak moved")
		sample(track, 0.225)
		local tipYaw = math.deg(math.atan2(-tip.Transform.LookVector.X, tip.Transform.RightVector.X)) * sign
		assert(math.abs(tipYaw - 26) < 0.05, "Delayed tail-tip peak moved")
		track:Stop(0)
		local asset = Instance.new("Animation")
		asset.AnimationId = assert(assets[name]:GetAttribute("SparseBaselineAnimationId"))
		previousTrack = controller.animator:LoadAnimation(asset)
		asset:Destroy()
		deadline = os.clock() + 8
		while previousTrack.Length == 0 and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(previousTrack.Length > 0, "Previous clip unavailable for comparison")
		local previous = profile(previousTrack)
		previousTrack:Destroy()
		previousTrack = nil
		assert(math.abs(previous.nearKeySpeed) < 1, "Baseline did not reproduce the keyframe slowdown")
		assert(math.abs(current.nearKeySpeed) > 50, "Dense interpolation still stops at authored keys")
		assert(current.seamLeftSpeed * current.seamRightSpeed > 0, "Loop reversed at seam")
		assert(math.abs(current.seamLeftSpeed - current.seamRightSpeed) < 10, "Loop velocity jumped at seam")
		profiles[name] = { previous = previous, current = current }
	end
	-- Count actual TimePosition corrections while the production controller plays in real time.
	local raw = controller.tracks.StruggleLeft
	local writes, frames, totalDt, maxDt = 0, 0, 0, 0
	controller.tracks.StruggleLeft = setmetatable({}, {
		__index = function(_, key)
			local value = raw[key]
			if type(value) == "function" then
				return function(_, ...)
					return value(raw, ...)
				end
			end
			return value
		end,
		__newindex = function(_, key, value)
			if key == "TimePosition" then
				writes += 1
			end
			raw[key] = value
		end,
	})
	local startedAt = os.clock()
	controller:Update("Struggling", startedAt, startedAt, 1)
	while os.clock() - startedAt < 3 do
		local dt = game:GetService("RunService").RenderStepped:Wait()
		local now = os.clock()
		if now - startedAt >= 3 then
			break
		end
		controller:Update("Struggling", startedAt, now, 1)
		frames, totalDt, maxDt = frames + 1, totalDt + dt, math.max(maxDt, dt)
	end
	return {
		passed = true,
		profiles = profiles,
		frames = frames,
		fps = frames / totalDt,
		maxFrameMs = maxDt * 1000,
		midPlayCorrections = math.max(0, writes - 1),
	}
end, debug.traceback)
if previousTrack then
	previousTrack:Destroy()
end
if controller then
	controller:Destroy()
end
fish:Destroy()
assert(ok, result)
return result
