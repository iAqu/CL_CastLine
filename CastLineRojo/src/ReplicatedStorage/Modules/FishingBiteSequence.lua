local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local warnedMissingTail = false

local FishingBiteSequence = {}
FishingBiteSequence.__index = FishingBiteSequence

-- 时序与实例表现分开，输入和渲染共用同一个绝对时钟。
local Timeline = {}
Timeline.__index = Timeline

function Timeline:_enter(phase, now, duration)
	self.phase, self.startedAt = phase, now
	self.endsAt = now + (duration or math.huge)
	if phase == "Bite" then
		self.baitConsumed = true
	end
end

function FishingBiteSequence.NewTimeline(startedAt, random, readyAt)
	local rng = random or Random.new()
	local timeline = setmetatable({
		random = rng,
		nibbles = rng:NextInteger(0, Settings.MaxNibbles),
		appearAt = startedAt + rng:NextNumber(Settings.AppearDelayMin, Settings.AppearDelayMax),
	}, Timeline)
	timeline:_enter("Settling", startedAt, math.max(0, (readyAt or startedAt) - startedAt))
	return timeline
end

function Timeline:Advance(now)
	while now >= self.endsAt do
		local at, phase = self.endsAt, self.phase
		if phase == "Settling" then
			self:_enter("Waiting", at, math.max(0, self.appearAt - at))
		elseif phase == "Waiting" then
			self:_enter("Approaching", at, Settings.ApproachTime)
		elseif phase == "Approaching" or phase == "Nibbling" then
			self:_enter("Holding", at, self.random:NextNumber(Settings.PauseMin, Settings.PauseMax))
		elseif phase == "Holding" then
			if self.nibbles > 0 then
				self.nibbles -= 1
				self:_enter("Nibbling", at, Settings.NibbleTime)
			else
				self:_enter("Bite", at, Settings.HookWindow)
			end
		elseif phase == "Bite" then
			self:_enter("Escaped", at)
		elseif phase == "Struggling" then
			self:_enter("Lifting", at, Settings.LiftTime)
		elseif phase == "Lifting" then
			self:_enter("Caught", at)
		else
			break
		end
	end
	return self.phase
end

function Timeline:TryHook(now)
	self:Advance(now)
	if self.phase == "Bite" then
		self:_enter("Struggling", now, Settings.StruggleTime)
		return true
	elseif
		self.phase == "Waiting"
		or self.phase == "Approaching"
		or self.phase == "Holding"
		or self.phase == "Nibbling"
		or self.phase == "Escaped"
	then
		self:_enter("Reeling", now)
	end
	return false
end

function Timeline:CanReturn(now)
	self:Advance(now)
	return self.phase == "Reeling" or (self.phase == "Caught" and now >= self.startedAt + Settings.ShowcaseHold)
end

function Timeline:CanRetry(now)
	self:Advance(now)
	return self.phase == "Escaped" and now >= self.startedAt + Settings.EscapeTime
end

local function smooth(alpha)
	alpha = math.clamp(alpha, 0, 1)
	return alpha * alpha * (3 - 2 * alpha)
end

local Motion = {}
Motion.__index = Motion

function FishingBiteSequence.NewMotion(startedAt, random)
	-- 表现随机数独立于咬钩时序，不因渲染频率改变玩法抽样。
	local rng = random or Random.new()
	return setmetatable({ startedAt = startedAt, random = rng, seedPhase = rng:NextNumber(0, math.pi * 2) }, Motion)
end

function Motion:_showcaseWave(elapsed, now)
	local settings = Settings.Motion.Showcase
	local caughtAt = now - elapsed
	if self.caughtAt == nil then
		self.caughtAt = caughtAt
		self.nextBurst = caughtAt + self.random:NextNumber(settings.GapMin, settings.GapMax)
		self.cycles = self.random:NextInteger(settings.CyclesMin, settings.CyclesMax)
	end
	if now >= self.nextBurst + settings.Duration then
		-- 长帧只安排下一次，不追赶已经错过的多轮挣动。
		self.nextBurst = now + self.random:NextNumber(settings.GapMin, settings.GapMax)
		self.cycles = self.random:NextInteger(settings.CyclesMin, settings.CyclesMax)
	end
	if now < self.nextBurst then
		return 0, 0
	end
	local alpha = (now - self.nextBurst) / settings.Duration
	local envelope = math.sin(math.pi * alpha) ^ 2
	local wave = alpha * math.pi * 2 * self.cycles
	return wave, envelope
