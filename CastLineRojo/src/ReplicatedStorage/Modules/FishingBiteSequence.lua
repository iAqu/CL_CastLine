local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite
local BaitElasticMotion = require(script.Parent.BaitElasticMotion)
local FishingReelSpring = require(script.Parent.FishingReelSpring)
local WaterSurfaceUtil = require(script.Parent.WaterSurfaceUtil)
local FishAnimationController = require(script.Parent.FishAnimationController)
local FishSecondaryMotion = require(script.Parent.FishSecondaryMotion)
local FishRepositionPath = require(script.Parent.FishRepositionPath)
local FishDripEffect = require(script.Parent.FishDripEffect)

local FishingBiteSequence = {}
FishingBiteSequence.__index = FishingBiteSequence

-- 时序与实例表现分开，输入和渲染共用同一个绝对时钟。
local Timeline = {}
Timeline.__index = Timeline

local function nibbleTiming(speed)
	return {
		nibbleSpeed = speed,
		duration = Settings.NibbleTime / speed,
		attackTime = Settings.Nibble.AttackTime / speed,
		returnAt = (Settings.Nibble.AttackTime + Settings.Nibble.ContactTime) / speed,
		reboundEnd = (Settings.Nibble.AttackTime + Settings.Nibble.ContactTime + Settings.Nibble.ReboundTime) / speed,
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

function FishingBiteSequence.NewTimeline(startedAt, random, readyAt)
	local rng = random or Random.new()
	local timeline = setmetatable({
		random = rng,
		nibbleIndex = 0,
		completedNibbles = 0,
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
			local pause = self.random:NextNumber(Settings.PauseMin, Settings.PauseMax)
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
	local time = math.clamp(elapsed, 0, Settings.StruggleTime)
	local blendTime = Settings.Struggle.BlendTime
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
		local duration = Settings.StruggleTime - blendTime
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
	elapsed *= entry.nibbleSpeed
	local progress = smooth(elapsed / settings.AttackTime)
	local retreatAt = settings.AttackTime + settings.ContactTime
	local pressure = smooth(elapsed / settings.AttackTime) * (1 - smooth((elapsed - retreatAt) / settings.ReboundTime))
	return progress, pressure * entry.depth, entry
end

function FishingBiteSequence.NewMotion(startedAt, random)
	-- 表现随机数独立于咬钩时序，不因渲染频率改变玩法抽样。
	local rng = random or Random.new()
	local motion = setmetatable({
		startedAt = startedAt,
		random = rng,
		nibbles = {},
		mirror = if rng:NextInteger(0, 1) == 0 then -1 else 1,
	}, Motion)
	local settings, yaw, gap = Settings.Nibble, 0, 1
	for index = 1, Settings.MaxNibbles do
		local turn = rng:NextNumber(settings.TurnMin, settings.TurnMax) * (if rng:NextInteger(0, 1) == 0 then -1 else 1)
		if math.abs(yaw + turn) > settings.TurnLimit then
			turn = -turn
		end
		local nextYaw = yaw + turn
		local nextGap = rng:NextNumber(settings.GapMin, settings.GapMax)
		local entry = nibbleTiming(rng:NextNumber(settings.SpeedMin, settings.SpeedMax))
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
		assert(template and template:IsA("Model") and template.PrimaryPart,
			"Models.Fish." .. Settings.FishName .. " is missing or invalid")
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

local function prepareRound(owner, template, startedAt, readyAt, random, visualRandom)
	local rng = random or Random.new()
	local self = setmetatable({
		owner = owner,
		timeline = FishingBiteSequence.NewTimeline(startedAt, rng, readyAt),
		motion = FishingBiteSequence.NewMotion(startedAt, visualRandom),
		originals = {},
		surfaces = {},
	}, FishingBiteSequence)
	local body = template.PrimaryPart
	-- 多部件鱼的 PrimaryPart 可能只覆盖半段鱼身，制作时标定完整体形尺寸。
	local bodySize = template:GetAttribute("FishBodySize")
	if typeof(bodySize) ~= "Vector3" or math.min(bodySize.X, bodySize.Y, bodySize.Z) <= 0 then
		bodySize = body.Size
	end
	self.halfLength, self.depth = bodySize.Z * 0.5, bodySize.Y * 0.5 + Settings.WaterClearance
	self.bodyWidth = math.max(bodySize.X, bodySize.Y)
	-- 美术导出时测量全部蒙皮部件在五个动作中的范围，包含宽鳍、长尾与装饰。
	self.presentationRadius = template:GetAttribute("PresentationRadius")
	local mouth = body:FindFirstChild("MouthAttachment")
	self.mouthOffset = if mouth and mouth:IsA("Attachment")
		then mouth.Position
		else body.Size * Vector3.new(unpack(Settings.MouthOffset))
	self.bodyOffset = template:GetPivot():ToObjectSpace(body.CFrame)
	self.baseScale, self.scale = template:GetScale(), 1
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

function FishingBiteSequence.GetBiteWindow(template, baitSize, startedAt, readyAt, seed, motionSeed, spin)
	local owner = { baitBaseSize = baitSize, forward = Vector3.zAxis, spin = spin }
	local round = prepareRound(owner, template, startedAt, readyAt, Random.new(seed), Random.new(motionSeed))
	local timeline = round.timeline
	while timeline.phase ~= "Bite" do
		timeline:Advance(timeline.endsAt)
	end
	return timeline.startedAt, timeline.endsAt
end

function FishingBiteSequence.new(owner, startedAt, readyAt, random, visualRandom, template)
	owner.baitBaseSize = BaitElasticMotion.BaseSize(owner)
	if not template then
		local models = ReplicatedStorage:FindFirstChild("Models")
		local fishFolder = models and models:FindFirstChild("Fish")
		template = FishingBiteSequence.SelectFishTemplate(fishFolder)
	end
	local self = prepareRound(owner, template, startedAt, readyAt, random, visualRandom)
	local fish = template:Clone()
	fish.Name, fish.Parent = "BitingFish", owner.folder
	self.fish = fish
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
					material = part.Material,
					materialVariant = part.MaterialVariant,
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
	highlight.FillTransparency, highlight.OutlineTransparency = 1, 1
	highlight.DepthMode, highlight.Enabled = Enum.HighlightDepthMode.AlwaysOnTop, false
	highlight.Parent, self.highlight = fish, highlight
	self.animation = FishAnimationController.new(fish, startedAt, self.motion.random)
	return self
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

function FishingBiteSequence:TryHook(now)
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
	owner:_waterFeedback(now, target, 0.8, false)
	local surface = target - Vector3.yAxis * BaitElasticMotion.BaseSize(owner).Y * 0.15
	owner:_playWaterVFX(now, Config.WaterVFX.Heavy, surface)
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
	local shadow = visible and not original and fade < 1
	-- 挣扎只淡出高亮，鱼身保持可见；出水前也保持淡出终点，避免阶段切换闪回。
	local highlightFade = if phase == "Struggling"
		then smooth(elapsed / Settings.Struggle.HighlightFadeTime)
		elseif phase == "Lifting" or phase == "Caught" then 1
		else 0
	highlightFade = 1 - (1 - fade) * (1 - highlightFade)
	self.highlight.FillTransparency = if shadow
		then Settings.ShadowTransparency + (1 - Settings.ShadowTransparency) * highlightFade
		else 1
	-- 出水显色后复用鱼影高亮，只保留遵循场景遮挡的黑色描边。
	self.highlight.OutlineColor = if original then Color3.new(0, 0, 0) else Color3.fromRGB(254, 254, 254)
	self.highlight.OutlineTransparency = if original then fade else self.highlight.FillTransparency
	self.highlight.DepthMode = if original
		then Enum.HighlightDepthMode.Occluded
		else Enum.HighlightDepthMode.AlwaysOnTop
	for part, saved in pairs(self.originals) do
		-- Plastic 半透明网格会被 Highlight 排除；Glass 让填充和描边完整参与渐变。
		-- 仅在可见鱼影阶段使用，隐藏和出水时恢复，避免全透明 Glass 残影。
		part.Material = if shadow then Enum.Material.Glass else saved.material
		part.MaterialVariant = if shadow then "" else saved.materialVariant
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
	-- 外观就绪后再启用；完全淡出后关闭，避免首尾帧使用旧的填充/描边。
	self.highlight.Enabled = (visible and original and fade < 1) or (shadow and highlightFade < 1)
end

function FishingBiteSequence:_scaleAt(phase, elapsed)
	if phase == "Lifting" then
		local punch = math.sin(math.pi * math.clamp(elapsed / Settings.LiftScaleTime, 0, 1))
		local recover = math.sin(math.pi * math.clamp((elapsed - Settings.LiftScaleTime) / 0.25, 0, 1))
		local bounce =
			BaitElasticMotion.Rebound((elapsed / Settings.LiftTime - Settings.LiftFallEnd) / (1 - Settings.LiftFallEnd))
		return 1 + (Settings.LiftScalePeak - 1) * punch - 0.06 * recover + Settings.LiftBounceScale * bounce
	end
	return 1
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
		+ outward * (self.halfLength + Settings.NibbleGap * gap)
		- Vector3.yAxis * self.depth
	return CFrame.lookAt(center, center - outward):PointToWorldSpace(self.mouthOffset)
end

function FishingBiteSequence:_biteFrame(baitPosition, yaw, size)
	yaw = yaw or self:_feedingState("Bite", 0)
	return self:_frameAtMouth(baitPosition + self:_contactOffset(yaw, size), yaw, Settings.BiteTilt)
end

-- 所有回游路径以落水点为局部原点，在建轮时预计算，不能依赖上一渲染帧。
function FishingBiteSequence:_prepareRepositions()
	self.repositions = {}
	self.timeline.nibbleTimings = self.motion.nibbles
	self.timeline.repositionDurations = {}
	local settings = Settings.Nibble
	local speed = Settings.ApproachDistance / Settings.ApproachTime * settings.ReturnSpeedScale
	local radius = math.max(0.5, self.halfLength * settings.ReturnRadiusScale)
	for index, entry in ipairs(self.motion.nibbles) do
		local rest = self:_restMouth(Vector3.zero, entry.beforeGap, entry.beforeYaw)
		local _, contactScale = BaitElasticMotion.Sample("Nibbling", entry.returnAt, nil, entry.nibbleSpeed)
		local contact = self:_contactOffset(entry.beforeYaw, BaitElasticMotion.BaseSize(self.owner) * contactScale)
		local mouth = Vector3.new(contact.X, rest.Y - BaitElasticMotion.BaseSize(self.owner).Y * entry.depth, contact.Z)
		local first = self:_frameAtMouth(mouth, entry.beforeYaw, settings.Pitch)
		local last = self:_frameAtMouth(self:_restMouth(Vector3.zero, entry.gap, entry.yaw), entry.yaw, 0)
		local function planar(frame)
			return {
				x = frame.Position.X,
				z = frame.Position.Z,
				heading = math.atan2(frame.LookVector.Z, frame.LookVector.X),
			}
		end
		local path = FishRepositionPath.new(
			planar(first), planar(last), radius, speed * entry.returnSpeed, settings.ReturnRampTime, settings.ReturnTurnBlendTime
		)
		self.repositions[index] = { path = path, first = first, last = last }
		self.timeline.repositionDurations[index] = path.duration
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
			local _, scale = BaitElasticMotion.Sample("Nibbling", entry.returnAt, nil, entry.nibbleSpeed)
			size *= scale
		end
		local contact = self:_contactOffset(yaw, size)
			- Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * pressure
		local mouth = frame:PointToWorldSpace(self.mouthOffset)
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
	local path = source.path
	-- 镜头只能改变表现路径，不能改变既定的回游时长和咬钩时序。
	local distance, speed = source.path:DistanceAt(elapsed)
	local weight = speed / source.path.speed
	if elapsed >= source.path.duration then
		weight = Settings.Motion.Animation.HoldWeight
			* smooth((elapsed - path.duration) / Settings.Nibble.ReturnRampTime)
		return CFrame.new(target) * route.last, weight
	elseif elapsed <= 0 then
		return CFrame.new(target) * route.first, 0
	end
	local u = distance / source.path.length
	local x, z, heading = path:Sample(u * path.length)
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
	local blend = smooth(elapsed / Settings.Struggle.BlendTime)
	local position = target
		+ outward * radius * fraction
		+ Vector3.yAxis * (initial.Position.Y - target.Y + (target.Y - self.depth - initial.Position.Y) * blend)
	local direction = horizontalUnit(tangent, horizontalUnit(initial.LookVector, -radial))
	local rotation = initial.Rotation:Lerp(CFrame.lookAt(Vector3.zero, direction).Rotation, blend)
	return CFrame.new(position) * rotation
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
	return goal + Vector3.yAxis * Settings.LiftBounceHeight * BaitElasticMotion.Rebound(bounce)
end

function FishingBiteSequence:_reelFrame(target)
	return CFrame.new(target + self.reelMotion.position) * self.reelFrom.Rotation
end

function FishingBiteSequence:_baitScaleAt(phase, elapsed)
	local duration = self.timeline.endsAt - self.timeline.startedAt
	local _, scale = BaitElasticMotion.Sample(phase, elapsed, duration, self.timeline:GetNibbleTiming().nibbleSpeed)
	local from, blendTime
	if phase == "Struggling" then
		from, blendTime = self.hookScale, Settings.Struggle.BlendTime
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
		local progress = smooth(elapsed / Settings.ApproachTime)
		local start = contact
			+ outward * (Settings.ApproachDistance + self.halfLength)
			- Vector3.yAxis * (self.depth + Settings.AppearRise)
		local position = start:Lerp(frame.Position, progress)
		frame = CFrame.lookAt(position, position - outward)
		fade = 1 - math.clamp(elapsed / Settings.AppearTime, 0, 1)
	elseif phase == "Holding" and self.timeline.completedNibbles > 0 then
		local index, time = self:_repositionState(phase, elapsed)
		frame = self:_repositionPose(index, time, target, cameraPosition)
	elseif phase == "Nibbling" then
		local progress, pressure = self.motion:SampleNibble(self.timeline.nibbleIndex, elapsed)
		local bounce = BaitElasticMotion.Sample("Nibbling", elapsed, nil, self.timeline:GetNibbleTiming().nibbleSpeed)
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
			local mouth = rest:Lerp(contactMouth, progress)
			local arc =
				math.min(math.abs(math.sin(yaw)) * Settings.NibbleGap, Settings.NibbleGap * Settings.Nibble.ArcLimit)
			mouth += outward:Cross(Vector3.yAxis) * arc * math.sin(math.pi * progress) * math.sign(yaw)
			frame = self:_frameAtMouth(mouth, yaw, Settings.Nibble.Pitch * progress)
		end
	elseif phase == "Bite" then
		local alpha = smooth(elapsed / Settings.BiteSinkTime)
		local bounce = BaitElasticMotion.Sample("Bite", elapsed)
		baitPosition = target
			- Vector3.yAxis * self.biteDepth * alpha
			+ Vector3.yAxis * BaitElasticMotion.BaseSize(self.owner).Y * bounce
		frame = frame:Lerp(self:_biteFrame(baitPosition, yaw, size), alpha)
	elseif phase == "Struggling" then
		frame = self:_struggleFrame(elapsed, target)
		local mouth = frame:PointToWorldSpace(self.mouthOffset * self.scale)
		local direction = frame.LookVector * Vector3.new(1, 0, 1)
		local right = -direction.Unit
		baitPosition = mouth - right * size.X * 0.5
		baitRotation = CFrame.fromMatrix(Vector3.zero, right, Vector3.yAxis)
		if self.hookBaitOffset then
			local blend = smooth(elapsed / Settings.Struggle.BlendTime)
			baitPosition = frame:PointToWorldSpace(self.hookBaitOffset):Lerp(baitPosition, blend)
			baitRotation = (frame.Rotation * self.hookBaitRotation):Lerp(baitRotation, blend)
			if self.hookContact then
				local contactPoint = self.hookContact:Lerp(Vector3.new(0.5, 0, 0), blend)
				baitPosition = mouth - baitRotation:VectorToWorldSpace(contactPoint * size)
			end
		end
	elseif phase == "Lifting" or phase == "Caught" then
		frame = self:_liftFrame(if phase == "Caught" then Settings.LiftTime else elapsed, target)
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
	return frame, baitPosition, fade, baitRotation
end

function FishingBiteSequence:_pose(phase, elapsed, target, _now, request, cameraPosition)
	local frame, baitPosition, fade, baitRotation = self:_basePose(phase, elapsed, target, cameraPosition)
	-- 镜头使用基础路径的中心，程序姿态只绕缩放后的嘴部支点旋转。
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
	local pitch, yaw, roll = FishSecondaryMotion.Sample(phase, elapsed, turnRate, request, self.motion.mirror)
	local mouth = CFrame.new(self.mouthOffset * self.scale)
	frame = frame * mouth * CFrame.Angles(pitch, yaw, roll) * mouth:Inverse()
	return frame, baitPosition, fade, baitRotation
end

function FishingBiteSequence:_createFishTrail()
	self.fishTrailAttempted = true
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild("Fish")
	local template = folder and folder:FindFirstChild("FishTrail")
	local source0 = template and template:FindFirstChild("Att0")
	local source1 = template and template:FindFirstChild("Att1")
	local sourceTrail = source0 and source0:FindFirstChild("Trail")
	if not (
		source0 and source0:IsA("Attachment") and source0.Archivable
		and source1 and source1:IsA("Attachment") and source1.Archivable
		and sourceTrail and sourceTrail:IsA("Trail") and sourceTrail.Archivable
	) then
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
		att0 = att0, att1 = att1, trail = trail,
		minX = minX / self.scale, maxX = maxX / self.scale,
	}
	att0.Position, att1.Position = Vector3.new(maxX, 0, 0), Vector3.new(minX, 0, 0)
	att0.Parent, att1.Parent = body, body
	trail:Clear()
end

function FishingBiteSequence:_updateFishTrail(phase)
	if phase == "Lifting" and not self.fishTrailAttempted then
		local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
		if waterY and self.fish.PrimaryPart.Position.Y >= waterY then
			self:_createFishTrail()
		end
	end
	local effect = self.fishTrail
	if effect then
		effect.att0.Position = Vector3.new(effect.maxX * self.scale, 0, 0)
		effect.att1.Position = Vector3.new(effect.minX * self.scale, 0, 0)
		-- 展示阶段只关闭生成，让最后一段拖尾按模板寿命自然消散。
		effect.trail.Enabled = phase == "Lifting"
	end
end

-- Update 先准备基础姿态供镜头取景；正式会话在镜头更新后调用 Present。
function FishingBiteSequence:Present(cameraPosition)
	self.presentationCamera = cameraPosition
	local pose = self.pendingPose
	if not pose then
		return
	end
	local frame, baitPosition, _, baitRotation =
		self:_pose(pose.phase, pose.elapsed, pose.target, pose.now, pose.request, cameraPosition)
	local offset = CFrame.new(self.bodyOffset.Position * self.scale) * self.bodyOffset.Rotation
	self.fish:PivotTo(frame * offset:Inverse())
	self.displayFrame = frame
	self:_updateFishTrail(pose.phase)
	if pose.phase == "Lifting" and not self.rarityVFXPlayed then
		self.rarityVFXPlayed = true
		local center = self.fish:GetBoundingBox()
		self.rarityVFX = self.owner:_playRarityVFX(pose.now, center.Position)
	end
	if self.rarityVFX and self.rarityVFX.model.Parent then
		local center = self.fish:GetBoundingBox()
		self.rarityVFX.model:PivotTo(CFrame.new(center.Position) * self.rarityVFX.rotation)
	end
	-- 在鱼的本帧缩放、姿态与位置落定后发射，避免甩尾水珠从旧位置出现。
	if pose.phase == "Caught" and not self.drip then
		self.drip = FishDripEffect.new(self.fish)
	end
	local active = self.animation.active
	local request = pose.request
	local playing = active and request and active.name == request.name and active.token == request.token and active.track.IsPlaying
	if self.owner.fishAudio then
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
	self.linePosition = if pose.phase == "Lifting" or pose.phase == "Caught"
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
		elseif phase == "Struggling" or phase == "Lifting" then
			owner:_waterFeedback(now, target, 0.8, false, phase == "Lifting")
			if phase == "Lifting" then
				local surface = target - Vector3.yAxis * BaitElasticMotion.BaseSize(owner).Y * 0.15
				owner:_playWaterVFX(now, Config.WaterVFX.Exit, surface)
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
		local index, time = self:_repositionState(phase, elapsed)
		local swimWeight
		if index then
			local _, weight = self:_repositionPose(index, time, target)
			swimWeight = weight
		end
		local timing = timeline:GetNibbleTiming()
		local animationPhase, animationAt = phase, timeline.startedAt
		local reeling = phase == "Reeling" or phase == "Reeled"
		if reeling and self.reelFish and not self.reelFish.finished then
			animationPhase = if self.reelFish.startedAt then "Escaped" else "Holding"
			animationAt = self.reelFish.startedAt or timeline.startedAt
		end
		local request = self.animation:Update(
			animationPhase, animationAt, now, self.motion.mirror, swimWeight, timing.nibbleSpeed
		)
		local frame, baitPosition, fade = self:_pose(phase, elapsed, target, now, request)
		self.lastPosition = frame.Position
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
		if
			phase == "Nibbling"
			and elapsed >= timing.attackTime
			and self.nibbleEmittedAt ~= timeline.startedAt
		then
			self.nibbleEmittedAt = timeline.startedAt
			owner:_nibbleFeedback(now, target)
		end
		if phase == "Struggling" then
			local tick = math.floor((elapsed + 1e-8) / Config.WaterVFX.StruggleInterval)
			if self.struggleVFXTick ~= tick then
				self.struggleVFXTick = tick
				local waterY = target.Y - BaitElasticMotion.BaseSize(owner).Y * 0.15
				local effectPosition = target:Lerp(baitPosition, Config.WaterVFX.StrugglePositionScale)
				owner:_playWaterVFX(
					now, Config.WaterVFX.Struggle,
					Vector3.new(effectPosition.X, waterY, effectPosition.Z), frame.LookVector
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
	owner.statusLabel.Visible = phase == "Escaped" or (phase == "Caught" and timeline:CanReturn(now))
	owner.statusLabel.Text = if phase == "Caught" then text.Caught else text.Escaped
	owner.returnLabel.Text = if phase == "Caught"
		then text.Return
		elseif phase == "Bite" then text.Hook
		else text.Waiting
	owner.returnLabel.Visible = if phase == "Caught"
		then timeline:CanReturn(now)
		else phase ~= "Settling"
			and phase ~= "Struggling"
			and phase ~= "Lifting"
			and phase ~= "Escaped"
			and phase ~= "Reeling"
			and phase ~= "Reeled"
	owner.returnLabel.TextTransparency = 0
	owner.returnLabel.TextColor3 = if phase == "Bite" then Color3.fromRGB(255, 220, 100) else Color3.new(1, 1, 1)
	return phase
end

function FishingBiteSequence:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	if self.fishTrail then
		self.fishTrail.trail.Enabled = false
		self.fishTrail.trail:Clear()
		self.fishTrail.att0:Destroy()
		self.fishTrail.att1:Destroy()
	end
	if self.rarityVFX then
		self.rarityVFX.model:Destroy()
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
	for _, surface in ipairs(self.surfaces) do
		surface.instance:Destroy()
	end
	self.fish:Destroy()
end

return FishingBiteSequence
