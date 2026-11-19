local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local DEFAULT_SWIM_SPEED = Settings.ApproachDistance / Settings.ApproachTime
local BaitElasticMotion = require(script.Parent.BaitElasticMotion)
local FishingReelSpring = require(script.Parent.FishingReelSpring)
local WaterSurfaceUtil = require(script.Parent.WaterSurfaceUtil)
local FishAnimationController = require(script.Parent.FishAnimationController)
local FishShadowAppearance = require(script.Parent.FishShadowAppearance)
local FishSecondaryMotion = require(script.Parent.FishSecondaryMotion)
local FishRepositionPath = require(script.Parent.FishRepositionPath)
local FishDripEffect = require(script.Parent.FishDripEffect)
local FishingShowcaseVFX = require(script.Parent.FishingShowcaseVFX)
local MutationVisualUtil = require(script.Parent.MutationVisualUtil)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local EggMotion = require(script.Parent.FishingEggMotion)
local LiftMotion = require(script.Parent.FishingLiftMotion)
local FishingMutationTrail = require(script.Parent.FishingMutationTrail)

local FishingBiteSequence = {}
FishingBiteSequence.__index = FishingBiteSequence

-- A protected tutorial bite stays alive for arbitrarily long input waits.
function FishingBiteSequence.SampleTutorialHold(elapsed)
	local ramp = math.clamp((elapsed - Settings.BiteSinkTime) / 0.3, 0, 1)
	ramp = ramp * ramp * (3 - 2 * ramp)
	local phase = elapsed * math.pi * 2 * 10
	return math.sin(phase) * 0.025 * ramp, math.cos(phase) * 0.05 * ramp, math.rad(1.5) * math.sin(phase) * ramp
end

-- 时序与实例表现分开，输入和渲染共用同一个绝对时钟。
local Timeline = {}
Timeline.__index = Timeline

local function nibbleTiming(speed, swimSpeed)
	local settings = Settings.Nibble
	local attackTime = math.clamp(
		settings.AttackTime / speed * (DEFAULT_SWIM_SPEED / (swimSpeed or DEFAULT_SWIM_SPEED)),
		settings.AttackTimeMin,
		settings.AttackTimeMax
	)
	local returnAt = attackTime + settings.ContactTime / speed
	return {
		nibbleSpeed = speed,
		duration = attackTime + (Settings.NibbleTime - settings.AttackTime) / speed,
		attackTime = attackTime,
		returnAt = returnAt,
		reboundEnd = returnAt + settings.ReboundTime / speed,
	}
end

local defaultNibbleTiming = nibbleTiming(1)

function Timeline:GetNibbleTiming(index)
	return (self.nibbleTimings and self.nibbleTimings[index or self.nibbleIndex]) or defaultNibbleTiming
end

function Timeline:_enter(phase, now, duration)
	self.phase, self.startedAt = phase, now
	self.endsAt = now + (duration or math.huge)
	if phase == "Bite" then
		self.baitConsumed = true
	end
end

local function validNumber(value, minimum)
	return type(value) == "number" and value >= minimum and value < math.huge
end

function FishingBiteSequence.NewTimeline(startedAt, random, readyAt, fish, catchKind, tutorial)
	local rng = random or Random.new()
	local minNibbles, maxNibbles = 0, Settings.MaxNibbles
	local appearTime, hookWindow, struggleTime = nil, Settings.HookWindow, Settings.StruggleTime
	local swimSpeed, turnRadiusScale = DEFAULT_SWIM_SPEED, Settings.Nibble.ReturnRadiusScale
	readyAt = math.max(startedAt, readyAt or startedAt)
	if fish then
		if validNumber(fish.SwimSpeed, 0) and fish.SwimSpeed > 0 then
			swimSpeed = fish.SwimSpeed
		end
		if validNumber(fish.TurnRadiusScale, 0) and fish.TurnRadiusScale > 0 then
			turnRadiusScale = fish.TurnRadiusScale
		end
		local min, max = fish.NibbleCountMin, fish.NibbleCountMax
		if validNumber(min, 0) and validNumber(max, min) and min % 1 == 0 and max % 1 == 0 then
			minNibbles, maxNibbles = min, max
		end
		if validNumber(fish.AppearTime, 0) then
			appearTime = fish.AppearTime
		end
		if validNumber(fish.HookWindow, 0) and fish.HookWindow > 0 then
			hookWindow = fish.HookWindow
		end
		if validNumber(fish.StruggleTime, 0) and fish.StruggleTime > 0 then
			struggleTime = fish.StruggleTime
		end
	end
	if tutorial then
		minNibbles, maxNibbles, appearTime = 2, 2, 0.8
		hookWindow, struggleTime = math.huge, 3
	end
	local timeline = setmetatable({
		tutorial = tutorial == true,
		random = rng,
		nibbleIndex = 0,
		completedNibbles = 0,
		nibbles = rng:NextInteger(minNibbles, maxNibbles),
		appearAt = if appearTime
			then readyAt + appearTime
			else startedAt + rng:NextNumber(Settings.AppearDelayMin, Settings.AppearDelayMax),
		swimSpeed = swimSpeed,
		approachTime = math.max(Settings.ApproachTimeMin, Settings.ApproachDistance / swimSpeed),
		turnRadiusScale = turnRadiusScale,
		hookWindow = hookWindow,
		struggleTime = struggleTime,
		liftTiming = LiftMotion.Timing(Settings, catchKind == "Egg"),
	}, Timeline)
	timeline:_enter("Settling", startedAt, readyAt - startedAt)
	return timeline
end

function Timeline:Advance(now)
	while now >= self.endsAt do
		local at, phase = self.endsAt, self.phase
		if phase == "Settling" then
			self:_enter("Waiting", at, math.max(0, self.appearAt - at))
		elseif phase == "Waiting" then
			self:_enter("Approaching", at, self.approachTime)
		elseif phase == "Approaching" or phase == "Nibbling" then
			local pause = if self.tutorial then 1.15 else self.random:NextNumber(Settings.PauseMin, Settings.PauseMax)
			if phase == "Nibbling" then
				self.completedNibbles = self.nibbleIndex
				local duration = self.repositionDurations and self.repositionDurations[self.nibbleIndex]
				if duration then
					local timing = self:GetNibbleTiming()
					pause = math.max(pause, duration - (timing.duration - timing.returnAt) + Settings.Nibble.SettleTime)
				end
			end
			self:_enter("Holding", at, pause)
		elseif phase == "Holding" then
			if self.nibbles > 0 then
				self.nibbles -= 1
				self.nibbleIndex += 1
				self:_enter("Nibbling", at, self:GetNibbleTiming().duration)
			else
				self:_enter("Bite", at, self.hookWindow)
			end
		elseif phase == "Bite" then
			self:_enter("Escaped", at)
		elseif phase == "Struggling" then
			self:_enter("Lifting", at, self.liftTiming.duration)
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
		self:_enter("Struggling", now, self.struggleTime)
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

function Timeline:FinishReel(now)
	if self.phase == "Reeling" then
		self:_enter("Reeled", now)
	end
end

function Timeline:CanReturn(now)
	self:Advance(now)
	return (self.phase == "Reeled" and now >= self.startedAt + Config.Reel.HoldTime)
		or (self.phase == "Caught" and now >= self.startedAt + Settings.ShowcaseHold)
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

-- 解析积分平滑起步，之后匀角速绕行；半径先展开再收拢，水花独立采样。
function Motion:SampleOrbit(elapsed)
	local time = math.clamp(elapsed, 0, self.struggleTime)
	local blendTime = self.struggleBlendTime
	local blend = math.clamp(time / blendTime, 0, 1)
	local travel = time - blendTime * (blend - blend ^ 3 + 0.5 * blend ^ 4)
	local orbit = self.orbit
	local baseSpeed = self.mirror * math.pi * 2 * Settings.Struggle.Speed
	local angle = baseSpeed * travel
	local velocity = baseSpeed * smooth(blend)
	local peakRadius = Settings.Struggle.StartRadiusScale
	local radius, radialVelocity
	if time < blendTime then
		radius = 1 + (peakRadius - 1) * smooth(blend)
		radialVelocity = (peakRadius - 1) * 6 * blend * (1 - blend) / blendTime
	else
		local duration = self.struggleTime - blendTime
		local progress = (time - blendTime) / duration
		radius = peakRadius - (peakRadius - orbit.endRadius) * smooth(progress)
		radialVelocity = -(peakRadius - orbit.endRadius) * 6 * progress * (1 - progress) / duration
	end
	local feedbackPhase = math.pi * 2 * orbit.feedbackFrequency * travel + orbit.feedbackPhase
	local strength = (0.5 + 0.5 * math.sin(feedbackPhase)) * smooth(blend)
	return angle, velocity, radius, radialVelocity, strength