end

local function swimStrength(phase, elapsed)
	local settings = Settings.Motion.Swim
	local strength = 0
	if phase == "Approaching" then
		strength = smooth(elapsed / settings.BlendTime)
			* (
				1
				- (1 - settings.HoldStrength)
					* smooth((elapsed - Settings.ApproachTime + settings.BlendTime) / settings.BlendTime)
			)
	elseif phase == "Holding" then
		strength = settings.HoldStrength
	elseif phase == "Nibbling" then
		strength = settings.HoldStrength * (1 - math.sin(math.pi * math.clamp(elapsed / Settings.NibbleTime, 0, 1)) ^ 2)
	elseif phase == "Bite" then
		strength = settings.HoldStrength * (1 - smooth(elapsed / Settings.BiteSinkTime))
	elseif phase == "Escaped" then
		strength = smooth(elapsed / settings.BlendTime)
	end
	return strength
end

function Motion:Sample(phase, elapsed, now)
	if phase == "Caught" then
		local settings = Settings.Motion.Showcase
		local wave, envelope = self:_showcaseWave(elapsed, now)
		return math.rad(settings.Pitch) * math.sin(wave + 0.7) * envelope,
			math.rad(settings.Yaw) * math.sin(wave) * envelope,
			math.rad(settings.Roll) * math.sin(wave + 1.4) * envelope
	end
	local settings = Settings.Motion.Swim
	local strength = swimStrength(phase, elapsed)
	local wave = (now - self.startedAt) * math.pi * 2 * settings.Frequency + self.seedPhase
	return math.rad(settings.Pitch) * math.sin(wave + 0.7) * strength,
		math.rad(settings.Yaw) * math.sin(wave) * strength,
		math.rad(settings.Roll) * math.sin(wave + 1.4) * strength
end

function Motion:SampleTail(phase, elapsed, now)
	local settings = Settings.Motion.Tail
	if phase == "Caught" then
		local wave, envelope = self:_showcaseWave(elapsed, now)
		return math.rad(settings.ShowcaseYaw) * math.sin(wave) * envelope
	end
	local frequency, amplitude = settings.Frequency, settings.Yaw * swimStrength(phase, elapsed)
	local initial = 0
	if phase == "Struggling" then
		local blend = smooth(elapsed / settings.BlendTime)
		frequency, amplitude = settings.StruggleFrequency, settings.StruggleYaw * blend
		initial = (self.hookTailAngle or 0) * (1 - blend)
	elseif phase == "Lifting" then
		frequency = settings.StruggleFrequency
		amplitude = settings.StruggleYaw * (1 - smooth(elapsed / Settings.LiftTime))
	end
	local wave = (now - self.startedAt) * math.pi * 2 * frequency + self.seedPhase
	return initial + math.rad(amplitude) * math.sin(wave)
end

local function aroundMouth(frame, mouth, rotation)
	return frame * CFrame.new(mouth) * rotation * CFrame.new(-mouth)
end

