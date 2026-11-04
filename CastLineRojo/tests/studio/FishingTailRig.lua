-- Studio Client: real published Animator clips, fixed head/mouth, phase selection and cleanup.
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local ReelSpring = require(storage.Modules.FishingReelSpring)
local settings = require(storage.Modules.FishingConfig).Bite
local originalFishName = settings.FishName
settings.FishName = "Elder Fish"
local names = settings.Motion.Animation.Bones
local template = storage.Models.Fish[settings.FishName]
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingTailRigValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local target = Vector3.new(0, 1000, 0)
	local owner = {
		folder = folder,
		forward = Vector3.zAxis,
		bait = bait,
		statusLabel = {},
		returnLabel = {},
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_playRarityVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_sound = function() end,
		_impulse = function() end,
		_setPhase = function() end,
	}
	local phases = {
		{ "Approaching", settings.ApproachTime },
		{ "Holding", 1 },
		{ "Nibbling", settings.NibbleTime },
		{ "Bite", settings.HookWindow },
		{ "Struggling", settings.StruggleTime },
		{ "Lifting", settings.LiftTime },
		{ "Caught", 10 },
		{ "Escaped", settings.EscapeTime },
		{ "Reeling", 1 },
	}
	local samples, moving, clips = 0, {}, {}
	for cycle = 1, 3 do
		active = Bite.new(owner, 100, 100, Random.new(cycle))
		active.motion.mirror = if cycle % 2 == 0 then 1 else -1
		local animation = active.animation
		local deadline = os.clock() + 12
		while animation.loading and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(not animation.loading and not animation.failed, "Published animations did not load")
		for name, track in pairs(animation.tracks) do
			assert(track.Length > 0, "Animation has no real clip data: " .. name)
			assert(
				math.abs(track.Length - settings.Motion.Animation.Clips[name].Duration) < 0.01,
				"Published clip duration changed: " .. name
			)
		end
		local bones, parent = {}, active.fish.PrimaryPart
		for _, name in ipairs(names) do
			parent = assert(parent:FindFirstChild(name), "Missing bone: " .. name)
			bones[name] = parent
		end
		local startedAt = 101
		for _, entry in ipairs(phases) do
			local phase, duration = entry[1], entry[2]
			if phase == "Nibbling" then
				active.timeline.nibbleIndex = 1
				duration = active.timeline:GetNibbleTiming().duration
			end
			active.timeline:_enter(phase, startedAt, duration)
			if phase == "Reeling" then
				active.reelFrom = CFrame.new(-target) * bait.CFrame
				active.reelMotion = ReelSpring.new(active.reelFrom.Position, owner.baitBaseSize.Y, startedAt)
				active.reelScale = owner.baitVisualScale or Vector3.one
			end
			for index = 0, math.ceil(duration * 10) - 1 do
				local elapsed = math.min(index / 10, duration - 0.0001)
				local now = startedAt + elapsed
				active:Update(now)
				task.wait()
				assert(bones.FishBody.Transform:FuzzyEq(CFrame.identity, 0.0001), "Animation moved fixed head")
				if animation.active then
					clips[animation.active.name] = true
					for _, name in ipairs(names) do
						local _, angle = bones[name].Transform:ToAxisAngle()
						if math.abs(angle) > 0.01 then
							moving[name] = true
						end
					end
				end
				local body = active.fish.PrimaryPart
				local mouth = body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
				if phase == "Bite" and elapsed >= settings.BiteSinkTime then
					local yaw = active:_feedingState("Bite", elapsed)
					assert((mouth - (bait.Position + active:_contactOffset(yaw, bait.Size))).Magnitude < 0.001,
						"Actual mouth left bait")
				end
				if phase == "Lifting" or phase == "Caught" then
					local anchor = mouth - Vector3.yAxis
					assert((anchor - active.linePosition).Magnitude < 0.001, "Line is not one stud below the mouth")
				end
				samples += 1
			end
			startedAt += duration
		end
		task.wait(0.2)
		for _, bone in pairs(bones) do
			assert(bone.Transform:FuzzyEq(CFrame.identity, 0.0001), "Stopped animation did not return to neutral")
		end
		local animator = animation.animator
		active:Destroy()
		active:Destroy()
		assert(
			not active.fish.Parent and animation.destroyed and not next(animation.tracks),
			"Fish or tracks survived cleanup"
		)
		assert(not animator.Parent, "Animator survived fish cleanup")
		active = nil
		task.wait()
	end
	for _, name in ipairs(names) do
		local bone = template.PrimaryPart:FindFirstChild(name, true)
		assert(bone.Transform == CFrame.identity, "Session changed template pose")
		if name ~= "FishBody" then
			assert(moving[name], "Animator did not articulate " .. name)
		end
	end
	for name in pairs(settings.Motion.Animation.Clips) do
		assert(clips[name], "Missing clip playback: " .. name)
	end
	-- Destroy while asynchronous preload is outstanding.
	active = Bite.new(owner, 100, 100, Random.new(10))
	local canceled = active.animation
	active:Destroy()
	active = nil
	task.wait(0.1)
	assert(canceled.destroyed and not next(canceled.tracks), "Canceled preload created orphan tracks")
	return {
		passed = true,
		cycles = 3,
		samples = samples,
		checks = "five real clips, four independent bends, fixed head, bait/line, scale, neutral rest, template isolation, canceled load, cleanup",
	}
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
settings.FishName = originalFishName
assert(ok, result)
return result
