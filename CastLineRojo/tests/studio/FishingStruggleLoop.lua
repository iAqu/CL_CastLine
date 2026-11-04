-- Studio Client: double-speed clips keep a curved body across ten uninterrupted loops.
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingStruggleLoopValidation", workspace
local active
local connections = {}
local ok, result = xpcall(function()
	local target = Vector3.new(0, 1000, 0)
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local owner = {
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		statusLabel = {},
		returnLabel = {},
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
	}
	local results = {}
	local function yaw(bone)
		local frame = bone.Transform
		return math.deg(math.atan2(-frame.LookVector.X, frame.RightVector.X))
	end
	for _, sign in ipairs({ 1, -1 }) do
		active = Bite.new(owner, os.clock(), nil, Random.new(1), Random.new(2))
		active.motion.mirror = sign
		local animation = active.animation
		local deadline = os.clock() + 12
		while animation.loading and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(not animation.loading and not animation.failed, "Struggle assets did not load")
		local name = if sign > 0 then "StruggleLeft" else "StruggleRight"
		local track = animation.tracks[name]
		assert(track.Looped and math.abs(track.Length - 0.6) < 0.01, "Published struggle is not a 0.6-second loop")
		local bones = {}
		for _, boneName in ipairs(settings.Motion.Animation.Bones) do
			bones[boneName] = active.fish.PrimaryPart:FindFirstChild(boneName, true)
		end
		local stopped, loops, samples = 0, 0, 0
		table.insert(
			connections,
			track.Stopped:Connect(function()
				stopped += 1
			end)
		)
		table.insert(
			connections,
			track.DidLoop:Connect(function()
				loops += 1
			end)
		)
		local minimumFront, minimumMid, tailMin, tailMax = 100, 100, 100, -100
		local minimumBody, maximumBody = 100, 0
		local maxPhaseDrift = 0
		local peakBase, peakTail = { angle = -100 }, { angle = -100 }
		local maxMouthError = 0
		local startedAt = os.clock()
		active.timeline:_enter("Struggling", startedAt, settings.StruggleTime)
		active:Update(startedAt)
		assert(math.abs(track.Speed - 2) < 0.0001, "Struggle animation did not use double speed")
		while os.clock() - startedAt < settings.StruggleTime - 0.04 do
			local now = os.clock()
			local elapsed = now - startedAt
			active:Update(now)
			local expectedPosition = (elapsed % settings.Struggle.AnimationCycle) * 2
			local drift = math.abs(track.TimePosition - expectedPosition)
			drift = math.min(drift, math.abs(track.Length - drift))
			maxPhaseDrift = math.max(maxPhaseDrift, drift)
			assert(drift <= settings.Motion.Animation.SyncTolerance + 0.001, "Struggle loop lost absolute phase")
			task.wait()
			assert(
				animation.active and animation.active.track == track and track.IsPlaying,
				"Struggle track stopped or changed"
			)
			assert(stopped == 0, "Struggle restarted at a cycle boundary")
			assert(bones.FishBody.Transform:FuzzyEq(CFrame.identity, 0.0001), "Fixed head moved")
			if elapsed >= 0.25 then
				local front, mid = yaw(bones.SpineFront) * sign, yaw(bones.SpineMid) * sign
				minimumFront, minimumMid = math.min(minimumFront, front), math.min(minimumMid, mid)
				assert(front >= 21.8 and front <= 26.2, "Front body bend left authored range")
				assert(mid >= 32.8 and mid <= 39.2, "Mid body bend left authored range")
				minimumBody, maximumBody = math.min(minimumBody, front + mid), math.max(maximumBody, front + mid)
				assert(front + mid >= 54.8 and front + mid <= 65.2, "Total body bend left 55-65 degree range")
				assert(track.WeightCurrent > 0.99, "Loop weight faded at a cycle boundary")
			end
			local tail = yaw(bones.FishTail) * sign
			tailMin, tailMax = math.min(tailMin, tail), math.max(tailMax, tail)
			if elapsed >= 0.25 then
				local base = yaw(bones.TailBase) * sign
				local phaseTime = track.TimePosition / track.Speed
				if base > peakBase.angle then
					peakBase = { angle = base, time = phaseTime }
				end
				if tail > peakTail.angle then
					peakTail = { angle = tail, time = phaseTime }
				end
			end
			local body = active.fish.PrimaryPart
			local mouth = body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
			local contact = bait.CFrame:PointToWorldSpace(Vector3.new(bait.Size.X * 0.5, 0, 0))
			maxMouthError = math.max(maxMouthError, (mouth - contact).Magnitude)
			assert(maxMouthError < 0.001, "Curved fish detached from bait")
			samples += 1
		end
		-- 长帧校时可能跨过循环边界而不发出 DidLoop；持续轨道与绝对相位才是判据。
		assert(loops > 0 and tailMax - tailMin > 45, "Continuous tail loop or its full range is missing")
		local delay = peakTail.time - peakBase.time
		assert(delay > 0.015 and delay < 0.075, "Double-speed tail tip did not lag behind tail base")
		active:Update(startedAt + settings.StruggleTime)
		assert(animation.active.name == "LiftFlop", "Struggle did not transition to lift")
		task.wait(settings.Motion.Animation.FadeTime + 0.05)
		assert(not track.IsPlaying, "Struggle loop survived lift fade")
		results[name] = {
			samples = samples,
			loops = loops,
			minimumFront = minimumFront,
			minimumMid = minimumMid,
			bodyRange = { minimumBody, maximumBody },
			maxPhaseDrift = maxPhaseDrift,
			tailRange = tailMax - tailMin,
			tailDelay = delay,
			maxMouthError = maxMouthError,
		}
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		connections = {}
		active:Destroy()
		active = nil
	end
	return { passed = true, clips = results }
end, debug.traceback)
for _, connection in ipairs(connections) do
	connection:Disconnect()
end
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