function FishingBiteSequence.new(owner, startedAt, readyAt, random)
	local models = ReplicatedStorage:FindFirstChild("Models")
	local fishFolder = models and models:FindFirstChild("Fish")
	local template = fishFolder and fishFolder:FindFirstChild(Settings.FishName)
	assert(template and template:IsA("Model") and template.PrimaryPart, "Models.Fish.Elder Fish is missing or invalid")
	local fish = template:Clone()
	local rng = random or Random.new()
	-- 立即纳入父会话，初始化异常时也能由会话清理。
	fish.Name, fish.Parent = "BitingFish", owner.folder
	local self = setmetatable({
		owner = owner,
		fish = fish,
		timeline = FishingBiteSequence.NewTimeline(startedAt, rng, readyAt),
		motion = FishingBiteSequence.NewMotion(startedAt),
		originals = {},
		surfaces = {},
	}, FishingBiteSequence)
	local body = fish.PrimaryPart
	local tailSettings = Settings.Motion.Tail
	local root = body:FindFirstChild(tailSettings.BodyBone, true)
	local tail = root and root:FindFirstChild(tailSettings.Bone, true)
	if root and root:IsA("Bone") and tail and tail:IsA("Bone") then
		self.tailBone, self.tailRest = tail, tail.Transform
		-- 导入骨骼的本地轴未必与鱼身一致，始终绕鱼身竖直轴摆尾。
		self.tailAxis = tail.WorldCFrame:VectorToObjectSpace(body.CFrame.UpVector)
	elseif not warnedMissingTail then
		warnedMissingTail = true
		warn("FishingBiteSequence: fish tail rig is missing; using whole-body sway")
	end
	self.halfLength, self.depth = body.Size.Z * 0.5, body.Size.Y * 0.5 + Settings.WaterClearance
	self.bodyWidth = math.max(body.Size.X, body.Size.Y)
	self.mouthOffset = body.Size * Vector3.new(unpack(Settings.MouthOffset))
	self.bodyOffset = fish:GetPivot():ToObjectSpace(body.CFrame)
	self.baseScale, self.scale = fish:GetScale(), 1
	self.side = owner.forward:Cross(Vector3.yAxis)
	self.spawnSector = rng:NextInteger(1, 3)
	local angle = ({ 0, -math.pi * 0.5, math.pi * 0.5 })[self.spawnSector]
		+ math.rad(rng:NextNumber(-Settings.SpawnAngleJitter, Settings.SpawnAngleJitter))
	self.spawnDirection = owner.forward * math.cos(angle) + self.side * math.sin(angle)
	self.direction = -self.spawnDirection
	self.baitRotation = CFrame.Angles(0, owner.spin or 0, 0)
	-- 固定鱼饵朝向，沿本轮出现方向选取朝向鱼的边缘交点。
	local localDirection = self.baitRotation:VectorToObjectSpace(self.spawnDirection)
	local halfSize = owner.bait.Size * 0.5
	local xDistance = if math.abs(localDirection.X) > 0.000001
		then halfSize.X / math.abs(localDirection.X)
		else math.huge
	local zDistance = if math.abs(localDirection.Z) > 0.000001
		then halfSize.Z / math.abs(localDirection.Z)
		else math.huge
	self.contactOffset = self.spawnDirection * math.min(xDistance, zDistance)
	for _, part in ipairs(fish:GetDescendants()) do
		if
			part:IsA("BaseScript")
			or part:IsA("JointInstance")
			or part:IsA("Constraint")
			or part:IsA("WeldConstraint")
			or part:IsA("Highlight")
		then
			part:Destroy()
		elseif part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
			part.LocalTransparencyModifier = 0
			if part.Transparency < 1 and part.Name ~= "CameraPart" then
				self.originals[part] = {
					color = part.Color,
					transparency = part.Transparency,
					texture = part:IsA("MeshPart") and part.TextureID or nil,
				}
				part.Color, part.Transparency = Color3.new(0, 0, 0), 1
				if part:IsA("MeshPart") then
					part.TextureID = ""
				end
			end
		elseif part:IsA("SurfaceAppearance") then
			table.insert(self.surfaces, { instance = part, parent = part.Parent })
			part.Parent = nil
		end
	end
	local highlight = Instance.new("Highlight")
	highlight.Name, highlight.Adornee = "FishShadow", fish
	highlight.FillColor, highlight.OutlineColor = Color3.new(0, 0, 0), Color3.fromRGB(254, 254, 254)
	highlight.FillTransparency, highlight.OutlineTransparency = Settings.ShadowTransparency, Settings.ShadowTransparency
	highlight.DepthMode, highlight.Enabled = Enum.HighlightDepthMode.AlwaysOnTop, false
	highlight.Parent, self.highlight = fish, highlight
	return self
end

function FishingBiteSequence:TryHook(now)
	if self.destroyed then
		return false
	end
	self.timeline:Advance(now)
	if self.timeline.phase == "Bite" then
		local elapsed = now - self.timeline.startedAt
		self.hookSway = self:_bodySway("Bite", elapsed, now)
		self.motion.hookTailAngle = self.motion:SampleTail("Bite", elapsed, now)
	end
	local hooked = self.timeline:TryHook(now)
	self.owner:_presentBait(self.timeline.phase)
	return hooked
