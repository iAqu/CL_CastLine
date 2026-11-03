-- 在 Studio Client 中执行；使用真实实例和正式模块，结束时清理测试对象。
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cast = require(ReplicatedStorage.Modules.FishingCastSequence)
local Bite = require(ReplicatedStorage.Modules.FishingBiteSequence)
local settings = require(ReplicatedStorage.Modules.FishingConfig).Bite
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
		folder = folder,
		phase = "Waiting",
		forward = Vector3.zAxis,
		spin = 0,
		landedAt = 0,
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
		statusLabel = {},
		returnLabel = {},
		wind = { Volume = 0, Stop = function() end },
		_waterTarget = function()
			return target
		end,
		_waterFeedback = function() end,
	}, Cast)
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
		owner:_updateLine()
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

	-- 三个出现方向、透明度和尺寸渐变，同时从较深的位置上浮。
	for sector = 1, 3 do
		round(0, 0, sector)
		update(2)
		local start = owner.bite.lastPosition
		assert(owner.bite.spawnSector == sector and owner.bite.scale < 0.2, "Spawn sector/initial scale is wrong")
		assert(owner.bite.fish.PrimaryPart.Transparency > 0.99, "Fish did not fade in")
		local delta = (start - target) * Vector3.new(1, 0, 1)
		local expected = if sector == 1 then owner.forward elseif sector == 2 then -owner.bite.side else owner.bite.side
		assert(delta.Unit:Dot(expected) > 0.99, "Fish did not appear from the requested direction")
		update(2 + settings.AppearTime)
		assert(
			math.abs(owner.bite.scale - 1) < 0.001 and owner.bite.lastPosition.Y > start.Y,
			"Fish did not grow and rise"
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
	local swayScale = if resting.tailBone then settings.Motion.Tail.BodySwayScale else 1
	assert(swimAngle > math.rad(1) * swayScale, "Water fish has no visible body motion")

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
	local contact = bait.Position + owner.bite.contactOffset
	local mouthAtBite = owner.bite.fish.PrimaryPart.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
	assert((contact - mouthAtBite).Magnitude < 0.001, "Fish missed bait edge on approach line")
	local deadline = owner.bite.timeline.endsAt
	update(deadline)
	assert(owner.phase == "Escaped" and not owner:CanReturn(deadline + 10), "Failure enabled return")
	assert(not owner.returnLabel.Visible, "Escaped fish displayed return prompt")
	local oldFish, oldRound = owner.bite.fish, owner.round
	update(deadline + settings.EscapeTime + 0.01)
	assert(
		owner.round == oldRound + 1 and oldFish.Parent == nil and fishCount() == 1,
		"Retry did not replace exactly one fish"
	)
	assert(bait.Transparency == 0.25 and line.Attachment0 == tip, "Retry did not restore bait/line")
	assert(
		owner.returnLabel.Text == settings.Text.Waiting and not owner.statusLabel.Visible,
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

	-- 主动提前收竿会终止重试，父控制器负责当次点击立即返回。
	round(2800)
	update(2800)
	assert(not owner:TryHook(2800.1) and owner:CanReturn(2800.1), "Early reeling did not end the cast")
	local endedRound = owner.round
	update(2900)
	assert(owner.round == endedRound and not owner.bite:CanRetry(2900), "Reeled cast automatically retried")

	-- 加速后每秒一圈；鱼线末端直接落在鱼嘴。
	round(3000)
	local hookAt = 3000 + trueBite + 0.2
	assert(owner:TryHook(hookAt), "True bite did not accept hook input")
	update(hookAt + 0.5)
	local first = owner.bite.fish.PrimaryPart.Position - target
	update(hookAt + 0.75)
	local second = owner.bite.fish.PrimaryPart.Position - target
	first, second = Vector3.new(first.X, 0, first.Z).Unit, Vector3.new(second.X, 0, second.Z).Unit
	assert(math.abs(first:Dot(second)) < 0.001, "Struggle did not cover a quarter turn in 0.25 seconds")
	local body = owner.bite.fish.PrimaryPart
	local mouth = body.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
	assert(
		(line.Attachment1.WorldPosition - bait.CFrame:PointToWorldSpace(Vector3.new(0, bait.Size.Y * 0.35, 0))).Magnitude
				< 0.001
			and bait.Transparency == 0.25,
		"Line detached from visible bait"
	)
	local sideContact = bait.CFrame:PointToWorldSpace(Vector3.new(bait.Size.X * 0.5, 0, 0))
	assert((sideContact - mouth).Magnitude < 0.001, "Struggling fish lost side contact")
	assert(owner.bite.timeline.endsAt == hookAt + 3, "Speed change shortened struggle")
	owner.root = { CFrame = CFrame.identity }
	owner.cameraFrame = CFrame.lookAt(target - Vector3.zAxis * 18 + Vector3.yAxis * 12, target)
	owner.cameraFov, owner.shotMode, owner.shotDuration = 60, "Landing", 0
	owner.shotStarted, owner.shotFrom, owner.fovFrom = hookAt - 1, owner.cameraFrame, 60
	owner.biteFocus = target
	owner:_updateCamera(hookAt + 0.75, 1 / 60)
	assert(owner.cameraFrame:ToObjectSpace(camera.CFrame).Position.Magnitude > 0.001, "Struggle camera has no shake")

	-- 出水保持竖线，完全出水才恢复彩色；最终鱼头朝上。
	local liftingAt = owner.bite.timeline.endsAt
	update(liftingAt)
	assert(
		line.Attachment0 == topAttachment and body.TextureID == "" and bait.Transparency == 1,
		"Lift did not switch the upper anchor or colored fish too early"
	)
	assert(owner.impulseCount == 1, "Exit must trigger one strong camera impulse")
	local caughtAt = owner.bite.timeline.endsAt
	local highest = -math.huge
	local peakScale, bounceHeight = 0, 0
	for index = 1, 100 do
		local at = liftingAt + settings.LiftTime * index / 100
		update(at)
		owner:_updateCamera(at, 1 / 60)
		peakScale = math.max(peakScale, owner.bite.scale)
		if index / 100 > settings.LiftFallEnd then
			bounceHeight = math.max(bounceHeight, body.Position.Y - target.Y - settings.ShowcaseHeight)
		end
		if index == 35 then
			assert(camera.CFrame.LookVector.Y > 0.3, "Camera did not tilt up to follow fish")
		end
		highest = math.max(highest, body.Position.Y)
		local delta = line.Attachment0.WorldPosition - line.Attachment1.WorldPosition
		assert(math.abs(delta.X) < 0.001 and math.abs(delta.Z) < 0.001 and delta.Y > 0, "Lift line is not vertical")
	end
	update(caughtAt + settings.ShowcaseHold)
	assert(
		body.CFrame.LookVector:Dot(Vector3.yAxis) > 0.9999 and body.TextureID == originalTexture,
		"Caught fish is not upright and colored"
	)
	assert(highest > target.Y + settings.LiftPeakHeight - 0.01, "Fish did not rise into the sky")
	assert(
		bounceHeight > 1 and peakScale > 1.3 and math.abs(owner.bite.scale - 1) < 0.001,
		"Fish did not scale-punch and rebound"
	)
	assert(owner.impulseCount == 1, "Exit replayed its camera impulse")
	owner:_updateCamera(caughtAt + settings.ShowcaseHold, 1 / 60)
	assert(math.abs(owner.cameraFrame.LookVector.Y) < 0.0001, "Base showcase camera did not return to level")
	assert(camera.CFrame.LookVector.Y < 0.02, "Showcase camera sway is too strong")
	assert(owner.cameraFrame:ToObjectSpace(camera.CFrame).Position.Magnitude > 0.0001, "Showcase camera has no sway")
	assert(
		owner:CanReturn(caughtAt + settings.ShowcaseHold) and not owner.bite:CanRetry(caughtAt + 100),
		"Caught fish cannot return or unexpectedly retried"
	)
	assert(
		bait.Transparency == 1 and owner.returnLabel.Text == settings.Text.Return,
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

	local previousBody = body.Position
	target += Vector3.yAxis * 4
	update(caughtAt + 1)
	assert((body.Position - previousBody - Vector3.yAxis * 4).Magnitude < 0.001, "Fish did not follow water")

	-- 三轮展示挣动：固定嘴部和构图中心，含镜头晃动的横竖屏构图均留有余量。
	owner.bite.motion = Bite.NewMotion(caughtAt, {
		NextNumber = function(_, low, high)
			return (low + high) * 0.5
		end,
		NextInteger = function(_, low)
			return low
		end,
	})
	update(caughtAt + 1)
	local restingFrame = body.CFrame
	local suspendedMouth = restingFrame:PointToWorldSpace(owner.bite.mouthOffset)
	local swaySettings = settings.Motion.Showcase
	local impulseCount = owner.impulseCount
	for _ = 1, 3 do
		local start = owner.bite.motion.nextBurst
		assert(start, "Showcase did not schedule a burst")
		local maximum = 0
		for index = 0, 60 do
			local at = start + swaySettings.Duration * index / 60
			update(at)
			owner:_updateCamera(at, 1 / 60)
			local _, angle = restingFrame.Rotation:ToObjectSpace(body.CFrame.Rotation):ToAxisAngle()
			maximum = math.max(maximum, math.abs(angle))
			local actualMouth = body.CFrame:PointToWorldSpace(owner.bite.mouthOffset)
			assert((actualMouth - suspendedMouth).Magnitude < 0.001, "Showcase mouth pivot drifted")
			assert(
				(line.Attachment1.WorldPosition - actualMouth).Magnitude < 0.001,
				"Showcase line detached from mouth"
			)
			local lineDelta = line.Attachment0.WorldPosition - actualMouth
			assert(
				math.abs(lineDelta.X) < 0.001 and math.abs(lineDelta.Z) < 0.001,
				"Showcase line stopped being vertical"
			)
			assert(
				(owner.cameraFrame.Position - owner:_showcaseCamera(target, camera.ViewportSize).Position).Magnitude
					< 0.001,
				"Showcase camera chased fish"
			)
			assert((camera.Focus.Position - restingFrame.Position).Magnitude < 0.001, "Showcase focus chased fish")
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
		assert(maximum > math.rad(4), "Showcase burst did not visibly move fish")
		update(start + swaySettings.Duration + 0.01)
		assert(
			(body.Position - restingFrame.Position).Magnitude < 0.001
				and body.CFrame.LookVector:Dot(Vector3.yAxis) > 0.9999,
			"Showcase did not recover upright rest"
		)
	end
	assert(owner.impulseCount == impulseCount and fishCount() == 1, "Showcase burst created extra effects or fish")
	assert(
		template.PrimaryPart.TextureID == originalTexture and template.PrimaryPart.Color == originalColor,
		"Source fish appearance changed"
	)
	owner:Destroy()
	owner:Destroy()
	assert(
		folder.Parent == nil and lineEnd.Parent == nil and lineTop.Parent == nil and body.Parent == nil,
		"Cleanup left fishing instances behind"
	)
	return {
		passed = true,
		checks = "three spawn sectors, water body sway, grow/fade/rise, bait outline/red fill, side contact, timeout retry, manual reel, struggle shake, single exit impulse, sky spin/fall/bounce, camera tracking, three idle bursts, fixed mouth/line/focus, landscape/portrait sway framing, cleanup",
	}
end, debug.traceback)

if owner then
	owner:Destroy()
end
folder:Destroy()
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType =
	savedCamera.frame, savedCamera.focus, savedCamera.fov, savedCamera.mode
assert(ok, result)
return result
