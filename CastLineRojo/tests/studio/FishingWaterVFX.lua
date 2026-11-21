-- Studio Client：真实资源的延迟/持续发射、真咬去重、挣扎节拍和清理。
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local Audio = require(storage.Modules.FishingAudio)
local Water = require(storage.Modules.WaterSurfaceUtil)
local config = require(storage.Modules.FishingConfig)
local vfx = config.WaterVFX
local ripplesEnabled = config.WaterRipple.Enabled
local owners = {}

local function near(a, b)
	assert(math.abs(a - b) < 0.0001, tostring(a) .. " ~= " .. tostring(b))
end

local function create(baitHeight)
	local surfaceY = assert(Water.GetWaterSurfaceY(), "Water surface is missing")
	local target = Vector3.new(1838, surfaceY, 1010)
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingWaterVFXValidation", workspace
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local rig = Instance.new("Model")
	rig.Parent = folder
	if baitHeight then
		bait.Size = Vector3.new(bait.Size.X, baitHeight, bait.Size.Z)
	end
	local owner = setmetatable({
		folder = folder,
		bait = bait,
		baitVisualScale = Vector3.one,
		forward = Vector3.zAxis,
		launch = target - Vector3.zAxis * 55,
		spin = 0,
		continueLabel = {},
		bitePrompt = Instance.new("BillboardGui"),
		trail = {},
		track = { Stop = function() end },
		rig = rig,
		options = {},
		cameraFrame = CFrame.identity,
		distance = 55,
		events = {},
		soundsPlayed = {},
		legacySplashes = 0,
		_presentBait = function() end,
		_impulse = function() end,
		_shot = function() end,
		_setPhase = function(self, phase)
			self.phase = phase
		end,
		_sound = function(self, name)
			self.soundsPlayed[name] = (self.soundsPlayed[name] or 0) + 1
		end,
		_splash = function(self)
			self.legacySplashes += 1
		end,
		_playRarityVFX = function() end, -- 稀有度演出由 FishingRarityVFX 单独验证。
		_playWaterVFX = function(self, now, name, position, direction, fishScale, fishDiameter)
			local effect = Cast._playWaterVFX(self, now, name, position, direction, fishScale, fishDiameter)
			assert(effect, "Missing test VFX: " .. name)
			if name ~= vfx.Struggle then
				local source = storage.VFX.WaterVFX[name]
				local scale = if name == vfx.Entry then 1.5 elseif name == vfx.Exit then fishScale or 1 else 1
				near(effect.model:GetScale(), source:GetScale() * scale)
			end
			assert((effect.model:GetPivot().Position - position).Magnitude < 0.001, "VFX position changed")
			for _, part in ipairs(effect.model:GetDescendants()) do
				if part:IsA("BasePart") then
					assert(
						part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery,
						"Unsafe VFX part"
					)
				end
			end
			if name == vfx.Struggle then
				near(fishScale, self.bite.scale)
				local pose = self.bite.pendingPose
				local frame, baitPosition = self.bite:_pose(pose.phase, pose.elapsed, target, now, pose.request)
				local centered = target:Lerp(baitPosition, vfx.StrugglePositionScale)
				near(position.X, centered.X)
				near(position.Z, centered.Z)
				local flat = Vector3.new(1, 0, 1)
				assert(
					((position - target) * flat).Magnitude <= ((baitPosition - target) * flat).Magnitude * 0.6 + 0.001,
					"Struggle VFX spread beyond the central 60% of the orbit"
				)
				near(position.Y, target.Y)
				local forward = (frame.LookVector * Vector3.new(1, 0, 1)).Unit
				assert(effect.model:GetPivot().LookVector:Dot(forward) > 0.9999, "Struggle VFX heading drifted")
			end
			table.insert(self.events, { name = name, at = now, effect = effect })
			return effect
		end,
	}, Cast)
	owner.fishAudio = setmetatable({
		Play = function(_, name) owner:_sound(name) end,
		StartLoop = function() end,
		StopLoop = function() end,
		UpdateFlap = function() end,
		Destroy = function() end,
	}, Audio)
	table.insert(owners, owner)
	return owner, target