end

function FishingBiteSequence:CanReturn(now)
	return not self.destroyed and self.timeline:CanReturn(now)
end

function FishingBiteSequence:CanRetry(now)
	return not self.destroyed and self.timeline:CanRetry(now)
end

function FishingBiteSequence:_appearance(visible, original, fade)
	self.highlight.Enabled = visible and not original
	self.highlight.FillTransparency = Settings.ShadowTransparency + (1 - Settings.ShadowTransparency) * fade
	self.highlight.OutlineTransparency = self.highlight.FillTransparency
	for part, saved in pairs(self.originals) do
		part.Transparency = if visible then saved.transparency + (1 - saved.transparency) * fade else 1
		if original and not self.originalShown then
			part.Color = saved.color
			if saved.texture then
				part.TextureID = saved.texture
			end
		end
	end
	if original and not self.originalShown then
		self.originalShown = true
		for _, surface in ipairs(self.surfaces) do
			surface.instance.Parent = surface.parent
		end
	end
end

function FishingBiteSequence:_scaleAt(phase, elapsed)
	if phase == "Approaching" then
		return Settings.AppearScale + (1 - Settings.AppearScale) * smooth(elapsed / Settings.AppearTime)
	elseif phase == "Lifting" then
		local punch = math.sin(math.pi * math.clamp(elapsed / Settings.LiftScaleTime, 0, 1))
		local recover = math.sin(math.pi * math.clamp((elapsed - Settings.LiftScaleTime) / 0.25, 0, 1))
		local bounce = math.sin(
			math.pi
				* math.clamp((elapsed / Settings.LiftTime - Settings.LiftFallEnd) / (1 - Settings.LiftFallEnd), 0, 1)
		)
		return 1 + (Settings.LiftScalePeak - 1) * punch - 0.06 * recover + Settings.LiftBounceScale * bounce
	end
	return 1
end

function FishingBiteSequence:_biteFrame(baitPosition)
	local outward = self.spawnDirection
	local angle = math.rad(Settings.BiteTilt)
	local rotation = CFrame.lookAt(Vector3.zero, -outward * math.cos(angle) + Vector3.yAxis * math.sin(angle))
	local contact = baitPosition + self.contactOffset
	return CFrame.new(contact - rotation:VectorToWorldSpace(self.mouthOffset * self.scale)) * rotation
end

function FishingBiteSequence:_struggleFrame(elapsed, target)
	local time = elapsed * Settings.StruggleSpeed
	local angle = math.atan2(self.spawnDirection.Z, self.spawnDirection.X)
		+ time * math.pi * 2 * Settings.StruggleTurns / Settings.StruggleTime
	local radius = self.halfLength + (Settings.StruggleRadius - self.halfLength) * smooth(time / 0.3)
	local position = target
		+ Vector3.new(
			math.cos(angle) * radius,
			-self.depth + math.sin(time * 16) * Settings.StruggleBob,
			math.sin(angle) * radius
		)
	local direction = Vector3.new(-math.sin(angle), 0, math.cos(angle))
	local orbit = CFrame.lookAt(position, position + direction)
		* CFrame.Angles(0, math.sin(time * 18) * 0.12, math.sin(time * 22) * Settings.StruggleRoll)
	local initial = self:_biteFrame(target - Vector3.yAxis * Settings.BiteDepth)
	if self.hookSway then
		initial = aroundMouth(initial, self.mouthOffset * self.scale, self.hookSway)
	end
	return initial:Lerp(orbit, smooth(elapsed / 0.2))
end

function FishingBiteSequence:_liftFrame(elapsed, target)
	local alpha = math.clamp(elapsed / Settings.LiftTime, 0, 1)
	local goal = CFrame.lookAt(
		target + Vector3.yAxis * Settings.ShowcaseHeight,
		target + Vector3.yAxis * (Settings.ShowcaseHeight + 1),
		self.side
	)
	local peak = target + Vector3.yAxis * Settings.LiftPeakHeight
	if alpha < Settings.LiftRiseEnd then
		local rise = smooth(alpha / Settings.LiftRiseEnd)
		local initial = self:_struggleFrame(Settings.StruggleTime, target)
		local position = initial.Position:Lerp(peak, rise)
		local rotation = initial.Rotation:Lerp(goal.Rotation, rise)
		return CFrame.new(position) * rotation * CFrame.Angles(0, 0, math.pi * 2 * Settings.LiftSpinTurns * rise)
	elseif alpha < Settings.LiftFallEnd then
		local fall = (alpha - Settings.LiftRiseEnd) / (Settings.LiftFallEnd - Settings.LiftRiseEnd)
		return CFrame.new(peak:Lerp(goal.Position, fall * fall)) * goal.Rotation
	end
	local bounce = (alpha - Settings.LiftFallEnd) / (1 - Settings.LiftFallEnd)
	return goal + Vector3.yAxis * Settings.LiftBounceHeight * math.sin(bounce * math.pi) ^ 2
