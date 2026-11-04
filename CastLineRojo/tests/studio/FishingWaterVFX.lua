-- Studio Client：真实资源的延迟/持续发射、真咬去重、挣扎节拍和清理。
local storage = game:GetService("ReplicatedStorage")
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local Elastic = require(storage.Modules.BaitElasticMotion)
local config = require(storage.Modules.FishingConfig)
local vfx = config.WaterVFX
local ripplesEnabled = config.WaterRipple.Enabled
local owners = {}

local function near(a, b)
	assert(math.abs(a - b) < 0.0001, tostring(a) .. " ~= " .. tostring(b))
end

local function create()
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingWaterVFXValidation", workspace
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local target = Vector3.new(1838, 772, 1010)
	local owner = setmetatable({
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		spin = 0,
		statusLabel = {},
		returnLabel = {},
		distanceLabel = {},
		trail = {},
		cameraFrame = CFrame.identity,
		distance = 55,
		events = {},
		soundsPlayed = {},
		legacySplashes = 0,
		_waterTarget = function()
			return target
		end,
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
		_playRarityVFX = function(self, now, position)
			local effect = Cast._playRarityVFX(self, now, position)
			assert(effect and effect.model:IsA("BasePart"), "Missing Part rarity VFX")
			local source = storage.VFX.AnimalRoller[config.RarityVFX.Template]
			local part = effect.model
			assert(part.Parent == self.folder and not part:IsDescendantOf(self.bite.fish), "Rarity VFX altered fish bounds")
			assert(part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery, "Unsafe rarity root")
			assert(part.Size == source.Size and part.Color == source.Color, "Rarity template appearance changed")
			assert(part:GetPivot().Rotation:FuzzyEq(source:GetPivot().Rotation, 0.0001), "Rarity rotation changed")
			local emitters = 0
			for _, emitter in ipairs(part:GetDescendants()) do
				if emitter:IsA("ParticleEmitter") then
					local original = source:FindFirstChild(emitter.Name, true)
					assert(emitter.LockedToPart == original.LockedToPart, "Rarity particle locking changed")
					assert(emitter:GetAttribute("EmitCount") == original:GetAttribute("EmitCount"), "Rarity burst count changed")
					assert(not emitter.Enabled, "One-shot rarity emitter left enabled")
					emitters += 1
				end
			end
			assert(emitters == 7, "Rarity emitters missing")
			table.insert(self.events, { name = config.RarityVFX.Template, at = now, effect = effect })
			return effect
		end,
		_playWaterVFX = function(self, now, name, position, direction)
			local effect = Cast._playWaterVFX(self, now, name, position, direction)
			assert(effect, "Missing test VFX: " .. name)
			local source = storage.VFX.WaterVFX[name]
			local scale = if name == vfx.Struggle then vfx.StruggleScale else 1
			near(effect.model:GetScale(), source:GetScale() * scale)
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
				near(position.Y, target.Y - Elastic.BaseSize(self).Y * 0.15)
				local forward = (frame.LookVector * Vector3.new(1, 0, 1)).Unit
				assert(effect.model:GetPivot().LookVector:Dot(forward) > 0.9999, "Struggle VFX heading drifted")
			end
			table.insert(self.events, { name = name, at = now, effect = effect })
			return effect
		end,
	}, Cast)
	table.insert(owners, owner)
	return owner, target
end

local function begin(owner, nibbles)
	local random = {
		NextInteger = function(_, low)
			return if low == 0 then nibbles or 0 else 1
		end,
		NextNumber = function(_, low)
			return if low < 0 then 0 else 1
		end,
	}
	owner.bite = Bite.new(owner, 0, 0, random)
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