end

function Motion:SampleNibble(index, elapsed)
	local settings = Settings.Nibble
	local entry = self.nibbles[math.max(1, index)]
	local progress = smooth(elapsed / entry.attackTime)
	local pressure = progress * (1 - smooth((elapsed - entry.returnAt) / (settings.ReboundTime / entry.nibbleSpeed)))
	return progress, pressure * entry.depth, entry
end

function FishingBiteSequence.NewMotion(startedAt, random, nibbleCount, struggleTime, swimSpeed)
	-- 表现随机数独立于咬钩时序，不因渲染频率改变玩法抽样。
	local rng = random or Random.new()
	struggleTime = struggleTime or Settings.StruggleTime
	local motion = setmetatable({
		startedAt = startedAt,
		random = rng,
		nibbles = {},
		struggleTime = struggleTime,
		struggleBlendTime = math.min(Settings.Struggle.BlendTime, struggleTime * 0.5),
		mirror = if rng:NextInteger(0, 1) == 0 then -1 else 1,
	}, Motion)
	local settings, yaw, gap = Settings.Nibble, 0, 1
	for index = 1, math.max(Settings.MaxNibbles, nibbleCount or 0) do
		local turn = rng:NextNumber(settings.TurnMin, settings.TurnMax) * (if rng:NextInteger(0, 1) == 0 then -1 else 1)
		if math.abs(yaw + turn) > settings.TurnLimit then
			turn = -turn
		end
		local nextYaw = yaw + turn
		local nextGap = rng:NextNumber(settings.GapMin, settings.GapMax)
		local entry = nibbleTiming(rng:NextNumber(settings.SpeedMin, settings.SpeedMax), swimSpeed)
		entry.beforeYaw, entry.yaw = math.rad(yaw), math.rad(nextYaw)
		entry.beforeGap, entry.gap = gap, nextGap
		entry.depth = rng:NextNumber(settings.DepthMin, settings.DepthMax)
		entry.returnSpeed = rng:NextNumber(settings.ReturnSpeedMin, settings.ReturnSpeedMax)
		motion.nibbles[index] = entry
		yaw, gap = nextYaw, nextGap
	end
	local orbit = Settings.Struggle
	motion.orbit = {
		feedbackFrequency = rng:NextNumber(orbit.FeedbackFrequencyMin, orbit.FeedbackFrequencyMax),
		feedbackPhase = rng:NextNumber(0, math.pi * 2),
		endRadius = rng:NextNumber(orbit.EndRadiusMin, orbit.EndRadiusMax),
	}
	return motion
end