end

function FishingBiteSequence:_bodySway(phase, elapsed, now)
	local pitch, yaw, roll = self.motion:Sample(phase, elapsed, now)
	local water = phase == "Approaching"
		or phase == "Holding"
		or phase == "Nibbling"
		or phase == "Bite"
		or phase == "Escaped"
	local strength = if self.tailBone and water then Settings.Motion.Tail.BodySwayScale else 1
	return CFrame.Angles(pitch * strength, yaw * strength, roll * strength)
end

function FishingBiteSequence:_pose(phase, elapsed, target, now)
	local outward = self.spawnDirection
	local contact = target + self.contactOffset
	local neutralPosition = contact + outward * (self.halfLength + Settings.NibbleGap) - Vector3.yAxis * self.depth
	local frame = CFrame.lookAt(neutralPosition, neutralPosition - outward)
	local baitPosition = target + Vector3.yAxis * math.sin(elapsed * 2.5) * 0.1
	local fade, baitRotation = 0, self.baitRotation
	if phase == "Approaching" then
		local progress = smooth(elapsed / Settings.ApproachTime)
		local start = contact
			+ outward * (Settings.ApproachDistance + self.halfLength)
			- Vector3.yAxis * (self.depth + Settings.AppearRise)
		local position = start:Lerp(neutralPosition, progress)
		frame = CFrame.lookAt(position, position - outward)
		fade = 1 - math.clamp(elapsed / Settings.AppearTime, 0, 1)
	elseif phase == "Nibbling" then
		local pulse = math.sin(math.clamp(elapsed / Settings.NibbleTime, 0, 1) * math.pi) ^ 2
		baitPosition = target - Vector3.yAxis * Settings.NibbleDepth * pulse
		frame = frame:Lerp(self:_biteFrame(baitPosition), pulse)
	elseif phase == "Bite" then
		local alpha = smooth(elapsed / Settings.BiteSinkTime)
		baitPosition = target - Vector3.yAxis * Settings.BiteDepth * alpha
		frame = frame:Lerp(self:_biteFrame(baitPosition), alpha)
	elseif phase == "Struggling" then
		frame = self:_struggleFrame(elapsed, target)
		local mouth = frame:PointToWorldSpace(self.mouthOffset * self.scale)
		local direction = frame.LookVector * Vector3.new(1, 0, 1)
		local right = -direction.Unit
		baitPosition = mouth - right * self.owner.bait.Size.X * 0.5
		baitRotation = CFrame.fromMatrix(Vector3.zero, right, Vector3.yAxis)
	elseif phase == "Lifting" or phase == "Caught" then
		frame = self:_liftFrame(if phase == "Caught" then Settings.LiftTime else elapsed, target)
		baitPosition = frame:PointToWorldSpace(self.mouthOffset * self.scale)
	elseif phase == "Escaped" then
		local position = target
			+ (self.escapeOffset or neutralPosition - target)
			+ self.spawnDirection * math.min(elapsed, Settings.EscapeTime) * 18
		frame = CFrame.lookAt(position, position + self.spawnDirection)
		fade = math.clamp(elapsed / Settings.EscapeTime, 0, 1)
	end
	-- 悬挂时固定嘴部支点；镜头使用摆动前的中心，避免跟着鱼身来回追。
	self.showcasePosition = if phase == "Lifting" or phase == "Caught" then frame.Position else nil
	local rotation = self:_bodySway(phase, elapsed, now)
	frame = aroundMouth(frame, self.mouthOffset * self.scale, rotation)
	return frame, baitPosition, fade, baitRotation