end

local function begin(owner, nibbles, template, catchKind, weight)
	local random = {
		NextInteger = function(_, low)
			return if low == 0 then nibbles or 0 else 1
		end,
		NextNumber = function(_, low)
			return if low < 0 then 0 else 1
		end,
	}
	local fishConfig = if weight then { DefaultWeight = 1 } else nil
	owner.bite = Bite.new(owner, 0, 0, random, nil, template, fishConfig, catchKind, nil, weight)
	return owner.bite.timeline
end

local function count(owner, name)
	local result = 0
	for _, event in ipairs(owner.events) do
		if event.name == name then
			result += 1
		end
	end
	return result
end

local function checkStruggleSize()
	local source = storage.VFX.WaterVFX[vfx.Struggle]
	local cases = {
		{ size = Vector3.new(2, 4, 4), expected = 0.75 },
		{ size = Vector3.new(12, 24, 24), expected = 2.25 },
		{ size = Vector3.new(6, 12, 12), weight = 8, fishScale = 2, expected = 2.25 },
		{ size = Vector3.new(2, 4, 4), radius = 45, expected = 4.5 },
		{ size = Vector3.new(12, 24, 24), catchKind = "Egg", expected = 0.75 },
	}
	for _, case in ipairs(cases) do
		local owner = create()
		local template = Instance.new("Model")
		local body = Instance.new("Part")
		body.Size, body.Anchored, body.Parent = case.size, true, template
		template.PrimaryPart = body
		template:SetAttribute("PresentationRadius", case.radius)
		local timeline = begin(owner, 0, template, case.catchKind, case.weight)
		while timeline.phase ~= "Bite" do
			timeline:Advance(timeline.endsAt)
		end
		local hookAt = timeline.startedAt + 0.01
		assert(owner.bite:TryHook(hookAt), "Struggle size test could not hook the catch")
		local expectedBursts = math.ceil(timeline.struggleTime / vfx.StruggleInterval)
		for tick = 0, expectedBursts - 1 do
			local now = hookAt + tick * vfx.StruggleInterval
			owner.bite:Update(now, true)
			local event = owner.events[#owner.events]
			assert(event.name == vfx.Struggle, "Struggle burst did not play")
			near(event.effect.model:GetScale(), source:GetScale() * case.expected)
			owner:_updateWaterEffects(now)
		end
		near(owner.bite.fish:GetScale(), case.fishScale or 1)
		assert(count(owner, vfx.Struggle) == expectedBursts, "Missing struggle bursts in size test")
		owner:Destroy()
		template:Destroy()
	end
end

local function checkIdleWaterVFX()
	local idle, surface = create()
	local timeline = begin(idle, 1)
	timeline:_enter("Waiting", 0)
	vfx.IdleEnabled = false
	idle:_updateIdleWaterVFX(0)
	assert(not idle.folder:FindFirstChild(vfx.Idle), "Idle VFX played while disabled")
	vfx.IdleEnabled = true
	timeline:_enter("Settling", 0.5)
	idle:_updateIdleWaterVFX(0.5)
	assert(not idle.folder:FindFirstChild(vfx.Idle), "Idle VFX played during landing")
	timeline:_enter("Waiting", 1)
	idle:_updateIdleWaterVFX(1)
	local ripple = assert(idle.folder:FindFirstChild(vfx.Idle), "Idle VFX missing")
	local childCount = #idle.folder:GetChildren()
	near((ripple:GetPivot().Position - surface).Magnitude, 0)
	local emitter = assert(ripple:FindFirstChildWhichIsA("ParticleEmitter", true))
	local templateEmitter = storage.VFX.WaterVFX[vfx.Idle]:FindFirstChildWhichIsA("ParticleEmitter", true)
	assert(emitter.Enabled and emitter.Rate == templateEmitter.Rate, "Idle VFX lost continuous emission")
	timeline:_enter("Approaching", 2)
	idle:_updateIdleWaterVFX(2)
	timeline:_enter("Holding", 4)
	idle:_updateIdleWaterVFX(4)
	idle:_updateWaterEffects(4)
	assert(idle.folder:FindFirstChild(vfx.Idle) == ripple, "Idle VFX was recreated or expired")
	assert(#idle.folder:GetChildren() == childCount, "Idle VFX was duplicated")
	for index, phase in ipairs({ "Nibbling", "Bite", "Reeling" }) do
		local at = 5 + 2 * (index - 1)
		timeline:_enter(phase, at)
		idle:_updateIdleWaterVFX(at)
		assert(ripple.Parent == nil and not idle.folder:FindFirstChild(vfx.Idle), "Idle VFX survived " .. phase)
		timeline:_enter("Holding", at + 1)
		idle:_updateIdleWaterVFX(at + 1)
		ripple = assert(idle.folder:FindFirstChild(vfx.Idle), "Idle VFX did not resume")
	end
	idle:Destroy()
	assert(ripple.Parent == nil, "Idle VFX survived session teardown")
end

local ok, result = xpcall(function()
	checkStruggleSize()
	local idleEnabled = vfx.IdleEnabled
	local idleOK, idleError = pcall(checkIdleWaterVFX)
	vfx.IdleEnabled = idleEnabled
	assert(idleOK, idleError)
	local scaling, scalingTarget = create()
	local source = storage.VFX.WaterVFX[vfx.Struggle]
	local defaultEffect = Cast._playWaterVFX(scaling, 0, vfx.Struggle, scalingTarget)
	near(defaultEffect.model:GetScale(), source:GetScale() * vfx.StruggleScale)
	for _, case in ipairs({ { 0.5, 0.75 }, { 1, 0.75 }, { 2, 1.5 }, { 8, 6, 90 } }) do
		local effect = Cast._playWaterVFX(scaling, 0, vfx.Struggle, scalingTarget, nil, case[1], case[3])
		near(effect.model:GetScale(), source:GetScale() * case[2])
	end
	local lightEffect = Cast._playWaterVFX(scaling, 0, vfx.Light, scalingTarget, nil, 2)
	near(lightEffect.model:GetScale(), storage.VFX.WaterVFX[vfx.Light]:GetScale())
	scaling:_updateWaterEffects(vfx.Lifetime + 0.01)
	assert(#scaling.waterVFX == 0 and defaultEffect.model.Parent == nil, "Scaled struggle VFX leaked")
	scaling:Destroy()
	local fishTemplate = Bite.SelectFishTemplate(storage.Models.Fish, Random.new(42))
	local bodySize = fishTemplate:GetAttribute("FishBodySize") or fishTemplate.PrimaryPart.Size
	for _, baitHeight in ipairs({ 1, 5 }) do
		local owner, surface = create(baitHeight)
		local target = owner:_waterTarget()
		near(target.Y, surface.Y)
		local timeline = begin(owner, 1, fishTemplate)
		local bite = owner.bite
		local restingY = surface.Y - bodySize.Y * 0.5 - config.Bite.WaterClearance
		local approachStart = bite:_basePose("Approaching", 0, target)
		assert(approachStart.Position.Y < restingY, "Fish must approach from deeper water")
		local holding, baitPosition = bite:_basePose("Holding", 0, target)
		near(baitPosition.Y, surface.Y)
		for _, pose in ipairs({
			(bite:_basePose("Approaching", timeline.approachTime, target)),
			holding,
			(bite:_repositionPose(1, math.huge, target)),
			(bite:_struggleFrame(timeline.struggleTime, target)),
		}) do
			assert(math.abs(pose.Position.Y - restingY) < 0.001, "Swim depth must be relative to the Top surface")
		end
		owner._startBiteRound = function() end
		owner:_land(10)
		near(owner.events[1].effect.model:GetPivot().Position.Y, surface.Y)
		owner:Destroy()
	end

	local entry, target = create()
	entry._startBiteRound = function() end
	entry:_land(10)
	assert(
		count(entry, vfx.Entry) == 1 and entry.legacySplashes == 0
			and #(entry.ripples or {}) == (if ripplesEnabled then 3 else 0),
		"Landing feedback changed"
	)
	assert(entry.soundsPlayed.Splash == 1, "Landing audio changed")
	local effect = entry.events[1].effect
	near(effect.model:GetPivot().Position.Y, target.Y)
	local originalDroplets = assert(storage.VFX.WaterVFX[vfx.Entry]:FindFirstChild("Droplets", true))
	local droplets = assert(effect.model:FindFirstChild("Droplets", true))
	for index, original in ipairs(originalDroplets.Size.Keypoints) do
		local scaled = droplets.Size.Keypoints[index]
		near(scaled.Time, original.Time)
		near(scaled.Value, original.Value * 1.5)
		near(scaled.Envelope, original.Envelope * 1.5)
	end
	near(droplets.Speed.Min, originalDroplets.Speed.Min * 1.5)
	near(droplets.Speed.Max, originalDroplets.Speed.Max * 1.5)
	near((droplets.Acceleration - originalDroplets.Acceleration * 1.5).Magnitude, 0)
	assert(#effect.emissions == 1, "Entry Wind should be the only delayed emission")
	local wind = effect.emissions[1]
	assert(wind.emitter.Name == "Wind" and not wind.emitted and not wind.emitter.Enabled, "Wind delay ignored")
	near(wind.at, 10.1)
	entry:_updateWaterEffects(10.099)
	assert(not wind.emitted, "Wind emitted early")
	entry:_updateWaterEffects(10.101)
	assert(wind.emitted and #effect.emissions == 0, "Delayed Wind did not emit")
	entry:_updateWaterEffects(12.001)
	assert(effect.model.Parent == nil and #entry.waterVFX == 0, "Entry VFX leaked")
	entry:Destroy()

	local duration, durationTarget = create()
	effect = duration:_playWaterVFX(20, vfx.Heavy, durationTarget)
	assert(#effect.emissions == 1, "Heavy Line should have a continuous emission")
	local line = effect.emissions[1]
	assert(
		line.emitter.Name == "Line" and line.emitted and line.emitter.Enabled and line.count == 18,
		"Heavy burst/duration ignored"
	)
	near(line.endsAt, 20.1)
	duration:_updateWaterEffects(20.099)
	assert(line.emitter.Enabled, "Heavy continuous emission stopped early")
	duration:_updateWaterEffects(20.101)
	assert(not line.emitter.Enabled and #effect.emissions == 0, "Heavy Line did not stop")
	duration:Destroy()

	-- 轻咬仍在原接触点播放；程序化波纹遵循开关，且不重复生成。
	local lightOwner = create()
	local lightTimeline = begin(lightOwner, 3)
	while lightTimeline.phase ~= "Nibbling" do
		lightOwner.bite:Update(lightTimeline.endsAt)
	end
	local attack = lightTimeline:GetNibbleTiming().attackTime
	local startedAt = lightTimeline.startedAt
	lightOwner.bite:Update(startedAt + attack * config.Bite.Nibble.RippleTriggerRatio + 0.000001)
	local nibbleRipples = if ripplesEnabled then 1 else 0
	assert(#(lightOwner.ripples or {}) == nibbleRipples and #lightOwner.events == 0, "Early nibble ripple shifted light VFX")
	local contactAt = startedAt + attack + 0.000001
	lightOwner.bite:Update(contactAt)
	lightOwner.bite:Update(contactAt)
	assert(count(lightOwner, vfx.Light) == 1 and #(lightOwner.ripples or {}) == nibbleRipples, "Nibble light or ripple duplicated")
	assert(lightOwner.soundsPlayed.Splash == 1, "Nibble sound changed")
	local light = lightOwner.events[1].effect.model
	lightOwner:_updateWaterEffects(contactAt + 0.6)
	assert(#(lightOwner.ripples or {}) == 0 and light.Parent ~= nil, "Nibble lifetimes became coupled")
	lightOwner:_updateWaterEffects(contactAt + 2.001)
	assert(light.Parent == nil, "Nibble light survived 2 seconds")
	lightOwner:Destroy()

	-- 正常进入真咬、以及首次真咬渲染前提竿，都只播放一次重咬和提示音。
	for _, hookBeforeRender in ipairs({ false, true }) do
		local owner = create()
		local timeline = begin(owner, 0)
		while timeline.phase ~= "Bite" do
			if hookBeforeRender then
				timeline:Advance(timeline.endsAt)
			else
				owner.bite:Update(timeline.endsAt)
			end
		end
		local hookAt = timeline.startedAt + 0.01
		if not hookBeforeRender then
			owner.bite:Update(hookAt)
		end
		assert(owner.bite:TryHook(hookAt), "True bite hook failed")
		owner.bite:Update(hookAt)
		owner.bite:Update(hookAt)
		assert(count(owner, vfx.Heavy) == 1 and count(owner, vfx.Struggle) == 1, "Heavy/struggle duplicated")
		assert(
			owner.soundsPlayed.FishBiteHeavey == 1 and owner.legacySplashes == 0,
			"True bite kept old splash or duplicate audio"
		)
		owner:Destroy()
	end

	local cadenceCases = 0
	for _, rate in ipairs({ 15, 30, 60, 144 }) do
		for _, mirror in ipairs({ -1, 1 }) do
			local owner = create()
			local timeline = begin(owner, 0)
			owner.bite.motion.mirror = mirror
			while timeline.phase ~= "Bite" do
				timeline:Advance(timeline.endsAt)
			end
			local hookAt = timeline.startedAt + 0.01
			assert(owner.bite:TryHook(hookAt), "True bite hook failed")
			for frame = 0, rate * config.Bite.StruggleTime - 1 do
				local now = hookAt + frame / rate
				local before = count(owner, vfx.Struggle)
				owner.bite:Update(now)
				assert(count(owner, vfx.Struggle) - before <= 1, "Struggle replayed missed ticks")
				owner.bite:Update(now)
				owner:_updateWaterEffects(now)
			end
			local expected = math.ceil(config.Bite.StruggleTime / vfx.StruggleInterval)
			assert(count(owner, vfx.Struggle) == expected, "Struggle cadence changed with frame rate")
			local index = 0
			for _, event in ipairs(owner.events) do
				if event.name == vfx.Struggle then
					local offset = event.at - hookAt - index * vfx.StruggleInterval
					assert(offset >= -1e-7 and offset <= 1 / rate + 1e-7, "Struggle clock drifted")
					index += 1
				end
			end
			assert(owner.legacySplashes == 0, "Struggle kept the legacy water splash")
			if not ripplesEnabled then
				assert(#(owner.ripples or {}) == 0, "Disabled struggle ripples were generated")
			end
			local liftAt = hookAt + config.Bite.StruggleTime + 0.001
			owner.bite:Update(liftAt, true)
			assert(count(owner, vfx.Struggle) == expected and owner.legacySplashes == 0, "Lift retained legacy splash")
			assert(count(owner, vfx.Exit) == 1, "Exit or presentation timing changed")
			local exit = owner.events[#owner.events].effect
			near(exit.model:GetPivot().Position.Y, owner:_waterTarget().Y)
			owner.bite:Present()
			owner.bite:Present()
			owner.bite:Update(liftAt + 0.15)
			assert(count(owner, vfx.Exit) == 1, "Exit replayed")
			owner:_updateWaterEffects(liftAt + vfx.Lifetime + 0.01)
			assert(#owner.waterVFX == 0, "Finished struggle VFX leaked")
			owner:Destroy()
			cadenceCases += 1
			task.wait()
		end
	end

	local skipped = create()
	local timeline = begin(skipped, 0)
	while timeline.phase ~= "Bite" do
		timeline:Advance(timeline.endsAt)
	end
	local hookAt = timeline.startedAt + 0.01
	assert(skipped.bite:TryHook(hookAt), "Skipped-frame fixture hook failed")
	skipped.bite:Update(hookAt)
	skipped.bite:Update(hookAt + 1.05)
	skipped.bite:Update(hookAt + 1.05)
	assert(count(skipped, vfx.Struggle) == 2, "Long frame replayed missed struggle effects")
	skipped.bite:Update(hookAt + config.Bite.StruggleTime + 0.01)
	assert(count(skipped, vfx.Struggle) == 2, "Expired struggle spawned another effect")
	skipped.bite:Destroy()
	skipped:Destroy()
	local expired = create()
	timeline = begin(expired, 0)
	while timeline.phase ~= "Bite" do
		timeline:Advance(timeline.endsAt)
	end
	expired.bite:Update(timeline.endsAt + 0.01)
	assert(#expired.events == 0 and not expired.soundsPlayed.FishBiteHeavey, "Expired true bite replayed effects")
	expired:Destroy()

	-- 换轮和退出会取消尚未到点的发射，而不是留下后台定时回调。
	local cleanup, cleanupTarget = create()
	begin(cleanup, 0)
	effect = cleanup:_playWaterVFX(0, vfx.Entry, cleanupTarget)
	wind = effect.emissions[1]
	cleanup:_startBiteRound(0.05)
	cleanup:_updateWaterEffects(0.2)
	assert(
		effect.model.Parent == nil and not wind.emitted and #cleanup.waterVFX == 0,
		"Cleanup left a pending emission"
	)
	effect = cleanup:_playWaterVFX(0.3, vfx.Entry, cleanupTarget)
	wind = effect.emissions[1]
	cleanup:Destroy()
	assert(
		effect.model.Parent == nil and not wind.emitted and #cleanup.waterVFX == 0,
		"Cleanup left a pending emission"
	)

	local reel, reelTarget = create()
	begin(reel, 0)
	effect = reel:_playWaterVFX(0, vfx.Entry, reelTarget)
	assert(not reel.bite:TryHook(0.01) and reel.legacySplashes == 1, "Empty reel splash changed")
	if not ripplesEnabled then
		assert(#(reel.ripples or {}) == 0, "Disabled reel ripples were generated")
	end
	reel:_updateWaterEffects(2.01)
	assert(effect.model.Parent == nil and #reel.waterVFX == 0, "Empty reel leaked VFX")
	reel:Destroy()

	-- 缺失水面资源只 warning。
	local missing = create()
	begin(missing, 0)
	assert(Cast._playWaterVFX(missing, 0, "MissingExitVFX", missing:_waterTarget()) == nil, "Missing VFX did not skip")
	assert(missing.warnedWaterVFX["WaterVFX.MissingExitVFX"], "Missing water VFX did not warn")
	missing:Destroy()
	return {
		passed = true,
		cadenceCases = cadenceCases,
		delay = true,
		duration = true,
		trueBiteDeduplication = true,
		longFrames = true,
		cleanup = true,
		exitOnce = true,
		missingResources = true,
		legacyReel = true,
	}
end, debug.traceback)
for _, owner in ipairs(owners) do
	if not owner.destroyed then
		owner:Destroy()
	end
end
assert(ok, result)
return result