local ok, result = xpcall(function()
	local entry, target = create()
	entry._startBiteRound = function() end
	entry:_land(10)
	assert(
		count(entry, vfx.Entry) == 1 and entry.legacySplashes == 0
			and #(entry.ripples or {}) == (if ripplesEnabled then 3 else 0),
		"Landing feedback changed"
	)
	assert(entry.soundsPlayed.Splash == 1 and entry.soundsPlayed.FovImpact == 1, "Landing audio changed")
	local effect = entry.events[1].effect
	near(effect.model:GetPivot().Position.Y, target.Y - Elastic.BaseSize(entry).Y * 0.15)
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
			owner.soundsPlayed.FishBite == 1 and owner.legacySplashes == 0,
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
			assert(count(owner, vfx.Exit) == 1 and count(owner, config.RarityVFX.Template) == 0, "Exit or presentation timing changed")
			local exit = owner.events[#owner.events].effect
			near(exit.model:GetPivot().Position.Y, owner:_waterTarget().Y - Elastic.BaseSize(owner).Y * 0.15)
			owner.bite:Present()
			local rarity = assert(owner.bite.rarityVFX, "Lift did not create rarity VFX")
			local center = owner.bite.fish:GetBoundingBox()
			assert((rarity.model:GetPivot().Position - center.Position).Magnitude < 0.001, "Rarity emitted from a stale fish pose")
			near(rarity.started, exit.started)
			local firstPosition = rarity.model:GetPivot().Position
			owner.bite:Present()
			owner.bite:Update(liftAt)
			owner.bite:Update(liftAt + 0.15)
			center = owner.bite.fish:GetBoundingBox()
			assert((rarity.model:GetPivot().Position - center.Position).Magnitude < 0.001, "Rarity did not follow fish center")
			assert((rarity.model:GetPivot().Position - firstPosition).Magnitude > 0.1, "Follow fixture did not move")
			assert(rarity.model:GetPivot().Rotation:FuzzyEq(rarity.rotation, 0.0001), "Rarity rotated with fish")
			assert(count(owner, vfx.Exit) == 1 and count(owner, config.RarityVFX.Template) == 1, "Exit or rarity replayed")
			owner:_updateWaterEffects(liftAt + vfx.Lifetime + 0.01)
			assert(#owner.waterVFX == 0, "Finished struggle VFX leaked")
			assert(rarity.model.Parent == nil, "Rarity VFX survived expiry")
			owner.bite:Present()
			assert(count(owner, config.RarityVFX.Template) == 1, "Expired rarity VFX restarted")
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
	local interruptedRarity = assert(skipped.bite.rarityVFX).model
	skipped.bite:Destroy()
	assert(interruptedRarity.Parent == nil, "Interrupted fish session left rarity VFX")
	skipped:Destroy()
	local expired = create()
	timeline = begin(expired, 0)
	while timeline.phase ~= "Bite" do
		timeline:Advance(timeline.endsAt)
	end
	expired.bite:Update(timeline.endsAt + 0.01)
	assert(#expired.events == 0 and not expired.soundsPlayed.FishBite, "Expired true bite replayed effects")
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

	-- 缺失资源只 warning；Common 失败后同轮不反复尝试。
	local missing = create()
	begin(missing, 0)
	missing._playRarityVFX = Cast._playRarityVFX
	assert(Cast._playWaterVFX(missing, 0, "MissingExitVFX", missing:_waterTarget()) == nil, "Missing VFX did not skip")
	local savedTemplate = config.RarityVFX.Template
	config.RarityVFX.Template = "MissingRarityVFX"
	local missingOK, missingError = pcall(function()
		missing.bite.timeline:_enter("Lifting", 10, config.Bite.LiftTime)
		missing.bite:Update(10)
		missing.bite:Update(10.01)
	end)
	config.RarityVFX.Template = savedTemplate
	assert(missingOK, missingError)
	assert(missing.bite.rarityVFXPlayed and not missing.bite.rarityVFX, "Missing rarity did not skip")
	assert(missing.warnedWaterVFX["AnimalRoller.MissingRarityVFX"], "Missing rarity did not warn")
	missing:Destroy()
	return {
		passed = true,
		cadenceCases = cadenceCases,
		delay = true,
		duration = true,
		trueBiteDeduplication = true,
		longFrames = true,
		cleanup = true,
		exitAndRarityOnce = true,
		rarityFollow = true,
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