end

function FishingBiteSequence:Update(now)
	assert(
		not self.destroyed
			and self.fish.Parent
			and self.highlight.Parent
			and self.fish.PrimaryPart
			and self.fish.PrimaryPart:IsDescendantOf(self.fish),
		"Fishing bite resource disappeared"
	)
	local timeline, owner = self.timeline, self.owner
	local phase = timeline:Advance(now)
	owner:_presentBait(phase)
	local target = owner:_waterTarget()
	local elapsed = math.max(0, now - timeline.startedAt)
	if phase ~= self.lastPhase or timeline.startedAt ~= self.lastStartedAt then
		if phase == "Escaped" then
			self.escapeOffset = self.lastPosition and self.lastPosition - target
		elseif phase == "Bite" or phase == "Struggling" or phase == "Lifting" then
			owner:_waterFeedback(now, target, 0.8, true)
			if phase == "Lifting" then
				owner:_impulse(Config.Camera.FishExit, timeline.startedAt)
			end
		end
		self.lastPhase, self.lastStartedAt = phase, timeline.startedAt
	end
	if phase ~= "Settling" then
		local scale = self:_scaleAt(phase, elapsed)
		if math.abs(scale - self.scale) > 0.00001 then
			self.fish:ScaleTo(self.baseScale * scale)
			self.scale = scale
		end
		local frame, baitPosition, fade, baitRotation = self:_pose(phase, elapsed, target, now)
		local offset = CFrame.new(self.bodyOffset.Position * self.scale) * self.bodyOffset.Rotation
		self.fish:PivotTo(frame * offset:Inverse())
		if self.tailBone and self.tailBone:IsDescendantOf(self.fish) then
			self.tailBone.Transform = self.tailRest
				* CFrame.fromAxisAngle(self.tailAxis, self.motion:SampleTail(phase, elapsed, now))
		end
		self.lastPosition = frame.Position
		local visible = phase ~= "Waiting" and phase ~= "Reeling" and (phase ~= "Escaped" or self.wasVisible == true)
		local original = phase == "Caught" or (phase == "Lifting" and frame.Position.Y >= target.Y)
		self:_appearance(visible, original, fade)
		self.wasVisible = visible
		owner.bait.CFrame = CFrame.new(baitPosition) * baitRotation
		if phase == "Lifting" or phase == "Caught" then
			self.linePosition = frame:PointToWorldSpace(self.mouthOffset * self.scale)
		else
			self.linePosition = nil
		end
		if
			phase == "Nibbling"
			and elapsed >= Settings.NibbleTime * 0.5
			and self.nibbleEmittedAt ~= timeline.startedAt
		then
			self.nibbleEmittedAt = timeline.startedAt
			owner:_waterFeedback(now, target, 0.25, false)
		end
		if phase == "Struggling" then
			if now >= (self.nextRipple or 0) then
				local splash = now >= (self.nextSplash or 0)
				owner:_waterFeedback(now, baitPosition, 0.45, splash)
				self.nextRipple = now + Settings.RippleInterval
				if splash then
					self.nextSplash = now + Settings.SplashInterval
				end
			end
		end
	end
	owner:_setPhase(if phase == "Settling" then "Waiting" else phase)
	local text = Settings.Text
	owner.statusLabel.Visible = phase == "Escaped" or (phase == "Caught" and timeline:CanReturn(now))
	owner.statusLabel.Text = if phase == "Caught" then text.Caught else text.Escaped
	owner.returnLabel.Text = if phase == "Caught"
		then text.Return
		elseif phase == "Bite" then text.Hook
		else text.Waiting
	owner.returnLabel.Visible = if phase == "Caught"
		then timeline:CanReturn(now)
		else phase ~= "Settling" and phase ~= "Struggling" and phase ~= "Lifting" and phase ~= "Escaped"
	owner.returnLabel.TextTransparency = 0
	owner.returnLabel.TextColor3 = if phase == "Bite" then Color3.fromRGB(255, 220, 100) else Color3.new(1, 1, 1)
	return phase
end

function FishingBiteSequence:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	for _, surface in ipairs(self.surfaces) do
		surface.instance:Destroy()
	end
	self.fish:Destroy()
end

return FishingBiteSequence