function FishingBiteSequence.SelectFishTemplate(fishFolder, random)
	if Settings.FishName then
		local template = fishFolder and fishFolder:FindFirstChild(Settings.FishName)
		assert(
			template and template:IsA("Model") and template.PrimaryPart,
			"Models.Fish." .. Settings.FishName .. " is missing or invalid"
		)
		return template
	end
	local candidates = {}
	if fishFolder then
		for _, template in ipairs(fishFolder:GetChildren()) do
			if template:IsA("Model") and template.PrimaryPart then
				table.insert(candidates, template)
			end
		end
	end
	assert(#candidates > 0, "Models.Fish has no valid fish models with a PrimaryPart")
	-- 鱼种独立抽样，不消耗咬钩时序和动作的随机数。
	local rng = random or Random.new()
	return candidates[rng:NextInteger(1, #candidates)]
end

local function prepareRound(owner, template, startedAt, readyAt, random, visualRandom, fish, catchKind, tutorial, weight)
	local rng = random or Random.new()
	local timeline = FishingBiteSequence.NewTimeline(startedAt, rng, readyAt, fish, catchKind, tutorial)
	local self = setmetatable({
		owner = owner,
		isEgg = catchKind == "Egg",
		timeline = timeline,
		motion = FishingBiteSequence.NewMotion(
			startedAt,
			visualRandom,
			timeline.nibbles,
			timeline.struggleTime,
			timeline.swimSpeed
		),
		originals = {},
		surfaces = {},
	}, FishingBiteSequence)
	if tutorial then
		local previousYaw = 0
		for index, entry in self.motion.nibbles do
			local timing = nibbleTiming(1, DEFAULT_SWIM_SPEED)
			entry.nibbleSpeed, entry.attackTime = timing.nibbleSpeed, timing.attackTime
			entry.duration, entry.returnAt, entry.reboundEnd = timing.duration, timing.returnAt, timing.reboundEnd
			-- 教学轮只小幅试探后缩回，不绕完整大圈。
			entry.beforeYaw, entry.yaw = previousYaw, math.rad(if index % 2 == 1 then 12 else -8)
			entry.beforeGap, entry.gap = 1, 1
			previousYaw = entry.yaw
		end
	end
	local scaleConfig = fish or { DefaultWeight = 1 }
	self.fixedSize = catchKind ~= "Egg" and type(weight) == "number" and weight > 0
	self.catchWeight = if self.fixedSize then weight else nil
	if self.isEgg then
		self.defaultScale, self.rawDefaultScale = 1, 1
	else
		self.defaultScale, self.rawDefaultScale = ItemStatUtil.GetScaleRatio(
			scaleConfig,
			if self.fixedSize then weight else tonumber(scaleConfig.DefaultWeight) or 1,
			template
		)
	end
	self.catchScale = if self.fixedSize then self.defaultScale else nil
	self.baseScale, self.scale = template:GetScale(), self.defaultScale
	local body = template.PrimaryPart
	-- 多部件鱼的 PrimaryPart 可能只覆盖半段鱼身，制作时标定完整体形尺寸。
	local bodySize = template:GetAttribute("FishBodySize")
	if typeof(bodySize) ~= "Vector3" or math.min(bodySize.X, bodySize.Y, bodySize.Z) <= 0 then
		bodySize = body.Size
	end
	-- 长度与局部偏移保留模板空间数值，使用时只乘一次当前倍率。
	self.halfLength = bodySize.Z * 0.5
	self.depth = bodySize.Y * 0.5 * self.defaultScale + Settings.WaterClearance
	self.bodyWidth = math.max(bodySize.X, bodySize.Y)
	local mouth = body:FindFirstChild(if self.isEgg then "HookAttachment" else "MouthAttachment")
	self.mouthOffset = if mouth and mouth:IsA("Attachment")
		then mouth.Position
		else body.Size * Vector3.new(unpack(Settings.MouthOffset))
	self.bodyOffset = template:GetPivot():ToObjectSpace(body.CFrame)
	self.biteDepth = BaitElasticMotion.BaseSize(owner).Y * Settings.BiteDepthFraction
	self.side = owner.forward:Cross(Vector3.yAxis)
	self.spawnSector = rng:NextInteger(1, 3)
	local angle = ({ 0, -math.pi * 0.5, math.pi * 0.5 })[self.spawnSector]
		+ math.rad(rng:NextNumber(-Settings.SpawnAngleJitter, Settings.SpawnAngleJitter))
	self.spawnDirection = owner.forward * math.cos(angle) + self.side * math.sin(angle)
	self.direction = -self.spawnDirection
	self.baitRotation = CFrame.Angles(0, owner.spin or 0, 0)
	-- 初次靠近的接触点；换位后的进食按当前方位重新求边缘交点。
	self.contactOffset = self:_contactOffset(0)
	self:_prepareRepositions()
	return self
end

function FishingBiteSequence.GetBiteWindow(
	template,
	baitSize,
	startedAt,
	readyAt,
	seed,
	motionSeed,
	spin,
	fish,
	catchKind,
	tutorial,
	weight
)
	local owner = { baitBaseSize = baitSize, forward = Vector3.zAxis, spin = spin }
	local round = prepareRound(
		owner,
		template,
		startedAt,
		readyAt,
		Random.new(seed),
		Random.new(motionSeed),
		fish,
		catchKind,
		tutorial,
		weight
	)
	local timeline = round.timeline
	while timeline.phase ~= "Bite" do
		timeline:Advance(timeline.endsAt)
	end
	return timeline.startedAt, timeline.endsAt
end

function FishingBiteSequence.new(
	owner,
	startedAt,
	readyAt,
	random,
	visualRandom,
	template,
	fishConfig,
	catchKind,
	tutorial,
	weight
)
	owner.baitBaseSize = BaitElasticMotion.BaseSize(owner)
	if not template then
		local models = ReplicatedStorage:FindFirstChild("Models")
		local fishFolder = models and models:FindFirstChild("Fish")
		template = FishingBiteSequence.SelectFishTemplate(fishFolder)
	end
	local self =
		prepareRound(owner, template, startedAt, readyAt, random, visualRandom, fishConfig, catchKind, tutorial, weight)
	self.template, self.fishConfig = template, fishConfig
	self.presentationRadius = ItemStatUtil.GetModelBounds(template).framingRadius
	local fish = template:Clone()
	fish:ScaleTo(self.baseScale * self.scale)
	fish.Name, fish.Parent = "BitingFish", owner.folder
	self.fish = fish
	local appearance = FishShadowAppearance.Prepare(fish)
	self.originals, self.surfaces, self.highlight = appearance.originals, appearance.surfaces, appearance.highlight
	self.animation = if self.isEgg
		then EggMotion.Animator()
		else FishAnimationController.new(
			fish,
			startedAt,
			self.motion.random,
			nil,
			self.timeline.struggleTime,
			self.timeline.approachTime
		)
	return self
end

function FishingBiteSequence:SetCaughtWeight(weight: number)
	self.catchWeight = weight
	if not self.isEgg then
		self.catchScale, self.rawCatchScale = ItemStatUtil.GetScaleRatio(self.fishConfig, weight, self.template)
	end
end

function FishingBiteSequence:_captureReelFish(target)
	local body = self.fish and self.fish.PrimaryPart
	if not body or body.Transparency >= 1 then
		return
	end
	local outward = (body.Position - target) * Vector3.new(1, 0, 1)
	self.reelFish = {
		frame = CFrame.new(-target) * body.CFrame,
		direction = if outward.Magnitude > 0.00001 then outward.Unit else self.spawnDirection,
		fade = self.appearanceFade or 0,
		elapsed = 0,
	}
end

function FishingBiteSequence:TryHook(now, mutationId)
	if self.destroyed then
		return false
	end
	self.timeline:Advance(now)
	if self.timeline.phase == "Bite" then
		local elapsed = now - self.timeline.startedAt
		local target = self.owner:_waterTarget()
		local frame, baitPosition, _, baitRotation =
			self:_pose("Bite", elapsed, target, now, nil, self.presentationCamera)
		self.hookFrame = CFrame.new(-target) * frame
		self.hookBaitOffset = frame:PointToObjectSpace(baitPosition)
		self.hookBaitRotation = frame.Rotation:ToObjectSpace(baitRotation)
		self.hookScale = self:_baitScaleAt("Bite", elapsed)
		local mouth = frame:PointToWorldSpace(self.mouthOffset * self.scale)
		self.hookContact = baitRotation:VectorToObjectSpace(mouth - baitPosition)
			/ (BaitElasticMotion.BaseSize(self.owner) * self.hookScale)
		self:_biteSound()
		self:_trueBiteFeedback(now, target)
	end
	local previous = self.timeline.phase
	local hooked = self.timeline:TryHook(now)
	if hooked then
		self.mutationId = mutationId
	end
	if self.owner.fishAudio then
		self.owner.fishAudio:SetPhase(self.timeline.phase)
	end
	if self.timeline.phase == "Reeling" and previous ~= "Reeling" then
		local owner = self.owner
		self.reelFrom = CFrame.new(-owner:_waterTarget()) * owner.bait.CFrame
		self.reelScale = owner.baitVisualScale or Vector3.one
		self.reelMotion = FishingReelSpring.new(self.reelFrom.Position, BaitElasticMotion.BaseSize(owner).Y, now)
		self:_captureReelFish(owner:_waterTarget())
		owner:_shot("Reel", Config.Reel.CameraTime, now)
		owner.impulses = {}
		owner:_setPhase("Reeling")
		owner:_waterFeedback(now, owner:_waterTarget(), 0.35, true)
	end
	self.owner:_presentBait(self.timeline.phase, math.max(0, now - self.timeline.startedAt))
	return hooked
end

function FishingBiteSequence:PreviewMutation(mutationId)
	if mutationId == "Golden" then
		self.highlight.FillColor = Color3.fromRGB(224, 151, 20)
		self.shadowOutlineColor = Color3.fromRGB(255, 214, 92)
	end
end

function FishingBiteSequence:_biteSound()
	if not self.biteSoundPlayed then
		self.biteSoundPlayed = true
		if self.owner.fishAudio then
			self.owner.fishAudio:SetPhase("Bite")
		end
	end
end

function FishingBiteSequence:_trueBiteFeedback(now, target)
	if self.trueBiteEmitted then
		return
	end
	self.trueBiteEmitted = true
	local owner = self.owner
	owner:_impulse(Config.Camera.Bite, now)
	owner:_waterFeedback(now, target, 0.8, false)
	owner:_playWaterVFX(now, Config.WaterVFX.Heavy, target)
end

function FishingBiteSequence:CanReturn(now)
	return not self.destroyed and self.timeline:CanReturn(now)
end

function FishingBiteSequence:CanRetry(now)
	return not self.destroyed and self.timeline:CanRetry(now)
end

function FishingBiteSequence:_appearance(visible, original, fade, phase, elapsed)
	self.appearanceFade = if visible then math.clamp(fade, 0, 1) else 1
	fade = if visible then smooth(fade) else 1
	-- 挣扎只淡出高亮，鱼身保持可见；出水前也保持淡出终点，避免阶段切换闪回。
	local highlightFade = if phase == "Struggling"
		then smooth(elapsed / Settings.Struggle.HighlightFadeTime)
		elseif phase == "Lifting" or phase == "Caught" then 1
		else 0
	highlightFade = 1 - (1 - fade) * (1 - highlightFade)
	FishShadowAppearance.Apply(self, visible, original, fade, highlightFade)
end

function FishingBiteSequence:_scaleAt(phase, elapsed)
	local defaultScale = self.defaultScale or 1
	if self.fixedSize then
		return defaultScale
	end
	if phase == "Lifting" then
		local timing = self:GetLiftTiming()
		local progress = math.clamp(elapsed / timing.scaleTime, 0, 1)
		local punch = math.sin(math.pi * progress)
		local recover = math.sin(math.pi * math.clamp((elapsed - timing.scaleTime) / 0.25, 0, 1))
		local bounce = BaitElasticMotion.Rebound((elapsed - timing.landAt) / (timing.duration - timing.landAt))
		local animationScale = 1
			+ (Settings.LiftScalePeak - 1) * punch
			- 0.06 * recover
			+ Settings.LiftBounceScale * bounce
		local rawDefaultScale = self.rawDefaultScale or defaultScale
		local rawScale = rawDefaultScale + ((self.rawCatchScale or rawDefaultScale) - rawDefaultScale) * progress
		local animatedScale = rawScale * animationScale
		return if self.isEgg then animatedScale else ItemStatUtil.CompressScaleRatio(self.template, animatedScale)
	elseif phase == "Caught" then
		return self.catchScale or defaultScale
	end
	return defaultScale
end

function FishingBiteSequence:_frameAtMouth(mouth, yaw, pitch)
	local rotation = CFrame.lookAt(Vector3.zero, -self.spawnDirection)
		* CFrame.Angles(0, yaw or 0, 0)
		* CFrame.Angles(math.rad(pitch or 0), 0, 0)
	return CFrame.new(mouth - rotation:VectorToWorldSpace(self.mouthOffset * self.scale)) * rotation
end

function FishingBiteSequence:_feedingState(phase, _elapsed)
	local completed = self.timeline.completedNibbles
	if phase == "Nibbling" then
		local entry = self.motion.nibbles[math.max(1, self.timeline.nibbleIndex)]
		return entry.beforeYaw, entry.beforeGap
	end
	local entry = self.motion.nibbles[completed]
	if not entry then
		return 0, 1
	end
	return entry.yaw, entry.gap
end

function FishingBiteSequence:_outward(yaw)
	return CFrame.Angles(0, yaw or 0, 0):VectorToWorldSpace(self.spawnDirection)
end

function FishingBiteSequence:_contactOffset(yaw, size)
	local outward = self:_outward(yaw)
	local localDirection = self.baitRotation:VectorToObjectSpace(outward)
	local halfSize = (size or BaitElasticMotion.BaseSize(self.owner)) * 0.5
	local xDistance = if math.abs(localDirection.X) > 0.000001
		then halfSize.X / math.abs(localDirection.X)
		else math.huge
	local zDistance = if math.abs(localDirection.Z) > 0.000001
		then halfSize.Z / math.abs(localDirection.Z)
		else math.huge
	return outward * math.min(xDistance, zDistance)
end

-- 沿相机穿过鱼饵边缘的射线求水下交点，保持鱼嘴高度和屏幕接触点。
function FishingBiteSequence:_viewOffset(contact, mouthY, cameraPosition)
	local ray = contact - cameraPosition
	if math.abs(ray.Y) < 0.00001 then
		return Vector3.zero
	end
	local distance = (mouthY - cameraPosition.Y) / ray.Y
	if distance <= 0 then
		return Vector3.zero
	end
	local intersection = cameraPosition + ray * distance
	return Vector3.new(intersection.X - contact.X, 0, intersection.Z - contact.Z)
end

function FishingBiteSequence:_restMouth(target, gap, yaw)
	local outward = self:_outward(yaw)
	local center = target
		+ self:_contactOffset(yaw)
		+ outward * (self.halfLength * self.defaultScale + Settings.NibbleGap * gap * (if self.timeline.tutorial
			then 0.45
			else 1))
		- Vector3.yAxis * self.depth
	return CFrame.lookAt(center, center - outward):PointToWorldSpace(self.mouthOffset * self.defaultScale)
end

function FishingBiteSequence:_biteFrame(baitPosition, yaw, size)
	yaw = yaw or self:_feedingState("Bite", 0)
	return self:_frameAtMouth(baitPosition + self:_contactOffset(yaw, size), yaw, Settings.BiteTilt)
end

-- 回游路径以水面的落点为局部原点，在建轮时预计算，不能依赖上一渲染帧。
function FishingBiteSequence:_prepareRepositions()
	self.repositions = {}
	self.timeline.nibbleTimings = self.motion.nibbles
	self.timeline.repositionDurations = {}
	local settings = Settings.Nibble
	local speed = self.timeline.swimSpeed * settings.ReturnSpeedScale
	local radius = self.halfLength * self.defaultScale * self.timeline.turnRadiusScale
	radius = if self.isEgg then math.max(0.5, radius) else math.clamp(radius, 0.5, settings.ReturnRadiusMax)
	for index, entry in ipairs(self.motion.nibbles) do
		local rest = self:_restMouth(Vector3.zero, entry.beforeGap, entry.beforeYaw)
		local _, contactScale =
			BaitElasticMotion.Sample("Nibbling", entry.returnAt, nil, entry.nibbleSpeed, entry.attackTime)
		local contact = self:_contactOffset(entry.beforeYaw, BaitElasticMotion.BaseSize(self.owner) * contactScale)
		local mouth = Vector3.new(contact.X, rest.Y - BaitElasticMotion.BaseSize(self.owner).Y * entry.depth, contact.Z)
		local first = self:_frameAtMouth(mouth, entry.beforeYaw, settings.Pitch)
		local last = self:_frameAtMouth(self:_restMouth(Vector3.zero, entry.gap, entry.yaw), entry.yaw, 0)
		if self.timeline and self.timeline.tutorial then
			self.repositions[index] = { first = first, last = last, duration = 0.9 }
			self.timeline.repositionDurations[index] = 0.9
		else
			local function planar(frame)
				return {
					x = frame.Position.X,
					z = frame.Position.Z,
					heading = math.atan2(frame.LookVector.Z, frame.LookVector.X),
				}
			end
			local path = FishRepositionPath.new(
				planar(first),
				planar(last),
				radius,
				if self.isEgg
					then speed * entry.returnSpeed
					else math.min(speed * entry.returnSpeed, settings.ReturnSpeedMaxStuds),
				settings.ReturnRampTime,
				settings.ReturnTurnBlendTime,
				if self.isEgg then nil else math.rad(settings.ReturnTurnRateMax)
			)
			self.repositions[index] = { path = path, first = first, last = last }
			self.timeline.repositionDurations[index] = path.duration
		end
	end
end

function FishingBiteSequence:_repositionState(phase, elapsed)
	local timing = self.timeline:GetNibbleTiming()
	if phase == "Nibbling" and elapsed >= timing.returnAt then
		return math.max(1, self.timeline.nibbleIndex), elapsed - timing.returnAt
	elseif phase == "Holding" and self.timeline.completedNibbles > 0 then
		timing = self.timeline:GetNibbleTiming(self.timeline.completedNibbles)
		return self.timeline.completedNibbles, elapsed + timing.duration - timing.returnAt
	end
	return nil
end

function FishingBiteSequence:_viewRoute(index, target, cameraPosition)
	local camera = cameraPosition - target
	local cached = self.viewRoute
	if cached and cached.index == index and cached.camera == camera then
		return cached
	end
	local source, entry = self.repositions[index], self.motion.nibbles[index]
	local function corrected(frame, yaw, pressure)
		local size = BaitElasticMotion.BaseSize(self.owner)
		if pressure > 0 then
			local _, scale =
				BaitElasticMotion.Sample("Nibbling", entry.returnAt, nil, entry.nibbleSpeed, entry.attackTime)
			size *= scale
		end
		local contact = self:_contactOffset(yaw, size)
			- Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * pressure
		local mouth = frame:PointToWorldSpace(self.mouthOffset * self.defaultScale)
		return frame + self:_viewOffset(contact, mouth.Y, camera)
	end
	local first = corrected(source.first, entry.beforeYaw, entry.depth)
	local last = corrected(source.last, entry.yaw, 0)
	self.viewRoute = {
		index = index,
		camera = camera,
		first = first,
		last = last,
		firstOffset = first.Position - source.first.Position,
		lastOffset = last.Position - source.last.Position,
	}
	return self.viewRoute
end

function FishingBiteSequence:_repositionPose(index, elapsed, target, cameraPosition)
	local source = self.repositions[index]
	local route = if cameraPosition then self:_viewRoute(index, target, cameraPosition) else source
	if self.timeline and self.timeline.tutorial then
		local progress = smooth(elapsed / source.duration)
		return CFrame.new(target) * route.first:Lerp(route.last, progress),
			Settings.Motion.Animation.HoldWeight * progress
	end
	local path = source.path
	-- 镜头只能改变表现路径，不能改变既定的回游时长和咬钩时序。
	if elapsed >= path.duration then
		local weight = Settings.Motion.Animation.HoldWeight
			* smooth((elapsed - path.duration) / Settings.Nibble.ReturnRampTime)
		return CFrame.new(target) * route.last, weight
	elseif elapsed <= 0 then
		return CFrame.new(target) * route.first, 0
	end
	local distance, speed = path:DistanceAt(elapsed)
	local weight = speed / path.speed
	local u = distance / path.length
	local x, z, heading = path:Sample(distance)
	-- 高度以弧长做 Hermite 衔接；俯仰直接取高度斜率，完整三维速度仍朝前。
	local firstY, lastY = route.first.Position.Y, route.last.Position.Y
	local slope = math.tan(math.asin(route.first.LookVector.Y)) * path.length
	local y = (2 * u ^ 3 - 3 * u ^ 2 + 1) * firstY + (u ^ 3 - 2 * u ^ 2 + u) * slope + (-2 * u ^ 3 + 3 * u ^ 2) * lastY
	local gradient = ((6 * u ^ 2 - 6 * u) * firstY + (3 * u ^ 2 - 4 * u + 1) * slope + (-6 * u ^ 2 + 6 * u) * lastY)
		/ path.length
	local position = target + Vector3.new(x, y, z)
	local direction = Vector3.new(math.cos(heading), gradient, math.sin(heading))
	if cameraPosition then
		-- 沿原弧长平滑修正整条曲线，避免镜头移动导致最短路径换型；首尾切线不变。
		position += route.firstOffset:Lerp(route.lastOffset, smooth(u))
		direction += (route.lastOffset - route.firstOffset) * (6 * u * (1 - u) / path.length)
	end
	return CFrame.lookAt(position, position + direction), weight
end

local function horizontalUnit(vector, fallback)
	local flat = vector * Vector3.new(1, 0, 1)
	return if flat.Magnitude > 0.00001 then flat.Unit else fallback
end

function FishingBiteSequence:GetShowcaseRadius()
	local showcase = Settings.Motion.Secondary.Showcase
	local maxTurn = 0
	for axis = 1, 3 do
		maxTurn += math.max(math.abs(showcase.IdleAngles[axis]), math.abs(showcase.BurstAngles[axis]))
	end
	-- 绕鱼嘴转动会带动主部件中心位移，给整段展示预留固定空间。
	local mouthSwing = 2 * self.mouthOffset.Magnitude * math.sin(math.rad(maxTurn) * 0.5)
	return (self.presentationRadius + mouthSwing) * (self.catchScale or self.defaultScale or 1)
end

function FishingBiteSequence:GetShowcaseHeight()
	local scale = self.catchScale or self.defaultScale or 1
	local rawScale = self.rawCatchScale or self.rawDefaultScale or scale
	local radius = self.presentationRadius * scale
	local clearance = self:GetShowcaseRadius()
	for _, amplitude in Config.BaitElastic.LobeAmplitudes do
		local scaleOffset = Settings.LiftBounceScale * amplitude
		-- 对数压缩会减弱缩小幅度，向下回弹时给整条鱼保留静止尺寸的空间。
		if rawScale > scale then
			scaleOffset = math.max(0, scaleOffset)
		end
		local reach = radius * (1 + scaleOffset) - Settings.LiftBounceHeight * amplitude
		clearance = math.max(clearance, reach)
	end
	return math.max(Settings.ShowcaseHeight, clearance + Settings.WaterClearance)
end

-- 从真实提竿姿态接入螺旋线；先展开大圈，再沿真实切线持续收小。
function FishingBiteSequence:_struggleFrame(elapsed, target)
	local initial = if self.hookFrame
		then CFrame.new(target) * self.hookFrame
		else self:_biteFrame(target - Vector3.yAxis * self.biteDepth)
	local offset = (initial.Position - target) * Vector3.new(1, 0, 1)
	local radius = offset.Magnitude
	local radial = horizontalUnit(offset, self.spawnDirection)
	local side = radial:Cross(Vector3.yAxis)
	local angle, velocity, fraction, radialVelocity = self.motion:SampleOrbit(elapsed)
	local outward = radial * math.cos(angle) + side * math.sin(angle)
	local tangent = outward * radius * radialVelocity
		+ (-radial * math.sin(angle) + side * math.cos(angle)) * radius * fraction * velocity
	local blend = smooth(elapsed / self.motion.struggleBlendTime)
	local position = target
		+ outward * radius * fraction
		+ Vector3.yAxis * (initial.Position.Y - target.Y + (target.Y - self.depth - initial.Position.Y) * blend)
	local direction = horizontalUnit(tangent, horizontalUnit(initial.LookVector, -radial))
	local rotation = initial.Rotation:Lerp(CFrame.lookAt(Vector3.zero, direction).Rotation, blend)
	return CFrame.new(position) * rotation
end

function FishingBiteSequence:GetLiftTiming()
	return (self.timeline and self.timeline.liftTiming) or LiftMotion.Timing(Settings, self.isEgg)
end

function FishingBiteSequence:_prepareLift(target)
	if self.liftPlan then
		return
	end
	local initial = self:_struggleFrame(self.timeline.struggleTime, target)
	self.liftInitial = CFrame.new(-target) * initial
	local diameter = 2 * self.presentationRadius * (self.catchScale or self.defaultScale or 1)
	self.liftPlan =
		LiftMotion.New(Settings, Config.BaitElastic, initial.Position.Y - target.Y, self:GetShowcaseHeight(), diameter)
end

function FishingBiteSequence:_liftFrame(elapsed, target)
	self:_prepareLift(target)
	local sample = LiftMotion.Sample(self.liftPlan, elapsed)
	local initial = self.liftInitial
	local horizontal = initial.Position * Vector3.new(1, 0, 1) * (1 - sample.rise)
	local position = target + horizontal + Vector3.yAxis * sample.height
	local showcaseUp = if self.fishConfig and self.fishConfig.DisplayFacing == "Front"
		then -self.owner.forward
		else self.side
	local goal = CFrame.lookAt(Vector3.zero, Vector3.yAxis, showcaseUp).Rotation
	local turn = smooth(elapsed / self.liftPlan.timing.riseEnd)
	local rotation = initial.Rotation:Lerp(goal, turn)
	return CFrame.new(position) * rotation * CFrame.Angles(0, 0, math.pi * 2 * Settings.LiftSpinTurns * turn)
end

function FishingBiteSequence:_updateLiftFeedback(phase, elapsed, now, target)
	if self.isEgg or (phase ~= "Lifting" and phase ~= "Caught") then
		return
	end
	self:_prepareLift(target)
	local time = if phase == "Caught" then self.liftPlan.timing.duration + elapsed else elapsed
	local previous = self.liftFeedbackAt or -1
	local exit, land = LiftMotion.Events(self.liftPlan, previous, time)
	self.liftFeedbackAt = math.max(previous, time)
	if exit then
		self.owner:_waterFeedback(now, target, 0.8, false, true)
		self.owner:_playWaterVFX(now, Config.WaterVFX.Exit, target, nil, math.clamp(self.liftPlan.diameter / 12, 1, 3))
		self.owner:_impulse(Settings.FishLift.Exit, now)
		if self.owner.fishAudio then
			self.owner.fishAudio:Play("FishWaterOut")
		end
		self.owner:_sound("CameraWhoosh")
	end
	if land then
		if self.owner.fishAudio then
			self.owner.fishAudio:Play("FishDrop")
		end
		self.owner:_impulse(Settings.FishLift.Land, now)
	end
end

function FishingBiteSequence:_reelFrame(target)
	return CFrame.new(target + self.reelMotion.position) * self.reelFrom.Rotation
end

function FishingBiteSequence:_baitScaleAt(phase, elapsed)
	local duration = self.timeline.endsAt - self.timeline.startedAt
	local timing = self.timeline:GetNibbleTiming()
	local _, scale = BaitElasticMotion.Sample(phase, elapsed, duration, timing.nibbleSpeed, timing.attackTime)
	local from, blendTime
	if phase == "Struggling" then
		from, blendTime = self.hookScale, self.motion.struggleBlendTime
	elseif phase == "Reeling" then
		from, blendTime = self.reelScale, Config.Reel.SinkTime
	end
	if from then
		scale = from:Lerp(scale, smooth(elapsed / blendTime))
	end
	return scale
end

function FishingBiteSequence:_basePose(phase, elapsed, target, cameraPosition)
	local yaw, gap = self:_feedingState(phase, elapsed)
	local outward = self:_outward(yaw)
	local size = BaitElasticMotion.BaseSize(self.owner) * self:_baitScaleAt(phase, elapsed)
	local contactOffset = self:_contactOffset(yaw, size)
	local contact = target + contactOffset
	local rest = self:_restMouth(target, gap, yaw)
	local frame = self:_frameAtMouth(rest, yaw, 0)
	local baitPosition = target
	local fade, baitRotation = 0, self.baitRotation
	if phase == "Settling" then
		baitPosition += Vector3.yAxis * self.owner:_landingOffset(elapsed)
	elseif phase == "Waiting" or phase == "Holding" or phase == "Approaching" or phase == "Escaped" then
		local offset = BaitElasticMotion.Sample(phase, elapsed, self.timeline.endsAt - self.timeline.startedAt)
		baitPosition += Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * offset
	end
	if phase == "Approaching" then
		local progress = smooth(elapsed / self.timeline.approachTime)
		local start = contact
			+ outward * (Settings.ApproachDistance + self.halfLength * self.defaultScale)
			- Vector3.yAxis * (self.depth + Settings.AppearRise)
		local position = start:Lerp(frame.Position, progress)
		frame = CFrame.lookAt(position, position - outward)
		fade = 1 - math.clamp(elapsed / Settings.AppearTime, 0, 1)
	elseif phase == "Holding" and self.timeline.completedNibbles > 0 then
		local index, time = self:_repositionState(phase, elapsed)
		frame = self:_repositionPose(index, time, target, cameraPosition)
	elseif phase == "Nibbling" then
		local progress, pressure = self.motion:SampleNibble(self.timeline.nibbleIndex, elapsed)
		local timing = self.timeline:GetNibbleTiming()
		local bounce = BaitElasticMotion.Sample("Nibbling", elapsed, nil, timing.nibbleSpeed, timing.attackTime)
		baitPosition = target + Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * (bounce - pressure)
		local index, time = self:_repositionState(phase, elapsed)
		if index then
			frame = self:_repositionPose(index, time, target, cameraPosition)
		else
			-- 基础路径保持水下高度；显示时再按同帧镜头修正接触点。
			local contactMouth = baitPosition + contactOffset
			contactMouth = Vector3.new(
				contactMouth.X,
				rest.Y - BaitElasticMotion.BaseSize(self.owner).Y * pressure,
				contactMouth.Z
			)
			local arc =
				math.min(math.abs(math.sin(yaw)) * Settings.NibbleGap, Settings.NibbleGap * Settings.Nibble.ArcLimit)
			local side = arc * math.sin(math.pi * progress) * math.sign(yaw)
			local mouth = rest:Lerp(contactMouth, progress) + outward:Cross(Vector3.yAxis) * side
			frame = self:_frameAtMouth(mouth, yaw, Settings.Nibble.Pitch * progress)
		end
	elseif phase == "Bite" then
		local alpha = smooth(elapsed / Settings.BiteSinkTime)
		local bounce = BaitElasticMotion.Sample("Bite", elapsed, self.timeline.hookWindow)
		baitPosition = target
			- Vector3.yAxis * self.biteDepth * alpha
			+ Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * bounce
		if self.timeline and self.timeline.tutorial then
			local horizontal, vertical = FishingBiteSequence.SampleTutorialHold(elapsed)
			baitPosition += self.side * horizontal + Vector3.yAxis * vertical
		end
		frame = frame:Lerp(self:_biteFrame(baitPosition, yaw, size), alpha)
	elseif phase == "Struggling" then
		frame = self:_struggleFrame(elapsed, target)
		local mouth = frame:PointToWorldSpace(self.mouthOffset * self.scale)
		local direction = frame.LookVector * Vector3.new(1, 0, 1)
		local right = -direction.Unit
		baitPosition = mouth - right * size.X * 0.5
		baitRotation = CFrame.fromMatrix(Vector3.zero, right, Vector3.yAxis)
		if self.hookBaitOffset then
			local blend = smooth(elapsed / self.motion.struggleBlendTime)
			baitPosition = frame:PointToWorldSpace(self.hookBaitOffset):Lerp(baitPosition, blend)
			baitRotation = (frame.Rotation * self.hookBaitRotation):Lerp(baitRotation, blend)
			if self.hookContact then
				local contactPoint = self.hookContact:Lerp(Vector3.new(0.5, 0, 0), blend)
				baitPosition = mouth - baitRotation:VectorToWorldSpace(contactPoint * size)
			end
		end
	elseif phase == "Lifting" or phase == "Caught" then
		frame = self:_liftFrame(if phase == "Caught" then self:GetLiftTiming().duration else elapsed, target)
		baitPosition = frame:PointToWorldSpace(self.mouthOffset * self.scale)
	elseif phase == "Reeling" or phase == "Reeled" then
		local reel = self:_reelFrame(target)
		baitPosition, baitRotation = reel.Position, reel.Rotation
		local fish = self.reelFish
		if fish then
			frame = CFrame.new(target) * fish.frame
			fade = fish.fade
			if fish.startedAt then
				local progress = math.clamp(fish.elapsed / Settings.EscapeTime, 0, 1)
				local position = frame.Position + fish.direction * math.min(fish.elapsed, Settings.EscapeTime) * 18
				local rotation = frame.Rotation:Lerp(
					CFrame.lookAt(position, position + fish.direction).Rotation,
					smooth(fish.elapsed / Settings.Motion.Animation.FadeTime)
				)
				frame = CFrame.new(position) * rotation
				fade = fish.fade + (1 - fish.fade) * progress
			end
		end
	elseif phase == "Escaped" then
		local position = target
			+ (self.escapeOffset or frame.Position - target)
			+ self.spawnDirection * math.min(elapsed, Settings.EscapeTime) * 18
		frame = CFrame.lookAt(position, position + self.spawnDirection)
		fade = math.clamp(elapsed / Settings.EscapeTime, 0, 1)
	end
	if cameraPosition then
		local index = self:_repositionState(phase, elapsed)
		if not index and (phase == "Approaching" or phase == "Holding" or phase == "Nibbling" or phase == "Bite") then
			local mouthY = if phase == "Nibbling"
				then frame:PointToWorldSpace(self.mouthOffset * self.scale).Y
				else rest.Y
			local edge = if phase == "Bite" then contact else baitPosition + contactOffset
			local amount = if phase == "Bite" then 1 - smooth(elapsed / Settings.BiteSinkTime) else 1
			frame += self:_viewOffset(edge, mouthY, cameraPosition) * amount
		end
	end
	return frame, baitPosition, fade, baitRotation, baitPosition + contactOffset
end

function FishingBiteSequence:_pose(phase, elapsed, target, _now, request, cameraPosition)
	if self.isEgg then
		return EggMotion.Pose(self, phase, elapsed, target)
	end
	local frame, baitPosition, fade, baitRotation, baitContact = self:_basePose(phase, elapsed, target, cameraPosition)
	local pathPosition = frame.Position
	-- 出水展示沿用基础路径的中心，程序姿态只绕缩放后的嘴部支点旋转。
	self.showcasePosition = if phase == "Lifting" or phase == "Caught" then frame.Position else nil
	local turnRate = 0
	if phase == "Approaching" or phase == "Struggling" or phase == "Escaped" then
		local step = Settings.Motion.Secondary.Bank.SampleInterval
		local beforeAt = math.max(0, elapsed - step)
		local before = self:_basePose(phase, beforeAt, target, cameraPosition)
		local after = self:_basePose(phase, elapsed + step, target, cameraPosition)
		local from = horizontalUnit(before.LookVector, frame.LookVector)
		local to = horizontalUnit(after.LookVector, frame.LookVector)
		turnRate = math.atan2(from:Cross(to).Y, from:Dot(to)) / (elapsed + step - beforeAt)
	end
	local pitch, yaw, roll = FishSecondaryMotion.Sample(
		phase,
		elapsed,
		turnRate,
		request,
		self.motion.mirror,
		self.timeline.struggleTime,
		self.timeline.approachTime
	)
	local mouth = CFrame.new(self.mouthOffset * self.scale)
	if phase == "Bite" and self.timeline.tutorial then
		local _, _, angle = FishingBiteSequence.SampleTutorialHold(elapsed)
		roll += angle
	end
	frame = frame * mouth * CFrame.Angles(pitch, yaw, roll) * mouth:Inverse()
	return frame, baitPosition, fade, baitRotation, baitContact, pathPosition
end

function FishingBiteSequence:_createFishTrail(now)
	self.fishTrailAttempted = true
	self.mutationTrail = FishingMutationTrail.new(self, now)
	if self.mutationTrail then return end
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild("Fish")
	local template = folder and folder:FindFirstChild("FishTrail")
	local source0 = template and template:FindFirstChild("Att0")
	local source1 = template and template:FindFirstChild("Att1")
	local sourceTrail = source0 and source0:FindFirstChild("Trail")
	if
		not (
			source0
			and source0:IsA("Attachment")
			and source0.Archivable
			and source1
			and source1:IsA("Attachment")
			and source1.Archivable
			and sourceTrail
			and sourceTrail:IsA("Trail")
			and sourceTrail.Archivable
		)
	then
		warn("FishingBiteSequence: VFX.Fish.FishTrail is missing or invalid; skipping fish trail")
		return
	end
	-- originals 只包含鱼体可见部件；在主部件局部坐标测量，兼容宽鳍与多网格鱼。
	local body = self.fish.PrimaryPart
	local minX, maxX = math.huge, -math.huge
	for part in pairs(self.originals) do
		local relative = body.CFrame:ToObjectSpace(part.CFrame)
		for _, x in ipairs({ -1, 1 }) do
			for _, y in ipairs({ -1, 1 }) do
				for _, z in ipairs({ -1, 1 }) do
					local point = relative:PointToWorldSpace(part.Size * Vector3.new(x, y, z) * 0.5)
					minX, maxX = math.min(minX, point.X), math.max(maxX, point.X)
				end
			end
		end
	end
	if minX >= maxX then
		warn("FishingBiteSequence: fish has no visible width; skipping fish trail")
		return
	end
	local att0, att1 = source0:Clone(), source1:Clone()
	local trail = att0.Trail
	trail.Enabled = false
	trail.Attachment0, trail.Attachment1 = att0, att1
	-- 缓存未发生出水形变时的边界；每帧显式更新，避免与 ScaleTo 重复缩放。
	self.fishTrail = {
		att0 = att0,
		att1 = att1,
		trail = trail,
		minX = minX / self.scale,
		maxX = maxX / self.scale,
	}
	att0.Position, att1.Position = Vector3.new(maxX, 0, 0), Vector3.new(minX, 0, 0)
	att0.Parent, att1.Parent = body, body
	trail:Clear()
end

function FishingBiteSequence:_updateFishTrail(phase, elapsed, now)
	if self.isEgg then return end
	local rising = phase == "Lifting" and elapsed < self:GetLiftTiming().riseEnd
	if rising and not self.fishTrailAttempted then
		local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
		if waterY and self.fish.PrimaryPart.Position.Y >= waterY then
			self:_createFishTrail(now)
		end
	end
	local effect = self.fishTrail
	if effect then
		effect.att0.Position = Vector3.new(effect.maxX * self.scale, 0, 0)
		effect.att1.Position = Vector3.new(effect.minX * self.scale, 0, 0)
		-- 展示阶段只关闭生成，让最后一段拖尾按模板寿命自然消散。
		effect.trail.Enabled = rising
	end
	if self.mutationTrail and not self.mutationTrail:Update(now, rising) then
		self.mutationTrail = nil
	end
end

function FishingBiteSequence:_updateRarityVFX(phase, now)
	local stage
	if phase == "Caught" then
		-- 跨过出水阶段时不补播；两个阶段各自只消费一次。
		self.rarityExitPlayed = true
		if not self.rarityShowcasePlayed then
			self.rarityShowcasePlayed = true
			stage = "Showcase"
		end
	elseif phase == "Lifting" and not self.rarityExitPlayed then
		local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
		if waterY and self.fish.PrimaryPart.Position.Y >= waterY then
			self.rarityExitPlayed = true
			stage = "Exit"
		end
	end
	if not stage and not self.rarityEffects then
		return
	end
	local center = self.fish:GetBoundingBox()
	local diameter = 2 * self.presentationRadius * self.scale
	if stage then
		local effect =
			self.owner:_playRarityVFX(now, center.Position, self.fishConfig and self.fishConfig.Rarity, diameter, stage)
		if effect then
			self.rarityEffects = self.rarityEffects or {}
			table.insert(self.rarityEffects, effect)
		end
	end
	for index = #(self.rarityEffects or {}), 1, -1 do
		if not self.rarityEffects[index]:Update(now, center.Position, diameter) then
			table.remove(self.rarityEffects, index)
		end
	end
end

function FishingBiteSequence:_updateShowcaseVFX(now, followFish)
	if self.showcasePending and not self.showcasePlayed then
		self.showcasePending = nil
		self.showcasePlayed = true
		self.showcaseVFX = FishingShowcaseVFX.new(self, now, followFish)
	end
	if self.showcaseVFX and not self.showcaseVFX:Update(now) then
		self.showcaseVFX = nil
	end
end

local function playReelSmoke(owner)
	local bait = owner.bait
	local size = math.clamp(math.max(bait.Size.X, bait.Size.Y, bait.Size.Z), 1, 3)
	local origin = bait.Position
	local camera = workspace.CurrentCamera
	local view = if camera then camera.CFrame else CFrame.identity
	local cloud = Instance.new("Part")
	cloud.Name = "FishingReelSmoke"
	cloud.Size, cloud.Position = Vector3.one * 0.1, origin
	cloud.Anchored, cloud.Transparency = true, 1
	cloud.CanCollide, cloud.CanTouch, cloud.CanQuery = false, false, false
	cloud.Parent = owner.folder

	-- 五个圆团在镜头平面上重叠，两侧的小团散开后形成云朵轮廓。
	local layout = {
		{ offset = Vector3.new(0, 0, 0), diameter = 0.93, shade = 246 },
		{ offset = Vector3.new(-0.39, -0.08, -0.16), diameter = 0.68, shade = 225 },
		{ offset = Vector3.new(-0.25, 0.32, -0.12), diameter = 0.68, shade = 240 },
		{ offset = Vector3.new(0.33, 0.24, -0.15), diameter = 0.74, shade = 244 },
		{ offset = Vector3.new(0.36, -0.16, -0.17), diameter = 0.60, shade = 226 },
		{ offset = Vector3.new(-0.83, 0.38, -0.10), diameter = 0.25, shade = 242 },
		{ offset = Vector3.new(0.84, 0.45, -0.10), diameter = 0.21, shade = 233 },
	}
	local expand = TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local fade = TweenInfo.new(0.27, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	for _, lobe in ipairs(layout) do
		local offset = view:VectorToWorldSpace(lobe.offset * size)
		local fullSize = Vector3.one * lobe.diameter * size
		local puff = Instance.new("Part")
		puff.Name, puff.Shape = "Puff", Enum.PartType.Ball
		puff.Size, puff.Position = fullSize * 0.25, origin + offset * 0.12
		puff.Color = Color3.fromRGB(lobe.shade, lobe.shade, lobe.shade + 2)
		puff.Material, puff.Transparency = Enum.Material.SmoothPlastic, 0.08
		puff.Anchored, puff.CastShadow = true, false
		puff.CanCollide, puff.CanTouch, puff.CanQuery = false, false, false
		puff.Parent = cloud
		local pop = TweenService:Create(puff, expand, { Position = origin + offset, Size = fullSize })
		pop.Completed:Once(function(state)
			if state == Enum.PlaybackState.Completed and puff.Parent then
				TweenService:Create(puff, fade, {
					Position = origin + offset * 1.42 + Vector3.yAxis * size * 0.28,
					Size = fullSize * 1.08,
					Transparency = 1,
				}):Play()
			end
		end)
		pop:Play()
	end
	Debris:AddItem(cloud, 0.4)
end

-- Update 先准备基础姿态供镜头取景；正式会话在镜头更新后调用 Present。
function FishingBiteSequence:Present(cameraPosition, caughtBodyFrame)
	self.presentationCamera = cameraPosition
	local pose = self.pendingPose
	if self.destroyed or not pose then
		return
	end
	local frame, baitPosition, _, baitRotation =
		self:_pose(pose.phase, pose.elapsed, pose.target, pose.now, pose.request, cameraPosition)
	frame = caughtBodyFrame or frame
	local offset = CFrame.new(self.bodyOffset.Position * self.scale) * self.bodyOffset.Rotation
	self.fish:PivotTo(frame * offset:Inverse())
	self.displayFrame = frame
	if not self.isEgg then
		self:_updateFishTrail(pose.phase, pose.elapsed, pose.now)
	end
	if self.originalShown and self.mutationId and not self.mutationShown then
		self.mutationShown = true
		MutationVisualUtil.Apply(self.fish, self.mutationId, self.template.Name)
	end
	self:_updateRarityVFX(pose.phase, pose.now)
	local customCatch = self.owner.options and self.owner.options.presentCaught
	if caughtBodyFrame or not customCatch then
		self:_updateShowcaseVFX(pose.now, caughtBodyFrame ~= nil)
	end
	-- 在鱼的本帧缩放、姿态与位置落定后发射，避免甩尾水珠从旧位置出现。
	if not self.isEgg and pose.phase == "Caught" and not self.drip then
		self.drip = FishDripEffect.new(self.fish)
	end
	local active = self.animation.active
	local request = pose.request
	local playing = active
		and request
		and active.name == request.name
		and active.token == request.token
		and active.track.IsPlaying
	if self.owner.fishAudio and not self.isEgg then
		self.owner.fishAudio:UpdateFlap(pose.phase, request, playing)
	end
	if self.drip then
		self.drip:Update(pose.phase, pose.elapsed, if playing then request else nil)
	end
	BaitElasticMotion.Apply(
		self.owner,
		CFrame.new(baitPosition) * baitRotation,
		self:_baitScaleAt(pose.phase, pose.elapsed)
	)
	if pose.phase == "Reeled" and not self.reelSmokePlayed then
		self.reelSmokePlayed = true
		playReelSmoke(self.owner)
	end
	self.linePosition = if not caughtBodyFrame and (pose.phase == "Lifting" or pose.phase == "Caught")
		then frame:PointToWorldSpace(self.mouthOffset * self.scale) - Vector3.yAxis * Settings.ShowcaseLineMouthDrop
		else nil
end

function FishingBiteSequence:_updateReelSurface(now, target)
	if self.reelSurfaced or not self.reelMotion.lifting then
		return
	end
	local waterY = assert(WaterSurfaceUtil.GetWaterSurfaceY(), "Workspace.Areas.Water.Top disappeared")
	if target.Y + self.reelMotion.position.Y <= waterY then
		return
	end
	-- 空收首次出水就提示失败，与附近鱼开始逃离使用同一个判断点。
	-- 静音时也消费此事件，后续回弹或重新开启声音不能补播。
	self.reelSurfaced = true
	if self.owner.fishAudio then
		self.owner.fishAudio:Play("FishFail")
	end
	if self.reelFish and not self.reelFish.startedAt then
		self.reelFish.startedAt = now
	end
end

function FishingBiteSequence:Update(now, deferPresentation)
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
	local target = owner:_waterTarget()
	if phase == "Reeling" or phase == "Reeled" then
		if not self.reelMotion then
			self.reelFrom = self.reelFrom or CFrame.new(-owner:_waterTarget()) * owner.bait.CFrame
			self.reelMotion =
				FishingReelSpring.new(self.reelFrom.Position, BaitElasticMotion.BaseSize(owner).Y, timeline.startedAt)
		end
		local _, settled = self.reelMotion:Update(now)
		self:_updateReelSurface(now, target)
		local fish = self.reelFish
		if fish then
			fish.elapsed = if fish.startedAt then math.max(0, now - fish.startedAt) else 0
			fish.finished = fish.elapsed >= Settings.EscapeTime
		end
		if phase == "Reeling" and settled then
			timeline:FinishReel(now)
			phase = timeline.phase
		end
	end
	self.pendingPose = nil
	if phase == "Bite" then
		self:_biteSound()
		self:_trueBiteFeedback(now, target)
	end
	local elapsed = math.max(0, now - timeline.startedAt)
	owner:_presentBait(phase, elapsed)
	if phase ~= self.lastPhase or timeline.startedAt ~= self.lastStartedAt then
		if phase == "Escaped" then
			self.escapeOffset = self.lastPosition and self.lastPosition - target
		elseif phase == "Struggling" or (phase == "Lifting" and self.isEgg) then
			owner:_waterFeedback(now, target, 0.8, false, phase == "Lifting")
			if phase == "Lifting" then
				owner:_playWaterVFX(now, Config.WaterVFX.Exit, target)
				owner:_impulse(Config.Camera.FishExit, timeline.startedAt)
			end
		end
		self.lastPhase, self.lastStartedAt = phase, timeline.startedAt
	end
	self:_updateLiftFeedback(phase, elapsed, now, target)
	if phase ~= "Settling" then
		local scale = self:_scaleAt(phase, elapsed)
		if math.abs(scale - self.scale) > 0.00001 then
			self.fish:ScaleTo(self.baseScale * scale)
			self.scale = scale
		end
		local index, time = self:_repositionState(phase, elapsed)
		local swimWeight
		if index then
			local _, weight = self:_repositionPose(index, time, target)
			swimWeight = weight
		end
		if phase == "Bite" and timeline.tutorial then
			swimWeight = 0.15
		end
		local timing = timeline:GetNibbleTiming()
		local animationPhase, animationAt = phase, timeline.startedAt
		local reeling = phase == "Reeling" or phase == "Reeled"
		if reeling and self.reelFish and not self.reelFish.finished then
			animationPhase = if self.reelFish.startedAt then "Escaped" else "Holding"
			animationAt = self.reelFish.startedAt or timeline.startedAt
		end
		local request = self.animation:Update(
			animationPhase,
			animationAt,
			now,
			self.motion.mirror,
			swimWeight,
			timing.nibbleSpeed,
			timing.attackTime,
			self:GetLiftTiming().duration
		)
		local frame, baitPosition, fade, _, baitContact, pathPosition =
			self:_pose(phase, elapsed, target, now, request)
		self.lastPosition = frame.Position
		-- 记录透视补偿前的咬点，避免镜头反过来追随自身造成的偏移。
		if not self.isEgg then
			self.lastMouthPosition = frame:PointToWorldSpace(self.mouthOffset * self.scale)
			self.lastBaitPosition = baitPosition
			self.lastBaitContact = baitContact
			self.lastPathPosition = pathPosition
		end
		self.pendingPose = { phase = phase, elapsed = elapsed, target = target, now = now, request = request }
		local visible = phase ~= "Waiting"
			and phase ~= "Reeling"
			and phase ~= "Reeled"
			and (phase ~= "Escaped" or self.wasVisible == true)
		if reeling then
			visible = self.reelFish ~= nil and not self.reelFish.finished
		end
		local original = phase == "Caught" or (phase == "Lifting" and frame.Position.Y >= target.Y)
		self:_appearance(visible, original, fade, phase, elapsed)
		self.wasVisible = visible
		if not deferPresentation then
			self:Present(self.presentationCamera)
		end
		-- 低帧率可能跨过整段触碰；仅为仍在进行的本次假咬补一次反馈。
		if
			phase == "Nibbling"
			and elapsed >= timing.attackTime * Settings.Nibble.RippleTriggerRatio
			and self.nibbleRippleEmittedAt ~= timeline.startedAt
		then
			self.nibbleRippleEmittedAt = timeline.startedAt
			owner:_nibbleRipple(now, target)
		end
		if phase == "Nibbling" and elapsed >= timing.attackTime and self.nibbleEmittedAt ~= timeline.startedAt then
			self.nibbleEmittedAt = timeline.startedAt
			owner:_nibbleFeedback(now, target)
		end
		if phase == "Struggling" then
			local tick = math.floor((elapsed + 1e-8) / Config.WaterVFX.StruggleInterval)
			if self.struggleVFXTick ~= tick then
				self.struggleVFXTick = tick
				local effectPosition = target:Lerp(baitPosition, Config.WaterVFX.StrugglePositionScale)
				owner:_playWaterVFX(
					now,
					Config.WaterVFX.Struggle,
					Vector3.new(effectPosition.X, target.Y, effectPosition.Z),
					frame.LookVector,
					self.scale
				)
			end
			if now >= (self.nextRipple or 0) then
				local _, _, _, _, strength = self.motion:SampleOrbit(elapsed)
				owner:_waterFeedback(now, baitPosition, 0.15 + 0.5 * strength, false)
				self.nextRipple = now + Settings.RippleInterval
			end
		end
	else
		self.pendingPose = { phase = phase, elapsed = elapsed, target = target, now = now }
		if not deferPresentation then
			self:Present(self.presentationCamera)
		end
	end
	owner:_setPhase(if phase == "Settling" then "Waiting" else phase)
	local text = Settings.Text
	owner.continueLabel.Text = if phase == "Caught"
		then owner.continueText or text.Return
		elseif phase == "Bite" then text.Hook
		else text.Waiting
	owner.continueLabel.Visible = if phase == "Caught"
		then timeline:CanReturn(now)
		else phase ~= "Settling"
			and phase ~= "Struggling"
			and phase ~= "Lifting"
			and phase ~= "Escaped"
			and phase ~= "Reeling"
			and phase ~= "Reeled"
	owner.continueLabel.TextTransparency = 0
	owner.continueLabel.TextColor3 = if phase == "Bite" then Color3.fromRGB(255, 220, 100) else Color3.new(1, 1, 1)
	return phase
end

function FishingBiteSequence:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self.showcasePending = nil
	if self.mutationTrail then
		self.mutationTrail:Destroy()
		self.mutationTrail = nil
	end
	if self.showcaseVFX then
		self.showcaseVFX:Destroy()
		self.showcaseVFX = nil
	end
	if self.fishTrail then
		self.fishTrail.trail.Enabled = false
		self.fishTrail.trail:Clear()
		self.fishTrail.att0:Destroy()
		self.fishTrail.att1:Destroy()
	end
	for _, effect in ipairs(self.rarityEffects or {}) do
		effect:Destroy()
	end
	if self.drip then
		self.drip:Destroy()
	end
	if self.reelMotion then
		self.reelMotion:Destroy()
	end
	if self.animation then
		self.animation:Destroy()
	end
	FishShadowAppearance.Destroy(self)
	self.fish:Destroy()
end

return FishingBiteSequence
