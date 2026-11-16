-- 在 Studio Client 中执行；使用真实实例和正式模块，结束时清理测试对象。
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cast = require(ReplicatedStorage.Modules.FishingCastSequence)
local Bite = require(ReplicatedStorage.Modules.FishingBiteSequence)
local FishAnimation = require(ReplicatedStorage.Modules.FishAnimationController)
local Audio = require(ReplicatedStorage.Modules.FishingAudio)
local config = require(ReplicatedStorage.Modules.FishingConfig)
local settings = config.Bite
local originalFishName = settings.FishName
settings.FishName = "GreenSeahorse"
local template = ReplicatedStorage.Models.Fish[settings.FishName]
local originalTexture, originalColor = template.PrimaryPart.TextureID, template.PrimaryPart.Color
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingPresentationValidation", workspace
local owner
local camera = workspace.CurrentCamera
local savedCamera = { frame = camera.CFrame, focus = camera.Focus, fov = camera.FieldOfView, mode = camera.CameraType }

local function anchor(name)
	local part = Instance.new("Part")
	part.Name, part.Transparency, part.Anchored, part.Parent = name, 1, true, folder
	local attachment = Instance.new("Attachment")
	attachment.Parent = part
	return part, attachment
end

local ok, result = xpcall(function()
	local target = Vector3.new(1838, 772, 1010)
	local bait = ReplicatedStorage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 0.25, folder
	local lineEnd, endAttachment = anchor("LineEnd")
	local lineTop, topAttachment = anchor("LineTop")
	local rod, tip = anchor("Rod")
	rod.Position = target - Vector3.zAxis * 55
	local baitHighlight = Instance.new("Highlight")
	baitHighlight.Adornee, baitHighlight.OutlineColor, baitHighlight.OutlineTransparency = bait, Color3.new(1, 1, 1), 0
	baitHighlight.FillColor = Color3.fromRGB(unpack(settings.BaitFillColor))
	baitHighlight.Parent = folder
	local line = Instance.new("Beam")
	line.Attachment0, line.Attachment1, line.Parent = tip, endAttachment, folder
	owner = setmetatable({
		options = {},
		folder = folder,
		phase = "Waiting",
		forward = Vector3.zAxis,
		spin = 0,
		landedAt = 0,
		root = { CFrame = CFrame.identity },
		cameraFrame = CFrame.lookAt(target - Vector3.zAxis * 18 + Vector3.yAxis * 12, target),
		cameraFov = settings.ShowcaseFov,
		bait = bait,
		baitAppearance = { [bait] = 0.25 },
		baitHighlight = baitHighlight,
		impulses = {},
		impulseCount = 0,
		_impulse = function(self, ...)
			self.impulseCount += 1
			Cast._impulse(self, ...)
		end,
		line = line,
		lineEnd = lineEnd,
		lineEndAttachment = endAttachment,
		lineTop = lineTop,
		lineTopAttachment = topAttachment,
		tip = tip,
		continueLabel = {},
		wind = { Volume = 0, Stop = function() end },
		_waterTarget = function()
			return target
		end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_sound = function(self, name)
			if name == "CameraWhoosh" then return end
			assert(name == "FishBiteHeavey", "Unexpected bite cue")
			self.biteCues = (self.biteCues or 0) + 1
		end,
	}, Cast)
	owner.fishAudio = setmetatable({
		Play = function(_, name)
			if name == "FishBiteHeavey" then
				owner:_sound(name)
			end
		end,
		StartLoop = function() end,
		StopLoop = function() end,
		UpdateFlap = function() end,
		Destroy = function() end,
	}, Audio)
	local function round(at, nibbles, sector)
		owner:_startBiteRound(at)
		local random = {
			NextInteger = function(_, low)
				return if low == 0 then nibbles or 0 else sector or 1
			end,
			NextNumber = function(_, low)
				return if low == 1 then 2 elseif low < 0 then 0 else 1
			end,
		}
		if sector then
			owner.bite:Destroy()
			owner.bite = Bite.new(owner, at, at, random)
		else
			owner.bite.timeline = Bite.NewTimeline(at, random)
		end
	end
	local function update(at)
		owner:_updateBait(at, 1 / 60)
		owner.bite:Present()
		owner:_updateLine()
	end
	local function assertShowcaseLine(point)
		assert((line.Attachment1.WorldPosition - point).Magnitude < 0.001, "Line detached from showcase anchor")
		local delta = line.Attachment0.WorldPosition - point
		assert(
			line.Attachment0 == topAttachment
				and math.abs(delta.X) < 0.001
				and math.abs(delta.Z) < 0.001
				and math.abs(delta.Y - settings.ShowcaseLineHeight) < 0.001,
			"Showcase line did not stay vertically above its anchor"
		)
	end
	local function assertFishShowcaseLine()
		local bite = owner.bite
		local mouth = bite.fish.PrimaryPart.CFrame:PointToWorldSpace(bite.mouthOffset * bite.scale)
		assertShowcaseLine(mouth - Vector3.yAxis)
	end
	local function assertCaughtOutline(bite)
		assert(
			bite.highlight.Enabled and bite.highlight.Adornee == bite.fish
				and bite.highlight.FillTransparency == 1
				and bite.highlight.OutlineTransparency == 0
				and bite.highlight.OutlineColor == Color3.new(0, 0, 0)
				and bite.highlight.DepthMode == Enum.HighlightDepthMode.Occluded,
			"Surfaced fish lost its occluded black outline"
		)
	end
	local function fishCount()
		local count = 0
		for _, child in ipairs(folder:GetChildren()) do
			if child.Name == "BitingFish" then
				count += 1
			end
		end
		return count
	end

	round(0, 1, 1)
	do
		local bite = owner.bite
		local timeline = bite.timeline
		local tail = bite.fish.PrimaryPart:FindFirstChild("FishTail", true)
		local deadline = os.clock() + settings.Motion.Animation.LoadTimeout
		while bite.animation.loading and os.clock() < deadline do
			task.wait()
		end
		assert(not bite.animation.loading and not bite.animation.failed, "Shadow animation failed to load")
		local function assertTailMoves(name, start, duration)
			local previous, moved
			for index = 0, 8 do
				update(start + duration * index / 8)
				task.wait(0.025)
				local pose = tail.Transform
				moved = moved or (previous and not pose:FuzzyEq(previous, 0.001))
				previous = pose
			end
			assert(moved, "Fish shadow tail stayed still during " .. name)
		end
		local approach = timeline.appearAt
		local hold = approach + timeline.approachTime
		assertTailMoves("approach", approach + 0.2, timeline.approachTime - 0.4)
		assertTailMoves("hold", hold + 0.1, 0.6)
		local nibble = hold + 1
		local timing = timeline:GetNibbleTiming(1)
		update(nibble + timing.attackTime)
		local cameraPosition = owner.cameraFrame.Position
		bite:Present(cameraPosition)
		local yaw = bite:_feedingState("Nibbling", timing.attackTime)
		local mouth = bite.fish.PrimaryPart.MouthAttachment.WorldPosition
		local contact = bait.Position + bite:_contactOffset(yaw, bait.Size)
		local screenError = (mouth - cameraPosition).Unit:Cross((contact - cameraPosition).Unit).Magnitude
		assert(screenError < 0.0001, "Nibble animation moved the mouth off the bait on screen")
		local returnDuration = timeline.repositionDurations[1]
		assertTailMoves("return", nibble + timing.returnAt + returnDuration * 0.2, returnDuration * 0.6)
	end

	-- 三个出现方向保持实际尺寸，通过透明度和深度显现。
	for sector = 1, 3 do
		round(0, 0, sector)
		local bite = owner.bite
		assert(
			not bite.highlight.Enabled
				and bite.highlight.FillTransparency == 1
				and bite.highlight.OutlineTransparency == 1
				and bite.fish.PrimaryPart.Transparency == 1,
			"New fish flashed before its first update"
		)
		local shadowHumanoid = bite.fish:FindFirstChildOfClass("Humanoid")
		assert(
			shadowHumanoid
				and not shadowHumanoid.EvaluateStateMachine
				and not shadowHumanoid.AutomaticScalingEnabled
				and shadowHumanoid.DisplayDistanceType == Enum.HumanoidDisplayDistanceType.None,
			"Transparent shadow highlight requires a passive Humanoid"
		)
		assert(
			bite.animation.animator.Parent == shadowHumanoid and not bite.fish:FindFirstChildOfClass("AnimationController"),
			"Shadow must have a single animation controller under its Humanoid"
		)
		update(2)
		local start = owner.bite.lastPosition
		assert(owner.bite.spawnSector == sector and owner.bite.scale == 1, "Spawn sector/actual scale is wrong")
		assert(owner.bite.fish.PrimaryPart.Transparency > 0.99, "Fish did not fade in")
		local delta = (start - target) * Vector3.new(1, 0, 1)
		local expected = if sector == 1 then owner.forward elseif sector == 2 then -owner.bite.side else owner.bite.side
		assert(delta.Unit:Dot(expected) > 0.99, "Fish did not appear from the requested direction")
		for _, rate in ipairs({ 30, 60 }) do
			for frame = 0, math.ceil(settings.AppearTime * rate) do
				local elapsed = math.min(frame / rate, settings.AppearTime)
				update(2 + elapsed)
				local progress = math.clamp(elapsed / settings.AppearTime, 0, 1)
				local fade = 1 - progress * progress * (3 - 2 * progress)
				assert(math.abs(bite.fish.PrimaryPart.Transparency - fade) < 1e-6, "Fish appearance easing is wrong")
				assert(
					bite.fish.PrimaryPart.Material
						== (if elapsed > 0 then Enum.Material.Neon else template.PrimaryPart.Material)
						and bite.fish.PrimaryPart.Reflectance == (if elapsed > 0 then 0 else template.PrimaryPart.Reflectance),
					"Fish shadow material is wrong"
				)
				assert(
					math.abs(
						bite.highlight.FillTransparency
							- (settings.ShadowTransparency + (1 - settings.ShadowTransparency) * fade)
					)
							< 1e-6
						and math.abs(bite.highlight.OutlineTransparency - (0.2 + 0.8 * fade ^ 3)) < 1e-6,
					"Fish shadow did not follow appearance easing"
				)
			end
		end
		update(2 + settings.AppearTime)
		assert(
			math.abs(owner.bite.scale - 1) < 0.001 and owner.bite.lastPosition.Y > start.Y,
			"Fish changed size or did not rise"
		)
	end

	-- 水中摆身围绕嘴部叠加，不能改变路径上的接触点。
	local resting = owner.bite
	local outward = resting.spawnDirection
	local neutral = target
		+ resting.contactOffset
		+ outward * (resting.halfLength + settings.NibbleGap)
		- Vector3.yAxis * resting.depth
	local reference = CFrame.lookAt(neutral, neutral - outward)
	local expectedMouth = reference:PointToWorldSpace(resting.mouthOffset)
	local swimAngle = 0
	for index = 1, 60 do
		local pose = resting:_pose("Holding", index / 60, target, 4 + index / 60)
		local _, angle = reference.Rotation:ToObjectSpace(pose.Rotation):ToAxisAngle()
		swimAngle = math.max(swimAngle, math.abs(angle))
		assert(
			(pose:PointToWorldSpace(resting.mouthOffset) - expectedMouth).Magnitude < 0.001,
			"Swim moved mouth pivot"
		)
	end
	assert(swimAngle < 0.001, "Whole-body procedural swim sway is still active")

	-- 真咬保留鱼饵和原朝向，红色填充，鱼嘴落在进食直线的边缘交点。

	round(0)
	update(0)
	local trueBite = 2 + settings.ApproachTime + 1
	update(trueBite + 0.2)
	assert(bait.Transparency == 0.25 and owner.bite.timeline.baitConsumed, "True bite hid bait")
	assert(
		math.abs(baitHighlight.FillTransparency - settings.BaitFillTransparency) < 0.0001,
		"True bite did not turn bait red"
	)
	local contact = bait.Position + owner.bite:_contactOffset(0, bait.Size)
	local mouthAtBite = owner.bite.fish.PrimaryPart.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
	assert((contact - mouthAtBite).Magnitude < 0.001, "Fish missed bait edge on approach line")
	local deadline = owner.bite.timeline.endsAt
	update(deadline)
	assert(owner.phase == "Escaped" and not owner:CanReturn(deadline + 10), "Failure enabled return")
	assert(not owner.continueLabel.Visible, "Escaped fish displayed return prompt")
	local oldFish, oldRound = owner.bite.fish, owner.round
	for frame = 0, 42 do
		local progress = frame / 42
		-- 直接更新咬钩表现，保留末帧以检查，暂不触发父会话自动重试。
		owner.bite:Update(deadline + settings.EscapeTime * progress)
		local fade = progress * progress * (3 - 2 * progress)
		assert(math.abs(oldFish.PrimaryPart.Transparency - fade) < 1e-6, "Escaping fish fade is wrong")
		assert(
			math.abs(
				owner.bite.highlight.FillTransparency
					- (settings.ShadowTransparency + (1 - settings.ShadowTransparency) * fade)
			) < 1e-6
				and math.abs(owner.bite.highlight.OutlineTransparency - (0.2 + 0.8 * fade ^ 3)) < 1e-6,
			"Escaping shadow fade is wrong"
		)
	end
	assert(not owner.bite.highlight.Enabled, "Fully escaped shadow stayed enabled")
	assert(oldFish.PrimaryPart.Material == template.PrimaryPart.Material, "Escaped fish retained the shadow material")
	update(deadline + settings.EscapeTime + 0.01)
	assert(
		owner.round == oldRound + 1 and oldFish.Parent == nil and fishCount() == 1,
		"Retry did not replace exactly one fish"
	)
	assert(bait.Transparency == 0.25 and line.Attachment0 == tip, "Retry did not restore bait/line")
	assert(
		owner.continueLabel.Text == settings.Text.Waiting,
		"Retry kept the failure prompt"
	)
	local restartedAt = deadline + settings.EscapeTime + 0.01
	assert(
		owner.bite.timeline.appearAt >= restartedAt + 1 and owner.bite.timeline.appearAt <= restartedAt + 3,
		"Retry delay is outside 1-3 seconds"
	)

	-- 连续超时和长帧只重开一轮，不积累鱼或追赶过期轮次。
	for index = 1, 12 do
		local at = index * 200
		round(at)
		update(at)
		local number = owner.round
		update(at + 100)
		assert(
			owner.round == number + 1 and fishCount() == 1 and owner.phase == "Waiting",
			"A long frame restarted multiple rounds"
		)
		assert(not owner.bite.timeline.baitConsumed and bait.Transparency == 0.25, "Retry kept consumed bait")
		assert(owner.bite.timeline.appearAt >= at + 101, "Retry reused stale time")
	end

	-- 已经过期的真咬不补播；当前真咬多帧更新只响一次。
	local previousCues = owner.biteCues or 0
	round(2600)
	update(2600 + trueBite + settings.HookWindow + 0.1)
	assert((owner.biteCues or 0) == previousCues, "Expired bite replayed cue")
	round(2700)
	update(2700 + trueBite + 0.01)
	update(2700 + trueBite + 0.02)
	assert(owner.biteCues == previousCues + 1, "Bite cue missing or duplicated")

	-- 空钩先下潜再出水回弹；平视镜头固定焦点，停稳后再次点击才返回。
	round(2800)
	update(2800)
	bait.CFrame *= CFrame.Angles(math.rad(8), math.rad(137), math.rad(-6))
	local reelAt = 2800.1
	local reelConfig = config.Reel
	local initialBait = bait.CFrame
	local beforeImpulses = owner.impulseCount
	local feedback = 0
	owner._waterFeedback = function(_, _, _, strength, splash)
		assert(strength == 0.35 and splash, "Empty reel did not use a small splash")
		feedback += 1
	end
	assert(not owner:TryHook(reelAt) and not owner:CanReturn(reelAt), "First reel tap returned immediately")
	update(reelAt)
	assert((bait.Position - initialBait.Position).Magnitude < 0.001, "Reeling snapped bait at entry")
	local _, entryAngle = initialBait.Rotation:ToObjectSpace(bait.CFrame.Rotation):ToAxisAngle()
	assert(math.abs(entryAngle) < 0.001, "Reeling snapped bait rotation at entry")
	assert(not owner.continueLabel.Visible, "Reeling showed premature result UI")
	local reelPeak = -math.huge
	local reelBottom = math.huge
	local expectedBottom = initialBait.Position.Y - owner.baitBaseSize.Y * reelConfig.SinkDepth
	local maxSway = 0
	-- spr 由 PreSimulation 推进；此处必须逐帧等待，不能仅跳动测试时钟。
	local reelFrames, reelEnd = {}, nil
	local realStart, elapsed = os.clock(), 0
	for index = 1, 600 do
		local at = reelAt + elapsed
		owner:TryHook(at)
		update(at)
		owner:_updateCamera(at, 1 / 60)
		if index == 1 then
			local sway = owner.cameraFrame:ToObjectSpace(camera.CFrame)
			-- 相同 CFrame 的往返也可能被 ToAxisAngle 算出约 0.00069 弧度，直接比较基向量。
			assert(
				sway.Position.Magnitude < 0.0001
					and (owner.cameraFrame.LookVector - camera.CFrame.LookVector).Magnitude < 0.00001
					and (owner.cameraFrame.UpVector - camera.CFrame.UpVector).Magnitude < 0.00001,
				"Empty reel camera sway jumped at entry"
			)
		end
		reelPeak = math.max(reelPeak, bait.Position.Y)
		reelBottom = math.min(reelBottom, bait.Position.Y)
		if elapsed > 0 and elapsed < reelConfig.SinkTime then
			assert(bait.Position.Y < initialBait.Position.Y, "Empty reel did not sink before rising")
		elseif math.abs(elapsed - reelConfig.SinkTime) < 0.000001 then
			assert(math.abs(bait.Position.Y - expectedBottom) < 0.03, "Empty reel sink depth is wrong")
		elseif elapsed > reelConfig.SinkTime + 0.05 and elapsed < reelConfig.SinkTime + 0.2 then
			assert(bait.Position.Y > expectedBottom, "Empty reel did not rise after sinking")
		end
		assert(
			(bait.CFrame.LookVector - initialBait.LookVector).Magnitude < 0.00001
				and (bait.CFrame.UpVector - initialBait.UpVector).Magnitude < 0.00001,
			"Empty reel changed the initial bait orientation"
		)
		assert(owner.bite.fish.PrimaryPart.Transparency == 1, "Empty reel showed a fish")
		assert(
			owner.bite.fish.PrimaryPart.Material == template.PrimaryPart.Material,
			"Empty reel retained Glass material"
		)
		assert(
			not owner.bite.highlight.Enabled
				and owner.bite.highlight.FillTransparency == 1
				and owner.bite.highlight.OutlineTransparency == 1,
			"Empty reel retained a fish shadow"
		)
		assert(
			bait.Transparency == 0.25 and baitHighlight.Enabled and baitHighlight.FillTransparency == 1,
			"Empty reel lost bait appearance"
		)
		assertShowcaseLine(bait.Position)
		if elapsed >= reelConfig.CameraTime then
			assert(math.abs(owner.cameraFrame.LookVector.Y) < 0.0001, "Empty reel base camera did not stay level")
			assert(
				owner.cameraFrame.LookVector:Dot(owner.forward) > 0.9999,
				"Empty reel camera did not retain the cast direction"
			)
			local sway = owner.cameraFrame:ToObjectSpace(camera.CFrame)
			local pitch, yaw, roll = sway:ToOrientation()
			maxSway = math.max(maxSway, sway.Position.Magnitude)
			assert(
				sway.Position.Magnitude < 0.05
					and math.max(math.abs(pitch), math.abs(yaw), math.abs(roll)) < math.rad(0.4),
				"Empty reel sway exceeded its gentle limits"
			)
			assert(math.abs(camera.FieldOfView - settings.ShowcaseFov) < 0.001, "Empty reel sway changed FOV")
			assert(
				(camera.Focus.Position - target - Vector3.yAxis * settings.ShowcaseHeight).Magnitude < 0.001,
				"Empty reel camera followed the bounce"
			)
		end
		table.insert(reelFrames, { frame = bait.CFrame, size = bait.Size })
		if owner.phase == "Reeled" then
			reelEnd = owner.bite.timeline.startedAt
			break
		end
		task.wait()
		elapsed = os.clock() - realStart
		assert(elapsed < 4, "Reel spring did not settle before the deadline")
	end
	assert(
		reelPeak > target.Y + settings.ShowcaseHeight + 0.9
			and reelPeak < target.Y + settings.ShowcaseHeight + owner.bite.reelMotion.reboundAllowance,
		"Empty reel used the sky arc or missed its bounce"
	)
	assert(math.abs(reelBottom - expectedBottom) < 0.05, "Empty reel did not approach its sink depth")
	assert(
		feedback == 1 and owner.impulseCount == beforeImpulses,
		"Empty reel repeated splash or used fish camera impact"
	)
	assert(maxSway > 0.0001, "Empty reel camera has no sway")
	owner._waterFeedback = function() end
	assert(owner.phase == "Reeled" and owner.folder:GetAttribute("Phase") == "Reeled", "Reel phase was not published")
	assert(reelEnd, "Spring did not report physical settling")
	update(reelEnd + reelConfig.HoldTime - 0.01)
	assert(
		not owner:CanReturn(reelEnd + reelConfig.HoldTime - 0.01) and not owner.continueLabel.Visible,
		"Empty reel did not wait to settle"
	)
	update(reelEnd + reelConfig.HoldTime)
	assert(
		owner:CanReturn(reelEnd + reelConfig.HoldTime)
			and not owner.continueLabel.Visible,
		"Empty reel showed a manual return prompt"
	)
	local firstSway
	local sustainedSway = 0
	for index = 0, 50 do
		local at = reelEnd + reelConfig.HoldTime + index * 0.1
		update(at)
		owner:_updateCamera(at, 1 / 60)
		local sway = owner.cameraFrame:ToObjectSpace(camera.CFrame)
		firstSway = firstSway or sway
		assertShowcaseLine(bait.Position)
		sustainedSway = math.max(sustainedSway, (sway.Position - firstSway.Position).Magnitude)
		assert(
			math.abs(owner.cameraFrame.LookVector.Y) < 0.0001 and sway.Position.Magnitude < 0.05,
			"Reeled showcase sway tilted the base camera or grew too strong"
		)
		assert(
			(camera.Focus.Position - target - Vector3.yAxis * settings.ShowcaseHeight).Magnitude < 0.001,
			"Reeled showcase sway moved its focus"
		)
	end
	assert(sustainedSway > 0.0001, "Reeled showcase stopped swaying while waiting for return")
	local restingBait = bait.CFrame
	local restingEye = owner.cameraFrame.Position
	target += Vector3.yAxis * 2
	update(reelEnd + 2)
	owner:_updateCamera(reelEnd + 2, 1 / 60)
	assertShowcaseLine(bait.Position)
	assert(
		(bait.Position - restingBait.Position - Vector3.yAxis * 2).Magnitude < 0.001
			and (owner.cameraFrame.Position - restingEye - Vector3.yAxis * 2).Magnitude < 0.001,
		"Empty reel did not follow the water level"
	)
	target -= Vector3.yAxis * 2
	for _, size in ipairs({ Vector2.new(390, 844), Vector2.new(844, 390), Vector2.new(1877, 1240) }) do
		local view, focus = owner:_reelCamera(target, size)
		local tanY = math.tan(math.rad(settings.ShowcaseFov * 0.5))
		for _, sample in ipairs(reelFrames) do
			local pose = sample.frame
			for _, x in ipairs({ -1, 1 }) do
				for _, y in ipairs({ -1, 1 }) do
					for _, z in ipairs({ -1, 1 }) do
						local point =
							view:PointToObjectSpace(pose:PointToWorldSpace(sample.size * Vector3.new(x, y, z) * 0.5))
						assert(
							point.Z < 0
								and math.abs(point.Y) < -point.Z * tanY
								and math.abs(point.X) < -point.Z * tanY * size.X / size.Y,
							"Empty reel clipped bait"
						)
					end
				end
			end
		end
		assert(math.abs(view.Position.Y - focus.Y) < 0.001, "Portrait empty reel camera tilted")
		assert(
			(view.Position - focus):Dot(owner.forward) < 0 and view.LookVector:Dot(owner.forward) > 0.9999,
			"Portrait empty reel camera did not retain the cast direction"
		)
	end
	local savedForward = owner.forward
	for _, forward in ipairs({ Vector3.xAxis, -Vector3.zAxis }) do
		owner.forward = forward
		local view, focus = owner:_reelCamera(target, camera.ViewportSize)
		assert(
			(view.Position - focus):Dot(forward) < 0 and view.LookVector:Dot(forward) > 0.9999,
			"Empty reel camera uses a fixed world direction"
		)
	end
	owner.forward = savedForward
	local endedRound = owner.round
	update(2900)
	assert(owner.round == endedRound and not owner.bite:CanRetry(2900), "Reeled cast automatically retried")

	-- 连续随机变速缩圈；鱼线末端始终跟随鱼饵。
	round(3000)
	local hookAt = 3000 + trueBite + 0.2
	assert(owner:TryHook(hookAt), "True bite did not accept hook input")
	local previousHighlight = settings.ShadowTransparency
	for _, struggleElapsed in ipairs({ 0, 0.125, 0.25, 0.375, 0.5, 0.75 }) do
		update(hookAt + struggleElapsed)
		local bite = owner.bite
		local progress = math.clamp(struggleElapsed / settings.Struggle.HighlightFadeTime, 0, 1)
		local eased = progress * progress * (3 - 2 * progress)
		local transparency = bite.highlight.FillTransparency
		assert(
			math.abs(transparency - (settings.ShadowTransparency + (1 - settings.ShadowTransparency) * eased)) < 1e-6
				and math.abs(bite.highlight.OutlineTransparency - (0.2 + 0.8 * eased ^ 3)) < 1e-6
				and transparency >= previousHighlight,
			"Struggle highlight did not fade smoothly"
		)
		assert(bite.highlight.Enabled == (progress < 1), "Struggle highlight fade endpoint is wrong")
		for part, saved in pairs(bite.originals) do
			assert(part.Transparency == saved.transparency, "Highlight fade hid the fish body")
		end
		previousHighlight = transparency
	end
	update(hookAt + 0.82)
	local first = owner.bite.fish.PrimaryPart.Position
	update(hookAt + 1.03)
	assert((first - owner.bite.fish.PrimaryPart.Position).Magnitude > 0.1, "Orbit paused")
	update(hookAt + 1.35)
	local orbitRadius = ((first - target) * Vector3.new(1, 0, 1)).Magnitude
	assert((first - owner.bite.fish.PrimaryPart.Position).Magnitude > orbitRadius * 0.05, "Orbit stopped moving")
	local body = owner.bite.fish.PrimaryPart
	local mouth = body.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
	assert(
		(line.Attachment1.WorldPosition - bait.Position).Magnitude < 0.001 and bait.Transparency == 0.25,
		"Line detached from visible bait"
	)
	local sideContact = bait.CFrame:PointToWorldSpace(Vector3.new(bait.Size.X * 0.5, 0, 0))
	assert((sideContact - mouth).Magnitude < 0.001, "Struggling fish lost side contact")
	assert(owner.bite.timeline.endsAt == hookAt + 3, "Orbit changed struggle duration")
	owner.root = { CFrame = CFrame.identity }
	owner.cameraFrame = CFrame.lookAt(target - Vector3.zAxis * 18 + Vector3.yAxis * 12, target)
	owner.cameraFov, owner.shotMode, owner.shotDuration = 60, "Landing", 0
	owner.shotStarted, owner.shotFrom, owner.fovFrom = hookAt - 1, owner.cameraFrame, 60
	owner.biteFocus = target
	owner:_updateCamera(hookAt + 0.75, 1 / 60)
	assert(owner.cameraFrame:ToObjectSpace(camera.CFrame).Position.Magnitude > 0.001, "Struggle camera has no shake")

	-- 出水保持竖线，完全出水才恢复彩色；最终鱼头朝上。
	local liftingAt = owner.bite.timeline.endsAt
	local liftImpulsesBefore = owner.impulseCount
	update(liftingAt)
	assert(
		not owner.bite.highlight.Enabled
			and owner.bite.highlight.FillTransparency == 1
			and owner.bite.highlight.OutlineTransparency == 1,
		"Highlight flashed back before the fish cleared the water"
	)
	assertFishShowcaseLine()
	assert(
		line.Attachment0 == topAttachment and body.TextureID == "" and bait.Transparency == 1,
		"Lift did not switch the upper anchor or colored fish too early"
	)
	assert(owner.impulseCount == liftImpulsesBefore, "Wait for the fish to cross the water before the exit impulse")
	local caughtAt = owner.bite.timeline.endsAt
	local highest = -math.huge
	local peakScale, bounceHeight = 0, 0
	for index = 1, 100 do
		local at = liftingAt + owner.bite:GetLiftTiming().duration * index / 100
		update(at)
		owner:_updateCamera(at, 1 / 60)
		if owner.bite.originalShown then
			assertCaughtOutline(owner.bite)
		else
			assert(not owner.bite.highlight.Enabled, "Black outline appeared before the fish surfaced")
		end
		peakScale = math.max(peakScale, owner.bite.scale)
		if at - liftingAt > owner.bite:GetLiftTiming().landAt then
			bounceHeight = math.max(bounceHeight, body.Position.Y - target.Y - settings.ShowcaseHeight)
		end
		if index == 20 then
			assert((camera.Focus.Position - owner.bite.showcasePosition).Magnitude > 0.01,
				"Rising camera must retain visible follow lag")
		end
		highest = math.max(highest, body.Position.Y)
		assertFishShowcaseLine()
	end
	update(caughtAt + settings.ShowcaseHold)
	assertCaughtOutline(owner.bite)
	assertFishShowcaseLine()
	local baseCaught = owner.bite:_basePose("Caught", settings.ShowcaseHold, target)
	local showcaseMotion = settings.Motion.Secondary.Showcase
	local maxTilt = showcaseMotion.IdleAngles[1] + showcaseMotion.BurstAngles[1]
		+ showcaseMotion.IdleAngles[3] + showcaseMotion.BurstAngles[3]
	assert(
		baseCaught.LookVector:Dot(Vector3.yAxis) > 0.99999
			and body.CFrame.LookVector:Dot(Vector3.yAxis) > math.cos(math.rad(maxTilt))
			and body.TextureID == originalTexture,
		"Caught fish is not upright and colored"
	)
	assert(highest > target.Y + settings.LiftPeakHeight - 0.01, "Fish did not rise into the sky")
	assert(
		bounceHeight > 1 and peakScale > 1.3 and math.abs(owner.bite.scale - 1) < 0.001,
		"Fish did not scale-punch and rebound"
	)
	assert(owner.impulseCount == liftImpulsesBefore + 2, "Exit and landing must each trigger once")
	owner:_updateCamera(caughtAt + settings.ShowcaseHold, 1 / 60)
	assert(math.abs(owner.cameraFrame.LookVector.Y) < 0.0001, "Base showcase camera did not return to level")
	assert(camera.CFrame.LookVector.Y < 0.02, "Showcase camera sway is too strong")
	assert(owner.cameraFrame:ToObjectSpace(camera.CFrame).Position.Magnitude > 0.0001, "Showcase camera has no sway")
	assert(
		owner:CanReturn(caughtAt + settings.ShowcaseHold) and not owner.bite:CanRetry(caughtAt + 100),
		"Caught fish cannot return or unexpectedly retried"
	)
	assert(
		bait.Transparency == 1 and owner.continueLabel.Text == settings.Text.Return,
		"Caught fish restored bait or lost return prompt"
	)

	-- 横屏、竖屏的鱼身八角均入镜，最终镜头水平，吊线上端在画外。
	for _, size in ipairs({ Vector2.new(390, 844), Vector2.new(844, 390), Vector2.new(1877, 1240) }) do
		local view = owner:_showcaseCamera(target, size)
		assert(math.abs(view.LookVector.Y) < 0.00001, "Showcase camera is not level")
		local tanY = math.tan(math.rad(settings.ShowcaseFov * 0.5))
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local corner = body.CFrame:PointToWorldSpace(body.Size * Vector3.new(x, y, z) * 0.5)
					local point = view:PointToObjectSpace(corner)
					assert(point.Z < 0, "Fish corner is behind the showcase camera")
					assert(math.abs(point.X / (-point.Z * tanY * size.X / size.Y)) < 0.8, "Fish clipped horizontally")
					assert(math.abs(point.Y / (-point.Z * tanY)) < 0.6, "Fish clipped or overlapped prompts")
				end
			end
		end
		local top = view:PointToObjectSpace(line.Attachment0.WorldPosition)
		assert(top.Y / (-top.Z * tanY) > 1, "Line top is visible inside showcase")
	end

	local previousMouth = body.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
	target += Vector3.yAxis * 4
	update(caughtAt + 1)
	assertFishShowcaseLine()
	assert(
		(body.CFrame:PointToWorldSpace(owner.bite.mouthOffset) - previousMouth - Vector3.yAxis * 4).Magnitude < 0.001,
		"Suspended mouth did not follow water"
	)

	-- 三轮展示挣动：固定嘴部和构图中心，含镜头晃动的横竖屏构图均留有余量。
	owner.bite.animation.state = FishAnimation.NewState(caughtAt, {
		NextNumber = function(_, low, high)
			return (low + high) * 0.5
		end,
		NextInteger = function(_, low)
			return low
		end,
	})
	update(caughtAt + 1)
	local restingFrame = body.CFrame
	local baseRestingFrame = owner.bite:_basePose("Caught", 1, target)
	local suspendedMouth = restingFrame:PointToWorldSpace(owner.bite.mouthOffset)
	local restingLine = line.Attachment1.WorldPosition
	local maxLineDrift = 0
	local swaySettings = { Duration = settings.Motion.Animation.Clips.ShowcaseFlop.Duration }
	local impulseCount = owner.impulseCount
	for _ = 1, 3 do
		local start = owner.bite.animation.state.nextBurst
		assert(start, "Showcase did not schedule a burst")
		local maximum = 0
		for index = 0, 60 do
			local at = start + swaySettings.Duration * index / 60
			update(at)
			assertCaughtOutline(owner.bite)
			owner:_updateCamera(at, 1 / 60)
			local _, angle = restingFrame.Rotation:ToObjectSpace(body.CFrame.Rotation):ToAxisAngle()
			maximum = math.max(maximum, math.abs(angle))
			local actualMouth = body.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
			assert((actualMouth - suspendedMouth).Magnitude < 0.001, "Showcase mouth pivot drifted")
			assertFishShowcaseLine()
			maxLineDrift = math.max(maxLineDrift, (line.Attachment1.WorldPosition - restingLine).Magnitude)
			assert(
				(owner.cameraFrame.Position - owner:_showcaseCamera(target, camera.ViewportSize).Position).Magnitude
					< 0.001,
				"Showcase camera chased fish"
			)
			assert((camera.Focus.Position - baseRestingFrame.Position).Magnitude < 0.001, "Showcase focus chased fish")
			local cameraSway = owner.cameraFrame:ToObjectSpace(camera.CFrame)
			assert(
				cameraSway.Position.Magnitude < 0.1 and camera.FieldOfView == settings.ShowcaseFov,
				"Showcase added an impact"
			)
			for _, size in ipairs({ Vector2.new(390, 844), Vector2.new(844, 390), Vector2.new(1877, 1240) }) do
				local view = owner:_showcaseCamera(target, size) * cameraSway
				local tanY = math.tan(math.rad(settings.ShowcaseFov * 0.5))
				for x = -1, 1, 2 do
					for y = -1, 1, 2 do
						for z = -1, 1, 2 do
							local corner = body.CFrame:PointToWorldSpace(body.Size * Vector3.new(x, y, z) * 0.5)
							local point = view:PointToObjectSpace(corner)
							assert(point.Z < 0, "Moving fish is behind camera")
							assert(
								math.abs(point.X / (-point.Z * tanY * size.X / size.Y)) < 0.8,
								"Moving fish clipped horizontally"
							)
							assert(
								math.abs(point.Y / (-point.Z * tanY)) < 0.6,
								"Moving fish clipped or overlapped prompts"
							)
						end
					end
				end
			end
		end
		assert(maximum > math.rad(2) and maximum < math.rad(15), "Showcase procedural accent missing or excessive")
		update(start + swaySettings.Duration + 0.01)
		assert(
			(body.CFrame:PointToWorldSpace(owner.bite.mouthOffset) - suspendedMouth).Magnitude < 0.001
				and body.CFrame.LookVector:Dot(Vector3.yAxis) > math.cos(math.rad(3)),
			"Showcase did not recover gentle idle sway"
		)
	end
	assert(maxLineDrift < 0.001, "Showcase line anchor drifted while the mouth stayed fixed")
	assert(
		body.Material == template.PrimaryPart.Material and body.MaterialVariant == template.PrimaryPart.MaterialVariant,
		"Caught fish did not restore its original material"
	)
	assert(owner.impulseCount == impulseCount and fishCount() == 1, "Showcase burst created extra effects or fish")
	assert(
		template.PrimaryPart.TextureID == originalTexture and template.PrimaryPart.Color == originalColor,
		"Source fish appearance changed"
	)
	-- 单网格与多部件鱼都复用同一个模型级描边，出水前关闭，显色后保持。
	for index, name in ipairs({ "GreenSeahorse", "AncientMegalodon" }) do
		settings.FishName = name
		local at = 5000 + index * 100
		round(at)
		local bite = owner.bite
		assert(owner:TryHook(at + trueBite + 0.2), "Outline validation fish did not hook")
		local liftAt = bite.timeline.endsAt
		update(liftAt)
		assert(not bite.highlight.Enabled, "Outline validation fish showed black outline underwater")
		for frame = 1, 60 do
			update(liftAt + owner.bite:GetLiftTiming().duration * frame / 60)
			if bite.originalShown then
				assertCaughtOutline(bite)
			else
				assert(not bite.highlight.Enabled, "Black outline preceded original appearance")
			end
		end
		assertCaughtOutline(bite)
		update(liftAt + owner.bite:GetLiftTiming().duration + settings.ShowcaseHold)
		assertCaughtOutline(bite)
		bite:_appearance(false, true, 0, "Caught", 0)
		assert(
			not bite.highlight.Enabled and bite.highlight.OutlineTransparency == 1,
			"Hidden original fish retained an outline"
		)
	end
	local caughtHighlight = owner.bite.highlight
	owner:Destroy()
	owner:Destroy()
	assert(
		folder.Parent == nil and lineEnd.Parent == nil and lineTop.Parent == nil and body.Parent == nil
			and caughtHighlight.Parent == nil,
		"Cleanup left fishing instances behind"
	)
	return {
		passed = true,
		checks = "three spawn sectors, Neon shadow and original material restoration, 30/60 fps body and outline easing, escape fade endpoints, keyframe animation, actual size/fade/rise, bait outline/red fill, side contact, timeout retry, spr reel with continuous retargeting and physical settling, struggle shake, synchronized exit and landing impulses, sky spin/fall/bounce, camera tracking, three idle bursts, fixed mouth/focus/line, centered bait anchor, fish anchor one world stud below scaled mouth, landscape/portrait animation framing, single-mesh and multipart surfaced black outline, hidden outline and cleanup",
	}
end, debug.traceback)

if owner then
	owner:Destroy()
end
folder:Destroy()
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType =
	savedCamera.frame, savedCamera.focus, savedCamera.fov, savedCamera.mode
settings.FishName = originalFishName
assert(ok, result)
return result
